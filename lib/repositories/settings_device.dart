part of 'repositories.dart';


class SettingsDevice {
  final Logger logger;
  final Database database;

  SettingsDevice({required this.logger, required this.database});

  Future<models.SettingsDevice> getAll() async {
    final columns = [
      'locate',
      'darkMode',
      'colorTheme',
      'blurTaskSwitchingEnable',
    ];

    return await database.transaction((txn) async {
      List<Map<String, Object?>> records = await txn.query('settingsDevice', columns: columns);
      if (records.isEmpty) {
        return models.SettingsDevice(
          darkMode: models.SettingsDeviceDarkMode.system,
          colorTheme: models.SettingsDeviceColorTheme.blue,
          blurTaskSwitchingEnable: true,
        );
      }

      return models.SettingsDevice.fromSqlite(records.first);
    });
  }

  Future<void> setLocate({required AppLocale locate}) async {
    return await database.transaction((txn) async {
      await txn.update('settingsDevice', {'locate': locate.languageCode});
    });
  }

  Future<void> setDarkMode(models.SettingsDeviceDarkMode value) async {
    return await database.transaction((txn) async {
      await txn.update('settingsDevice', {'darkMode': value.name});
    });
  }

  Future<void> setThemeColor(models.SettingsDeviceColorTheme value) async {
    return await database.transaction((txn) async {
      await txn.update('settingsDevice', {'themeColor': value.name});
    });
  }

  Future<void> setBlurTaskSwitching(bool value) async {
    return await database.transaction((txn) async {
      if(value){
        await txn.update('settingsDevice', {'blurTaskSwitchingEnable': 1});
      } else {
        await txn.update('settingsDevice', {'blurTaskSwitchingEnable': 0});
      }
    });
  }

}
