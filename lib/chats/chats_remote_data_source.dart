import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:path/path.dart' as p;

import '../api.dart';
import '../auth.dart';
import '../cdn.dart';
import '../crypto/cloud_password.dart';
import '../di.dart';
import '../utils.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf.dart';
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import '../repositories.dart';
import '../demo/chats_demo_data_source.dart';
import '../i18n/translations.g.dart';
import 'channel_views.dart';
import 'chats_data_source.dart';
import 'chats_mapping.dart';
import 'chats_presence.dart';
import 'chats_typing.dart';
import 'chats_media.dart';
import 'edit_media.dart';
import 'chats_sync.dart';
import 'media_prepare.dart' show avatarThumbhash;
import 'message_search.dart';
import 'reactions.dart';
import 'history_window.dart';
import 'reactions_list.dart';
import 'read_receipts.dart';
import '../account_scope.dart';

/// Настоящие чаты: SQLite-кэш ([ChatsRepository]) + сервер (chats_v1.proto).
/// Первый срез — только личные чаты и «Избранное» (см.
/// docs/plans/chats-groups-channels.md, «Этап 1+»).
///
/// Чтение — из локальной БД (видно offline), подписки перечитывают её на
/// каждое изменение таблиц (`db.onChange`); изменения пишет [ChatsSync]
/// (ответы сервера и push `UPDATES`). Запись — через сервер: без сети
/// серверные действия (закреп, звук, архив, удаление, правка …) бросают
/// [ChatsOfflineException] — ничего не меняем «понарошку». Исключение —
/// отправка сообщений (честно ждут в outbox (⏱) и уходят при подключении) и
/// реакции (ждут в `chatPendingReactions` так же).
///
/// Группы — срез 3.1 (docs/plans/chats-groups.md): создать,
/// переписка, служебные, «Изменить» (название, описание, фото), участники,
/// выйти / удалить; 3.2 — роли и права админа, исключение и блокировка,
/// передача владения, роль по умолчанию, закреп у всех; 3.3 — способы
/// вступления, публичное имя, ссылки-приглашения, заявки, «Скрыть историю»,
/// предпросмотр чужой группы по ссылке и «Вступить»; 3.4 — сообщения в
/// группе: реакции группы (счётчики), опросы, упоминания и кнопка «@»,
/// «кто прочитал», медленный режим, «новички», «скрыть участников». Каналы и
/// сообщества — следующие срезы: их действия бросают [UnsupportedError].
class ChatsRemoteDataSource implements ChatsDataSource {
  /// Аккаунт этого сервиса: зависимости берутся из него, а не из «текущего» —
  /// после переключения аккаунта незавершённые операции не уйдут в чужой.
  final AccountScope _scope = AccountScope.current;

  ChatsRemoteDataSource._();

  static ChatsRemoteDataSource get instance => AccountScope.current.resolve(ChatsRemoteDataSource._);

  Logger get _logger => getIt.get<Logger>();
  Repositories get _repositories => _scope.repositories;
  ChatsRepository get _store => _repositories.chats;
  ChatsSync get _sync => ChatsSync.instance;
  Auth get _auth => _scope.auth;

  final _random = Random.secure();

  static const _chatTables = [
    ChatsRepository.dialogsTable,
    ChatsRepository.outboxTable,
    ChatsRepository.pinnedTable,
    ChatsRepository.groupsTable,
    'profiles',
    'contacts',
  ];
  static const _messageTables = [
    // Контакты — имена в ленте (отправитель, ответ, «Переслано от») по общему
    // правилу: переименовал контакт — лента обновилась.
    'contacts',
    ChatsRepository.messagesTable,
    ChatsRepository.outboxTable,
    ChatsRepository.dialogsTable,
    ChatsRepository.pinnedTable,
    ChatsRepository.pendingReactionsTable,
    // Группа: имена отправителей — из профилей участников.
    ChatsRepository.groupsTable,
    'profiles',
  ];

  Future<void> _requireNetwork() async {
    if (!await _sync.hasNetwork()) throw const ChatsOfflineException();
  }

  static Never _unsupported(String what) => throw UnsupportedError('$what — пока только в демо (личные чаты — первый срез)');

  /// Закреплённые, реакции, пересылка и отложенные — есть; группы — с ролями
  /// и правами (3.2), вступлением (3.3) и сообщениями в группе (3.4: реакции,
  /// опросы, упоминания …); каналы (4.1: посты, подписи, подписчики, админы).
  /// Сообществ нет;
  /// опрос пересылается только в группу или канал — тем же опросом (голоса
  /// общие).
  @override
  ChatsFeatures get features => ChatsFeatures(
    reactions: true,
    pinnedMessages: true,
    forward: true,
    scheduled: true,
    groups: true,
    groupRoles: true,
    groupJoining: true,
    groupExtras: true,
    // Каналы (срез 4.1); просмотры, реакции и опросы в канале — подэтап 4.2,
    // комментарии (ветки) — 4.3.
    channels: true,
    channelExtras: true,
    channelComments: true,
    forwardPolls: true,
    pollsGroupsChannelsOnly: true,
  );

  /// Сервер удаляет отозванные ссылки только все сразу.
  @override
  bool get deletesRevokedLinkSingly => false;

  /// Передачу владения сервер подтверждает облачным паролем.
  @override
  bool get transferNeedsPassword => true;

  // --- список чатов ---

