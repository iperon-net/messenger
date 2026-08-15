import 'package:dart_mappable/dart_mappable.dart';

part 'device_info.mapper.dart';

@MappableEnum()
enum OS { iOS, android }

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
