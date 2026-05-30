part of 'repositories.dart';


class SettingsDevice {
  final Logger logger;
  final SqliteDatabase database;

  SettingsDevice({required this.logger, required this.database});

  Future<models.SettingsDevice> getAll() async {
    final results = await database.getAll("SELECT * FROM settingsDevice");
    if (results.isEmpty) {
      return models.SettingsDevice();
    }

    return models.SettingsDevice.fromSqlite(results.first);
  }

  Future<void> setLocate({required AppLocale locate}) async {
    // return await database.transaction((txn) async {
    //   await txn.update('settingsDevice', {'locate': locate.languageCode});
    // });
  }

  Future<void> setDarkMode(models.SettingsDeviceDarkMode value) async {
    // return await database.transaction((txn) async {
    //   await txn.update('settingsDevice', {'darkMode': value.name});
    // });
  }

  Future<void> setColorTheme(models.SettingsDeviceColorTheme value) async {
    // return await database.transaction((txn) async {
    //   await txn.update('settingsDevice', {'colorTheme': value.name});
    // });
  }

  Future<void> setBlurTaskSwitching(bool value) async {
    // return await database.transaction((txn) async {
    //   if(value){
    //     await txn.update('settingsDevice', {'blurTaskSwitchingEnable': 1});
    //   } else {
    //     await txn.update('settingsDevice', {'blurTaskSwitchingEnable': 0});
    //   }
    // });
  }

}
