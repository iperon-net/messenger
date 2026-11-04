import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart';

part 'settings_device_sessions_state.mapper.dart';

@MappableClass()
class SettingsDeviceSessionsState with SettingsDeviceSessionsStateMappable {
  final Status status;
  final Status requestStatus;
  final String error;
  final List<DeviceSessionsModel> deviceSessions;

  const SettingsDeviceSessionsState({
    this.status = Status.initialization,
    this.deviceSessions = const <DeviceSessionsModel>[],
    this.requestStatus = Status.initialization,
    this.error = '',
  });
}
