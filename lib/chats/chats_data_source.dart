import '../models.dart' as models;
import 'reactions_list.dart';
import 'read_receipts.dart';

/// Источник данных списка чатов. UI и cubit'ы работают только через него: сейчас
/// единственная реализация — [ChatsDemoDataSource] (фейковые данные для UX-демо,
/// включается на экране «Разработчик»), позже появится реализация на SQLite +
/// gRPC, а экраны не изменятся. См. docs/plans/chats-groups-channels.md.
/// Страница списка участников ([ChatsDataSource.membersPage]).
class ChatMembersPage {
  final List<models.ChatMember> members;

  /// Курсор следующей страницы; пусто — это последняя.
  final String nextCursor;

  /// Всего участников (для подписи); у скрытого списка не админу — сколько
  /// ему видно.
  final int total;

  const ChatMembersPage({required this.members, required this.nextCursor, required this.total});
}

/// Чем закончился запрос страницы поиска на сервере
/// ([ChatsDataSource.searchMessagesOnServer]).
enum ServerSearchStatus {
  /// Ответ есть ([ServerSearchPage.ids], может быть пустым).
  ok,

  /// Сервер не ищет по такому запросу (пустой / одни стоп-слова,
  /// `QUERY_TOO_SHORT`) — показываем локальное, без ошибки.
  tooShort,

  /// Нет сети — показаны только сообщения на устройстве; появится сеть —
  /// спросить снова.
  offline,

  /// Сервер не спрашиваем: история чата на устройстве полная, источник не
  /// умеет (демо, предпросмотр), сервер отказал. Без пометки.
  skipped,
}

/// Страница результатов поиска на сервере.
class ServerSearchPage {
  /// id найденных — от новых к старым (уже в кэше, см.
  /// `ChatsRepository.applySearchHits`).
  final List<String> ids;

  /// Продолжение — искать старше этого id; null — дальше нет.
  final String? nextOffsetID;

  final ServerSearchStatus status;

  const ServerSearchPage({this.ids = const [], this.nextOffsetID, this.status = ServerSearchStatus.ok});

  const ServerSearchPage.status(this.status) : ids = const [], nextOffsetID = null;
}

/// Что из действий над сообщениями умеет источник: демо — всё, серверный —
/// по срезам (личные чаты, группы срез 3.1). Экраны прячут недоступное, а не
/// падают с [UnsupportedError].
class ChatsFeatures {
  final bool reactions;
  final bool pinnedMessages;
  final bool forward;
  final bool scheduled;

  /// Группы: «Новое» → «Группа», группы в списке (сервер — флаг «Группы»).
  final bool groups;

  /// Роли и права в группе (подэтап 3.2): «Чтение» / «Запись», админы с
  /// правами и званием, исключение и блокировка, «Заблокированные», роль по
  /// умолчанию в «Изменить», закреп у всех и удаление чужих — по праву.
  final bool groupRoles;

  /// Вступление в группы (подэтап 3.3): способы вступления, публичное имя,
  /// ссылки-приглашения, заявки, «Скрыть историю», предпросмотр и
  /// «Вступить» по ссылке.
  final bool groupJoining;

  /// Расширенное в группах: реакции, опросы, упоминания, медленный режим,
  /// «новички», «скрыть участников» (на сервере — подэтап 3.4). `false` — в
  /// группе это скрыто, а «Изменить» — только название, описание, фото (роль
  /// по умолчанию — с [groupRoles], вступление — с [groupJoining]).
  final bool groupExtras;

  /// Правила демо (каналы и сообщества): в профиле чата ссылки и заявки —
  /// любому админу, участников добавляют админы. Без них (сервер) — по правам
  /// приглашать (см. `chatInfoShowsInvites`).
  final bool demoRules;

  /// Каналы: «Новое» → «Канал», каналы в списке (сервер — флаг «Каналы»,
  /// срез 4).
  final bool channels;

  /// Расширенное в каналах (на сервере — подэтап 4.2): просмотры, реакции и
  /// «Максимум реакций под постом», опросы. `false` — в канале это скрыто.
  final bool channelExtras;

