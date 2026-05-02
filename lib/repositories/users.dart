part of 'repositories.dart';


class Users {
  final Logger logger;
  final Database database;

  Users({required this.logger, required this.database});

  Future<void> setLanguage(AppLocale language) async {
    return await database.transaction((txn) async {
      await txn.update('settingsDevice', {'language': language.name});
    });
  }

}
