// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsDevice _$SettingsDeviceFromJson(Map<String, dynamic> json) =>
    _SettingsDevice(
      locate: $enumDecodeNullable(_$AppLocaleEnumMap, json['locate']),
      darkMode:
          $enumDecodeNullable(
            _$SettingsDeviceDarkModeEnumMap,
            json['darkMode'],
          ) ??
          SettingsDeviceDarkMode.system,
      colorTheme:
          $enumDecodeNullable(
            _$SettingsDeviceColorThemeEnumMap,
            json['colorTheme'],
          ) ??
          SettingsDeviceColorTheme.blue,
      blurTaskSwitchingEnable: json['blurTaskSwitchingEnable'] == null
          ? false
          : const BoolConverter().fromJson(
              (json['blurTaskSwitchingEnable'] as num).toInt(),
            ),
    );

Map<String, dynamic> _$SettingsDeviceToJson(_SettingsDevice instance) =>
    <String, dynamic>{
      'locate': _$AppLocaleEnumMap[instance.locate],
      'darkMode': _$SettingsDeviceDarkModeEnumMap[instance.darkMode]!,
      'colorTheme': _$SettingsDeviceColorThemeEnumMap[instance.colorTheme]!,
      'blurTaskSwitchingEnable': const BoolConverter().toJson(
        instance.blurTaskSwitchingEnable,
      ),
    };

const _$AppLocaleEnumMap = {AppLocale.en: 'en', AppLocale.ru: 'ru'};

const _$SettingsDeviceDarkModeEnumMap = {
  SettingsDeviceDarkMode.system: 'system',
  SettingsDeviceDarkMode.disabled: 'disabled',
  SettingsDeviceDarkMode.alwaysOn: 'alwaysOn',
};

const _$SettingsDeviceColorThemeEnumMap = {
  SettingsDeviceColorTheme.blue: 'blue',
  SettingsDeviceColorTheme.green: 'green',
  SettingsDeviceColorTheme.purple: 'purple',
};
