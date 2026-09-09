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
      "SELECT userID, username, fistName, lastName, birthDate, aboutMe, phoneNumber, avatarCdnID FROM profiles WHERE userID = ?;",
      [userID],
    );
    if (rows.isEmpty) return models.Profile();
    return models.ProfileMapper.fromMap(rows.first);
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
