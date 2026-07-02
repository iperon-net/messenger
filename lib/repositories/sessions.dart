part of 'repositories.dart';

class Sessions {
  final Logger logger;
  final Database database;

  Sessions({required this.logger, required this.database});

  Future<void> deleteAndCreate({
    required List<int> userID, required List<int> session, required List<int> sessionID,
    required List<int> sharedKey, required List<int> sharedSalt, required DateTime createAt
  }) async {
    database.execute("BEGIN;");
    database.execute("DELETE FROM sessions WHERE userID = ?;", [userID]);
    database.execute(
        "INSERT INTO sessions (sessionID, userID, session, sharedKey, salt, isActive, createAt) VALUES(?, ?, ?, ?, ?, 1, ?);",
        [sessionID, userID, session, sharedKey, sharedSalt, createAt.microsecondsSinceEpoch]
    );
    database.select("COMMIT;");
  }

  Future<models.Session> getActive() async {
    final sqlSession = database.select("SELECT sessionID, userID, session, sharedKey, salt, isActive FROM sessions WHERE isActive = 1;");
    if (sqlSession.isEmpty) return models.Session();
    return models.SessionMapper.fromMap(sqlSession.first);
  }

  Future<void> logout() async {
    database.execute("DELETE FROM sessions WHERE isActive = 1;");
  }

}
