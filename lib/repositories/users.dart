part of 'repositories.dart';

class Users {
  final Logger logger;
  final SqliteDatabase db;

  Users({required this.logger, required this.db});

  // Create user
  Future<void> createOrUpdate({required List<int> userID, required String phoneNumber}) async {
    await db.writeTransaction((txn) async {
      final sqlUser = await txn.execute("SELECT userID FROM users WHERE phoneNumber = ?;", [phoneNumber]);
      if (sqlUser.isEmpty) {
        await txn.execute("INSERT INTO users (userID, phoneNumber) VALUES(?, ?);", [userID, phoneNumber]);
      } else {
        await txn.execute("UPDATE users SET phoneNumber = ? WHERE userID = ?", [phoneNumber, userID]);
      }
    });
  }

  // Get active user
  Future<User> getBySession({required Session session}) async {
    if (session.userID.isEmpty) return User();

    final sqlUser = await db.execute("SELECT userID, phoneNumber FROM users WHERE userID = ? LIMIT 1;", [session.userID]);
    if (sqlUser.isEmpty) return User();
    return UserMapper.fromMap(sqlUser.first);
  }

  // Set salt
  Future<void> setSalt({required List<int> salt, required Session session}) async {
    await db.execute("UPDATE users SET salt = ? WHERE userID = ?;", [salt, session.userID]);
  }
}
