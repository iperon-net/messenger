import 'package:dart_mappable/dart_mappable.dart';

part 'chat.mapper.dart';

/// Тип чата (см. docs/plans/chats-groups-channels.md). Сообщество — страница
/// организации и контейнер над её группами и каналами ([Chat.communityID]);
/// своей ленты у него нет, в списке чатов — одной строкой.
@MappableEnum()
enum ChatType { private, group, channel, community }

/// Статус исходящего сообщения: ⏱ отправляется → ✓ на сервере → ✓✓ прочитано.
@MappableEnum()
enum MessageStatus { pending, sent, read }

/// Вид последнего сообщения — для превью в списке («Фото», «Файл» …).
@MappableEnum()
enum MessageKind { text, photo, video, file, voice, poll }

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

/// Канал: кто может комментировать посты — все, кто видит пост, или только
/// подписчики (с [Chat.commentsMinSubscription] — подписанные не меньше срока).
@MappableEnum()
enum ChatCommentsWho { all, subscribers }

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

  /// Публичное имя (@username) — для упоминаний; пусто — упоминают по имени.
  final String username;
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

  /// Чат сообщества: [role] и [rights] — от сообщества (его владелец и админы
  /// — владелец и админы во всех его чатах), в самом чате их не изменить.
  final bool fromCommunity;

  const ChatMember({
    required this.id,
    required this.name,
    this.username = '',
    this.role = ChatRole.writer,
    this.online = false,
    this.lastSeen,
    this.isSelf = false,
    this.rights = const ChatAdminRights(),
    this.rank = '',
    this.fromCommunity = false,
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

  /// Строка сообщества: из какого его чата сообщение («Группа › Анна»); пусто
  /// — у обычных чатов и у канала объявлений.
  final String chatTitle;

  const ChatLastMessage({
    this.kind = MessageKind.text,
    this.text = '',
    this.senderName = '',
    this.outgoing = false,
    this.status = MessageStatus.sent,
    required this.date,
    this.chatTitle = '',
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

  /// Уведомления выключены до этого времени (`null` при [muted] — навсегда);
  /// по истечении чат включается сам.
  final DateTime? mutedUntil;
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

  /// Канал: сколько разных реакций может быть под постом (1–11, как в
  /// Telegram); набрано — ставить можно только уже стоящие.
  final int maxReactions;

  /// Медленный режим группы/сообщества: участник (не админ) отправляет не
  /// чаще одного сообщения за столько секунд; 0 — выключен.
  final int slowMode;

  /// Медленный режим: когда нам можно отправить следующее сообщение (сервер
  /// ставит после нашей отправки); `null` / в прошлом — можно сейчас.
  final DateTime? slowModeUntil;

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

  /// Обложка сообщества — фон шапки его страницы (локальный файл, как
  /// [avatarPath]). Пусто — генеративный фон.
  final String coverPath;

  /// Контакты заведения сообщества: телефон (как ввели, показывается
  /// отформатированным), адрес и координаты — по ним маршрут в Яндекс Картах
  /// и 2ГИС (`null` — не заданы).
  final String phone;
  final String address;
  final double? latitude;
  final double? longitude;

  /// Как вступить (группа/сообщество) / публичный ли канал.
  final ChatJoinMode joinMode;

  /// Роль, которую получает вступивший в группу/сообщество: [ChatRole.reader]
  /// или [ChatRole.writer] (в канале подписчик всегда читатель).
  final ChatRole defaultRole;

  /// Канал: под постами — комментарии (обсуждение каждого поста).
  final bool commentsEnabled;

  /// Канал: сколько секунд после публикации под постом можно комментировать
  /// (0 — без ограничения); действует на новые посты — срок записывается в
  /// пост (`Message.commentsCloseDate`).
  final int commentsTimeLimit;

  /// Ветка комментариев ([isThread]): когда закрывается (срок поста или админ
  /// закрыл досрочно); `null` — открыта бессрочно. После — только чтение.
  final DateTime? commentsCloseDate;

  /// Канал: кто может комментировать. Читать комментарии могут все, кто видит
  /// пост; админов канала ограничения не касаются.
  final ChatCommentsWho commentsWho;

  /// Канал, [ChatCommentsWho.subscribers]: комментировать — только подписанным
  /// не меньше стольких секунд (защита от спама «подписался и пишет»); 0 —
  /// без ограничения.
  final int commentsMinSubscription;

  /// Группа/сообщество и комментарии канала: «Новичкам — без ссылок и медиа»
  /// — вступившие (в канале — подписавшиеся; не подписанные — всегда) меньше
  /// стольких секунд назад пишут только текст; 0 — выключено. Админов не
  /// касается.
  final int newcomerMediaDelay;

  /// Когда мы вступили / подписались (`null` — давно, до учёта): для
  /// [commentsMinSubscription].
  final DateTime? joinedAt;

  /// Канал: под постами — имя опубликовавшего админа.
  final bool signMessages;

  /// Список участников / подписчиков виден только админам (вкладку в профиле
  /// остальные не видят).
  final bool membersHidden;

  /// Мы участник / подписчик. `false` — открыли по ссылке и смотрим: в списке
  /// чата нет, внизу — «Подписаться» / «Вступить».
  final bool isMember;

  /// Подали заявку на вступление (чат «По заявке»), ждём одобрения.
  final bool joinRequested;

  /// Обсуждение поста канала — скрытый чат-ветка (в списке не виден): id
  /// канала и поста. Пусто — обычный чат.
  final String threadOf;
  final String threadPostID;

  /// Группа / канал сообщества — id сообщества (задаётся при создании и не
  /// меняется: прикреплять чаты извне и выносить наружу нельзя). Пусто —
  /// обычный чат. В общем списке такие чаты не видны — только внутри
  /// сообщества.
  final String communityID;

  /// Канал объявлений сообщества — создаётся вместе с ним, покинуть или
  /// удалить его отдельно нельзя.
  final bool announcements;

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
    this.mutedUntil,
    this.pinned = false,
    this.archived = false,
    this.draft = '',
    this.typing = '',
    this.reactionsMode = ChatReactionsMode.all,
    this.reactions = const [],
    this.maxReactions = 11,
    this.slowMode = 0,
    this.slowModeUntil,
    this.about = '',
    this.username = '',
    this.inviteLink = '',
    this.avatarPath = '',
    this.coverPath = '',
    this.phone = '',
    this.address = '',
    this.latitude,
    this.longitude,
    this.joinMode = ChatJoinMode.link,
    this.defaultRole = ChatRole.reader,
    this.pendingRequests = 0,
    this.commentsEnabled = false,
    this.commentsTimeLimit = 0,
    this.commentsCloseDate,
    this.commentsWho = ChatCommentsWho.all,
    this.commentsMinSubscription = 0,
    this.joinedAt,
    this.newcomerMediaDelay = 0,
    this.signMessages = false,
    this.membersHidden = false,
    this.isMember = true,
    this.joinRequested = false,
    this.threadOf = '',
    this.threadPostID = '',
    this.communityID = '',
    this.announcements = false,
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
  /// У чатов сообщества своих ссылок нет — вступают через сообщество.
  String get linkPath => inCommunity ? '' : (username.isNotEmpty ? username : (joinMode == ChatJoinMode.admins ? '' : inviteLink));

  /// Группа / канал внутри сообщества.
  bool get inCommunity => communityID.isNotEmpty;

  bool get hasUnread => unreadCount > 0 || markedUnread;

  /// Дата для сортировки (последнее сообщение).
  DateTime get sortDate => lastMessage?.date ?? createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  /// Личный чат, в котором ещё ничего нет (открыли из «Нового сообщения» и
  /// ничего не отправили) — в списке не показывается, как в Telegram.
  bool get isBlank => type == ChatType.private && !isSelf && lastMessage == null && draft.isEmpty;

  /// Комментарии к посту канала.
  bool get isThread => threadOf.isNotEmpty;

  /// Ветка комментариев закрыта: писать нельзя, только читать.
  bool commentsClosed([DateTime? now]) => commentsCloseDate != null && !commentsCloseDate!.isAfter(now ?? DateTime.now());

  /// В списке чатов не показывается: пустой личный, ветка комментариев, чат
  /// сообщества (он внутри строки сообщества).
  bool get hiddenInList => isBlank || isThread || !isMember || inCommunity;

  /// Медленный режим действует на нас: включён в группе/сообществе, а мы не
  /// админ.
  bool get slowModeApplies => slowMode > 0 && (type == ChatType.group || type == ChatType.community) && !canManage;

  /// Можно писать: не канал, либо админ/владелец канала (публикует посты).
  bool get canPost => isMember && (type != ChatType.channel || canManage);
}