  @override
  Stream<List<models.Chat>> watchChats() {
    // Перечитываем при изменении таблиц и «в сети» собеседников; загрузки по
    // очереди, чтобы старый результат не пришёл после нового. «Печатает…»
    // меняется часто и в БД не лежит — накладываем на последний загруженный
    // список без перечитывания.
    late final StreamController<List<models.Chat>> out;
    StreamSubscription<void>? changes;
    StreamSubscription<void>? presence;
    StreamSubscription<void>? typing;
    StreamSubscription<void>? connection;
    StreamSubscription<void>? avatars;
    StreamSubscription<void>? previews;
    List<models.Chat>? loaded;
    var pending = Future<void>.value();
    void reload() {
      pending = pending
          .then((_) async {
            final chats = loaded = await _loadChats();
            if (!out.isClosed) out.add(_withTyping(chats));
          })
          .catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace));
    }

    out = StreamController<List<models.Chat>>(
      onListen: () {
        _listShown = true;
        changes = _repositories.db.onChange(_chatTables).listen((_) => reload());
        presence = ChatsPresence.instance.changed.listen((_) => reload());
        // Подключились — перечитать: профили собеседников запрашиваются только
        // при подключённом стриме (см. _requestProfiles).
        connection = getIt
            .get<API>()
            .connectionStatusStream
            .where((status) => status == ApiConnectionStatus.connected)
            .listen((_) => reload());
        typing = ChatsTyping.instance.changed.listen((_) {
          final chats = loaded;
          if (chats == null || out.isClosed) return;
          // В группе печатает тот, чьего имени ещё нет, — перечитать с ним.
          if (_typingNamesMissing(chats)) return reload();
          out.add(_withTyping(chats));
        });
        // Скачанные аватары групп и предпросмотры по ссылкам.
        previews = _previewsChanged.stream.listen((_) => reload());
        avatars = _avatarsChanged.stream.listen((_) => reload());
      },
      onCancel: () async {
        _listShown = false;
        ChatsPresence.instance.setListPeers(const []);
        await changes?.cancel();
        await presence?.cancel();
        await typing?.cancel();
        await connection?.cancel();
        await avatars?.cancel();
        await previews?.cancel();
      },
    );
    return out.stream;
  }

  /// Список чатов разовым чтением, без подписки («Использование памяти»).
  Future<List<models.Chat>> loadChats() => _loadChats();

  /// Один чат списка по [id] (hex) — разовым чтением, без подписки (баннер о
  /// новом сообщении, `InAppNotices`); null — нет в списке.
  Future<models.Chat?> loadChat(String id) async {
    for (final chat in await _loadChats()) {
      if (chat.id == id) return chat;
    }
    return null;
  }

  /// «Печатает…» / «отправляет фото…» из [ChatsTyping] — поверх загруженного.
  /// В личном чате имя не нужно (собеседник один) — берём заголовок; в группе
  /// — имя участника по общему правилу ([_names]).
  List<models.Chat> _withTyping(List<models.Chat> chats) => [
    for (final chat in chats)
      switch (ChatsTyping.instance.of(chat.id)) {
        final typing when typing.isEmpty => chat,
        final typing => chat.copyWith(
          typing: [
            for (final t in typing)
              models.ChatTyping(
                userID: t.userID,
                name: chat.type == models.ChatType.group ? _names[t.userID] ?? '' : chat.title,
                activity: t.activity,
              ),
          ],
        ),
      },
  ];

  /// В какой-то группе печатает участник, чьё имя ещё не загружено.
  bool _typingNamesMissing(List<models.Chat> chats) =>
      chats.any((chat) => chat.type == models.ChatType.group && ChatsTyping.instance.of(chat.id).any((t) => !_names.containsKey(t.userID)));

  /// Имена людей по общему правилу (hex userID → имя) — для «печатает…» в
  /// группах; пополняется при каждом чтении списка.
  final _names = <String, String>{};

  /// Скачался аватар группы — список перечитывается.
  final _avatarsChanged = StreamController<void>.broadcast();

  /// Аватары групп, которые уже качаются / качались за этот запуск: hex cdnID →
  /// ссылка последней попытки.
  final _avatarDownloads = <String, String>{};

  /// Список чатов подписан ([watchChats]) — только тогда держим «в сети»
  /// собеседников свежим (загрузка, закончившаяся после отписки, не включит).
  var _listShown = false;

  /// Когда последний раз запрашивали профиль собеседника (hex userID).
  final _profilesRequested = <String, DateTime>{};

  /// Профиль из кэша освежаем не чаще раза в этот интервал: иначе смена
  /// аватара/имени собеседника (и скрытие аватара, если он меня заблокировал,
  /// пока я был без сети) не дошла бы до списка, пока профиль не открыли.
  static const _profileRefreshInterval = Duration(hours: 1);

  /// Сколько верхних чатов списка освежать за раз (дальние — при прокрутке не
  /// видны; нехватающие профили запрашиваются все).
  static const _profileRefreshLimit = 100;

  /// Номера профилей в международном формате (libphonenumber не на каждое
  /// перечитывание списка).
  final _formattedPhones = <String, String>{};

  /// Пути к аватарам по cdnID (hex) — чтобы не ходить в `downloads` на каждое
  /// изменение списка.
  final _avatarPaths = <String, String>{};

  Future<List<models.Chat>> _loadChats() async {
    if (!_auth.isAuthorized) return const [];
    final me = _sync.me;
    final rows = await _store.dialogs(userID: me);
    final outbox = await _store.outbox(userID: me);
    final allGroups = {for (final g in await _store.groups(userID: me)) idHex(g.chatID): g};
    // Группы и каналы списка (ветки комментариев — отдельно, ниже).
    final groups = {
      for (final MapEntry(:key, :value) in allGroups.entries)
        if (_sync.showsChatType(value.info.type.value)) key: value,
    };
    // Люди списка: собеседники личных, авторы последних сообщений групп и те,
    // кого касается служебное (добавил / исключил), печатающие в группах.
    final people = <String, Uint8List>{};
    for (final row in rows) {
      if (row.peerUserID case final peer?) people[idHex(peer)] = peer;
      if (row.type != pb.ChatType.CHAT_TYPE_GROUP.value || !groups.containsKey(idHex(row.chatID))) continue;
      final top = row.topMessage == null ? null : pb.ChatMessage.fromBuffer(row.topMessage!);
      if (top != null) {
        for (final userID in [top.fromUserID, ...top.content.chatAction.userIDs]) {
          people[idHex(userID)] = Uint8List.fromList(userID);
        }
      }
      for (final typing in ChatsTyping.instance.of(idHex(row.chatID))) {
        final userID = idBytes(typing.userID);
        if (userID.isNotEmpty) people[typing.userID] = userID;
      }
    }
    final peers = _Peers(await _loadPeers(people.values.toList()));
    for (final MapEntry(:key, :value) in peers.byID.entries) {
      _names[key] = value.title;
    }
    final now = DateTime.now();

    // Последнее неотправленное каждого чата — в превью вместо последнего
    // с сервера (с ⏱), как в Telegram.
    final pending = <String, ChatOutboxRow>{};
    for (final row in outbox) {
      final chatID = row.chatID;
      // Отложенное — не в чате, а на экране «Отложенные».
      if (chatID != null && !row.isScheduled) pending[idHex(chatID)] = row;
    }

    final chats = <models.Chat>[];
    for (final row in rows) {
      final id = idHex(row.chatID);
      if (row.type == pb.ChatType.CHAT_TYPE_THREAD.value) {
        // Ветка комментариев (4.3): в списке не видна (`Chat.isThread`), но
        // окно чата берёт её отсюда — как и канал, от которого её настройки.
        final thread = allGroups[id];
        if (thread == null) continue;
        final channel = allGroups[idHex(thread.info.parentChatID)];
        chats.add(
          threadChatFromPb(
            thread.info,
            channel: channel?.info,
            channelAdmin: channel != null && (channel.role == pb.ChatRole.CHAT_ROLE_ADMIN || channel.role == pb.ChatRole.CHAT_ROLE_OWNER),
            avatarPath: channel == null ? '' : await _groupAvatar(channel.info),
            unreadCount: row.unreadCount,
            slowModeUntil: thread.slowModeUntil,
            draft: row.draft,
            createdAt: row.createdAt > 0 ? DateTime.fromMillisecondsSinceEpoch(row.createdAt) : null,
          ),
        );
        continue;
      }
      final group = groups[id];
      // Личные и (по флагам) группы и каналы; сообщества — следующий срез.
      if (row.type != pb.ChatType.CHAT_TYPE_PRIVATE.value && group == null) continue;
      final channel = group != null && group.info.type == pb.ChatType.CHAT_TYPE_CHANNEL;
      final peer = group == null ? row.peerUserID : null;
      final isSelf = peer != null && sameID(peer, me);
      final info = peer == null || isSelf ? null : peers.of(peer);
      final topBlob = row.topMessage;
      final top = topBlob == null ? null : pb.ChatMessage.fromBuffer(topBlob);
      var lastMessage = top == null
          ? null
          : lastMessageFromPb(
              top,
              myUserID: me,
              readOutboxMaxID: row.readOutboxMaxID,
              isSelf: isSelf,
              pinned: top.content.hasPin() ? await _pinnedMessage(row.chatID, top.content.pin.messageID.toInt()) : null,
              channel: channel,
            );
      if (group != null && top != null && lastMessage != null) {
        lastMessage = top.content.hasChatAction()
            // Служебное группы — текстом, без автора и галочек.
            ? lastMessage.copyWith(text: _chatActionText(top, me, peers, channel: channel), outgoing: false)
            // Пост канала — без автора (от имени канала).
            : lastMessage.copyWith(senderName: lastMessage.outgoing || channel ? '' : peers.of(top.fromUserID).title);
      }
      final queued = pending[id];
      if (queued != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(queued.createdAt);
        if (lastMessage == null || !date.isBefore(lastMessage.date)) {
          final content = pb.MessageContent.fromBuffer(queued.content);
          lastMessage = models.ChatLastMessage(
            kind: contentKind(content),
            text: content.hasPoll() ? content.poll.question : content.text,
            outgoing: true,
            status: queued.failed ? models.MessageStatus.failed : models.MessageStatus.pending,
            date: date,
          );
        }
      }
      final muted = mutedFromPb(row.mutedUntil, now);
      if (group != null) {
        // Публичный канал без подписки (4.4): в списке и счётчиках его нет
        // (`isMember == false`), окно чата читает его кэш, внизу «Подписаться».
        final browsing = group.browsing;
        _backfillGroupThumbhash(group);
        chats.add(
          models.Chat(
            id: id,
            type: channel ? models.ChatType.channel : models.ChatType.group,
            title: group.info.title,
            about: group.info.about,
            avatarPath: await _groupAvatar(group.info),
            avatarThumbhash: group.info.avatarThumbhash,
            membersCount: group.info.membersCount,
            myRole: browsing ? models.ChatRole.reader : roleFromPb(group.role),
            // Права — у админа (владельцу — все, см. myChatRights).
            myRights: rightsFromPb(group.rights),
            myRank: group.rank,
            defaultRole: roleFromPb(group.info.defaultRole),
            // Вступление (3.3): основная ссылка и заявки — только у тех, кто
            // может приглашать (иначе пусто / 0).
            joinMode: joinModeFromPb(group.info.joinMode),
            username: group.info.username,
            historyHidden: group.info.historyHidden,
            inviteLink: invitePath(group.inviteCode),
            pendingRequests: group.pendingRequests,
            // Сообщения в группе (3.4).
            reactionsMode: reactionsModeFromPb(group.info.reactionsMode),
            reactions: group.info.reactions,
            slowMode: group.info.slowMode,
            slowModeUntil: group.slowModeUntil > 0 ? DateTime.fromMillisecondsSinceEpoch(group.slowModeUntil) : null,
            newcomerMediaDelay: group.info.newcomerMediaDelay,
            joinedAt: group.joinedAt > 0 ? DateTime.fromMillisecondsSinceEpoch(group.joinedAt) : null,
            membersHidden: group.info.membersHidden,
            // «Запретить копирование» — настройка группы (EditChat), всем.
            noForwards: group.info.noForwards,
            // Канал: «Подписывать сообщения» (4.1).
            signMessages: group.info.signMessages,
            // Канал: «Максимум реакций под постом» (4.2).
            maxReactions: maxReactionsOf(group.info),
            // Канал: комментарии к постам (4.3).
            commentsEnabled: channel && group.info.commentsEnabled,
            commentsTimeLimit: group.info.commentsTimeLimit,
            commentsWho: commentsWhoFromPb(group.info.commentsWho),
            commentsMinSubscription: group.info.commentsMinSubscription,
            isMember: !browsing,
            browsing: browsing,
            unreadMentions: browsing ? 0 : row.unreadMentions,
            lastMessage: lastMessage,
            unreadCount: browsing ? 0 : row.unreadCount,
            unreadReactions: browsing ? 0 : row.unreadReactions,
            markedUnread: !browsing && row.markedUnread,
            muted: muted.muted,
            mutedUntil: muted.until,
            pinned: row.pinned,
            archived: row.archived,
            draft: row.draft,
            createdAt: row.createdAt > 0
                ? DateTime.fromMillisecondsSinceEpoch(row.createdAt)
                : (group.info.createdAt > 0 ? DateTime.fromMillisecondsSinceEpoch(group.info.createdAt.toInt()) : null),
          ),
        );
        continue;
      }
      chats.add(
        models.Chat(
          id: id,
          type: models.ChatType.private,
          title: info?.title ?? '',
          isContact: info?.isContact ?? false,
          isSelf: isSelf,
          peerUserID: peer == null || isSelf ? '' : idHex(peer),
          lastMessage: lastMessage,
          unreadCount: row.unreadCount,
          unreadReactions: row.unreadReactions,
          markedUnread: row.markedUnread,
          muted: muted.muted,
          mutedUntil: muted.until,
          pinned: row.pinned,
          archived: row.archived,
          ttlPeriod: isSelf ? 0 : row.ttlPeriod,
          noForwards: !isSelf && row.noForwards > 0,
          noForwardsMine: row.noForwards == 1,
          draft: row.draft,
          about: info?.profile?.aboutMe ?? '',
          username: info?.profile?.username ?? '',
          avatarPath: await _avatarPath(info?.profile?.avatarCdnID),
          avatarThumbhash: info?.profile?.avatarThumbhash ?? '',
          phone: info?.profile?.phoneNumber ?? '',
          online: peer != null && !isSelf && ChatsPresence.instance.isOnline(idHex(peer)),
          lastSeen: info?.profile?.lastSeenAt,
          createdAt: row.createdAt > 0 ? DateTime.fromMillisecondsSinceEpoch(row.createdAt) : null,
        ),
      );
    }
    // Чужие группы, открытые по ссылке (предпросмотр): в списке не видны
    // (`isMember == false`), но окно чата берёт их отсюда. Вступили —
    // диалог уже в списке, предпросмотр больше не нужен.
    final ids = {for (final c in chats) c.id};
    final owner = idHex(me);
    for (final MapEntry(key: id, value: preview) in _previews.entries.toList()) {
      if (preview.owner != owner) continue;
      // Вступили (в т.ч. одобрили заявку — пришёл dialogNew).
      if (ids.contains(id)) {
        _previews.remove(id);
        continue;
      }
      chats.add(await _previewChat(id, preview));
    }
    // «В сети» у аватаров списка — собеседники личных чатов.
    if (_listShown) {
      ChatsPresence.instance.setListPeers([
        for (final row in rows)
          if (row.peerUserID case final peer? when row.type == pb.ChatType.CHAT_TYPE_PRIVATE.value && !sameID(peer, me)) peer,
      ]);
    }
    _requestProfiles([
      for (final userID in people.values)
        if (!sameID(userID, me)) (userID: userID, cached: (peers.of(userID).profile?.fistName ?? '').isNotEmpty),
    ]);
    return chats;
  }

  /// Текст служебного группы ([chatActionText]) с именами по общему правилу;
  /// [channel] — служебное канала (от имени канала, без автора).
  String _chatActionText(pb.ChatMessage message, List<int> me, _Peers peers, {bool channel = false}) {
    final action = message.content.chatAction;
    return chatActionText(
      t,
      action,
      channel: channel,
      outgoing: sameID(message.fromUserID, me),
      actor: peers.of(message.fromUserID).title,
      names: [for (final userID in action.userIDs) sameID(userID, me) ? t.chatAction.youObject : peers.of(userID).title],
    );
  }

  /// Аватар группы: скачан — путь; нет — качаем (раз за запуск), список
  /// перечитается сам ([_avatarsChanged]).
  Future<String> _groupAvatar(pb.ChatInfo info) async {
    if (info.avatarCdnID.isEmpty) return '';
    final path = await _avatarPath(info.avatarCdnID);
    // Ссылка с токеном живёт ограниченно: сохранённая в кэше могла истечь.
    // Повторяем, только когда пришла другая ссылка (свежий ChatInfo).
    final key = idHex(info.avatarCdnID);
    if (path.isNotEmpty || !info.hasAvatar() || _avatarDownloads[key] == info.avatar.url) return path;
    _avatarDownloads[key] = info.avatar.url;
    unawaited(
      _scope.cdn.download(cdn: models.CDN.fromProto(info.avatar)).then((_) => _avatarsChanged.add(null)).catchError((
        Object error,
        StackTrace stackTrace,
      ) {
        _logger.handle(error, stackTrace);
      }),
    );
    return '';
  }

  /// Фото группы (cdnID hex), к которым уже дописывали ThumbHash за запуск.
  final _thumbhashBackfilled = <String>{};

  /// Фото группы поставлено до появления ThumbHash: тот, у кого есть право
  /// «Изменить», досчитывает его по скачанному файлу и дописывает (EditChat
  /// только с avatarThumbhash — без служебного в ленту), чтобы у участников
  /// до загрузки было размытое превью. Файл ещё не скачан — попробуем при
  /// следующем перечитывании списка.
  void _backfillGroupThumbhash(ChatGroupRow group) {
    final info = group.info;
    if (info.avatarCdnID.isEmpty || info.avatarThumbhash.isNotEmpty) return;
    final canEdit = group.role == pb.ChatRole.CHAT_ROLE_OWNER || (group.role == pb.ChatRole.CHAT_ROLE_ADMIN && group.rights.changeInfo);
    final key = idHex(info.avatarCdnID);
    if (!canEdit || !_thumbhashBackfilled.add(key)) return;
    unawaited(() async {
      try {
        final path = await _avatarPath(info.avatarCdnID);
        if (path.isEmpty) {
          _thumbhashBackfilled.remove(key);
          return;
        }
        final thumbhash = await avatarThumbhash(await File(path).readAsBytes());
        if (thumbhash.isEmpty) return;
        final response = await _sync.chats(
          pb.Chats_Request(
            editChat: pb.Chats_EditChat(chatID: group.chatID, avatarThumbhash: thumbhash),
          ),
        );
        await _sync.applyUpdates(response.editChat.updates);
      } catch (error) {
        _logger.warning('chats: group avatar thumbhash backfill: $error');
      }
    }());
  }

  /// Закреплённое сообщение — из кэша истории или закреплённых (превью
  /// служебного «закрепил «…»» в списке чатов).
  Future<pb.ChatMessage?> _pinnedMessage(List<int> chatID, int messageID) async {
    final me = _sync.me;
    final cached = await _store.message(userID: me, chatID: chatID, messageID: messageID);
    if (cached != null) return cached;
    for (final m in await _store.pinned(userID: me, chatID: chatID)) {
      if (m.messageID.toInt() == messageID) return m;
    }
    return null;
  }

  /// Имена собеседников по общему правилу (`Utils.composeDisplayName`): как я
  /// его записал (облачный контакт главнее книжного; контакт без имени — не
  /// имя), имя из профиля, @username, номер.
  Future<Map<String, _PeerInfo>> _loadPeers(List<Uint8List> userIDs) async {
    if (userIDs.isEmpty) return const {};
    final utils = getIt.get<Utils>();
    final profiles = await _repositories.profiles.getByUserIDs(userIDs: userIDs, toHex: idHex);
    final contactNames = <String, String>{};
    final contactPhones = <String, String>{};
    // Облачные — первыми: их имя главнее книжного.
    final contacts = (await _repositories.contacts.getAll()).where((c) => c.userID != null).toList()
      ..sort((a, b) => (b.isCloud ? 1 : 0) - (a.isCloud ? 1 : 0));
    for (final c in contacts) {
      final key = idHex(c.userID!);
      contactPhones.putIfAbsent(key, () => c.phone);
      final name = c.displayName.trim();
      if (name.isNotEmpty && name != c.phone) contactNames.putIfAbsent(key, () => name);
    }
    return {
      for (final userID in userIDs)
        idHex(userID): () {
          final key = idHex(userID);
          final profile = profiles[key];
          // Системный аккаунт — всегда «Iperon» (его не переименовать контактом).
          if (key == models.systemUserID) return _PeerInfo(title: models.systemAccountName, isContact: false, profile: profile);
          final rawPhone = profile?.phoneNumber ?? '';
          final phone = rawPhone.isEmpty
              ? ''
              : _formattedPhones.putIfAbsent(rawPhone, () => utils.phoneNormalization(phoneNumber: rawPhone).international);
          final title = utils.composeDisplayName(
            contactName: contactNames[key] ?? '',
            firstName: profile?.fistName ?? '',
            lastName: profile?.lastName ?? '',
            username: profile?.username ?? '',
            phoneNumber: phone.isNotEmpty ? phone : (rawPhone.isNotEmpty ? rawPhone : contactPhones[key] ?? ''),
          );
          return _PeerInfo(
            // Профиль уже есть, но ни имени, ни @username, а номер скрыт
            // приватностью — «Пользователь» (профиля ещё нет — пусто, как было).
            title: title.isEmpty && profile != null ? t.sessionsPrivacyAndSecurity.unknownUser : title,
            isContact: contactPhones.containsKey(key),
            hasContactName: contactNames.containsKey(key),
            profile: profile,
          );
        }(),
    };
  }

  /// Профили собеседников запросом `PROFILE` по стриму: ответ пишет
  /// `API._handleMessage` в `profiles`, список перечитается сам. Нет в кэше
  /// ([cached] false) — один раз за запуск; есть — освежаем раз в
  /// [_profileRefreshInterval] для верхних [_profileRefreshLimit] чатов. Пока
  /// стрим не подключён, не помечаем — запросим при следующем чтении.
  void _requestProfiles(List<({Uint8List userID, bool cached})> peers) {
    final api = _scope.api;
    if (api.connectionStatus != ApiConnectionStatus.connected) return;
    final now = DateTime.now();
    for (final (index, (:userID, :cached)) in peers.indexed) {
      final key = idHex(userID);
      final last = _profilesRequested[key];
      final due = cached ? index < _profileRefreshLimit && (last == null || now.difference(last) >= _profileRefreshInterval) : last == null;
      if (!due) continue;
      _profilesRequested[key] = now;
      unawaited(
        api
            .sendEncoded(MessageType.PROFILE, Profile_Request(userID: userID).writeToBuffer())
            .catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)),
      );
    }
  }

  Future<String> _avatarPath(List<int>? cdnID) async {
    if (cdnID == null || cdnID.isEmpty) return '';
    final key = idHex(cdnID);
    final cached = _avatarPaths[key];
    if (cached != null) return cached;
    try {
      final file = await _scope.cdn.cachedFile(Uint8List.fromList(cdnID));
      if (file == null) return '';
      return _avatarPaths[key] = file.path;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
      return '';
    }
  }

  /// Имена людей по общему правилу (hex userID → имя) — для «Ответов» (4.6);
  /// профили неизвестных — запросом (список перечитается, когда придут).
  Future<Map<String, String>> peopleNames(List<Uint8List> userIDs) async {
    final unique = {
      for (final id in userIDs)
        if (id.isNotEmpty) idHex(id): id,
    };
    final peers = _Peers(await _loadPeers(unique.values.toList()));
    _requestProfiles([for (final id in unique.values) (userID: id, cached: peers.of(id).profile != null)]);
    return {for (final MapEntry(:key, value: id) in unique.entries) key: peers.of(id).title};
  }

  /// Уже скачанный файл по cdnID (превью медиа в «Ответах»); пусто — нет.
  Future<String> cachedFilePath(List<int> cdnID) => _avatarPath(cdnID);

  /// Папки — из снимка в SQLite (видны без сети), перечитываются при каждой
  /// его записи (ответ GetFolders / обновление folders).
  @override
  Stream<List<models.ChatFolder>> watchFolders() => _repositories.db
      .onChange(const [ChatsRepository.foldersTable])
      .asyncMap((_) async => foldersFromPb(_auth.isAuthorized ? await _store.folders(userID: _sync.me) : null))
      .distinct(listEquals);

  /// Мои настройки диалога на сервере; результат приходит обновлением
  /// `DialogSettings`.
  Future<void> _setDialog(String chatID, {bool? pinned, bool? archived, bool? markedUnread, int? mutedUntil}) async {
    await _requireNetwork();
    final response = await _sync.chats(
      pb.Chats_Request(
        setDialog: pb.Chats_SetDialog(
          chatID: idBytes(chatID),
          pinned: pinned,
          archived: archived,
          markedUnread: markedUnread,
          mutedUntil: mutedUntil == null ? null : Int64(mutedUntil),
        ),
      ),
    );
    await _sync.applyUpdates(response.setDialog.updates);
  }

  @override
  Future<void> setPinned(String chatID, bool pinned) => _setDialog(chatID, pinned: pinned);

  @override
  Future<void> setMuted(String chatID, bool muted, {DateTime? until}) => _setDialog(chatID, mutedUntil: mutedToPb(muted, until));

  @override
  Future<void> setArchived(String chatID, bool archived) => _setDialog(chatID, archived: archived);

  @override
  Future<void> setNoForwards(String chatID, bool enabled, {String requestID = ''}) async {
    await _requireNetwork();
    final response = await _sync.chats(
      pb.Chats_Request(
        setNoForwards: pb.Chats_SetNoForwards(
          chatID: idBytes(chatID),
          enabled: enabled,
          requestID: requestID.isEmpty ? null : Int64.parseInt(requestID),
        ),
      ),
    );
    await _sync.applyUpdates(response.setNoForwards.updates);
  }

  @override
  Future<void> setTTL(String chatID, int period) async {
    await _requireNetwork();
    final response = await _sync.chats(
      pb.Chats_Request(
        setTTL: pb.Chats_SetTTL(chatID: idBytes(chatID), period: period),
      ),
    );
    await _sync.applyUpdates(response.setTTL.updates);
  }

  /// Чаты, по которым сейчас уходит «прочитано» (cubit окна чата зовёт
  /// [setRead] на каждое изменение, пока счётчик не обнулится).
  final _reading = <String>{};

  /// «Прочитать» — фоновое действие (открыли чат): без сети или при ошибке
  /// молча откладываем до следующего открытия, счётчик честно остаётся.
  /// «Пометить непрочитанным» — явное действие, без сети —
  /// [ChatsOfflineException].
  @override
  Future<void> setRead(String chatID, bool read) async {
    if (!read) {
      await _setDialog(chatID, markedUnread: true);
      return;
    }
    if (!_reading.add(chatID)) return;
    try {
      final row = await _store.dialog(userID: _sync.me, chatID: idBytes(chatID));
      if (row == null || !await _sync.hasNetwork()) return;
      if (row.unreadCount > 0 && row.topMessageID > 0) {
        final response = await _sync.chats(
          pb.Chats_Request(
            readHistory: pb.Chats_ReadHistory(chatID: row.chatID, maxID: Int64(row.topMessageID)),
          ),
        );
        await _sync.applyUpdates(response.readHistory.updates);
        // Ветка: счётчик ведём сами, и readMaxID у поста (точка гаснет).
        if (row.type == pb.ChatType.CHAT_TYPE_THREAD.value) await _sync.markThreadRead(row.chatID, row.topMessageID);
      }
      if (row.markedUnread) await _setDialog(chatID, markedUnread: false);
    } on ChatsOfflineException {
      // Прочитаем при следующем открытии.
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    } finally {
      _reading.remove(chatID);
    }
  }

  /// «Прочитать все» (папка): и упоминания в группах — иначе «@» остался бы.
  @override
  Future<void> readAll(List<String> chatIDs) async {
    for (final chatID in chatIDs) {
      await setRead(chatID, true);
      final row = await _store.dialog(userID: _sync.me, chatID: idBytes(chatID));
      if (row != null && row.unreadMentions > 0) await readMentions(chatID, const []);
    }
  }

  /// Группа: владелец удаляет её у всех (`DeleteChat`), остальные выходят
  /// (`LeaveChat`); у меня диалог пропадает обновлением dialogDeleted.
  @override
  Future<void> delete(String chatID, {bool forEveryone = false}) async {
    await _requireNetwork();
    final chat = idBytes(chatID);
    final group = await _store.group(userID: _sync.me, chatID: chat);
    if (group != null) {
      final owner = group.role == pb.ChatRole.CHAT_ROLE_OWNER;
      final response = await _sync.chats(
        owner
            ? pb.Chats_Request(deleteChat: pb.Chats_DeleteChat(chatID: chat))
            : pb.Chats_Request(leaveChat: pb.Chats_LeaveChat(chatID: chat)),
      );
      await _sync.applyUpdates(owner ? response.deleteChat.updates : response.leaveChat.updates);
      // Сервер принял — у меня группы больше нет, даже если dialogDeleted
      // придёт позже (push).
      await _sync.forgetChat(chat);
      return;
    }
    final response = await _sync.chats(
      pb.Chats_Request(
        deleteDialog: pb.Chats_DeleteDialog(chatID: chat, forEveryone: forEveryone),
      ),
    );
    await _sync.applyUpdates(response.deleteDialog.updates);
  }

  // Папки — серверная настройка: без сети не меняем (ChatsOfflineException),
  // результат приходит обновлением folders (снимок в SQLite).

  @override
  Future<void> deleteFolder(String folderID) async {
    final id = folderIDToPb(folderID);
    if (id == 0) return;
    await _requireNetwork();
    final response = await _folderRequest(pb.Chats_Request(deleteFolder: pb.Chats_DeleteFolder(id: id)));
    if (response != null) await _sync.applyUpdates(response.deleteFolder.updates);
  }

  @override
  Future<void> saveFolder(models.ChatFolder folder) async {
    await _requireNetwork();
    final response = await _folderRequest(pb.Chats_Request(saveFolder: pb.Chats_SaveFolder(folder: folderToPb(folder))));
    if (response != null) await _sync.applyUpdates(response.saveFolder.updates);
  }

  @override
  Future<void> reorderFolders(List<String> folderIDs) async {
    await _requireNetwork();
    final ids = [for (final id in folderIDs) folderIDToPb(id)].where((id) => id > 0);
    final response = await _folderRequest(pb.Chats_Request(reorderFolders: pb.Chats_ReorderFolders(ids: ids)));
    if (response != null) await _sync.applyUpdates(response.reorderFolders.updates);
  }

  /// Отказ сервера (папку удалили на другом устройстве, лимит) — не ошибка
  /// экрана: снимок папок и так придёт обновлением, его и покажем. `null` —
  /// отказ.
  Future<pb.Chats_Response?> _folderRequest(pb.Chats_Request request) async {
    try {
      return await _sync.chats(request);
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: folder request failed: $error');
      return null;
    }
  }

  /// Зарегистрированные контакты из локального снимка адресной книги (без
  /// себя и скрытых профилей) — по алфавиту.
  @override
  Future<List<models.ChatMember>> contacts() async {
    final me = _sync.me;
    final hidden = {for (final h in await _repositories.hiddenProfiles.getAll()) idHex(h.userID)};
    final byID = <String, models.ChatMember>{};
    final userIDs = <List<int>>[];
    for (final c in await _repositories.contacts.getAll()) {
      final userID = c.userID;
      if (userID == null || userID.isEmpty || sameID(userID, me)) continue;
      final id = idHex(userID);
      if (hidden.contains(id) || byID.containsKey(id)) continue;
      byID[id] = models.ChatMember(id: id, name: c.displayName.isNotEmpty ? c.displayName : c.phone);
      userIDs.add(userID);
    }
    final lastSeen = await _repositories.profiles.getLastSeenByUserIDs(userIDs: userIDs, toHex: idHex);
    final members = [for (final m in byID.values) lastSeen[m.id] == null ? m : m.copyWith(lastSeen: lastSeen[m.id])];
    members.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return members;
  }

  @override
  Future<List<models.ChatMember>> searchUsers(String query) async {
    await _requireNetwork();
    final response = await _sync.chats(pb.Chats_Request(searchUsers: pb.Chats_SearchUsers(query: query)));
    if (!response.hasSearchUsers()) return const [];
    final me = _sync.me;
    final hidden = {for (final h in await _repositories.hiddenProfiles.getAll()) idHex(h.userID)};
    final api = _scope.api;
    final userIDs = <Uint8List>[];
    for (final profile in response.searchUsers.profiles) {
      final userID = Uint8List.fromList(profile.userID);
      if (userID.isEmpty || sameID(userID, me) || hidden.contains(idHex(userID))) continue;
      // В кэш профилей — имя по общему правилу, аватар (UserAvatar) и профиль
      // по тапу берутся оттуда; фото докачается само.
      await api.cacheProfile(profile, waitAvatar: false);
      userIDs.add(userID);
    }
    final peers = await _loadPeers(userIDs);
    final utils = getIt.get<Utils>();
    return [
      for (final userID in userIDs)
        if (peers[idHex(userID)] case final peer?)
          models.ChatMember(
            id: idHex(userID),
            name: peer.title,
            username: peer.profile?.username ?? '',
            phone: utils.phoneNormalization(phoneNumber: peer.profile?.phoneNumber ?? '').international,
          ),
    ];
  }

  /// Публичные группы (`Chats.SearchChats`). Группы выключены (флаг) — пусто:
  /// открыть найденную было бы некуда. Аватары докачиваются здесь же (недолго,
  /// параллельно) — выдача живёт только в памяти экрана поиска.
  @override
  Future<List<models.Chat>> searchChats(String query) async {
    await _requireNetwork();
    final response = await _sync.chats(pb.Chats_Request(searchChats: pb.Chats_SearchChats(query: query)));
    if (!response.hasSearchChats()) return const [];
    final found = await Future.wait([
      for (final item in response.searchChats.chats)
        // Только диалоги списка: открыть другое было бы некуда.
        if (_sync.showsChatType(item.chat.type.value)) _foundChat(item),
    ]);
    return [for (final chat in found) ?chat];
  }

  /// Найденная группа с аватаром: нет в кэше — качаем (до [_searchAvatarWait],
  /// не успели — без фото).
  Future<models.Chat?> _foundChat(pb.Chats_FoundChat found) async {
    final info = found.chat;
    var path = await _avatarPath(info.avatarCdnID);
    if (path.isEmpty && info.avatarCdnID.isNotEmpty && info.hasAvatar()) {
      try {
        path = (await _scope.cdn.download(cdn: models.CDN.fromProto(info.avatar)).timeout(_searchAvatarWait)).path;
      } catch (error) {
        _logger.warning('chats: search avatar: $error');
      }
    }
    return foundChatFromPb(found, avatarPath: path);
  }

  static const _searchAvatarWait = Duration(seconds: 3);

  /// Существующий личный чат — сразу из кэша (и offline); новый создаёт сервер
  /// (без сети — [ChatsOfflineException]). Свой userID — «Избранное».
  @override
  Future<String> openPrivateChat(String userID) async {
    final peer = idBytes(userID);
    if (peer.isEmpty) return '';
    final local = await _store.dialogByPeer(userID: _sync.me, peerUserID: peer);
    if (local != null) return idHex(local.chatID);
    await _requireNetwork();
    final response = await _sync.chats(pb.Chats_Request(openPrivate: pb.Chats_OpenPrivate(userID: peer)));
    if (!response.hasOpenPrivate() || !response.openPrivate.hasDialog()) return '';
    final dialog = response.openPrivate.dialog;
    await _sync.saveDialog(dialog);
    return idHex(dialog.chatID);
  }

  @override
  Future<String> findPrivateChat(String userID) async {
    final peer = idBytes(userID);
    if (peer.isEmpty) return '';
    final local = await _store.dialogByPeer(userID: _sync.me, peerUserID: peer);
    return local == null ? '' : idHex(local.chatID);
  }

  /// Общее пространство имён с пользователями (`Chats.CheckUsername`): своё
  /// текущее имя группы [exceptChatID] — свободно. Без сети —
  /// [ChatsOfflineException] (форма покажет «не удалось проверить», а не
  /// «свободно»); не по правилам сервера — `ChatsRequestException`
  /// «usernameInvalid».
  @override
  Future<bool> isUsernameAvailable(String username, {String exceptChatID = ''}) async {
    await _requireNetwork();
    final response = await _sync.chats(
      pb.Chats_Request(
        checkUsername: pb.Chats_CheckUsername(username: username, exceptChatID: idBytes(exceptChatID)),
      ),
    );
    final result = response.checkUsername;
    if (result.invalid) throw const ChatsRequestException(usernameInvalidError, StatusCode.invalidArgument);
    return result.available;
  }

  /// Группа: способ вступления [joinMode] и публичное имя [username] (только
  /// у [models.ChatJoinMode.open]); код ссылки-приглашения частной выдаёт
  /// сервер (`Dialog.inviteCode`), [inviteLink] формы не отправляется.
  /// Канал (срез 4.1) — тот же `CreateGroup` с `channel`:
  /// [memberIDs] — подписчики («Добавить подписчиков»), вступление — только
  /// публичный (OPEN) или по ссылке (LINK), «Скрыть историю» у канала нет.
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
    bool historyHidden = false,
    bool commentsEnabled = false,
    int commentsTimeLimit = 0,
    models.ChatCommentsWho commentsWho = models.ChatCommentsWho.all,
    int commentsMinSubscription = 0,
    int newcomerMediaDelay = 0,
  }) async {
    final channel = type == models.ChatType.channel;
    if (communityID.isNotEmpty || !(channel || type == models.ChatType.group)) {
      _unsupported('Сообщества');
    }
    // Публичная — только с именем; без имени — частная по ссылке (канал —
    // других способов нет).
    final open = joinMode == models.ChatJoinMode.open && username.isNotEmpty;
    final mode = open ? models.ChatJoinMode.open : (joinMode == models.ChatJoinMode.open || channel ? models.ChatJoinMode.link : joinMode);
    await _requireNetwork();
    final avatar = avatarPath.isEmpty ? null : await _uploadChatAvatar(avatarPath);
    final response = await _sync.chats(
      pb.Chats_Request(
        createGroup: pb.Chats_CreateGroup(
          title: title,
          about: about,
          memberUserIDs: [
            for (final id in memberIDs)
              if (idBytes(id) case final userID when userID.isNotEmpty) userID,
          ],
          avatarCdnID: avatar?.cdnID,
          avatarThumbhash: avatar?.thumbhash,
          randomID: Int64(_randomID()),
          username: open ? username : null,
          joinMode: joinModeToPb(mode),
          // У публичной истории не скрыть (сервер — INVALID_ARGUMENT); у
          // канала «Скрыть историю» нет.
          historyHidden: historyHidden && !open && !channel,
          channel: channel ? true : null,
          // Канал: комментарии к постам (4.3); у группы полей нет.
          commentsEnabled: channel && commentsEnabled ? true : null,
          commentsTimeLimit: channel && commentsEnabled && commentsTimeLimit > 0 ? commentsTimeLimit : null,
          commentsWho: channel && commentsEnabled ? commentsWhoToPb(commentsWho) : null,
          commentsMinSubscription:
              channel && commentsEnabled && commentsWho == models.ChatCommentsWho.subscribers && commentsMinSubscription > 0
              ? commentsMinSubscription
              : null,
        ),
      ),
    );
    final result = response.createGroup;
    await _sync.applyUpdates(result.updates);
    if (result.hasDialog()) await _sync.saveDialog(result.dialog);
    final chatID = idHex(result.dialog.chatID);
    // «Новичкам — без ссылок и медиа» в комментариях — в CreateGroup поля нет:
    // отдельной правкой (канал уже создан — сбой не отменяет создание).
    if (channel && commentsEnabled && newcomerMediaDelay > 0 && result.dialog.chatID.isNotEmpty) {
      try {
        await _editChat(pb.Chats_EditChat(chatID: result.dialog.chatID, newcomerMediaDelay: newcomerMediaDelay));
      } catch (error, stackTrace) {
        _logger.handle(error, stackTrace);
      }
    }
    if (result.restrictedUserIDs.isNotEmpty) throw ChatsMembersRestrictedException(chatID, result.restrictedUserIDs.length);
    return chatID;
  }

  /// Фото группы — на CDN (как аватар профиля); сбой сети —
  /// [ChatsOfflineException]: группа не создаётся / не меняется.
  /// Загружает фото группы; [thumbhash] — размытое превью для участников, пока
  /// фото качается (не получилось посчитать — пусто, фото всё равно ставим).
  Future<({Uint8List cdnID, String thumbhash})> _uploadChatAvatar(String path) async {
    try {
      final file = await _scope.cdn.uploadFile(file: File(path), folder: 'avatars', contentType: 'image/jpeg');
      return (cdnID: Uint8List.fromList(file.cdnID), thumbhash: await avatarThumbhash(await File(path).readAsBytes()));
    } on FileSystemException {
      rethrow;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
      throw const ChatsOfflineException();
    }
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
    bool historyHidden = false,
    bool noForwards = false,
  }) async {
    final chat = idBytes(chatID);
    final group = await _store.group(userID: _sync.me, chatID: chat);
    if (group == null) _unsupported('Каналы и сообщества');
    // Название, описание, фото, роль вступающих (3.2), способ вступления,
    // публичное имя и «Скрыть историю» (3.3), «новички» и «скрыть участников»
    // (3.4), «Запретить копирование»; остальное — следующие срезы.
    final info = group.info;
    final currentAvatar = await _avatarPath(info.avatarCdnID);
    final avatarChanged = avatarPath != currentAvatar && !(avatarPath.isEmpty && info.avatarCdnID.isEmpty);
    final titleChanged = title != info.title;
    final aboutChanged = about != info.about;
    final roleChanged =
        info.type != pb.ChatType.CHAT_TYPE_CHANNEL &&
        (defaultRole == models.ChatRole.reader || defaultRole == models.ChatRole.writer) &&
        defaultRole != roleFromPb(info.defaultRole);
    final channel = info.type == pb.ChatType.CHAT_TYPE_CHANNEL;
    final join = editJoinChanges(info, joinMode: joinMode, username: username, historyHidden: channel ? false : historyHidden);
    // У канала роли вступающих нет (подписчик только читает); «новички» —
    // в комментариях (4.3).
    final newcomerChanged = newcomerMediaDelay != info.newcomerMediaDelay;
    final membersHiddenChanged = membersHidden != info.membersHidden;
    final noForwardsChanged = noForwards != info.noForwards;
    final signChanged = channel && signMessages != info.signMessages;
    // Канал: комментарии (4.3) — только изменившееся.
    final minSubscription = commentsWho == models.ChatCommentsWho.subscribers ? commentsMinSubscription : 0;
    final commentsEnabledChanged = channel && commentsEnabled != info.commentsEnabled;
    final commentsLimitChanged = channel && commentsTimeLimit != info.commentsTimeLimit;
    final commentsWhoChanged = channel && commentsWhoToPb(commentsWho) != info.commentsWho;
    final minSubscriptionChanged = channel && minSubscription != info.commentsMinSubscription;
    final commentsChanged = commentsEnabledChanged || commentsLimitChanged || commentsWhoChanged || minSubscriptionChanged;
    final extrasChanged = newcomerChanged || membersHiddenChanged || noForwardsChanged || signChanged || commentsChanged;
    if (!titleChanged && !aboutChanged && !avatarChanged && !roleChanged && join.isEmpty && !extrasChanged) return;
    await _requireNetwork();
    final avatar = !avatarChanged
        ? null
        : (avatarPath.isEmpty ? (cdnID: Uint8List(0), thumbhash: '') : await _uploadChatAvatar(avatarPath));
    final response = await _sync.chats(
      pb.Chats_Request(
        editChat: pb.Chats_EditChat(
          chatID: chat,
          title: titleChanged ? title : null,
          about: aboutChanged ? about : null,
          avatarCdnID: avatar?.cdnID,
          avatarThumbhash: avatar == null || avatar.thumbhash.isEmpty ? null : avatar.thumbhash,
          defaultRole: roleChanged ? roleToPb(defaultRole) : null,
          joinMode: join.joinMode,
          username: join.username,
          historyHidden: join.historyHidden,
          newcomerMediaDelay: newcomerChanged ? newcomerMediaDelay : null,
          membersHidden: membersHiddenChanged ? membersHidden : null,
          noForwards: noForwardsChanged ? noForwards : null,
          signMessages: signChanged ? signMessages : null,
          commentsEnabled: commentsEnabledChanged ? commentsEnabled : null,
          commentsTimeLimit: commentsLimitChanged ? commentsTimeLimit : null,
          commentsWho: commentsWhoChanged ? commentsWhoToPb(commentsWho) : null,
          commentsMinSubscription: minSubscriptionChanged ? minSubscription : null,
        ),
      ),
    );
    await _sync.applyUpdates(response.editChat.updates);
  }

  /// Настройка группы через `EditChat` (право changeInfo): без сети —
  /// [ChatsOfflineException], отказ — `ChatsRequestException`; новое
  /// `ChatInfo` приходит обновлением журнала чата.
  Future<void> _editChat(pb.Chats_EditChat edit) async {
    await _requireNetwork();
    final response = await _sync.chats(pb.Chats_Request(editChat: edit));
    await _sync.applyUpdates(response.editChat.updates);
  }

  /// Имя пользователя (как на сервере, без учёта регистра).
  static final _usernamePattern = RegExp(r'^[A-Za-z0-9_]{5,24}$');

  /// Код приглашения после `+` (сервер выдаёт 12 символов base62).
  static final _invitePattern = RegExp(r'^\+[A-Za-z0-9]{4,64}$');

  /// Чужие группы, открытые по ссылке (hex chatID → предпросмотр): только в
  /// памяти — до вступления или перезапуска.
  final _previews = <String, _Preview>{};
  final _previewsChanged = StreamController<void>.broadcast();

  /// `iperon.net/<username>` или `iperon.net/+код` (`Chats.ResolveLink`).
  /// Знакомое — без сети: своё имя («Избранное»), собеседник с чатом в кэше,
  /// своя группа (по имени или основной ссылке), публичный канал, уже
  /// открытый без подписки. Иначе сервер: диалог (личный чат, группа, где я
  /// участник) — в кэш; публичный канал (`canViewHistory`, 4.4) — в кэш как
  /// канал без подписки (лента, Watch, просмотры; в списке его нет); чужая
  /// группа — предпросмотр (`Chat.isMember == false`). Нет такого / ссылка
  /// недействительна — пусто.
  @override
  Future<String> resolveLink(String path) async {
    final name = path.trim().replaceFirst(RegExp(r'^/+'), '').split('/').first.replaceFirst('@', '');
    if (!_auth.isAuthorized) return '';
    final invite = name.startsWith('+');
    if (invite ? !_invitePattern.hasMatch(name) : !_usernamePattern.hasMatch(name)) return '';
    final me = _sync.me;
    final local = await _localLink(name, invite: invite);
    if (local.isNotEmpty) return local;

    await _requireNetwork();
    try {
      final response = await _sync.chats(pb.Chats_Request(resolveLink: pb.Chats_ResolveLink(path: invite ? name : name.toLowerCase())));
      if (!response.hasResolveLink()) return '';
      final result = response.resolveLink;
      if (result.hasDialog() && result.dialog.chatID.isNotEmpty) {
        await _sync.saveDialog(result.dialog);
        return idHex(result.dialog.chatID);
      }
      if (!result.hasPreview() || result.preview.chat.chatID.isEmpty) return '';
      // Не группа и не канал (сообщества — пока только в демо) — в списке
      // такого нет, и предпросмотр открыть некуда.
      if (!_sync.showsChatType(result.preview.chat.type.value)) {
        final channel = result.preview.chat.type == pb.ChatType.CHAT_TYPE_CHANNEL;
        throw ChatsRequestException(channel ? 'channelsDisabled' : 'groupsDisabled', StatusCode.failedPrecondition);
      }
      final preview = result.preview;
      final api = _scope.api;
      for (final profile in preview.members) {
        await api.cacheProfile(profile, waitAvatar: false);
      }
      final id = idHex(preview.chat.chatID);
      // Публичный канал (4.4) читается без подписки: кэш как у канала
      // (Watch, история, просмотры), в списке его нет.
      if (preview.canViewHistory && preview.chat.type == pb.ChatType.CHAT_TYPE_CHANNEL) {
        await _sync.saveBrowsedChannel(preview.chat);
        if (_previews.remove(id) != null) _previewsChanged.add(null);
        return id;
      }
      _previews[id] = _Preview(owner: idHex(me), path: invite ? name : name.toLowerCase(), preview: preview);
      _previewsChanged.add(null);
      return id;
    } on ChatsRequestException catch (error) {
      if (!error.isNotFound) {
        if (error.isGroupsDisabled || error.isChannelsDisabled) rethrow;
        _logger.warning('chats: resolve link failed: $error');
      }
      return '';
    }
  }

  /// Ссылка на знакомое — из кэша, без сети (пусто — спросить сервер).
  Future<String> _localLink(String name, {required bool invite}) async {
    final me = _sync.me;
    if (invite) {
      final code = inviteCodeOf(name);
      for (final g in await _store.groups(userID: me)) {
        if (g.inviteCode == code) return idHex(g.chatID);
      }
      return '';
    }
    final username = name.toLowerCase();
    final mine = await _repositories.myProfile.getByUserID(userID: me);
    final peer = mine.username.toLowerCase() == username ? me : await _repositories.profiles.userIDByUsername(username);
    if (peer != null) {
      final local = await _store.dialogByPeer(userID: me, peerUserID: peer);
      if (local != null) return idHex(local.chatID);
    }
    for (final g in await _store.groups(userID: me)) {
      if (!_sync.showsChatType(g.info.type.value)) continue;
      if (g.info.username.isNotEmpty && g.info.username.toLowerCase() == username) return idHex(g.chatID);
    }
    return '';
  }

  /// Предпросмотр → модель чата: не участник, «Заявка отправлена» —
  /// `joinRequested`.
  Future<models.Chat> _previewChat(String id, _Preview preview) async {
    final info = preview.preview.chat;
    return models.Chat(
      id: id,
      type: info.type == pb.ChatType.CHAT_TYPE_CHANNEL ? models.ChatType.channel : models.ChatType.group,
      title: info.title,
      about: info.about,
      avatarPath: await _groupAvatar(info),
      avatarThumbhash: info.avatarThumbhash,
      membersCount: info.membersCount,
      myRole: roleFromPb(info.defaultRole),
      defaultRole: roleFromPb(info.defaultRole),
      joinMode: previewJoinMode(preview.preview),
      username: info.username,
      historyHidden: info.historyHidden,
      reactionsMode: reactionsModeFromPb(info.reactionsMode),
      reactions: info.reactions,
      slowMode: info.slowMode,
      newcomerMediaDelay: info.newcomerMediaDelay,
      membersHidden: info.membersHidden,
      noForwards: info.noForwards,
      signMessages: info.signMessages,
      maxReactions: maxReactionsOf(info),
      commentsEnabled: info.type == pb.ChatType.CHAT_TYPE_CHANNEL && info.commentsEnabled,
      commentsTimeLimit: info.commentsTimeLimit,
      commentsWho: commentsWhoFromPb(info.commentsWho),
      commentsMinSubscription: info.commentsMinSubscription,
      isMember: false,
      joinRequested: preview.requested,
      createdAt: info.createdAt > 0 ? DateTime.fromMillisecondsSinceEpoch(info.createdAt.toInt()) : null,
    );
  }

  /// «Вступить» / «Подать заявку» в группу из предпросмотра (`Chats.JoinChat`
  /// по той же ссылке): вступили — диалог в кэш, история — с сервера; нужна
  /// заявка — «Заявка отправлена» (вступим, когда одобрят: придёт dialogNew).
  ///
  /// Публичный канал без подписки (4.4) — «Подписаться» по его имени: кэш
  /// становится обычным каналом (роль с сервера), окно не перезагружается.
  @override
  Future<void> joinChat(String chatID) async {
    final preview = _previews[chatID];
    final String path;
    if (preview == null) {
      final group = await _store.group(userID: _sync.me, chatID: idBytes(chatID));
      if (group == null || !group.browsing || group.info.username.isEmpty) return;
      path = group.info.username.toLowerCase();
    } else {
      if (preview.requested) return;
      path = preview.path;
    }
    await _requireNetwork();
    final response = await _sync.chats(pb.Chats_Request(joinChat: pb.Chats_JoinChat(path: path)));
    final result = response.joinChat;
    await _sync.applyUpdates(result.updates);
    if (result.hasDialog() && result.dialog.chatID.isNotEmpty) {
      await _sync.saveDialog(result.dialog);
      if (_previews.remove(chatID) != null) _previewsChanged.add(null);
      final chat = idBytes(chatID);
      unawaited(
        _sync.loadHistory(chat).catchError((Object error, StackTrace stackTrace) {
          if (error is! ChatsOfflineException) _logger.handle(error, stackTrace);
        }),
      );
      return;
    }
    if (result.requested && preview != null) {
      preview.requested = true;
      _previewsChanged.add(null);
    }
  }

  /// История чужой публичной группы (`ChatPreview.canViewHistory`) — только
  /// чтение, без журнала и кэша: страница за страницей в память
  /// предпросмотра. [older] — следующая страница старше загруженной.
  /// Возвращает, есть ли ещё старше.
  Future<bool> _loadPreviewHistory(String chatID, {bool older = false}) async {
    final preview = _previews[chatID];
    if (preview == null || !preview.preview.canViewHistory) return false;
    if (older && !preview.hasMore) return false;
    if (!await _sync.hasNetwork()) return true;
    final offset = older && preview.history.isNotEmpty ? preview.history.first.messageID : Int64.ZERO;
    try {
      final response = await _sync.messages(
        pb.Messages_Request(
          history: pb.Messages_History(chatID: idBytes(chatID), offsetID: offset, limit: _windowStep),
        ),
      );
      final page = response.history;
      final known = {for (final m in preview.history) m.messageID};
      // История — от новых к старым; в памяти — от старых к новым.
      final fresh = [
        for (final m in page.messages.reversed)
          if (!known.contains(m.messageID)) m,
      ];
      preview.history = older ? [...fresh, ...preview.history] : mergePreviewHistory(preview.history, fresh);
      if (older || preview.history.length == fresh.length) preview.hasMore = page.hasMore;
      _windowChanged.add(chatID);
      return preview.hasMore;
    } on ChatsOfflineException {
      return true;
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: preview history failed: $error');
      return false;
    }
  }

  /// Ветка уже открывалась на этом устройстве — сразу из кэша (и без сети;
  /// сведения освежаются в фоне), иначе `Messages.OpenComments` (ветка
  /// создаётся на сервере при первом обращении): без сети —
  /// [ChatsOfflineException], отказ («commentsDisabled») —
  /// `ChatsRequestException`.
  @override
  Future<String> openComments(String channelID, String postID) async {
    final channel = idBytes(channelID);
    final post = int.tryParse(postID);
    if (channel.isEmpty || post == null || !_auth.isAuthorized) return '';
    final me = _sync.me;
    final cached = await _store.thread(userID: me, chatID: channel, postID: post);
    if (cached != null && await _store.dialog(userID: me, chatID: cached) != null) {
      unawaited(_refreshThread(channel, post));
      return idHex(cached);
    }
    await _requireNetwork();
    return _openThread(channel, post);
  }

  Future<String> _openThread(Uint8List channel, int post) async {
    final response = await _sync.messages(
      pb.Messages_Request(
        openComments: pb.Messages_OpenComments(chatID: channel, postID: Int64(post)),
      ),
    );
    final result = response.openComments;
    if (!result.hasThread() || result.thread.chatID.isEmpty) return '';
    // Канал и пост ветки — из запроса, если сервер их не повторил.
    final info = result.thread.deepCopy()..type = pb.ChatType.CHAT_TYPE_THREAD;
    if (info.parentChatID.isEmpty) info.parentChatID = channel;
    if (info.postID == 0) info.postID = Int64(post);
    await _sync.saveThread(info, result.readInboxMaxID.toInt());
    return idHex(info.chatID);
  }

  /// Открыли ветку из кэша — сведения (срок, мой readMaxID) с сервера, если
  /// есть сеть; нет — покажем кэш.
  Future<void> _refreshThread(Uint8List channel, int post) async {
    try {
      if (await _sync.hasNetwork()) await _openThread(channel, post);
    } on ChatsOfflineException {
      // Освежим при следующем открытии.
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: refresh thread failed: $error');
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Право editMessages; новые комментарии поста (и срок открытой ветки)
  /// приходят обновлением `postComments`.
  @override
  Future<void> setCommentsClosed(String channelID, String postID, bool closed) async {
    final channel = idBytes(channelID);
    final post = int.tryParse(postID);
    if (channel.isEmpty || post == null) return;
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        setCommentsClosed: pb.Messages_SetCommentsClosed(chatID: channel, postID: Int64(post), closed: closed),
      ),
    );
    await _sync.applyUpdates(response.setCommentsClosed.updates);
  }

  /// Канал ветки и пост (для шапки ленты ветки); `null` — не ветка.
  Future<({Uint8List chatID, int postID})?> _threadPost(Uint8List chat) => _store.threadPost(userID: _sync.me, threadChatID: chat);

  /// Посты, которых нет в кэше канала, уже запрошены (hex канал:пост).
  final _postFetches = <String>{};

  /// Пост ветки — шапкой её ленты, как пересланный из канала (в демо — так
  /// же). Нет в кэше канала — запрашиваем (раз за запуск) и кладём скрытым из
  /// ленты канала (как найденное поиском), лента ветки перечитается.
  Future<models.Message?> _threadHeader(String chatID, ({Uint8List chatID, int postID}) thread) async {
    final me = _sync.me;
    final post = await _store.message(userID: me, chatID: thread.chatID, messageID: thread.postID);
    if (post == null) {
      final key = '${idHex(thread.chatID)}:${thread.postID}';
      if (_postFetches.add(key)) unawaited(_fetchPost(thread.chatID, thread.postID, key));
      return null;
    }
    final channel = await _store.group(userID: me, chatID: thread.chatID);
    final header = messageFromPb(post, chatID: chatID, myUserID: me, readOutboxMaxID: 0, isSelf: false, channel: true);
    final message = header.copyWith(
      id: threadPostMessageID(thread.postID),
      outgoing: false,
      // Аватар шапки — канала (название — в «Переслано из»).
      senderAvatarPath: channel == null ? '' : await _groupAvatar(channel.info),
      status: models.MessageStatus.read,
      forward: models.MessageForward(
        name: channel?.info.title ?? '',
        chatID: idHex(thread.chatID),
        messageID: '${thread.postID}',
        signature: post.authorSignature,
      ),
      reactions: const [],
      views: 0,
      commentsCount: 0,
      commenters: const [],
      commentsThreadID: '',
      commentsUnread: false,
      pinned: false,
    );
    return _withServerMedia(message, post.content, chatID);
  }

  Future<void> _fetchPost(Uint8List channel, int postID, String key) async {
    try {
      if (!await _sync.hasNetwork()) {
        _postFetches.remove(key);
        return;
      }
      final response = await _sync.messages(
        pb.Messages_Request(
          get: pb.Messages_Get(chatID: channel, messageIDs: [Int64(postID)]),
        ),
      );
      final found = response.get.messages.where((m) => m.messageID.toInt() == postID).toList();
      if (found.isNotEmpty) await _sync.saveSearchHits(channel, found);
    } on ChatsOfflineException {
      _postFetches.remove(key);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  // --- ссылки-приглашения и заявки (владелец / админ с правом приглашать) ---

  /// Из кэша (`chatInviteLinks`, видно без сети); при подписке — свежий
  /// список с сервера (нет сети / нет права — остаётся кэш).
  @override
  Stream<List<models.ChatInviteLink>> watchInviteLinks(String chatID) {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return Stream.value(const []);
    unawaited(_refreshInviteLinks(chat));
    return _repositories.db
        .onChange(const [ChatsRepository.inviteLinksTable])
        .asyncMap(
          (_) async => sortInviteLinks([for (final l in await _store.inviteLinks(userID: _sync.me, chatID: chat)) inviteLinkFromPb(l)]),
        )
        .distinct(listEquals);
  }

  Future<void> _refreshInviteLinks(Uint8List chat) async {
    try {
      if (!await _sync.hasNetwork()) return;
      final response = await _sync.chats(pb.Chats_Request(inviteLinks: pb.Chats_InviteLinks(chatID: chat)));
      final user = _sync.me;
      await _store.transaction((tx) => tx.replaceInviteLinks(userID: user, chatID: chat, links: response.inviteLinks.links));
    } on ChatsOfflineException {
      // Покажем кэш; освежим при следующем открытии.
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: invite links failed: $error');
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Ссылка из ответа сервера — в кэш.
  Future<void> _saveInviteLink(Uint8List chat, pb.ChatInviteLink link) async {
    if (link.code.isEmpty) return;
    final user = _sync.me;
    await _store.transaction((tx) => tx.upsertInviteLink(userID: user, chatID: chat, link: link));
  }

  @override
  Future<void> createInviteLink(
    String chatID, {
    String title = '',
    DateTime? expireDate,
    int usageLimit = 0,
    bool requestApproval = false,
  }) async {
    await _requireNetwork();
    final chat = idBytes(chatID);
    final response = await _sync.chats(
      pb.Chats_Request(
        createInviteLink: pb.Chats_CreateInviteLink(
          chatID: chat,
          title: title,
          expireDate: Int64(expireDate?.millisecondsSinceEpoch ?? 0),
          // С одобрением заявок лимит вступлений не нужен (как в Telegram).
          usageLimit: requestApproval ? 0 : usageLimit,
          requestApproval: requestApproval,
        ),
      ),
    );
    await _saveInviteLink(chat, response.createInviteLink.link);
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
    await _requireNetwork();
    final chat = idBytes(chatID);
    final response = await _sync.chats(
      pb.Chats_Request(
        editInviteLink: pb.Chats_EditInviteLink(
          chatID: chat,
          code: inviteCodeOf(linkID),
          title: title,
          expireDate: Int64(expireDate?.millisecondsSinceEpoch ?? 0),
          usageLimit: requestApproval ? 0 : usageLimit,
          requestApproval: requestApproval,
        ),
      ),
    );
    await _saveInviteLink(chat, response.editInviteLink.link);
  }

  /// Основная заменяется новой: её код — и в группу (`Chat.inviteLink`).
  @override
  Future<void> revokeInviteLink(String chatID, String linkID) async {
    await _requireNetwork();
    final chat = idBytes(chatID);
    final response = await _sync.chats(
      pb.Chats_Request(
        revokeInviteLink: pb.Chats_RevokeInviteLink(chatID: chat, code: inviteCodeOf(linkID)),
      ),
    );
    final result = response.revokeInviteLink;
    await _saveInviteLink(chat, result.revoked);
    if (result.hasPrimary() && result.primary.code.isNotEmpty) {
      await _saveInviteLink(chat, result.primary);
      final user = _sync.me;
      await _store.transaction((tx) => tx.setGroupInviteCode(userID: user, chatID: chat, code: result.primary.code));
    }
    await _sync.applyUpdates(result.updates);
  }

  /// Сервер удаляет все отозванные сразу ([deletesRevokedLinkSingly]).
  @override
  Future<void> deleteRevokedLinks(String chatID, {String linkID = ''}) async {
    await _requireNetwork();
    final chat = idBytes(chatID);
    await _sync.chats(pb.Chats_Request(deleteRevokedInviteLinks: pb.Chats_DeleteRevokedInviteLinks(chatID: chat)));
    final user = _sync.me;
    await _store.transaction((tx) => tx.deleteRevokedInviteLinks(userID: user, chatID: chat));
  }

  /// Сколько заявок читать за раз и сколько страниц максимум.
  static const _requestsPage = 100;
  static const _requestsPages = 20;

  /// Заявки — только с сервера, при подписке и при каждом их изменении
  /// (`Update.joinRequests`, ответ на заявку). Не загрузились — ошибка в
  /// потоке: экран пишет «не загрузилось», а не «заявок нет».
  @override
  Stream<List<models.ChatJoinRequest>> watchJoinRequests(String chatID) {
    late final StreamController<List<models.ChatJoinRequest>> out;
    StreamSubscription<String>? changes;
    var pending = Future<void>.value();
    void reload() {
      pending = pending.then((_) async {
        try {
          final requests = await _loadJoinRequests(chatID);
          if (!out.isClosed) out.add(requests);
        } on ChatsOfflineException catch (error) {
          if (!out.isClosed) out.addError(error);
        } on ChatsRequestException catch (error) {
          _logger.warning('chats: join requests failed: $error');
          if (!out.isClosed) out.addError(error);
        } catch (error, stackTrace) {
          _logger.handle(error, stackTrace);
          if (!out.isClosed) out.addError(error, stackTrace);
        }
      });
    }

    out = StreamController<List<models.ChatJoinRequest>>(
      onListen: () {
        changes = _sync.joinRequestsChanged.where((id) => id == chatID).listen((_) => reload());
        reload();
      },
      onCancel: () async => changes?.cancel(),
    );
    return out.stream;
  }

  Future<List<models.ChatJoinRequest>> _loadJoinRequests(String chatID) async {
    if (!_auth.isAuthorized) return const [];
    await _requireNetwork();
    final chat = idBytes(chatID);
    final api = _scope.api;
    final rows = <pb.ChatJoinRequest>[];
    var offset = <int>[];
    var total = 0;
    for (var page = 0; page < _requestsPages; page++) {
      final response = await _sync.chats(
        pb.Chats_Request(
          joinRequests: pb.Chats_JoinRequests(chatID: chat, offset: offset.isEmpty ? null : offset, limit: _requestsPage),
        ),
      );
      final result = response.joinRequests;
      for (final profile in result.profiles) {
        await api.cacheProfile(profile, waitAvatar: false);
      }
      rows.addAll(result.requests);
      if (page == 0) total = result.total;
      if (result.nextOffset.isEmpty) break;
      offset = result.nextOffset;
    }
    // Счётчик на плашке — как сейчас на сервере.
    final user = _sync.me;
    await _store.transaction((tx) => tx.setGroupPendingRequests(userID: user, chatID: chat, pending: total));
    if (rows.isEmpty) return const [];
    final peers = _Peers(await _loadPeers([for (final r in rows) Uint8List.fromList(r.userID)]));
    return [for (final r in rows) joinRequestFromPb(r, name: peers.of(r.userID).title, about: peers.of(r.userID).profile?.aboutMe ?? '')];
  }

  @override
  Future<void> answerJoinRequest(String chatID, {String userID = '', required bool approve}) async {
    await _requireNetwork();
    try {
      final response = await _sync.chats(
        pb.Chats_Request(
          answerJoinRequest: pb.Chats_AnswerJoinRequest(chatID: idBytes(chatID), userID: idBytes(userID), approve: approve),
        ),
      );
      await _sync.applyUpdates(response.answerJoinRequest.updates);
    } finally {
      // Список мог измениться и при отказе (заявку уже разобрали).
      _sync.notifyJoinRequestsChanged(chatID);
    }
  }

  /// Известные участники группы — из кэша (`chatGroupMembers`: страницы
  /// `Chats.Members` и `Update.chatMembers`), видны и без сети. Профиль
  /// личного чата их тоже читает — пусто.
  @override
  Future<List<models.ChatMember>> members(String chatID) async {
    if (!_auth.isAuthorized) return const [];
    final rows = await _store.groupMembers(userID: _sync.me, chatID: idBytes(chatID));
    return _membersFrom(rows);
  }

  /// Группы, чьих админов уже спросили за этот запуск ([refreshAdmins]).
  final _adminsRefreshed = <String>{};

  @override
  Future<bool> refreshAdmins(String chatID) async {
    if (!_auth.isAuthorized || _adminsRefreshed.contains(chatID)) return false;
    final me = _sync.me;
    final chat = idBytes(chatID);
    final group = await _store.group(userID: me, chatID: chat);
    // Подписи в пузырях — только у групп (в канале автор поста скрыт).
    if (group == null || group.info.type != pb.ChatType.CHAT_TYPE_GROUP || group.browsing) return false;
    if (!await _sync.hasNetwork()) return false;
    try {
      final before = {for (final r in await _store.groupMembers(userID: me, chatID: chat)) _memberKey(r)};
      final response = await _sync.chats(pb.Chats_Request(members: pb.Chats_Members(chatID: chat, admins: true)));
      _adminsRefreshed.add(chatID);
      final page = response.members;
      final api = _scope.api;
      for (final profile in page.profiles) {
        await api.cacheProfile(profile, waitAvatar: false);
      }
      if (page.members.isEmpty) return false;
      await _store.transaction((tx) => tx.upsertGroupMembers(userID: me, chatID: chat, members: page.members));
      final after = {for (final r in await _store.groupMembers(userID: me, chatID: chat)) _memberKey(r)};
      if (setEquals(before, after)) return false;
      _sync.notifyMembersChanged(chatID);
      return true;
    } on ChatsOfflineException {
      return false;
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: admins not loaded: $error');
      return false;
    }
  }

  /// Участники из кэша → модели: имя по общему правилу, «в сети» / «был(а)»,
  /// владелец первым.
  Future<List<models.ChatMember>> _membersFrom(List<ChatGroupMemberRow> rows) async {
    if (rows.isEmpty) return const [];
    final me = _sync.me;
    final peers = _Peers(await _loadPeers([for (final r in rows) r.userID]));
    final members = [
      for (final r in rows)
        models.ChatMember(
          id: idHex(r.userID),
          name: sameID(r.userID, me) ? t.screenChat.you : peers.of(r.userID).title,
          username: peers.of(r.userID).profile?.username ?? '',
          role: roleFromPb(r.role),
          rights: rightsFromPb(r.rights),
          rank: r.rank,
          isSelf: sameID(r.userID, me),
          online: !sameID(r.userID, me) && ChatsPresence.instance.isOnline(idHex(r.userID)),
          lastSeen: peers.of(r.userID).profile?.lastSeenAt,
        ),
    ];
    final owners = members.where((m) => m.role == models.ChatRole.owner);
    return [...owners, ...members.where((m) => m.role != models.ChatRole.owner)];
  }

  /// Страница с сервера (`Chats.Members`, курсор — непрозрачный, base64) —
  /// в кэш; без сети — весь кэш одной страницей. Поиск ([query]) — на
  /// сервере ([_searchMembers]), без сети — по кэшу.
  @override
  Future<ChatMembersPage> membersPage(String chatID, {String cursor = '', int limit = 50, String query = ''}) async {
    final chat = idBytes(chatID);
    final me = _sync.me;
    final group = _auth.isAuthorized ? await _store.group(userID: me, chatID: chat) : null;
    if (group == null) return const ChatMembersPage(members: [], nextCursor: '', total: 0);
    Future<ChatMembersPage> cached() async {
      final members = await _membersFrom(await _store.groupMembers(userID: me, chatID: chat));
      final q = query.trim().toLowerCase();
      final found = q.isEmpty
          ? members
          : members.where((m) => m.name.toLowerCase().contains(q) || m.username.toLowerCase().contains(q.replaceFirst('@', ''))).toList();
      return ChatMembersPage(members: found, nextCursor: '', total: q.isEmpty ? group.info.membersCount : found.length);
    }

    if (!await _sync.hasNetwork()) return cached();
    if (query.trim().isNotEmpty) return _searchMembers(chatID, query.trim(), cursor: cursor, limit: limit, cached: cached);
    try {
      final before = {for (final r in await _store.groupMembers(userID: me, chatID: chat)) _memberKey(r)};
      final response = await _sync.chats(
        pb.Chats_Request(
          members: pb.Chats_Members(chatID: chat, offset: cursor.isEmpty ? null : base64Decode(cursor), limit: limit),
        ),
      );
      final page = response.members;
      final api = _scope.api;
      for (final profile in page.profiles) {
        await api.cacheProfile(profile, waitAvatar: false);
      }
      await _store.transaction((tx) async {
        if (cursor.isEmpty && page.nextOffset.isEmpty) {
          await tx.replaceGroupMembers(userID: me, chatID: chat, members: page.members);
        } else {
          await tx.upsertGroupMembers(userID: me, chatID: chat, members: page.members);
        }
      });
      final after = {for (final r in await _store.groupMembers(userID: me, chatID: chat)) _memberKey(r)};
      // Кэш известных изменился — «известные» ([members]) перечитаются.
      if (!setEquals(before, after)) _sync.notifyMembersChanged(chatID);
      final rows = [for (final m in page.members) ChatGroupMemberRow.fromPb(m)];
      return ChatMembersPage(
        members: await _membersFrom(rows),
        nextCursor: page.nextOffset.isEmpty ? '' : base64Encode(page.nextOffset),
        total: page.total,
      );
    } on ChatsOfflineException {
      return cached();
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: members page failed: $error');
      return cached();
    }
  }

  /// Поиск участников на сервере (`Members.query`: по началам слов имени в
  /// профиле или `@username`) — находит и тех, кого нет в кэше «известных».
  /// Первая страница дополняется найденными в кэше (имя из книги контактов
  /// сервер не знает); без сети или при отказе — только кэш.
  Future<ChatMembersPage> _searchMembers(
    String chatID,
    String query, {
    required String cursor,
    required int limit,
    required Future<ChatMembersPage> Function() cached,
  }) async {
    final chat = idBytes(chatID);
    final me = _sync.me;
    try {
      final response = await _sync.chats(
        pb.Chats_Request(
          members: pb.Chats_Members(chatID: chat, offset: cursor.isEmpty ? null : base64Decode(cursor), limit: limit, query: query),
        ),
      );
      final page = response.members;
      final api = _scope.api;
      for (final profile in page.profiles) {
        await api.cacheProfile(profile, waitAvatar: false);
      }
      if (page.members.isNotEmpty) {
        await _store.transaction((tx) => tx.upsertGroupMembers(userID: me, chatID: chat, members: page.members));
      }
      final found = [
        ...await _membersFrom([for (final m in page.members) ChatGroupMemberRow.fromPb(m)]),
      ];
      if (cursor.isEmpty) {
        final ids = {for (final m in found) m.id};
        found.addAll((await cached()).members.where((m) => !ids.contains(m.id)));
      }
      return ChatMembersPage(members: found, nextCursor: page.nextOffset.isEmpty ? '' : base64Encode(page.nextOffset), total: found.length);
    } on ChatsOfflineException {
      return cached();
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: members search failed: $error');
      return cached();
    }
  }

  /// Что в участнике видно в списках: роль, права, звание.
  static String _memberKey(ChatGroupMemberRow r) => '${idHex(r.userID)}:${r.role.value}:${idHex(r.rights.writeToBuffer())}:${r.rank}';

  @override
  Stream<void> watchMembersChanged(String chatID) => _sync.membersChanged.where((id) => id == chatID).map((_) {});

  /// Действие над участником группы на сервере: без сети —
  /// [ChatsOfflineException], отказ (нет права, «rightsTooWide» …) —
  /// `ChatsRequestException`; обновления ответа — в кэш сразу.
  Future<void> _memberAction(pb.Chats_Request request, pb.Updates Function(pb.Chats_Response response) updates) async {
    await _requireNetwork();
    final response = await _sync.chats(request);
    await _sync.applyUpdates(updates(response));
  }

  @override
  Future<void> setMemberRole(String chatID, String userID, models.ChatRole role) => _memberAction(
    pb.Chats_Request(
      setMemberRole: pb.Chats_SetMemberRole(chatID: idBytes(chatID), userID: idBytes(userID), role: roleToPb(role)),
    ),
    (response) => response.setMemberRole.updates,
  );

  @override
  Future<void> removeMember(String chatID, String userID, {bool ban = false}) => _memberAction(
    pb.Chats_Request(
      removeMember: pb.Chats_RemoveMember(chatID: idBytes(chatID), userID: idBytes(userID), ban: ban),
    ),
    (response) => response.removeMember.updates,
  );

  /// Сервер блокирует и не участника (`RemoveMember` с `ban`): без
  /// служебного сообщения, журнала у списка нет — экраны перечитают
  /// «Заблокированные».
  @override
  Future<void> banUser(String chatID, models.ChatMember user) async {
    await removeMember(chatID, user.id, ban: true);
    _sync.notifyMembersChanged(chatID);
  }

  /// Сколько заблокированных читать за раз и сколько страниц максимум.
  static const _bannedPage = 100;
  static const _bannedPages = 20;

  /// «Заблокированные» — только с сервера (список для админа, без кэша): без
  /// сети — [ChatsOfflineException], экран покажет, что не загрузилось.
  @override
  Future<List<models.ChatMember>> banned(String chatID) async {
    await _requireNetwork();
    final chat = idBytes(chatID);
    final api = _scope.api;
    final rows = <pb.ChatBannedMember>[];
    var offset = <int>[];
    for (var page = 0; page < _bannedPages; page++) {
      final response = await _sync.chats(
        pb.Chats_Request(
          banned: pb.Chats_Banned(chatID: chat, offset: offset.isEmpty ? null : offset, limit: _bannedPage),
        ),
      );
      final result = response.banned;
      for (final profile in result.profiles) {
        await api.cacheProfile(profile, waitAvatar: false);
      }
      rows.addAll(result.banned);
      if (result.nextOffset.isEmpty) break;
      offset = result.nextOffset;
    }
    if (rows.isEmpty) return const [];
    final peers = _Peers(await _loadPeers([for (final r in rows) Uint8List.fromList(r.userID)]));
    return [
      for (final r in rows)
        models.ChatMember(
          id: idHex(r.userID),
          name: peers.of(r.userID).title,
          username: peers.of(r.userID).profile?.username ?? '',
          role: models.ChatRole.reader,
          lastSeen: peers.of(r.userID).profile?.lastSeenAt,
        ),
    ];
  }

  @override
  Future<void> unbanMember(String chatID, String userID) async {
    await _requireNetwork();
    await _sync.chats(
      pb.Chats_Request(
        unban: pb.Chats_Unban(chatID: idBytes(chatID), userID: idBytes(userID)),
      ),
    );
    // Журнала у списка нет — экраны перечитают «Заблокированные».
    _sync.notifyMembersChanged(chatID);
  }

  /// Любой участник; в режиме «Только админы» — с правом приглашать (иначе
  /// отказ сервера). Кому нельзя по приватности
  /// (и заблокированных в группе — без права блокировать) сервер пропускает,
  /// а мы сообщаем ([ChatsMembersRestrictedException]); группа заполнена —
  /// `ChatsRequestException` «membersLimit».
  @override
  Future<void> addMembers(String chatID, List<String> userIDs) async {
    final ids = [
      for (final id in userIDs)
        if (idBytes(id) case final userID when userID.isNotEmpty) userID,
    ];
    if (ids.isEmpty) return;
    await _requireNetwork();
    final response = await _sync.chats(
      pb.Chats_Request(
        addMembers: pb.Chats_AddMembers(chatID: idBytes(chatID), userIDs: ids),
      ),
    );
    final result = response.addMembers;
    await _sync.applyUpdates(result.updates);
    if (result.restrictedUserIDs.isNotEmpty) throw ChatsMembersRestrictedException(chatID, result.restrictedUserIDs.length);
  }

  @override
  Future<void> setAdmin(String chatID, String userID, {required models.ChatAdminRights rights, String rank = ''}) => _memberAction(
    pb.Chats_Request(
      setAdmin: pb.Chats_SetAdmin(chatID: idBytes(chatID), userID: idBytes(userID), rights: rightsToPb(rights), rank: rank),
    ),
    (response) => response.setAdmin.updates,
  );

  @override
  Future<void> removeAdmin(String chatID, String userID) => _memberAction(
    pb.Chats_Request(
      removeAdmin: pb.Chats_RemoveAdmin(chatID: idBytes(chatID), userID: idBytes(userID)),
    ),
    (response) => response.removeAdmin.updates,
  );

  /// Пароль уходит pre-hash'ем, как в CloudPasswordVerify ([cloudPasswordHash]).
  @override
  Future<void> transferOwnership(String chatID, String userID, {String password = ''}) async {
    await _requireNetwork();
    final pwHash = password.isEmpty ? Uint8List(0) : await cloudPasswordHash(password);
    await _memberAction(
      pb.Chats_Request(
        transferOwnership: pb.Chats_TransferOwnership(chatID: idBytes(chatID), userID: idBytes(userID), pwHash: pwHash),
      ),
      (response) => response.transferOwnership.updates,
    );
  }

  /// Группа и канал: режим и набор (`EditChat.reactions`). «Некоторые» без
  /// единой — сервер не примет (1..всех), не отправляем. Канал — ещё
  /// [maxReactions] («Максимум реакций под постом», 1–11; `null` — не менять).
  @override
  Future<void> setChatReactions(String chatID, models.ChatReactionsMode mode, List<String> reactions, {int? maxReactions}) async {
    final chat = idBytes(chatID);
    final group = await _store.group(userID: _sync.me, chatID: chat);
    if (group == null) _unsupported('Реакции сообществ');
    if (mode == models.ChatReactionsMode.some && reactions.isEmpty) return;
    final channel = group.info.type == pb.ChatType.CHAT_TYPE_CHANNEL;
    await _editChat(
      pb.Chats_EditChat(
        chatID: chat,
        reactions: pb.Chats_ChatReactionsSettings(
          mode: reactionsModeToPb(mode),
          emojis: mode == models.ChatReactionsMode.some ? reactions : const [],
          // У группы поля нет (сервер — INVALID_ARGUMENT); 0 — не менять.
          maxReactions: channel && maxReactions != null ? maxReactions.clamp(1, maxReactionsPerPost) : null,
        ),
      ),
    );
  }

  @override
  Future<void> resetToCommunity(String chatID) async => _unsupported('Сообщества');

  @override
  Future<void> setSlowMode(String chatID, int seconds) async {
    final chat = idBytes(chatID);
    if (await _store.group(userID: _sync.me, chatID: chat) == null) _unsupported('Медленный режим сообществ');
    await _editChat(pb.Chats_EditChat(chatID: chat, slowMode: seconds));
  }

  // --- сообщения ---

  /// История из кэша + неотправленные (⏱) в конце; при подписке — свежая
  /// страница с сервера (нет сети — показываем кэш).
  @override
  Stream<List<models.Message>> watchMessages(String chatID) {
    final chat = idBytes(chatID);
    if (_previews.containsKey(chatID)) {
      // Чужая группа по ссылке: публичную читаем без вступления — в память,
      // без журнала и кэша.
      unawaited(_loadPreviewHistory(chatID));
    } else if (chat.isNotEmpty) {
      unawaited(
        _sync.loadHistory(chat).catchError((Object error, StackTrace stackTrace) {
          if (error is! ChatsOfflineException) _logger.handle(error, stackTrace);
        }),
      );
      // Открытый чат — докачиваем всю его историю в фоне: локальный поиск
      // (по началу слова, гибче серверного) и лента — по скачанному. Канал
      // без подписки (4.4) — нет: его кэш временный ([ChatsSync.pruneBrowsed]).
      unawaited(
        _sync.isBrowsing(chat).then((browsing) {
          if (!browsing) _sync.backfill(chat);
        }, onError: (Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)),
      );
    }
    // Перечитываем при изменении таблиц и при расширении окна истории
    // ([loadOlderMessages] из кэша — без записи в БД). Загрузки — по очереди,
    // чтобы старый результат не пришёл после нового.
    late final StreamController<List<models.Message>> out;
    StreamSubscription<void>? changes;
    StreamSubscription<String>? refresh;
    StreamSubscription<void>? uploads;
    // Ветка комментариев (4.3) и публичный канал без подписки (4.4): пока
    // окно открыто — временная подписка на журнал чата (`Chats.Watch`).
    var watching = false;
    var browsing = false;
    var cancelled = false;
    Future<void> watchThread() async {
      if (chat.isEmpty || !_auth.isAuthorized) return;
      final row = await _store.dialog(userID: _sync.me, chatID: chat);
      if (cancelled || row == null) return;
      if (row.type == pb.ChatType.CHAT_TYPE_CHANNEL.value) {
        browsing = await _sync.isBrowsing(chat);
        if (cancelled || !browsing) return;
        await _sync.touchBrowsed(chat);
      } else if (row.type != pb.ChatType.CHAT_TYPE_THREAD.value) {
        return;
      }
      if (cancelled) return;
      watching = true;
      _sync.watch(chat);
    }

    /// Окно закрыто: снять подписку (подписались, пока смотрели, — журнал
    /// канала и так идёт стриму, снимать на сервере нечего), канал без
    /// подписки — «свежий», и чистка кэша таких каналов.
    Future<void> unwatchThread() async {
      if (!watching) return;
      if (!browsing) {
        _sync.unwatch(chat);
        return;
      }
      final still = _auth.isAuthorized && await _sync.isBrowsing(chat);
      _sync.unwatch(chat, send: still);
      if (!still) return;
      await _sync.touchBrowsed(chat);
      await _sync.pruneBrowsed();
    }

    var pending = Future<void>.value();
    void reload() {
      pending = pending
          .then((_) async {
            final messages = await _loadMessages(chatID, chat);
            if (!out.isClosed) out.add(messages);
          })
          .catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace));
    }

    out = StreamController<List<models.Message>>(
      onListen: () {
        changes = _repositories.db.onChange(_messageTables).listen((_) => reload());
        refresh = _windowChanged.stream.where((id) => id == chatID).listen((_) => reload());
        uploads = _sync.uploadChanged.listen((_) => reload());
        unawaited(watchThread().catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)));
      },
      onCancel: () async {
        cancelled = true;
        unawaited(unwatchThread().catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)));
        await changes?.cancel();
        await refresh?.cancel();
        await uploads?.cancel();
        _windows.remove(chatID);
        _detached.remove(chatID);
      },
    );
    return out.stream;
  }

  /// Сколько последних сообщений чата показывать (окно истории): растёт по
  /// [loadOlderMessages], сбрасывается, когда чат закрыли.
  final _windows = <String, int>{};
  static const _initialWindow = 200;
  static const _windowStep = 100;

  /// Окно «вокруг сообщения» ([HistoryWindow]): переход к старому, которого
  /// нет в скачанной ленте, — лента показывает только его, пока прокрутка
  /// новее не дойдёт до обычной ленты; сбрасывается, когда чат закрыли.
  final _detached = <String, HistoryWindow>{};
  final _windowChanged = StreamController<String>.broadcast();

  @override
  Future<List<String>> searchMessages(String chatID, String query) async {
    final chat = idBytes(chatID);
    final match = ftsMatchQuery(query);
    if (chat.isEmpty || match == null || !_auth.isAuthorized) return const [];
    final ids = await _store.searchMessages(userID: _sync.me, chatID: chat, match: match);
    return [for (final id in ids) id.toString()];
  }

  /// Страница поиска на сервере (`Messages.Search`, по умолчанию у сервера
  /// тоже 20).
  static const _serverSearchLimit = 20;

  @override
  Future<ServerSearchPage> searchMessagesOnServer(String chatID, String query, {String? offsetID}) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty || query.trim().isEmpty || !_auth.isAuthorized || _previews.containsKey(chatID)) {
      return const ServerSearchPage.status(ServerSearchStatus.skipped);
    }
    // Вся история уже на устройстве и сверена — локальный поиск полный.
    if (await _sync.historyComplete(chat)) return const ServerSearchPage.status(ServerSearchStatus.skipped);
    if (!await _sync.hasNetwork()) return const ServerSearchPage.status(ServerSearchStatus.offline);
    final pb.Messages_SearchResult result;
    try {
      final response = await _sync.messages(
        pb.Messages_Request(
          search: pb.Messages_Search(
            chatID: chat,
            query: query.trim(),
            offsetID: Int64(int.tryParse(offsetID ?? '') ?? 0),
            limit: _serverSearchLimit,
          ),
        ),
      );
      result = response.search;
    } on ChatsOfflineException {
      return const ServerSearchPage.status(ServerSearchStatus.offline);
    } on ChatsRequestException catch (error) {
      // Сервер без поиска (старая версия) / нет прав — молча локальное.
      _logger.warning('chats: server search failed: $error');
      return const ServerSearchPage.status(ServerSearchStatus.skipped);
    } on ChatsFloodException catch (error) {
      _logger.warning('chats: server search flood: $error');
      return const ServerSearchPage.status(ServerSearchStatus.skipped);
    }
    if (result.status == pb.Messages_SearchResult_Status.QUERY_TOO_SHORT) {
      return const ServerSearchPage.status(ServerSearchStatus.tooShort);
    }
    await _sync.saveSearchHits(chat, result.messages);
    final next = result.nextOffsetID.toInt();
    return ServerSearchPage(
      ids: [for (final m in result.messages) m.messageID.toString()],
      nextOffsetID: next > 0 ? next.toString() : null,
    );
  }

  /// Уже в ленте (обычной — расширить её окно до него) — показать; иначе
  /// (старше скачанного: закреплённое, найденное на сервере, цитата) — окно
  /// вокруг него с сервера ([HistoryWindow], `History.aroundID`), а не
  /// докачка всей истории сверху. Без сети — ничего (лента как есть).
  @override
  Future<void> revealMessage(String chatID, String messageID) async {
    final chat = idBytes(chatID);
    final id = int.tryParse(messageID);
    if (chat.isEmpty || id == null || !_auth.isAuthorized || _previews.containsKey(chatID)) return;
    if (_detached[chatID]?.contains(id) ?? false) return;
    final me = _sync.me;
    if (await _store.inHistory(userID: me, chatID: chat, messageID: id)) {
      final wasDetached = _detached.remove(chatID) != null;
      final needed = await _store.countMessagesFrom(userID: me, chatID: chat, messageID: id) + _windowStep ~/ 2;
      if (needed <= (_windows[chatID] ?? _initialWindow) && !wasDetached) return;
      _windows[chatID] = max(needed, _windows[chatID] ?? _initialWindow);
      _windowChanged.add(chatID);
      return;
    }
    // Без сети — ChatsOfflineException наверх: экран скажет «Нет соединения».
    final page = await _sync.historyPage(chat, aroundID: id, limit: _windowStep);
    final ids = [for (final m in page.messages) m.messageID.toInt()];
    final older = [
      for (final i in ids)
        if (i <= id) i,
    ];
    final range = pageRange(older, hasOlder: page.hasMore);
    final low = range?.from ?? id;
    final high = ids.isEmpty ? id : max(ids.first, id);
    await _placeWindow(
      chatID,
      chat,
      page.messages,
      window: HistoryWindow(low: low, high: high, older: page.hasMore, newer: page.hasNewer),
    );
  }

  /// Новая страница окна [window] ([page] — по убыванию, уже в его
  /// диапазоне): дошло до ленты — слить (всё окно — обычной страницей
  /// истории, окно снимается), иначе — в кэш скрытым из ленты.
  Future<void> _placeWindow(
    String chatID,
    Uint8List chat,
    List<pb.ChatMessage> page, {
    required HistoryWindow window,
    HistoryWindow? previous,
  }) async {
    final me = _sync.me;
    final floor = await _store.historyFloor(userID: me, chatID: chat);
    if (windowJoins(high: window.high, newer: window.newer, floor: floor)) {
      final cached = previous == null
          ? const <pb.ChatMessage>[]
          : await _store.messagesBetween(userID: me, chatID: chat, from: previous.low, to: previous.high);
      final seen = {for (final m in page) m.messageID.toInt()};
      final all = [
        ...page,
        for (final m in cached.reversed)
          if (seen.add(m.messageID.toInt())) m,
      ]..sort((a, b) => b.messageID.compareTo(a.messageID));
      await _sync.joinWindow(chat, all, hasOlder: window.older, reachesTop: !window.newer);
      _detached.remove(chatID);
      final needed = await _store.countMessagesFrom(userID: me, chatID: chat, messageID: window.low) + _windowStep ~/ 2;
      _windows[chatID] = max(needed, _windows[chatID] ?? _initialWindow);
    } else {
      // Диапазон страницы: у первой — всё окно, у страницы новее — от
      // прежнего верха (ниже — уже лежит).
      await _sync.applyWindowPage(chat, page, from: previous == null ? window.low : previous.high + 1, to: window.high);
      _detached[chatID] = window;
    }
    _windowChanged.add(chatID);
  }

  @override
  bool historyDetached(String chatID) => _detached[chatID]?.newer ?? false;

  /// Окно, оторванное от ленты: страница новее его верха (`History.aroundID`
  /// = верх окна, берётся новая половина); дошли до ленты — окно сливается с
  /// ней. Без сети — [ChatsOfflineException].
  @override
  Future<bool> loadNewerMessages(String chatID) async {
    final window = _detached[chatID];
    final chat = idBytes(chatID);
    if (window == null || !window.newer || chat.isEmpty) return false;
    final page = await _sync.historyPage(chat, aroundID: window.high, limit: _windowStep * 2);
    final newer = [
      for (final m in page.messages)
        if (m.messageID.toInt() > window.high) m,
    ];
    final high = newer.isEmpty ? window.high : newer.first.messageID.toInt();
    await _placeWindow(
      chatID,
      chat,
      newer,
      window: window.copyWith(high: high, newer: page.hasNewer),
      previous: window,
    );
    return _detached[chatID]?.newer ?? false;
  }

  /// Кнопка «вниз» в окне «вокруг сообщения» — снова обычная лента.
  @override
  Future<void> showLatestMessages(String chatID) async {
    if (_detached.remove(chatID) != null) _windowChanged.add(chatID);
  }

  @override
  Future<bool> loadOlderMessages(String chatID) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return false;
    if (_previews.containsKey(chatID) && await _store.dialog(userID: _sync.me, chatID: chat) == null) {
      return _loadPreviewHistory(chatID, older: true);
    }
    // Окно «вокруг сообщения» — старше его начала, с сервера.
    final window = _detached[chatID];
    if (window != null) {
      if (!window.older) return false;
      final page = await _sync.historyPage(chat, offsetID: window.low, limit: _windowStep);
      final ids = [for (final m in page.messages) m.messageID.toInt()];
      final range = pageRange(ids, hasOlder: page.hasMore, upper: window.low - 1);
      if (range != null) await _sync.applyWindowPage(chat, page.messages, from: range.from, to: range.to);
      _detached[chatID] = window.copyWith(low: range?.from ?? window.low, older: page.hasMore);
      _windowChanged.add(chatID);
      return page.hasMore;
    }
    final me = _sync.me;
    final shown = _windows[chatID] ?? _initialWindow;
    // В кэше есть старше показанного — просто расширяем окно.
    if (await _store.countMessages(userID: me, chatID: chat) > shown) {
      _windows[chatID] = shown + _windowStep;
      _windowChanged.add(chatID);
      return true;
    }
    final result = await _sync.loadOlder(chat);
    if (result.loaded > 0) {
      _windows[chatID] = shown + result.loaded;
      _windowChanged.add(chatID);
    }
    return result.hasMore;
  }

  Future<List<models.Message>> _loadMessages(String chatID, Uint8List chat) async {
    if (!_auth.isAuthorized || chat.isEmpty) return const [];
    final me = _sync.me;
    final row = await _store.dialog(userID: me, chatID: chat);
    // Диалога в кэше нет (удалён / ещё не пришёл), а окно открыто — всё равно
    // показываем, что есть: историю и неотправленное, иначе отправленное
    // «пропадает» из ленты.
    // Чужая группа по ссылке (не вступили) — то, что прочитали без
    // вступления.
    final preview = row == null ? _previews[chatID] : null;
    if (row == null && preview == null) _logger.warning('chats: open chat ${idHex(chat)} has no local dialog');
    final peer = row?.peerUserID;
    final isSelf = peer != null && sameID(peer, me);
    final peerName = peer == null || isSelf ? '' : _Peers(await _loadPeers([peer])).of(peer).title;
    // Окно «вокруг сообщения» — только оно (и без неотправленного ниже).
    final window = _detached[chatID];
    final history =
        preview?.history ??
        (window != null
            ? await _store.messagesBetween(userID: me, chatID: chat, from: window.low, to: window.high)
            : await _store.messages(userID: me, chatID: chat, limit: _windows[chatID] ?? _initialWindow));
    final byID = {for (final m in history) m.messageID.toInt(): m};
    final pinnedIDs = {for (final m in await _store.pinned(userID: me, chatID: chat)) m.messageID.toInt()};
    final sharedPinnedIDs = await _store.sharedPinnedIDs(userID: me, chatID: chat);
    final pendingReactions = {for (final r in await _store.pendingReactions(userID: me, chatID: chat)) r.messageID: r.emojis};
    // Непрочитанные упоминания меня — отдельно от сообщений (см. chatMentions).
    final mentions = row == null ? const <int>{} : (await _store.unreadMentionIDs(userID: me, chatID: chat)).toSet();
    // Канал (срез 4): постов без автора — людей ленты нет.
    final channel =
        (row != null && row.type == pb.ChatType.CHAT_TYPE_CHANNEL.value) ||
        (preview != null && preview.preview.chat.type == pb.ChatType.CHAT_TYPE_CHANNEL);
    // Ветка комментариев (4.3) — лента как у группы (авторы — люди).
    final thread = row != null && row.type == pb.ChatType.CHAT_TYPE_THREAD.value;
    final group = !channel && (preview != null || (row != null && (row.type == pb.ChatType.CHAT_TYPE_GROUP.value || thread)))
        ? await _groupPeople(history)
        : null;

    models.Message map(pb.ChatMessage m) {
      final message = messageFromPb(
        m,
        chatID: chatID,
        myUserID: me,
        readOutboxMaxID: row?.readOutboxMaxID ?? 0,
        isSelf: isSelf,
        replied: m.content.hasReplyTo() ? byID[m.content.replyTo.messageID.toInt()] : null,
        peerName: peerName,
        nameOf: group == null ? null : (userID) => group.of(userID).title,
        serviceText: !m.content.hasChatAction()
            ? ''
            : (channel
                  ? chatActionText(t, m.content.chatAction, outgoing: false, actor: '', channel: true)
                  : (group != null ? _chatActionText(m, me, group) : '')),
        channel: channel,
        pinned: pinnedIDs.contains(m.messageID.toInt()),
        pinnedOnlyMe: !sharedPinnedIDs.contains(m.messageID.toInt()),
      );
      // Мой набор, ещё не принятый сервером, — поверх серверных.
      final mine = pendingReactions[m.messageID.toInt()];
      final mention = !message.outgoing && mentions.contains(m.messageID.toInt());
      return message.copyWith(
        reactions: mine == null ? message.reactions : applyMyReactions(message.reactions, mine),
        mentionUnread: mention,
      );
    }

    final outboxDir = await outboxMediaDir();
    Future<models.Message> queuedMessage(ChatOutboxRow queued) async {
      final content = pb.MessageContent.fromBuffer(queued.content);
      final message = map(
        pb.ChatMessage(
          chatID: chat,
          fromUserID: channel ? null : me,
          postOut: channel ? true : null,
          date: Int64(queued.createdAt),
          content: content,
          silent: queued.silent,
        ),
      ).copyWith(id: localMessageID(queued.randomID), status: queued.failed ? models.MessageStatus.failed : models.MessageStatus.pending);
      // Пересылаемое — вложения уже на CDN (описания — из кэша исходного).
      return queued.isForward ? _withServerMedia(message, content, chatID) : _withOutboxMedia(message, queued, outboxDir);
    }

    final messages = [for (final m in history) await _withServerMedia(map(m), m.content, chatID, messageID: m.messageID.toInt())];
    // Ветка: пост — шапкой ленты, когда видно её начало.
    if (thread && window == null) {
      final post = await _threadPost(chat);
      final start =
          history.isEmpty ||
          (history.first.messageID.toInt() == await _store.oldestMessageID(userID: me, chatID: chat) && await _sync.historyComplete(chat));
      final header = post == null || !start ? null : await _threadHeader(chatID, post);
      if (header != null) messages.insert(0, header);
    }
    if (window != null) return _withForwardNames(messages);
    final pending = <models.Message>[];
    for (final queued in await _store.outbox(userID: me, chatID: chat)) {
      if (queued.isScheduled) continue;
      final message = await queuedMessage(queued);
      if (!queued.failed) {
        pending.add(message);
        continue;
      }
      // Отклонённое — на своём месте по времени (как в Telegram), а не внизу
      // под всем, что отправили и получили после него. Старше окна истории —
      // не показываем, пока окно не дойдёт.
      if (messages.isNotEmpty && message.date.isBefore(messages.first.date) && history.length >= (_windows[chatID] ?? _initialWindow)) {
        continue;
      }
      final at = messages.indexWhere((m) => m.date.isAfter(message.date));
      messages.insert(at < 0 ? messages.length : at, message);
    }
    // Ещё отправляющиеся — внизу: они новее всего, что есть на сервере.
    return _withForwardNames([...messages, ...pending]);
  }

  /// Люди ленты группы: авторы и те, кого касаются служебные; профили
  /// неизвестных — запросом (лента перечитается, когда придут).
  Future<_Peers> _groupPeople(List<pb.ChatMessage> messages) async {
    final me = _sync.me;
    final people = <String, Uint8List>{};
    for (final m in messages) {
      for (final userID in [m.fromUserID, ...m.content.chatAction.userIDs]) {
        if (userID.isNotEmpty && !sameID(userID, me)) people[idHex(userID)] = Uint8List.fromList(userID);
      }
    }
    final peers = _Peers(await _loadPeers(people.values.toList()));
    _requestProfiles([for (final userID in people.values) (userID: userID, cached: peers.of(userID).profile != null)]);
    return peers;
  }

  // --- вложения ---

  CDNManager get _cdn => _scope.cdn;

  /// Скачанные файлы вложений: cdnID (hex) → путь в кэше.
  final _mediaPaths = <String, String>{};

  /// Скачивания в очереди и идущие: cdnID (hex) → получено / всего байт
  /// шифротекста (0 / 0 — ещё ждёт очереди).
  final _downloads = <String, ({int received, int total})>{};
  final _downloadQueue = <({String key, models.CDN cdn, String chatID, int? messageID})>[];
  var _activeDownloads = 0;
  static const _maxDownloads = 3;

  /// Файлы [keys] (hex cdnID) удалены из кэша («Использование памяти»):
  /// забыть их пути и перечитать окна [chatIDs] — открытый чат скачает
  /// вложения снова.
  void forgetMedia(Set<String> keys, Set<String> chatIDs) {
    for (final key in keys) {
      _mediaPaths.remove(key);
      _downloadFailed.remove(key);
    }
    for (final chatID in chatIDs) {
      _windowChanged.add(chatID);
    }
  }

  /// Неудачные скачивания (нет сети, ошибка CDN): повтор не раньше чем через
  /// [_downloadRetry] — иначе каждое перечитывание ленты дёргало бы сеть.
  final _downloadFailed = <String, DateTime>{};
  static const _downloadRetry = Duration(minutes: 1);

  /// Перечитать ленту чата не чаще раза в 250 мс (прогресс скачивания).
  final _mediaNotify = <String, Timer>{};

  void _notifyMedia(String chatID) {
    _mediaNotify[chatID] ??= Timer(const Duration(milliseconds: 250), () {
      _mediaNotify.remove(chatID);
      _windowChanged.add(chatID);
    });
  }

  /// Путь к скачанному файлу [file]; ещё не скачан — ставит в очередь
  /// (автозагрузка всех вложений открытого чата) и отдаёт пусто. [messageID] —
  /// серверное сообщение с этим файлом: по нему берётся свежая ссылка, если
  /// старая не открывается (null — неотправленная пересылка, без обновления).
  Future<String> _mediaFile(CDN file, String chatID, int? messageID) async {
    if (file.cdnID.isEmpty) return '';
    final key = idHex(file.cdnID);
    final known = _mediaPaths[key];
    if (known != null) return known;
    if (_downloads.containsKey(key)) return '';
    final cached = await _cdn.cachedFile(Uint8List.fromList(file.cdnID));
    if (cached != null) return _mediaPaths[key] = cached.path;
    final failed = _downloadFailed[key];
    if (failed != null && DateTime.now().difference(failed) < _downloadRetry) return '';
    _downloads[key] = (received: 0, total: 0);
    _downloadQueue.add((key: key, cdn: models.CDN.fromProto(file), chatID: chatID, messageID: messageID));
    _pumpDownloads();
    return '';
  }

  void _pumpDownloads() {
    while (_activeDownloads < _maxDownloads && _downloadQueue.isNotEmpty) {
      final job = _downloadQueue.removeAt(0);
      _activeDownloads++;
      unawaited(
        _download(job.key, job.cdn, job.chatID, job.messageID).whenComplete(() {
          _activeDownloads--;
          _pumpDownloads();
        }),
      );
    }
  }

  Future<void> _download(String key, models.CDN cdn, String chatID, int? messageID) async {
    try {
      if (!await _sync.hasNetwork()) throw const ChatsOfflineException();
      final file = await _cdn.download(
        cdn: cdn,
        chatID: chatID,
        onProgress: (received, total) {
          _downloads[key] = (received: received, total: total);
          _notifyMedia(chatID);
        },
        refresh: messageID == null ? null : () => _freshFile(cdn.cdnID, chatID, messageID),
      );
      _mediaPaths[key] = file.path;
      _downloadFailed.remove(key);
    } catch (error, stackTrace) {
      _downloadFailed[key] = DateTime.now();
      if (error is! ChatsOfflineException) _logger.handle(error, stackTrace);
    } finally {
      _downloads.remove(key);
      _notifyMedia(chatID);
    }
  }

  /// Свежее описание файла [cdnID] из сообщения [messageID] (Messages.Get):
  /// ссылка на вложение устарела. Сообщения или файла больше нет — null.
  Future<models.CDN?> _freshFile(Uint8List cdnID, String chatID, int messageID) async {
    final message = await _sync.refreshMessage(idBytes(chatID), messageID);
    if (message == null) return null;
    for (final media in message.content.media) {
      for (final file in [if (media.hasFile()) media.file, if (media.hasThumbFile()) media.thumbFile]) {
        if (sameID(file.cdnID, cdnID)) return models.CDN.fromProto(file);
      }
    }
    return null;
  }

  /// Пути скачанных вложений сообщения с сервера и прогресс скачивания (у
  /// видео, файлов и голосовых — кольцо в пузыре, фото проявляются из
  /// размытого превью).
  Future<models.Message> _withServerMedia(models.Message message, pb.MessageContent content, String chatID, {int? messageID}) async {
    if (content.media.isEmpty) return message;
    final paths = <String>[];
    final thumbs = <String>[];
    var received = 0;
    var total = 0;
    for (final media in content.media) {
      final path = media.hasFile() ? await _mediaFile(media.file, chatID, messageID) : '';
      paths.add(path);
      thumbs.add(media.hasThumbFile() ? await _mediaFile(media.thumbFile, chatID, messageID) : '');
      final progress = media.hasFile() ? _downloads[idHex(media.file.cdnID)] : null;
      if (path.isEmpty && progress != null && message.kind != models.MessageKind.photo) {
        final size = media.size.toInt();
        total += size;
        if (progress.total > 0) received += (size * progress.received / progress.total).round();
      }
    }
    return message.copyWith(
      localPath: paths.first,
      media: [
        for (final (i, item) in message.media.indexed)
          if (i < paths.length) item.copyWith(localPath: paths[i], thumbPath: thumbs[i]) else item,
      ],
      uploadedBytes: total > 0 ? received : 0,
      uploadTotal: total,
    );
  }

  /// Неотправленное: вложения — локальные копии из outbox, прогресс — загрузка
  /// на CDN (ждёт сети — кольцо на нуле, его крестик отменяет отправку).
  models.Message _withOutboxMedia(models.Message message, ChatOutboxRow row, Directory dir) {
    final local = OutboxMedia.decode(row.media);
    if (local.isEmpty) return message;
    final content = pb.MessageContent.fromBuffer(row.content);
    final progress = _sync.uploadProgress(row.randomID);
    final total = progress?.total ?? content.media.fold<int>(0, (sum, m) => sum + m.size.toInt());
    return message.copyWith(
      localPath: outboxFilePath(dir, local.first.path),
      media: [
        for (final (i, item) in message.media.indexed)
          if (i < local.length)
            item.copyWith(localPath: outboxFilePath(dir, local[i].path), thumbPath: outboxFilePath(dir, local[i].thumb))
          else
            item,
      ],
      uploadedBytes: progress?.sent ?? 0,
      // Без размера (0) кольца не будет — хотя бы 1 байт.
      uploadTotal: max(total, 1),
    );
  }

  /// randomID отправки: случайное положительное 63-битное, не 0.
  int _randomID() {
    while (true) {
      final value = (_random.nextInt(1 << 31) << 32) | _random.nextInt(1 << 32);
      if (value != 0) return value;
    }
  }

  /// Текст, фото/видео (альбом), файл, голосовое: в outbox (файлы — копией
  /// в каталог outbox), затем — загрузка вложений и отправка, если есть сеть;
  /// нет — уйдёт при подключении (⏱ в ленте).
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
    final chat = idBytes(chatID);
    if (chat.isEmpty) return;
    // Отправили из окна «вокруг сообщения» — снова обычная лента (с новым).
    unawaited(showLatestMessages(chatID));
    // Опрос — только в группе (в личном сервер откажет); текста у него нет.
    final isPoll = kind == models.MessageKind.poll || poll != null;
    if (isPoll && (poll == null || await _store.group(userID: _sync.me, chatID: chat) == null)) _unsupported('Опросы вне групп');
    final content = isPoll
        ? textContent(text: '', reply: reply)
        : textContent(text: text, entities: entities, reply: reply, linkPreview: linkPreview);
    if (isPoll) content.poll = pollToPb(poll!);
    final local = <OutboxMedia>[];
    switch (isPoll ? models.MessageKind.poll : kind) {
      case models.MessageKind.text:
        if (text.isEmpty) return;
      case models.MessageKind.photo || models.MessageKind.video:
        final items = media.isNotEmpty ? media : [models.MessageMedia(kind: kind, localPath: localPath)];
        for (final item in items) {
          if (item.localPath.isEmpty) continue;
          final video = item.kind == models.MessageKind.video;
          content.media.add(
            pb.MessageMedia(
              kind: video ? pb.MessageKind.MESSAGE_KIND_VIDEO : pb.MessageKind.MESSAGE_KIND_PHOTO,
              width: item.width,
              height: item.height,
              size: Int64(item.size > 0 ? item.size : await File(item.localPath).length()),
              thumbhash: item.thumbhash,
              spoiler: item.spoiler,
              duration: item.duration,
              fileName: p.basename(item.localPath),
              mimeType: chatMediaContentType(item.localPath),
            ),
          );
          local.add(OutboxMedia(path: await stashOutboxFile(item.localPath), thumb: video ? await stashOutboxFile(item.thumbPath) : ''));
        }
      case models.MessageKind.file || models.MessageKind.voice:
        if (localPath.isEmpty) return;
        final voice = kind == models.MessageKind.voice;
        content.media.add(
          pb.MessageMedia(
            kind: voice ? pb.MessageKind.MESSAGE_KIND_VOICE : pb.MessageKind.MESSAGE_KIND_FILE,
            size: Int64(await File(localPath).length()),
            duration: duration,
            fileName: fileName.isNotEmpty ? fileName : p.basename(localPath),
            mimeType: chatMediaContentType(localPath),
            waveform: voice ? waveformToPb(waveform) : null,
          ),
        );
        local.add(OutboxMedia(path: await stashOutboxFile(localPath)));
      case models.MessageKind.poll:
        break;
      // Звонок пишет только сервер.
      case models.MessageKind.call:
        return;
    }
    if (kind != models.MessageKind.text && !isPoll && local.isEmpty) return;
    // Подпись к медиа — без превью ссылки.
    if (local.isNotEmpty) content.clearNoLinkPreview();
    await _store.addOutbox(
      userID: _sync.me,
      randomID: _randomID(),
      chatID: chat,
      content: content.writeToBuffer(),
      silent: silent,
      media: OutboxMedia.encode(local),
      // Отложенное ждёт в outbox, только пока сервер его не принял.
      scheduleDate: scheduleDate?.millisecondsSinceEpoch ?? 0,
    );
    unawaited(_sync.flushOutbox());
  }

  /// Голос — на сервере (без сети [ChatsOfflineException], без
  /// «оптимистичного» выбора); итоги глазами меня — сразу в кэш.
  @override
  Future<void> votePoll(String chatID, String messageID, List<int> options) async {
    final id = serverMessageID(messageID);
    if (id == null) return;
    await _requireNetwork();
    final chat = idBytes(chatID);
    final response = await _sync.messages(
      pb.Messages_Request(
        votePoll: pb.Messages_VotePoll(chatID: chat, messageID: Int64(id), options: options),
      ),
    );
    final result = response.votePoll;
    await _sync.applyUpdates(result.updates);
    if (result.hasResults()) await _sync.savePollResults(chat, id, result.results);
  }

  /// Автор / владелец / админ с правом удалять сообщения (иначе отказ).
  @override
  Future<void> closePoll(String chatID, String messageID) async {
    final id = serverMessageID(messageID);
    if (id == null) return;
    await _requireNetwork();
    final chat = idBytes(chatID);
    final response = await _sync.messages(
      pb.Messages_Request(
        closePoll: pb.Messages_ClosePoll(chatID: chat, messageID: Int64(id)),
      ),
    );
    final result = response.closePoll;
    await _sync.applyUpdates(result.updates);
    if (result.hasResults()) await _sync.savePollResults(chat, id, result.results);
  }

  /// Сколько голосов читать за раз и сколько страниц максимум.
  static const _votersPage = 100;
  static const _votersPages = 10;

  /// «Кто за что» — с сервера (`Messages.PollVoters`, все варианты сразу):
  /// имена по общему правилу, мы — «Вы». Без сети — [ChatsOfflineException];
  /// анонимный — отказ сервера.
  @override
  Future<models.MessagePoll?> pollVoters(String chatID, String messageID) async {
    final id = serverMessageID(messageID);
    final chat = idBytes(chatID);
    if (id == null || chat.isEmpty) return null;
    final me = _sync.me;
    final cached = await _store.message(userID: me, chatID: chat, messageID: id);
    if (cached == null || !cached.content.hasPoll()) return null;
    await _requireNetwork();
    final voters = <pb.Messages_PollVoter>[];
    var offset = <int>[];
    for (var page = 0; page < _votersPages; page++) {
      final response = await _sync.messages(
        pb.Messages_Request(
          pollVoters: pb.Messages_PollVoters(
            chatID: chat,
            messageID: Int64(id),
            option: -1,
            offset: offset.isEmpty ? null : offset,
            limit: _votersPage,
          ),
        ),
      );
      voters.addAll(response.pollVoters.voters);
      offset = response.pollVoters.nextOffset;
      if (offset.isEmpty) break;
    }
    final peers = _Peers(await _loadPeers([for (final v in voters) Uint8List.fromList(v.userID)]));
    _requestProfiles([
      for (final v in voters)
        if (!sameID(v.userID, me)) (userID: Uint8List.fromList(v.userID), cached: peers.of(v.userID).profile != null),
    ]);
    final poll = pollFromPb(cached.content.poll, cached.hasPoll() ? cached.poll : null);
    String name(List<int> userID) => sameID(userID, me) ? pollVoterSelf : peers.of(userID).title;
    return poll.copyWith(
      options: [
        for (final (i, option) in poll.options.indexed)
          option.copyWith(
            voters: [
              for (final v in voters)
                if (v.options.contains(i)) name(v.userID),
            ],
          ),
      ],
    );
  }

  /// Сколько реакций в странице «Кто поставил реакцию».
  static const _reactionsPage = 50;

  /// «Кто поставил реакцию» (`Messages.ReactionsList`, курсор — непрозрачный,
  /// base64); имена — по общему правилу, неизвестные профили подтянутся.
  @override
  Future<ReactionsListPage> reactionsList(String chatID, String messageID, {String emoji = '', String cursor = ''}) async {
    final id = serverMessageID(messageID);
    final chat = idBytes(chatID);
    if (id == null || chat.isEmpty) return const ReactionsListPage(reactors: []);
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        reactionsList: pb.Messages_ReactionsList(
          chatID: chat,
          messageID: Int64(id),
          emoji: emoji,
          offset: cursor.isEmpty ? null : base64Decode(cursor),
          limit: _reactionsPage,
        ),
      ),
    );
    final result = response.reactionsList;
    final me = _sync.me;
    final peers = _Peers(await _loadPeers([for (final r in result.reactions) Uint8List.fromList(r.userID)]));
    _requestProfiles([
      for (final r in result.reactions)
        if (!sameID(r.userID, me)) (userID: Uint8List.fromList(r.userID), cached: peers.of(r.userID).profile != null),
    ]);
    return ReactionsListPage(
      reactors: [
        for (final r in result.reactions)
          MessageReactor(
            userID: idHex(r.userID),
            name: sameID(r.userID, me) ? t.screenChat.you : peers.of(r.userID).title,
            emoji: r.emoji,
            date: DateTime.fromMillisecondsSinceEpoch(r.date.toInt()),
            isSelf: sameID(r.userID, me),
          ),
      ],
      nextCursor: result.nextOffset.isEmpty ? '' : base64Encode(result.nextOffset),
    );
  }

  // --- просмотры постов канала (подэтап 4.2) ---

  /// Очереди просмотров по каналам (hex id): живут дольше окна канала —
  /// накопленное без сети уходит после подключения.
  final _channelViews = <String, ChannelViews>{};

  /// Просмотры постов канала [chatID] (см. [ChannelViews]).
  ChannelViews channelViews(String chatID) => _channelViews.putIfAbsent(chatID, () {
    final chat = idBytes(chatID);
    return ChannelViews(
      fetch: (ids, {required increment}) => _getViews(chat, ids, increment: increment),
      viewed: (ids) => _store.viewedIDs(userID: _sync.me, chatID: chat, messageIDs: ids),
      markViewed: (ids) => _store.markViewed(userID: _sync.me, chatID: chat, messageIDs: ids),
    );
  });

  /// `Messages.GetViews`: числа — в кэш (лента перерисуется). Нет сети или
  /// не авторизованы — `null` (повторить позже).
  Future<Map<int, int>?> _getViews(Uint8List chat, List<int> ids, {required bool increment}) async {
    if (!_auth.isAuthorized || !await _sync.hasNetwork()) return null;
    final pb.Messages_Response response;
    try {
      response = await _sync.messages(
        pb.Messages_Request(
          getViews: pb.Messages_GetViews(chatID: chat, messageIDs: [for (final id in ids) Int64(id)], increment: increment),
        ),
      );
    } on ChatsOfflineException {
      return null;
    }
    final views = {for (final v in response.getViews.views) v.messageID.toInt(): v.views};
    await _store.setViews(userID: _sync.me, chatID: chat, views: views);
    // Свежие комментарии видимых постов (4.3) — с моим readMaxID.
    await _sync.savePostComments(chat, {
      for (final v in response.getViews.views)
        if (v.hasComments()) v.messageID.toInt(): v.comments,
    });
    return views;
  }

  // --- отложенные ---

  /// Принятые сервером (кэш, при подписке — свежий список с сервера) и ещё
  /// ждущие в outbox (без сети) — по времени отправки.
  @override
  Stream<List<models.Message>> watchScheduled(String chatID) {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return Stream.value(const []);
    // Чужая группа по ссылке и канал без подписки (4.4) — отложенных у нас
    // там нет.
    if (!_previews.containsKey(chatID)) {
      unawaited(
        _sync.isBrowsing(chat).then((browsing) async {
          if (!browsing) await _sync.loadScheduled(chat);
        }, onError: (Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)),
      );
    }
    return _repositories.db
        .onChange(const [ChatsRepository.scheduledTable, ChatsRepository.outboxTable])
        .asyncMap((_) => _loadScheduled(chatID, chat))
        .distinct(listEquals);
  }

  Future<List<models.Message>> _loadScheduled(String chatID, Uint8List chat) async {
    if (!_auth.isAuthorized) return const [];
    final me = _sync.me;
    final row = await _store.dialog(userID: me, chatID: chat);
    final peer = row?.peerUserID;
    final isSelf = peer != null && sameID(peer, me);
    final peerName = peer == null || isSelf ? '' : _Peers(await _loadPeers([peer])).of(peer).title;

    Future<models.Message> map(pb.MessageContent content, {required int date, required bool silent}) async {
      final replied = content.hasReplyTo()
          ? await _store.message(userID: me, chatID: chat, messageID: content.replyTo.messageID.toInt())
          : null;
      return messageFromPb(
        pb.ChatMessage(chatID: chat, fromUserID: me, date: Int64(date), content: content, silent: silent),
        chatID: chatID,
        myUserID: me,
        readOutboxMaxID: 0,
        isSelf: isSelf,
        replied: replied,
        peerName: peerName,
      ).copyWith(scheduledDate: DateTime.fromMillisecondsSinceEpoch(date), status: models.MessageStatus.pending);
    }

    final result = <models.Message>[
      for (final scheduled in await _store.scheduled(userID: me, chatID: chat))
        (await map(
          scheduled.content,
          date: scheduled.date.toInt(),
          silent: scheduled.silent,
        )).copyWith(id: scheduledMessageID(scheduled.scheduledID.toInt())),
      for (final queued in await _store.outbox(userID: me, chatID: chat))
        if (queued.isScheduled)
          (await map(pb.MessageContent.fromBuffer(queued.content), date: queued.scheduleDate, silent: queued.silent)).copyWith(
            id: localMessageID(queued.randomID),
            status: queued.failed ? models.MessageStatus.failed : models.MessageStatus.pending,
          ),
    ];
    result.sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));
    return _withForwardNames(result);
  }

  /// Ещё не принятое сервером (в outbox) меняется локально и без сети;
  /// принятое — на сервере, результат приходит обновлениями.
  @override
  Future<void> sendScheduledNow(String chatID, String messageID) async {
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) {
      // Станет обычным неотправленным — уйдёт с outbox.
      await _store.setOutboxScheduleDate(userID: _sync.me, randomID: randomID, scheduleDate: 0);
      unawaited(_sync.flushOutbox());
      return;
    }
    final scheduledID = scheduledIDOf(messageID);
    if (scheduledID == null) return;
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        sendScheduledNow: pb.Messages_SendScheduledNow(chatID: idBytes(chatID), scheduledIDs: [Int64(scheduledID)]),
      ),
    );
    await _sync.applyUpdates(response.sendScheduledNow.updates);
  }

  @override
  Future<void> rescheduleMessage(String chatID, String messageID, DateTime date) async {
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) {
      await _store.setOutboxScheduleDate(userID: _sync.me, randomID: randomID, scheduleDate: date.millisecondsSinceEpoch);
      unawaited(_sync.flushOutbox());
      return;
    }
    final scheduledID = scheduledIDOf(messageID);
    if (scheduledID == null) return;
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        reschedule: pb.Messages_Reschedule(
          chatID: idBytes(chatID),
          scheduledID: Int64(scheduledID),
          date: Int64(date.millisecondsSinceEpoch),
        ),
      ),
    );
    await _sync.applyUpdates(response.reschedule.updates);
  }

  @override
  Future<void> deleteScheduled(String chatID, String messageID) async {
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) {
      await _store.deleteOutbox(userID: _sync.me, randomID: randomID);
      return;
    }
    final scheduledID = scheduledIDOf(messageID);
    if (scheduledID == null) return;
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        deleteScheduled: pb.Messages_DeleteScheduled(chatID: idBytes(chatID), scheduledIDs: [Int64(scheduledID)]),
      ),
    );
    await _sync.applyUpdates(response.deleteScheduled.updates);
  }

  /// Неотправленное правится прямо в outbox (уйдёт уже исправленным);
  /// отправленное — на сервере.
  @override
  Future<void> editMessage(
    String chatID,
    String messageID,
    String text,
    List<models.MessageEntity> entities, {
    models.EditMedia? media,
    void Function(int sent, int total)? onUpload,
    bool Function()? isCancelled,
  }) async {
    if (media != null && !media.isEmpty) {
      return _editWithMedia(chatID, messageID, text, entities, media, onUpload: onUpload, isCancelled: isCancelled);
    }
    final me = _sync.me;
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) {
      final queued = await _store.outboxByRandomID(userID: me, randomID: randomID);
      if (queued == null) return;
      final content = pb.MessageContent.fromBuffer(queued.content)
        ..text = text
        ..entities.clear()
        ..entities.addAll([for (final e in entities) entityToPb(e)]);
      await _store.updateOutboxContent(userID: me, randomID: randomID, content: content.writeToBuffer());
      return;
    }
    final id = serverMessageID(messageID);
    if (id == null) return;
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        edit: pb.Messages_Edit(
          chatID: idBytes(chatID),
          messageID: Int64(id),
          text: text,
          entities: [for (final e in entities) entityToPb(e)],
        ),
      ),
    );
    await _sync.applyUpdates(response.edit.updates);
  }

  /// Правка с заменой / добавлением вложений: только для принятого сервером
  /// и только с сетью (проверка — до загрузки, без «оптимистичного» пузыря).
  /// Новые файлы — на CDN, как вложения при отправке (обложка видео — тоже;
  /// загруженное ложится в кэш скачиваний под своим cdnID), затем
  /// `Edit {replaceMedia, media}` со всем итоговым списком; пузырь меняет
  /// пришедшее обновление `editMessage`.
  Future<void> _editWithMedia(
    String chatID,
    String messageID,
    String text,
    List<models.MessageEntity> entities,
    models.EditMedia draft, {
    void Function(int sent, int total)? onUpload,
    bool Function()? isCancelled,
  }) async {
    final id = serverMessageID(messageID);
    if (id == null) throw const ChatsRequestException(editMediaInvalid, StatusCode.invalidArgument);
    final chat = idBytes(chatID);
    late pb.Messages_Response response;
    await editMessageMedia(
      edit: pb.Messages_Edit(chatID: chat, messageID: Int64(id), text: text, entities: [for (final e in entities) entityToPb(e)]),
      draft: draft,
      hasNetwork: _sync.hasNetwork,
      original: () async => (await _store.message(userID: _sync.me, chatID: chat, messageID: id))?.content,
      upload: (file, onProgress) async => (await _cdn.uploadFile(
        file: file,
        folder: chatMediaFolder,
        contentType: chatMediaContentType(file.path),
        chatID: chatID,
        isCancelled: isCancelled,
        onProgress: onProgress,
      )).cdnID,
      send: (edit) async => response = await _sync.messages(pb.Messages_Request(edit: edit)),
      onUpload: onUpload,
      isCancelled: isCancelled,
    );
    await _sync.applyUpdates(response.edit.updates);
  }

  /// Неотправленное — убрать из outbox (и остановить загрузку вложений);
  /// отправленное — на сервере.
  @override
  Future<void> deleteMessage(String chatID, String messageID, {bool forEveryone = true}) async {
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) {
      await _sync.cancelUpload(randomID);
      return;
    }
    final id = serverMessageID(messageID);
    if (id == null) return;
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        delete: pb.Messages_Delete(chatID: idBytes(chatID), messageIDs: [Int64(id)], forEveryone: forEveryone),
      ),
    );
    await _sync.applyUpdates(response.delete.updates);
  }

  @override
  Future<void> setMessagePinned(String chatID, String messageID, bool pinned, {bool forEveryone = true}) async {
    final id = serverMessageID(messageID);
    if (id == null) return;
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        pin: pb.Messages_Pin(chatID: idBytes(chatID), messageID: Int64(id), pinned: pinned, forEveryone: forEveryone),
      ),
    );
    await _sync.applyUpdates(response.pin.updates);
  }

  @override
  Future<void> unpinAllMessages(String chatID, {bool forEveryone = true}) async {
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        unpinAll: pb.Messages_UnpinAll(chatID: idBytes(chatID), forEveryone: forEveryone),
      ),
    );
    await _sync.applyUpdates(response.unpinAll.updates);
  }

  /// Из кэша закреплённых ([ChatsRepository.pinned]); при подписке — свежий
  /// список с сервера (нет сети — показываем кэш).
  @override
  Stream<List<models.Message>> watchPinnedMessages(String chatID) {
    final chat = idBytes(chatID);
    // Чужая группа по ссылке и канал без подписки (4.4) — закреплённых не
    // спрашиваем (не участник).
    if (chat.isNotEmpty && !_previews.containsKey(chatID)) {
      unawaited(
        _sync
            .isBrowsing(chat)
            .then((browsing) async {
              if (!browsing) await _sync.loadPinned(chat);
            })
            .catchError((Object error, StackTrace stackTrace) {
              if (error is! ChatsOfflineException) _logger.handle(error, stackTrace);
            }),
      );
    }
    late final StreamController<List<models.Message>> out;
    StreamSubscription<void>? changes;
    StreamSubscription<String>? refresh;
    var pending = Future<void>.value();
    void reload() {
      pending = pending
          .then((_) async {
            final pinned = await _loadPinned(chatID, chat);
            if (!out.isClosed) out.add(pinned);
          })
          .catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace));
    }

    out = StreamController<List<models.Message>>(
      onListen: () {
        changes = _repositories.db.onChange([ChatsRepository.pinnedTable, ChatsRepository.dialogsTable]).listen((_) => reload());
        // Скачалось превью вложения закреплённого.
        refresh = _windowChanged.stream.where((id) => id == chatID).listen((_) => reload());
      },
      onCancel: () async {
        await changes?.cancel();
        await refresh?.cancel();
      },
    );
    return out.stream;
  }

  Future<List<models.Message>> _loadPinned(String chatID, Uint8List chat) async {
    if (!_auth.isAuthorized || chat.isEmpty) return const [];
    final me = _sync.me;
    final row = await _store.dialog(userID: me, chatID: chat);
    final peer = row?.peerUserID;
    final isSelf = peer != null && sameID(peer, me);
    final peerName = peer == null || isSelf ? '' : _Peers(await _loadPeers([peer])).of(peer).title;
    final sharedIDs = await _store.sharedPinnedIDs(userID: me, chatID: chat);
    final pinned = await _store.pinned(userID: me, chatID: chat);
    final group = row != null && (row.type == pb.ChatType.CHAT_TYPE_GROUP.value || row.type == pb.ChatType.CHAT_TYPE_THREAD.value)
        ? await _groupPeople(pinned)
        : null;
    final channel = row != null && row.type == pb.ChatType.CHAT_TYPE_CHANNEL.value;
    return [
      for (final m in pinned)
        await _withServerMedia(
          messageFromPb(
            m,
            chatID: chatID,
            myUserID: me,
            readOutboxMaxID: row?.readOutboxMaxID ?? 0,
            isSelf: isSelf,
            peerName: peerName,
            nameOf: group == null ? null : (userID) => group.of(userID).title,
            channel: channel,
            pinned: true,
            pinnedOnlyMe: !sharedIDs.contains(m.messageID.toInt()),
          ),
          m.content,
          chatID,
          messageID: m.messageID.toInt(),
        ),
    ];
  }

  /// «Переслано от» по общему правилу имени: автор оригинала у меня в
  /// контактах — моё имя для него; иначе имя, записанное сервером при
  /// пересылке (без него — из кэша профиля: превью ещё не отправленного).
  Future<List<models.Message>> _withForwardNames(List<models.Message> messages) async {
    final ids = <String>{
      for (final m in messages)
        if (m.forward case final f? when f.userID.isNotEmpty && !f.self) f.userID,
    };
    if (ids.isEmpty) return messages;
    final peers = _Peers(await _loadPeers([for (final id in ids) idBytes(id)]));
    return [
      for (final m in messages)
        if (m.forward case final f? when f.userID.isNotEmpty && !f.self)
          () {
            final info = peers.of(idBytes(f.userID));
            final name = info.hasContactName || f.name.isEmpty ? info.title : f.name;
            return name == f.name || name.isEmpty ? m : m.copyWith(forward: f.copyWith(name: name));
          }()
        else
          m,
    ];
  }

  /// Пересылка: каждое — отдельной отправкой через outbox (сразу или при
  /// подключении, ⏱ в ленте). На сервер уходит ссылка на исходное
  /// (`Messages.Send.forwardFrom`) — содержимое он берёт сам; в outbox —
  /// только превью для ленты: копия из кэша без ответа, с «Переслано от».
  /// Чего нет в кэше / ещё не на сервере — пропускаем.
  @override
  Future<void> forwardMessages(String toChatID, List<models.Message> messages) async {
    final to = idBytes(toChatID);
    if (to.isEmpty || !_auth.isAuthorized) return;
    unawaited(showLatestMessages(toChatID));
    final me = _sync.me;
    // Порядок outbox — по createdAt: у пачки он должен строго расти.
    final now = DateTime.now().millisecondsSinceEpoch;
    var added = 0;
    for (final m in messages) {
      final from = idBytes(m.chatID);
      final id = serverMessageID(m.id);
      if (from.isEmpty || id == null) continue;
      final source = await _store.message(userID: me, chatID: from, messageID: id);
      if (source == null) continue;
      final content = pb.MessageContent.fromBuffer(source.content.writeToBuffer())..clearReplyTo();
      if (!content.hasForward()) {
        // Пост канала (4.2) — «Переслано из» канала с подписью автора.
        final channel = (await _store.dialog(userID: me, chatID: from))?.type == pb.ChatType.CHAT_TYPE_CHANNEL.value;
        content.forward = channel
            ? pb.MessageForward(
                fromChatID: from,
                fromMessageID: Int64(id),
                fromSignature: source.authorSignature,
                fromName: m.forward?.name ?? '',
                // Публичное имя (4.4): не подписанный откроет канал по нему
                // (сервер всё равно ставит своё — на момент пересылки).
                fromUsername: (await _store.group(userID: me, chatID: from))?.info.username ?? '',
                date: source.date,
              )
            : pb.MessageForward(fromUserID: source.fromUserID, fromName: m.forward?.name ?? '', date: source.date);
      }
      await _store.addOutbox(
        userID: me,
        randomID: _randomID(),
        chatID: to,
        content: content.writeToBuffer(),
        forwardChatID: from,
        forwardMessageID: id,
        createdAt: now + added,
      );
      added++;
    }
    if (added > 0) unawaited(_sync.flushOutbox());
  }

  /// Отклонённое сервером ([models.MessageStatus.failed]) — снова в очередь.
  @override
  Future<void> retrySend(String chatID, String messageID) async {
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) await _sync.retryOutbox(randomID);
  }

  /// Крестик на кольце: у неотправленного — отменить загрузку и отправку. У
  /// полученного кольцо — скачивание, его не прерываем (файл всё равно нужен
  /// для показа).
  @override
  Future<void> cancelUpload(String chatID, String messageID) async {
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) await _sync.cancelUpload(randomID);
  }

  /// Мой новый набор реакций: сразу в очередь (лента показывает его поверх
  /// серверных), на сервер — сейчас или при подключении, как outbox. Без сети
  /// не ошибка: реакция честно ждёт, а не «прыгает» обратно.
  @override
  Future<void> setReactions(String chatID, String messageID, List<String> emojis) async {
    final chat = idBytes(chatID);
    final id = serverMessageID(messageID);
    // Неотправленное (⏱) — реакции некуда ставить, пока сервер его не принял.
    if (chat.isEmpty || id == null || !_auth.isAuthorized) return;
    await _store.setPendingReactions(userID: _sync.me, chatID: chat, messageID: id, emojis: emojis);
    unawaited(_sync.flushReactions());
  }

  /// Личный чат: когда собеседник прочитал (сервер, ≤ 7 дней). Группа — кто
  /// прочитал (`Messages.ReadParticipants`, ≤ 100 участников).
  @override
  Future<MessageReadInfo> readInfo(String chatID, String messageID) async {
    final id = serverMessageID(messageID);
    if (id == null) return const MessageReadInfo(MessageReadStatus.notRead);
    // «Избранное» — читать некому (сервер отвечает только по личным не-self).
    final row = await _store.dialog(userID: _sync.me, chatID: idBytes(chatID));
    final peer = row?.peerUserID;
    if (peer != null && sameID(peer, _sync.me)) return const MessageReadInfo(MessageReadStatus.unavailable);
    if (row != null && row.type == pb.ChatType.CHAT_TYPE_GROUP.value) return _groupReaders(idBytes(chatID), id);
    if (row != null && row.type != pb.ChatType.CHAT_TYPE_PRIVATE.value) return const MessageReadInfo(MessageReadStatus.unavailable);
    await _requireNetwork();
    final response = await _sync.chats(
      pb.Chats_Request(
        readDate: pb.Chats_ReadDate(chatID: idBytes(chatID), messageID: Int64(id)),
      ),
    );
    final result = response.readDate;
    return switch (result.status) {
      pb.Chats_ReadDateResult_Status.READ => MessageReadInfo(
        MessageReadStatus.read,
        date: result.date > 0 ? DateTime.fromMillisecondsSinceEpoch(result.date.toInt()) : null,
      ),
      pb.Chats_ReadDateResult_Status.NOT_READ => const MessageReadInfo(MessageReadStatus.notRead),
      pb.Chats_ReadDateResult_Status.HIDDEN => const MessageReadInfo(MessageReadStatus.hidden),
      _ => const MessageReadInfo(MessageReadStatus.unavailable),
    };
  }

  /// «Кто прочитал» в группе: от последних к первым, имена — по общему
  /// правилу, реакция — первая его.
  Future<MessageReadInfo> _groupReaders(Uint8List chat, int messageID) async {
    await _requireNetwork();
    final response = await _sync.messages(
      pb.Messages_Request(
        readParticipants: pb.Messages_ReadParticipants(chatID: chat, messageID: Int64(messageID)),
      ),
    );
    final result = response.readParticipants;
    switch (result.status) {
      case pb.Messages_ReadParticipantsResult_Status.NOT_READ:
        return const MessageReadInfo(MessageReadStatus.notRead);
      case pb.Messages_ReadParticipantsResult_Status.READ:
        break;
      default:
        return const MessageReadInfo(MessageReadStatus.unavailable);
    }
    if (result.readers.isEmpty) return const MessageReadInfo(MessageReadStatus.notRead);
    final peers = _Peers(await _loadPeers([for (final r in result.readers) Uint8List.fromList(r.userID)]));
    _requestProfiles([for (final r in result.readers) (userID: Uint8List.fromList(r.userID), cached: peers.of(r.userID).profile != null)]);
    return MessageReadInfo(
      MessageReadStatus.read,
      readers: [
        for (final r in result.readers)
          MessageReader(
            userID: idHex(r.userID),
            name: peers.of(r.userID).title,
            date: DateTime.fromMillisecondsSinceEpoch(r.date.toInt()),
            reaction: r.reaction,
          ),
      ],
    );
  }

  /// «Прослушано» — фоновое (началось проигрывание): сейчас или при
  /// подключении; точка снимется ответом сервера, а не заранее.
  @override
  Future<void> readMessageContents(String chatID, String messageID) async {
    final id = serverMessageID(messageID);
    final chat = idBytes(chatID);
    if (id == null || chat.isEmpty || !_auth.isAuthorized) return;
    try {
      await _sync.readContents(chat, [id]);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Реакции увидели — фоновое, как «прослушано»: без сети молча пропускаем,
  /// отметка останется до следующего показа (бейдж не «прыгает» обратно).
  @override
  Future<void> readReactions(String chatID, List<String> messageIDs) async {
    final ids = [for (final id in messageIDs.map(serverMessageID)) ?id];
    if (ids.isEmpty || !_auth.isAuthorized) return;
    try {
      if (!await _sync.hasNetwork()) return;
      final response = await _sync.messages(
        pb.Messages_Request(
          readReactions: pb.Messages_ReadReactions(chatID: idBytes(chatID), messageIDs: [for (final id in ids) Int64(id)]),
        ),
      );
      await _sync.applyUpdates(response.readReactions.updates);
    } on ChatsOfflineException {
      // Отметим в следующий раз.
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Пустой список id — сервер снимает со всех. Ничего не снял — счётчик в
  /// кэше устарел, обнуляем сами.
  @override
  Future<void> readAllReactions(String chatID) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return;
    await _requireNetwork();
    final response = await _sync.messages(pb.Messages_Request(readReactions: pb.Messages_ReadReactions(chatID: chat)));
    final updates = response.readReactions.updates;
    if (updates.updates.isNotEmpty) return _sync.applyUpdates(updates);
    final ids = await _store.unreadReactionIDs(userID: _sync.me, chatID: chat);
    await _store.readReactions(userID: _sync.me, chatID: chat, messageIDs: ids);
    await _store.updateDialog(userID: _sync.me, chatID: chat, fields: {'unreadReactions': 0});
  }

  /// С сервера (старых сообщений может не быть в кэше), без сети — из кэша.
  /// Сервер ответил «нет» — счётчик в кэше устарел, обнуляем.
  @override
  Future<String?> nextUnreadReaction(String chatID) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return null;
    try {
      if (await _sync.hasNetwork()) {
        final response = await _sync.messages(pb.Messages_Request(unreadReactions: pb.Messages_UnreadReactions(chatID: chat, limit: 1)));
        final messages = response.unreadReactions.messages;
        if (messages.isNotEmpty) return messages.first.messageID.toString();
        await _store.updateDialog(userID: _sync.me, chatID: chat, fields: {'unreadReactions': 0});
        return null;
      }
    } on ChatsOfflineException {
      // Ниже — из кэша.
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
    final ids = await _store.unreadReactionIDs(userID: _sync.me, chatID: chat);
    return ids.isEmpty ? null : ids.first.toString();
  }

  /// Кнопка «@»: самое старое непрочитанное упоминание меня — с сервера
  /// (старого может не быть в кэше), без сети — из кэша. Сервер ответил «нет»
  /// — счётчик в кэше устарел, обнуляем.
  @override
  Future<String?> nextUnreadMention(String chatID) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return null;
    final me = _sync.me;
    try {
      if (await _sync.hasNetwork()) {
        final response = await _sync.messages(pb.Messages_Request(unreadMentions: pb.Messages_UnreadMentions(chatID: chat, limit: 1)));
        final messages = response.unreadMentions.messages;
        if (messages.isNotEmpty) return messages.first.messageID.toString();
        await _store.transaction((tx) async {
          await tx.removeMentions(userID: me, chatID: chat);
          await tx.updateDialog(userID: me, chatID: chat, fields: {'unreadMentions': 0});
        });
        return null;
      }
    } on ChatsOfflineException {
      // Ниже — из кэша.
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
    final ids = await _store.unreadMentionIDs(userID: me, chatID: chat);
    return ids.isEmpty ? null : ids.first.toString();
  }

  /// Упоминания увидели — фоновое, как [readReactions]: без сети молча
  /// пропускаем (отметка останется до следующего показа). Пустой список —
  /// все в чате; сервер ничего не снял — кэш устарел, снимаем сами.
  @override
  Future<void> readMentions(String chatID, List<String> messageIDs) async {
    final chat = idBytes(chatID);
    final ids = [for (final id in messageIDs.map(serverMessageID)) ?id];
    if (chat.isEmpty || (messageIDs.isNotEmpty && ids.isEmpty) || !_auth.isAuthorized) return;
    try {
      if (!await _sync.hasNetwork()) return;
      final response = await _sync.messages(
        pb.Messages_Request(
          readMentions: pb.Messages_ReadMentions(chatID: chat, messageIDs: [for (final id in ids) Int64(id)]),
        ),
      );
      final updates = response.readMentions.updates;
      if (updates.updates.isNotEmpty) {
        await _sync.applyUpdates(updates);
        return;
      }
      final me = _sync.me;
      await _store.transaction((tx) async {
        await tx.removeMentions(userID: me, chatID: chat, messageIDs: ids.isEmpty ? null : ids);
        if (ids.isEmpty) await tx.updateDialog(userID: me, chatID: chat, fields: {'unreadMentions': 0});
      });
    } on ChatsOfflineException {
      // Отметим в следующий раз.
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Черновик — сразу локально (виден и без сети) и на сервер — на мои
  /// остальные устройства; без сети уйдёт при подключении.
  @override
  Future<void> setDraft(String chatID, String draft) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return;
    if (await _store.setDraft(userID: _sync.me, chatID: chat, draft: draft)) unawaited(_sync.flushDrafts());
  }
}

/// Чужая группа, открытая по ссылке ([ChatsRemoteDataSource.resolveLink]):
/// [path] — та же ссылка для `JoinChat`; [history] — прочитанное без
/// вступления (публичная), от старых к новым.
class _Preview {
  /// Чей предпросмотр (hex userID) — после смены аккаунта не показываем.
  final String owner;
  final String path;
  final pb.ChatPreview preview;
  bool requested;
  List<pb.ChatMessage> history = const [];
  bool hasMore = true;

  _Preview({required this.owner, required this.path, required this.preview}) : requested = preview.requested;
}

class _PeerInfo {
  final String title;
  final bool isContact;

  /// [title] — имя контакта («как я его записал»).
  final bool hasContactName;
  final models.Profile? profile;

  const _PeerInfo({required this.title, required this.isContact, this.hasContactName = false, required this.profile});
}

class _Peers {
  final Map<String, _PeerInfo> byID;

  const _Peers(this.byID);

  _PeerInfo of(List<int> userID) => byID[idHex(userID)] ?? const _PeerInfo(title: '', isContact: false, profile: null);
}

/// Источник чатов для экранов: демо (фейковые данные), настоящие чаты — только
/// при включённом фича-флаге «Серверные чаты» ([ChatsSync.enabled]), иначе
/// `null` (вкладка пуста).
ChatsDataSource? chatsDataSource({required bool demo}) {
  if (demo) return ChatsDemoDataSource.instance;
  return ChatsSync.instance.enabled ? ChatsRemoteDataSource.instance : null;
}
