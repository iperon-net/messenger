import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

import '../../constants.dart';
import '../../i18n/translations.g.dart';

part 'settings_my_profile_edit_state.mapper.dart';

@MappableClass()
class SettingsMyProfileEditState with SettingsMyProfileEditStateMappable {
  final Status status;
  final Status networkStatus;
  final String error;
  final String redirectURI;

  final String firstName;
  final String lastName;
  final String aboutMe;
  final DateTime? birthDate;

  final AppLocale locale;

  final String boringAvatarHash;
  final BoringAvatarType boringAvatarType;
  final int aboutMeLength;

  const SettingsMyProfileEditState({
    this.status = Status.initialization,
    this.networkStatus = Status.initialization,
    this.error = "",
    this.redirectURI = "",

    this.firstName = "",
    this.lastName = "",
    this.aboutMe = "",
    this.birthDate,

    this.locale = AppLocale.en,

    this.boringAvatarHash = "",
    this.boringAvatarType = BoringAvatarType.ring,
    this.aboutMeLength = 0,
  });
}
