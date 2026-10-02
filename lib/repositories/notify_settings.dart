part of 'repositories.dart';

class NotifySettings {
  final Logger logger;
  final SqliteDatabase db;

  NotifySettings({required this.logger, required this.db});

  /// Возвращает сырой буфер `NotifySettings_Response` пользователя, или null,
  /// если настройки ещё ни разу не приходили с сервера. Как и приватность —
  /// read-only отражение серверной настройки: меняется только на сервере
  /// (NOTIFY_SETTINGS_UPDATE), сюда попадает через стрим и пишется
  /// централизованно в API._handleMessage.
  Future<Uint8List?> get({required List<int> userID}) async {
    final res = await db.getOptional("SELECT payload FROM notifySettings WHERE userID = ?", [userID]);
    if (res == null) return null;
    return res["payload"] as Uint8List;
  }

  /// UPSERT настроек уведомлений пользователя (одна строка на userID).
  Future<void> upsert({required List<int> userID, required Uint8List payload}) async {
    await db.execute(
      """
      INSERT INTO notifySettings (userID, payload) VALUES (?, ?)
      ON CONFLICT(userID) DO UPDATE SET payload = excluded.payload;
    """,
      [userID, payload],
    );
  }
}
