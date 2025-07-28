part of 'repositories.dart';


class SettingsDevice {
  final Logger logger;
  final Database database;

  SettingsDevice({required this.logger, required this.database});

  Future<models.SettingsDevice> getAllSettings() async {
    final columns = [
      "language",
      "darkMode",
      "themeColor",
    ];

    return await database.transaction((txn) async {
      List<Map<String, Object?>> records = await txn.query("settings_device", columns: columns);
      if (records.isEmpty) {
        return models.SettingsDevice(
          language: "",
          darkMode: models.SettingsDeviceDarkMode.system,
          themeColor: models.SettingsDeviceThemeColor.blue,
        );
      }
      return models.SettingsDevice.fromJson(records.first);
    });
  }

  Future<void> setLanguage(AppLocale language) async {
    return await database.transaction((txn) async {
      await txn.update("settings_device", {"language": language.name});
    });
  }

  Future<void> setDarkMode(models.SettingsDeviceDarkMode value) async {
    return await database.transaction((txn) async {
      await txn.update("settings_device", {"darkMode": value.name});
    });
  }

  Future<void> setThemeColor(models.SettingsDeviceThemeColor value) async {
    return await database.transaction((txn) async {
      await txn.update("settings_device", {"themeColor": value.name});
    });

  }

}
