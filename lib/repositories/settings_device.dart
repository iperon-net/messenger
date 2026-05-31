part of 'repositories.dart';


class SettingsDevice {
  final Logger logger;
  final Database database;

  SettingsDevice({required this.logger, required this.database});

  Future<models.SettingsDevice> getAll() async {
    final results = database.select("SELECT * FROM settingsDevice");
    if (results.isEmpty) {
      return models.SettingsDevice();
    }
    return models.SettingsDevice.fromSqlite(results.first);
  }

  Future<void> setLocale({required AppLocale locale}) async {
    database.execute("UPDATE settingsDevice SET locale = ?", [locale.languageCode]);
  }

  Future<void> setDarkMode(models.SettingsDeviceDarkMode value) async {
    database.execute("UPDATE settingsDevice SET darkMode = ?", [value.name]);
  }

  Future<void> setColorTheme(models.SettingsDeviceColorTheme value) async {
    database.execute("UPDATE settingsDevice SET colorTheme = ?", [value.name]);
  }

  Future<void> setBlurTaskSwitching(bool value) async {
    if (value) {
      database.execute("UPDATE settingsDevice SET blurTaskSwitchingEnable = ?", [1]);
    } else {
      database.execute("UPDATE settingsDevice SET blurTaskSwitchingEnable = ?", [0]);
    }
  }

}
