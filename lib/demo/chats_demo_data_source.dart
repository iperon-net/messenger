import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../chats/chats_data_source.dart';
import '../auth.dart';
import '../chats/invite_link.dart';
import '../di.dart';
import '../repositories.dart';
import '../chats/message_formatting.dart';
import '../chats/reactions.dart';
import '../models.dart' as models;

/// Фейковые чаты и папки для UX-демо (флаг «Демо чатов» на экране
/// «Разработчик»). Состояние живёт в памяти процесса — одно на всё приложение,
/// чтобы список и «Архив» показывали одно и то же. Пока есть подписчики,
/// имитирует жизнь: кто-то печатает, приходят новые сообщения, наши исходящие
/// становятся прочитанными.
class ChatsDemoDataSource implements ChatsDataSource {
  ChatsDemoDataSource._() {
    _chats = [for (final c in _seedChats()) _withProfile(c)];
    _folders = _seedFolders();
  }

  static final ChatsDemoDataSource instance = ChatsDemoDataSource._();

  final _random = Random();
  late List<models.Chat> _chats;
  late List<models.ChatFolder> _folders;

  late final StreamController<List<models.Chat>> _chatsController = StreamController.broadcast(
    onListen: _startSimulation,
    onCancel: _stopSimulation,
  );
  final _foldersController = StreamController<List<models.ChatFolder>>.broadcast();

  Timer? _timer;

  @override
  Stream<List<models.Chat>> watchChats() async* {
    yield _present();
    yield* _chatsController.stream;
  }

  void _emit() => _chatsController.add(_present());

  /// Чаты для подписчиков: строки сообществ — сводкой по их чатам, где мы
  /// участник (см. «Сообщества» в docs/plans/chats-groups-channels.md):
  /// последнее сообщение с подписью «Группа › Отправитель» и суммарные
  /// непрочитанные без заглушённых чатов.
  List<models.Chat> _present() {
    final byCommunity = <String, List<models.Chat>>{};
    for (final c in _chats) {
      if (c.inCommunity && c.isMember) (byCommunity[c.communityID] ??= []).add(c);
    }
    return [
      for (final c in _chats)
        if (c.type == models.ChatType.community) _summary(c, byCommunity[c.id] ?? const []) else c,
    ];
  }

  models.Chat _summary(models.Chat community, List<models.Chat> chats) {
    models.Chat? latest;
    for (final c in chats) {
      final date = c.lastMessage?.date;
      if (date != null && (latest == null || date.isAfter(latest.lastMessage!.date))) latest = c;
    }
    final audible = chats.where((c) => !c.muted);
    return community.copyWith(
      lastMessage: latest == null
          ? community.lastMessage
          : latest.lastMessage!.copyWith(chatTitle: latest.announcements ? '' : latest.title),
      unreadCount: audible.fold<int>(0, (sum, c) => sum + c.unreadCount),
      unreadMentions: audible.fold<int>(0, (sum, c) => sum + c.unreadMentions),
    );
  }

  /// Чаты сообщества [communityID]: канал объявлений первым.
  List<models.Chat> _communityChats(String communityID) => [
    ..._chats.where((c) => c.communityID == communityID && c.announcements),
    ..._chats.where((c) => c.communityID == communityID && !c.announcements),
  ];

  @override
  Stream<List<models.ChatFolder>> watchFolders() async* {
    yield _folders;
    yield* _foldersController.stream;
  }

  @override
  Future<void> setPinned(String chatID, bool pinned) async => _update(chatID, (c) => c.copyWith(pinned: pinned));

  /// Таймеры «включить уведомления» для заглушённых на время.
  final _unmuteTimers = <String, Timer>{};

  @override
  Future<void> setMuted(String chatID, bool muted, {DateTime? until}) async {
    _unmuteTimers.remove(chatID)?.cancel();
    final timed = muted ? until : null;
    _update(chatID, (c) => c.copyWith(muted: muted, mutedUntil: timed));
    if (timed != null) {
      final delay = timed.difference(DateTime.now());
      _unmuteTimers[chatID] = Timer(delay.isNegative ? Duration.zero : delay, () => setMuted(chatID, false));
    }
  }

  @override
  Future<void> setArchived(String chatID, bool archived) async =>
      _update(chatID, (c) => c.copyWith(archived: archived, pinned: archived ? false : c.pinned));

  @override
  Future<void> setRead(String chatID, bool read) async {
    // Сообщество «прочитано» — прочитаны все его чаты.
    if (read && _chats.any((c) => c.id == chatID && c.type == models.ChatType.community)) {
      await readAll([chatID, for (final c in _communityChats(chatID)) c.id]);
      return;
    }
    _update(chatID, (c) => read ? c.copyWith(unreadCount: 0, unreadMentions: 0, markedUnread: false) : c.copyWith(markedUnread: true));
  }

  @override
  Future<void> readAll(List<String> chatIDs) async {
    // Сообщество в папке — и все его чаты.
    final ids = {
      ...chatIDs,
      for (final c in _chats)
        if (chatIDs.contains(c.communityID)) c.id,
    };
    _chats = [for (final c in _chats) ids.contains(c.id) ? c.copyWith(unreadCount: 0, unreadMentions: 0, markedUnread: false) : c];
    _emit();
  }

  @override
  Future<void> setChatReactions(String chatID, models.ChatReactionsMode mode, List<String> reactions, {int? maxReactions}) async =>
      _update(chatID, (c) => c.copyWith(reactionsMode: mode, reactions: reactions, maxReactions: maxReactions ?? c.maxReactions));

  @override
  Future<void> setSlowMode(String chatID, int seconds) async => _update(chatID, (c) => c.copyWith(slowMode: seconds));

