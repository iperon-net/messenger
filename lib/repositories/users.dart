part of 'repositories.dart';

class Users {
  final Logger logger;
  final Database database;

  Users({required this.logger, required this.database});

  // Create user
  Future<void> createOrUpdate({
    required List<int> userID,
    required String phoneNumber,
  }) async {

    database.execute("BEGIN;");

    final sqlUser = database.select("SELECT userID FROM users WHERE userID = ?;", [userID]);
    if (sqlUser.isEmpty) {
      database.execute("INSERT INTO users (userID, phoneNumber) VALUES(?, ?);", [userID, phoneNumber]);
    } else {
      database.execute("UPDATE users SET phoneNumber = ? WHERE userID = ?", [phoneNumber, userID]);
    }
    database.select("COMMIT;");
  }

  // Get active user
  Future<models.User> getBySession({required models.Session session}) async {
    if (session.userID.isEmpty) return models.User();

    final sqlUser = database.select("SELECT userID, phoneNumber, salt FROM users WHERE userID = ?;", [session.userID]);
    if (sqlUser.isEmpty) return models.User();
    return models.UserMapper.fromMap(sqlUser.first);
  }

  // Set salt
  Future<void> setSalt({required List<int> salt, required models.Session session}) async {
    database.execute("UPDATE users SET salt = ? WHERE userID = ?;", [salt, session.userID]);
  }

}
