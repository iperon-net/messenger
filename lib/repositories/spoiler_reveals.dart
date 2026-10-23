part of 'repositories.dart';

/// Раскрытые спойлеры (таблица `spoilerReveals`, миграция 49): фото, видео и
/// текст, которые пользователь уже раскрыл тапом, остаются раскрытыми и после
/// перезапуска. Ключ — `chatID/messageID/часть` (`SpoilerReveals.key`). Набор
/// свой у каждого аккаунта ([_owner], как у [HiddenProfiles]); только
/// локально, на сервер не уходит.
class SpoilerRevealsRepository {
  final Logger logger;
  final SqliteDatabase db;

  SpoilerRevealsRepository({required this.logger, required this.db});

  /// userID активного аккаунта — подзапросом, чтобы не тянуть `Auth` в слой БД.
  static const _owner = '(SELECT userID FROM sessions WHERE isActive = 1 LIMIT 1)';

  /// Сколько раскрытий держим: старые вытесняются (это давние сообщения,
  /// которые вряд ли снова откроют).
  static const limit = 10000;

  /// Все раскрытые ключи активного аккаунта.
  Future<Set<String>> all() async {
    final rows = await db.execute("SELECT key FROM spoilerReveals WHERE ownerID = $_owner;");
    return {for (final row in rows) row["key"] as String};
  }

  /// Запоминает раскрытие [key]; сверх [limit] — удаляет самые старые.
  Future<void> add(String key) async {
    await db.writeTransaction((tx) async {
      await tx.execute("INSERT OR IGNORE INTO spoilerReveals (ownerID, key, createdAt) SELECT $_owner, ?, ? WHERE $_owner IS NOT NULL;", [
        key,
        DateTime.now().millisecondsSinceEpoch,
      ]);
      await tx.execute(
        """
        DELETE FROM spoilerReveals WHERE ownerID = $_owner AND key IN (
          SELECT key FROM spoilerReveals WHERE ownerID = $_owner ORDER BY createdAt DESC LIMIT -1 OFFSET ?
        );
        """,
        [limit],
      );
    });
  }
}
