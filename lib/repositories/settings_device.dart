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

  Future<void> setCallsE2ee(bool value) async {
    await db.execute("UPDATE settingsDevice SET callsE2ee = ?", [value ? 1 : 0]);
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

  Future<void> setPasscodeNotificationContent(bool value) async {
    await db.execute("UPDATE settingsDevice SET passcodeNotificationContent = ?", [value ? 1 : 0]);
  }

  Future<void> setChatsDemo(bool value) async {
    await db.execute("UPDATE settingsDevice SET chatsDemo = ?", [value ? 1 : 0]);
  }

  /// Флаги «Группы» / «Каналы» сняты (группы и каналы всегда включены):
  /// колонки остались отметкой «список диалогов после этого перечитан».
  Future<void> setChatsGroupsChannelsMigrated() async {
    await db.execute("UPDATE settingsDevice SET chatsGroups = 1, chatsChannels = 1");
  }

  Future<void> setChatWallpaper({required String pattern, required int color}) async {
    await db.execute("UPDATE settingsDevice SET chatWallpaper = ?, chatWallpaperColor = ?", [pattern, color]);
  }

  Future<void> setChatWallpaperIntensity(int value) async {
    await db.execute("UPDATE settingsDevice SET chatWallpaperIntensity = ?", [value]);
  }

  Future<void> setQuickReaction(String emoji) async {
    await db.execute("UPDATE settingsDevice SET quickReaction = ?", [emoji]);
  }

  Future<void> setSendWithModifierEnter(bool value) async {
    await db.execute("UPDATE settingsDevice SET sendWithModifierEnter = ?", [value ? 1 : 0]);
  }
}
