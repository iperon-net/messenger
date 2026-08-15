part of 'repositories.dart';

class Cache {
  final Logger logger;
  final SqliteDatabase db;

  Cache({required this.logger, required this.db});

  Future<void> set({
    required Uint8List userID,
    required String key,
    required Uint8List value,
  }) async {
    await db.execute("DELETE FROM cache WHERE userID = ? AND key = ?;", [
      userID,
      key,
    ]);
    await db.execute(
      "INSERT INTO cache (key, value, userID) VALUES (?, ?, ?);",
      [key, value, userID],
    );
    logger.info("set cache key=$key");
  }

  // Future<List<int>> get({required List<int> userID, required String key}) async {
  //   final sqlSelect = database.select("SELECT value FROM cache WHERE userID = ? AND key = ? LIMIT 1;", [userID, key]);
  //   if (sqlSelect.isEmpty) return [];
  //   return sqlSelect.first["value"];
  // }
}
