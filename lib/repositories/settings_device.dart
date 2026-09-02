part of 'repositories.dart';

class SettingsDevice {
  final Logger logger;
  final SqliteDatabase db;

  SettingsDevice({required this.logger, required this.db});

  Future<models.SettingsDeviceModel> getAll() async {
    final res = await db.get("SELECT * FROM settingsDevice");
    return models.SettingsDeviceModel.fromSqlite(res);
  }

  Future<void> setLocale({required AppLocale locale}) async {
    await db.execute("UPDATE settingsDevice SET locale = ?", [locale.languageCode]);
  }

  Future<void> setDarkMode(models.DarkModeModel value) async {
    await db.execute("UPDATE settingsDevice SET darkMode = ?", [value.name]);
  }

  Future<void> setColorTheme(models.ColorThemeModel value) async {
    await db.execute("UPDATE settingsDevice SET colorTheme = ?", [value.name]);
  }

  Future<void> setIsBlurOnInactive(bool value) async {
    await db.execute("UPDATE settingsDevice SET isBlurOnInactive = ?", [value ? 1 : 0]);
  }

  Future<void> setFontScale(double value) async {
    await db.execute("UPDATE settingsDevice SET fontScale = ?", [value]);
  }

  Future<void> setPasscode(List<int> value) async {
    await db.execute("UPDATE settingsDevice SET passcode = ?", [value]);
  }

  Future<void> setPasscodeBiometric({required bool biometric}) async {
    await db.execute("UPDATE settingsDevice SET passcodeBiometric = ?", [biometric ? 1 : 0]);
  }

  Future<void> setPasscodeAutoLock({required int seconds}) async {
    await db.execute("UPDATE settingsDevice SET passcodeAutoLock = ?", [seconds]);
  }

  Future<void> setPasscodeForceLocked(bool value) async {
    await db.execute("UPDATE settingsDevice SET passcodeForceLocked = ?", [value ? 1 : 0]);
  }

  /// Момент ухода приложения в фон (мс с эпохи, 0 — сброс). Персистится, чтобы
  /// авто-блокировка по таймауту переживала выгрузку приложения из памяти iOS.
  Future<void> setPasscodeBackgroundedAt(int millisecondsSinceEpoch) async {
    await db.execute("UPDATE settingsDevice SET passcodeBackgroundedAt = ?", [millisecondsSinceEpoch]);
  }
}
