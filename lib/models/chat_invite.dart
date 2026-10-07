import 'package:dart_mappable/dart_mappable.dart';

part 'chat_invite.mapper.dart';

/// Ссылка-приглашение группы/канала/сообщества (профиль чата → «Ссылки-
/// приглашения»). [primary] — основная (она же `Chat.inviteLink`), её можно
/// только заменить; дополнительные админ создаёт сам — с названием, сроком,
/// лимитом вступлений и/или одобрением заявок.
@MappableClass()
class ChatInviteLink with ChatInviteLinkMappable {
  final String id;

  /// Путь ссылки после `iperon.net/` (`+код`).
  final String link;

  /// Название для админов («Для подрядчиков»); пусто — показывается сама ссылка.
  final String title;

  final bool primary;

  /// Отозвана: по ней больше не вступить, лежит в «Отозванных».
  final bool revoked;

  /// Действует до (`null` — бессрочно).
  final DateTime? expireDate;

  /// Сколько человек может вступить (0 — без ограничений).
  final int usageLimit;

  /// Сколько уже вступило.
  final int usage;

  /// Вступление по ссылке — через заявку, которую одобряет админ.
  final bool requestApproval;

  final DateTime createdAt;

  const ChatInviteLink({
    required this.id,
    required this.link,
    this.title = '',
    this.primary = false,
    this.revoked = false,
    this.expireDate,
    this.usageLimit = 0,
    this.usage = 0,
    this.requestApproval = false,
    required this.createdAt,
  });

  bool isExpired(DateTime now) => expireDate != null && !expireDate!.isAfter(now);

  bool get isExhausted => usageLimit > 0 && usage >= usageLimit;

  /// По ссылке сейчас можно вступить.
  bool isActive(DateTime now) => !revoked && !isExpired(now) && !isExhausted;
}

/// Заявка на вступление (профиль чата → «Заявки на вступление»).
@MappableClass()
class ChatJoinRequest with ChatJoinRequestMappable {
  /// id пользователя.
  final String userID;
  final String name;

  /// «О себе» — помогает админу решить.
  final String about;

  final DateTime date;

  /// Ссылка, по которой пришла заявка ([linkTitle] — её название; пусто —
  /// основная или без названия).
  final String linkID;
  final String linkTitle;

  const ChatJoinRequest({
    required this.userID,
    required this.name,
    this.about = '',
    required this.date,
    this.linkID = '',
    this.linkTitle = '',
  });
}
