import 'package:dart_mappable/dart_mappable.dart';

part 'chat.mapper.dart';

/// Тип чата (см. docs/plans/chats-groups-channels.md). Сообщество — контейнер
/// над группами и каналами; в списке чатов показывается одной строкой.
@MappableEnum()
enum ChatType { private, group, channel, community }

/// Статус исходящего сообщения: ⏱ отправляется → ✓ на сервере → ✓✓ прочитано.
@MappableEnum()
enum MessageStatus { pending, sent, read }

/// Вид последнего сообщения — для превью в списке («Фото», «Файл» …).
@MappableEnum()
enum MessageKind { text, photo, video, file, voice }

/// Какие реакции разрешены в группе/канале (настраивает админ, см.
/// docs/plans/chats-groups-channels.md, «Реакции»). В личных чатах — всегда
/// фиксированный набор.
@MappableEnum()
enum ChatReactionsMode { all, some, none }

/// Роль в группе/канале (см. docs/plans/chats-groups-channels.md, «Приватность
/// групп»): по возрастанию прав. В канале подписчик — [reader].
@MappableEnum()
enum ChatRole { reader, writer, admin, owner }

/// Как вступить в группу/сообщество (см. docs/plans/chats-groups-channels.md,
/// «Приватность групп»): [open] — публичная, находится поиском по username,
/// вступает любой; [link] — по ссылке-приглашению; [request] — по ссылке, но
/// после одобрения админом; [admins] — только админ добавляет. У канала —
/// только [open] (публичный) / [link] (частный).
@MappableEnum()
enum ChatJoinMode { open, link, request, admins }

/// Права админа — раздельные, как в Telegram (см.
/// docs/plans/chats-groups-channels.md, «Приватность групп»). Набор в UI
/// зависит от типа: у группы/сообщества — без [postMessages] / [editMessages],
/// у канала — без [banUsers] / [pinMessages] / [anonymous]. Владелец имеет все
/// права всегда ([all]).
@MappableClass()
class ChatAdminRights with ChatAdminRightsMappable {
  /// Название, описание, фото и настройки (вступление, реакции, ссылки).
  final bool changeInfo;
  final bool postMessages;
  final bool editMessages;
  final bool deleteMessages;

  /// Блокировать и ограничивать участников (в т.ч. «Чтение» / «Запись»).
  final bool banUsers;

  /// Приглашать участников, ссылки-приглашения, заявки.
  final bool inviteUsers;
  final bool pinMessages;

  /// Голосовые/видеочаты и трансляции (LiveKit).
  final bool manageCalls;

  /// Сообщения от имени группы.
  final bool anonymous;

  /// Назначать админов — с правами не шире своих.
  final bool addAdmins;

  const ChatAdminRights({
    this.changeInfo = false,
    this.postMessages = false,
    this.editMessages = false,
    this.deleteMessages = false,
    this.banUsers = false,
    this.inviteUsers = false,
    this.pinMessages = false,
    this.manageCalls = false,
    this.anonymous = false,
    this.addAdmins = false,
  });

  static const all = ChatAdminRights(
    changeInfo: true,
    postMessages: true,
    editMessages: true,
    deleteMessages: true,
    banUsers: true,
    inviteUsers: true,
    pinMessages: true,
    manageCalls: true,
    anonymous: true,
    addAdmins: true,
  );

  /// Новому админу по умолчанию — всё, кроме анонимности и назначения админов.
  static const standard = ChatAdminRights(
    changeInfo: true,
    postMessages: true,
    editMessages: true,
    deleteMessages: true,
    banUsers: true,
    inviteUsers: true,
    pinMessages: true,
    manageCalls: true,
  );

  List<bool> get _flags => [
    changeInfo,
    postMessages,
    editMessages,
    deleteMessages,
    banUsers,
    inviteUsers,
    pinMessages,
    manageCalls,
    anonymous,
    addAdmins,
  ];

  /// Все права [other] есть и у этих (выдать можно только не шире своих).
  bool covers(ChatAdminRights other) {
    final mine = _flags;
    final theirs = other._flags;
    for (var i = 0; i < mine.length; i++) {
      if (theirs[i] && !mine[i]) return false;
    }
    return true;
  }
}

/// Участник группы (профиль чата → «Участники»).
@MappableClass()
class ChatMember with ChatMemberMappable {
  final String id;
  final String name;
  final ChatRole role;

  /// Сейчас в сети; иначе — [lastSeen] (`null` — давно / скрыто).
  final bool online;
  final DateTime? lastSeen;

  /// Это мы.
  final bool isSelf;

  /// Права — у [ChatRole.admin] (у владельца — все, см. [effectiveRights]).
  final ChatAdminRights rights;

  /// «Звание» админа — подпись вместо «админ» (пусто — «админ»).
  final String rank;

  const ChatMember({
    required this.id,
    required this.name,
    this.role = ChatRole.writer,
    this.online = false,
    this.lastSeen,
    this.isSelf = false,
    this.rights = const ChatAdminRights(),
    this.rank = '',
  });

  /// Права с учётом роли: владелец — все, не админ — никаких.
  ChatAdminRights get effectiveRights => switch (role) {
    ChatRole.owner => ChatAdminRights.all,
    ChatRole.admin => rights,
    _ => const ChatAdminRights(),
  };
}

