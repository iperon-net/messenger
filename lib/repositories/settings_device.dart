part of 'repositories.dart';


class SettingsDevice {
  final Logger logger;
  final Database database;

  SettingsDevice({required this.logger, required this.database});

  Future<models.SettingsDevice> getAllSettings() async {
    final columns = [
      'language',
      'darkMode',
      'themeColor',
      'blurTaskSwitchingEnable',
    ];

    return await database.transaction((txn) async {
      List<Map<String, Object?>> records = await txn.query('settingsDevice', columns: columns);
      if (records.isEmpty) {
        return models.SettingsDevice(
          language: '',
          darkMode: models.SettingsDeviceDarkMode.system,
          themeColor: models.SettingsDeviceThemeColor.blue,
          blurTaskSwitchingEnable: 1,
        );
      }
      return models.SettingsDevice.fromJson(records.first);
    });
  }

  Future<void> setLanguage(AppLocale language) async {
    return await database.transaction((txn) async {
      await txn.update('settingsDevice', {'language': language.name});
    });
  }

  Future<void> setDarkMode(models.SettingsDeviceDarkMode value) async {
    return await database.transaction((txn) async {
      await txn.update('settingsDevice', {'darkMode': value.name});
    });
  }

  Future<void> setThemeColor(models.SettingsDeviceThemeColor value) async {
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
