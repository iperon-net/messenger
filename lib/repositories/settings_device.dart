part of 'repositories.dart';

class SettingsDevice {
  final Logger logger;
  final SqliteDatabase db;

  SettingsDevice({required this.logger, required this.db});

  Future<SettingsDeviceModel> getAll() async {
    final res = await db.get("SELECT * FROM settingsDevice");
    return SettingsDeviceModel.fromSqlite(res);
  }

  Future<void> setLocale({required AppLocale locale}) async {
    await db.execute("UPDATE settingsDevice SET locale = ?", [
      locale.languageCode,
    ]);
  }

  Future<void> setDarkMode(DarkModeModel value) async {
    await db.execute("UPDATE settingsDevice SET darkMode = ?", [value.name]);
  }

  Future<void> setColorTheme(ColorThemeModel value) async {
    await db.execute("UPDATE settingsDevice SET colorTheme = ?", [value.name]);
  }

  Future<void> setIsBlurOnInactive(bool value) async {
    await db.execute("UPDATE settingsDevice SET isBlurOnInactive = ?", [
      value ? 1 : 0,
    ]);
  }

  Future<void> setPasscode(List<int> value) async {
    await db.execute("UPDATE settingsDevice SET passcode = ?", [value]);
  }

  Future<void> setPasscodeBiometric({required bool biometric}) async {
    await db.execute("UPDATE settingsDevice SET passcodeBiometric = ?", [
      biometric ? 1 : 0,
    ]);
  }

  Future<void> setPasscodeAutoLock({required int seconds}) async {
    await db.execute("UPDATE settingsDevice SET passcodeAutoLock = ?", [
      seconds,
    ]);
  }

  Future<void> setPasscodeForceLocked(bool value) async {
    await db.execute("UPDATE settingsDevice SET passcodeForceLocked = ?", [
      value ? 1 : 0,
    ]);
  }
}
