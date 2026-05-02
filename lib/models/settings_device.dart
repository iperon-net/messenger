import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'freezed_convertor.dart';

part 'settings_device.freezed.dart';
part 'settings_device.g.dart';

enum SettingsDeviceThemeColor { blue, green,  purple }
enum SettingsDeviceDarkMode { system, disabled, alwaysOn }

@freezed
abstract class SettingsDevice with _$SettingsDevice {
  const SettingsDevice._();

  const factory SettingsDevice({
    required String language,
    required SettingsDeviceDarkMode darkMode,
    required SettingsDeviceThemeColor themeColor,
    @BoolConverter() required bool blurTaskSwitchingEnable,
  }) = _SettingsDevice;

  factory SettingsDevice.fromJson(Map<String, dynamic> json) => _$SettingsDeviceFromJson(json);

  Map<String, dynamic> toSqlite() => toJson();
  factory SettingsDevice.fromSqlite(Map<String, dynamic> data) => SettingsDevice.fromJson(data);
}

