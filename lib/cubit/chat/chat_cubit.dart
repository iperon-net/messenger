import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:grpc/grpc.dart' show StatusCode;

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/message_formatting.dart';
import '../../chats/newcomer.dart';
import '../../chats/reactions.dart';
import '../../chats/read_receipts.dart';
import '../../chats/voice_player.dart';
import '../../chats/chats_remote_data_source.dart';
import '../../chats/chats_mapping.dart';
import '../../chats/chats_presence.dart';
import '../../chats/chats_sync.dart';
import '../../chats/chats_typing.dart';
import '../../chats/message_search.dart';
import '../../chats/group_rights.dart';
import '../../models.dart' as models;
import '../../privacy_blocks.dart';
import '../../repositories/repositories.dart';

import 'chat_state.dart';
import 'message_dust.dart';
import '../../chats/animated_emoji.dart';

/// Окно чата. Данные — из того же [ChatsDataSource], что и список чатов: демо
/// или настоящие ([ChatsRemoteDataSource], см.
/// docs/plans/chats-groups-channels.md, «Этап 1+»).
class ChatCubit extends Cubit<ChatState> with MessageDust<ChatState> {
  ChatCubit() : super(const ChatState());

  ChatsDataSource? _source;
  late String _chatID;
  StreamSubscription<List<models.Chat>>? _chatsSubscription;
  StreamSubscription<List<models.Message>>? _messagesSubscription;
  StreamSubscription<List<models.Message>>? _scheduledSubscription;
  StreamSubscription<List<models.Message>>? _pinnedSubscription;
  StreamSubscription<void>? _membersSubscription;
  StreamSubscription<models.Message>? _voiceSubscription;
  StreamSubscription<DateTime?>? _floodSubscription;
  Timer? _floodTimer;
  StreamSubscription<({Uint8List chatID, Uint8List? peerUserID, bool restricted})>? _writeSubscription;
  StreamSubscription<({String chatID, List<String> messageIDs})>? _deletedSubscription;
  StreamSubscription<({Uint8List chatID, String error})>? _rejectedSubscription;

  /// Собеседник ограничил, кто может ему писать (ответ `canWrite` при открытии
  /// или отказ сервера при отправке) — вместо поля ввода плашка.
  bool _writeRestricted = false;

  /// Личный чат: собеседник у меня в «Заблокированных» — вместо поля ввода
  /// «Разблокировать» (сервер и так не примет сообщение). Из кэша настроек
  /// приватности, следим за его изменениями ([PrivacyBlocks]).
  bool _peerBlocked = false;
  StreamSubscription<void>? _blocksSubscription;

  /// `canWrite` уже спросили (один раз за открытие окна).
  bool _writeChecked = false;

  /// Собеседник личного чата, чьё «в сети» держим свежим, пока окно открыто
  /// ([ChatsPresence.watch]).
  Uint8List? _presencePeer;

  /// Пока плашка — переспрашиваем `canWrite`: собеседник мог снять
  /// ограничение («Все» / добавил в контакты), не написав нам, а пуша об этом
  /// нет. По таймеру и после переподключения стрима.
  Timer? _writeRecheckTimer;
  StreamSubscription<ApiConnectionStatus>? _connectionSubscription;

  /// Медленный режим: до какого времени ждём и таймер обратного отсчёта.
  DateTime? _slowModeUntil;
  Timer? _slowModeTimer;

  /// Срок комментариев: таймер до ближайшего изменения (закрытие поста /
  /// ветки, конец ожидания «подписка не менее»).
  Timer? _commentsTimer;

  /// Канал, к посту которого эта ветка комментариев (`null` — не ветка).
  models.Chat? _channel;

  /// Наши сообщения с непрочитанными реакциями, показанные на экране и ещё
  /// не отмеченные сервером «просмотренными»; отправка — пачкой по таймеру,
  /// без сети — повтор после переподключения.
  final _reactionsSeen = <String>{};
  Timer? _reactionsSeenTimer;

  /// То же для упоминаний нас (`Message.mentionUnread`).
  final _mentionsSeen = <String>{};
  Timer? _mentionsSeenTimer;

  /// Непрочитанных при открытии (до `setRead`) и поставлен ли уже разделитель.
  int? _openUnread;
  bool _unreadPlaced = false;

  /// Пересылка в другой чат: сообщения ждут здесь, пока не откроется окно
  /// чата-получателя (его cubit забирает их в [ChatState.forwarding]).
  static final _pendingForwards = <String, List<models.Message>>{};

  static void forwardTo(String chatID, List<models.Message> messages) => _pendingForwards[chatID] = messages;

  /// Что доступно в источнике и в этом чате — экраны прячут остальное
  /// (реакции, закреп …; в группе на сервере — см. [ChatsFeatures.forChat]).
  ChatsFeatures get features => (_source?.features ?? const ChatsFeatures.none()).forChat(state.chat);

  /// Окно чата открыто ([initialization] без `markRead: false`): входящие
  /// читаются сразу и спрашивается, можно ли писать. Профиль пользователя
  /// держит cubit его личного чата только для секций (звук, медиа, «Ещё») —
  /// переписку он не читает.
  bool _markRead = true;

