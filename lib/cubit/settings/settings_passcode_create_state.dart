import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_passcode_create_state.mapper.dart';

@MappableClass()
class SettingsPasscodeCreateState with SettingsPasscodeCreateStateMappable {
  final Status status;
  final List<int> passcode;

  const SettingsPasscodeCreateState({this.status = Status.initialization, this.passcode = const []});
}
