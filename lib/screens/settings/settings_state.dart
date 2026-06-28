import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_state.mapper.dart';

@MappableClass()
class SettingsState with SettingsStateMappable {
  final Status status;
  final String error;
  final bool logout;
  final int deviceCount;

  const SettingsState({
    this.status = Status.initialization,
    this.error = "",
    this.logout = false,
    this.deviceCount = 0,
  });
}