  /// Комментарии к постам канала (на сервере — подэтап 4.3): «Комментарии»
  /// под постом и блок комментариев в «Изменить». `false` — скрыты.
  final bool channelComments;

  /// Опрос можно переслать (демо — куда угодно, сервер — см.
  /// [pollsGroupsChannelsOnly]).
  final bool forwardPolls;

  /// Опросы — только в группах и каналах (сервер, 4.6): пересланный опрос —
  /// тот же опрос (голоса общие с исходным), и переслать его можно только в
  /// группу или канал (в личный чат сервер ответит «pollInvalid»).
  final bool pollsGroupsChannelsOnly;

  const ChatsFeatures({
    required this.reactions,
    required this.pinnedMessages,
    required this.forward,
    required this.scheduled,
    this.groups = false,
    this.groupRoles = false,
    this.groupJoining = false,
    this.groupExtras = false,
    this.demoRules = false,
    this.channels = false,
    this.channelExtras = false,
    this.channelComments = false,
    this.forwardPolls = false,
    this.pollsGroupsChannelsOnly = false,
  });

  const ChatsFeatures.all()
    : reactions = true,
      pinnedMessages = true,
      forward = true,
      scheduled = true,
      groups = true,
      groupRoles = true,
      groupJoining = true,
      groupExtras = true,
      demoRules = true,
      channels = true,
      channelExtras = true,
      channelComments = true,
      forwardPolls = true,
      pollsGroupsChannelsOnly = false;

  const ChatsFeatures.none()
    : reactions = false,
      pinnedMessages = false,
      forward = false,
      scheduled = false,
      groups = false,
      groupRoles = false,
      groupJoining = false,
      groupExtras = false,
      demoRules = false,
      channels = false,
      channelExtras = false,
      channelComments = false,
      forwardPolls = false,
      pollsGroupsChannelsOnly = false;

  /// Доступное в чате [chat]: в группе без [groupExtras] — без реакций, а
  /// закреп — только с [groupRoles] (у всех — по праву pinMessages); в канале
  /// без [channelExtras] — без реакций и опросов (как без [groupExtras]).
  ChatsFeatures forChat(models.Chat? chat) {
    if (chat == null || chat.type == models.ChatType.private) return this;
    final channel = chat.type == models.ChatType.channel || chat.isThread;
    if (channel ? channelExtras : groupExtras) return this;
    return ChatsFeatures(
      reactions: false,
      pinnedMessages: pinnedMessages && groupRoles,
      forward: forward,
      scheduled: scheduled,
      groups: groups,
      groupRoles: groupRoles,
      groupJoining: groupJoining,
      groupExtras: false,
      demoRules: demoRules,
      channels: channels,
      channelExtras: channelExtras,
      channelComments: channelComments,
      forwardPolls: forwardPolls,
      pollsGroupsChannelsOnly: pollsGroupsChannelsOnly,
    );
  }
}

abstract class ChatsDataSource {
  /// Какие действия над сообщениями доступны (см. [ChatsFeatures]).
  ChatsFeatures get features;

  /// Текущий список чатов (включая архивные) — сразу при подписке, затем при
  /// каждом изменении.
  Stream<List<models.Chat>> watchChats();

  /// Папки пользователя; первая — «Все чаты».
  Stream<List<models.ChatFolder>> watchFolders();

  Future<void> setPinned(String chatID, bool pinned);

  /// Выключить / включить уведомления; [until] — до этого времени (`null` —
  /// навсегда).
  Future<void> setMuted(String chatID, bool muted, {DateTime? until});
  Future<void> setArchived(String chatID, bool archived);

  /// Автоудаление в личном чате ([period] — секунды, 0 — выключить; от суток
  /// до года, кратно суткам): общее для обоих, в ленте — служебное «… включил
  /// автоудаление». Без сети — [ChatsOfflineException]; собеседник ограничил,
  /// кто может писать, — `ChatsRequestException.isPrivacyRestricted`.
  Future<void> setTTL(String chatID, int period);

