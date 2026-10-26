import 'package:dart_mappable/dart_mappable.dart';

part 'device_info.mapper.dart';

@MappableEnum()
enum OS { iOS, android, macOS, windows }

/// Код ОС в сессии (`os` в AuthConfirmation / DeviceSessions; сервер хранит
/// как есть): 1 — iOS, 2 — Android, 3 — macOS, 4 — Windows.
String osName(int code) => switch (code) {
  1 => 'iOS',
  2 => 'Android',
  3 => 'macOS',
  4 => 'Windows',
  _ => '',
};

/// «iOS 18.1» по коду ОС и версии; без известной ОС — только версия.
String osWithVersion(int code, String version) => [osName(code), version].where((part) => part.isNotEmpty).join(' ');

@MappableClass()
class DeviceInfoModel with DeviceInfoModelMappable {
  final String deviceModel;
  final OS os;
  final int osCode;
  final String osVersion;
  final bool isPhysicalDevice;

  const DeviceInfoModel({
    required this.deviceModel,
    required this.os,
    required this.osCode,
    required this.osVersion,
    required this.isPhysicalDevice,
  });
}
