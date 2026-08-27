import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:messenger/i18n/translations.g.dart';

import '../../constants.dart';

part 'settings_my_profile_state.mapper.dart';

@MappableClass()
class SettingsMyProfileState with SettingsMyProfileStateMappable {
  final Status status;
  final Status networkStatus;
  final String error;
  final String redirectURI;

  final AppLocale locale;

  final String firstName;
  final String lastName;
  final String aboutMe;
  final DateTime? birthDate;
  final String username;

  final String boringAvatarHash;
  final BoringAvatarType boringAvatarType;
  final int aboutMeLength;

  const SettingsMyProfileState({
    this.status = Status.initialization,
    this.networkStatus = Status.initialization,
    this.error = "",
    this.redirectURI = "",
    this.locale = AppLocale.en,

    this.firstName = "",
    this.lastName = "",
    this.aboutMe = "",
    this.birthDate,
    this.username = "",

    this.boringAvatarHash = "",
    this.boringAvatarType = BoringAvatarType.ring,
    this.aboutMeLength = 0,
  });
}