  /// Защита содержимого в личном чате: [enabled] — включить; выключить сам
  /// может только включивший, у собеседника — запрос в ленту. [requestID] —
  /// ответ включившего на такой запрос (false — принять, true — отклонить).
  /// Без сети — [ChatsOfflineException]; запрос уже отвечен / просрочен —
  /// `ChatsRequestException.isRequestExpired`.
  Future<void> setNoForwards(String chatID, bool enabled, {String requestID = ''});

  /// Прочитать (сбросить счётчики и ручную пометку) или пометить непрочитанным.
  Future<void> setRead(String chatID, bool read);

  /// Прочитать все чаты папки.
  Future<void> readAll(List<String> chatIDs);

  /// Удалить чат / покинуть группу или канал. Сообщество — вместе со всеми его
  /// чатами; группа / канал сообщества: владелец удаляет у всех, остальные
  /// только выходят (чат остаётся в сообществе, можно вступить снова).
  Future<void> delete(String chatID, {bool forEveryone = false});

  Future<void> deleteFolder(String folderID);

  /// Создать / изменить папку (по `id`); новая — в конец списка.
  Future<void> saveFolder(models.ChatFolder folder);

  /// Новый порядок папок: [folderIDs] — все, кроме «Все чаты» (она всегда
  /// первая).
  Future<void> reorderFolders(List<String> folderIDs);

  /// Контакты, с которыми можно начать личный чат или добавить в группу
  /// («Новое сообщение», выбор участников) — по алфавиту.
  Future<List<models.ChatMember>> contacts();

  /// Глобальный поиск людей (сервер, как contacts.search / resolvePhone в
  /// Telegram): [query] — номер телефона целиком или username (см.
  /// `UsersSearch.qualifies`). Без меня и локально скрытых; без сети —
  /// [ChatsOfflineException], лимит — [ChatsFloodException].
  Future<List<models.ChatMember>> searchUsers(String query);

  /// Глобальный поиск публичных групп (сервер, `Chats.SearchChats`): слова
  /// названия по началу или «@имя» по префиксу (см.
  /// `UsersSearch.chatsQualify`), по убыванию числа участников. Модель —
  /// для строки поиска: название, имя, аватар, число участников и
  /// [models.Chat.isMember]. Без сети — [ChatsOfflineException], лимит —
  /// [ChatsFloodException].
  Future<List<models.Chat>> searchChats(String query);

  /// Личный чат с пользователем [userID] (контакт или участник группы):
  /// существующий или новый пустой. Возвращает id чата (пусто — не найден).
  Future<String> openPrivateChat(String userID);

  /// Уже существующий личный чат с [userID] — только из локального кэша, без
  /// сервера (профиль пользователя: секции чата, если переписка есть). Пусто —
  /// чата нет.
  Future<String> findPrivateChat(String userID);

  /// Свободно ли публичное имя группы/канала/сообщества (форма создания и
  /// «Изменить»; своё текущее имя чата [exceptChatID] — свободно).
  Future<bool> isUsernameAvailable(String username, {String exceptChatID = ''});

  /// Создать группу / канал / сообщество, мы — владелец. [memberIDs] — кого
  /// добавить сразу (группа); [username] — публичное имя (пусто — частный чат со
  /// ссылкой-приглашением [inviteLink]; на сервере код выдаёт он сам, а
  /// [inviteLink] не отправляется); [avatarPath] — локальный файл фото.
  /// Сообщество создаётся сразу с каналом объявлений. [communityID] — группа /
  /// канал внутри сообщества (своих ссылок нет, [joinMode] — одним нажатием
  /// ([models.ChatJoinMode.open]) или по заявке; настройки по умолчанию — от
  /// сообщества). [historyHidden] — «Скрыть историю» (только частная группа).
  /// Канал: [commentsEnabled] и остальные `comments*` — комментарии к постам
  /// (как в [updateChat]), [newcomerMediaDelay] — «новички» в комментариях.
  /// Возвращает id нового чата.
  Future<String> createChat({
    required models.ChatType type,
    required String title,
    String about = '',
    List<String> memberIDs = const [],
    String username = '',
    String inviteLink = '',
    String avatarPath = '',
    String communityID = '',
    models.ChatJoinMode joinMode = models.ChatJoinMode.open,
    bool historyHidden = false,
    bool commentsEnabled = false,
    int commentsTimeLimit = 0,
    models.ChatCommentsWho commentsWho = models.ChatCommentsWho.all,
    int commentsMinSubscription = 0,
    int newcomerMediaDelay = 0,
  });