  /// [demo] — флаг «Демо чатов» из `settingsDevice`.
  void initialization({required String chatID, required bool demo, bool markRead = true}) {
    _chatID = chatID;
    _markRead = markRead;
    _source = chatsDataSource(demo: demo);
    final source = _source;
    if (source == null) {
      emit(state.copyWith(status: Status.success));
      return;
    }
    final pending = _pendingForwards.remove(chatID);
    if (pending != null) emit(state.copyWith(forwarding: pending));
    if (source is ChatsRemoteDataSource) {
      _syncFlood(ChatsSync.instance.floodUntil);
      _floodSubscription = ChatsSync.instance.floodChanged.listen(_syncFlood);
      _writeSubscription = ChatsSync.instance.writeRestricted.listen((event) {
        final chat = state.chat;
        final ours =
            (event.chatID.isNotEmpty && idHex(event.chatID) == chatID) ||
            (event.peerUserID != null && chat != null && chat.peerUserID.isNotEmpty && idHex(event.peerUserID!) == chat.peerUserID);
        if (isClosed || !ours || event.restricted == _writeRestricted) return;
        _writeRestricted = event.restricted;
        _syncWriteRecheck();
        _syncLimits();
      });
      _deletedSubscription = ChatsSync.instance.messagesDeleted.listen((event) {
        if (event.chatID == chatID) dissolveRemoved(event.messageIDs);
      });
      // Сервер не принял сообщение из outbox этого чата — объясняем почему
      // («новичкам — без ссылок и медиа», опрос не пересылается, медленный
      // режим …); общие отказы — без пояснения, как раньше («!» у сообщения).
      _rejectedSubscription = ChatsSync.instance.sendRejected.listen((event) {
        if (isClosed || idHex(event.chatID) != chatID || !_sendErrors.contains(event.error)) return;
        emit(state.copyWith(failNotice: state.failNotice + 1, failError: event.error));
      });
      _connectionSubscription = getIt.get<API>().connectionStatusStream.listen((status) {
        if (isClosed || status != ApiConnectionStatus.connected) return;
        if (_writeRestricted) unawaited(ChatsSync.instance.canWrite(idBytes(_chatID)));
        if (_reactionsSeen.isNotEmpty) _scheduleReactionsSeen();
        if (_mentionsSeen.isNotEmpty) _scheduleMentionsSeen();
        _retryServerSearch();
      });
    }
    _chatsSubscription = source.watchChats().listen((chats) {
      if (isClosed) return;
      final chat = chats.where((c) => c.id == chatID).firstOrNull;
      // Ветка комментариев: кто может писать — по настройкам канала.
      _channel = chat != null && chat.isThread ? chats.where((c) => c.id == chat.threadOf).firstOrNull : null;
      final community = chat?.type == models.ChatType.community;
      _openUnread ??= chat?.unreadCount;
      // Чат открыт — всё входящее сразу прочитано (у сообщества своей ленты
      // нет — его чаты читаются, когда их открывают).
      if (markRead && chat != null && chat.hasUnread && !community) source.setRead(chatID, true);
      emit(
        state.copyWith(
          chat: chat,
          status: Status.success,
          // Скрытые группы ([models.ChatJoinMode.admins]) видят только их
          // участники и админы сообщества.
          communityChats: community
              ? [
                  ...chats.where((c) => c.communityID == chatID && c.announcements),
                  ...chats.where(
                    (c) =>
                        c.communityID == chatID &&
                        !c.announcements &&
                        (c.isMember || c.joinMode != models.ChatJoinMode.admins || chat!.canManage),
                  ),
                ]
              : const [],
          community: chat != null && chat.inCommunity ? chats.where((c) => c.id == chat.communityID).firstOrNull : null,
        ),
      );
      _placeUnread();
      _syncSlowMode();
      _syncLimits();
      _checkCanWrite(source, chat);
      _watchPresence(source, chat);
      _watchBlocks(source, chat);
    });
    // Участники / роли поменялись (в т.ч. в сообществе — его владелец, админы
    // и блокировки действуют во всех его чатах) — перечитываем загруженные.
    _membersSubscription = source.watchMembersChanged(chatID).listen((_) {
      if (isClosed) return;
      if (state.members.isNotEmpty) loadMembers();
      if (state.memberPage.isNotEmpty) loadMemberPage();
    });
    // Включили непрослушанное входящее голосовое этого чата — «прослушано».
    _voiceSubscription = VoicePlayer.instance.started.listen((message) {
      getIt.get<Logger>().info(
        'chat: voice started id=${message.id} chat=${message.chatID == chatID} unread=${message.mediaUnread} outgoing=${message.outgoing}',
      );
      if (!isClosed && message.chatID == chatID && message.mediaUnread && !message.outgoing) {
        source.readMessageContents(chatID, message.id);
      }
    });
    _scheduledSubscription = source.watchScheduled(chatID).listen((scheduled) {
      if (!isClosed) emit(state.copyWith(scheduled: scheduled));
    });
    _pinnedSubscription = source.watchPinnedMessages(chatID).listen((pinned) {
      if (!isClosed) emit(state.copyWith(pinned: pinned));
    });
    _messagesSubscription = source.watchMessages(chatID).listen((fresh) {
      if (isClosed) return;
      final messages = withDustRetained(fresh);
      emit(state.copyWith(messages: messages));
      // Отмечено сервером (здесь или на другом устройстве) — больше не ждём.
      _reactionsSeen.removeWhere((id) => !messages.any((m) => m.id == id && m.reactionsUnread));
      _mentionsSeen.removeWhere((id) => !messages.any((m) => m.id == id && m.mentionUnread));
      _placeUnread();
      _syncLimits();
      _recheckCanWrite(messages);
      // Пришло/удалилось сообщение во время поиска — пересчитываем, оставаясь
      // на текущем найденном.
      if (state.searching) unawaited(_search(_server.query, keepID: state.searchCurrentID));
    });
  }

  /// Личный чат: заранее узнать, можно ли писать собеседнику (его «кто может
  /// мне писать»), — чтобы показать плашку до попытки отправить. Нет сети —
  /// не знаем, поле ввода остаётся (отказ при отправке покажет плашку).
  void _checkCanWrite(ChatsDataSource source, models.Chat? chat) {
    if (!_markRead || _writeChecked || source is! ChatsRemoteDataSource || chat == null) return;
    if (chat.type != models.ChatType.private || chat.isSelf || chat.peerUserID.isEmpty) return;
    _writeChecked = true;
    // Ответ придёт и в [ChatsSync.writeRestricted] — его ловит подписка.
    unawaited(ChatsSync.instance.canWrite(idBytes(_chatID)));
  }

  static const _writeRecheckInterval = Duration(seconds: 15);

  void _syncWriteRecheck() {
    _writeRecheckTimer?.cancel();
    _writeRecheckTimer = null;
    if (!_writeRestricted) return;
    _writeRecheckTimer = Timer.periodic(_writeRecheckInterval, (_) {
      if (!isClosed && _writeRestricted) unawaited(ChatsSync.instance.canWrite(idBytes(_chatID)));
    });
  }

  /// Личный чат: «в сети» собеседника — спрашиваем при открытии и держим
  /// свежим, пока окно открыто (сам статус приходит в [models.Chat.online]).
  void _watchPresence(ChatsDataSource source, models.Chat? chat) {
    if (_presencePeer != null || source is! ChatsRemoteDataSource || chat == null) return;
    if (chat.type != models.ChatType.private || chat.isSelf || chat.peerUserID.isEmpty) return;
    final peer = idBytes(chat.peerUserID);
    _presencePeer = peer;
    ChatsPresence.instance.watch(peer);
  }

  /// Личный чат: следим, не заблокирован ли собеседник (один раз за окно).
  void _watchBlocks(ChatsDataSource source, models.Chat? chat) {
    if (_blocksSubscription != null || source is! ChatsRemoteDataSource || chat == null) return;
    if (chat.type != models.ChatType.private || chat.isSelf || chat.peerUserID.isEmpty) return;
    _blocksSubscription = PrivacyBlocks.changes().listen((_) => unawaited(_readBlocked()));
    unawaited(_readBlocked());
    unawaited(PrivacyBlocks.refreshOnce());
  }

  Future<void> _readBlocked() async {
    final peer = state.chat?.peerUserID ?? '';
    if (peer.isEmpty) return;
    final blocked = await PrivacyBlocks.isBlocked(idBytes(peer));
    if (isClosed || blocked == _peerBlocked) return;
    _peerBlocked = blocked;
    // Разблокировали — сервер мог успеть ответить «нельзя писать»: переспросим.
    if (!blocked && _writeRestricted) unawaited(ChatsSync.instance.canWrite(idBytes(_chatID)));
    _syncLimits();
  }

  /// «Разблокировать» вместо поля ввода. Без сети — «Нет соединения».
  Future<bool> unblockPeer() async {
    final peer = state.chat?.peerUserID ?? '';
    if (peer.isEmpty) return false;
    final ok = await PrivacyBlocks.setBlocked(idBytes(peer), false);
    if (!ok && !isClosed) emit(state.copyWith(offlineNotice: state.offlineNotice + 1));
    return ok;
  }

  /// Последнее входящее, при котором спрашивали `canWrite`.
  String? _lastIncomingID;

  /// Собеседник, ограничивший сообщения, написал сам — теперь ему можно
  /// ответить: переспрашиваем сервер, чтобы убрать плашку.
  void _recheckCanWrite(List<models.Message> messages) {
    final last = messages.where((m) => !m.outgoing && !m.service).lastOrNull?.id ?? '';
    if (last == _lastIncomingID) return;
    final first = _lastIncomingID == null;
    _lastIncomingID = last;
    if (first || !_writeRestricted) return;
    unawaited(ChatsSync.instance.canWrite(idBytes(_chatID)));
  }

  /// Разделитель «Непрочитанные сообщения» — один раз, когда известны и
  /// счётчик непрочитанных, и история: над N-м с конца входящим.
  void _placeUnread() {
    final unread = _openUnread;
    if (_unreadPlaced || unread == null || state.messages.isEmpty) return;
    _unreadPlaced = true;
    if (unread <= 0) return;
    final incoming = [
      for (final m in state.messages)
        if (!m.outgoing && !m.service) m,
    ];
    if (incoming.isEmpty) return;
    emit(state.copyWith(unreadFromID: incoming[math.max(0, incoming.length - unread)].id));
  }

