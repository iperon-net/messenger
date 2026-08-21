import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

import '../../constants.dart';

part 'settings_my_profile_state.mapper.dart';

@MappableClass()
class SettingsMyProfileState with SettingsMyProfileStateMappable {
  final Status status;
  final String boringAvatarHash;
  final BoringAvatarType boringAvatarType;

  const SettingsMyProfileState({
    this.status = Status.initialization,
    this.boringAvatarHash = "",
    this.boringAvatarType = BoringAvatarType.ring,
  });
}
