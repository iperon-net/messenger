import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'api.dart';
import 'auth.dart';
import 'crypto.dart';
import 'di.dart';
import 'logger.dart';
import 'models.dart' as models;
import 'protobuf.dart';
import 'repositories.dart';
import 'utils.dart';

/// Ошибка загрузки/подтверждения файла, не сведённая к обычному
/// [APICallStatus] (например, обрыв сырого стрима `Upload` до `CompleteAck`,
/// который на gRPC-уровне не всегда даёт осмысленный `GrpcError`).
class UploadException implements Exception {
  final String message;
  const UploadException(this.message);

  @override
  String toString() => 'UploadException: $message';
}

/// Фатальная (не-транзиентная) ошибка скачивания/расшифровки файла: сервер
/// вернул осмысленный отказ (4xx), не сошёлся хеш ciphertext или провалилась
/// AEAD-проверка при расшифровке. В отличие от сетевого обрыва повтор тут не
/// поможет, поэтому [CDNManager.download] такие ошибки не ретраит, а пробрасывает
/// сразу.
class DownloadException implements Exception {
  final String message;
  const DownloadException(this.message);

  @override
  String toString() => 'DownloadException: $message';
}

/// `CDNManager` — этапы 1+2 загрузки больших зашифрованных на клиенте
/// медиафайлов (см. `docs/plans/client-media-upload-stage-1-2.md` и, на
/// сервере, `docs/plans/breezy-uploading-courier.md` /
/// `docs/plans/shimmying-tumbling-owl.md` в репозитории `iperon`).
///
/// Намеренно отдельный класс, а не часть [API]: у `Upload` свой gRPC-метод и
/// свой жизненный цикл на файл (открывается/закрывается на каждую попытку
/// загрузки), в отличие от одного долгоживущего персистентного стрима,
/// которым управляет `API`.
///
/// Домено-нейтрален: отдаёт наружу только `CDN` (`cdn_id`/`url`/обёрнутый
/// ключ) — привязку к конкретной сущности (аватарка, вложение в чат и т.п.)
/// делает вызывающий код, когда такая сущность появится (см. "Заметки на
/// будущее" в `shimmying-tumbling-owl.md`).
class CDNManager {
  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final crypto = getIt.get<Crypto>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();
  final utils = getIt.get<Utils>();

  /// Максимум подряд идущих попыток переоткрыть стрим `Upload` **без прогресса**
  /// (оффсет докачки не сдвинулся), прежде чем пробросить ошибку вызывающему
  /// коду. Попытки, в которых оффсет вырос, счётчик сбрасывают — заливка,
  /// которую сеть/прокси рвёт регулярно, но которая каждый раз продвигается,
  /// дойдёт до конца перезапусками стрима (см. [uploadFile]). У скачивания
  /// [download] тот же лимит применяется как обычное число сетевых ретраев.
  static const int _maxStreamAttempts = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  /// Число автоматических повторов `UPLOAD_CONFIRM` при транзиентном обрыве
  /// соединения — сервер temp-файл не трогает до успешного confirm (см.
  /// `shimmying-tumbling-owl.md`), поэтому повтор безопасен и не требует
  /// повторной заливки файла.
  static const int _maxConfirmAttempts = 3;

  /// gRPC-коды, при которых имеет смысл повторить `UPLOAD_CONFIRM` — обрыв
  /// соединения/таймаут, а не осмысленный отказ сервера (тот же confirm с теми
  /// же данными не станет валиднее от повтора, например `InvalidArgument`,
  /// `NotFound`, `PermissionDenied`).
  static const Set<int> _transientStatusCodes = {StatusCode.unavailable, StatusCode.unknown, StatusCode.deadlineExceeded};

