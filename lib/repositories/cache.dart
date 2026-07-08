part of 'repositories.dart';

class Cache {
  final Logger logger;
  final Database database;

  Cache({required this.logger, required this.database});

  // Future<void> logout() async {
  //   database.execute("DELETE FROM sessions WHERE isActive = 1;");
  // }

}
