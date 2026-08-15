import 'package:dart_mappable/dart_mappable.dart';

import '../constants.dart';
import '../models.dart';

part 'common_state.mapper.dart';

@MappableClass()
class CommonState with CommonStateMappable {
  final Status status;
  final SettingsDeviceModel settingsDevice;
  final bool isLocked;

  const CommonState({
    this.status = Status.initialization,
    required this.settingsDevice,
    this.isLocked = false,
  });
}
