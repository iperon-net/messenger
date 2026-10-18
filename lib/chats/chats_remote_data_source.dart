import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../api.dart';
import '../auth.dart';
import '../cdn.dart';
import '../di.dart';
import '../utils.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf.dart';
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import '../repositories.dart';
import '../demo/chats_demo_data_source.dart';
import 'chats_data_source.dart';
import 'chats_mapping.dart';
import 'chats_presence.dart';
import 'chats_typing.dart';
import 'chats_media.dart';
import 'chats_sync.dart';
import 'message_search.dart';
import 'reactions.dart';
import 'read_receipts.dart';

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
/// Группы, каналы, сообщества, приглашения, опросы, отложенные и
/// пересылка — следующие срезы: их действия бросают
/// [UnsupportedError], а то, что экраны читают при открытии любого чата
/// (участники, отложенные, ссылки), отдаёт пустое.
class ChatsRemoteDataSource implements ChatsDataSource {
  ChatsRemoteDataSource._();

  static final ChatsRemoteDataSource instance = ChatsRemoteDataSource._();

  Logger get _logger => getIt.get<Logger>();
  Repositories get _repositories => getIt.get<Repositories>();
  ChatsRepository get _store => _repositories.chats;
  ChatsSync get _sync => ChatsSync.instance;
  Auth get _auth => getIt.get<Auth>();

  final _random = Random.secure();

  static const _chatTables = [
    ChatsRepository.dialogsTable,
    ChatsRepository.outboxTable,
    ChatsRepository.pinnedTable,
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
  ];

  Future<void> _requireNetwork() async {
    if (!await _sync.hasNetwork()) throw const ChatsOfflineException();
  }

  static Never _unsupported(String what) => throw UnsupportedError('$what — пока только в демо (личные чаты — первый срез)');

