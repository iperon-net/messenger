import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'constants.dart';

part 'settings_device.mapper.dart';

@MappableClass()
class SettingsDeviceModel with SettingsDeviceModelMappable {
  final AppLocale? locale;
  final DarkModeModel darkMode;
  final ColorThemeModel colorTheme;
  final bool isBlurOnInactive;
  final List<int> passcode;
  final bool passcodeBiometric;
  final int passcodeAutoLock;
  final bool passcodeForceLocked;
  final int passcodeBackgroundedAt;

  /// UX-демо чатов (экран «Разработчик»): вкладка «Чаты» на фейковых данных.
  final bool chatsDemo;

  /// Фича-флаг «Серверные чаты» (экран «Разработчик»): настоящие чаты через
  /// сервер (`ChatsRemoteDataSource`). Выключен — вкладка пуста (кроме демо).
  final bool chatsServer;

  /// Обои чатов («Темы для чатов»): id узора (`assets/wallpapers/<id>.svg`,
  /// неизвестный — узор по умолчанию) и индекс цвета в палитре `ChatWallpaperColors`.
  final String chatWallpaper;
  final int chatWallpaperColor;

  /// Интенсивность (видимость) узора обоев, 0–100 %.
  final int chatWallpaperIntensity;

  /// Быстрая реакция — эмодзи двойного тапа по сообщению.
  final String quickReaction;

  /// Предлагать ли сквозное шифрование (E2EE) в звонках на этом устройстве. По
  /// умолчанию включено; выключается на экране приватности звонков. Звонок
  /// шифруется, только когда E2EE включён у обоих собеседников (см. [Calls]).
  final bool callsE2ee;

  const SettingsDeviceModel({
    this.locale,
    this.darkMode = DarkModeModel.system,
    this.colorTheme = ColorThemeModel.blue,
    this.isBlurOnInactive = false,
    this.passcode = const [],
    this.passcodeBiometric = false,
    this.passcodeAutoLock = 0,
    this.passcodeForceLocked = false,
    this.passcodeBackgroundedAt = 0,
    this.chatsDemo = false,
    this.chatsServer = false,
    this.chatWallpaper = 'chat',
    this.chatWallpaperColor = 0,
    this.chatWallpaperIntensity = 40,
    this.quickReaction = '❤️',
    this.callsE2ee = true,
  });

  factory SettingsDeviceModel.fromSqlite(Map<String, dynamic> data) {
    final localeValue = data['locale'];
    final darkModeValue = data['darkMode'] ?? "system";
    final colorThemeValue = data['colorTheme'] ?? "blue";
    final isBlurOnInactive = data['isBlurOnInactive'] ?? 0;
    final passcode = data['passcode'] ?? [];
    final passcodeBiometric = data['passcodeBiometric'] ?? 0;
    final passcodeAutoLock = data['passcodeAutoLock'] ?? 0;
    final passcodeForceLocked = data['passcodeForceLocked'] ?? 0;
    final passcodeBackgroundedAt = data['passcodeBackgroundedAt'] ?? 0;
    final chatsDemo = data['chatsDemo'] ?? 0;
    final chatsServer = data['chatsServer'] ?? 0;
    final chatWallpaper = data['chatWallpaper'] as String?;
    final chatWallpaperColor = data['chatWallpaperColor'] as int?;
    final chatWallpaperIntensity = data['chatWallpaperIntensity'] as int?;
    final quickReaction = data['quickReaction'] as String?;
    // Отсутствующая/NULL колонка (старая БД до миграции) трактуется как включено.
    final callsE2ee = data['callsE2ee'] ?? 1;

    SettingsDeviceModel settingsDeviceModel = SettingsDeviceModel();

    if (localeValue != null && localeValue == "ru") {
      settingsDeviceModel = settingsDeviceModel.copyWith(locale: AppLocale.ru);
    } else if (localeValue != null && localeValue == "en") {
      settingsDeviceModel = settingsDeviceModel.copyWith(locale: AppLocale.en);
    }

    if (darkModeValue == "disabled") {
      settingsDeviceModel = settingsDeviceModel.copyWith(darkMode: DarkModeModel.disabled);
    } else if (darkModeValue == "alwaysOn") {
      settingsDeviceModel = settingsDeviceModel.copyWith(darkMode: DarkModeModel.alwaysOn);
    } else if (darkModeValue == "system") {
      settingsDeviceModel = settingsDeviceModel.copyWith(darkMode: DarkModeModel.system);
    }

    if (colorThemeValue == "purple") {
      settingsDeviceModel = settingsDeviceModel.copyWith(colorTheme: ColorThemeModel.purple);
    } else if (colorThemeValue == "green") {
      settingsDeviceModel = settingsDeviceModel.copyWith(colorTheme: ColorThemeModel.green);
    } else if (colorThemeValue == "orange") {
      settingsDeviceModel = settingsDeviceModel.copyWith(colorTheme: ColorThemeModel.orange);
    } else if (colorThemeValue == "blue") {
      settingsDeviceModel = settingsDeviceModel.copyWith(colorTheme: ColorThemeModel.blue);
    }

    if (isBlurOnInactive > 0) {
      settingsDeviceModel = settingsDeviceModel.copyWith(isBlurOnInactive: true);
    }

    if (passcode.isNotEmpty) {
      settingsDeviceModel = settingsDeviceModel.copyWith(passcode: passcode);
    }

    if (passcodeBiometric > 0) {
      settingsDeviceModel = settingsDeviceModel.copyWith(passcodeBiometric: true);
    }

    if (passcodeAutoLock > 0) {
      settingsDeviceModel = settingsDeviceModel.copyWith(passcodeAutoLock: passcodeAutoLock);
    }

    if (passcodeForceLocked > 0) {
      settingsDeviceModel = settingsDeviceModel.copyWith(passcodeForceLocked: true);
    }

    if (passcodeBackgroundedAt > 0) {
      settingsDeviceModel = settingsDeviceModel.copyWith(passcodeBackgroundedAt: passcodeBackgroundedAt);
    }

    if (chatsDemo > 0) {
      settingsDeviceModel = settingsDeviceModel.copyWith(chatsDemo: true);
    }

    if (chatsServer > 0) {
      settingsDeviceModel = settingsDeviceModel.copyWith(chatsServer: true);
    }

    if (chatWallpaper != null && chatWallpaper.isNotEmpty) {
      settingsDeviceModel = settingsDeviceModel.copyWith(chatWallpaper: chatWallpaper);
    }

    if (chatWallpaperColor != null) {
      settingsDeviceModel = settingsDeviceModel.copyWith(chatWallpaperColor: chatWallpaperColor);
    }

    if (chatWallpaperIntensity != null) {
      settingsDeviceModel = settingsDeviceModel.copyWith(chatWallpaperIntensity: chatWallpaperIntensity);
    }

    if (quickReaction != null && quickReaction.isNotEmpty) {
      settingsDeviceModel = settingsDeviceModel.copyWith(quickReaction: quickReaction);
    }

    if (callsE2ee == 0) {
      settingsDeviceModel = settingsDeviceModel.copyWith(callsE2ee: false);
    }

    return settingsDeviceModel;
  }
}
