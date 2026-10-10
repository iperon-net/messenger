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
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf.dart';
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import '../repositories.dart';
import '../demo/chats_demo_data_source.dart';
import 'chats_data_source.dart';
import 'chats_mapping.dart';
import 'chats_media.dart';
import 'chats_sync.dart';
import 'message_search.dart';
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

  /// Реакции, закрепы, пересылка и отложенные — второй срез.
  @override
  ChatsFeatures get features => const ChatsFeatures.none();

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
          peerUserID: peer == null || isSelf ? '' : idHex(peer),
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
    if (row == null) return const [];
    final peer = row.peerUserID;
    final isSelf = peer != null && sameID(peer, me);
    final peerName = peer == null || isSelf ? '' : _Peers(await _loadPeers([peer])).of(peer).title;
    final history = await _store.messages(userID: me, chatID: chat, limit: _windows[chatID] ?? _initialWindow);
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

    final outboxDir = await outboxMediaDir();
    return [
      for (final m in history) await _withServerMedia(map(m), m.content, chatID),
      for (final queued in await _store.outbox(userID: me, chatID: chat))
        _withOutboxMedia(
          map(
            pb.ChatMessage(
              chatID: chat,
              fromUserID: me,
              date: Int64(queued.createdAt),
              content: pb.MessageContent.fromBuffer(queued.content),
              silent: queued.silent,
            ),
          ).copyWith(id: localMessageID(queued.randomID), status: models.MessageStatus.pending),
          queued,
          outboxDir,
        ),
    ];
  }

  // --- вложения ---

  CDNManager get _cdn => getIt.get<CDNManager>();

  /// Скачанные файлы вложений: cdnID (hex) → путь в кэше.
  final _mediaPaths = <String, String>{};

  /// Скачивания в очереди и идущие: cdnID (hex) → получено / всего байт
  /// шифротекста (0 / 0 — ещё ждёт очереди).
  final _downloads = <String, ({int received, int total})>{};
  final _downloadQueue = <({String key, models.CDN cdn, String chatID})>[];
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
  /// (автозагрузка всех вложений открытого чата) и отдаёт пусто.
  Future<String> _mediaFile(CDN file, String chatID) async {
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
    _downloadQueue.add((key: key, cdn: models.CDN.fromProto(file), chatID: chatID));
    _pumpDownloads();
    return '';
  }

  void _pumpDownloads() {
    while (_activeDownloads < _maxDownloads && _downloadQueue.isNotEmpty) {
      final job = _downloadQueue.removeAt(0);
      _activeDownloads++;
      unawaited(
        _download(job.key, job.cdn, job.chatID).whenComplete(() {
          _activeDownloads--;
          _pumpDownloads();
        }),
      );
    }
  }

  Future<void> _download(String key, models.CDN cdn, String chatID) async {
    try {
      if (!await _sync.hasNetwork()) throw const ChatsOfflineException();
      final file = await _cdn.download(
        cdn: cdn,
        onProgress: (received, total) {
          _downloads[key] = (received: received, total: total);
          _notifyMedia(chatID);
        },
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

  /// Пути скачанных вложений сообщения с сервера и прогресс скачивания (у
  /// видео, файлов и голосовых — кольцо в пузыре, фото проявляются из
  /// размытого превью).
  Future<models.Message> _withServerMedia(models.Message message, pb.MessageContent content, String chatID) async {
    if (content.media.isEmpty) return message;
    final paths = <String>[];
    final thumbs = <String>[];
    var received = 0;
    var total = 0;
    for (final media in content.media) {
      final path = media.hasFile() ? await _mediaFile(media.file, chatID) : '';
      paths.add(path);
      thumbs.add(media.hasThumbFile() ? await _mediaFile(media.thumbFile, chatID) : '');
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
    if (scheduleDate != null) _unsupported('Отложенные сообщения');
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
      case models.MessageKind.poll:
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
    );
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
  Future<void> setMessagePinned(String chatID, String messageID, bool pinned, {bool forEveryone = true}) async =>
      _unsupported('Закреплённые сообщения');

  @override
  Future<void> unpinAllMessages(String chatID) async => _unsupported('Закреплённые сообщения');

  @override
  Future<void> forwardMessages(String toChatID, List<models.Message> messages) async => _unsupported('Пересылка');

  /// Крестик на кольце: у неотправленного — отменить загрузку и отправку. У
  /// полученного кольцо — скачивание, его не прерываем (файл всё равно нужен
  /// для показа).
  @override
  Future<void> cancelUpload(String chatID, String messageID) async {
    final randomID = randomIDOfLocal(messageID);
    if (randomID != null) await _sync.cancelUpload(randomID);
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

/// Источник чатов для экранов: демо (фейковые данные), настоящие чаты — только
/// при включённом фича-флаге «Серверные чаты» ([ChatsSync.enabled]), иначе
/// `null` (вкладка пуста).
ChatsDataSource? chatsDataSource({required bool demo}) {
  if (demo) return ChatsDemoDataSource.instance;
  return ChatsSync.instance.enabled ? ChatsRemoteDataSource.instance : null;
}
