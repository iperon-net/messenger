import 'dart:typed_data';

/// Статус строки в таблице `downloads`.
enum DownloadStatus {
  /// Ciphertext ещё качается (или закачан, но не расшифрован).
  downloading,

  /// Файл скачан, проверен и расшифрован — [DownloadState.targetPath] готов.
  ready,
}

/// Локальное состояние одного скачивания файла (таблица `downloads`) —
/// одновременно реестр кэша расшифрованных медиа и данные для докачки
/// ciphertext после обрыва соединения/перезапуска приложения (см.
/// `docs/plans/client-media-download-stage-3.md`).
///
/// В отличие от [UploadState] строка **не удаляется** после успеха: она держит
/// путь к расшифрованному файлу ([targetPath]) и позволяет отдать кэш повторно
/// без новой закачки. Не dart_mappable-модель: это внутреннее техническое
/// состояние [CDNManager], а не доменные данные для UI.
class DownloadState {
  /// `CDN.cdnID` — первичный ключ.
  final Uint8List cdnID;
  final String url;

  /// Путь к скачиваемому ciphertext-времяннику (дописывается при докачке,
  /// удаляется после расшифровки).
  final String tmpPath;

  /// Путь к расшифрованному файлу — `null`, пока не готов (`status != ready`).
  final String? targetPath;

  final Uint8List encryptionKey;
  final Uint8List hkdfSalt;
  final String contentType;

  /// sha256 ciphertext (`CDN.hashSumEncrypted`) — для проверки целостности
  /// скачанного до расшифровки.
  final Uint8List hashSumEncrypted;

  /// Полный размер ciphertext (HTTP `Content-Length`) — `null`, пока не пришёл
  /// первый ответ сервера.
  final int? cipherSize;

  /// Сколько байт ciphertext уже на диске (оффсет докачки).
  final int receivedBytes;

  final DownloadStatus status;
  final DateTime createdAt;

  const DownloadState({
    required this.cdnID,
    required this.url,
    required this.tmpPath,
    required this.targetPath,
    required this.encryptionKey,
    required this.hkdfSalt,
    required this.contentType,
    required this.hashSumEncrypted,
    required this.cipherSize,
    required this.receivedBytes,
    required this.status,
    required this.createdAt,
  });
}