  /// Изменить группу/канал/сообщество (профиль чата → «Изменить», админ):
  /// название, описание, фото, способ вступления ([username] — для
  /// [models.ChatJoinMode.open], иначе действует [inviteLink]) и роль
  /// вступивших; [coverPath] — обложка сообщества, [phone] / [address] /
  /// [latitude] / [longitude] — контакты его заведения. [commentsTimeLimit] — «Срок комментирования» канала (секунд,
  /// 0 — без ограничения), действует только на новые посты; [commentsWho] и
  /// [commentsMinSubscription] — кто может комментировать (только подписчики —
  /// подписанные не меньше стольких секунд); [newcomerMediaDelay] —
  /// «Новичкам — без ссылок и медиа» (секунд, 0 — выключено). [historyHidden]
  /// — «Скрыть историю» группы (только частной): новые участники видят
  /// сообщения с момента вступления. [noForwards] — «Запретить копирование»
  /// (защита содержимого для всех участников, как `Chat.noForwards`).
  Future<void> updateChat(
    String chatID, {
    required String title,
    required String about,
    required String avatarPath,
    String coverPath = '',
    String phone = '',
    String address = '',
    double? latitude,
    double? longitude,
    required models.ChatJoinMode joinMode,
    required String username,
    required String inviteLink,
    required models.ChatRole defaultRole,
    bool commentsEnabled = false,
    int commentsTimeLimit = 0,
    models.ChatCommentsWho commentsWho = models.ChatCommentsWho.all,
    int commentsMinSubscription = 0,
    int newcomerMediaDelay = 0,
    bool signMessages = false,
    bool membersHidden = false,
    bool historyHidden = false,
    bool noForwards = false,
  });

  /// Ссылка `iperon.net/<path>` (публичное имя или `+код` приглашения) → id
  /// чата: наш — сразу, чужой публичный / по живой ссылке — для просмотра
  /// (`Chat.isMember == false`); имя пользователя — личный чат с ним. Пусто —
  /// ссылка не найдена или недействительна. Нужна сеть, а её нет —
  /// `ChatsOfflineException`; лимит частоты — `ChatsFloodException`.
  Future<String> resolveLink(String path);

  /// «Подписаться» / «Вступить»: стать участником; у чата «По заявке» —
  /// подать заявку (`Chat.joinRequested`), вступление — после одобрения. В
  /// сообщество — вместе с его каналом объявлений (в остальные чаты вступают
  /// по отдельности). Сервер: без сети — [ChatsOfflineException]; отказ
  /// («banned», «membersLimit», «groupsLimit», ссылка уже недействительна —
  /// NOT_FOUND) — `ChatsRequestException`.
  Future<void> joinChat(String chatID);

  /// Комментарии к посту [postID] канала [channelID]: id чата-ветки (создаётся
  /// при первом открытии; первым в ней — сам пост). Пусто — комментариев нет.
  /// Сервер: уже открытая на устройстве — сразу из кэша (и без сети); новая —
  /// без сети [ChatsOfflineException], комментарии выключены —
  /// `ChatsRequestException` «commentsDisabled».
  Future<String> openComments(String channelID, String postID);

  /// Админ канала: закрыть комментарии к посту досрочно ([closed]) или снова
  /// открыть (бессрочно). Закрытую ветку можно только читать. Сервер: право
  /// editMessages, без сети — [ChatsOfflineException].
  Future<void> setCommentsClosed(String channelID, String postID, bool closed);

