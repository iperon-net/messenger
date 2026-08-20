import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

import '../../constants.dart';

part 'settings_profile_state.mapper.dart';

@MappableClass()
class SettingsProfileState with SettingsProfileStateMappable {
  final Status status;
  final String boringAvatarHash;
  final BoringAvatarType boringAvatarType;

  const SettingsProfileState({
    this.status = Status.initialization,
    this.boringAvatarHash = "",
    this.boringAvatarType = BoringAvatarType.ring,
  });
}
