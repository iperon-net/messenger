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

  /// Присутствие (заполняется PRESENCE-запросом, см. ContactsCubit): сейчас в
  /// сети и время последнего онлайна. `lastSeen == null` — статус ещё неизвестен
  /// (пока не пришёл ответ) либо пользователь никогда не подключался.
  final bool online;
  final DateTime? lastSeen;

  const ContactItem({
    required this.displayName,
    required this.phone,
    required this.phoneE164,
    this.userID,
    this.online = false,
    this.lastSeen,
  });

  bool get isRegistered => userID != null;
}

@MappableClass()
class ContactsState with ContactsStateMappable {
  final Status status;
  final String error;

  /// Разрешение на чтение книги отклонено — показываем экран-объяснение.
  final bool permissionDenied;

  /// Из телефонной книги: найденные в Iperon ([registered]) и остальные — для
  /// приглашения ([invitable]). [cloud] — добавленные вручную «облачные» контакты
  /// (источник MANUAL), которых нет в книге устройства; они могут быть как
  /// зарегистрированы, так и ещё нет.
  final List<ContactItem> registered;
  final List<ContactItem> invitable;
  final List<ContactItem> cloud;

  /// Текущий поисковый запрос (фильтрация в UI).
  final String query;

  const ContactsState({
    this.status = Status.initialization,
    this.error = "",
    this.permissionDenied = false,
    this.registered = const [],
    this.invitable = const [],
    this.cloud = const [],
    this.query = "",
  });
}