  /// Ссылки-приглашения чата (админ): основная первой, затем дополнительные
  /// (новые выше), отозванные — с `revoked`. Сразу при подписке, затем при
  /// каждом изменении (счётчики вступлений).
  Stream<List<models.ChatInviteLink>> watchInviteLinks(String chatID);

  /// Новая дополнительная ссылка.
  Future<void> createInviteLink(String chatID, {String title = '', DateTime? expireDate, int usageLimit = 0, bool requestApproval = false});

  /// Изменить дополнительную ссылку (код остаётся прежним).
  Future<void> editInviteLink(
    String chatID,
    String linkID, {
    required String title,
    DateTime? expireDate,
    required int usageLimit,
    required bool requestApproval,
  });

  /// Отозванную ссылку можно удалить одну ([deleteRevokedLinks] с `linkID`);
  /// `false` — только все отозванные сразу (сервер).
  bool get deletesRevokedLinkSingly;

  /// Отозвать ссылку. Основная не отзывается, а заменяется новой (старая
  /// уходит в отозванные) — меняется и `Chat.inviteLink`.
  Future<void> revokeInviteLink(String chatID, String linkID);

  /// Удалить отозванную ссылку ([linkID] пусто — все отозванные).
  Future<void> deleteRevokedLinks(String chatID, {String linkID = ''});

  /// Заявки на вступление — от новых к старым. Сервер: список только по
  /// запросу (при подписке и при изменении заявок) — не загрузился (нет
  /// сети, отказ) — ошибка в потоке ([ChatsOfflineException] /
  /// `ChatsRequestException`), а не пустой список.
  Stream<List<models.ChatJoinRequest>> watchJoinRequests(String chatID);

  /// Принять / отклонить заявку ([userID] пусто — все).
  Future<void> answerJoinRequest(String chatID, {String userID = '', required bool approve});

  /// «Известные» участники — не весь список: владелец, админы (модераторы),
  /// мы и до ~200 недавно активных — для прав, упоминаний и выбора. У чата
  /// сообщества владелец и админы — от сообщества (`fromCommunity`, их роль и
  /// права меняются только там), заблокированных в сообществе нет. Весь
  /// список — страницами через [membersPage].
  Future<List<models.ChatMember>> members(String chatID);

  /// Страница списка участников (профиль → «Участники»): владелец, админы и
  /// модераторы, затем по активности (в сети, недавно были, остальные).
  /// [cursor] — `nextCursor` предыдущей страницы (пусто — с начала). В
  /// сообществе участников могут быть сотни тысяч — целиком не грузим. Скрытый
  /// список (`Chat.membersHidden`) не админу — только владелец и админы.
  /// [query] — поиск (см. `memberMatches`): по `@username` у всех, по имени —
  /// среди админов, недавно активных и наших контактов (имена на сервере
  /// зашифрованы).
  Future<ChatMembersPage> membersPage(String chatID, {String cursor = '', int limit = 50, String query = ''});

  /// Изменились участники / роли / блокировки чата [chatID] (в т.ч. на другом
  /// устройстве или в его сообществе) — перечитать [members] и [banned].
  Stream<void> watchMembersChanged(String chatID);

  /// Админ: роль участника — «Чтение» / «Запись» (админы — отдельно).
  Future<void> setMemberRole(String chatID, String userID, models.ChatRole role);

  /// Админ: исключить участника; [ban] — ещё и заблокировать (по ссылкам не
  /// вернётся, пока не разблокируют). В чате сообщества блокировка — в самом
  /// сообществе (из него и всех его чатов); исключение из сообщества — и из
  /// всех его чатов.
  Future<void> removeMember(String chatID, String userID, {bool ban = false});

  /// Заблокированные в группе (профиль → «Заблокированные», админ); у чата
  /// сообщества — заблокированные в сообществе.
  Future<List<models.ChatMember>> banned(String chatID);

  Future<void> unbanMember(String chatID, String userID);