  /// Закреплённые, реакции, пересылка и отложенные — есть.
  @override
  ChatsFeatures get features => const ChatsFeatures(reactions: true, pinnedMessages: true, forward: true, scheduled: true);

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
          if (chats != null && !out.isClosed) out.add(_withTyping(chats));
        });
      },
      onCancel: () async {
        _listShown = false;
        ChatsPresence.instance.setListPeers(const []);
        await changes?.cancel();
        await presence?.cancel();
        await typing?.cancel();
        await connection?.cancel();
      },
    );
    return out.stream;
  }

  /// «Печатает…» / «отправляет фото…» из [ChatsTyping] — поверх загруженного.
  /// В личном чате имя не нужно (собеседник один) — берём заголовок.
  static List<models.Chat> _withTyping(List<models.Chat> chats) => [
    for (final chat in chats)
      switch (ChatsTyping.instance.of(chat.id)) {
        final typing when typing.isEmpty => chat,
        final typing => chat.copyWith(
          typing: [for (final t in typing) models.ChatTyping(userID: t.userID, name: chat.title, activity: t.activity)],
        ),
      },
  ];

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
    final peers = _Peers(await _loadPeers(rows.map((r) => r.peerUserID).nonNulls.toList()));
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
      // В этом срезе — только личные.
      if (row.type != pb.ChatType.CHAT_TYPE_PRIVATE.value) continue;
      final id = idHex(row.chatID);
      final peer = row.peerUserID;
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
            );
      final queued = pending[id];
      if (queued != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(queued.createdAt);
        if (lastMessage == null || !date.isBefore(lastMessage.date)) {
          final content = pb.MessageContent.fromBuffer(queued.content);
          lastMessage = models.ChatLastMessage(
            kind: contentKind(content),
            text: content.text,
            outgoing: true,
            status: queued.failed ? models.MessageStatus.failed : models.MessageStatus.pending,
            date: date,
          );
        }
      }
      final muted = mutedFromPb(row.mutedUntil, now);
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
          phone: info?.profile?.phoneNumber ?? '',
          online: peer != null && !isSelf && ChatsPresence.instance.isOnline(idHex(peer)),
          lastSeen: info?.profile?.lastSeenAt,
          createdAt: row.createdAt > 0 ? DateTime.fromMillisecondsSinceEpoch(row.createdAt) : null,
        ),
      );
    }
    // «В сети» у аватаров списка — собеседники личных чатов.
    if (_listShown) {
      ChatsPresence.instance.setListPeers([
        for (final row in rows)
          if (row.peerUserID case final peer? when row.type == pb.ChatType.CHAT_TYPE_PRIVATE.value && !sameID(peer, me)) peer,
      ]);
    }
    _requestProfiles([
      for (final row in rows)
        if (row.peerUserID case final peer? when !sameID(peer, me))
          (userID: peer, cached: (peers.of(peer).profile?.fistName ?? '').isNotEmpty),
    ]);
    return chats;
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
          final rawPhone = profile?.phoneNumber ?? '';
          final phone = rawPhone.isEmpty
              ? ''
              : _formattedPhones.putIfAbsent(rawPhone, () => utils.phoneNormalization(phoneNumber: rawPhone).international);
          return _PeerInfo(
            title: utils.composeDisplayName(
              contactName: contactNames[key] ?? '',
              firstName: profile?.fistName ?? '',
              lastName: profile?.lastName ?? '',
              username: profile?.username ?? '',
              phoneNumber: phone.isNotEmpty ? phone : (rawPhone.isNotEmpty ? rawPhone : contactPhones[key] ?? ''),
            ),
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
    final api = getIt.get<API>();
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
      final file = await getIt.get<CDNManager>().cachedFile(Uint8List.fromList(cdnID));
      if (file == null) return '';
      return _avatarPaths[key] = file.path;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
      return '';
    }
  }

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

  @override
  Future<void> readAll(List<String> chatIDs) async {
    for (final chatID in chatIDs) {
      await setRead(chatID, true);
    }
  }

  @override
  Future<void> delete(String chatID, {bool forEveryone = false}) async {
    await _requireNetwork();
    final response = await _sync.chats(
      pb.Chats_Request(
        deleteDialog: pb.Chats_DeleteDialog(chatID: idBytes(chatID), forEveryone: forEveryone),
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

  @override
  Future<bool> isUsernameAvailable(String username, {String exceptChatID = ''}) async => _unsupported('Публичные имена чатов');

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
  }) async => _unsupported('Группы, каналы и сообщества');

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
  }) async => _unsupported('Группы, каналы и сообщества');

  /// Имя пользователя (как на сервере, без учёта регистра).
  static final _usernamePattern = RegExp(r'^[A-Za-z0-9_]{5,24}$');

  /// `iperon.net/<username>` — личный чат с пользователем: знакомый (своё имя
  /// — «Избранное», собеседник с чатом в кэше) — без сети, иначе — сервер.
  /// Приглашения (`+код`) и публичные имена групп / каналов — следующие
  /// срезы: «не найдено».
  @override
  Future<String> resolveLink(String path) async {
    final name = path.trim().replaceFirst(RegExp(r'^/+'), '').split('/').first.replaceFirst('@', '');
    if (!_usernamePattern.hasMatch(name) || !_auth.isAuthorized) return '';
    final username = name.toLowerCase();
    final me = _sync.me;

    final mine = await _repositories.myProfile.getByUserID(userID: me);
    final peer = mine.username.toLowerCase() == username ? me : await _repositories.profiles.userIDByUsername(username);
    if (peer != null) {
      final local = await _store.dialogByPeer(userID: me, peerUserID: peer);
      if (local != null) return idHex(local.chatID);
    }

    await _requireNetwork();
    try {
      final response = await _sync.chats(pb.Chats_Request(resolveUsername: pb.Chats_ResolveUsername(username: username)));
      if (!response.hasResolveUsername() || !response.resolveUsername.hasDialog()) return '';
      final dialog = response.resolveUsername.dialog;
      await _sync.saveDialog(dialog);
      return idHex(dialog.chatID);
    } on ChatsRequestException catch (error) {
      if (!error.isNotFound) _logger.warning('chats: resolve username failed: $error');
      return '';
    }
  }

  @override
  Future<void> joinChat(String chatID) async => _unsupported('Группы и каналы');

  @override
  Future<String> openComments(String channelID, String postID) async => _unsupported('Комментарии каналов');

  @override
  Future<void> setCommentsClosed(String channelID, String postID, bool closed) async => _unsupported('Комментарии каналов');

  @override
  Stream<List<models.ChatInviteLink>> watchInviteLinks(String chatID) => Stream.value(const []);

  @override
  Future<void> createInviteLink(
    String chatID, {
    String title = '',
    DateTime? expireDate,
    int usageLimit = 0,
    bool requestApproval = false,
  }) async => _unsupported('Ссылки-приглашения');

  @override
  Future<void> editInviteLink(
    String chatID,
    String linkID, {
    required String title,
    DateTime? expireDate,
    required int usageLimit,
    required bool requestApproval,
  }) async => _unsupported('Ссылки-приглашения');

  @override
  Future<void> revokeInviteLink(String chatID, String linkID) async => _unsupported('Ссылки-приглашения');

  @override
  Future<void> deleteRevokedLinks(String chatID, {String linkID = ''}) async => _unsupported('Ссылки-приглашения');

  @override
  Stream<List<models.ChatJoinRequest>> watchJoinRequests(String chatID) => Stream.value(const []);

  @override
  Future<void> answerJoinRequest(String chatID, {String userID = '', required bool approve}) async => _unsupported('Заявки на вступление');

  /// Участники — у групп; профиль личного чата их тоже читает — пусто.
  @override
  Future<List<models.ChatMember>> members(String chatID) async => const [];

  @override
  Future<ChatMembersPage> membersPage(String chatID, {String cursor = '', int limit = 50, String query = ''}) async =>
      const ChatMembersPage(members: [], nextCursor: '', total: 0);

  @override
  Stream<void> watchMembersChanged(String chatID) => const Stream.empty();

  @override
  Future<void> setMemberRole(String chatID, String userID, models.ChatRole role) async => _unsupported('Участники групп');

  @override
  Future<void> removeMember(String chatID, String userID, {bool ban = false}) async => _unsupported('Участники групп');

  @override
  Future<List<models.ChatMember>> banned(String chatID) async => const [];

  @override
  Future<void> unbanMember(String chatID, String userID) async => _unsupported('Участники групп');

  @override
  Future<void> addMembers(String chatID, List<String> userIDs) async => _unsupported('Участники групп');

  @override
  Future<void> setAdmin(String chatID, String userID, {required models.ChatAdminRights rights, String rank = ''}) async =>
      _unsupported('Админы групп');

  @override
  Future<void> removeAdmin(String chatID, String userID) async => _unsupported('Админы групп');

  @override
  Future<void> transferOwnership(String chatID, String userID) async => _unsupported('Передача владения');

  @override
  Future<void> setChatReactions(String chatID, models.ChatReactionsMode mode, List<String> reactions, {int? maxReactions}) async =>
      _unsupported('Реакции групп и каналов');

  @override
  Future<void> resetToCommunity(String chatID) async => _unsupported('Сообщества');

  @override
  Future<void> setSlowMode(String chatID, int seconds) async => _unsupported('Медленный режим');

  // --- сообщения ---

  /// История из кэша + неотправленные (⏱) в конце; при подписке — свежая
  /// страница с сервера (нет сети — показываем кэш).
  @override
  Stream<List<models.Message>> watchMessages(String chatID) {
    final chat = idBytes(chatID);
    if (chat.isNotEmpty) {
      unawaited(
        _sync.loadHistory(chat).catchError((Object error, StackTrace stackTrace) {
          if (error is! ChatsOfflineException) _logger.handle(error, stackTrace);
        }),
      );
      // Открытый чат — докачиваем всю его историю в фоне: сервер искать не
      // может (содержимое зашифровано), поиск — только по скачанному.
      _sync.backfill(chat);
    }
    // Перечитываем при изменении таблиц и при расширении окна истории
    // ([loadOlderMessages] из кэша — без записи в БД). Загрузки — по очереди,
    // чтобы старый результат не пришёл после нового.
    late final StreamController<List<models.Message>> out;
    StreamSubscription<void>? changes;
    StreamSubscription<String>? refresh;
    StreamSubscription<void>? uploads;
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
      },
      onCancel: () async {
        await changes?.cancel();
        await refresh?.cancel();
        await uploads?.cancel();
        _windows.remove(chatID);
      },
    );
    return out.stream;
  }

  /// Сколько последних сообщений чата показывать (окно истории): растёт по
  /// [loadOlderMessages], сбрасывается, когда чат закрыли.
  final _windows = <String, int>{};
  static const _initialWindow = 200;
  static const _windowStep = 100;

  /// Сколько страниц истории докачивать ради перехода к старому сообщению.
  static const _revealMaxPages = 20;
  final _windowChanged = StreamController<String>.broadcast();

  @override
  Future<List<String>> searchMessages(String chatID, String query) async {
    final chat = idBytes(chatID);
    final match = ftsMatchQuery(query);
    if (chat.isEmpty || match == null || !_auth.isAuthorized) return const [];
    final ids = await _store.searchMessages(userID: _sync.me, chatID: chat, match: match);
    return [for (final id in ids) id.toString()];
  }

  @override
  Future<void> revealMessage(String chatID, String messageID) async {
    final chat = idBytes(chatID);
    final id = int.tryParse(messageID);
    if (chat.isEmpty || id == null || !_auth.isAuthorized) return;
    // Старше скачанной истории (закреплённое) — докачать до него.
    for (var page = 0; page < _revealMaxPages; page++) {
      final oldest = await _store.oldestMessageID(userID: _sync.me, chatID: chat);
      if (oldest == 0 || oldest <= id) break;
      final result = await _sync.loadOlder(chat);
      if (result.loaded == 0) break;
    }
    final needed = await _store.countMessagesFrom(userID: _sync.me, chatID: chat, messageID: id) + _windowStep ~/ 2;
    if (needed <= (_windows[chatID] ?? _initialWindow)) return;
    _windows[chatID] = needed;
    _windowChanged.add(chatID);
  }

  @override
  Future<bool> loadOlderMessages(String chatID) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return false;
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
    if (row == null) _logger.warning('chats: open chat ${idHex(chat)} has no local dialog');
    final peer = row?.peerUserID;
    final isSelf = peer != null && sameID(peer, me);
    final peerName = peer == null || isSelf ? '' : _Peers(await _loadPeers([peer])).of(peer).title;
    final history = await _store.messages(userID: me, chatID: chat, limit: _windows[chatID] ?? _initialWindow);
    final byID = {for (final m in history) m.messageID.toInt(): m};
    final pinnedIDs = {for (final m in await _store.pinned(userID: me, chatID: chat)) m.messageID.toInt()};
    final sharedPinnedIDs = await _store.sharedPinnedIDs(userID: me, chatID: chat);
    final pendingReactions = {for (final r in await _store.pendingReactions(userID: me, chatID: chat)) r.messageID: r.emojis};

    models.Message map(pb.ChatMessage m) {
      final message = messageFromPb(
        m,
        chatID: chatID,
        myUserID: me,
        readOutboxMaxID: row?.readOutboxMaxID ?? 0,
        isSelf: isSelf,
        replied: m.content.hasReplyTo() ? byID[m.content.replyTo.messageID.toInt()] : null,
        peerName: peerName,
        pinned: pinnedIDs.contains(m.messageID.toInt()),
        pinnedOnlyMe: !sharedPinnedIDs.contains(m.messageID.toInt()),
      );
      // Мой набор, ещё не принятый сервером, — поверх серверных.
      final mine = pendingReactions[m.messageID.toInt()];
      return mine == null ? message : message.copyWith(reactions: applyMyReactions(message.reactions, mine));
    }

    final outboxDir = await outboxMediaDir();
    Future<models.Message> queuedMessage(ChatOutboxRow queued) async {
      final content = pb.MessageContent.fromBuffer(queued.content);
      final message = map(
        pb.ChatMessage(chatID: chat, fromUserID: me, date: Int64(queued.createdAt), content: content, silent: queued.silent),
      ).copyWith(id: localMessageID(queued.randomID), status: queued.failed ? models.MessageStatus.failed : models.MessageStatus.pending);
      // Пересылаемое — вложения уже на CDN (описания — из кэша исходного).
      return queued.isForward ? _withServerMedia(message, content, chatID) : _withOutboxMedia(message, queued, outboxDir);
    }

    final messages = [for (final m in history) await _withServerMedia(map(m), m.content, chatID, messageID: m.messageID.toInt())];
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

  // --- вложения ---

  CDNManager get _cdn => getIt.get<CDNManager>();

  /// Скачанные файлы вложений: cdnID (hex) → путь в кэше.
  final _mediaPaths = <String, String>{};

  /// Скачивания в очереди и идущие: cdnID (hex) → получено / всего байт
  /// шифротекста (0 / 0 — ещё ждёт очереди).
  final _downloads = <String, ({int received, int total})>{};
  final _downloadQueue = <({String key, models.CDN cdn, String chatID, int? messageID})>[];
  var _activeDownloads = 0;
  static const _maxDownloads = 3;

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
    if (kind == models.MessageKind.poll || poll != null) _unsupported('Опросы');
    final chat = idBytes(chatID);
    if (chat.isEmpty) return;
    final content = textContent(text: text, entities: entities, reply: reply, linkPreview: linkPreview);
    final local = <OutboxMedia>[];
    switch (kind) {
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
      // Звонок пишет только сервер.
      case models.MessageKind.poll || models.MessageKind.call:
        return;
    }
    if (kind != models.MessageKind.text && local.isEmpty) return;
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

  @override
  Future<void> votePoll(String chatID, String messageID, List<int> options) async => _unsupported('Опросы');

  @override
  Future<void> closePoll(String chatID, String messageID) async => _unsupported('Опросы');

  // --- отложенные ---

  /// Принятые сервером (кэш, при подписке — свежий список с сервера) и ещё
  /// ждущие в outbox (без сети) — по времени отправки.
  @override
  Stream<List<models.Message>> watchScheduled(String chatID) {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return Stream.value(const []);
    unawaited(_sync.loadScheduled(chat));
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
  Future<void> editMessage(String chatID, String messageID, String text, List<models.MessageEntity> entities) async {
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
    if (chat.isNotEmpty) {
      unawaited(
        _sync.loadPinned(chat).catchError((Object error, StackTrace stackTrace) {
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
    return [
      for (final m in await _store.pinned(userID: me, chatID: chat))
        await _withServerMedia(
          messageFromPb(
            m,
            chatID: chatID,
            myUserID: me,
            readOutboxMaxID: row?.readOutboxMaxID ?? 0,
            isSelf: isSelf,
            peerName: peerName,
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
        content.forward = pb.MessageForward(fromUserID: source.fromUserID, fromName: m.forward?.name ?? '', date: source.date);
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

  /// Личный чат: когда собеседник прочитал (сервер, ≤ 7 дней). Группы — позже.
  @override
  Future<MessageReadInfo> readInfo(String chatID, String messageID) async {
    final id = serverMessageID(messageID);
    if (id == null) return const MessageReadInfo(MessageReadStatus.notRead);
    // «Избранное» — читать некому (сервер отвечает только по личным не-self).
    final row = await _store.dialog(userID: _sync.me, chatID: idBytes(chatID));
    final peer = row?.peerUserID;
    if (peer != null && sameID(peer, _sync.me)) return const MessageReadInfo(MessageReadStatus.unavailable);
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

  /// Черновик — сразу локально (виден и без сети) и на сервер — на мои
  /// остальные устройства; без сети уйдёт при подключении.
  @override
  Future<void> setDraft(String chatID, String draft) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty || !_auth.isAuthorized) return;
    if (await _store.setDraft(userID: _sync.me, chatID: chat, draft: draft)) unawaited(_sync.flushDrafts());
  }
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
