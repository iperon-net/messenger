import 'package:dart_mappable/dart_mappable.dart';

import 'mapper.dart';

part 'device_sessions.mapper.dart';

@MappableClass(includeCustomMappers: [BoolMapper()])
class DeviceSession with DeviceSessionMappable {
  final String deviceModel;
  final String osVersion;
  final String appVersion;
  final String appBuildNumber;
  final String locationRussian;
  final String locationEnglish;
  final DateTime updateAt;

  DeviceSession({
    this.deviceModel = "",
    this.osVersion = "",
    this.appVersion = "",
    this.appBuildNumber = "",
    this.locationRussian = "",
    this.locationEnglish = "",
    DateTime? updateAt,
  }) : updateAt = updateAt ?? DateTime.fromMicrosecondsSinceEpoch(0);

  @override
  String toString() {
    return "device deviceModel=$deviceModel osVersion=$osVersion, appVersion=$appVersion, appBuildNumber=$appBuildNumber, "
        "locationRussian=$locationRussian, locationEnglish=$locationEnglish";
  }

}