  /// Админ с правом блокировать: «Заблокировать пользователя» в
  /// «Заблокированных» — [user] может и не быть в группе (тогда он только
  /// попадает в список и не вступит ни по ссылке, ни заявкой, ни по имени);
  /// участник — исключается, как [removeMember] с `ban`. Сервер: без сети —
  /// [ChatsOfflineException], отказ — `ChatsRequestException`.
  Future<void> banUser(String chatID, models.ChatMember user);

  /// Добавить контакты [userIDs] (с ролью по умолчанию). Заблокированных в
  /// группе разблокирует только админ с правом блокировать — у остальных они
  /// не добавятся (как запретившие приватностью).
  Future<void> addMembers(String chatID, List<String> userIDs);

  /// Назначить админом / изменить права и «звание» админа (у владельца и
  /// админов сообщества в его чате — нельзя). Владелец на себя ([userID] —
  /// мы) — только своё звание ([rights] не значат).
  Future<void> setAdmin(String chatID, String userID, {required models.ChatAdminRights rights, String rank = ''});

  /// Снять админа (останется участником с ролью по умолчанию группы).
  Future<void> removeAdmin(String chatID, String userID);

  /// Владелец: передать владение — [userID] станет владельцем, мы — админом со
  /// всеми правами. На сервере — с подтверждением облачным паролем
  /// [password] (см. [transferNeedsPassword]): его нет —
  /// `ChatsRequestException` «cloudPasswordRequired», неверный —
  /// «passwordInvalid». У чата сообщества нельзя — владение передаётся всего
  /// сообщества.
  Future<void> transferOwnership(String chatID, String userID, {String password = ''});

  /// Передача владения подтверждается облачным паролем (сервер; в демо — нет).
  bool get transferNeedsPassword;

  /// Реакции группы/канала (профиль чата → «Реакции», админ): все /
  /// выбранные [reactions] / никаких; у канала — ещё [maxReactions] (сколько
  /// разных под постом).
  Future<void> setChatReactions(String chatID, models.ChatReactionsMode mode, List<String> reactions, {int? maxReactions});

  /// Чат сообщества: снова брать от сообщества все настройки по умолчанию
  /// (роль вступивших, медленный режим, реакции, «Новичкам — без ссылок и
  /// медиа»), заданные своими (`Chat.overrides`).
  Future<void> resetToCommunity(String chatID);

  /// Медленный режим группы/сообщества (профиль чата → «Медленный режим»,
  /// админ): интервал в секундах, 0 — выключить.
  Future<void> setSlowMode(String chatID, int seconds);

  /// Сообщения чата (от старых к новым) — сразу при подписке, затем при каждом
  /// изменении. Сначала — последние; старше — по [loadOlderMessages].
  Stream<List<models.Message>> watchMessages(String chatID);

  /// Прокрутили к началу ленты: добавить в [watchMessages] страницу более
  /// старых сообщений (из кэша или с сервера). false — старше нет.
  Future<bool> loadOlderMessages(String chatID);

  /// Поиск в чате (лупа в окне чата) на устройстве: id найденных сообщений,
  /// от новых к старым. Настоящие чаты ищут по всей скачанной истории (FTS5,
  /// по началу слова), демо — по подстроке.
  Future<List<String>> searchMessages(String chatID, String query);

  /// Тот же поиск на сервере (`Messages.Search`, по словам и их формам) —
  /// находит то, чего на устройстве нет (до вступления, до установки, после
  /// долгого офлайна). Страница от новых к старым; [offsetID] — продолжение
  /// из [ServerSearchPage.nextOffsetID]. Найденное ложится в кэш (локальный
  /// поиск найдёт его в следующий раз, [revealMessage] докачает историю до
  /// него). Не бросает: нет сети / не нужно — в [ServerSearchPage.status].
  Future<ServerSearchPage> searchMessagesOnServer(String chatID, String query, {String? offsetID});

