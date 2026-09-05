import 'dart:typed_data';

/// Локальное состояние одной загрузки файла (таблица `uploads`), достаточное
/// для докачки после обрыва соединения или перезапуска приложения — см.
/// `docs/plans/client-media-upload-stage-1-2.md`. Строка живёт от постановки
/// файла в очередь до успешного `UPLOAD_CONFIRM`, после чего удаляется.
///
/// Не dart_mappable-модель: это внутреннее техническое состояние
/// [UploadManager]/[Uploads], а не доменные данные, отображаемые в UI через
/// cubit state (copyWith/equality здесь не нужны).
class UploadState {
  final String localID;
  final String? uploadID;
  final String filePath;
  final int fileSize;
  final Uint8List fileKey;
  final Uint8List hkdfSalt;
  final Uint8List noncePrefix;
  final String folder;
  final String contentType;
  final String fileName;
  final DateTime createdAt;

  const UploadState({
    required this.localID,
    required this.uploadID,
    required this.filePath,
    required this.fileSize,
    required this.fileKey,
    required this.hkdfSalt,
    required this.noncePrefix,
    required this.folder,
    required this.contentType,
    required this.fileName,
    required this.createdAt,
  });

  UploadState copyWithUploadID(String uploadID) => UploadState(
    localID: localID,
    uploadID: uploadID,
    filePath: filePath,
    fileSize: fileSize,
    fileKey: fileKey,
    hkdfSalt: hkdfSalt,
    noncePrefix: noncePrefix,
    folder: folder,
    contentType: contentType,
    fileName: fileName,
    createdAt: createdAt,
  );
}
