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
    database.execute("UPDATE users SET isActive = 0;");

    final sqlUser = database.select("SELECT userID FROM users WHERE userID = ?;", [userID]);
    if (sqlUser.isEmpty) {
      database.execute("INSERT INTO users (userID, phoneNumber, isActive) VALUES(?, ?, 1);", [userID, phoneNumber]);
    } else {
      database.execute("UPDATE users SET phoneNumber = ?, isActive = 1 WHERE userID = ?", [phoneNumber, userID]);
    }
    database.select("COMMIT;");
  }

  // Get active user
  Future<models.User> getBySession({required models.Session session}) async {
    if (session.userID.isEmpty) return models.User();

    final sqlUser = database.select("SELECT userID, phoneNumber FROM users WHERE userID = ?;", [session.userID]);
    if (sqlUser.isEmpty) return models.User();
    return models.UserMapper.fromMap(sqlUser.first);
  }

  // Get active user
  Future<models.User> getActive() async {
    final sqlUser = database.select("SELECT userID, phoneNumber FROM users WHERE isActive = 1;");
    if (sqlUser.isEmpty) return models.User();
    return models.UserMapper.fromMap(sqlUser.first);
  }

  Future<void> logout() async {
    // database.execute("DELETE FROM users WHERE ;");
    // await database.transaction((txn) async {
    //   txn.delete("users", where: 'isActive = ?', whereArgs: [1]);
    // });
  }
}
