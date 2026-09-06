part of 'repositories.dart';

/// Хранит [models.UploadState] для докачки после обрыва соединения или
/// перезапуска приложения (см. `docs/plans/client-media-upload-stage-1-2.md`).
/// Строка живёт от постановки файла в очередь до успешного `UPLOAD_CONFIRM`.
class Cdn {
  final Logger logger;
  final SqliteDatabase db;

  Cdn({required this.logger, required this.db});

  static const _columns = "localID, uploadID, filePath, fileSize, fileKey, hkdfSalt, noncePrefix, folder, contentType, createdAt";

  models.UploadState _fromRow(Map<String, dynamic> row) {
    return models.UploadState(
      localID: row['localID'] as String,
      uploadID: row['uploadID'] as String?,
      filePath: row['filePath'] as String,
      fileSize: row['fileSize'] as int,
      fileKey: Uint8List.fromList(row['fileKey'] as List<int>),
      hkdfSalt: Uint8List.fromList(row['hkdfSalt'] as List<int>),
      noncePrefix: Uint8List.fromList(row['noncePrefix'] as List<int>),
      folder: row['folder'] as String,
      contentType: row['contentType'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
    );
  }

  Future<void> create(models.UploadState upload) async {
    await db.execute(
      """
      INSERT INTO cdn ($_columns)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      """,
      [
        upload.localID,
        upload.uploadID,
        upload.filePath,
        upload.fileSize,
        upload.fileKey,
        upload.hkdfSalt,
        upload.noncePrefix,
        upload.folder,
        upload.contentType,
        upload.createdAt.millisecondsSinceEpoch,
      ],
    );
  }

  Future<void> setUploadID({required String localID, required String uploadID}) async {
    await db.execute("UPDATE cdn SET uploadID = ? WHERE localID = ?;", [uploadID, localID]);
  }

  Future<models.UploadState?> getByLocalID(String localID) async {
    final rows = await db.execute("SELECT $_columns FROM cdn WHERE localID = ?;", [localID]);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  /// Незавершённая загрузка того же локального файла — переиспользуется вместо
  /// генерации нового `fileKey`/`hkdfSalt`, если она ещё не подтверждена.
  Future<models.UploadState?> getByFilePath(String filePath) async {
    final rows = await db.execute("SELECT $_columns FROM cdn WHERE filePath = ? LIMIT 1;", [filePath]);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  Future<List<models.UploadState>> getAllPending() async {
    final rows = await db.execute("SELECT $_columns FROM cdn;");
    return rows.map(_fromRow).toList();
  }

  Future<void> delete(String localID) async {
    await db.execute("DELETE FROM cdn WHERE localID = ?;", [localID]);
  }
}
