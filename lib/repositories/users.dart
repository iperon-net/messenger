part of 'repositories.dart';


class Users {
  final Logger logger;
  final Database database;

  Users({required this.logger, required this.database});

  Future<void> create({
    required List<int> session,
    required String phoneNumber,
    required List<int> userID,
    required List<int> sharedKeyID,
    required List<int> sharedSecretKey,
  }) async {

    return await database.transaction((txn) async {
      final userObjectID = ObjectId.fromBytes(userID);
      final sharedKeyObjectID = ObjectId.fromBytes(sharedKeyID);

      await txn.delete('users', where: 'userID = ?', whereArgs: [userObjectID.hexString]);
      await txn.insert(
        "users",
        {
          "userID": userObjectID.hexString,
          "phoneNumber": phoneNumber,
          "session": Uint8List.fromList(session),
          "isActive": 1,
        }
      );
      await txn.insert(
        "sharedKeys",
          {
            "sharedKeyID": sharedKeyObjectID.hexString,
            "userID": userObjectID.hexString,
            "sharedKey": Uint8List.fromList(sharedSecretKey),
          },
      );
    });
  }

  // Get active
  Future<models.User> getActive() async {
    return await database.transaction((txn) async {
      final resultsUser = await txn.query(
        "users",
        columns: ["userID", "phoneNumber", "session"],
        where: 'isActive = ?',
        whereArgs: [1],
        limit: 1,
      );
      if (resultsUser.isEmpty) {
        logger.warning("empty user");
        return models.User();
      }

      Map<String, Object?> user = {...resultsUser.first};

      final resultsSharedKeys = await txn.query(
        "sharedKeys",
        columns: ["sharedKeyID", "sharedKey", "expiredAt"],
        where: 'userID = ?',
        whereArgs: [user["userID"]],
      );

      if (resultsSharedKeys.isEmpty) {
        logger.warning("empty sharedKey");
        return models.User();
      }

      user["sharedKeys"] = resultsSharedKeys;

      return models.User.fromSqlite(user);
    });
  }

}
