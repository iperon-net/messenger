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

  /// [chatID] — чат, из которого файл (id списка; см. [setChatID]).
  Future<void> create(models.DownloadState download, {String chatID = ''}) async {
    await db.execute(
      """
      INSERT INTO downloads ($_columns, chatID, accessedAt)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
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
        chatID,
        download.createdAt.millisecondsSinceEpoch,
      ],
    );
  }

  /// Чат файла ещё не известен ('' — до миграции 51, '~' — не нашёлся в
  /// сообщениях) — запомнить [chatID]. Уже привязанный не меняем.
  Future<void> setChatID({required Uint8List cdnID, required String chatID}) async {
    if (chatID.isEmpty) return;
    await db.execute("UPDATE downloads SET chatID = ? WHERE cdnID = ? AND chatID IN ('', '~');", [chatID, cdnID]);
  }

  /// Файл открыли (показали из кэша) — для автоочистки по давности. Пишем не
  /// чаще раза в час: показы из кэша частые, а запись без изменений строк
  /// подписчиков `onChange` не будит.
  Future<void> touch(Uint8List cdnID) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.execute("UPDATE downloads SET accessedAt = ? WHERE cdnID = ? AND accessedAt < ?;", [
      now,
      cdnID,
      now - const Duration(hours: 1).inMilliseconds,
    ]);
  }

  /// Все файлы кэша для «Использования памяти»: тип, чат, пути, когда
  /// открывали.
  Future<List<StoredDownload>> stored() async {
    final rows = await db.getAll("SELECT cdnID, contentType, chatID, targetPath, tmpPath, status, accessedAt FROM downloads;");
    return [
      for (final row in rows)
        StoredDownload(
          cdnID: Uint8List.fromList(row['cdnID'] as List<int>),
          contentType: row['contentType'] as String,
          chatID: row['chatID'] as String,
          targetPath: row['targetPath'] as String?,
          tmpPath: row['tmpPath'] as String,
          ready: row['status'] == models.DownloadStatus.ready.name,
          accessedAt: DateTime.fromMillisecondsSinceEpoch(row['accessedAt'] as int),
        ),
    ];
  }

  /// Привязать файлы к чатам пачкой ([setChatID] для многих): cdnID → чат.
  Future<void> setChatIDs(Map<Uint8List, String> chats) async {
    if (chats.isEmpty) return;
    await db.writeTransaction((tx) async {
      for (final MapEntry(key: cdnID, value: chatID) in chats.entries) {
        await tx.execute("UPDATE downloads SET chatID = ? WHERE cdnID = ? AND chatID IN ('', '~');", [chatID, cdnID]);
      }
    });
  }

  Future<models.DownloadState?> getByCdnID(Uint8List cdnID) async {
    final rows = await db.execute("SELECT $_columns FROM downloads WHERE cdnID = ?;", [cdnID]);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  /// Ссылка устарела (истёк токен, файл переехал) — свежая от сервера; объект
  /// тот же, прогресс докачки сохраняется.
  Future<void> setUrl({required Uint8List cdnID, required String url}) async {
    await db.execute("UPDATE downloads SET url = ? WHERE cdnID = ?;", [url, cdnID]);
  }

  Future<void> setCipherSize({required Uint8List cdnID, required int cipherSize}) async {
    await db.execute("UPDATE downloads SET cipherSize = ? WHERE cdnID = ?;", [cipherSize, cdnID]);
  }

  Future<void> setReceivedBytes({required Uint8List cdnID, required int receivedBytes}) async {
    await db.execute("UPDATE downloads SET receivedBytes = ? WHERE cdnID = ?;", [receivedBytes, cdnID]);
  }

  /// Пути файлов кэша — после переезда контейнера приложения (iOS меняет
  /// путь к нему при обновлении).
  Future<void> setPaths({required Uint8List cdnID, required String tmpPath, required String? targetPath}) async {
    await db.execute("UPDATE downloads SET tmpPath = ?, targetPath = ? WHERE cdnID = ?;", [tmpPath, targetPath, cdnID]);
  }

  Future<void> markReady({required Uint8List cdnID, required String targetPath}) async {
    await db.execute("UPDATE downloads SET status = ?, targetPath = ?, accessedAt = ? WHERE cdnID = ?;", [
      models.DownloadStatus.ready.name,
      targetPath,
      DateTime.now().millisecondsSinceEpoch,
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

/// Строка кэша скачиваний для «Использования памяти» ([Downloads.stored]).
class StoredDownload {
  final Uint8List cdnID;
  final String contentType;

  /// Чат (id списка); '' — ещё не знаем, '~' — не из сообщений.
  final String chatID;
  final String? targetPath;
  final String tmpPath;
  final bool ready;
  final DateTime accessedAt;

  const StoredDownload({
    required this.cdnID,
    required this.contentType,
    required this.chatID,
    required this.targetPath,
    required this.tmpPath,
    required this.ready,
    required this.accessedAt,
  });

  /// Файл из сообщения какого-то чата.
  bool get hasChat => chatID.isNotEmpty && chatID != '~';
}
