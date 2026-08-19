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

  const SettingsDeviceModel({
    this.locale,
    this.darkMode = DarkModeModel.system,
    this.colorTheme = ColorThemeModel.blue,
    this.isBlurOnInactive = false,
    this.passcode = const [],
    this.passcodeBiometric = false,
    this.passcodeAutoLock = 0,
    this.passcodeForceLocked = false,
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

    return settingsDeviceModel;
  }
}
