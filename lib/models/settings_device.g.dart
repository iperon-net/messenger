// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsDevice _$SettingsDeviceFromJson(Map<String, dynamic> json) =>
    _SettingsDevice(
      language: json['language'] as String? ?? "",
      darkMode:
          $enumDecodeNullable(
            _$SettingsDeviceDarkModeEnumMap,
            json['darkMode'],
          ) ??
          SettingsDeviceDarkMode.system,
      themeColor: json['themeColor'] ?? SettingsDeviceThemeColor.blue,
      blurTaskSwitchingEnable: json['blurTaskSwitchingEnable'] == null
          ? false
          : const BoolConverter().fromJson(
              (json['blurTaskSwitchingEnable'] as num).toInt(),
            ),
    );

Map<String, dynamic> _$SettingsDeviceToJson(_SettingsDevice instance) =>
    <String, dynamic>{
      'language': instance.language,
      'darkMode': _$SettingsDeviceDarkModeEnumMap[instance.darkMode]!,
      'themeColor': instance.themeColor,
      'blurTaskSwitchingEnable': const BoolConverter().toJson(
        instance.blurTaskSwitchingEnable,
      ),
    };

const _$SettingsDeviceDarkModeEnumMap = {
  SettingsDeviceDarkMode.system: 'system',
  SettingsDeviceDarkMode.disabled: 'disabled',
  SettingsDeviceDarkMode.alwaysOn: 'alwaysOn',
};