  /// Медленный режим: срок от сервера изменился — перезапускаем отсчёт.
  void _syncSlowMode() {
    final chat = state.chat;
    final until = chat != null && chat.slowModeApplies ? chat.slowModeUntil : null;
    if (until == _slowModeUntil) return;
    _slowModeUntil = until;
    _slowModeTimer?.cancel();
    _slowModeTimer = null;
    _tickSlowMode();
    if (state.slowModeLeft > 0) _slowModeTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickSlowMode());
  }

  void _tickSlowMode() {
    if (isClosed) return;
    final until = _slowModeUntil;
    final ms = until == null ? 0 : until.difference(DateTime.now()).inMilliseconds;
    final left = ms <= 0 ? 0 : (ms / 1000).ceil();
    if (left != state.slowModeLeft) emit(state.copyWith(slowModeLeft: left));
    if (left == 0) {
      _slowModeTimer?.cancel();
      _slowModeTimer = null;
    }
  }

  /// Лимит частоты: сервер велел подождать до [until] — отсчёт на кнопке
  /// отправки, как у медленного режима.
  void _syncFlood(DateTime? until) {
    _floodTimer?.cancel();
    _floodTimer = null;
    void tick() {
      if (isClosed) return;
      final ms = until == null ? 0 : until.difference(DateTime.now()).inMilliseconds;
      final left = ms <= 0 ? 0 : (ms / 1000).ceil();
      if (left != state.floodLeft) emit(state.copyWith(floodLeft: left));
      if (left == 0) {
        _floodTimer?.cancel();
        _floodTimer = null;
      }
    }

    tick();
    if (state.floodLeft > 0) _floodTimer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  /// Ограничения на запись: какие посты канала уже закрыты для комментариев,
  /// можно ли нам писать в эту ветку (срок, «только подписчики», «подписка не
  /// менее») и действует ли «Новичкам — без ссылок и медиа»; таймер — на
  /// ближайшее будущее изменение, тогда пересчёт.
  void _syncLimits() {
    if (isClosed) return;
    final chat = state.chat;
    final now = DateTime.now();
    final channel = chat?.type == models.ChatType.channel;
    final closedIDs = [
      if (channel)
        for (final m in state.messages)
          if (m.commentsClosed(now)) m.id,
    ];
    final (block, waitUntil) = _commentsBlock(chat, now);
    final (newcomer, newcomerUntil) = _newcomer(chat, now);
    if (block != state.commentsBlock ||
        waitUntil != state.commentsWaitUntil ||
        newcomer != state.newcomerRestricted ||
        newcomerUntil != state.newcomerUntil ||
        closedIDs.length != state.commentsClosedIDs.length ||
        !closedIDs.every(state.commentsClosedIDs.contains)) {
      emit(
        state.copyWith(
          commentsClosedIDs: closedIDs,
          commentsBlock: block,
          commentsWaitUntil: waitUntil,
          newcomerRestricted: newcomer,
          newcomerUntil: newcomerUntil,
        ),
      );
    }
    final upcoming = [
      if (channel)
        for (final m in state.messages)
          if (m.commentsCloseDate case final date? when date.isAfter(now)) date,
      if (chat != null && chat.isThread)
        if (chat.commentsCloseDate case final date? when date.isAfter(now)) date,
      ?waitUntil,
      ?newcomerUntil,
    ];
    _commentsTimer?.cancel();
    _commentsTimer = null;
    if (upcoming.isEmpty) return;
    final next = upcoming.reduce((a, b) => a.isBefore(b) ? a : b);
    // +50 мс — чтобы в момент срабатывания срок уже точно истёк.
    _commentsTimer = Timer(next.difference(now) + const Duration(milliseconds: 50), _syncLimits);
  }

  /// Почему нам нельзя писать в [chat] (и до когда ждать): собеседник ограничил
  /// личные сообщения; ветка комментариев закрытая — для всех; «только
  /// подписчики» и срок подписки админов канала не касаются.
  (ChatCommentsBlock, DateTime?) _commentsBlock(models.Chat? chat, DateTime now) {
    if (_peerBlocked) return (ChatCommentsBlock.blocked, null);
    if (_writeRestricted) return (ChatCommentsBlock.privacy, null);
    // Группа, роль «Чтение» — вместо поля ввода плашка (сервер всё равно
    // ответит «chatWriteForbidden»).
    if (chat != null && chat.type == models.ChatType.group && chat.isMember && !canSendInGroup(chat.myRole)) {
      return (ChatCommentsBlock.readOnly, null);
    }
    if (chat == null || !chat.isThread) return (ChatCommentsBlock.none, null);
    if (chat.commentsClosed(now)) return (ChatCommentsBlock.closed, null);
    final channel = _channel;
    if (channel == null || channel.canManage || channel.commentsWho != models.ChatCommentsWho.subscribers) {
      return (ChatCommentsBlock.none, null);
    }
    if (!channel.isMember) return (ChatCommentsBlock.subscribe, null);
    final joinedAt = channel.joinedAt;
    if (channel.commentsMinSubscription <= 0 || joinedAt == null) return (ChatCommentsBlock.none, null);
    final until = joinedAt.add(Duration(seconds: channel.commentsMinSubscription));
    return until.isAfter(now) ? (ChatCommentsBlock.wait, until) : (ChatCommentsBlock.none, null);
  }

  /// Медленный режим не даёт отправить сейчас (UI заранее объясняет почему,
  /// см. `checkSlowMode`; здесь — страховка).
  bool get _slowModeWaiting => state.slowModeLeft > 0 || state.floodLeft > 0;

  /// Отправить текст из поля ввода (markdown-ярлыки → entities). В режиме
  /// редактирования — правит сообщение. [silent] — без звука у получателя;
  /// [scheduleDate] — отложить текст (пересылаемые уходят сразу).
  /// [mentions] — упомянутые по имени (без @username) из подсказки «@»:
  /// их имена в тексте становятся упоминаниями (`mentionName`).
  Future<void> send(String raw, {bool silent = false, DateTime? scheduleDate, List<models.ChatMember> mentions = const []}) async {
    final source = _source;
    final forwarding = state.forwarding;
    if (source == null || (raw.trim().isEmpty && forwarding.isEmpty)) return;
    if (_sendsTyping) ChatsTyping.instance.cancel(_chatID);
    // Правка сообщения медленным режимом не ограничена.
    if (state.editing == null && (_slowModeWaiting || state.commentsBlocked)) return;
    final (text, parsed) = parseMarkdownShortcuts(raw.trim());
    final entities = withMentionNames(text, parsed, mentions);
    // Новичку — только текст без ссылок (UI заранее объясняет, см.
    // `checkNewcomer`; здесь — страховка).
    if (state.newcomerRestricted && (!isLinkFree(text, entities) || !forwarding.every(newcomerAllows))) return;
    final editing = state.editing;
    final reply = _takeReply();
    final linkPreview = !state.linkPreviewDisabled;
    emit(state.copyWith(editing: null, forwarding: const [], linkPreviewDisabled: false));
    if (editing != null) {
      // Без сети правка не уходит — возвращаем её в поле ввода с новым текстом.
      if (!await _online(() => source.editMessage(_chatID, editing.id, text, entities)) && !isClosed) {
        emit(
          state.copyWith(
            editing: editing.copyWith(text: text, entities: entities),
          ),
        );
      }
      return;
    }
    // Как в Telegram: сначала комментарий, за ним пересылаемые.
    if (text.isNotEmpty) {
      await source.sendMessage(
        _chatID,
        text: text,
        entities: entities,
        reply: reply,
        silent: silent,
        scheduleDate: scheduleDate,
        linkPreview: linkPreview,
      );
    }
    if (forwarding.isNotEmpty) await source.forwardMessages(_chatID, forwarding);
  }

  bool _loadingOlder = false;
  bool _noOlder = false;

  /// Прокрутили к началу ленты — подгрузить более старые сообщения (по одной
  /// странице за раз; дошли до начала — больше не спрашиваем). Нет сети —
  /// молча: история из кэша уже показана, попробуем при следующей прокрутке.
  Future<void> loadOlder() async {
    final source = _source;
    if (source == null || _loadingOlder || _noOlder) return;
    _loadingOlder = true;
    try {
      _noOlder = !await source.loadOlderMessages(_chatID);
    } on ChatsOfflineException {
      // Нет сети — повторим при следующей прокрутке.
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    } finally {
      _loadingOlder = false;
    }
  }

  /// Фото/видео из галереи или файл; [media] (2+) — альбом одним сообщением.
  /// [caption] — подпись под медиа (markdown-ярлыки → entities).
  Future<void> sendMedia({
    required models.MessageKind kind,
    String localPath = '',
    String fileName = '',
    String caption = '',
    List<models.MessageMedia> media = const [],
  }) async {
    final source = _source;
    if (source == null || _slowModeWaiting || state.commentsBlocked || state.newcomerRestricted) return;
    final reply = _takeReply();
    final (text, entities) = parseMarkdownShortcuts(caption.trim());
    await source.sendMessage(
      _chatID,
      kind: kind,
      localPath: localPath,
      fileName: fileName,
      media: media,
      text: text,
      entities: entities,
      reply: reply,
    );
  }

  /// Голосовое: файл записи [localPath], длительность и волна.
  Future<void> sendVoice({required String localPath, required int duration, required List<int> waveform}) async {
    final source = _source;
    if (source == null || _slowModeWaiting || state.commentsBlocked || state.newcomerRestricted) return;
    final reply = _takeReply();
    await source.sendMessage(
      _chatID,
      kind: models.MessageKind.voice,
      localPath: localPath,
      duration: duration,
      waveform: waveform,
      reply: reply,
    );
  }

  /// Ответ (с цитатой, если отвечаем на фрагмент) для отправляемого
  /// сообщения; плашка над полем ввода убирается.
  models.MessageReply? _takeReply() {
    final m = state.reply;
    final quote = state.replyQuote;
    emit(state.copyWith(reply: null, replyQuote: null));
    if (m == null) return null;
    return models.MessageReply(
      messageID: m.id,
      senderName: m.outgoing ? '' : (m.senderName.isNotEmpty ? m.senderName : state.chat?.title ?? ''),
      text: m.kind == models.MessageKind.file && m.text.isEmpty ? m.fileName : m.text,
      kind: m.kind,
      quote: quote,
    );
  }

  /// Реакция: тап по своей — снять, по другой — добавить (до
  /// [maxReactionsPerUser], сверх — вытесняется самая ранняя наша). На
  /// служебные (звонок, «закрепил») реакций нет; собеседник ограничил, кто
  /// может ему писать, — новые нельзя, снять свои можно.
  Future<void> toggleReaction(models.Message message, String emoji) async {
    final chat = state.chat;
    if (chat == null || message.service || message.phoneCall != null) return;
    final mine = message.myReactions;
    final adds = !mine.contains(emoji);
    if (adds && (_writeRestricted || _peerBlocked || !availableReactions(chat, message: message).contains(emoji))) return;
    // Поставили — в плашке её эмодзи проиграется анимацией.
    if (adds) ReactionAnimations.mark(message.id, emoji);
    await _source?.setReactions(_chatID, message.id, toggleMyReaction(mine, emoji));
  }

  /// Строка ленты оказалась на экране: наше сообщение с непрочитанными
  /// реакциями или упоминание нас — «просмотрено» (пачкой).
  void unreadShown(models.Message message) {
    if (message.outgoing && message.reactionsUnread && _reactionsSeen.add(message.id)) _scheduleReactionsSeen();
    if (!message.outgoing && message.mentionUnread && _mentionsSeen.add(message.id)) _scheduleMentionsSeen();
  }

  void _scheduleMentionsSeen() {
    _mentionsSeenTimer?.cancel();
    _mentionsSeenTimer = Timer(const Duration(milliseconds: 300), () {
      final ids = _mentionsSeen.toList();
      if (!isClosed && ids.isNotEmpty) unawaited(_source?.readMentions(_chatID, ids));
    });
  }

  /// Кнопка «@»: id самого старого непрочитанного упоминания нас (лента
  /// расширяется до него) — экран переходит к нему; оно же сразу прочитано.
  Future<String?> nextUnreadMention() async {
    final source = _source;
    if (source == null) return null;
    final id = await source.nextUnreadMention(_chatID);
    if (id == null || isClosed) return null;
    await _reveal(id);
    unawaited(source.readMentions(_chatID, [id]));
    return id;
  }

  void _scheduleReactionsSeen() {
    _reactionsSeenTimer?.cancel();
    _reactionsSeenTimer = Timer(const Duration(milliseconds: 300), () {
      final ids = _reactionsSeen.toList();
      if (!isClosed && ids.isNotEmpty) unawaited(_source?.readReactions(_chatID, ids));
    });
  }

  /// Кнопка ❤️: id самого старого нашего сообщения с непрочитанными
  /// реакциями (лента расширяется до него) — экран переходит к нему. Оно же
  /// сразу «просмотрено»: флага в кэше может не быть (сообщение старше).
  Future<String?> nextUnreadReaction() async {
    final source = _source;
    if (source == null) return null;
    final id = await source.nextUnreadReaction(_chatID);
    if (id == null || isClosed) return null;
    await _reveal(id);
    unawaited(source.readReactions(_chatID, [id]));
    return id;
  }

  /// Кто / когда прочитал наше сообщение — строка в меню сообщения (только
  /// если `readReceiptsApply`).
  Future<MessageReadInfo> readInfo(models.Message message) async =>
      await _source?.readInfo(_chatID, message.id) ?? const MessageReadInfo(MessageReadStatus.unavailable);

  /// Двойной тап по сообщению — быстрая реакция [preferred] (из настроек).
  Future<void> quickReact(models.Message message, {String preferred = defaultQuickReaction}) async {
    final chat = state.chat;
    final emoji = chat == null ? null : quickReaction(chat, message: message, preferred: preferred);
    if (emoji != null) await toggleReaction(message, emoji);
  }

  /// Меню отклонённого сообщения — «Отправить ещё раз».
  Future<void> retrySend(models.Message message) async => _source?.retrySend(_chatID, message.id);

  /// Крестик на прогрессе загрузки — отменить отправку вложений.
  Future<void> cancelUpload(models.Message message) async => _source?.cancelUpload(_chatID, message.id);

  /// Поиск по чату: открыть (удержание шапки) / закрыть.
  void startSearch() {
    _resetServerSearch('');
    emit(
      state.copyWith(
        searching: true,
        searchQuery: '',
        searchResults: const [],
        searchIndex: 0,
        searchLoading: false,
        searchOffline: false,
        searchHasMore: false,
      ),
    );
  }

  void closeSearch() {
    _resetServerSearch('');
    emit(
      state.copyWith(
        searching: false,
        searchQuery: '',
        searchResults: const [],
        searchIndex: 0,
        searchLoading: false,
        searchOffline: false,
        searchHasMore: false,
      ),
    );
  }

  /// Новый запрос: локально — сразу, на сервере — после паузы в наборе.
  void setSearchQuery(String query) {
    _resetServerSearch(query);
    if (query.trim().isNotEmpty) _serverTimer = Timer(_serverSearchDelay, () => unawaited(_loadServerPage(_server)));
    if (state.searchLoading || state.searchOffline || state.searchHasMore) {
      emit(state.copyWith(searchLoading: false, searchOffline: false, searchHasMore: false));
    }
    unawaited(_search(query));
  }

  /// Стрелка «вверх» — к более старому найденному («ещё раньше»: между ним и
  /// текущим могут быть ещё не спрошенные у сервера — сначала догружаем
  /// страницу), «вниз» — к более новому.
  void searchOlder() => unawaited(_searchOlder());

  Future<void> _searchOlder() async {
    final session = _server;
    for (var page = 0; page < _serverMorePages && session.needsPage(state.searchResults, state.searchIndex + 1); page++) {
      final before = session.next;
      await _loadServerPage(session, more: true);
      if (isClosed || !state.searching || !identical(session, _server) || session.next == before) break;
    }
    if (isClosed || !state.searching) return;
    final next = state.searchIndex + 1;
    if (next < state.searchResults.length) await _showResult(next);
  }

  void searchNewer() {
    if (state.searchIndex > 0) unawaited(_showResult(state.searchIndex - 1));
  }

  /// Номер запроса: ответ на устаревший (пока искали, ввели ещё букву) — не
  /// показываем.
  int _searchGeneration = 0;

  /// Ищет источник на устройстве: настоящие чаты — по всей скачанной истории
  /// (FTS5, не только по ленте на экране), демо — по тексту и имени файла — и
  /// сливает с уже пришедшим от сервера ([ServerSearchSession.merge]). От
  /// новых к старым. [keepID] — остаться на этом найденном (лента обновилась,
  /// пришла страница с сервера).
  Future<void> _search(String query, {String? keepID}) async {
    final source = _source;
    final generation = ++_searchGeneration;
    final local = source == null || query.trim().isEmpty ? const <String>[] : await source.searchMessages(_chatID, query);
    if (isClosed || generation != _searchGeneration || !state.searching) return;
    final results = query == _server.query ? _server.merge(local) : local;
    final kept = keepID == null ? -1 : results.indexOf(keepID);
    // Новый переход — к самому новому найденному; сначала дотягиваем ленту до
    // него, чтобы экран мог к нему прокрутиться.
    if (kept < 0 && results.isNotEmpty) {
      await _reveal(results.first);
      if (isClosed || generation != _searchGeneration || !state.searching) return;
    }
    emit(state.copyWith(searchQuery: query, searchResults: results, searchIndex: kept < 0 ? 0 : kept));
  }

  // --- поиск на сервере (подэтап 3.6) ---

  /// Пауза после последней буквы перед запросом к серверу.
  static const _serverSearchDelay = Duration(milliseconds: 400);

  /// Сколько страниц сервера догружать подряд за одно «вверх».
  static const _serverMorePages = 5;

  /// Поиск на сервере по текущему запросу.
  ServerSearchSession _server = ServerSearchSession('');
  Timer? _serverTimer;

  void _resetServerSearch(String query) {
    _serverTimer?.cancel();
    _serverTimer = null;
    _server = ServerSearchSession(query);
  }

  /// Страница поиска на сервере ([more] — следующая); один запрос за раз.
  Future<void> _loadServerPage(ServerSearchSession session, {bool more = false}) {
    final inFlight = session.inFlight;
    if (inFlight != null) return inFlight;
    late final Future<void> future;
    future = _fetchServerPage(session, more).whenComplete(() {
      if (identical(session.inFlight, future)) session.inFlight = null;
    });
    session.inFlight = future;
    return future;
  }

  Future<void> _fetchServerPage(ServerSearchSession session, bool more) async {
    final source = _source;
    final query = session.query;
    if (source == null || !session.active || (more && session.next == null)) return;
    emit(state.copyWith(searchLoading: true));
    ServerSearchPage page;
    try {
      page = await source.searchMessagesOnServer(_chatID, query, offsetID: more ? session.next : null);
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
      page = const ServerSearchPage.status(ServerSearchStatus.skipped);
    }
    if (isClosed || !identical(session, _server) || !state.searching) return;
    session.apply(page, more: more);
    // Слить с локальными, оставаясь на текущем найденном (нет — к самому
    // новому); «Поиск…» — пока не дотянули ленту до него.
    await _search(query, keepID: state.searchQuery == query ? state.searchCurrentID : null);
    if (isClosed || !identical(session, _server)) return;
    emit(state.copyWith(searchLoading: false, searchOffline: session.offline, searchHasMore: session.hasMore));
  }

  /// Подключились: поиск, не дошедший до сервера из-за сети, — догрузить.
  void _retryServerSearch() {
    final session = _server;
    if (!state.searching || !session.offline || !session.active) return;
    unawaited(_loadServerPage(session, more: session.retryMore));
  }

  /// Перейти к найденному [index]. Дошли до самого старого, а на сервере
  /// есть ещё — заранее догружаем следующую страницу.
  Future<void> _showResult(int index) async {
    final id = state.searchResults[index];
    await _reveal(id);
    if (!isClosed && state.searchResults.length > index && state.searchResults[index] == id) {
      emit(state.copyWith(searchIndex: index));
    }
    if (!isClosed && state.searching && _server.needsPage(state.searchResults, state.searchIndex + 1)) {
      unawaited(_loadServerPage(_server, more: true));
    }
  }

  /// Перейти к сообщению [id] (плашка закреплённых, «закрепил «…»»): старое,
  /// за окном истории, — сначала расширить ленту до него.
  Future<void> reveal(String id) => _reveal(id);

  /// Сообщения [id] ещё нет в ленте (старое, за окном истории) — расширить
  /// ленту до него и дождаться, пока оно придёт.
  Future<void> _reveal(String id) async {
    final source = _source;
    if (source == null || state.messages.any((m) => m.id == id)) return;
    await source.revealMessage(_chatID, id);
    try {
      await stream.firstWhere((s) => s.messages.any((m) => m.id == id)).timeout(const Duration(seconds: 3));
    } on TimeoutException {
      // Не дождались — переходим как есть (лента прокрутится, как сможет).
    } on StateError {
      // cubit закрыт.
    }
  }

  /// Ответить на [message]; [quote] — на его фрагмент («Цитировать»).
  void startReply(models.Message message, {models.MessageQuote? quote}) =>
      emit(state.copyWith(reply: message, replyQuote: quote, editing: null, forwarding: const []));

  void startEdit(models.Message message) => emit(state.copyWith(editing: message, reply: null, replyQuote: null, forwarding: const []));

  /// × на превью ссылки над полем ввода.
  void disableLinkPreview() => emit(state.copyWith(linkPreviewDisabled: true));

  void cancelCompose() => emit(state.copyWith(reply: null, replyQuote: null, editing: null, forwarding: const []));

  /// Закрепить / открепить (меню сообщения, крестик в плашке); [forEveryone]
  /// — см. [ChatsDataSource.setMessagePinned].
  /// Без сети — «Нет соединения» (`offlineNotice`), false.
  Future<bool> setPinned(models.Message message, bool pinned, {bool forEveryone = true}) =>
      _online(() => _source?.setMessagePinned(_chatID, message.id, pinned, forEveryone: forEveryone));

  /// Открепить все (экран «Закреплённые сообщения»).
  Future<bool> unpinAll({bool forEveryone = true}) => _online(() => _source?.unpinAllMessages(_chatID, forEveryone: forEveryone));

  /// Режим выделения: «Выбрать» в меню сообщения.
  void startSelection(models.Message message) {
    _resetServerSearch('');
    emit(
      state.copyWith(
        selecting: true,
        selectedIDs: [message.id],
        searching: false,
        searchQuery: '',
        searchResults: const [],
        searchLoading: false,
        searchOffline: false,
        searchHasMore: false,
      ),
    );
  }

  /// Тап по сообщению в режиме выделения; сняли последнее — выходим из режима.
  void toggleSelected(models.Message message) {
    if (message.service) return;
    final ids = state.selectedIDs.contains(message.id)
        ? state.selectedIDs.where((id) => id != message.id).toList()
        : [...state.selectedIDs, message.id];
    emit(state.copyWith(selectedIDs: ids, selecting: ids.isNotEmpty));
  }

  void clearSelection() => emit(state.copyWith(selecting: false, selectedIDs: const []));

  @override
  List<models.Message> get dustShown => state.messages;

  @override
  List<String> get dustVanishing => state.vanishingIDs;

  @override
  void emitDust({required List<models.Message> messages, required List<String> vanishingIDs}) =>
      emit(state.copyWith(messages: messages, vanishingIDs: vanishingIDs));

  /// Удалить можно свои, в личном чате — любые, в группе чужие — с правом
  /// удалять сообщения (у всех).
  bool canDelete(models.Message message) {
    final chat = state.chat;
    if (message.outgoing || chat?.type == models.ChatType.private) return true;
    return chat != null && chat.type == models.ChatType.group && !message.service && canDeleteOthers(chat, state.members);
  }

  /// Закрепить / открепить «у всех» в группе — с правом (без него — только у
  /// себя); в остальных чатах выбор — как раньше (см. `askPinScope*`).
  bool get canPinForEveryone {
    final chat = state.chat;
    return chat == null || chat.type != models.ChatType.group || canPinForAll(chat, state.members);
  }

  /// Пункт «Закрепить» / «Открепить» у [message]: в группе общий закреп
  /// снимает только тот, у кого есть право.
  bool canTogglePin(models.Message message) => !message.pinned || message.pinnedOnlyMe || canPinForEveryone;

  /// `false` — не удалось (нет сети), остальные не пробовали.
  Future<bool> deleteSelected({bool forEveryone = true}) async {
    final messages = state.selectedMessages;
    clearSelection();
    for (final m in messages) {
      // Нет сети — одно «Нет соединения», остальные не пробуем.
      if (canDelete(m) && !await delete(m, forEveryone: forEveryone)) return false;
    }
    return true;
  }

  /// Можно ли переслать: не звонок и уже на сервере (неотправленное
  /// пересылать не из чего).
  static bool forwardable(models.Message m) =>
      m.kind != models.MessageKind.call && m.status != models.MessageStatus.pending && m.status != models.MessageStatus.failed;

  /// [forwardable] в этом источнике: опрос на сервере не пересылается.
  bool canForward(models.Message m) => forwardable(m) && (m.kind != models.MessageKind.poll || features.forwardPolls);

  /// Отмеченные для пересылки, с автором оригинала — сейчас, пока известен
  /// этот чат (в личном у входящих имени отправителя нет — это название чата).
  List<models.Message> _forwardSelection() => [
    for (final m in state.selectedMessages)
      if (canForward(m))
        m.forward != null
            ? m
            : m.copyWith(
                forward: models.MessageForward(
                  self: m.outgoing,
                  name: m.outgoing ? '' : (m.senderName.isNotEmpty ? m.senderName : state.chat?.title ?? ''),
                ),
              ),
  ];

  /// Переслать отмеченные: в этот же чат — сразу в плашку над полем ввода,
  /// в другой — отложить до открытия его окна ([forwardTo]).
  void forwardSelected(String toChatID) {
    final messages = _forwardSelection();
    if (messages.isEmpty) return;
    if (toChatID == _chatID) {
      emit(state.copyWith(selecting: false, selectedIDs: const [], forwarding: messages, reply: null, replyQuote: null, editing: null));
    } else {
      forwardTo(toChatID, messages);
      clearSelection();
    }
  }

  /// «Избранное» в списке «Переслать в…» (как в Telegram): отмеченные уходят
  /// туда сразу, без перехода и без плашки (без сети — ⏱ в outbox, уйдут
  /// при подключении). Возвращает, сколько переслали.
  Future<int> saveSelected(String savedChatID) async {
    final source = _source;
    final messages = _forwardSelection();
    clearSelection();
    if (source == null || messages.isEmpty) return 0;
    await source.forwardMessages(savedChatID, messages);
    return messages.length;
  }

  /// Куда можно переслать: все чаты, кроме каналов (писать в них нельзя),
  /// сообществ (своей ленты нет — только их группы, где мы участник) и личных
  /// с локально скрытыми профилями (см. HiddenProfiles) — «Избранное» первым,
  /// архив в конце.
  Future<List<models.Chat>> forwardTargets() async {
    final source = _source;
    if (source == null) return const [];
    final hidden = await getIt.get<Repositories>().hiddenProfiles.hashByHex();
    final chats = (await source.watchChats().first)
        .where(
          (c) =>
              c.type != models.ChatType.channel &&
              c.type != models.ChatType.community &&
              // «Чтение» в группе — писать (и пересылать) туда нельзя.
              (c.type != models.ChatType.group || canSendInGroup(c.myRole)) &&
              !c.isThread &&
              (!c.inCommunity || c.isMember) &&
              !(c.type == models.ChatType.private && hidden.containsKey(c.peerUserID)),
        )
        .toList();
    int rank(models.Chat c) => c.isSelf ? 0 : (c.archived ? 2 : 1);
    // Внутри группы — порядок списка чатов (sort в Dart неустойчивый).
    final indexed = chats.indexed.toList()
      ..sort((a, b) => rank(a.$2) != rank(b.$2) ? rank(a.$2).compareTo(rank(b.$2)) : a.$1.compareTo(b.$1));
    return [for (final (_, c) in indexed) c];
  }

  /// [forEveryone] — см. [ChatsDataSource.deleteMessage].
  /// false — не удалено (нет сети).
  Future<bool> delete(models.Message message, {bool forEveryone = true}) async {
    final ok = await _online(() => _source?.deleteMessage(_chatID, message.id, forEveryone: forEveryone));
    if (ok && (state.editing?.id == message.id || state.reply?.id == message.id)) cancelCompose();
    return ok;
  }

  /// [until] — выключить до этого времени (`null` — навсегда).
  Future<void> setMuted(bool muted, {DateTime? until}) => _online(() => _source?.setMuted(_chatID, muted, until: until));

  /// Автоудаление (секунды; 0 — выключить). Без сети — «Нет соединения»;
  /// отказ сервера (собеседник ограничил, кто может писать; лимит частоты)
  /// пробрасывается — экран объясняет.
  Future<bool> setTTL(int period) => _online(() => _source?.setTTL(_chatID, period));

  /// Защита содержимого (см. ChatsDataSource.setNoForwards). Без сети — «Нет
  /// соединения»; отказ сервера пробрасывается — экран объясняет.
  Future<bool> setNoForwards(bool enabled, {String requestID = ''}) =>
      _online(() => _source?.setNoForwards(_chatID, enabled, requestID: requestID));

  /// Профиль чата: участники группы (и заблокированные — для админа).
  /// Курсор следующей страницы «Участников» и номер загрузки (перезагрузка
  /// списка отменяет догрузку, начатую до неё).
  String _memberCursor = '';
  int _memberGeneration = 0;

  /// «Участники» в профиле: [more] — следующая страница (у конца списка),
  /// иначе — заново с начала (столько же, сколько было загружено).
  Future<void> loadMemberPage({bool more = false}) async {
    final source = _source;
    if (source == null || (more && (state.memberPageLoading || !state.memberPageMore))) return;
    final generation = more ? _memberGeneration : ++_memberGeneration;
    emit(state.copyWith(memberPageLoading: true));
    final page = await source.membersPage(
      _chatID,
      cursor: more ? _memberCursor : '',
      limit: more ? 50 : math.max(50, state.memberPage.length),
      query: state.memberQuery,
    );
    if (isClosed || generation != _memberGeneration) return;
    _memberCursor = page.nextCursor;
    emit(
      state.copyWith(
        memberPage: more ? [...state.memberPage, ...page.members] : page.members,
        memberPageMore: page.nextCursor.isNotEmpty,
        memberPageLoading: false,
        membersTotal: page.total,
      ),
    );
  }

  Timer? _memberSearchTimer;

  /// Поиск по «Участникам»: список перезагружается с запросом (с паузой на
  /// набор — не на каждую букву).
  void searchMembers(String query) {
    if (query == state.memberQuery) return;
    emit(state.copyWith(memberQuery: query));
    _memberSearchTimer?.cancel();
    _memberSearchTimer = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      // Новый запрос — с первой страницы.
      emit(state.copyWith(memberPage: const []));
      loadMemberPage();
    });
  }

  /// Найти участников по [query] (выбор модератора / админа) — первая
  /// страница результатов.
  Future<List<models.ChatMember>> findMembers(String query) async =>
      (await _source?.membersPage(_chatID, query: query))?.members ?? const [];

  Future<void> loadMembers() async {
    final source = _source;
    if (source == null) return;
    final members = await source.members(_chatID);
    final chat = state.chat;
    // «Заблокированные» — владельцу и админам с правом блокировать; список
    // только с сервера: нет сети — помечаем, а не показываем пустой.
    var banned = const <models.ChatMember>[];
    var bannedFailed = false;
    if (chat != null && chat.type != models.ChatType.private && chat.canManage && canUnbanMembers(chat, members)) {
      try {
        banned = await source.banned(_chatID);
      } on ChatsOfflineException {
        banned = state.banned;
        bannedFailed = true;
      } on ChatsRequestException catch (error) {
        getIt.get<Logger>().warning('chat: banned not loaded: $error');
        banned = state.banned;
        bannedFailed = true;
      }
    }
    if (!isClosed) emit(state.copyWith(members: members, banned: banned, bannedLoadFailed: bannedFailed));
  }

  /// Действие над участником (роль, исключение, админ …): без сети — «Нет
  /// соединения», отказ сервера — объяснение ([ChatState.failNotice]); затем
  /// участники перечитываются. false — не выполнено.
  Future<bool> _memberAction(Future<void>? Function() action) async {
    var done = false;
    await _online(() async {
      try {
        await action();
        done = true;
      } on ChatsRequestException catch (error) {
        _failed(error);
      }
    });
    if (!isClosed) await loadMembers();
    return done;
  }

  /// Админ: «Чтение» ⇄ «Запись» у участника.
  Future<bool> setMemberRole(models.ChatMember member, models.ChatRole role) =>
      _memberAction(() => _source?.setMemberRole(_chatID, member.id, role));

  /// Админ: исключить ([ban] — и заблокировать).
  Future<bool> removeMember(models.ChatMember member, {bool ban = false}) =>
      _memberAction(() => _source?.removeMember(_chatID, member.id, ban: ban));

  Future<bool> unbanMember(models.ChatMember member) => _memberAction(() => _source?.unbanMember(_chatID, member.id));

  /// Добавить участников: без сети — «Нет соединения»; кого нельзя по
  /// приватности — пояснение ([ChatState.restrictedNotice]).
  Future<void> addMembers(List<models.ChatMember> members) async {
    await _online(() async {
      try {
        await _source?.addMembers(_chatID, [for (final m in members) m.id]);
      } on ChatsMembersRestrictedException catch (error) {
        if (!isClosed) emit(state.copyWith(restrictedNotice: state.restrictedNotice + 1, restrictedCount: error.count));
      } on ChatsRequestException catch (error) {
        _failed(error);
      }
    });
    if (!isClosed) await loadMembers();
  }

  /// Сервер отклонил действие — экран объясняет ([ChatState.failNotice]).
  /// Отказ в правах без своего ключа — «Недостаточно прав».
  void _failed(ChatsRequestException error) {
    final key = error.statusCode == StatusCode.permissionDenied && !_knownErrors.contains(error.error) ? 'permissionDenied' : error.error;
    if (!isClosed) emit(state.copyWith(failNotice: state.failNotice + 1, failError: key));
  }

  /// Ключи отказов сервера, у которых есть свой текст (`showChatsFailed`).
  static const _knownErrors = {
    'rightsTooWide',
    'rankInvalid',
    'chatWriteForbidden',
    'passwordInvalid',
    'privacyRestricted',
    'banned',
    'newcomerRestricted',
    'pollClosed',
    'pollForward',
  };

  /// Отказы при отправке из outbox, которые объясняем ([ChatsSync.sendRejected]).
  static const _sendErrors = {'newcomerRestricted', 'pollForward', 'chatWriteForbidden', 'slowModeWait'};

  /// Назначить админом / изменить права и «звание». false — не сохранено.
  Future<bool> setAdmin(models.ChatMember member, models.ChatAdminRights rights, String rank) =>
      _memberAction(() => _source?.setAdmin(_chatID, member.id, rights: rights, rank: rank.trim()));

  Future<bool> removeAdmin(models.ChatMember member) => _memberAction(() => _source?.removeAdmin(_chatID, member.id));

  /// Передача владения подтверждается облачным паролем (сервер).
  bool get transferNeedsPassword => _source?.transferNeedsPassword ?? false;

  /// Владелец: передать владение [member] ([password] — облачный пароль, см.
  /// [transferNeedsPassword]). Облачного пароля нет — [ChatTransferResult.passwordRequired].
  Future<ChatTransferResult> transferOwnership(models.ChatMember member, {String password = ''}) async {
    var result = ChatTransferResult.failed;
    await _online(() async {
      try {
        await _source?.transferOwnership(_chatID, member.id, password: password);
        result = ChatTransferResult.done;
      } on ChatsRequestException catch (error) {
        if (error.error == 'cloudPasswordRequired') {
          result = ChatTransferResult.passwordRequired;
        } else {
          _failed(error);
        }
      }
    });
    if (!isClosed) await loadMembers();
    return result;
  }

  /// Отправить опрос (скрепка → «Опрос»).
  Future<void> sendPoll(models.MessagePoll poll) async {
    if (_slowModeWaiting || state.commentsBlocked || state.newcomerRestricted) return;
    final reply = _takeReply();
    await _source?.sendMessage(_chatID, kind: models.MessageKind.poll, text: poll.question, poll: poll, reply: reply);
  }

  /// Голос в опросе (пустой список — отменить голос). Сервер: без сети —
  /// «Нет соединения» (выбор не «прыгает»), отказ («pollClosed» …) —
  /// объяснение, лимит частоты — общий текст.
  Future<bool> votePoll(models.Message message, List<int> options) => _serverAction(() => _source?.votePoll(_chatID, message.id, options));

  Future<bool> closePoll(models.Message message) => _serverAction(() => _source?.closePoll(_chatID, message.id));

  /// «Кто за что» в открытом опросе (сервер — по запросу). `null` — не
  /// загрузилось (нет сети — «Нет соединения», отказ — объяснение).
  Future<models.MessagePoll?> pollVoters(models.Message message) async {
    models.MessagePoll? poll;
    await _serverAction(() async => poll = await _source?.pollVoters(_chatID, message.id));
    return poll;
  }

  /// Серверное действие: без сети — `offlineNotice`, отказ или лимит
  /// частоты — `failNotice`. false — не выполнено.
  Future<bool> _serverAction(Future<void>? Function() action) async {
    var done = false;
    await _online(() async {
      try {
        await action();
        done = true;
      } on ChatsFloodException {
        _failed(const ChatsRequestException('', StatusCode.resourceExhausted));
      } on ChatsRequestException catch (error) {
        _failed(error);
      }
    });
    return done;
  }

  /// «Подписаться» / «Вступить» / «Подать заявку». Сервер: без сети — «Нет
  /// соединения», отказ (заблокирован, группа заполнена, ссылка устарела …)
  /// — объяснение ([ChatState.failNotice]); лимит частоты — тоже.
  Future<void> join() async {
    if (state.joining) return;
    emit(state.copyWith(joining: true));
    await _online(() async {
      try {
        await _source?.joinChat(_chatID);
      } on ChatsFloodException {
        _failed(const ChatsRequestException('', StatusCode.resourceExhausted));
      } on ChatsRequestException catch (error) {
        _failed(error.isNotFound ? const ChatsRequestException('linkInvalid', StatusCode.notFound) : error);
      }
    });
    if (!isClosed) emit(state.copyWith(joining: false));
  }

  /// Сообщество: вступить в его группу / канал одним нажатием (закрытая тема —
  /// заявка).
  Future<void> joinCommunityChat(models.Chat chat) async => _source?.joinChat(chat.id);

  /// Комментарии к посту канала — id чата-ветки (пусто — не открыть).
  Future<String> openComments(models.Message post) async => await _source?.openComments(_chatID, post.id) ?? '';

  /// «Новичкам — без ссылок и медиа»: действует ли на нас и до когда. Группа /
  /// сообщество — по дате вступления; ветка — по подписке на канал (не
  /// подписаны — пока не подпишемся). Админов не касается.
  (bool, DateTime?) _newcomer(models.Chat? chat, DateTime now) {
    if (chat == null) return (false, null);
    final models.Chat source;
    if (chat.isThread) {
      final channel = _channel;
      if (channel == null) return (false, null);
      source = channel;
    } else if (chat.type == models.ChatType.group || chat.type == models.ChatType.community) {
      source = chat;
    } else {
      return (false, null);
    }
    if (source.newcomerMediaDelay <= 0 || source.canManage) return (false, null);
    if (!source.isMember) return chat.isThread ? (true, null) : (false, null);
    final joinedAt = source.joinedAt;
    if (joinedAt == null) return (false, null);
    final until = joinedAt.add(Duration(seconds: source.newcomerMediaDelay));
    return until.isAfter(now) ? (true, until) : (false, null);
  }

  /// Ветка «только для подписчиков»: подписаться на канал поста.
  Future<void> subscribeToChannel() async {
    final channelID = state.chat?.threadOf ?? '';
    if (channelID.isNotEmpty) await _source?.joinChat(channelID);
  }

  /// Админ канала: закрыть комментарии к посту досрочно / снова открыть.
  Future<void> setCommentsClosed(models.Message post, bool closed) async => _source?.setCommentsClosed(_chatID, post.id, closed);

  /// «Написать сообщение» участнику — id личного чата с ним.
  Future<String?> privateChatWith(models.ChatMember member) async => _source?.openPrivateChat(member.id);

  /// Профиль чата → «Реакции» (админ). Сервер: без сети — «Нет соединения».
  Future<bool> setChatReactions(models.ChatReactionsMode mode, List<String> reactions, {int? maxReactions}) =>
      _serverAction(() => _source?.setChatReactions(_chatID, mode, reactions, maxReactions: maxReactions));

  /// Профиль чата → «Медленный режим» (админ): интервал в секундах, 0 — выкл.
  Future<bool> setSlowMode(int seconds) => _serverAction(() => _source?.setSlowMode(_chatID, seconds));

  /// Чат сообщества: настройки по умолчанию — снова от сообщества.
  Future<void> resetToCommunity() async => _source?.resetToCommunity(_chatID);

  /// Профиль чата: «Удалить чат» / «Покинуть группу».
  /// false — не удалён (нет сети): экран остаётся на месте.
  /// [forEveryone] — и у собеседника.
  Future<bool> deleteChat({bool forEveryone = false}) async {
    var done = false;
    await _online(() async {
      try {
        await _source?.delete(_chatID, forEveryone: forEveryone);
        done = true;
      } on ChatsRequestException catch (error) {
        // Например, владелец не может выйти из группы («ownerCannotLeave»).
        _failed(error);
      }
    });
    return done;
  }

  /// Серверное действие без сети: не делаем вид, что получилось, — экран
  /// покажет «Нет соединения» (см. `offlineNotice`). false — не выполнено.
  Future<bool> _online(Future<void>? Function() action) async {
    try {
      await action();
      return true;
    } on ChatsOfflineException {
      if (!isClosed) emit(state.copyWith(offlineNotice: state.offlineNotice + 1));
      return false;
    }
  }

  /// Отложенные (экран «Отложенные сообщения»).
  /// Принятые сервером без сети не меняются — «Нет соединения».
  Future<void> sendScheduledNow(models.Message message) => _online(() => _source?.sendScheduledNow(_chatID, message.id));

  Future<void> reschedule(models.Message message, DateTime date) => _online(() => _source?.rescheduleMessage(_chatID, message.id, date));

  Future<void> deleteScheduled(models.Message message) => _online(() => _source?.deleteScheduled(_chatID, message.id));

  // --- «печатает…» собеседнику (см. ChatsTyping) ---

  /// Только в настоящих чатах (в демо сигналы слать некуда).
  bool get _sendsTyping => _source is ChatsRemoteDataSource;

  ChatTypingHandle? _recording;

  /// Текст в поле изменился (не подстановка черновика): набирают — «печатает…»,
  /// очистили — снять. Правка сообщения не в счёт.
  void composeChanged(String text) {
    if (!_sendsTyping || state.editing != null) return;
    if (text.trim().isEmpty) {
      ChatsTyping.instance.cancel(_chatID);
    } else {
      ChatsTyping.instance.typing(_chatID);
    }
  }

  /// Идёт запись голосового — «записывает аудио…».
  void setRecording(bool recording) {
    if (recording == (_recording != null)) return;
    final handle = _recording;
    _recording = null;
    if (handle != null) {
      ChatsTyping.instance.end(handle);
    } else if (_sendsTyping) {
      _recording = ChatsTyping.instance.begin(_chatID, models.ChatActivity.recordVoice);
    }
  }

  /// Долгое действие до отправки (сжатие видео) — «отправляет видео…»;
  /// парный вызов — [endActivity].
  ChatTypingHandle? beginActivity(models.ChatActivity activity) => _sendsTyping ? ChatsTyping.instance.begin(_chatID, activity) : null;

  void endActivity(ChatTypingHandle? handle) {
    if (handle != null) ChatsTyping.instance.end(handle);
  }

  /// Черновик — при уходе с экрана (видно в списке чатов).
  Future<void> saveDraft(String text) async {
    if (state.editing != null) return;
    await _source?.setDraft(_chatID, text.trim());
  }

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _messagesSubscription?.cancel();
    await _scheduledSubscription?.cancel();
    await _pinnedSubscription?.cancel();
    await _membersSubscription?.cancel();
    await _voiceSubscription?.cancel();
    await _floodSubscription?.cancel();
    await _writeSubscription?.cancel();
    await _deletedSubscription?.cancel();
    await _rejectedSubscription?.cancel();
    await _connectionSubscription?.cancel();
    _serverTimer?.cancel();
    await _blocksSubscription?.cancel();
    final peer = _presencePeer;
    if (peer != null) ChatsPresence.instance.unwatch(peer);
    setRecording(false);
    if (_sendsTyping) ChatsTyping.instance.cancel(_chatID);
    _writeRecheckTimer?.cancel();
    _floodTimer?.cancel();
    _memberSearchTimer?.cancel();
    _slowModeTimer?.cancel();
    _commentsTimer?.cancel();
    _reactionsSeenTimer?.cancel();
    _mentionsSeenTimer?.cancel();
    return super.close();
  }
}
