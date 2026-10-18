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

  /// Сырые байты ObjectID пользователя, чей профиль показываем. Нужны, чтобы с
  /// экрана можно было инициировать звонок (`Calls.startCall`).
  final List<int> userID;

  /// Имя по общему правилу (как я его записал → профиль → @username → номер)
  /// — заголовок под аватаром; поля профиля ниже — его настоящие данные.
  final String displayName;

  final String firstName;
  final String lastName;
  final String aboutMe;
  final DateTime? birthDate;

  /// Владелец скрыл год рождения: [birthDate] с обнулённым годом (sentinel),
  /// показываем только день и месяц, без возраста.
  final bool hideBirthYear;

  final String username;
  final String phoneNumber;

  final String boringAvatarHash;
  final BoringAvatarType boringAvatarType;

  /// Расшифрованный аватар для показа. `null`, пока не скачан/не задан.
  final Uint8List? avatarBytes;

  /// Показывать «Начать секретный чат»: фича включена (Remote Config) и, если
  /// она только для Premium, у меня Premium (кэш MY_PROFILE).
  final bool secretChatAvailable;

  /// Идёт создание секретного чата (кнопка неактивна).
  final bool secretChatStarting;

  const ProfileState({
    this.status = Status.initialization,
    this.error = "",
    this.locale = AppLocale.en,
    this.userID = const [],

    this.displayName = "",
    this.firstName = "",
    this.lastName = "",
    this.aboutMe = "",
    this.birthDate,
    this.hideBirthYear = false,
    this.username = "",
    this.phoneNumber = "",

    this.boringAvatarHash = "",
    this.boringAvatarType = BoringAvatarType.ring,
    this.avatarBytes,
    this.secretChatAvailable = false,
    this.secretChatStarting = false,
  });
}
