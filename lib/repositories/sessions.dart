part of 'repositories.dart';

class Sessions {
  final Logger logger;
  final SqliteDatabase db;

  /// Индекс аккаунтов в `device.db`: вход и выход отражаются и в нём.
  final Accounts accounts;

  Sessions({required this.logger, required this.db, required this.accounts});

  Future<void> deleteAndCreate({
    required List<int> userID,
    required List<int> session,
    required List<int> sessionID,
    required List<int> sharedKey,
    required List<int> sharedSalt,
    required DateTime createAt,
  }) async {
    await db.writeTransaction((txn) async {
      await txn.execute("DELETE FROM sessions WHERE userID = ?;", [userID]);
      await txn.execute(
        "INSERT INTO sessions (sessionID, userID, session, sharedKey, salt, isActive, createAt) VALUES(?, ?, ?, ?, ?, 1, ?);",
        [sessionID, userID, session, sharedKey, sharedSalt, createAt.millisecondsSinceEpoch],
      );
    });
    // Номер пишет Users.createOrUpdate перед созданием сессии.
    final user = await db.getOptional("SELECT phoneNumber FROM users WHERE userID = ?;", [userID]);
    await accounts.activate(userID: userID, phoneNumber: user?['phoneNumber'] as String? ?? '');
  }

  Future<models.Session> getActive() async {
    final sqlSession = await db.execute("SELECT sessionID, userID, session, sharedKey, salt, isActive FROM sessions WHERE isActive = 1;");
    if (sqlSession.isEmpty) return models.Session();
    return models.SessionMapper.fromMap(sqlSession.first);
  }

  Future<void> deleteActive() async {
    await db.writeTransaction((txn) async {
      // await txn.execute("UPDATE settingsDevice SET passcode = NULL;");
      await txn.execute("DELETE FROM sessions WHERE isActive = 1;");
    });
    await accounts.removeActive();
  }
}
