import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/i18n/translations.g.dart';

part 'settings_device.mapper.dart';

@MappableEnum()
enum SettingsDeviceColorTheme { blue, green, purple }

@MappableEnum()
enum SettingsDeviceDarkMode { system, disabled, alwaysOn }

@MappableClass()
class SettingsDevice with SettingsDeviceMappable {
  final AppLocale? locate;
  final SettingsDeviceDarkMode darkMode;
  final SettingsDeviceColorTheme colorTheme;
  final bool blurTaskSwitchingEnable;

  const SettingsDevice({
    this.locate,
    this.darkMode = SettingsDeviceDarkMode.system,
    this.colorTheme = SettingsDeviceColorTheme.blue,
    this.blurTaskSwitchingEnable = false,
  });

  Map<String, dynamic> toSqlite() => {
    'locate': locate?.name,
    'darkMode': darkMode.name,
    'colorTheme': colorTheme.name,
    'blurTaskSwitchingEnable': blurTaskSwitchingEnable ? 1 : 0,
  };

  factory SettingsDevice.fromSqlite(Map<String, dynamic> data) => SettingsDevice(
    locate: data['locate'] != null
        ? AppLocale.values.byName(data['locate'] as String)
        : null,
    darkMode: SettingsDeviceDarkMode.values.byName(
      data['darkMode'] as String? ?? 'system',
    ),
    colorTheme: SettingsDeviceColorTheme.values.byName(
      data['colorTheme'] as String? ?? 'blue',
    ),
    blurTaskSwitchingEnable: (data['blurTaskSwitchingEnable'] as int?) != 0,
  );
}
