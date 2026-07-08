part of 'repositories.dart';

class Cache {
  final Logger logger;
  final Database database;

  Cache({required this.logger, required this.database});

  Future<void> set({required List<int> userID, required String key, required List<int> value}) async {
    database.execute("DELETE FROM cache WHERE userID = ? AND key = ?;", [userID, key]);
    database.execute("INSERT INTO cache (key, value, userID) VALUES (?, ?, ?);", [key, value, userID]);
  }

  Future<List<int>> get({required List<int> userID, required String key}) async {
    final sqlSelect = database.select("SELECT value FROM cache WHERE userID = ? AND key = ? LIMIT 1;", [userID, key]);
    if (sqlSelect.isEmpty) return [];
    return sqlSelect.first["value"];
  }


  // Future<void> logout() async {
  //   database.execute("DELETE FROM sessions WHERE isActive = 1;");
  // }

}
