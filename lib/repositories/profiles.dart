part of 'repositories.dart';

/// Локальный кэш публичных профилей чужих пользователей (таблица `profiles`).
/// Заполняется из стрима (`MessageType.PROFILE`, см. `API._handleMessage`) и
/// читается экраном профиля для мгновенного показа без сети.
class Profiles {
  final Logger logger;
  final SqliteDatabase db;

  Profiles({required this.logger, required this.db});

  Future<models.Profile> getByUserID({required List<int> userID}) async {
    final rows = await db.execute(
      "SELECT userID, username, fistName, lastName, birthDate, aboutMe, phoneNumber, avatarCdnID, lastSeenAt FROM profiles WHERE userID = ?;",
      [userID],
    );
    if (rows.isEmpty) return models.Profile();
    return models.ProfileMapper.fromMap(rows.first);
  }

  /// Кэш last-seen по набору userID для мгновенного показа на cold-start (батч,
  /// один запрос). Возвращает карту `userID(hex) -> DateTime` только по тем, у
  /// кого дата известна. [toHex] — Utils.bytesToHex (ключ, совместимый с кубитом).
  Future<Map<String, DateTime>> getLastSeenByUserIDs({required List<List<int>> userIDs, required String Function(List<int>) toHex}) async {
    if (userIDs.isEmpty) return {};
    final placeholders = List.filled(userIDs.length, '?').join(',');
    final rows = await db.execute(
      "SELECT userID, lastSeenAt FROM profiles WHERE lastSeenAt IS NOT NULL AND userID IN ($placeholders);",
      userIDs,
    );
    final result = <String, DateTime>{};
    for (final row in rows) {
      final id = row["userID"] as List<int>?;
      final ms = row["lastSeenAt"] as int?;
      if (id == null || ms == null) continue;
      result[toHex(id)] = DateTime.fromMillisecondsSinceEpoch(ms);
    }
    return result;
  }

  /// Пишет last-seen пользователя (epoch-millis) — upsert по userID. Обновления
  /// присутствия приходят из ContactsCubit при получении PRESENCE.
  Future<void> updateLastSeen({required List<int> userID, required DateTime lastSeen}) async {
    await db.execute(
      """
      INSERT INTO profiles (userID, lastSeenAt)
      VALUES(?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        lastSeenAt = excluded.lastSeenAt;
      """,
      [userID, lastSeen.millisecondsSinceEpoch],
    );
  }

  /// Upsert всех текстовых полей профиля разом (кроме аватара — он привязывается
  /// отдельно через [updateAvatarByCdnID], т.к. может приходить/скачиваться
  /// независимо). Ключ конфликта — `userID`.
  Future<void> upsert({
    required List<int> userID,
    String username = "",
    String fistName = "",
    String lastName = "",
    DateTime? birthDate,
    String aboutMe = "",
    String phoneNumber = "",
  }) async {
    await db.execute(
      """
      INSERT INTO profiles (userID, username, fistName, lastName, birthDate, aboutMe, phoneNumber)
      VALUES(?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        username = excluded.username,
        fistName = excluded.fistName,
        lastName = excluded.lastName,
        birthDate = excluded.birthDate,
        aboutMe = excluded.aboutMe,
        phoneNumber = excluded.phoneNumber;
      """,
      [userID, username, fistName, lastName, birthDate?.millisecondsSinceEpoch, aboutMe, phoneNumber],
    );
  }

  /// Привязывает скачанный на CDN аватар к профилю: пишет [cdnID] в колонку
  /// `avatarCdnID`. Строка `downloads` с этим `cdnID` к этому моменту уже создана
  /// (`CDNManager.download`), поэтому внешний ключ соблюдён. Upsert — на случай,
  /// если строки профиля для [userID] ещё нет.
  Future<void> updateAvatarByCdnID({required List<int> userID, required List<int> cdnID}) async {
    await db.execute(
      """
      INSERT INTO profiles (userID, avatarCdnID)
      VALUES(?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        avatarCdnID = excluded.avatarCdnID;
      """,
      [userID, cdnID],
    );
  }
}