  /// Показать в [watchMessages] сообщение [messageID] (переход к найденному,
  /// к цитате, к закреплённому, которого ещё нет в ленте): уже скачанное —
  /// расширить ленту до него; старше скачанного — окно вокруг него с сервера
  /// (лента — только это окно, см. [historyDetached], пока прокрутка новее
  /// не дойдёт до обычной ленты). Нужен сервер, а сети нет —
  /// [ChatsOfflineException].
  Future<void> revealMessage(String chatID, String messageID);

  /// Лента — окно «вокруг сообщения», а новее него есть ещё: внизу — не
  /// самое новое ([loadNewerMessages], кнопка «вниз» — [showLatestMessages]).
  bool historyDetached(String chatID);

  /// Прокрутили к концу окна «вокруг сообщения»: добавить страницу новее (дошли
  /// до обычной ленты — окно сливается с ней). false — новее нет. Без сети —
  /// [ChatsOfflineException].
  Future<bool> loadNewerMessages(String chatID);

  /// Из окна «вокруг сообщения» — к самому новому (обычная лента).
  Future<void> showLatestMessages(String chatID);

  /// Отправить сообщение: текст уже разобран в entities (см.
  /// `parseMarkdownShortcuts`), для медиа — [kind] + [localPath]/[fileName],
  /// для альбома — [media] (подпись — [text]). [silent] — без звука у
  /// получателя; [scheduleDate] — не сейчас, а в это время (см. [watchScheduled]);
  /// [linkPreview] `false` — без превью ссылки (× над полем ввода).
  Future<void> sendMessage(
    String chatID, {
    String text = '',
    List<models.MessageEntity> entities = const [],
    models.MessageReply? reply,
    models.MessageKind kind = models.MessageKind.text,
    String localPath = '',
    String fileName = '',
    List<models.MessageMedia> media = const [],
    int duration = 0,
    List<int> waveform = const [],
    bool silent = false,
    DateTime? scheduleDate,
    bool linkPreview = true,
    models.MessagePoll? poll,
  });

  /// Опрос: наш голос — варианты [options] (пустой список — отменить голос).
  /// Сервер: без сети — [ChatsOfflineException], опрос завершён —
  /// `ChatsRequestException` «pollClosed».
  Future<void> votePoll(String chatID, String messageID, List<int> options);

  /// Завершить опрос (автор или админ): голосовать больше нельзя.
  Future<void> closePoll(String chatID, String messageID);

  /// Открытый опрос: «кто за что» — опрос с заполненными
  /// `PollOption.voters` (мы — «Вы»). Сервер — по запросу (без сети —
  /// [ChatsOfflineException]); `null` — опроса нет.
  Future<models.MessagePoll?> pollVoters(String chatID, String messageID);

  /// «Кто поставил реакцию» на сообщение группы: страница от поздних к ранним
  /// ([emoji] пусто — все, [cursor] — `nextCursor` прошлой страницы). Сервер —
  /// по запросу: без сети — [ChatsOfflineException], лимит —
  /// [ChatsFloodException], отказ — `ChatsRequestException`.
  Future<ReactionsListPage> reactionsList(String chatID, String messageID, {String emoji = '', String cursor = ''});

  /// Отложенные сообщения чата (отправка с [sendMessage] `scheduleDate`) — от
  /// ранних к поздним; в момент `scheduledDate` уходят в чат сами.
  Stream<List<models.Message>> watchScheduled(String chatID);

  /// Отложенное — отправить сейчас / перенести / удалить.
  Future<void> sendScheduledNow(String chatID, String messageID);
  Future<void> rescheduleMessage(String chatID, String messageID, DateTime date);
  Future<void> deleteScheduled(String chatID, String messageID);

  /// Править сообщение: текст и разметка; [media] — ещё и вложения (замена /
  /// добавление, см. `edit_media.dart`): новые файлы сначала грузятся на CDN
  /// ([onUpload] — отправлено / всего байт, [isCancelled] — отменили), затем
  /// весь итоговый список уходит одной правкой. С вложениями нужна сеть сразу —
  /// без неё [ChatsOfflineException] до любых изменений; отказ сервера —
  /// `ChatsRequestException` («mediaInvalid»), отмена — `UploadCancelledException`.
  Future<void> editMessage(
    String chatID,
    String messageID,
    String text,
    List<models.MessageEntity> entities, {
    models.EditMedia? media,
    void Function(int sent, int total)? onUpload,
    bool Function()? isCancelled,
  });

