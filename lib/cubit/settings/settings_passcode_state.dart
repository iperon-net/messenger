import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_passcode_state.mapper.dart';

@MappableClass()
class SettingsPasscodeState with SettingsPasscodeStateMappable {
  final Status status;
  final List<int> passcode;
  final bool unlocked;
  final int autoLockSeconds;
  final bool isBiometric;
  final bool isBiometricAvailable;

  const SettingsPasscodeState({
    this.status = Status.initialization,
    this.passcode = const [],
    this.unlocked = false,
    this.autoLockSeconds = 0,
    this.isBiometric = false,
    this.isBiometricAvailable = false,
  });
}
