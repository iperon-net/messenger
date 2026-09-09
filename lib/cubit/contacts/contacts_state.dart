import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/models/mapper.dart';

import '../../constants.dart';

part 'contacts_state.mapper.dart';

/// Один контакт из телефонной книги. [userID] задан только для зарегистрированных
/// в Iperon (найденных по OPRF); у остальных — `null` (их можно пригласить).
@MappableClass(includeCustomMappers: [Uint8ListMapper()])
class ContactItem with ContactItemMappable {
  /// Отображаемое имя из книги (или сам номер, если имени нет).
  final String displayName;

  /// Номер в международном формате для показа.
  final String phone;

  /// Канонический e164 — ключ кэша и цель приглашения.
  final String phoneE164;

  /// userID зарегистрированного пользователя (сырые байты ObjectID) или `null`.
  final Uint8List? userID;

  const ContactItem({required this.displayName, required this.phone, required this.phoneE164, this.userID});

  bool get isRegistered => userID != null;
}

@MappableClass()
class ContactsState with ContactsStateMappable {
  final Status status;
  final String error;

  /// Разрешение на чтение книги отклонено — показываем экран-объяснение.
  final bool permissionDenied;

  /// Найденные в Iperon (сверху) и остальные — для приглашения.
  final List<ContactItem> registered;
  final List<ContactItem> invitable;

  /// Текущий поисковый запрос (фильтрация в UI).
  final String query;

  const ContactsState({
    this.status = Status.initialization,
    this.error = "",
    this.permissionDenied = false,
    this.registered = const [],
    this.invitable = const [],
    this.query = "",
  });
}
