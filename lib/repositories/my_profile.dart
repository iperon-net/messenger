part of 'repositories.dart';

class MyProfile {
  final Logger logger;
  final SqliteDatabase db;

  MyProfile({required this.logger, required this.db});

  Future<models.MyProfile> getByUserID({required List<int> userID}) async {
    final sqlMyProfile = await db.execute("SELECT username, fistName, lastName, birthDate, aboutMe FROM myProfile WHERE userID = ?;", [
      userID,
    ]);
    if (sqlMyProfile.isEmpty) return models.MyProfile();
    return models.MyProfileMapper.fromMap(sqlMyProfile.first);
  }

  Future<void> update({required List<int> userID, String fistName = "", String lastName = "", DateTime? birthDate, aboutMe = ""}) async {
    await db.execute(
      """
      INSERT INTO myProfile (userID, fistName, lastName, birthDate, aboutMe)
      VALUES(?, ?, ?, ?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        fistName = excluded.fistName,
        lastName = excluded.lastName,
        birthDate = excluded.birthDate,
        aboutMe = excluded.aboutMe;
      """,
      [userID, fistName, lastName, birthDate?.millisecondsSinceEpoch, aboutMe],
    );
  }

  /// Привязывает загруженный на CDN аватар к локальному профилю: пишет
  /// [cdnID] в колонку `avatarCdnID`. Строка `downloads` с этим `cdnID` к
  /// этому моменту уже создана аплоад-флоу (`_seedDownloadCache` в [CDNManager]),
  /// поэтому внешний ключ `avatarCdnID → downloads(cdnID)` соблюдён. Upsert —
  /// на случай, если строки профиля для [userID] ещё нет.
  Future<void> updateAvatarByCdnID({required List<int> userID, required List<int> cdnID}) async {
    await db.execute(
      """
      INSERT INTO myProfile (userID, avatarCdnID)
      VALUES(?, ?)
      ON CONFLICT(userID) DO UPDATE SET
        avatarCdnID = excluded.avatarCdnID;
      """,
      [userID, cdnID],
    );
  }
}
