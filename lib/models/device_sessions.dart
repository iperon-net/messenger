import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';

part 'device_sessions.mapper.dart';

@MappableClass(includeCustomMappers: [BoolMapper()])
class DeviceSession with DeviceSessionMappable {
  final List<int> sessionID;
  final String deviceModel;
  final String osVersion;
  final int os;
  final String appVersion;
  final String appBuildNumber;
  final String locationRussian;
  final String locationEnglish;
  final DateTime updateAt;
  final bool isCurrent;

  DeviceSession({
    this.sessionID = const [],
    this.deviceModel = "",
    this.osVersion = "",
    this.os = 0,
    this.appVersion = "",
    this.appBuildNumber = "",
    this.locationRussian = "",
    this.locationEnglish = "",
    this.isCurrent = false,
    DateTime? updateAt,
  }) : updateAt = updateAt ?? DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  String toString() {
    return "device isCurrent=$isCurrent, deviceModel=$deviceModel osVersion=$osVersion, appVersion=$appVersion, appBuildNumber=$appBuildNumber, "
        "locationRussian=$locationRussian, locationEnglish=$locationEnglish";
  }

}