  /// Медленный режим: после нашей отправки следующее — не раньше чем через
  /// `slowMode` секунд (настоящий сервер ещё и отклонит слишком раннее).
  void _slowModeSent(String chatID) {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || !chat.slowModeApplies) return;
    _update(chatID, (c) => c.copyWith(slowModeUntil: DateTime.now().add(Duration(seconds: c.slowMode))));
  }

  final _members = <String, List<models.ChatMember>>{};

  @override
  Future<List<models.ChatMember>> members(String chatID) async {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || chat.type == models.ChatType.private) return const [];
    return _members.putIfAbsent(chatID, () {
      final now = DateTime.now();
      // Демо: участники из имён истории + «Вы»; список — первые до 30.
      const surnames = ['Смирнова', 'Козлов', 'Иванова', 'Петров', 'Соколова', 'Морозов', 'Волкова', 'Новиков'];
      final count = min(chat.membersCount, 30);
      // Мы-админ — со всеми правами (в демо можно показать назначение админов).
      final result = <models.ChatMember>[
        models.ChatMember(
          id: 'me',
          name: 'Вы',
          role: chat.myRole,
          online: true,
          isSelf: true,
          rights: chat.myRole == models.ChatRole.admin ? models.ChatAdminRights.all : const models.ChatAdminRights(),
        ),
      ];
      for (var i = 0; result.length < count; i++) {
        final name = '${_names[i % _names.length]} ${surnames[(i * 3) % surnames.length]}';
        final role = i == 0 && chat.myRole != models.ChatRole.owner
            ? models.ChatRole.owner
            : i < 2
            ? models.ChatRole.admin
            : (i % 4 == 3 ? models.ChatRole.reader : models.ChatRole.writer);
        result.add(
          models.ChatMember(
            id: 'u$i',
            name: name,
            // У половины — @username (упоминание «@»), у остальных — по имени.
            username: i.isEven ? _translit(name) : '',
            role: role,
            rights: role == models.ChatRole.admin ? models.ChatAdminRights.standard : const models.ChatAdminRights(),
            rank: role == models.ChatRole.admin && i == 1 ? 'модератор' : '',
            online: i % 3 == 0,
            lastSeen: i % 3 == 0 ? null : now.subtract(Duration(minutes: 7 + i * 53)),
          ),
        );
      }
      int rank(models.ChatMember m) => m.role == models.ChatRole.owner ? 0 : (m.role == models.ChatRole.admin ? 1 : 2);
      final indexed = result.indexed.toList()
        ..sort((a, b) => rank(a.$2) != rank(b.$2) ? rank(a.$2).compareTo(rank(b.$2)) : a.$1.compareTo(b.$1));
      return [for (final (_, m) in indexed) m];
    });
  }

  // ─── Новые чаты ───────────────────────────────────────────────────────────

  /// Демо-контакты: собеседники личных чатов (id контакта = id чата) и ещё
  /// несколько человек, с кем переписки пока нет.
  List<models.ChatMember> _contacts() {
    final now = DateTime.now();
    final fromChats = [
      for (final c in _chats)
        if (c.type == models.ChatType.private && !c.isSelf && c.isContact)
          models.ChatMember(id: c.id, name: c.title, username: c.username, online: c.online, lastSeen: c.lastSeen),
    ];
    final known = {for (final m in fromChats) m.id};
    final extra = [
      models.ChatMember(id: 'ekaterina', name: 'Екатерина Волкова', lastSeen: now.subtract(const Duration(minutes: 40))),
      models.ChatMember(id: 'ivan', name: 'Иван Новиков', online: true),
      models.ChatMember(id: 'pavel', name: 'Павел Морозов', lastSeen: now.subtract(const Duration(hours: 3))),
      models.ChatMember(id: 'natalia', name: 'Наталья Соколова', lastSeen: now.subtract(const Duration(days: 2))),
      models.ChatMember(id: 'mikhail', name: 'Михаил Орлов'),
      models.ChatMember(id: 'tatiana', name: 'Татьяна Лебедева', online: true),
      models.ChatMember(id: 'andrey', name: 'Андрей Захаров', lastSeen: now.subtract(const Duration(minutes: 5))),
      models.ChatMember(id: 'yulia', name: 'Юлия Кузнецова', lastSeen: now.subtract(const Duration(hours: 20))),
    ].where((m) => !known.contains(m.id));
    return [...fromChats, ...extra]..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<List<models.ChatMember>> contacts() async => _contacts();

  @override
  Future<String> openPrivateChat(String userID) async {
    if (_chats.any((c) => c.id == userID)) {
      // Чат мог быть в архиве — достаём, как при новом сообщении.
      _update(userID, (c) => c.copyWith(archived: false));
      return userID;
    }
    // Не только контакт — и участник группы («Написать сообщение» в профиле).
    final contacts = _contacts();
    final contact =
        contacts.where((m) => m.id == userID).firstOrNull ??
        _members.values.expand((list) => list).where((m) => m.id == userID).firstOrNull;
    if (contact == null) return '';
    // Пустая история — иначе при открытии сгенерировалась бы демо-переписка.
    _messages[userID] = [];
    _chats = [
      ..._chats,
      models.Chat(
        id: userID,
        type: models.ChatType.private,
        title: contact.name,
        isContact: contacts.any((m) => m.id == userID),
        online: contact.online,
        lastSeen: contact.lastSeen,
        createdAt: DateTime.now(),
      ),
    ];
    _emit();
    return userID;
  }

  /// Занятые публичные имена: у демо-чатов и несколько зарезервированных.
  @override
  Future<bool> isUsernameAvailable(String username, {String exceptChatID = ''}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350)); // как запрос к серверу
    const reserved = {'iperon', 'admin', 'support', 'settings', 'channel', 'group', 'community'};
    final name = username.toLowerCase();
    return !reserved.contains(name) && !_chats.any((c) => c.id != exceptChatID && c.username.toLowerCase() == name);
  }

  var _nextChatID = 0;

  @override
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
  }) async {
    final now = DateTime.now();
    final id = 'new${_nextChatID++}';
    final community = _chats.where((c) => c.id == communityID && c.type == models.ChatType.community).firstOrNull;
    final contacts = {for (final m in _contacts()) m.id: m};
    final members = [
      for (final memberID in memberIDs)
        if (contacts[memberID] case final m?) m.copyWith(role: models.ChatRole.writer),
    ];
    // В сообществе наша роль — как в сообществе (его админы — админы во всех
    // его чатах).
    final myRole = community?.myRole ?? models.ChatRole.owner;
    _members[id] = [models.ChatMember(id: 'me', name: 'Вы', role: myRole, online: true, isSelf: true), ...members];

    // Сервисное «создан» первым сообщением (в демо — по-русски, как прочие
    // сервисные; настоящие придут с сервера структурой и локализуются).
    final service = switch (type) {
      models.ChatType.group => 'Вы создали группу «$title»',
      models.ChatType.channel => 'Канал создан',
      models.ChatType.community => 'Сообщество создано',
      models.ChatType.private => '',
    };
    _messages[id] = [
      models.Message(id: _id(), chatID: id, text: service, outgoing: true, service: true, status: models.MessageStatus.read, date: now),
      if (type == models.ChatType.group && members.isNotEmpty)
        models.Message(
          id: _id(),
          chatID: id,
          text: 'Вы добавили ${members.map((m) => m.name).join(', ')}',
          outgoing: true,
          service: true,
          status: models.MessageStatus.read,
          date: now,
        ),
    ];

    final chat = models.Chat(
      id: id,
      type: type,
      title: title,
      about: about,
      username: username,
      inviteLink: username.isEmpty ? inviteLink : '',
      joinMode: username.isEmpty ? models.ChatJoinMode.link : models.ChatJoinMode.open,
      avatarPath: avatarPath,
      commentsEnabled: type == models.ChatType.channel,
      membersHidden: type == models.ChatType.channel,
      membersCount: 1 + members.length,
      myRole: myRole,
      createdAt: now,
      lastMessage: type == models.ChatType.community ? null : models.ChatLastMessage(text: service, date: now),
    );
    _chats = [
      ..._chats,
      if (community != null)
        // Чат сообщества: своих ссылок нет, настройки по умолчанию — от
        // сообщества (админ может поменять у конкретного чата).
        chat.copyWith(
          communityID: community.id,
          username: '',
          inviteLink: '',
          // Одним нажатием / по заявке (закрытая тема) / скрытая (добавляют админы).
          joinMode: joinMode == models.ChatJoinMode.link ? models.ChatJoinMode.open : joinMode,
          defaultRole: type == models.ChatType.channel ? models.ChatRole.reader : community.defaultRole,
          slowMode: type == models.ChatType.channel ? 0 : community.slowMode,
          reactionsMode: community.reactionsMode,
          reactions: community.reactions,
          newcomerMediaDelay: community.newcomerMediaDelay,
          membersHidden: false,
        )
      else
        chat,
      // У сообщества своей ленты нет — сразу канал объявлений.
      if (type == models.ChatType.community) _announcementsFor(chat, now),
    ];
    _emit();
    return id;
  }

  /// Канал объявлений нового сообщества [community]: его название и фото, мы
  /// — владелец; первым — сервисное «Сообщество создано».
  models.Chat _announcementsFor(models.Chat community, DateTime now) {
    final id = '${community.id}_news';
    const service = 'Сообщество создано';
    _members[id] = [const models.ChatMember(id: 'me', name: 'Вы', role: models.ChatRole.owner, online: true, isSelf: true)];
    _messages[id] = [
      models.Message(id: _id(), chatID: id, text: service, outgoing: true, service: true, status: models.MessageStatus.read, date: now),
    ];
    return models.Chat(
      id: id,
      type: models.ChatType.channel,
      title: community.title,
      avatarPath: community.avatarPath,
      communityID: community.id,
      announcements: true,
      joinMode: models.ChatJoinMode.open,
      membersHidden: true,
      membersCount: 1,
      myRole: models.ChatRole.owner,
      createdAt: now,
      lastMessage: models.ChatLastMessage(text: service, date: now),
    );
  }

  @override
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
  }) async {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null) return;
    final open = joinMode == models.ChatJoinMode.open;
    _update(
      chatID,
      (c) => c.copyWith(
        title: title,
        about: about,
        avatarPath: avatarPath,
        coverPath: chat.type == models.ChatType.community ? coverPath : '',
        phone: chat.type == models.ChatType.community ? phone : '',
        address: chat.type == models.ChatType.community ? address : '',
        latitude: chat.type == models.ChatType.community ? latitude : null,
        longitude: chat.type == models.ChatType.community ? longitude : null,
        joinMode: joinMode,
        username: open ? username : '',
        // Ссылка-приглашение сохраняется и у публичного — вернётся при
        // переключении обратно; у «только админы» её нет.
        inviteLink: joinMode == models.ChatJoinMode.admins ? '' : inviteLink,
        defaultRole: defaultRole,
        commentsEnabled: chat.type == models.ChatType.channel && commentsEnabled,
        commentsTimeLimit: chat.type == models.ChatType.channel ? commentsTimeLimit : 0,
        commentsWho: commentsWho,
        commentsMinSubscription: commentsWho == models.ChatCommentsWho.subscribers ? commentsMinSubscription : 0,
        newcomerMediaDelay: newcomerMediaDelay,
        signMessages: chat.type == models.ChatType.channel && signMessages,
        membersHidden: membersHidden,
      ),
    );
    // Основная ссылка — та же, что в чате (форма могла выдать новую).
    final links = _links[chatID];
    if (links != null && inviteLink.isNotEmpty) {
      _setLinks(chatID, [for (final l in links) l.primary ? l.copyWith(link: inviteLink) : l]);
    }
    // Включили «По заявке» — в демо сразу пара заявок, чтобы было что смотреть.
    if (joinMode == models.ChatJoinMode.request && chat.joinMode != models.ChatJoinMode.request && _requestsOf(chatID).isEmpty) {
      _addRequest(chatID, ago: const Duration(minutes: 42));
      _addRequest(chatID, ago: const Duration(minutes: 3));
    }
    // Сервисные «изменил название / фото» (в демо — по-русски, как прочие).
    final channel = chat.type == models.ChatType.channel;
    final now = DateTime.now();
    models.Message service(String text) =>
        models.Message(id: _id(), chatID: chatID, text: text, outgoing: true, service: true, status: models.MessageStatus.read, date: now);
    _setMessages(chatID, [
      ..._history(chatID),
      if (chat.title != title) service(channel ? 'Название канала изменено на «$title»' : 'Вы изменили название на «$title»'),
      if (chat.avatarPath != avatarPath)
        service(
          avatarPath.isEmpty
              ? (channel ? 'Фото канала удалено' : 'Вы удалили фото')
              : (channel ? 'Фото канала изменено' : 'Вы изменили фото'),
        ),
    ]);
  }

  // ─── Ссылки-приглашения и заявки ──────────────────────────────────────────

  final _links = <String, List<models.ChatInviteLink>>{};
  final _linksController = StreamController<String>.broadcast();
  final _requests = <String, List<models.ChatJoinRequest>>{};
  final _requestsController = StreamController<String>.broadcast();
  var _nextLinkID = 0;

  /// Ссылки чата; при первом обращении — основная (из `Chat.inviteLink`) и у
  /// «Команды Iperon» несколько дополнительных для наглядности.
  List<models.ChatInviteLink> _linksOf(String chatID) => _links.putIfAbsent(chatID, () {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    final now = DateTime.now();
    var code = chat?.inviteLink ?? '';
    if (code.isEmpty) {
      code = newInviteCode();
      _update(chatID, (c) => c.copyWith(inviteLink: code));
    }
    return [
      models.ChatInviteLink(id: 'l${_nextLinkID++}', link: code, primary: true, usage: chat?.membersCount ?? 0, createdAt: now),
      if (chatID == 'team') ...[
        models.ChatInviteLink(
          id: 'l${_nextLinkID++}',
          link: newInviteCode(),
          title: 'Для подрядчиков',
          usageLimit: 10,
          usage: 3,
          createdAt: now.subtract(const Duration(days: 4)),
        ),
        models.ChatInviteLink(
          id: 'l${_nextLinkID++}',
          link: newInviteCode(),
          title: 'Митап',
          usage: 17,
          expireDate: now.subtract(const Duration(days: 1)),
          createdAt: now.subtract(const Duration(days: 9)),
        ),
        models.ChatInviteLink(
          id: 'l${_nextLinkID++}',
          link: newInviteCode(),
          title: 'Старая ссылка',
          revoked: true,
          usage: 5,
          createdAt: now.subtract(const Duration(days: 40)),
        ),
      ],
    ];
  });

  void _setLinks(String chatID, List<models.ChatInviteLink> links) {
    _links[chatID] = links;
    _linksController.add(chatID);
  }

  @override
  Stream<List<models.ChatInviteLink>> watchInviteLinks(String chatID) async* {
    yield _linksOf(chatID);
    yield* _linksController.stream.where((id) => id == chatID).map((_) => _linksOf(chatID));
  }

  @override
  Future<void> createInviteLink(
    String chatID, {
    String title = '',
    DateTime? expireDate,
    int usageLimit = 0,
    bool requestApproval = false,
  }) async {
    final links = _linksOf(chatID);
    final link = models.ChatInviteLink(
      id: 'l${_nextLinkID++}',
      link: newInviteCode(),
      title: title,
      expireDate: expireDate,
      usageLimit: requestApproval ? 0 : usageLimit,
      requestApproval: requestApproval,
      createdAt: DateTime.now(),
    );
    // Новая — сразу после основной.
    _setLinks(chatID, [...links.where((l) => l.primary), link, ...links.where((l) => !l.primary)]);
  }

  @override
  Future<void> editInviteLink(
    String chatID,
    String linkID, {
    required String title,
    DateTime? expireDate,
    required int usageLimit,
    required bool requestApproval,
  }) async {
    _setLinks(chatID, [
      for (final l in _linksOf(chatID))
        l.id == linkID
            ? models.ChatInviteLink(
                id: l.id,
                link: l.link,
                title: title,
                primary: l.primary,
                revoked: l.revoked,
                expireDate: expireDate,
                usageLimit: requestApproval ? 0 : usageLimit,
                usage: l.usage,
                requestApproval: requestApproval,
                createdAt: l.createdAt,
              )
            : l,
    ]);
  }

  @override
  Future<void> revokeInviteLink(String chatID, String linkID) async {
    final links = _linksOf(chatID);
    final link = links.where((l) => l.id == linkID).firstOrNull;
    if (link == null) return;
    final revoked = link.copyWith(revoked: true, primary: false);
    if (!link.primary) {
      _setLinks(chatID, [for (final l in links) l.id == linkID ? revoked : l]);
      return;
    }
    // Основная — заменяется новой.
    final fresh = models.ChatInviteLink(id: 'l${_nextLinkID++}', link: newInviteCode(), primary: true, createdAt: DateTime.now());
    _setLinks(chatID, [fresh, ...links.where((l) => l.id != linkID), revoked]);
    _update(chatID, (c) => c.copyWith(inviteLink: fresh.link));
  }

  @override
  Future<void> deleteRevokedLinks(String chatID, {String linkID = ''}) async {
    _setLinks(chatID, [
      for (final l in _linksOf(chatID))
        if (!l.revoked || (linkID.isNotEmpty && l.id != linkID)) l,
    ]);
  }

  static const _applicants = [
    ('Виктория Белова', 'Фронтенд-разработчик'),
    ('Григорий Седов', ''),
    ('Ксения Павлова', 'Продакт в финтехе'),
    ('Роман Тихонов', 'Учусь на iOS-разработчика'),
    ('Елена Фомина', ''),
    ('Олег Жуков', 'Дизайнер'),
  ];
  var _nextApplicant = 0;

  List<models.ChatJoinRequest> _requestsOf(String chatID) => _requests[chatID] ?? const [];

  void _setRequests(String chatID, List<models.ChatJoinRequest> requests) {
    _requests[chatID] = requests;
    _requestsController.add(chatID);
    _update(chatID, (c) => c.copyWith(pendingRequests: requests.length));
  }

  /// Новая заявка в чат по ссылке [link] (`null` — по основной).
  void _addRequest(String chatID, {models.ChatInviteLink? link, Duration ago = Duration.zero}) {
    final via = link ?? _linksOf(chatID).firstWhere((l) => l.primary);
    final (name, about) = _applicants[_nextApplicant % _applicants.length];
    final request = models.ChatJoinRequest(
      userID: 'applicant${_nextApplicant++}',
      name: name,
      about: about,
      date: DateTime.now().subtract(ago),
      linkID: via.id,
      linkTitle: via.title,
    );
    _setRequests(chatID, [request, ..._requestsOf(chatID)]);
  }

  /// Заявки возможны: вступление «по заявке» или есть живая ссылка с
  /// одобрением.
  bool _acceptsRequests(models.Chat chat) {
    if (!chat.canManage || chat.type == models.ChatType.private) return false;
    if (chat.joinMode == models.ChatJoinMode.request) return true;
    final now = DateTime.now();
    return (_links[chat.id] ?? const <models.ChatInviteLink>[]).any((l) => l.requestApproval && l.isActive(now));
  }

  @override
  Stream<List<models.ChatJoinRequest>> watchJoinRequests(String chatID) async* {
    yield _requestsOf(chatID);
    yield* _requestsController.stream.where((id) => id == chatID).map((_) => _requestsOf(chatID));
  }

  @override
  Future<void> answerJoinRequest(String chatID, {String userID = '', required bool approve}) async {
    final all = _requestsOf(chatID);
    final answered = all.where((r) => userID.isEmpty || r.userID == userID).toList();
    if (answered.isEmpty) return;
    _setRequests(chatID, all.where((r) => !answered.contains(r)).toList());
    if (!approve) return;

    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null) return;
    _update(chatID, (c) => c.copyWith(membersCount: c.membersCount + answered.length));
    final members = _members[chatID];
    if (members != null) {
      _members[chatID] = [
        ...members,
        for (final r in answered) models.ChatMember(id: r.userID, name: r.name, role: chat.defaultRole, online: true),
      ];
    }
    // Вступление по ссылке засчитывается ей.
    if (_links.containsKey(chatID)) {
      _setLinks(chatID, [for (final l in _linksOf(chatID)) l.copyWith(usage: l.usage + answered.where((r) => r.linkID == l.id).length)]);
    }
    final now = DateTime.now();
    _setMessages(chatID, [
      ..._history(chatID),
      for (final r in answered)
        models.Message(
          id: _id(),
          chatID: chatID,
          text: chat.type == models.ChatType.channel ? '${r.name} подписался(-ась) на канал' : '${r.name} вступил(а) в группу',
          service: true,
          status: models.MessageStatus.read,
          date: now,
        ),
    ]);
  }

  // ─── Участники: роль, исключение, блокировка, добавление ──────────────────

  final _banned = <String, List<models.ChatMember>>{};

  /// Сервисное сообщение от нас (в демо — по-русски, как прочие).
  void _service(String chatID, String text) {
    _setMessages(chatID, [
      ..._history(chatID),
      models.Message(
        id: _id(),
        chatID: chatID,
        text: text,
        outgoing: true,
        service: true,
        status: models.MessageStatus.read,
        date: DateTime.now(),
      ),
    ]);
  }

  @override
  Future<void> setMemberRole(String chatID, String userID, models.ChatRole role) async {
    final members = await this.members(chatID);
    _members[chatID] = [for (final m in members) m.id == userID ? m.copyWith(role: role) : m];
  }

  @override
  Future<void> removeMember(String chatID, String userID, {bool ban = false}) async {
    final members = await this.members(chatID);
    final member = members.where((m) => m.id == userID).firstOrNull;
    if (member == null) return;
    _members[chatID] = members.where((m) => m.id != userID).toList();
    if (ban) _banned[chatID] = [member, ...?_banned[chatID]];
    _update(chatID, (c) => c.copyWith(membersCount: max(1, c.membersCount - 1)));
    _service(chatID, 'Вы исключили ${member.name}');
  }

  @override
  Future<List<models.ChatMember>> banned(String chatID) async => _banned[chatID] ?? const [];

  @override
  Future<void> unbanMember(String chatID, String userID) async {
    _banned[chatID] = [
      for (final m in _banned[chatID] ?? const <models.ChatMember>[])
        if (m.id != userID) m,
    ];
  }

  @override
  Future<void> addMembers(String chatID, List<String> userIDs) async {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null) return;
    final members = await this.members(chatID);
    final present = {for (final m in members) m.id};
    final contacts = {for (final c in _contacts()) c.id: c};
    final added = [
      for (final id in userIDs)
        if (!present.contains(id) && contacts[id] != null) contacts[id]!.copyWith(role: chat.defaultRole),
    ];
    if (added.isEmpty) return;
    _members[chatID] = [...members, ...added];
    for (final m in added) {
      await unbanMember(chatID, m.id);
    }
    _update(chatID, (c) => c.copyWith(membersCount: c.membersCount + added.length));
    _service(chatID, 'Вы добавили ${added.map((m) => m.name).join(', ')}');
  }

  // ─── Админы ───────────────────────────────────────────────────────────────

  @override
  Future<void> setAdmin(String chatID, String userID, {required models.ChatAdminRights rights, String rank = ''}) async {
    final members = await this.members(chatID);
    _members[chatID] = [
      for (final m in members)
        m.id == userID && m.role != models.ChatRole.owner ? m.copyWith(role: models.ChatRole.admin, rights: rights, rank: rank) : m,
    ];
  }

  @override
  Future<void> removeAdmin(String chatID, String userID) async {
    final members = await this.members(chatID);
    _members[chatID] = [
      for (final m in members)
        m.id == userID && m.role == models.ChatRole.admin
            ? m.copyWith(role: models.ChatRole.writer, rights: const models.ChatAdminRights(), rank: '')
            : m,
    ];
  }

  @override
  Future<void> transferOwnership(String chatID, String userID) async {
    final members = await this.members(chatID);
    final target = members.where((m) => m.id == userID).firstOrNull;
    if (target == null) return;
    _members[chatID] = [
      for (final m in members)
        if (m.id == userID)
          m.copyWith(role: models.ChatRole.owner, rights: const models.ChatAdminRights(), rank: '')
        else if (m.role == models.ChatRole.owner)
          m.copyWith(role: models.ChatRole.admin, rights: models.ChatAdminRights.all)
        else
          m,
    ];
    _update(chatID, (c) => c.copyWith(myRole: models.ChatRole.admin));
    _service(chatID, '${target.name} теперь владелец');
  }

  // ─── Ссылки iperon.net и вступление ───────────────────────────────────────

  @override
  Future<String> resolveLink(String path) async {
    final name = path.trim().replaceFirst(RegExp(r'^/+'), '').split('/').first;
    if (name.isEmpty) return '';
    if (name.startsWith('+')) {
      // Ссылка-приглашение: основная (`Chat.inviteLink`) или живая доп. ссылка.
      final now = DateTime.now();
      final byMain = _chats.where((c) => c.inviteLink == name && c.joinMode != models.ChatJoinMode.admins).firstOrNull;
      if (byMain != null) return byMain.id;
      for (final entry in _links.entries) {
        if (entry.value.any((l) => l.link == name && l.isActive(now))) return entry.key;
      }
      return '';
    }
    final lower = name.toLowerCase();
    final chat = _chats.where((c) => c.username.toLowerCase() == lower && !c.isThread).firstOrNull;
    if (chat != null) return chat.id;
    // @username участника группы / контакта — личный чат с ним.
    final person = [
      ..._contacts(),
      ..._members.values.expand((list) => list),
    ].where((m) => !m.isSelf && m.username.toLowerCase() == lower).firstOrNull;
    return person == null ? '' : openPrivateChat(person.id);
  }

  /// «Анна Смирнова» → «anna_smirnova» (демо-username участников).
  static String _translit(String name) {
    const map = {
      'а': 'a',
      'б': 'b',
      'в': 'v',
      'г': 'g',
      'д': 'd',
      'е': 'e',
      'ё': 'e',
      'ж': 'zh',
      'з': 'z',
      'и': 'i',
      'й': 'y',
      'к': 'k',
      'л': 'l',
      'м': 'm',
      'н': 'n',
      'о': 'o',
      'п': 'p',
      'р': 'r',
      'с': 's',
      'т': 't',
      'у': 'u',
      'ф': 'f',
      'х': 'h',
      'ц': 'ts',
      'ч': 'ch',
      'ш': 'sh',
      'щ': 'sch',
      'ъ': '',
      'ы': 'y',
      'ь': '',
      'э': 'e',
      'ю': 'yu',
      'я': 'ya',
      ' ': '_',
    };
    return name.toLowerCase().split('').map((c) => map[c] ?? c).join();
  }

  @override
  Future<void> joinChat(String chatID) async {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    // В скрытую группу сообщества самому не вступить — добавляют админы.
    if (chat == null || chat.isMember || (chat.inCommunity && chat.joinMode == models.ChatJoinMode.admins)) return;
    if (chat.joinMode == models.ChatJoinMode.request) {
      _update(chatID, (c) => c.copyWith(joinRequested: true));
      // Демо: админ одобряет через несколько секунд.
      Timer(const Duration(seconds: 5), () => _becomeMember(chatID));
      return;
    }
    _becomeMember(chatID);
  }

  void _becomeMember(String chatID) {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || chat.isMember) return;
    // В сообщество — вместе с каналом объявлений (своей ленты у него нет).
    if (chat.type == models.ChatType.community) {
      _update(chatID, (c) => c.copyWith(isMember: true, joinRequested: false, myRole: c.defaultRole, membersCount: c.membersCount + 1));
      for (final news in _communityChats(chatID).where((c) => c.announcements)) {
        _becomeMember(news.id);
      }
      return;
    }
    final role = chat.type == models.ChatType.channel ? models.ChatRole.reader : chat.defaultRole;
    _update(
      chatID,
      (c) => c.copyWith(
        isMember: true,
        joinRequested: false,
        myRole: role,
        membersCount: c.membersCount + 1,
        createdAt: DateTime.now(),
        joinedAt: DateTime.now(),
      ),
    );
    _members.remove(chatID);
    _service(chatID, chat.type == models.ChatType.channel ? 'Вы подписались на канал' : 'Вы вступили в группу');
  }

  // ─── Опросы ───────────────────────────────────────────────────────────────

  @override
  Future<void> votePoll(String chatID, String messageID, List<int> options) async {
    _updateMessage(chatID, messageID, (m) {
      final poll = m.poll;
      if (poll == null || poll.closed) return m;
      // Ответ викторины не отменяется и не меняется.
      if (poll.quiz && poll.voted) return m;
      final open = !poll.anonymous;
      return m.copyWith(
        poll: poll.copyWith(
          options: [
            for (final (i, o) in poll.options.indexed)
              () {
                final was = o.chosen;
                final now = options.contains(i);
                if (was == now) return o;
                return o.copyWith(
                  chosen: now,
                  votes: max(0, o.votes + (now ? 1 : -1)),
                  voters: open
                      ? (now
                            ? [...o.voters, 'Вы']
                            : [
                                for (final v in o.voters)
                                  if (v != 'Вы') v,
                              ])
                      : o.voters,
                );
              }(),
          ],
        ),
      );
    });
  }

  @override
  Future<void> closePoll(String chatID, String messageID) async =>
      _updateMessage(chatID, messageID, (m) => m.poll == null ? m : m.copyWith(poll: m.poll!.copyWith(closed: true)));

  /// Демо-опрос группы / канала.
  models.MessagePoll _seedPoll({required bool channel}) {
    if (channel) {
      return const models.MessagePoll(
        question: 'Чем вы пользуетесь чаще?',
        options: [
          models.PollOption(text: 'Личными чатами', votes: 412),
          models.PollOption(text: 'Группами', votes: 268),
          models.PollOption(text: 'Каналами', votes: 133),
        ],
      );
    }
    return const models.MessagePoll(
      question: 'Когда созвон по релизу?',
      anonymous: false,
      options: [
        models.PollOption(text: 'Понедельник, 11:00', votes: 2, voters: ['Анна', 'Ольга']),
        models.PollOption(text: 'Вторник, 15:00', votes: 3, voters: ['Дмитрий', 'Сергей', 'Иван']),
        models.PollOption(text: 'Среда, 10:00', votes: 1, voters: ['Мария']),
      ],
    );
  }

  /// Чужие голоса в открытых опросах (раз в такт, в случайный незавершённый).
  void _tickPolls() {
    final candidates = <(String, models.Message)>[
      for (final entry in _messages.entries)
        for (final m in entry.value)
          if (m.poll case final poll? when !poll.closed && !poll.quiz) (entry.key, m),
    ];
    if (candidates.isEmpty || _random.nextInt(2) == 0) return;
    final (chatID, message) = candidates[_random.nextInt(candidates.length)];
    final poll = message.poll!;
    final pick = _random.nextInt(poll.options.length);
    final voter = _names[_random.nextInt(_names.length)];
    _updateMessage(
      chatID,
      message.id,
      (m) => m.copyWith(
        poll: poll.copyWith(
          options: [
            for (final (i, o) in poll.options.indexed)
              i == pick ? o.copyWith(votes: o.votes + 1, voters: poll.anonymous ? o.voters : [...o.voters, voter]) : o,
          ],
        ),
      ),
    );
  }

  /// Профиль демо-чата: «О себе» / описание, @username, число участников и
  /// наша роль.
  models.Chat _withProfile(models.Chat chat) {
    final withProfile = _profileOf(chat);
    // Публичные (с username) — открытые; в рабочих и дружеских группах
    // вступившие сразу могут писать.
    // Чаты сообществ: своих ссылок нет, вступление — одним нажатием, кроме
    // «закрытых тем» (по заявке).
    if (chat.inCommunity) {
      return withProfile.copyWith(
        joinMode: switch (chat.id) {
          'spices_vip' => models.ChatJoinMode.request,
          // Скрытые: гости их не видят («Персонал» ресторана нам не виден вовсе).
          'coffee_staff' || 'spices_staff' || 'kuksu_staff' => models.ChatJoinMode.admins,
          _ => models.ChatJoinMode.open,
        },
        defaultRole: chat.type == models.ChatType.channel ? models.ChatRole.reader : models.ChatRole.writer,
        commentsEnabled: chat.id == 'devs_jobs',
        membersHidden: chat.type == models.ChatType.channel,
      );
    }
    return withProfile.copyWith(
      joinMode: chat.id == 'designers'
          ? models.ChatJoinMode.request
          : (withProfile.username.isNotEmpty ? models.ChatJoinMode.open : models.ChatJoinMode.link),
      inviteLink: chat.id == 'designers'
          ? '+DesignClubJoin'
          : (withProfile.username.isEmpty && withProfile.type != models.ChatType.private
                ? '+K${(chat.id.hashCode & 0xFFFFFFF).toRadixString(36)}hQ'
                : ''),
      defaultRole: const {'team', 'family', 'football', 'district', 'devs', 'spices', 'coffee', 'kuksu'}.contains(chat.id)
          ? models.ChatRole.writer
          : models.ChatRole.reader,
      commentsEnabled: const {'news', 'flutter', 'tech', 'iperon_dev'}.contains(chat.id),
      // Срок комментирования: у старых постов этих каналов ветки уже закрыты.
      commentsTimeLimit: switch (chat.id) {
        'flutter' => 3 * 86400,
        'tech' => 86400,
        _ => 0,
      },
      // Комментируют только подписчики: «Iperon Dev» (мы не подписаны —
      // «Подписаться, чтобы комментировать»; подпишемся — ждать 1 час).
      commentsWho: chat.id == 'iperon_dev' ? models.ChatCommentsWho.subscribers : models.ChatCommentsWho.all,
      commentsMinSubscription: chat.id == 'iperon_dev' ? 3600 : 0,
      // «Новичкам — без ссылок и медиа» на сутки: вступим в «Flutter Moscow» /
      // подпишемся на «Iperon Dev» — первые сутки только текст.
      newcomerMediaDelay: const {'iperon_dev', 'flutter_msk'}.contains(chat.id) ? 86400 : 0,
      signMessages: const {'news', 'iperon_dev'}.contains(chat.id),
      // Подписчиков канала по умолчанию видят только админы; у ресторана —
      // и участников сообщества (гостям незачем видеть друг друга).
      membersHidden: chat.type == models.ChatType.channel || chat.id == 'spices',
    );
  }

  models.Chat _profileOf(models.Chat chat) {
    final now = DateTime.now();
    return switch (chat.id) {
      'anna' => chat.copyWith(about: 'Дизайнер интерфейсов. Люблю горы 🏔', username: 'anna_smirnova', online: true),
      'dmitry' => chat.copyWith(about: 'Backend, Go, Kubernetes', username: 'dkozlov', lastSeen: now.subtract(const Duration(minutes: 25))),
      'olga' => chat.copyWith(lastSeen: now.subtract(const Duration(hours: 2))),
      'maria' => chat.copyWith(about: 'Юрист', lastSeen: now.subtract(const Duration(days: 1))),
      'sergey' => chat.copyWith(username: 'spetrov', lastSeen: now.subtract(const Duration(hours: 5))),
      'alexey' => chat.copyWith(online: true),
      'team' => chat.copyWith(about: 'Рабочий чат команды Iperon: релизы, баги, планы.', membersCount: 12, myRole: models.ChatRole.admin),
      'family' => chat.copyWith(membersCount: 6, myRole: models.ChatRole.owner),
      'football' => chat.copyWith(about: 'Каждую среду в 20:00, манеж на Ленинградке.', membersCount: 18),
      'school' => chat.copyWith(about: 'Чат родителей 5 «Б» класса школы № 1234.', membersCount: 27, myRole: models.ChatRole.reader),
      'district' => chat.copyWith(
        about: 'Сообщество жителей ЖК «Северный»: новости УК, соседи, объявления.',
        username: 'severny_zhk',
        membersCount: 1340,
      ),
      'district_news' => chat.copyWith(membersCount: 1340),
      'district_neighbors' => chat.copyWith(membersCount: 860),
      'district_parking' => chat.copyWith(membersCount: 410),
      'district_kids' => chat.copyWith(membersCount: 225),
      'devs' => chat.copyWith(about: 'Русскоязычное сообщество Flutter-разработчиков.', username: 'flutter_ru', membersCount: 8420),
      'devs_news' => chat.copyWith(membersCount: 8420),
      // Большой общий чат — с медленным режимом (мы обычный участник).
      'devs_chat' => chat.copyWith(about: 'Вопросы, обсуждения, новости.', membersCount: 6130, slowMode: 30),
      'devs_jobs' => chat.copyWith(about: 'Вакансии и резюме. Публикуют админы.', membersCount: 3900),
      'devs_newbies' => chat.copyWith(about: 'Здесь можно спрашивать что угодно.', membersCount: 1210),
      'spices' => chat.copyWith(
        about: 'Ресторан восточной кухни. Ежедневно 12:00–23:00, ул. Лесная, 5. Бронь столиков — +7 495 123-45-67.',
        username: 'spices_rest',
        membersCount: 2140,
        myRole: models.ChatRole.writer,
      ),
      'spices_news' => chat.copyWith(membersCount: 2140),
      'spices_reviews' => chat.copyWith(about: 'Делитесь впечатлениями — мы читаем всё.', membersCount: 230),
      'spices_vip' => chat.copyWith(about: 'Закрытый клуб гостей: дегустации и ранняя бронь.', membersCount: 48),
      'coffee' => chat.copyWith(
        about: 'Кофейня у метро «Сокол». Каждый день 7:30–21:00.',
        username: 'zerno_coffee',
        membersCount: 312,
        myRole: models.ChatRole.owner,
      ),
      'coffee_news' => chat.copyWith(membersCount: 312),
      'coffee_staff' => chat.copyWith(about: 'Смены, поставки, рабочие вопросы.', membersCount: 6),
      'coffee_guests' => chat.copyWith(membersCount: 154),
      'kuksu' => chat.copyWith(
        about: 'Ресторан корейской кухни. Основан в 2014 году.',
        username: 'domkuksu',
        phone: '+79260906996',
        address: 'Москва, Симферопольский бульвар, 22, корп. 3, стр. 2',
        latitude: 55.650088,
        longitude: 37.606609,
        membersCount: 520,
        myRole: models.ChatRole.owner,
      ),
      'kuksu_news' => chat.copyWith(avatarPath: 'assets/demo/domkuksu_logo.png', membersCount: 520),
      'kuksu_guests' => chat.copyWith(about: 'Отзывы, вопросы, пожелания.', membersCount: 214),
      'kuksu_staff' => chat.copyWith(about: 'Смены и рабочие вопросы.', membersCount: 12),
      'news' => chat.copyWith(
        about: 'Новости мессенджера Iperon.',
        username: 'iperon_news',
        membersCount: 15400,
        myRole: models.ChatRole.reader,
      ),
      'flutter' => chat.copyWith(
        about: 'Всё о Flutter и Dart.',
        username: 'flutter_dev',
        membersCount: 52300,
        myRole: models.ChatRole.reader,
        // Под постом не больше 3 разных реакций — набрано, новые не поставить.
        maxReactions: 3,
      ),
      'tech' => chat.copyWith(
        about: 'Обзоры гаджетов и технологий.',
        username: 'tech_review',
        membersCount: 3100,
        myRole: models.ChatRole.owner,
      ),
      'shop' => chat.copyWith(membersCount: 920, myRole: models.ChatRole.reader),
      'iperon_dev' => chat.copyWith(
        about: 'Как мы делаем Iperon: архитектура, релизы, грабли.',
        username: 'iperon_dev',
        membersCount: 2480,
      ),
      'flutter_msk' => chat.copyWith(
        about: 'Flutter-сообщество Москвы: митапы, вакансии, помощь.',
        username: 'flutter_msk',
        membersCount: 864,
      ),
      'designers' => chat.copyWith(about: 'Закрытый клуб продуктовых дизайнеров. Вступление — по заявке.', membersCount: 312),
      _ => chat,
    };
  }

  @override
  Future<void> delete(String chatID) async {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null) return;
    // Из группы / канала сообщества выходим, но чат остаётся в сообществе —
    // можно вступить снова; удаляет его у всех только владелец.
    if (chat.inCommunity && chat.myRole != models.ChatRole.owner) {
      _members.remove(chatID);
      _update(
        chatID,
        (c) => c.copyWith(
          isMember: false,
          myRole: models.ChatRole.reader,
          membersCount: max(0, c.membersCount - 1),
          unreadCount: 0,
          unreadMentions: 0,
          markedUnread: false,
          muted: false,
        ),
      );
      return;
    }
    // Сообщество — вместе со всеми его чатами.
    _chats = _chats.where((c) => c.id != chatID && c.communityID != chatID).toList();
    _emit();
  }

  @override
  Future<void> deleteFolder(String folderID) async {
    _folders = _folders.where((f) => f.isAll || f.id != folderID).toList();
    _foldersController.add(_folders);
  }

  @override
  Future<void> saveFolder(models.ChatFolder folder) async {
    final index = _folders.indexWhere((f) => f.id == folder.id);
    if (index >= 0) {
      _folders = [..._folders]..[index] = folder;
    } else {
      if (_folders.length >= models.chatFoldersLimit) return;
      _folders = [..._folders, folder];
    }
    _foldersController.add(_folders);
  }

  @override
  Future<void> reorderFolders(List<String> folderIDs) async {
    final byID = {for (final f in _folders) f.id: f};
    _folders = [
      ..._folders.where((f) => f.isAll),
      for (final id in folderIDs)
        if (byID[id] case final folder? when !folder.isAll) folder,
      // Не названные в folderIDs (не должно быть) — в конец, не теряем.
      ..._folders.where((f) => !f.isAll && !folderIDs.contains(f.id)),
    ];
    _foldersController.add(_folders);
  }

  // ─── Сообщения ────────────────────────────────────────────────────────────

  /// История по чатам (от старых к новым); генерируется при первом открытии.
  final _messages = <String, List<models.Message>>{};
  final _messagesController = StreamController<String>.broadcast();
  var _nextID = 0;

  String _id() => 'm${_nextID++}';

  List<models.Message> _history(String chatID) => _messages.putIfAbsent(chatID, () => _seedMessages(chatID));

  @override
  Stream<List<models.Message>> watchMessages(String chatID) async* {
    yield _history(chatID);
    yield* _messagesController.stream.where((id) => id == chatID).map((_) => _history(chatID));
  }

  void _setMessages(String chatID, List<models.Message> messages) {
    _messages[chatID] = messages;
    _messagesController.add(chatID);
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat != null && chat.isThread) _syncComments(chat);
  }

  void _updateMessage(String chatID, String messageID, models.Message Function(models.Message) change) {
    _setMessages(chatID, [for (final m in _history(chatID)) m.id == messageID ? change(m) : m]);
  }

  models.ChatLastMessage _lastOf(models.Message m) => models.ChatLastMessage(
    kind: m.kind,
    text: m.kind == models.MessageKind.file && m.text.isEmpty ? m.fileName : m.text,
    senderName: m.outgoing ? '' : m.senderName,
    outgoing: m.outgoing,
    status: m.status,
    date: m.date,
  );

  /// Последнее сообщение чата в списке — по истории (после правки/удаления).
  void _syncLast(String chatID) {
    final history = _history(chatID).where((m) => !m.service);
    _update(chatID, (c) => c.copyWith(lastMessage: history.isEmpty ? null : _lastOf(history.last)));
  }

  @override
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
  }) async {
    if (scheduleDate != null && scheduleDate.isAfter(DateTime.now())) {
      _schedule(
        models.Message(
          id: _id(),
          chatID: chatID,
          text: text,
          entities: entities,
          outgoing: true,
          status: models.MessageStatus.pending,
          date: DateTime.now(),
          reply: reply,
          silent: silent,
          scheduledDate: scheduleDate,
          linkPreview: linkPreview ? _linkPreviewOf(text, entities) : null,
        ),
      );
      return;
    }
    final fileSize = kind == models.MessageKind.file ? await _fileSize(localPath) : 0;
    // Байты к загрузке: фото/видео альбома или одиночное медиа/файл.
    var uploadTotal = 0;
    if (kind != models.MessageKind.text) {
      final paths = media.isNotEmpty ? [for (final m in media) m.localPath] : [localPath];
      for (final (i, path) in paths.indexed) {
        final known = media.length > i ? media[i].size : 0;
        uploadTotal += known > 0 ? known : await _fileSize(path);
      }
    }
    final now = DateTime.now();
    final message = models.Message(
      id: _id(),
      chatID: chatID,
      kind: kind,
      text: text,
      entities: entities,
      outgoing: true,
      status: models.MessageStatus.pending,
      date: now,
      reply: reply,
      localPath: localPath,
      fileName: fileName,
      media: media,
      duration: duration,
      waveform: waveform,
      fileSize: fileSize,
      uploadTotal: uploadTotal,
      silent: silent,
      linkPreview: linkPreview && kind == models.MessageKind.text ? _linkPreviewOf(text, entities) : null,
      poll: poll,
      // Пост канала: сразу 1 просмотр (наш), дальше растут.
      views: _isChannel(chatID) ? 1 : 0,
      authorSignature: _chats.any((c) => c.id == chatID && c.type == models.ChatType.channel && c.signMessages) ? await _selfName() : '',
      commentsCloseDate: _commentsCloseDate(chatID, now),
    );
    _setMessages(chatID, [..._history(chatID), message]);
    _update(chatID, (c) => c.copyWith(lastMessage: _lastOf(message), draft: '', archived: false));
    _slowModeSent(chatID);

    if (uploadTotal > 0) {
      _simulateUpload(chatID, message.id, uploadTotal, onDone: () => _delivered(chatID, message.id));
    } else {
      _delivered(chatID, message.id);
    }
  }

  /// Превью первой ссылки (демо: заготовки для известных сайтов, иначе — имя
  /// хоста). Настоящие соберёт сервер.
  models.MessageLinkPreview? _linkPreviewOf(String text, List<models.MessageEntity> entities) {
    final url = firstLinkUrl(text, entities);
    final host = url == null ? null : Uri.tryParse(url)?.host.replaceFirst(RegExp(r'^www\.'), '');
    if (url == null || host == null || host.isEmpty) return null;
    final (site, title, description) = switch (host) {
      'flutter.dev' || 'docs.flutter.dev' => (
        'Flutter',
        'Flutter documentation',
        'Get started with Flutter. Widgets, examples, updates, and API docs to help you write your first Flutter app.',
      ),
      'github.com' => (
        'GitHub',
        'GitHub · Build and ship software on a single, collaborative platform',
        'Join the world’s most widely adopted developer platform.',
      ),
      'youtube.com' || 'youtu.be' => ('YouTube', 'YouTube', 'Смотрите любимые видео, слушайте музыку и делитесь ими с друзьями.'),
      'iperon.net' => ('Iperon', 'Iperon — мессенджер', 'Звонки, чаты и каналы с шифрованием.'),
      _ => (host, host, ''),
    };
    return models.MessageLinkPreview(url: url, siteName: site, title: title, description: description);
  }

  /// Отложенные по чатам (от ранних к поздним) и их таймеры (id → таймер).
  final _scheduled = <String, List<models.Message>>{};
  final _scheduleTimers = <String, Timer>{};
  final _scheduledController = StreamController<String>.broadcast();

  List<models.Message> _scheduledOf(String chatID) => _scheduled[chatID] ?? const [];

  void _setScheduled(String chatID, List<models.Message> messages) {
    _scheduled[chatID] = [...messages]..sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));
    _scheduledController.add(chatID);
  }

  /// В список отложенных + таймер на отправку.
  void _schedule(models.Message message) {
    final chatID = message.chatID;
    _scheduleTimers.remove(message.id)?.cancel();
    _setScheduled(chatID, [
      for (final m in _scheduledOf(chatID))
        if (m.id != message.id) m,
      message,
    ]);
    final delay = message.scheduledDate!.difference(DateTime.now());
    _scheduleTimers[message.id] = Timer(delay.isNegative ? Duration.zero : delay, () => sendScheduledNow(chatID, message.id));
  }

  @override
  Stream<List<models.Message>> watchScheduled(String chatID) async* {
    yield _scheduledOf(chatID);
    yield* _scheduledController.stream.where((id) => id == chatID).map((_) => _scheduledOf(chatID));
  }

  @override
  Future<void> sendScheduledNow(String chatID, String messageID) async {
    final message = _scheduledOf(chatID).where((m) => m.id == messageID).firstOrNull;
    await deleteScheduled(chatID, messageID);
    if (message == null) return;
    await sendMessage(
      chatID,
      text: message.text,
      entities: message.entities,
      reply: message.reply,
      silent: message.silent,
      linkPreview: message.linkPreview != null,
    );
  }

  @override
  Future<void> rescheduleMessage(String chatID, String messageID, DateTime date) async {
    final message = _scheduledOf(chatID).where((m) => m.id == messageID).firstOrNull;
    if (message != null) _schedule(message.copyWith(scheduledDate: date));
  }

  @override
  Future<void> deleteScheduled(String chatID, String messageID) async {
    _scheduleTimers.remove(messageID)?.cancel();
    _setScheduled(chatID, [
      for (final m in _scheduledOf(chatID))
        if (m.id != messageID) m,
    ]);
  }

  /// Идущие загрузки вложений (id сообщения → таймер), см. [cancelUpload].
  final _uploads = <String, Timer>{};

  /// Имитация загрузки на CDN: ~250–450 КБ/с с колебаниями, шаг 100 мс —
  /// чтобы прогресс было видно даже на сжатом фото.
  void _simulateUpload(String chatID, String messageID, int total, {required void Function() onDone}) {
    var sent = 0;
    _uploads[messageID] = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_chats.any((c) => c.id == chatID) || !_history(chatID).any((m) => m.id == messageID)) {
        timer.cancel();
        _uploads.remove(messageID);
        return;
      }
      sent = min(total, sent + 25000 + _random.nextInt(20000));
      final done = sent >= total;
      _updateMessage(chatID, messageID, (m) => m.copyWith(uploadedBytes: done ? 0 : sent, uploadTotal: done ? 0 : total));
      if (done) {
        timer.cancel();
        _uploads.remove(messageID);
        onDone();
      }
    });
  }

  Future<int> _fileSize(String path) async {
    if (path.isEmpty) return 0;
    try {
      return await File(path).length();
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<void> setReactions(String chatID, String messageID, List<String> emojis) async {
    _updateMessage(chatID, messageID, (m) => m.copyWith(reactions: applyMyReactions(m.reactions, emojis)));
  }

  @override
  Future<void> cancelUpload(String chatID, String messageID) async {
    _uploads.remove(messageID)?.cancel();
    await deleteMessage(chatID, messageID);
  }

  /// Сервер принял сообщение (после загрузки вложений, если были): ⏱ → ✓ →
  /// в личном чате собеседник читает, печатает, отвечает.
  void _delivered(String chatID, String messageID) {
    final message = _history(chatID).where((m) => m.id == messageID).firstOrNull;
    if (message == null) return;
    Timer(const Duration(milliseconds: 700), () => _setStatus(chatID, message.id, models.MessageStatus.sent));
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || chat.isSelf) {
      Timer(const Duration(milliseconds: 900), () => _setStatus(chatID, message.id, models.MessageStatus.read));
      return;
    }
    if (chat.type == models.ChatType.channel) return;
    Timer(const Duration(milliseconds: 1800), () {
      _setStatus(chatID, message.id, models.MessageStatus.read);
      // Иногда собеседник отвечает реакцией на наше сообщение.
      if (_random.nextInt(3) == 0 && _history(chatID).any((m) => m.id == message.id)) {
        final emoji = ['❤️', '👍', '🔥', '😂'][_random.nextInt(4)];
        _updateMessage(chatID, message.id, (m) => m.copyWith(reactions: addOtherReaction(m.reactions, emoji)));
      }
      final sender = chat.type == models.ChatType.private ? chat.title : _names[_random.nextInt(_names.length)];
      _update(chatID, (c) => c.copyWith(typing: sender));
    });
    Timer(const Duration(milliseconds: 4200), () => _incoming(chatID));
  }

  void _setStatus(String chatID, String messageID, models.MessageStatus status) {
    if (!_chats.any((c) => c.id == chatID)) return;
    _updateMessage(chatID, messageID, (m) => m.copyWith(status: status));
    final last = _history(chatID).lastOrNull;
    if (last?.id == messageID) _update(chatID, (c) => c.copyWith(lastMessage: _lastOf(last!)));
  }

  /// Входящее в чат: в историю (если она уже открыта) и в список чатов.
  void _incoming(String chatID, {bool mention = false}) {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null) return;
    final sender = chat.typing.isNotEmpty
        ? chat.typing
        : (chat.type == models.ChatType.private ? chat.title : _names[_random.nextInt(_names.length)]);
    final (text, entities) = parseMarkdownShortcuts(
      mention ? '@you ${_phrases[_random.nextInt(_phrases.length)]}' : _phrases[_random.nextInt(_phrases.length)],
    );
    final message = models.Message(
      id: _id(),
      chatID: chatID,
      text: text,
      entities: entities,
      senderName: chat.type == models.ChatType.private ? '' : sender,
      date: DateTime.now(),
    );
    if (_messages.containsKey(chatID)) _setMessages(chatID, [..._history(chatID), message]);
    _update(
      chatID,
      (c) => c.copyWith(
        typing: '',
        unreadCount: c.unreadCount + 1,
        unreadMentions: c.unreadMentions + (mention ? 1 : 0),
        lastMessage: _lastOf(message),
      ),
    );
  }

  @override
  Future<void> editMessage(String chatID, String messageID, String text, List<models.MessageEntity> entities) async {
    _updateMessage(
      chatID,
      messageID,
      (m) => m.copyWith(text: text, entities: entities, edited: true, linkPreview: _linkPreviewOf(text, entities)),
    );
    _syncLast(chatID);
  }

  @override
  Future<void> deleteMessage(String chatID, String messageID, {bool forEveryone = true}) async {
    // Демо: собеседника нет — у себя и у всех удаляется одинаково.
    _setMessages(chatID, _history(chatID).where((m) => m.id != messageID).toList());
    _syncLast(chatID);
  }

  @override
  Future<void> setMessagePinned(String chatID, String messageID, bool pinned, {bool forEveryone = true}) async {
    _updateMessage(chatID, messageID, (m) => m.copyWith(pinned: pinned));
    if (!pinned || !forEveryone) return;
    _setMessages(chatID, [
      ..._history(chatID),
      models.Message(
        id: _id(),
        chatID: chatID,
        outgoing: true,
        service: true,
        status: models.MessageStatus.read,
        date: DateTime.now(),
        pinnedMessageID: messageID,
      ),
    ]);
  }

  @override
  Future<void> unpinAllMessages(String chatID) async {
    _setMessages(chatID, [for (final m in _history(chatID)) m.pinned ? m.copyWith(pinned: false) : m]);
  }

  @override
  Future<void> forwardMessages(String toChatID, List<models.Message> messages) async {
    final source = {for (final c in _chats) c.id: c};
    final now = DateTime.now();
    final copies = [
      for (final (i, m) in messages.indexed)
        models.Message(
          id: _id(),
          chatID: toChatID,
          kind: m.kind,
          text: m.text,
          entities: m.entities,
          outgoing: true,
          status: models.MessageStatus.pending,
          date: now.add(Duration(microseconds: i)),
          localPath: m.localPath,
          fileName: m.fileName,
          duration: m.duration,
          waveform: m.waveform,
          media: m.media,
          fileSize: m.fileSize,
          poll: m.poll,
          commentsCloseDate: _commentsCloseDate(toChatID, now),
          // Пересылка пересланного — автор оригинала остаётся прежним.
          forward:
              m.forward ??
              models.MessageForward(
                self: m.outgoing,
                name: m.outgoing ? '' : (m.senderName.isNotEmpty ? m.senderName : source[m.chatID]?.title ?? ''),
              ),
        ),
    ];
    if (copies.isEmpty) return;
    _setMessages(toChatID, [..._history(toChatID), ...copies]);
    _update(toChatID, (c) => c.copyWith(lastMessage: _lastOf(copies.last), archived: false));
    _slowModeSent(toChatID);
    // Файлы уже на CDN — пересылка без загрузки: сразу «доставлено».
    for (final m in copies.take(copies.length - 1)) {
      Timer(const Duration(milliseconds: 700), () => _setStatus(toChatID, m.id, models.MessageStatus.sent));
    }
    _delivered(toChatID, copies.last.id);
  }

  @override
  Future<void> setDraft(String chatID, String draft) async {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || chat.draft == draft) return;
    _update(chatID, (c) => c.copyWith(draft: draft));
  }

  void _update(String chatID, models.Chat Function(models.Chat) change) {
    _chats = [for (final c in _chats) c.id == chatID ? change(c) : c];
    _emit();
  }

  // ─── Имитация жизни ───────────────────────────────────────────────────────

  void _startSimulation() {
    _timer ??= Timer.periodic(const Duration(seconds: 9), (_) => _tick());
  }

  void _stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }

  /// Один «такт»: случайный неархивный чат (кроме каналов — там не печатают)
  /// начинает печатать, через 3 с приходит сообщение. Заодно наши отправленные
  /// сообщения становятся прочитанными.
  bool _isChannel(String chatID) => _chats.any((c) => c.id == chatID && c.type == models.ChatType.channel);

  void _tick() {
    _tickPolls();
    // Просмотры свежих постов открытых каналов растут.
    for (final channel in _chats.where((c) => c.type == models.ChatType.channel && _messages.containsKey(c.id))) {
      final history = _history(channel.id);
      final recent = history.where((m) => !m.service).toList().reversed.take(3).map((m) => m.id).toSet();
      if (recent.isEmpty) continue;
      _setMessages(channel.id, [for (final m in history) recent.contains(m.id) ? m.copyWith(views: m.views + 1 + _random.nextInt(12)) : m]);
    }

    // Изредка — новая заявка туда, где их ждут.
    final accepting = _chats.where(_acceptsRequests).toList();
    if (accepting.isNotEmpty && _random.nextInt(3) == 0) {
      final chat = accepting[_random.nextInt(accepting.length)];
      final now = DateTime.now();
      final approvalLinks = (_links[chat.id] ?? const <models.ChatInviteLink>[])
          .where((l) => l.requestApproval && l.isActive(now))
          .toList();
      final viaLink = chat.joinMode != models.ChatJoinMode.request || (approvalLinks.isNotEmpty && _random.nextBool());
      _addRequest(chat.id, link: viaLink && approvalLinks.isNotEmpty ? approvalLinks[_random.nextInt(approvalLinks.length)] : null);
    }

    final candidates = _chats
        .where(
          (c) =>
              c.isMember &&
              !c.archived &&
              !c.isSelf &&
              c.type != models.ChatType.channel &&
              c.type != models.ChatType.community &&
              c.draft.isEmpty &&
              !c.commentsClosed() &&
              // Новая группа, где пока только мы, — писать некому.
              (c.type == models.ChatType.private || c.membersCount > 1),
        )
        .toList();
    if (candidates.isEmpty) return;
    final chat = candidates[_random.nextInt(candidates.length)];
    final sender = chat.type == models.ChatType.private ? chat.title : _names[_random.nextInt(_names.length)];

    _update(chat.id, (c) => c.copyWith(typing: sender));

    Timer(const Duration(seconds: 3), () {
      if (!_chats.any((c) => c.id == chat.id)) return;
      _incoming(chat.id, mention: chat.type != models.ChatType.private && _random.nextInt(5) == 0);
    });

    final readable = _chats.where((c) => c.lastMessage?.outgoing == true && c.lastMessage?.status == models.MessageStatus.sent);
    if (readable.isNotEmpty) {
      final c = readable.first;
      _update(c.id, (c) => c.copyWith(lastMessage: c.lastMessage!.copyWith(status: models.MessageStatus.read)));
      if (_messages.containsKey(c.id)) {
        _setMessages(c.id, [
          for (final m in _history(c.id))
            m.outgoing && m.status == models.MessageStatus.sent ? m.copyWith(status: models.MessageStatus.read) : m,
        ]);
      }
    }
  }

  // ─── Начальные данные ─────────────────────────────────────────────────────

  static const _names = ['Анна', 'Дмитрий', 'Ольга', 'Сергей', 'Мария', 'Алексей', 'Екатерина', 'Иван'];

  static const _phrases = [
    'Ок, договорились 👍',
    'Скинь, пожалуйста, ещё раз ссылку',
    'Буду через 10 минут',
    'Посмотрел, всё отлично',
    'А во сколько встречаемся?',
    'Спасибо!',
    'Созвонимся вечером?',
    'Уже выезжаю',
  ];

  List<models.Chat> _seedChats() {
    final now = DateTime.now();
    DateTime ago({int days = 0, int hours = 0, int minutes = 0}) => now.subtract(Duration(days: days, hours: hours, minutes: minutes));
    models.ChatLastMessage msg(
      String text, {
      required DateTime date,
      String sender = '',
      bool out = false,
      models.MessageStatus status = models.MessageStatus.sent,
      models.MessageKind kind = models.MessageKind.text,
    }) => models.ChatLastMessage(text: text, senderName: sender, outgoing: out, status: status, kind: kind, date: date);

    return [
      models.Chat(
        id: 'saved',
        type: models.ChatType.private,
        title: 'Избранное',
        isContact: true,
        isSelf: true,
        pinned: true,
        lastMessage: msg('Список покупок: молоко, хлеб, кофе', out: true, status: models.MessageStatus.read, date: ago(days: 1)),
      ),
      models.Chat(
        id: 'anna',
        type: models.ChatType.private,
        title: 'Анна Смирнова',
        isContact: true,
        pinned: true,
        unreadCount: 2,
        lastMessage: msg('Ты сегодня будешь на встрече?', date: ago(minutes: 4)),
      ),
      models.Chat(
        id: 'team',
        type: models.ChatType.group,
        title: 'Команда Iperon',
        unreadCount: 14,
        unreadMentions: 1,
        lastMessage: msg('Релиз 0.0.240 ушёл в TestFlight', sender: 'Дмитрий', date: ago(minutes: 12)),
      ),
      models.Chat(
        id: 'dmitry',
        type: models.ChatType.private,
        title: 'Дмитрий Козлов',
        isContact: true,
        lastMessage: msg('Скинул макеты, глянь', out: true, status: models.MessageStatus.sent, date: ago(minutes: 30)),
      ),
      models.Chat(
        id: 'news',
        type: models.ChatType.channel,
        title: 'Iperon News',
        muted: true,
        unreadCount: 3,
        lastMessage: msg('Встречайте папки в списке чатов!', kind: models.MessageKind.photo, date: ago(hours: 1)),
      ),
      models.Chat(
        id: 'olga',
        type: models.ChatType.private,
        title: 'Ольга',
        isContact: true,
        draft: 'Напомни, пожалуйста, адрес',
        lastMessage: msg('Хорошо, до завтра', date: ago(hours: 2)),
      ),
      // Сообщества: строка в списке — сводка по их чатам (см. `_present`),
      // сами чаты — ниже, в «Чатах сообществ».
      models.Chat(id: 'district', type: models.ChatType.community, title: 'Жители ЖК «Северный»', muted: true),
      models.Chat(
        id: 'family',
        type: models.ChatType.group,
        title: 'Семья ❤️',
        lastMessage: msg('', kind: models.MessageKind.photo, sender: 'Мама', date: ago(hours: 5)),
      ),
      models.Chat(
        id: 'unknown',
        type: models.ChatType.private,
        title: '+7 916 123-45-67',
        unreadCount: 1,
        lastMessage: msg('Здравствуйте! Вы продаёте велосипед?', date: ago(hours: 7)),
      ),
      models.Chat(
        id: 'sergey',
        type: models.ChatType.private,
        title: 'Сергей Петров',
        isContact: true,
        markedUnread: true,
        lastMessage: msg('', kind: models.MessageKind.voice, date: ago(days: 1, hours: 2)),
      ),
      models.Chat(
        id: 'flutter',
        type: models.ChatType.channel,
        title: 'Flutter Dev',
        lastMessage: msg('Вышел Flutter 4.2 — что нового', date: ago(days: 1, hours: 5)),
      ),
      models.Chat(
        id: 'maria',
        type: models.ChatType.private,
        title: 'Мария',
        isContact: true,
        lastMessage: msg('договор.pdf', kind: models.MessageKind.file, out: true, status: models.MessageStatus.read, date: ago(days: 2)),
      ),
      models.Chat(
        id: 'football',
        type: models.ChatType.group,
        title: 'Футбол по средам ⚽',
        muted: true,
        unreadCount: 5,
        lastMessage: msg('Кто сегодня идёт?', sender: 'Иван', date: ago(days: 2, hours: 3)),
      ),
      models.Chat(
        id: 'alexey',
        type: models.ChatType.private,
        title: 'Алексей',
        isContact: true,
        lastMessage: msg('', kind: models.MessageKind.video, date: ago(days: 3)),
      ),
      models.Chat(id: 'devs', type: models.ChatType.community, title: 'Flutter Russia'),
      // Бизнес-страницы: ресторан (мы гость) и своя кофейня (мы владелец —
      // можно создавать группы и каналы внутри).
      models.Chat(id: 'spices', type: models.ChatType.community, title: 'Ресторан «Пряности»'),
      models.Chat(id: 'coffee', type: models.ChatType.community, title: 'Кофейня «Зерно»', pinned: true),
      // С настоящими логотипом и обложкой (ассеты демо) — мы владелец.
      models.Chat(
        id: 'kuksu',
        type: models.ChatType.community,
        title: 'Ресторан «Дом куксу»',
        avatarPath: 'assets/demo/domkuksu_logo.png',
        coverPath: 'assets/demo/domkuksu_cover.jpg',
      ),
      models.Chat(
        id: 'tech',
        type: models.ChatType.channel,
        title: 'Техно-обзор',
        // Админ разрешил только некоторые реакции.
        reactionsMode: models.ChatReactionsMode.some,
        reactions: const ['🔥', '👍', '🤯', '❤️'],
        lastMessage: msg('Обзор нового iPhone', kind: models.MessageKind.video, date: ago(days: 6)),
      ),
      models.Chat(
        id: 'school',
        type: models.ChatType.group,
        title: 'Родители 5 «Б»',
        // Реакции в группе выключены.
        reactionsMode: models.ChatReactionsMode.none,
        archived: true,
        unreadCount: 41,
        muted: true,
        lastMessage: msg('Сдаём на экскурсию до пятницы', sender: 'Ольга', date: ago(hours: 6)),
      ),
      models.Chat(
        id: 'shop',
        type: models.ChatType.channel,
        title: 'Скидки и акции',
        archived: true,
        unreadCount: 8,
        lastMessage: msg('−30% на всё до воскресенья', date: ago(days: 1)),
      ),
      models.Chat(
        id: 'old',
        type: models.ChatType.private,
        title: 'Курьер',
        archived: true,
        lastMessage: msg('Заказ доставлен', date: ago(days: 40)),
      ),
      // Не подписаны — открываются по ссылкам из постов «Iperon News» и чата
      // команды (в списке их нет, внизу «Подписаться» / «Вступить»).
      models.Chat(
        id: 'iperon_dev',
        type: models.ChatType.channel,
        title: 'Iperon Dev',
        isMember: false,
        myRole: models.ChatRole.reader,
        lastMessage: msg('Перевели звонки на LiveKit — групповые на подходе', date: ago(hours: 6)),
      ),
      models.Chat(
        id: 'flutter_msk',
        type: models.ChatType.group,
        title: 'Flutter Moscow',
        isMember: false,
        myRole: models.ChatRole.reader,
        lastMessage: msg('Кто идёт на митап в четверг?', sender: 'Ольга', date: ago(hours: 3)),
      ),
      models.Chat(
        id: 'designers',
        type: models.ChatType.group,
        title: 'Дизайнеры интерфейсов',
        isMember: false,
        myRole: models.ChatRole.reader,
        lastMessage: msg('Скинула гайдлайны по иконкам', sender: 'Мария', date: ago(hours: 9)),
      ),
      // ─── Чаты сообществ ───
      ..._seedCommunityChats(ago, msg),
    ];
  }

  /// Чаты демо-сообществ: канал объявлений + группы по темам (где-то мы
  /// участник, где-то нет; «закрытые темы» — по заявке).
  List<models.Chat> _seedCommunityChats(
    DateTime Function({int days, int hours, int minutes}) ago,
    models.ChatLastMessage Function(
      String text, {
      required DateTime date,
      String sender,
      bool out,
      models.MessageStatus status,
      models.MessageKind kind,
    })
    msg,
  ) {
    models.Chat chat(
      String communityID,
      String id,
      models.ChatType type,
      String title, {
      bool announcements = false,
      bool member = true,
      int unread = 0,
      models.ChatRole role = models.ChatRole.writer,
      required models.ChatLastMessage last,
    }) => models.Chat(
      id: id,
      type: type,
      title: title,
      communityID: communityID,
      announcements: announcements,
      isMember: member,
      unreadCount: unread,
      myRole: member ? role : models.ChatRole.reader,
      lastMessage: last,
    );

    const group = models.ChatType.group;
    const channel = models.ChatType.channel;
    const reader = models.ChatRole.reader;
    const owner = models.ChatRole.owner;
    return [
      chat(
        'district',
        'district_news',
        channel,
        'Жители ЖК «Северный»',
        announcements: true,
        unread: 2,
        role: reader,
        last: msg('Завтра отключат горячую воду с 10:00', date: ago(hours: 3)),
      ),
      chat(
        'district',
        'district_neighbors',
        group,
        'Соседи',
        unread: 25,
        last: msg('Кто-нибудь видел рыжего кота у 2-го подъезда?', sender: 'Ольга', date: ago(hours: 4)),
      ),
      chat(
        'district',
        'district_parking',
        group,
        'Парковка',
        member: false,
        last: msg('Шлагбаум снова не открывается', sender: 'Иван', date: ago(hours: 5)),
      ),
      chat(
        'district',
        'district_kids',
        group,
        'Детская площадка',
        member: false,
        last: msg('Завтра субботник в 11:00', sender: 'Мария', date: ago(days: 1)),
      ),

      chat(
        'devs',
        'devs_news',
        channel,
        'Flutter Russia',
        announcements: true,
        role: reader,
        last: msg('Flutter 4.2: разбор релиза', date: ago(days: 5)),
      ),
      chat(
        'devs',
        'devs_chat',
        group,
        'Общий чат',
        last: msg('Вопрос по go_router и вложенным навигаторам', sender: 'Екатерина', date: ago(days: 4)),
      ),
      chat(
        'devs',
        'devs_jobs',
        channel,
        'Вакансии',
        member: false,
        role: reader,
        last: msg('Senior Flutter, удалёнка, от 350k', date: ago(days: 1)),
      ),
      chat(
        'devs',
        'devs_newbies',
        group,
        'Новичкам',
        member: false,
        last: msg('С чего начать изучение Dart?', sender: 'Алексей', date: ago(hours: 7)),
      ),

      chat(
        'spices',
        'spices_news',
        channel,
        'Ресторан «Пряности»',
        announcements: true,
        unread: 1,
        role: reader,
        last: msg('Новое осеннее меню уже в ресторане 🍂', kind: models.MessageKind.photo, date: ago(days: 1, hours: 3)),
      ),
      chat(
        'spices',
        'spices_reviews',
        group,
        'Отзывы гостей',
        member: false,
        last: msg('Плов — лучший в городе!', sender: 'Сергей', date: ago(hours: 8)),
      ),
      chat(
        'spices',
        'spices_vip',
        group,
        'Для постоянных гостей',
        member: false,
        last: msg('Дегустация вин в пятницу', sender: 'Анна', date: ago(days: 2)),
      ),
      chat(
        'spices',
        'spices_staff',
        group,
        'Персонал',
        member: false,
        last: msg('Смена на субботу утверждена', sender: 'Ольга', date: ago(hours: 2)),
      ),

      chat(
        'coffee',
        'coffee_news',
        channel,
        'Кофейня «Зерно»',
        announcements: true,
        role: owner,
        last: msg('С понедельника открываемся в 7:30 ☕️', out: true, status: models.MessageStatus.read, date: ago(days: 2)),
      ),
      chat(
        'coffee',
        'coffee_staff',
        group,
        'Сотрудники',
        role: owner,
        last: msg('Завтра поставка зерна в 9:00', sender: 'Мария', date: ago(days: 1)),
      ),
      chat(
        'coffee',
        'coffee_guests',
        group,
        'Гости',
        role: owner,
        last: msg('А овсяное молоко есть?', sender: 'Иван', date: ago(hours: 10)),
      ),

      chat(
        'kuksu',
        'kuksu_news',
        channel,
        'Ресторан «Дом куксу»',
        announcements: true,
        role: owner,
        last: msg('Добро пожаловать в сообщество ресторана!', out: true, status: models.MessageStatus.read, date: ago(hours: 1)),
      ),
      chat(
        'kuksu',
        'kuksu_guests',
        group,
        'Гости',
        role: owner,
        last: msg('Спасибо за вечер, всё было очень вкусно!', sender: 'Анна', date: ago(minutes: 40)),
      ),
      chat(
        'kuksu',
        'kuksu_staff',
        group,
        'Персонал',
        role: owner,
        last: msg('График на неделю в закрепе', sender: 'Мария', date: ago(hours: 5)),
      ),
    ];
  }

  /// Диалог личного чата: (наше?, текст с markdown-ярлыками).
  static const _dialog = [
    (false, 'Привет! Как дела?'),
    (true, 'Привет 👋 Всё отлично, сам как?'),
    (false, 'Тоже норм. Слушай, **важно**: встреча переносится на __пятницу__'),
    (true, 'Ок, понял. Во сколько?'),
    (false, 'В 15:00, вот ссылка на док: https://iperon.net/docs'),
    (true, '~~Завтра~~ Сегодня вечером посмотрю'),
    (false, 'Код от домофона `4815`, если что'),
    (false, 'И не читай это: ||в пятницу будет торт 🎂||'),
    (true, '> встреча переносится на пятницу\nТогда я возьму ноутбук'),
    (false, 'Отлично, договорились'),
  ];

  static const _groupDialog = [
    'Всем привет! Кидаю план на неделю',
    '**Понедельник** — созвон, __вторник__ — ревью',
    'А где посмотреть задачи? #планирование',
    'Вот доска: [Задачи](https://iperon.net/board)',
    'Спасибо 🙏',
    'Кто возьмёт ревью ветки `chats`?',
    'Я посмотрю сегодня',
    'Дизайнеры зовут в свой чат: https://iperon.net/+DesignClubJoin',
  ];

  static const _channelPosts = [
    '**Обновление 0.0.240** 🎉\n\n• папки в списке чатов\n• поиск прячется при прокрутке\n• новые табы на «Звонках»\n\nПодробнее: https://iperon.net/blog',
    'Опрос недели: чем вы пользуетесь чаще — __личными чатами__ или __группами__? Пишите в комментариях #опрос',
    '> Хороший мессенджер — тот, который не замечаешь\n\nДелимся планами на осень в нашем блоге.',
    'Подписывайтесь на канал разработчиков: https://iperon.net/iperon_dev\nА обсудить Flutter можно в https://iperon.net/flutter_msk 🚀',
  ];

  /// История чата для демо: несколько дней переписки, кончается тем же
  /// последним сообщением, что видно в списке.
  List<models.Message> _seedMessages(String chatID) {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    // У сообщества своей ленты нет — сообщения в его чатах.
    if (chat == null || chat.type == models.ChatType.community) return [];
    final now = DateTime.now();
    final last = chat.lastMessage;
    final end = last?.date ?? now;
    var date = end.subtract(const Duration(days: 2, hours: 3));
    final result = <models.Message>[];

    void add(
      String raw, {
      bool out = false,
      String sender = '',
      models.MessageKind kind = models.MessageKind.text,
      String fileName = '',
      int duration = 0,
      bool service = false,
      models.MessageReply? reply,
      int album = 0,
      bool spoiler = false,
      bool pinned = false,
      String pinnedMessageID = '',
      List<models.MessageReaction> reactions = const [],
      models.MessagePoll? poll,
      Duration step = const Duration(minutes: 7),
    }) {
      date = date.add(step);
      final (text, entities) = poll != null ? (poll.question, const <models.MessageEntity>[]) : parseMarkdownShortcuts(raw);
      result.add(
        models.Message(
          id: _id(),
          chatID: chatID,
          kind: poll != null ? models.MessageKind.poll : kind,
          poll: poll,
          text: text,
          entities: entities,
          outgoing: out,
          senderName: out ? '' : sender,
          status: models.MessageStatus.read,
          date: date,
          fileName: fileName,
          duration: duration,
          service: service,
          reply: reply,
          media: [
            for (var i = 0; i < album; i++)
              models.MessageMedia(kind: i == 2 ? models.MessageKind.video : models.MessageKind.photo, spoiler: spoiler),
            if (album == 0 && spoiler) models.MessageMedia(kind: kind, spoiler: true),
          ],
          reactions: reactions,
          pinned: pinned,
          pinnedMessageID: pinnedMessageID,
          linkPreview: kind == models.MessageKind.text && !service ? _linkPreviewOf(text, entities) : null,
        ),
      );
    }

    models.MessageReaction r(String emoji, [int count = 1, bool chosen = false]) =>
        models.MessageReaction(emoji: emoji, count: count, chosen: chosen);

    switch (chat.type) {
      case models.ChatType.private when chat.isSelf:
        add('Идея: папки чатов как в Telegram, но с __сообществами__', out: true);
        add('', out: true, kind: models.MessageKind.file, fileName: 'план_релиза.pdf', step: const Duration(hours: 20));
        add('Ссылка на статью https://flutter.dev/docs', out: true, step: const Duration(hours: 5));
      case models.ChatType.private:
        for (final (i, (out, text)) in _dialog.indexed) {
          add(
            text,
            out: out,
            step: Duration(minutes: i == 5 ? 60 * 18 : 3 + i),
          );
        }
        add('Вид из окна 🌇', kind: models.MessageKind.photo, reactions: [r('❤️', 1, true)], step: const Duration(hours: 9));
        add('Угадай, где я 😏', kind: models.MessageKind.photo, spoiler: true);
        add(
          'Поездка на выходных 🏔',
          out: true,
          kind: models.MessageKind.photo,
          album: 4,
          reactions: [r('🔥')],
          step: const Duration(minutes: 40),
        );
        add('', out: true, kind: models.MessageKind.voice, duration: 12);
        final quoted = result[2];
        add(
          'Тогда до пятницы!',
          out: true,
          reply: models.MessageReply(messageID: quoted.id, senderName: chat.title, text: quoted.text),
        );
      case models.ChatType.group || models.ChatType.community:
        add('Анна добавила Ивана', service: true);
        for (final (i, text) in _groupDialog.indexed) {
          add(
            text,
            out: i == 6,
            sender: _names[i % _names.length],
            step: Duration(minutes: 4 + i * 9),
          );
        }
        add(
          'Фото с митапа',
          sender: 'Мария',
          kind: models.MessageKind.photo,
          album: 6,
          pinned: true,
          reactions: [r('👍', 5), r('❤️', 3, true), r('🔥', 2)],
          step: const Duration(hours: 20),
        );
        add('', sender: 'Мария', service: true, pinnedMessageID: result.last.id, step: const Duration(minutes: 1));
        add('', sender: 'Иван', kind: models.MessageKind.file, fileName: 'отчёт_сентябрь.xlsx', pinned: true);
        add('', sender: 'Иван', service: true, pinnedMessageID: result.last.id, step: const Duration(minutes: 1));
        add('', sender: 'Дмитрий', poll: _seedPoll(channel: false), step: const Duration(minutes: 20));
      case models.ChatType.channel:
        // Реакции канала — только из разрешённых админом.
        final allowed = chat.reactionsMode == models.ChatReactionsMode.some ? chat.reactions : const ['👍', '🔥', '❤️'];
        for (final (i, post) in _channelPosts.indexed) {
          add(
            post,
            // «Опрос недели» — настоящим опросом.
            poll: i == 1 ? _seedPoll(channel: true) : null,
            reactions: chat.reactionsMode == models.ChatReactionsMode.none
                ? const []
                : [for (final (j, emoji) in allowed.take(3).indexed) r(emoji, 140 - j * 45 + i * 13)],
            step: const Duration(hours: 14),
          );
        }
    }

    // История не должна уходить в будущее относительно последнего сообщения.
    if (result.isNotEmpty && !result.last.date.isBefore(end)) {
      final shift = result.last.date.difference(end) + const Duration(minutes: 5);
      for (var i = 0; i < result.length; i++) {
        result[i] = result[i].copyWith(date: result[i].date.subtract(shift));
      }
    }

    if (last != null) {
      final (text, entities) = parseMarkdownShortcuts(last.text);
      result.add(
        models.Message(
          id: _id(),
          chatID: chatID,
          kind: last.kind,
          text: last.kind == models.MessageKind.file ? '' : text,
          entities: entities,
          fileName: last.kind == models.MessageKind.file ? last.text : '',
          duration: last.kind == models.MessageKind.voice ? 23 : 0,
          outgoing: last.outgoing,
          senderName: last.senderName,
          status: last.status,
          date: last.date,
        ),
      );
    }
    if (chat.type == models.ChatType.channel) return _withChannelStats(chat, result);
    return result;
  }

  /// Посты канала: просмотры (старые — больше, до ~60% подписчиков) и, если
  /// комментарии включены, их число и последние комментаторы.
  List<models.Message> _withChannelStats(models.Chat chat, List<models.Message> posts) {
    final audience = max(chat.membersCount, 40);
    return [
      for (final (i, m) in posts.indexed)
        if (m.service)
          m
        else
          m.copyWith(
            views: (audience * (0.25 + 0.35 * (posts.length - i) / posts.length)).round() + i * 7,
            authorSignature: chat.signMessages ? _signatures[i % _signatures.length] : '',
            commentsCount: chat.commentsEnabled ? (i * 7 + 3) % 19 : 0,
            commenters: chat.commentsEnabled ? _seedCommenters(m.id, (i * 7 + 3) % 19) : const [],
            commentsCloseDate: chat.commentsTimeLimit > 0 ? m.date.add(Duration(seconds: chat.commentsTimeLimit)) : null,
          ),
    ];
  }

  /// Подписи авторов постов в демо-каналах с «Подписывать сообщения».
  static const _signatures = ['Анна Смирнова', 'Дмитрий Козлов', 'Мария Иванова'];

  /// Наше имя для подписи постов — из своего профиля (пусто — «Вы»).
  Future<String> _selfName() async {
    try {
      final profile = await getIt.get<Repositories>().myProfile.getByUserID(userID: getIt.get<Auth>().session.userID);
      final name = '${profile.fistName} ${profile.lastName}'.trim();
      return name.isEmpty ? 'Вы' : name;
    } catch (_) {
      return 'Вы';
    }
  }

  // ─── Комментарии к постам канала ──────────────────────────────────────────

  static const _commentPhrases = [
    'Наконец-то! Давно ждал 🔥',
    'А когда будет на Android?',
    'Отличная новость 👍',
    'Подскажите, как включить?',
    'У меня уже работает, спасибо!',
    'Интересно, а что с темами?',
    '+1, очень удобно',
    'Можно подробнее про приватность?',
  ];

  /// Автор [i]-го демо-комментария к посту [postID] (детерминированно — те же
  /// имена и в счётчике под постом, и в самой ветке).
  String _commentAuthor(String postID, int i) => _names[(postID.hashCode.abs() + i * 3) % _names.length];

  /// Последние (до 3) разные комментаторы для [count] комментариев.
  List<String> _seedCommenters(String postID, int count) {
    final result = <String>[];
    for (var i = count - 1; i >= 0 && result.length < 3; i--) {
      final name = _commentAuthor(postID, i);
      if (!result.contains(name)) result.add(name);
    }
    return result;
  }

  static String _threadID(String channelID, String postID) => 'thread-$channelID-$postID';

  @override
  Future<String> openComments(String channelID, String postID) async {
    final threadID = _threadID(channelID, postID);
    if (_chats.any((c) => c.id == threadID)) return threadID;
    final channel = _chats.where((c) => c.id == channelID).firstOrNull;
    final post = _history(channelID).where((m) => m.id == postID).firstOrNull;
    if (channel == null || post == null) return '';

    // Первым — сам пост («Переслано из канала»), затем «Начало обсуждения» и
    // комментарии.
    final count = min(post.commentsCount, 30);
    final now = DateTime.now();
    final span = now.difference(post.date);
    final messages = <models.Message>[
      models.Message(
        id: 'post-$postID',
        chatID: threadID,
        kind: post.kind,
        poll: post.poll,
        text: post.text,
        entities: post.entities,
        media: post.media,
        fileName: post.fileName,
        duration: post.duration,
        status: models.MessageStatus.read,
        date: post.date,
        forward: models.MessageForward(name: channel.title),
        linkPreview: post.linkPreview,
      ),
      models.Message(
        id: _id(),
        chatID: threadID,
        text: 'Начало обсуждения',
        service: true,
        status: models.MessageStatus.read,
        date: post.date.add(const Duration(seconds: 1)),
      ),
      for (var i = 0; i < count; i++)
        models.Message(
          id: _id(),
          chatID: threadID,
          text: _commentPhrases[(postID.hashCode.abs() + i) % _commentPhrases.length],
          senderName: _commentAuthor(postID, i),
          status: models.MessageStatus.read,
          date: post.date.add(span * ((i + 1) / (count + 1))),
        ),
    ];
    _chats = [
      ..._chats,
      models.Chat(
        id: threadID,
        type: models.ChatType.group,
        title: channel.title,
        threadOf: channelID,
        threadPostID: postID,
        commentsCloseDate: post.commentsCloseDate,
        membersCount: max(channel.membersCount, 2),
        reactionsMode: channel.reactionsMode,
        reactions: channel.reactions,
        createdAt: now,
      ),
    ];
    _emit();
    _setMessages(threadID, messages);
    return threadID;
  }

  /// Срок комментариев нового поста в канале [chatID] (по «Сроку
  /// комментирования» на момент публикации); `null` — бессрочно / не канал.
  DateTime? _commentsCloseDate(String chatID, DateTime date) {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || chat.type != models.ChatType.channel || chat.commentsTimeLimit <= 0) return null;
    return date.add(Duration(seconds: chat.commentsTimeLimit));
  }

  @override
  Future<void> setCommentsClosed(String channelID, String postID, bool closed) async {
    final date = closed ? DateTime.now() : null;
    _updateMessage(channelID, postID, (m) => m.copyWith(commentsCloseDate: date));
    final threadID = _threadID(channelID, postID);
    if (_chats.any((c) => c.id == threadID)) _update(threadID, (c) => c.copyWith(commentsCloseDate: date));
  }

  /// Ветка изменилась — у поста в канале обновляются счётчик и комментаторы.
  void _syncComments(models.Chat thread) {
    final comments = _history(thread.id).where((m) => !m.service && m.id != 'post-${thread.threadPostID}').toList();
    final commenters = <String>[];
    for (final m in comments.reversed) {
      final name = m.outgoing ? 'Вы' : m.senderName;
      if (!commenters.contains(name)) commenters.add(name);
      if (commenters.length == 3) break;
    }
    if (!_messages.containsKey(thread.threadOf)) return;
    _updateMessage(thread.threadOf, thread.threadPostID, (m) => m.copyWith(commentsCount: comments.length, commenters: commenters));
  }

  List<models.ChatFolder> _seedFolders() => const [
    models.ChatFolder(id: 'all', isAll: true),
    models.ChatFolder(
      id: 'unread',
      title: 'Непрочитанные',
      includeContacts: true,
      includeNonContacts: true,
      includeGroups: true,
      includeChannels: true,
      includeCommunities: true,
      excludeRead: true,
    ),
    models.ChatFolder(id: 'personal', title: 'Личные', includeContacts: true, includeNonContacts: true),
    models.ChatFolder(id: 'groups', title: 'Группы', includeGroups: true),
    models.ChatFolder(id: 'channels', title: 'Каналы', includeChannels: true),
    models.ChatFolder(id: 'communities', title: 'Сообщества', includeCommunities: true),
    models.ChatFolder(id: 'work', title: 'Работа', includeChatIDs: ['team', 'dmitry', 'devs', 'flutter']),
  ];
}
