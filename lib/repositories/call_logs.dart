part of 'repositories.dart';

/// Локальный журнал звонков (таблица `callLogs`). Наполняется при завершении
/// каждого звонка из сервиса `Calls` (сервер историю не хранит) и читается
/// вкладкой «Звонки» (`CallsCubit`). Строки упорядочены по времени завершения.
/// Всё — по аккаунту [ownerID] (миграция 41): на одном устройстве журналы
/// разных аккаунтов не смешиваются.
class CallLogs {
  final Logger logger;
  final SqliteDatabase db;

  CallLogs({required this.logger, required this.db});

  static const table = 'callLogs';

  /// Добавляет запись о завершённом звонке. Звонок с тем же callID уже есть
  /// (успело прийти служебное сообщение «звонок» с сервера) — не дублируем.
  Future<void> insert({required List<int> ownerID, required models.CallLog log}) async {
    await db.execute(
      """
      INSERT INTO callLogs
        (callID, ownerID, userID, displayName, direction, video, missed, durationSeconds, createdAt)
      SELECT ?1, ?2, ?, ?, ?, ?, ?, ?, ?
      WHERE ?1 = '' OR NOT EXISTS (SELECT 1 FROM callLogs WHERE ownerID = ?2 AND callID = ?1);
      """,
      [
        log.callID,
        ownerID,
        log.userID,
        log.displayName,
        log.direction.name,
        log.video ? 1 : 0,
        log.missed ? 1 : 0,
        log.durationSeconds,
        log.createdAt.millisecondsSinceEpoch,
      ],
    );
  }

  /// Все звонки, новые сверху. [limit] ограничивает выборку — журнал локальный
  /// и большего показывать смысла нет.
  Future<List<models.CallLog>> getAll({required List<int> ownerID, int limit = 500}) async {
    final rows = await db.execute("SELECT * FROM callLogs WHERE ownerID = ? AND hidden = 0 ORDER BY createdAt DESC LIMIT ?;", [
      ownerID,
      limit,
    ]);
    return rows.map((row) => models.CallLogMapper.fromMap(row)).toList();
  }

  /// Удаляет одну запись по локальному id (скрывает — см. миграцию 20).
  Future<void> deleteByID(int id) async {
    await db.execute("UPDATE callLogs SET hidden = 1 WHERE id = ?;", [id]);
  }

  /// Очищает весь журнал аккаунта.
  Future<void> deleteAll({required List<int> ownerID}) async {
    await db.execute("UPDATE callLogs SET hidden = 1 WHERE ownerID = ?;", [ownerID]);
  }
}
