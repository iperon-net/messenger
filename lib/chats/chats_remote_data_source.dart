import 'dart:async';
import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';

import '../api.dart';
import '../auth.dart';
import '../cdn.dart';
import '../di.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf.dart';
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import '../repositories.dart';
import 'chats_data_source.dart';
import 'chats_mapping.dart';
import 'chats_sync.dart';
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
/// отправка сообщений: они честно ждут в outbox (⏱) и уходят при подключении.
///
/// Группы, каналы, сообщества, папки, приглашения, опросы, реакции,
/// отложенные, пересылка и закрепы — следующие срезы: их действия бросают
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

  static const _chatTables = [ChatsRepository.dialogsTable, ChatsRepository.outboxTable, 'profiles', 'contacts'];
  static const _messageTables = [ChatsRepository.messagesTable, ChatsRepository.outboxTable, ChatsRepository.dialogsTable];

  Future<void> _requireNetwork() async {
    if (!await _sync.hasNetwork()) throw const ChatsOfflineException();
  }

  static Never _unsupported(String what) => throw UnsupportedError('$what — пока только в демо (личные чаты — первый срез)');

  // --- список чатов ---

  @override
  Stream<List<models.Chat>> watchChats() => _repositories.db.onChange(_chatTables).asyncMap((_) => _loadChats());

  /// Уже запрошенные профили собеседников (hex userID) — по разу за запуск.
  final _profilesRequested = <String>{};

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
      if (chatID != null) pending[idHex(chatID)] = row;
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
      var lastMessage = topBlob == null
          ? null
          : lastMessageFromPb(pb.ChatMessage.fromBuffer(topBlob), myUserID: me, readOutboxMaxID: row.readOutboxMaxID, isSelf: isSelf);
      final queued = pending[id];
      if (queued != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(queued.createdAt);
        if (lastMessage == null || !date.isBefore(lastMessage.date)) {
          final content = pb.MessageContent.fromBuffer(queued.content);
          lastMessage = models.ChatLastMessage(
            kind: contentKind(content),
            text: content.text,
            outgoing: true,
            status: models.MessageStatus.pending,
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
          lastMessage: lastMessage,
          unreadCount: row.unreadCount,
          markedUnread: row.markedUnread,
          muted: muted.muted,
          mutedUntil: muted.until,
          pinned: row.pinned,
          archived: row.archived,
          draft: row.draft,
          about: info?.profile?.aboutMe ?? '',
          username: info?.profile?.username ?? '',
          avatarPath: await _avatarPath(info?.profile?.avatarCdnID),
          phone: info?.profile?.phoneNumber ?? '',
          lastSeen: info?.profile?.lastSeenAt,
          createdAt: row.createdAt > 0 ? DateTime.fromMillisecondsSinceEpoch(row.createdAt) : null,
        ),
      );
    }
    _requestProfiles([
      for (final row in rows)
        if (row.peerUserID case final peer? when !sameID(peer, me) && (peers.of(peer).profile?.fistName ?? '').isEmpty) peer,
    ]);
    return chats;
  }

  /// Имена собеседников: из адресной книги (как подписан у нас), иначе из
  /// кэша профилей.
  Future<Map<String, _PeerInfo>> _loadPeers(List<Uint8List> userIDs) async {
    if (userIDs.isEmpty) return const {};
    final profiles = await _repositories.profiles.getByUserIDs(userIDs: userIDs, toHex: idHex);
    final contacts = <String, String>{};
    for (final c in await _repositories.contacts.getAll()) {
      final userID = c.userID;
      if (userID != null && c.displayName.isNotEmpty) contacts.putIfAbsent(idHex(userID), () => c.displayName);
    }
    return {
      for (final userID in userIDs)
        idHex(userID): () {
          final key = idHex(userID);
          final profile = profiles[key];
          final contactName = contacts[key];
          final profileName = profile == null ? '' : '${profile.fistName} ${profile.lastName}'.trim();
          return _PeerInfo(
            title: contactName ?? (profileName.isNotEmpty ? profileName : profile?.phoneNumber ?? ''),
            isContact: contactName != null,
            profile: profile,
          );
        }(),
    };
  }

  /// Профили, которых нет в кэше, — запросом `PROFILE` по стриму: ответ
  /// пишет `API._handleMessage` в `profiles`, список перечитается сам. Пока
  /// стрим не подключён, не помечаем — запросим при следующем чтении.
  void _requestProfiles(List<Uint8List> userIDs) {
    final api = getIt.get<API>();
    if (api.connectionStatus != ApiConnectionStatus.connected) return;
    for (final userID in userIDs) {
      if (!_profilesRequested.add(idHex(userID))) continue;
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

  @override
  Stream<List<models.ChatFolder>> watchFolders() => Stream.value(const [models.ChatFolder(id: 'all', isAll: true)]);

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
  Future<void> delete(String chatID) async {
    await _requireNetwork();
    final response = await _sync.chats(pb.Chats_Request(deleteDialog: pb.Chats_DeleteDialog(chatID: idBytes(chatID))));
    await _sync.applyUpdates(response.deleteDialog.updates);
  }

  @override
  Future<void> deleteFolder(String folderID) async => _unsupported('Папки');

  @override
  Future<void> saveFolder(models.ChatFolder folder) async => _unsupported('Папки');

  @override
  Future<void> reorderFolders(List<String> folderIDs) async => _unsupported('Папки');

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

  /// Ссылки на группы/каналы — следующие срезы: «не найдено».
  @override
  Future<String> resolveLink(String path) async => '';

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
    }
    return _repositories.db.onChange(_messageTables).asyncMap((_) => _loadMessages(chatID, chat));
  }

  Future<List<models.Message>> _loadMessages(String chatID, Uint8List chat) async {
    if (!_auth.isAuthorized || chat.isEmpty) return const [];
    final me = _sync.me;
    final row = await _store.dialog(userID: me, chatID: chat);
    if (row == null) return const [];
    final peer = row.peerUserID;
    final isSelf = peer != null && sameID(peer, me);
    final peerName = peer == null || isSelf ? '' : _Peers(await _loadPeers([peer])).of(peer).title;
    final history = await _store.messages(userID: me, chatID: chat);
    final byID = {for (final m in history) m.messageID.toInt(): m};

    models.Message map(pb.ChatMessage m) => messageFromPb(
      m,
      chatID: chatID,
      myUserID: me,
      readOutboxMaxID: row.readOutboxMaxID,
      isSelf: isSelf,
      replied: m.content.hasReplyTo() ? byID[m.content.replyTo.messageID.toInt()] : null,
      peerName: peerName,
    );

    return [
      for (final m in history) map(m),
      for (final queued in await _store.outbox(userID: me, chatID: chat))
        map(
          pb.ChatMessage(
            chatID: chat,
            fromUserID: me,
            date: Int64(queued.createdAt),
            content: pb.MessageContent.fromBuffer(queued.content),
            silent: queued.silent,
          ),
        ).copyWith(id: localMessageID(queued.randomID), status: models.MessageStatus.pending),
    ];
  }

  /// randomID отправки: случайное положительное 63-битное, не 0.
  int _randomID() {
    while (true) {
      final value = (_random.nextInt(1 << 31) << 32) | _random.nextInt(1 << 32);
      if (value != 0) return value;
    }
  }

  /// Пока только текст (+ разметка, ответ): в outbox, затем — на сервер, если
  /// есть сеть; нет — уйдёт при подключении (⏱ в ленте).
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
    if (kind != models.MessageKind.text || media.isNotEmpty || localPath.isNotEmpty || poll != null) _unsupported('Медиа и опросы');
    if (scheduleDate != null) _unsupported('Отложенные сообщения');
    final chat = idBytes(chatID);
    if (chat.isEmpty || text.isEmpty) return;
    final content = textContent(text: text, entities: entities, reply: reply, linkPreview: linkPreview);
    await _store.addOutbox(userID: _sync.me, randomID: _randomID(), chatID: chat, content: content.writeToBuffer(), silent: silent);
    unawaited(_sync.flushOutbox());
  }

  @override
  Future<void> votePoll(String chatID, String messageID, List<int> options) async => _unsupported('Опросы');

  @override
  Future<void> closePoll(String chatID, String messageID) async => _unsupported('Опросы');

  @override
  Stream<List<models.Message>> watchScheduled(String chatID) => Stream.value(const []);

  @override
  Future<void> sendScheduledNow(String chatID, String messageID) async => _unsupported('Отложенные сообщения');

  @override
  Future<void> rescheduleMessage(String chatID, String messageID, DateTime date) async => _unsupported('Отложенные сообщения');

  @override
  Future<void> deleteScheduled(String chatID, String messageID) async => _unsupported('Отложенные сообщения');

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

  /// Неотправленное — просто убрать из outbox; отправленное — на сервере.
  @override
  Future<void> deleteMessage(String chatID, String messageID, {bool forEveryone = true}) async {
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) {
      await _store.deleteOutbox(userID: _sync.me, randomID: randomID);
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
  Future<void> setMessagePinned(String chatID, String messageID, bool pinned, {bool forEveryone = true}) async =>
      _unsupported('Закреплённые сообщения');

  @override
  Future<void> unpinAllMessages(String chatID) async => _unsupported('Закреплённые сообщения');

  @override
  Future<void> forwardMessages(String toChatID, List<models.Message> messages) async => _unsupported('Пересылка');

  /// Вложения пока не отправляются — отменять нечего, кроме неотправленного.
  @override
  Future<void> cancelUpload(String chatID, String messageID) async {
    if (randomIDOfLocal(messageID) != null) await deleteMessage(chatID, messageID);
  }

  @override
  Future<void> setReactions(String chatID, String messageID, List<String> emojis) async => _unsupported('Реакции');

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

  /// «Прослушано» — фоновое (началось проигрывание): без сети молча
  /// пропускаем, точка останется до следующего раза.
  @override
  Future<void> readMessageContents(String chatID, String messageID) async {
    final id = serverMessageID(messageID);
    if (id == null) return;
    try {
      if (!await _sync.hasNetwork()) return;
      final response = await _sync.messages(
        pb.Messages_Request(
          readContents: pb.Messages_ReadContents(chatID: idBytes(chatID), messageIDs: [Int64(id)]),
        ),
      );
      await _sync.applyUpdates(response.readContents.updates);
    } on ChatsOfflineException {
      // Отметим в следующий раз.
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Черновик — только локально (на сервер не уходит).
  @override
  Future<void> setDraft(String chatID, String draft) async {
    final chat = idBytes(chatID);
    if (chat.isEmpty) return;
    await _store.setDraft(userID: _sync.me, chatID: chat, draft: draft);
  }
}

class _PeerInfo {
  final String title;
  final bool isContact;
  final models.Profile? profile;

  const _PeerInfo({required this.title, required this.isContact, required this.profile});
}

class _Peers {
  final Map<String, _PeerInfo> byID;

  const _Peers(this.byID);

  _PeerInfo of(List<int> userID) => byID[idHex(userID)] ?? const _PeerInfo(title: '', isContact: false, profile: null);
}
