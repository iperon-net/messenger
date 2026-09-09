import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models/mapper.dart';

import '../../constants.dart';

part 'profile_state.mapper.dart';

@MappableClass(includeCustomMappers: [Uint8ListMapper()])
class ProfileState with ProfileStateMappable {
  final Status status;
  final String error;

  final AppLocale locale;

  final String firstName;
  final String lastName;
  final String aboutMe;
  final DateTime? birthDate;
  final String username;
  final String phoneNumber;

  final String boringAvatarHash;
  final BoringAvatarType boringAvatarType;

  /// Расшифрованный аватар для показа. `null`, пока не скачан/не задан.
  final Uint8List? avatarBytes;

  const ProfileState({
    this.status = Status.initialization,
    this.error = "",
    this.locale = AppLocale.en,

    this.firstName = "",
    this.lastName = "",
    this.aboutMe = "",
    this.birthDate,
    this.username = "",
    this.phoneNumber = "",

    this.boringAvatarHash = "",
    this.boringAvatarType = BoringAvatarType.ring,
    this.avatarBytes,
  });
}