/// Последнее сообщение чата в том виде, в каком оно нужно списку чатов.
@MappableClass()
class ChatLastMessage with ChatLastMessageMappable {
  final MessageKind kind;

  /// Плоский текст (без разметки). Для медиа — подпись, может быть пустой.
  final String text;

  /// Имя автора — показывается в группах/сообществах («Анна: текст»).
  final String senderName;

  /// Исходящее (наше) — рядом с датой рисуются галочки [status].
  final bool outgoing;

  final MessageStatus status;
  final DateTime date;

  const ChatLastMessage({
    this.kind = MessageKind.text,
    this.text = '',
    this.senderName = '',
    this.outgoing = false,
    this.status = MessageStatus.sent,
    required this.date,
  });
}

/// Строка списка чатов (диалог). Пока клиентская модель для UX-демо; позже
/// заполняется из SQLite-кэша, синхронизируемого с сервером.
@MappableClass()
class Chat with ChatMappable {
  final String id;
  final ChatType type;
  final String title;

  /// Собеседник личного чата — в контактах (для правил папок «Контакты» /
  /// «Не контакты»).
  final bool isContact;

  /// «Избранное» — чат с самим собой (иконка-закладка вместо аватара).
  final bool isSelf;

  final ChatLastMessage? lastMessage;

  /// Непрочитанные сообщения.
  final int unreadCount;

  /// Непрочитанные упоминания (@) — отдельный бейдж.
  final int unreadMentions;

  /// Помечен «непрочитанным» вручную (без счётчика).
  final bool markedUnread;

  final bool muted;
  final bool pinned;
  final bool archived;

  /// Черновик — показывается вместо последнего сообщения.
  final String draft;

  /// Кто печатает: пусто — никто; в личном чате достаточно непустого значения,
  /// в группе — имя («Анна печатает…»).
  final String typing;

  /// Реакции группы/канала: все, выбранные ([reactions]) или никаких.
  final ChatReactionsMode reactionsMode;
  final List<String> reactions;

  /// Профиль чата: «О себе» собеседника / описание группы или канала.
  final String about;

  /// Публичное имя (@username) — у пользователя или публичной группы/канала.
  final String username;

  /// Ссылка-приглашение частной группы/канала/сообщества (`+код`, ссылка —
  /// `iperon.net/+код`); у публичных — пусто, ссылка по [username].
  final String inviteLink;

  /// Аватар чата — локальный файл (пока только у созданных в демо; настоящие
  /// аватарки придут с сервера по `cdnID`). Пусто — генеративный плейсхолдер.
  final String avatarPath;

  /// Как вступить (группа/сообщество) / публичный ли канал.
  final ChatJoinMode joinMode;

  /// Роль, которую получает вступивший в группу/сообщество: [ChatRole.reader]
  /// или [ChatRole.writer] (в канале подписчик всегда читатель).
  final ChatRole defaultRole;

  /// Заявок на вступление ждёт одобрения (бейдж в профиле для админа).
  final int pendingRequests;

  /// Участников группы / подписчиков канала (0 — личный чат).
  final int membersCount;

  /// Наша роль в группе/канале (в личном чате не важна).
  final ChatRole myRole;

  /// Собеседник в сети (личный чат); иначе — [lastSeen].
  final bool online;
  final DateTime? lastSeen;

  /// Когда чат появился у нас (создан / открыт впервые) — для сортировки, пока
  /// в нём нет сообщений.
  final DateTime? createdAt;

  const Chat({
    required this.id,
    required this.type,
    required this.title,
    this.isContact = false,
    this.isSelf = false,
    this.lastMessage,
    this.unreadCount = 0,
    this.unreadMentions = 0,
    this.markedUnread = false,
    this.muted = false,
    this.pinned = false,
    this.archived = false,
    this.draft = '',
    this.typing = '',
    this.reactionsMode = ChatReactionsMode.all,
    this.reactions = const [],
    this.about = '',
    this.username = '',
    this.inviteLink = '',
    this.avatarPath = '',
    this.joinMode = ChatJoinMode.link,
    this.defaultRole = ChatRole.reader,
    this.pendingRequests = 0,
    this.membersCount = 0,
    this.myRole = ChatRole.writer,
    this.online = false,
    this.lastSeen,
    this.createdAt,
  });

  /// Админ или владелец — может менять настройки группы/канала.
  bool get canManage => myRole == ChatRole.admin || myRole == ChatRole.owner;

  /// Путь ссылки на чат после `iperon.net/`: публичный [username] или
  /// [inviteLink] (если по ссылкам можно вступить); пусто — ссылки нет.
  String get linkPath => username.isNotEmpty ? username : (joinMode == ChatJoinMode.admins ? '' : inviteLink);

  bool get hasUnread => unreadCount > 0 || markedUnread;

  /// Дата для сортировки (последнее сообщение).
  DateTime get sortDate => lastMessage?.date ?? createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  /// Личный чат, в котором ещё ничего нет (открыли из «Нового сообщения» и
  /// ничего не отправили) — в списке не показывается, как в Telegram.
  bool get isBlank => type == ChatType.private && !isSelf && lastMessage == null && draft.isEmpty;
}
