import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';


part 'device_sessions.mapper.dart';

@MappableClass()
class DeviceSessionsModel with DeviceSessionsModelMappable {
  final Uint8List sessionID;
  final bool isCurrent;
  final DateTime updateAt;
  final String deviceModel;
  final int os;
  final String osVersion;
  final String appVersion;
  final String appBuildNumber;
  final String locationEnglish;
  final String locationRussian;

  DeviceSessionsModel({
    required this.sessionID,
    this.isCurrent = false,
    DateTime? updateAt,
    this.deviceModel = '',
    this.os = 0,
    this.osVersion = '',
    this.appVersion = '',
    this.appBuildNumber = '',
    this.locationEnglish = '',
    this.locationRussian = '',
  }) : updateAt = updateAt ?? DateTime.fromMicrosecondsSinceEpoch(0);
}
