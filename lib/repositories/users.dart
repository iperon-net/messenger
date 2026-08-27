part of 'repositories.dart';

class Users {
  final Logger logger;
  final SqliteDatabase db;

  Users({required this.logger, required this.db});

  // Create user
  //
  // Апсертим строго по первичному ключу `userID`, а не «ищем по номеру,
  // обновляем по userID»: сервер может выдать тому же номеру новый `userID`
  // (например, пересозданный аккаунт на бэкенде), а локальная строка с этим
  // номером переживает logout. При старой логике UPDATE ... WHERE userID = <новый>
  // не находил строку, и записи с новым userID не появлялось — последующая
  // вставка в `sessions` падала по FOREIGN KEY (userID) REFERENCES users(userID).
  //
  // Дополнительно сносим устаревшую строку с тем же номером под другим userID,
  // чтобы номер указывал ровно на один аккаунт; её сессии уходят каскадом
  // (ON DELETE CASCADE) — этот аккаунт всё равно больше не действителен.
  Future<void> createOrUpdate({required List<int> userID, required String phoneNumber}) async {
    await db.writeTransaction((txn) async {
      await txn.execute("DELETE FROM users WHERE phoneNumber = ? AND userID != ?;", [phoneNumber, userID]);
      await txn.execute(
        "INSERT INTO users (userID, phoneNumber) VALUES(?, ?) ON CONFLICT(userID) DO UPDATE SET phoneNumber = excluded.phoneNumber;",
        [userID, phoneNumber],
      );
    });
  }

  // Get active user
  Future<models.User> getBySession({required models.Session session}) async {
    if (session.userID.isEmpty) return models.User();

    final sqlUser = await db.execute("SELECT userID, phoneNumber FROM users WHERE userID = ? LIMIT 1;", [session.userID]);
    if (sqlUser.isEmpty) return models.User();
    return models.UserMapper.fromMap(sqlUser.first);
  }

  // Set salt
  Future<void> setSalt({required List<int> salt, required models.Session session}) async {
    await db.execute("UPDATE users SET salt = ? WHERE userID = ?;", [salt, session.userID]);
  }
}
