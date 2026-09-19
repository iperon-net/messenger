part of 'repositories.dart';

/// Локальный журнал звонков (таблица `callLogs`). Наполняется при завершении
/// каждого звонка из сервиса `Calls` (сервер историю не хранит) и читается
/// вкладкой «Звонки» (`CallsCubit`). Строки упорядочены по времени завершения.
class CallLogs {
  final Logger logger;
  final SqliteDatabase db;

  CallLogs({required this.logger, required this.db});

  /// Добавляет запись о завершённом звонке.
  Future<void> insert(models.CallLog log) async {
    await db.execute(
      """
      INSERT INTO callLogs
        (callID, userID, displayName, direction, video, missed, durationSeconds, createdAt)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?);
      """,
      [
        log.callID,
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
  Future<List<models.CallLog>> getAll({int limit = 500}) async {
    final rows = await db.execute("SELECT * FROM callLogs ORDER BY createdAt DESC LIMIT ?;", [limit]);
    return rows.map((row) => models.CallLogMapper.fromMap(row)).toList();
  }

  /// Удаляет одну запись по локальному id.
  Future<void> deleteByID(int id) async {
    await db.execute("DELETE FROM callLogs WHERE id = ?;", [id]);
  }

  /// Очищает весь журнал.
  Future<void> deleteAll() async {
    await db.execute("DELETE FROM callLogs;");
  }
}