  /// Удалить сообщение: [forEveryone] — у всех (в личном чате — и у
  /// собеседника), `false` — только у себя.
  Future<void> deleteMessage(String chatID, String messageID, {bool forEveryone = true});

  /// Закрепить / открепить сообщение в чате. [forEveryone] — закрепить и у
  /// собеседника (личный чат) / у всех: тогда в ленте появляется сервисное
  /// «Вы закрепили «…»»; `false` — только у себя, без сервисного.
  Future<void> setMessagePinned(String chatID, String messageID, bool pinned, {bool forEveryone = true});

  /// Открепить все сообщения чата (экран «Закреплённые сообщения»):
  /// [forEveryone] — и у собеседника, иначе только у себя.
  Future<void> unpinAllMessages(String chatID, {bool forEveryone = true});

  /// Закреплённые сообщения чата — от новых к старым; сразу при подписке,
  /// затем при каждом изменении. Не зависят от окна [watchMessages]:
  /// закреплённое может быть старше загруженной истории.
  Stream<List<models.Message>> watchPinnedMessages(String chatID);

  /// Переслать [messages] (из любых чатов, по порядку) в чат [toChatID]: новые
  /// исходящие сообщения с тем же содержимым и пометкой «Переслано от».
  Future<void> forwardMessages(String toChatID, List<models.Message> messages);

  /// Отправить ещё раз сообщение, отклонённое сервером
  /// ([models.MessageStatus.failed]).
  Future<void> retrySend(String chatID, String messageID);

  /// Отменить загрузку вложений (крестик на прогрессе) — сообщение удаляется,
  /// так и не дойдя до собеседника.
  Future<void> cancelUpload(String chatID, String messageID);

  /// Наши реакции на сообщение — весь набор целиком (пустой — снять все), как
  /// `sendReaction` в Telegram.
  Future<void> setReactions(String chatID, String messageID, List<String> emojis);

  /// Кто / когда прочитал наше сообщение (меню сообщения, см.
  /// `readReceiptsApply`): в личном чате — время, в группе — участники. На
  /// сервере — по событиям прочтения за [readMarksExpire]; собеседник скрыл
  /// время прочтения — [MessageReadStatus.hidden].
  Future<MessageReadInfo> readInfo(String chatID, String messageID);

  /// Мы прослушали входящее голосовое: снять `Message.mediaUnread` (у нас и у
  /// отправителя — точка у длительности пропадает).
  Future<void> readMessageContents(String chatID, String messageID);

  /// Реакции на наши сообщения [messageIDs] увидели на экране: снять
  /// `Message.reactionsUnread` и уменьшить бейдж ❤️ (`Chat.unreadReactions`).
  Future<void> readReactions(String chatID, List<String> messageIDs);

  /// «Прочитать реакции» из меню чата в списке: снять все непрочитанные
  /// реакции чата. Серверное действие — без сети [ChatsOfflineException].
  Future<void> readAllReactions(String chatID);

  /// Кнопка ❤️ в окне чата: самое старое наше сообщение с непрочитанными
  /// реакциями; `null` — таких нет.
  Future<String?> nextUnreadReaction(String chatID);

  /// Кнопка «@» в окне чата: самое старое непрочитанное упоминание нас;
  /// `null` — таких нет.
  Future<String?> nextUnreadMention(String chatID);

  /// Упоминания нас в [messageIDs] увидели на экране (пустой список — все в
  /// чате): снять `Message.mentionUnread` и уменьшить бейдж «@»
  /// (`Chat.unreadMentions`). Фоновое — без сети молча ждёт следующего показа.
  Future<void> readMentions(String chatID, List<String> messageIDs);

  /// Сохранить черновик поля ввода (показывается в списке чатов).
  Future<void> setDraft(String chatID, String draft);
}