  /// Шифрует [file] на клиенте, заливает с докачкой (этап 1) и подтверждает
  /// загрузку (этап 2). Резюмирует уже поставленную в очередь, но не
  /// подтверждённую загрузку того же [file.path] — при повторном вызове (тот
  /// же локальный файл) новые `fileKey`/`hkdfSalt` не генерируются.
  ///
  /// [onProgress] — необязательный колбэк (уже посланные/подтверждённые
  /// сервером байты шифротекста, полный размер шифротекста) для UI-прогресса.
  /// Пишет [bytes] во временный файл и заливает его через [uploadFile] — для
  /// вызывающего кода, у которого данные уже в памяти (обрезанный аватар и
  /// т.п.), а не на диске. Расширение [extension] (без точки) идёт в имя temp-
  /// файла.
  Future<models.CDN> uploadBytes({
    required Uint8List bytes,
    required String folder,
    required String contentType,
    String extension = 'bin',
    void Function(int sentBytes, int totalBytes)? onProgress,
  }) async {
    final tmpFile = await File(
      p.join(Directory.systemTemp.path, 'upload_${DateTime.now().millisecondsSinceEpoch}.$extension'),
    ).writeAsBytes(bytes, flush: true);

    try {
      return await uploadFile(file: tmpFile, folder: folder, contentType: contentType, onProgress: onProgress);
    } finally {
      // Temp-файл нужен только на время заливки (uploadFile читает его с диска
      // при докачке), поэтому чистим и после успеха, и после ошибки.
      try {
        await tmpFile.delete();
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
  }

  Future<models.CDN> uploadFile({
    required File file,
    required String folder,
    required String contentType,
    void Function(int sentBytes, int totalBytes)? onProgress,
  }) async {
    var state = await _resolveUploadState(file: file, folder: folder, contentType: contentType);

    // Считаем не общее число попыток, а число подряд идущих попыток БЕЗ
    // прогресса: некоторые сети/прокси рвут стрим `Upload` регулярно (например,
    // лимит на стриминговый body каждые ~N КБ), но докачка при этом каждый раз
    // продвигается вперёд. Пока оффсет растёт — продолжаем (заливка дойдёт до
    // конца перезапусками стрима); сдаёмся, только если стрим падает
    // [_maxStreamAttempts] раз подряд, не сдвинув оффсет ни на байт.
    var maxReceived = 0;
    var stalledAttempts = 0;

    for (;;) {
      final receivedBefore = maxReceived;
      try {
        state = await _runUploadStream(
          state,
          onProgress: (sentBytes, totalBytes) {
            if (sentBytes > maxReceived) maxReceived = sentBytes;
            onProgress?.call(sentBytes, totalBytes);
          },
        );
        break;
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);

        if (maxReceived > receivedBefore) {
          // Стрим оборвался, но докачка продвинулась — обрыв не считаем
          // «застреванием», сбрасываем счётчик и продолжаем.
          stalledAttempts = 0;
        } else {
          stalledAttempts++;
          if (stalledAttempts >= _maxStreamAttempts) {
            rethrow;
          }
        }

        await Future.delayed(_retryDelay * (stalledAttempts + 1));

        // Между попытками мог сохраниться uploadID (первая попытка успела
        // получить InitAck перед обрывом) — перечитываем состояние, чтобы
        // докачка стартовала не с нуля.
        final reloaded = await repositories.uploads.getByLocalID(state.localID);
        if (reloaded == null) {
          throw const UploadException('upload: local state disappeared between retries');
        }
        state = reloaded;
      }
    }

    final cdn = await _confirm(state);

    // Plaintext уже лежит на устройстве — засеиваем им media-кэш, чтобы
    // последующий download(cdn) для только что залитого файла (аватарка и т.п.)
    // был cache-hit без сети и без расшифровки.
    await _seedDownloadCache(file: file, cdn: cdn);

    return cdn;
  }

  /// Кладёт plaintext только что залитого [file] в media-кэш как готовый
  /// результат скачивания [cdn] (строка `downloads` со статусом `ready`).
  /// Best-effort: ошибка кэширования не должна валить успешный аплоад, поэтому
  /// глотается в лог.
  Future<void> _seedDownloadCache({required File file, required models.CDN cdn}) async {
    try {
      if (await repositories.downloads.getByCdnID(cdn.cdnID) != null) {
        return;
      }

      final target = File(await _targetPath(cdn));
      await file.copy(target.path);

      final cdnHex = utils.bytesToHex(cdn.cdnID);
      final mediaDir = await _mediaDir();
      final plaintextSize = await file.length();

      await repositories.downloads.create(
        models.DownloadState(
          cdnID: cdn.cdnID,
          url: cdn.url,
          // Времянник ciphertext для сида не нужен, но путь держим консистентным
          // с download-флоу — вдруг файл кэша потом удалят и потребуется перекачка.
          tmpPath: p.join(mediaDir.path, '.part', '$cdnHex.part'),
          targetPath: target.path,
          encryptionKey: cdn.encryptionKey,
          hkdfSalt: cdn.hkdfSalt,
          contentType: cdn.contentType,
          hashSumEncrypted: cdn.hashSumEncrypted,
          // Полный размер ciphertext известен и без сети — чтобы cache-hit
          // отдавал корректный total в onProgress.
          cipherSize: crypto.fileEncryptor.totalCipherSize(plaintextSize),
          receivedBytes: 0,
          status: models.DownloadStatus.ready,
          createdAt: DateTime.now(),
        ),
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  Future<models.UploadState> _resolveUploadState({required File file, required String folder, required String contentType}) async {
    final existing = await repositories.uploads.getByFilePath(file.path);
    if (existing != null) {
      return existing;
    }

    final fileSize = await file.length();

    final state = models.UploadState(
      localID: randomBytesAsHexString(16),
      uploadID: null,
      filePath: file.path,
      fileSize: fileSize,
      fileKey: Uint8List.fromList(crypto.fileEncryptor.generateFileKey()),
      hkdfSalt: Uint8List.fromList(crypto.fileEncryptor.generateHkdfSalt()),
      folder: folder,
      contentType: contentType,
      createdAt: DateTime.now(),
    );

    await repositories.uploads.create(state);
    return state;
  }

  /// Один проход по сырому bidi-стриму `Upload`: `Init` (новая загрузка или
  /// докачка по `state.uploadID`) → чанки → `Done`. Кидает исключение при
  /// любом обрыве до `CompleteAck` — вызывающий код (см. [uploadFile]) решает,
  /// переоткрывать стрим или нет; сама функция стрим не переоткрывает.
  Future<models.UploadState> _runUploadStream(models.UploadState state, {void Function(int sentBytes, int totalBytes)? onProgress}) async {
    final outgoing = StreamController<Upload_Request>();
    final responses = StreamIterator(api.uploadClient.upload(outgoing.stream));
    var completedCleanly = false;

    try {
      final sessionIDHex = utils.bytesToHex(Uint8List.fromList(auth.session.session));

      outgoing.add(
        Upload_Request(
          init: Upload_Init(
            sessionId: sessionIDHex,
            // Сервер меряет байты потока (шифротекст), а не plaintext —
            // state.fileSize исходного файла тут занизит лимит на 16 байт
            // (AEAD-тег) на каждый чанк и ChunkAck на последнем чанке
            // отклонится как "upload size exceeded".
            fileSize: Int64(crypto.fileEncryptor.totalCipherSize(state.fileSize)),
            resumeUploadId: state.uploadID,
          ),
        ),
      );

      if (!await responses.moveNext()) {
        throw const UploadException('upload: stream closed before InitAck');
      }

      final initAck = responses.current.initAck;

      var uploadState = state;
      if (uploadState.uploadID == null) {
        await repositories.uploads.setUploadID(localID: uploadState.localID, uploadID: initAck.uploadId);
        uploadState = uploadState.copyWithUploadID(initAck.uploadId);
      }

      var sentBytes = initAck.receivedBytes.toInt();
      onProgress?.call(sentBytes, uploadState.fileSize);

      final startChunkIndex = crypto.fileEncryptor.chunkIndexForReceivedBytes(uploadState.fileSize, sentBytes);

      final chunks = crypto.fileEncryptor.encryptFile(
        file: File(uploadState.filePath),
        fileKey: uploadState.fileKey,
        hkdfSalt: uploadState.hkdfSalt,
        startChunkIndex: startChunkIndex,
      );

      // Строго последовательно: следующий чанк уходит только после ack на
      // предыдущий (сервер пайплайнинг не поддерживает, см. серверный план).
      await for (final cipherChunk in chunks) {
        outgoing.add(Upload_Request(chunk: Upload_Chunk(data: cipherChunk)));

        if (!await responses.moveNext()) {
          throw const UploadException('upload: stream closed mid-chunk');
        }

        sentBytes = responses.current.chunkAck.receivedBytes.toInt();
        onProgress?.call(sentBytes, uploadState.fileSize);
      }

      outgoing.add(Upload_Request(done: Upload_Done()));

      if (!await responses.moveNext()) {
        throw const UploadException('upload: stream closed before CompleteAck');
      }
      // completeAck.receivedBytes == fileSize уже проверен сервером
      // (иначе стрим завершился бы ошибкой InvalidArgument) — дублировать
      // проверку на клиенте незачем.

      completedCleanly = true;
      return uploadState;
    } finally {
      await outgoing.close();

      // cancel() шлёт RST_STREAM — уместно только если стрим прервали сами
      // (исключение выше). Звать его и после штатного CompleteAck (сервер уже
      // сам закрыл стрим) — попытка отменить то, что уже полностью завершено
      // по HTTP/2, что как минимум одна реализация трактует как protocol
      // error и рвёт всё gRPC-соединение целиком (включая персистентный
      // Stream API) — именно это било по последующему UPLOAD_CONFIRM.
      if (!completedCleanly) {
        await responses.cancel();
      }
    }
  }

  Future<models.CDN> _confirm(models.UploadState state) async {
    final uploadID = state.uploadID;
    if (uploadID == null) {
      throw const UploadException('upload: confirm called before InitAck ever succeeded');
    }

    final request = UploadConfirm_Request(
      uploadId: uploadID,
      encryptionKey: state.fileKey,
      hkdfSalt: state.hkdfSalt,
      contentType: state.contentType,
      folder: state.folder,
    );
    final payload = request.writeToBuffer();

    for (var attempt = 1; ; attempt++) {
      final (status, response) = await api.unaryEncodedWithResponse(MessageType.UPLOAD_CONFIRM, payload);

      if (status.status == APIStatus.success && response != null) {
        final cdn = models.CDN.fromProto(UploadConfirm_Response.fromBuffer(response).cdn);
        await repositories.uploads.delete(state.localID);
        return cdn;
      }

      // Temp-файл на сервере не тронут (см. shimmying-tumbling-owl.md) —
      // локальную строку не удаляем в любом случае, чтобы вызывающий код мог
      // повторить именно confirm (без повторной заливки файла) даже после
      // исчерпания автоматических попыток здесь.
      final retryable = status.isGrpc && _transientStatusCodes.contains(status.statusCode);
      if (!retryable || attempt >= _maxConfirmAttempts) {
        throw UploadException('upload: confirm failed: $status');
      }

      logger.debug('upload: confirm attempt $attempt failed ($status), retrying');
      await Future.delayed(_retryDelay * attempt);
    }
  }

  // --- Скачивание (этап 3) --------------------------------------------------

  /// Как часто (в байтах ciphertext) сбрасывать прогресс докачки в БД: слишком
  /// часто — лишние записи на каждый сетевой чанк, слишком редко — при обрыве
  /// докачаем меньше. 1 MiB — разумный компромисс.
  static const int _downloadPersistInterval = 1024 * 1024;

  /// Активные (ещё не завершённые) закачки по `cdnID` (hex) — дедупликация
  /// одновременных [download] одного и того же файла. Один и тот же аватар при
  /// открытии профиля качают сразу два независимых потребителя стрима: слушатель
  /// `ProfileCubit` (для показа) и `API._handleMessage` (для персиста в БД). Без
  /// дедупликации оба доходят до [_resolveDownloadState] с пустой строкой и оба
  /// делают `INSERT` в `downloads` (PK = `cdnID`) — второй падает на UNIQUE, и
  /// `_handleMessage` не успевает привязать `avatarCdnID` к профилю, из-за чего
  /// cache-hit при следующем открытии больше никогда не срабатывает (аватар
  /// каждый раз тянется по сети заново). Разделяя один `Future`, оба получают
  /// один и тот же результат без гонки и без двойной сетевой закачки.
  final Map<String, Future<File>> _inFlightDownloads = {};

  /// Скачивает ciphertext файла [cdn] с CDN (докачка после обрыва + сетевые
  /// ретраи), проверяет целостность по `hashSumEncrypted`, расшифровывает
  /// локально ([Crypto.fileEncryptor]) и возвращает файл plaintext в кэше
  /// приложения (`<cache>/media/<cdnID>`). Повторный вызов для уже скачанного
  /// [cdn] отдаёт файл из кэша без сети.
  ///
  /// Одновременные вызовы для одного [cdn] дедуплицируются ([_inFlightDownloads]):
  /// разделяют один сетевой проход и один результат. Прогресс при этом получает
  /// только первый вызвавший (его [onProgress]); остальным вернётся готовый файл.
  ///
  /// [onProgress] — необязательный колбэк (скачанные/полные **байты
  /// ciphertext**), симметрично `onProgress` аплоада; фаза расшифровки прогресс
  /// не двигает.
  ///
  /// Бросает [DownloadException] при фатальной ошибке (отказ сервера, битый хеш,
  /// провал расшифровки); сетевые обрывы обрабатывает докачкой и ретраями.
  Future<File> download({required models.CDN cdn, void Function(int receivedBytes, int totalBytes)? onProgress}) async {
    final key = utils.bytesToHex(cdn.cdnID);
    final existing = _inFlightDownloads[key];
    if (existing != null) return existing;

    final future = _download(cdn: cdn, onProgress: onProgress);
    _inFlightDownloads[key] = future;
    try {
      return await future;
    } finally {
      _inFlightDownloads.remove(key);
    }
  }

  Future<File> _download({required models.CDN cdn, void Function(int receivedBytes, int totalBytes)? onProgress}) async {
    var state = await _resolveDownloadState(cdn);

    // Cache-hit: файл уже скачан и расшифрован.
    if (state.status == models.DownloadStatus.ready && state.targetPath != null) {
      final ready = File(state.targetPath!);
      if (await ready.exists()) {
        final size = state.cipherSize ?? 0;
        onProgress?.call(size, size);
        return ready;
      }
      // Расшифрованный файл кто-то удалил — качаем заново с нуля.
      await repositories.downloads.delete(cdn.cdnID);
      state = await _resolveDownloadState(cdn);
    }

    // 1. Закачка ciphertext с докачкой; сетевые обрывы — ретраим.
    for (var attempt = 1; ; attempt++) {
      try {
        await _runDownloadPass(state, onProgress: onProgress);
        break;
      } catch (error, stackTrace) {
        if (error is DownloadException) rethrow;

        logger.handle(error, stackTrace);
        if (attempt >= _maxStreamAttempts) {
          throw DownloadException('download: network failure after $attempt attempts: $error');
        }

        await Future.delayed(_retryDelay * attempt);

        final reloaded = await repositories.downloads.getByCdnID(cdn.cdnID);
        if (reloaded == null) {
          throw const DownloadException('download: local state disappeared between retries');
        }
        state = reloaded;
      }
    }

    // 2. Целостность ciphertext (URL сам по себе бесполезен без ключа, но хеш
    //    ловит порчу при передаче/хранении до расшифровки).
    final tmp = File(state.tmpPath);
    await _verifyHash(tmp, cdn.hashSumEncrypted);

    // 3. Расшифровка на диск.
    final target = File(await _targetPath(cdn));
    try {
      await crypto.fileEncryptor.decryptFile(cipherFile: tmp, outFile: target, fileKey: cdn.encryptionKey, hkdfSalt: cdn.hkdfSalt);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      throw DownloadException('download: decryption failed: $error');
    }

    // 4. Финал: времянник больше не нужен, строка остаётся реестром кэша.
    try {
      await tmp.delete();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
    await repositories.downloads.markReady(cdnID: cdn.cdnID, targetPath: target.path);

    return target;
  }

  /// Отдаёт уже скачанный и расшифрованный файл [cdnID] из media-кэша, если он
  /// там есть и лежит на диске (cache-hit **без сети**). Иначе `null` — в
  /// отличие от [download] сюда не ходит в сеть и ничего не качает, поэтому
  /// годится для «показать, если уже есть» (аватар из локального профиля и т.п.).
  Future<File?> cachedFile(Uint8List cdnID) async {
    final state = await repositories.downloads.getByCdnID(cdnID);
    if (state == null || state.status != models.DownloadStatus.ready || state.targetPath == null) {
      return null;
    }
    final file = File(state.targetPath!);
    return await file.exists() ? file : null;
  }

  Future<models.DownloadState> _resolveDownloadState(models.CDN cdn) async {
    final existing = await repositories.downloads.getByCdnID(cdn.cdnID);
    if (existing != null) {
      return existing;
    }

    final cdnHex = utils.bytesToHex(cdn.cdnID);
    final mediaDir = await _mediaDir();
    final tmpPath = p.join(mediaDir.path, '.part', '$cdnHex.part');
    await Directory(p.dirname(tmpPath)).create(recursive: true);

    final state = models.DownloadState(
      cdnID: cdn.cdnID,
      url: cdn.url,
      tmpPath: tmpPath,
      targetPath: null,
      encryptionKey: cdn.encryptionKey,
      hkdfSalt: cdn.hkdfSalt,
      contentType: cdn.contentType,
      hashSumEncrypted: cdn.hashSumEncrypted,
      cipherSize: null,
      receivedBytes: 0,
      status: models.DownloadStatus.downloading,
      createdAt: DateTime.now(),
    );

    await repositories.downloads.create(state);
    return state;
  }

  /// Один проход закачки ciphertext в `state.tmpPath`. Стартовый оффсет берём из
  /// фактической длины времянника (устойчиво к рассинхрону БД/диска после
  /// обрыва), докачиваем через `Range`. Сетевые обрывы пробрасывает как обычные
  /// исключения (не [DownloadException]) — их ретраит [download]; осмысленный
  /// отказ сервера (4xx) — как [DownloadException] (ретрай бесполезен).
  Future<void> _runDownloadPass(models.DownloadState state, {void Function(int receivedBytes, int totalBytes)? onProgress}) async {
    final tmp = File(state.tmpPath);
    var received = await tmp.exists() ? await tmp.length() : 0;

    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(state.url));
      if (received > 0) {
        request.headers.add(HttpHeaders.rangeHeader, 'bytes=$received-');
      }
      final response = await request.close();

      int? total;
      IOSink sink;
      switch (response.statusCode) {
        case HttpStatus.partialContent:
          total = response.contentLength >= 0 ? received + response.contentLength : null;
          sink = tmp.openWrite(mode: FileMode.append);
        case HttpStatus.ok:
          // Сервер проигнорировал Range и отдаёт файл целиком — пишем с нуля.
          received = 0;
          total = response.contentLength >= 0 ? response.contentLength : null;
          sink = tmp.openWrite(mode: FileMode.write);
        default:
          if (response.statusCode >= 500) {
            // 5xx — транзиентно, пусть ретраит download.
            throw HttpException('download: server error ${response.statusCode}', uri: Uri.parse(state.url));
          }
          throw DownloadException('download: unexpected HTTP status ${response.statusCode}');
      }

      if (total != null) {
        await repositories.downloads.setCipherSize(cdnID: state.cdnID, cipherSize: total);
      }
      onProgress?.call(received, total ?? received);

      var sincePersist = 0;
      try {
        await for (final chunk in response) {
          sink.add(chunk);
          received += chunk.length;
          sincePersist += chunk.length;
          if (sincePersist >= _downloadPersistInterval) {
            await sink.flush();
            await repositories.downloads.setReceivedBytes(cdnID: state.cdnID, receivedBytes: received);
            sincePersist = 0;
          }
          onProgress?.call(received, total ?? received);
        }
      } finally {
        await sink.close();
      }

      await repositories.downloads.setReceivedBytes(cdnID: state.cdnID, receivedBytes: received);

      if (total != null && received != total) {
        // Поток закрылся чисто, но короче обещанного — не финальная ошибка,
        // докачаем на следующем проходе (не DownloadException → ретраится).
        throw HttpException('download: incomplete stream ($received/$total bytes)', uri: Uri.parse(state.url));
      }
    } finally {
      client.close();
    }
  }

  /// Стриминговый sha256 по ciphertext-времяннику — сверяем с `hashSumEncrypted`
  /// из `CDN`, не держа файл в памяти целиком.
  Future<void> _verifyHash(File file, Uint8List expected) async {
    final sink = Sha256().newHashSink();
    await for (final chunk in file.openRead()) {
      sink.add(chunk);
    }
    sink.close();
    final hash = await sink.hash();

    if (!_bytesEqual(hash.bytes, expected)) {
      throw const DownloadException('download: ciphertext hash mismatch');
    }
  }

  bool _bytesEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<Directory> _mediaDir() async {
    final cache = await getApplicationCacheDirectory();
    final dir = Directory(p.join(cache.path, 'media'));
    await dir.create(recursive: true);
    return dir;
  }

  Future<String> _targetPath(models.CDN cdn) async {
    final mediaDir = await _mediaDir();
    final cdnHex = utils.bytesToHex(cdn.cdnID);
    return p.join(mediaDir.path, '$cdnHex${_extensionForContentType(cdn.contentType)}');
  }

  /// Расширение файла (с точкой) по MIME contentType — чтобы системные
  /// вьюеры/шаринг узнавали тип. Неизвестный тип → без расширения.
  String _extensionForContentType(String contentType) {
    switch (contentType.split(';').first.trim().toLowerCase()) {
      case 'image/jpeg':
        return '.jpg';
      case 'image/png':
        return '.png';
      case 'image/gif':
        return '.gif';
      case 'image/webp':
        return '.webp';
      case 'image/heic':
        return '.heic';
      case 'video/mp4':
        return '.mp4';
      case 'video/quicktime':
        return '.mov';
      case 'audio/mpeg':
        return '.mp3';
      case 'audio/aac':
        return '.aac';
      case 'application/pdf':
        return '.pdf';
      default:
        return '';
    }
  }
}
