import 'package:dart_mappable/dart_mappable.dart';

import '../../models.dart' as models;

part 'settings_device_sessions_state.mapper.dart';

@MappableClass()
class SettingsDeviceSessionsState with SettingsDeviceSessionsStateMappable {
  final List<models.DeviceSession> deviceSessions;

  const SettingsDeviceSessionsState({
    this.deviceSessions = const [],
  });


}
