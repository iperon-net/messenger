import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_profile_state.mapper.dart';

@MappableClass()
class SettingsProfileState with SettingsProfileStateMappable {
  final Status status;

  const SettingsProfileState({this.status = Status.initialization});
}
