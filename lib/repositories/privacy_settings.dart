part of 'repositories.dart';

class PrivacySettings {
  final Logger logger;
  final SqliteDatabase db;

  PrivacySettings({required this.logger, required this.db});

  /// Возвращает сырой буфер `PrivacySettings_Response` пользователя, или null,
  /// если настройки ещё ни разу не приходили с сервера (первый запуск / кэш пуст).
  /// Значение — read-only отражение серверной настройки; редактируется всегда
  /// на сервере (отдельные *_UPDATE RPC), сюда попадает через стрим (push или
  /// ответ на запрос), записывается централизованно в API._handleMessage.
  Future<Uint8List?> get({required List<int> userID}) async {
    final res = await db.getOptional("SELECT payload FROM privacySettings WHERE userID = ?", [userID]);
    if (res == null) return null;
    return res["payload"] as Uint8List;
  }

  /// UPSERT настроек приватности пользователя. Одна строка на userID: весь ответ
  /// хранится одним BLOB (у настройки repeated-bytes списки исключений allow/deny
  /// на 4 канала — колоночная раскладка неудобна, парсим на чтении).
  Future<void> upsert({required List<int> userID, required Uint8List payload}) async {
    await db.execute(
      """
      INSERT INTO privacySettings (userID, payload) VALUES (?, ?)
      ON CONFLICT(userID) DO UPDATE SET payload = excluded.payload;
    """,
      [userID, payload],
    );
  }
}
