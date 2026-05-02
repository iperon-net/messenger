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
            "sharedSecretKey": Uint8List.fromList(sharedSecretKey),
          },
      );
    });
  }

}
