part of 'repositories.dart';

class Sessions {
  final Logger logger;
  final Database database;

  Sessions({required this.logger, required this.database});

  Future<void> deleteAndCreate({
    required List<int> userID, required List<int> session,
    required List<int> sharedKey, required List<int> sharedSalt,
  }) async {
    database.execute("BEGIN;");
    database.execute("DELETE FROM sessions WHERE userID = ?;", [userID]);
    database.execute(
        "INSERT INTO sessions (userID, session, sharedKey, sharedSalt, isActive) VALUES(?, ?, ?, ?, 1);",
        [userID, session, sharedKey, sharedSalt]
    );
    database.select("COMMIT;");
  }

  Future<models.Session> getActive() async {
    final sqlSession = database.select("SELECT userID, session, sharedKey, sharedSalt, isActive FROM sessions WHERE isActive = 1;");
    if (sqlSession.isEmpty) return models.Session();
    return models.SessionMapper.fromMap(sqlSession.first);
  }

  Future<void> logout() async {
    database.execute("DELETE FROM sessions WHERE isActive = 1;");
  }

}
