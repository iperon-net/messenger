// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsDevice _$SettingsDeviceFromJson(Map<String, dynamic> json) =>
    _SettingsDevice(
      language: json['language'] as String,
      darkMode: $enumDecode(_$SettingsDeviceDarkModeEnumMap, json['darkMode']),
      themeColor: $enumDecode(
        _$SettingsDeviceThemeColorEnumMap,
        json['themeColor'],
      ),
      passCode: json['passCode'] as String,
      passCodeTtl: (json['passCodeTtl'] as num).toInt(),
      passCodeTimer: (json['passCodeTimer'] as num).toInt(),
      passCodeExpire: (json['passCodeExpire'] as num?)?.toInt() ?? 0,
      passCodeLock: json['passCodeLock'] as bool? ?? false,
    );

Map<String, dynamic> _$SettingsDeviceToJson(_SettingsDevice instance) =>
    <String, dynamic>{
      'language': instance.language,
      'darkMode': _$SettingsDeviceDarkModeEnumMap[instance.darkMode]!,
      'themeColor': _$SettingsDeviceThemeColorEnumMap[instance.themeColor]!,
      'passCode': instance.passCode,
      'passCodeTtl': instance.passCodeTtl,
      'passCodeTimer': instance.passCodeTimer,
      'passCodeExpire': instance.passCodeExpire,
      'passCodeLock': instance.passCodeLock,
    };

const _$SettingsDeviceDarkModeEnumMap = {
  SettingsDeviceDarkMode.system: 'system',
  SettingsDeviceDarkMode.disabled: 'disabled',
  SettingsDeviceDarkMode.alwaysOn: 'alwaysOn',
};

const _$SettingsDeviceThemeColorEnumMap = {
  SettingsDeviceThemeColor.blue: 'blue',
  SettingsDeviceThemeColor.green: 'green',
  SettingsDeviceThemeColor.purple: 'purple',
};
