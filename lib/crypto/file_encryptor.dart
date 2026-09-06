part of 'crypto.dart';

/// Overhead AES-GCM добавляет к каждому чанку (16-байтовый тег аутентификации).
const int _fileEncryptorTagSize = 16;

/// Потоковая (chunked) AEAD-схема шифрования файлов на клиенте — см.
/// `docs/plans/client-media-upload-stage-1-2.md`. Файл может быть гигабайтным,
/// поэтому весь plaintext/ciphertext в памяти не держим: читаем и шифруем по
/// одному чанку фиксированного размера за раз.
///
/// В отличие от [Syncer] (одноразовый AES-GCM над всем сообщением сессионного
/// конверта), это не подходит для больших файлов и докачки — здесь нужна
/// возможность детерминированно восстановить шифротекст любого чанка по его
/// индексу (тот же fileKey/hkdfSalt/noncePrefix → тот же ciphertext), чтобы при
/// обрыве соединения можно было продолжить ровно с чанка, который сервер ещё не
/// подтвердил, а не шифровать файл заново.
///
/// Nonce-схема (STREAM-конструкция, см. план): 8 случайных байт-префикс на
/// файл + 4-байтовый big-endian номер чанка = 12 байт, как того ждёт
/// `AesGcm.with256bits()`. У последнего чанка инвертирован старший бит
/// счётчика — это защита от усечения потока (получатель на этапе 3 обязан
/// проверить бит финального чанка, иначе конец файла можно молча обрезать).
class FileEncryptor {
  final Logger logger;

  /// Размер plaintext-чанка. По умолчанию 256 KiB — совпадает с сетевым
  /// чанком `Upload.Chunk.data` (см. [UploadManager]), лишней прослойки нет.
  /// Параметризован (а не константа) ради быстрых юнит-тестов на маленьких
  /// файлах.
  final int chunkSize;

  FileEncryptor({required this.logger, this.chunkSize = 256 * 1024});

  final algorithmAesGcm = AesGcm.with256bits();
  final algorithmHkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

  static final List<int> _hkdfInfo = utf8.encode('iperon-media-file-v1');

  /// Ключ файла — генерируется один раз на файл, уходит в
  /// `UploadConfirm.Request.encryptionKey` (сервер заворачивает его своим
  /// ключом при подтверждении, plaintext-ключ на сервер не попадает).
  List<int> generateFileKey() => randomBytes(32);

  /// HKDF-соль файла — уходит в `UploadConfirm.Request.hkdfSalt`.
  List<int> generateHkdfSalt() => randomBytes(32);

  /// 8-байтовый nonce-префикс — хранится только локально (таблица `cdn`),
  /// на сервер не передаётся (сервер ciphertext не расшифровывает).
  List<int> generateNoncePrefix() => randomBytes(8);

  /// Сколько чанков займёт файл размера [fileLength] при текущем [chunkSize].
  /// Пустой файл (0 байт) — тоже один (пустой) чанк, а не ноль: серверу всё
  /// равно нужен один `Upload.Chunk`/финальный AEAD-фрейм для целостности.
  int totalChunks(int fileLength) {
    if (fileLength == 0) return 1;
    return (fileLength / chunkSize).ceil();
  }

  /// Итоговый размер шифротекста для файла [fileLength] байт — то, что нужно
  /// заявлять в `Upload.Init.fileSize` (сервер меряет байты потока, а не
  /// plaintext). Каждый чанк даёт ровно [_fileEncryptorTagSize] байт
  /// оверхеда, независимо от того, полный он или последний укороченный.
  int totalCipherSize(int fileLength) => fileLength + totalChunks(fileLength) * _fileEncryptorTagSize;

  int _plainSizeOf(int chunkIndex, int fileLength) {
    final remaining = fileLength - chunkIndex * chunkSize;
    return remaining < chunkSize ? remaining : chunkSize;
  }

  /// Индекс чанка, с которого нужно продолжить шифрование/отправку, если
  /// сервер уже подтвердил [receivedBytes] байт шифротекста (см.
  /// `Upload.InitAck`/`Upload.ChunkAck` на этапе 1). Не через простое деление
  /// на размер шифро-чанка: последний чанк файла обычно короче остальных, и
  /// деление даёт неверный индекс, если докачка возобновляется ровно на нём.
  /// Возвращает [totalChunks] (не последний валидный индекс), если все чанки
  /// уже приняты и остаётся только отправить `Upload.Done`.
  int chunkIndexForReceivedBytes(int fileLength, int receivedBytes) {
    final chunks = totalChunks(fileLength);

    var offset = 0;
    for (var index = 0; index < chunks; index++) {
      final cipherSize = _plainSizeOf(index, fileLength) + _fileEncryptorTagSize;
      if (offset + cipherSize > receivedBytes) {
        return index;
      }
      offset += cipherSize;
    }

    return chunks;
  }

  List<int> _nonceFor(List<int> noncePrefix, int chunkIndex, {required bool isFinal}) {
    var counter = chunkIndex;
    if (isFinal) {
      counter |= 0x80000000;
    }

    final counterBytes = ByteData(4)..setUint32(0, counter, Endian.big);
    return [...noncePrefix, ...counterBytes.buffer.asUint8List()];
  }

  /// Шифрует [file] чанками, начиная с [startChunkIndex] (см.
  /// [chunkIndexForReceivedBytes] — для докачки после обрыва), и отдаёт готовые
  /// к отправке шифро-чанки (`ciphertext + tag`) по одному. Детерминированно:
  /// один и тот же [fileKey]/[hkdfSalt]/[noncePrefix] всегда дают один и тот же
  /// ciphertext на том же индексе чанка.
  Stream<Uint8List> encryptFile({
    required File file,
    required List<int> fileKey,
    required List<int> hkdfSalt,
    required List<int> noncePrefix,
    int startChunkIndex = 0,
  }) async* {
    final chunkKey = await algorithmHkdf.deriveKey(secretKey: SecretKey(fileKey), nonce: hkdfSalt, info: _hkdfInfo);

    final fileLength = await file.length();
    final chunks = totalChunks(fileLength);

    final raf = await file.open();
    try {
      await raf.setPosition(startChunkIndex * chunkSize);

      for (var index = startChunkIndex; index < chunks; index++) {
        final plainSize = _plainSizeOf(index, fileLength);
        final plainChunk = await raf.read(plainSize);
        final isFinal = index == chunks - 1;

        final secretBox = await algorithmAesGcm.encrypt(
          plainChunk,
          secretKey: chunkKey,
          nonce: _nonceFor(noncePrefix, index, isFinal: isFinal),
        );

        yield Uint8List.fromList(secretBox.concatenation(nonce: false));
      }
    } finally {
      await raf.close();
    }
  }
}
