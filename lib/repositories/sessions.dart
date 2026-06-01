part of 'repositories.dart';

class Sessions {
  final Logger logger;
  final Database database;

  Sessions({required this.logger, required this.database});

  Future<void> deleteAndCreate({required List<int> userID, required List<int> session, required List<int> sharedKey}) async {
    database.execute("BEGIN;");
    database.execute("DELETE FROM sessions WHERE userID = ?;", [userID]);
    database.execute("INSERT INTO sessions (userID, session, sharedKey, isActive) VALUES(?, ?, ?, 1);", [userID, session, sharedKey]);
    database.select("COMMIT;");
  }

  Future<models.Session> getActive() async {
    final sqlSession = database.select("SELECT userID, session, sharedKey, isActive FROM sessions WHERE isActive = 1;");
    if (sqlSession.isEmpty) return models.Session();
    return models.SessionMapper.fromMap(sqlSession.first);
  }

}
