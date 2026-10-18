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

  /// «В сети» и время захода — из [ChatsPresence] и кэша профилей
  /// (`lastSeen == null` — скрыто или неизвестно: «был(а) недавно»).
  final bool online;
  final DateTime? lastSeen;

  /// Личный чат с этим пользователем, если переписка уже есть (локально) —
  /// тогда в профиле его секции: звук, медиа, «Ещё». Пусто — чата нет.
  final String chatID;

  /// Чат искали ([chatID] уже достоверен) — до этого секции чата не рисуем,
  /// чтобы экран не перестраивался.
  final bool chatResolved;

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
    this.online = false,
    this.lastSeen,
    this.chatID = "",
    this.chatResolved = false,
  });
}
