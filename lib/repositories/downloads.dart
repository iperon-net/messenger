part of 'repositories.dart';

/// Реестр скачиваемых/скачанных CDN-файлов (таблица `downloads`) — держит и
/// состояние докачки ciphertext, и путь к уже расшифрованному файлу для
/// повторной отдачи из кэша (см. `docs/plans/client-media-download-stage-3.md`).
/// В отличие от [Uploads] строка живёт и после успеха.
class Downloads {
  final Logger logger;
  final SqliteDatabase db;

  Downloads({required this.logger, required this.db});

  static const _columns =
      "cdnID, url, tmpPath, targetPath, encryptionKey, hkdfSalt, contentType, hashSumEncrypted, cipherSize, receivedBytes, status, createdAt";

  models.DownloadState _fromRow(Map<String, dynamic> row) {
    return models.DownloadState(
      cdnID: Uint8List.fromList(row['cdnID'] as List<int>),
      url: row['url'] as String,
      tmpPath: row['tmpPath'] as String,
      targetPath: row['targetPath'] as String?,
      encryptionKey: Uint8List.fromList(row['encryptionKey'] as List<int>),
      hkdfSalt: Uint8List.fromList(row['hkdfSalt'] as List<int>),
      contentType: row['contentType'] as String,
      hashSumEncrypted: Uint8List.fromList(row['hashSumEncrypted'] as List<int>),
      cipherSize: row['cipherSize'] as int?,
      receivedBytes: row['receivedBytes'] as int,
      status: models.DownloadStatus.values.byName(row['status'] as String),
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
    );
  }

  Future<void> create(models.DownloadState download) async {
    await db.execute(
      """
      INSERT INTO downloads ($_columns)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
      """,
      [
        download.cdnID,
        download.url,
        download.tmpPath,
        download.targetPath,
        download.encryptionKey,
        download.hkdfSalt,
        download.contentType,
        download.hashSumEncrypted,
        download.cipherSize,
        download.receivedBytes,
        download.status.name,
        download.createdAt.millisecondsSinceEpoch,
      ],
    );
  }

  Future<models.DownloadState?> getByCdnID(Uint8List cdnID) async {
    final rows = await db.execute("SELECT $_columns FROM downloads WHERE cdnID = ?;", [cdnID]);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  Future<void> setCipherSize({required Uint8List cdnID, required int cipherSize}) async {
    await db.execute("UPDATE downloads SET cipherSize = ? WHERE cdnID = ?;", [cipherSize, cdnID]);
  }

  Future<void> setReceivedBytes({required Uint8List cdnID, required int receivedBytes}) async {
    await db.execute("UPDATE downloads SET receivedBytes = ? WHERE cdnID = ?;", [receivedBytes, cdnID]);
  }

  Future<void> markReady({required Uint8List cdnID, required String targetPath}) async {
    await db.execute("UPDATE downloads SET status = ?, targetPath = ? WHERE cdnID = ?;", [
      models.DownloadStatus.ready.name,
      targetPath,
      cdnID,
    ]);
  }

  Future<List<models.DownloadState>> getAll() async {
    final rows = await db.execute("SELECT $_columns FROM downloads;");
    return rows.map(_fromRow).toList();
  }

  Future<void> delete(Uint8List cdnID) async {
    await db.execute("DELETE FROM downloads WHERE cdnID = ?;", [cdnID]);
  }
}
