import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/i18n/translations.g.dart';

part 'settings_device.mapper.dart';

@MappableEnum()
enum SettingsDeviceColorTheme { blue, green, purple }

@MappableEnum()
enum SettingsDeviceDarkMode { system, disabled, alwaysOn }

@MappableClass()
class SettingsDevice with SettingsDeviceMappable {
  final AppLocale locale;
  final SettingsDeviceDarkMode darkMode;
  final SettingsDeviceColorTheme colorTheme;
  final bool blurTaskSwitchingEnable;

  const SettingsDevice({
    this.locale = AppLocale.en,
    this.darkMode = SettingsDeviceDarkMode.system,
    this.colorTheme = SettingsDeviceColorTheme.blue,
    this.blurTaskSwitchingEnable = false,
  });

  factory SettingsDevice.fromSqlite(Map<String, dynamic> data) {
    final localeValue = data['locale'] ?? "en";
    final darkModeValue = data['darkMode'] ?? "system";
    final colorThemeValue = data['colorTheme'] ?? "blue";

    AppLocale locale = AppLocale.en;
    if (localeValue == "ru") {
      locale = AppLocale.ru;
    }

    SettingsDeviceDarkMode darkMode = SettingsDeviceDarkMode.system;
    if (darkModeValue == "disabled") {
      darkMode = SettingsDeviceDarkMode.disabled;
    } else if (darkModeValue == "alwaysOn") {
      darkMode = SettingsDeviceDarkMode.alwaysOn;
    }

    SettingsDeviceColorTheme colorTheme = SettingsDeviceColorTheme.blue;
    if (colorThemeValue == "purple") {
      colorTheme = SettingsDeviceColorTheme.purple;
    } else if (colorThemeValue == "green") {
      colorTheme = SettingsDeviceColorTheme.green;
    }

    return SettingsDevice(locale: locale, darkMode: darkMode, colorTheme: colorTheme);
  }
}
