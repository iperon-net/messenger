import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import '../api.dart';
import '../auth.dart';
import '../cdn.dart';
import '../di.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf.dart';
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import '../push.dart';
import '../repositories.dart';
import '../utils.dart';
import 'chats_mapping.dart';
import 'chats_media.dart';
import 'edit_media.dart';
import 'updates_plan.dart';
import 'chats_media_cleanup.dart';
import 'chats_typing.dart';
import 'secret/secret_chats_list.dart' show secretChatListID;
import '../account_scope.dart';

/// Capability сессии «умеет группы» (`Subscribe.capabilities`): групповое
/// сервер отдаёт только таким сессиям (старые сборки групп не знают).
const groupsCapability = 'groups';

/// Capability сессии «умеет каналы» (срез 4): каналы сервер отдаёт только
/// таким сессиям.
const channelsCapability = 'channels';

/// Действие требует сети, а её нет (или сервер недоступен): ничего не
/// изменилось — UI должен честно сказать «нет сети», а не делать вид, что
/// получилось.
class ChatsOfflineException implements Exception {
  const ChatsOfflineException();

  @override
  String toString() => 'ChatsOfflineException: нет сети';
}

/// Лимит частоты на сервере (`ResourceExhausted` «floodWait:<секунды>»):
/// повторить можно через [seconds].
class ChatsFloodException implements Exception {
  final int seconds;

  const ChatsFloodException(this.seconds);

  /// Разбор ответа сервера; `null` — это не лимит частоты.
  static ChatsFloodException? parse(int statusCode, String error) {
    if (statusCode != StatusCode.resourceExhausted || !error.startsWith(_prefix)) return null;
    final seconds = int.tryParse(error.substring(_prefix.length));
    return seconds == null ? null : ChatsFloodException(seconds < 1 ? 1 : seconds);
  }

  static const _prefix = 'floodWait:';

  @override
  String toString() => 'ChatsFloodException: повторить через $seconds с';
}

/// Медленный режим группы (`ResourceExhausted` «slowModeWait:<секунды>»,
/// подэтап 3.4): следующее сообщение — через [seconds]. Не путать с
/// [ChatsFloodException]: ждёт только этот чат, остальной outbox уходит.
class ChatsSlowModeException implements Exception {
  final int seconds;

  const ChatsSlowModeException(this.seconds);

  /// Разбор ответа сервера; `null` — это не медленный режим.
  static ChatsSlowModeException? parse(int statusCode, String error) {
    if (statusCode != StatusCode.resourceExhausted || !error.startsWith(_prefix)) return null;
    final seconds = int.tryParse(error.substring(_prefix.length));
    return seconds == null ? null : ChatsSlowModeException(seconds < 1 ? 1 : seconds);
  }

  static const _prefix = 'slowModeWait:';

  @override
  String toString() => 'ChatsSlowModeException: следующее через $seconds с';
}

/// Отказы комментариев к постам канала (подэтап 4.3, `FailedPrecondition`):
/// комментарии выключены, ветка закрыта, только подписчики. Ещё —
/// «commentsTooNew:N» ([commentsTooNewPrefix]).
const commentsErrors = {'commentsDisabled', 'commentsClosed', 'commentsSubscribersOnly'};

/// Публичный канал без подписки (подэтап 4.4): реакции и голосование — только
/// подписчикам (`FailedPrecondition`).
const subscribeRequiredError = 'subscribeRequired';

/// «commentsTooNew:N» — подписан недавно, комментировать через N секунд.
const commentsTooNewPrefix = 'commentsTooNew:';

/// Сколько секунд ждать по отказу «commentsTooNew:N»; `null` — не он.
int? commentsTooNewSeconds(String error) {
  if (!error.startsWith(commentsTooNewPrefix)) return null;
  final seconds = int.tryParse(error.substring(commentsTooNewPrefix.length));
  return seconds == null ? null : (seconds < 0 ? 0 : seconds);
}

/// Сервер отклонил запрос чатов; [error] — i18n-ключ или текст ошибки из
/// [APICallStatus].
class ChatsRequestException implements Exception {
  final String error;
  final int statusCode;

  const ChatsRequestException(this.error, this.statusCode);

  /// Собеседник ограничил, кто может ему писать (`PermissionDenied`
  /// «privacyRestricted»).
  bool get isPrivacyRestricted => statusCode == StatusCode.permissionDenied && error == 'privacyRestricted';

  /// Закреплённых чатов уже [models.chatPinnedLimit] (`FailedPrecondition`
  /// «pinnedLimit»; например, закрепили на другом устройстве).
  bool get isPinnedLimit => statusCode == StatusCode.failedPrecondition && error == 'pinnedLimit';

  /// Пересылка из чата с защитой содержимого (`PermissionDenied`
  /// «forwardsRestricted»).
  bool get isForwardsRestricted => statusCode == StatusCode.permissionDenied && error == 'forwardsRestricted';

  /// Запрос снять защиту уже отвечен или просрочен (`FailedPrecondition`
  /// «requestExpired»).
  bool get isRequestExpired => statusCode == StatusCode.failedPrecondition && error == 'requestExpired';

  /// Группы выключены — на сервере (`groups.enabled`) или у сессии нет
  /// capability `groups` (`FailedPrecondition` «groupsDisabled»).
  bool get isGroupsDisabled => statusCode == StatusCode.failedPrecondition && error == 'groupsDisabled';

  /// Каналы выключены — на сервере (`channels.enabled`) или у сессии нет
  /// capability `channels` (`FailedPrecondition` «channelsDisabled»).
  bool get isChannelsDisabled => statusCode == StatusCode.failedPrecondition && error == 'channelsDisabled';

  /// Канал: под постом уже набран «Максимум реакций под постом» — новую
  /// (не стоящую там) реакцию не поставить (`InvalidArgument`
  /// «reactionsLimit», подэтап 4.2).
  bool get isReactionsLimit => statusCode == StatusCode.invalidArgument && error == 'reactionsLimit';

  /// Публичный канал без подписки (подэтап 4.4): реакции и голосование —
  /// только подписчикам (`FailedPrecondition` «subscribeRequired»).
  bool get isSubscribeRequired => error == subscribeRequiredError;

  /// Не найдено (`NotFound`): например, пользователя с таким именем нет.
  bool get isNotFound => statusCode == StatusCode.notFound;

  @override
  String toString() => 'ChatsRequestException($statusCode): $error';
}

/// Группа создана / участники добавлены, но не все: [count] человек не
/// добавлены — их приватность «Кто может добавлять меня в группы» (или они
/// меня заблокировали). [chatID] — группа (hex).
class ChatsMembersRestrictedException implements Exception {
  final String chatID;
  final int count;

  const ChatsMembersRestrictedException(this.chatID, this.count);

  @override
  String toString() => 'ChatsMembersRestrictedException: $count не добавлены в $chatID';
}

/// Синхронизация чатов с сервером по модели Telegram (см.
/// docs/plans/chats-groups-channels.md, «Этап 1+»): у пользователя журнал
/// обновлений с монотонным pts, клиент держит копию в SQLite
/// ([ChatsRepository]) и применяет обновления строго по порядку
/// ([planUpdates]): повтор — пропуск, дыра — догон через GET_DIFFERENCE.
///
/// Источники обновлений: ответы на запросы (применяются сразу) и push
/// `UPDATES` по стриму (те же обновления приходят на все мои устройства,
/// включая это, — отсюда идемпотентность по pts). При (пере)подключении
/// стрима ([onConnected]) — догон и отправка outbox.
///
/// Всё, что меняет локальное состояние, идёт последовательно через [_locked]:
/// push, ответ на запрос и догон не применяются наперегонки.
class ChatsSync {
  /// Аккаунт этого сервиса: зависимости берутся из него, а не из «текущего» —
  /// после переключения аккаунта незавершённые операции не уйдут в чужой.
  final AccountScope _scope = AccountScope.current;

  ChatsSync._() {
    // Удалённые сообщения / чаты — их файлы с устройства, если больше не нужны.
    ChatsRepository.onMediaReleased = ChatsMediaCleanup.release;
  }

  static ChatsSync get instance => AccountScope.current.resolve(ChatsSync._);

  Logger get _logger => getIt.get<Logger>();
  API get _api => _scope.api;
  ChatsRepository get _store => _scope.repositories.chats;
  Auth get _auth => _scope.auth;

  /// Мой userID (активная сессия).
  Uint8List get me => Uint8List.fromList(_auth.session.userID);

  /// Размер страницы списка диалогов / истории / догона.
  static const _pageLimit = 100;

  /// Предел страниц догона за раз — защита от бесконечного цикла, если сервер
  /// всё время отвечает `hasMore`.
  static const _maxDifferencePages = 50;

  Future<void> _queue = Future.value();

  /// Выполнить [action] после всех ранее поставленных (мьютекс на Future).
  Future<T> _locked<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _queue = _queue.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  // --- запросы ---

  /// Unary-запрос с шифрованием; ошибки → [ChatsOfflineException] (нет связи) /
  /// [ChatsRequestException].
  Future<Uint8List> _request(MessageType type, Uint8List payload) async {
    final (status, body) = await _api.unaryEncodedWithResponse(type, payload);
    if (status.status == APIStatus.success && body != null) return body;
    if (const [StatusCode.unavailable, StatusCode.deadlineExceeded, StatusCode.unknown].contains(status.statusCode)) {
      throw const ChatsOfflineException();
    }
    final flood = ChatsFloodException.parse(status.statusCode, status.error);
    if (flood != null) throw flood;
    final slowMode = ChatsSlowModeException.parse(status.statusCode, status.error);
    if (slowMode != null) throw slowMode;
    throw ChatsRequestException(status.error, status.statusCode);
  }

  Future<pb.Chats_Response> chats(pb.Chats_Request request) async =>
      pb.Chats_Response.fromBuffer(await _request(MessageType.CHATS, request.writeToBuffer()));

  /// Могу ли я писать в чат (приватность собеседника «кто может мне писать»).
  /// `null` — не удалось узнать (нет сети / ошибка): поле ввода не прячем,
  /// отправку всё равно проверит сервер.
  Future<bool?> canWrite(List<int> chatID) async {
    if (!await hasNetwork()) return null;
    try {
      final response = await chats(pb.Chats_Request(canWrite: pb.Chats_CanWrite(chatID: chatID)));
      if (!response.hasCanWrite()) return null;
      final allowed = response.canWrite.allowed;
      _logger.debug('chats: can write chat=${idHex(chatID)} allowed=$allowed');
      _writeRestricted.add((chatID: Uint8List.fromList(chatID), peerUserID: null, restricted: !allowed));
      return allowed;
    } on ChatsOfflineException {
      return null;
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: can write failed: $error');
      return null;
    }
  }

  final _writeRestricted = StreamController<({Uint8List chatID, Uint8List? peerUserID, bool restricted})>.broadcast();

  /// Узнали, можно ли писать в чат: ответ [canWrite] или отказ сервера при
  /// отправке из outbox (тогда [chatID] может быть пустым — чат по
  /// [peerUserID] ещё не создан). Окно чата меняет поле ввода на плашку.
  Stream<({Uint8List chatID, Uint8List? peerUserID, bool restricted})> get writeRestricted => _writeRestricted.stream;

  final _sendRejected = StreamController<({Uint8List chatID, String error})>.broadcast();

  /// Сервер не принял сообщение из outbox (или принял не сразу — медленный
  /// режим «slowModeWait»): [error] — ключ отказа («newcomerRestricted»,
  /// «pollForward», «chatWriteForbidden» …). Окно чата объясняет.
  Stream<({Uint8List chatID, String error})> get sendRejected => _sendRejected.stream;

  final _messagesDeleted = StreamController<({String chatID, List<String> messageIDs})>.broadcast(sync: true);

  /// Сообщения сейчас пропадут из кэша (удалил собеседник, другое моё
  /// устройство, автоудаление) — шлётся ДО записи в БД, чтобы открытое окно
  /// чата успело придержать строки и рассыпать их пылью. [chatID] — hex.
  Stream<({String chatID, List<String> messageIDs})> get messagesDeleted => _messagesDeleted.stream;

  Future<pb.Messages_Response> messages(pb.Messages_Request request) async =>
      pb.Messages_Response.fromBuffer(await _request(MessageType.MESSAGES, request.writeToBuffer()));

  /// Есть ли сеть у устройства (быстрая проверка до запроса).
  Future<bool> hasNetwork() => getIt.get<Utils>().hasNetwork();

  // --- подключение ---

  bool _enabled = false;

  /// Фича-флаг «Серверные чаты» (экран «Разработчик»). Выключен — журнал не
  /// догоняется и push'и UPDATES не применяются (сервер их всё равно шлёт).
  bool get enabled => _enabled;

  /// Ставит [CommonCubit] при старте и при переключении. Включили при живом
  /// стриме — догнать сразу, не дожидаясь переподключения.
  void setEnabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    _watchUnread(value);
    _watchExpired(value);
    if (value && _scope.api.connectionStatus == ApiConnectionStatus.connected) {
      unawaited(onConnected());
    }
  }

  /// Чат типа [type] (`pb.ChatType`) — диалог списка: личные, группы и
  /// каналы (ветки комментариев и прочее — нет).
  bool showsChatType(int type) =>
      type == pb.ChatType.CHAT_TYPE_PRIVATE.value ||
      type == pb.ChatType.CHAT_TYPE_GROUP.value ||
      type == pb.ChatType.CHAT_TYPE_CHANNEL.value;

  /// После переподключения перечитать список диалогов целиком
  /// ([reloadDialogsOnConnect]).
  bool _reloadOnConnect = false;

  /// Группы и каналы раньше были за флагами «Группы» / «Каналы» (экран
  /// «Разработчик»): пока флаг был выключен, они не попадали в журнал этой
  /// сессии. Ставит [CommonCubit] один раз, когда флаги сняты, — список
  /// диалогов перечитается на следующем подключении.
  void reloadDialogsOnConnect() {
    _reloadOnConnect = true;
    if (_scope.api.connectionStatus == ApiConnectionStatus.connected) {
      unawaited(onConnected());
    }
  }

  final _membersChanged = StreamController<String>.broadcast();

  /// Изменился состав группы (hex chatID): `Update.chatMembers` или страница
  /// `Chats.Members`.
  Stream<String> get membersChanged => _membersChanged.stream;

  /// Состав группы перечитан с сервера ([ChatsRemoteDataSource]).
  void notifyMembersChanged(String chatID) => _membersChanged.add(chatID);

  final _joinRequestsChanged = StreamController<String>.broadcast();

  /// Изменились заявки на вступление в группу (hex chatID):
  /// `Update.joinRequests` — открытый экран «Заявки» перечитывает список.
  Stream<String> get joinRequestsChanged => _joinRequestsChanged.stream;

  /// Ответили на заявку ([ChatsRemoteDataSource]) — перечитать список.
  void notifyJoinRequestsChanged(String chatID) => _joinRequestsChanged.add(chatID);

  StreamSubscription<ChatsUnread>? _unreadSub;

  /// Непрочитанные чаты для счётчиков на вкладке «Чаты», у «назад» в окне
  /// чата и на иконке (iOS) — одно число [ChatsUnread.total], как в Telegram
  /// (режим «чаты»); из локального списка диалогов, при каждом его изменении.
  final unread = ValueNotifier<ChatsUnread>(ChatsUnread.empty);

  /// Последнее выставленное число на иконке (iOS) — не дёргаем натив зря.
  int? _badge;

  /// Счётчики [unread] и бейдж на иконке (iOS) — из локального списка диалогов
  /// при каждом его изменении: так они сходятся с тем, что видно в «Чатах», и
  /// падают сразу после прочтения здесь. В фоне бейдж ведут пуши (сервер
  /// считает так же, см. `badge` в `services/chats.go`). Выключили серверные
  /// чаты — снимаем.
  void _watchUnread(bool enabled) {
    unawaited(_unreadSub?.cancel());
    _unreadSub = null;
    if (!enabled) {
      unread.value = ChatsUnread.empty;
      _setBadge(0);
      return;
    }
    final repositories = _scope.repositories;
    // Скрыли/показали профиль — его личный чат входит в счётчик или выходит.
    final changes = StreamController<void>();
    final dialogsSub = repositories.db
        .onChange([ChatsRepository.dialogsTable, ChatsRepository.repliesStateTable, ...SecretChatsRepository.tables])
        .listen(changes.add, onError: changes.addError);
    final hiddenSub = repositories.hiddenProfiles.changes.listen(changes.add);
    changes.onCancel = () async {
      await dialogsSub.cancel();
      await hiddenSub.cancel();
    };
    _unreadSub = changes.stream.asyncMap((_) => _countUnread()).listen((counts) {
      unread.value = counts;
      _setBadge(counts.total);
    }, onError: (Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace));
  }

  void _setBadge(int count, {bool force = false}) {
    if (!Platform.isIOS || (!force && _badge == count)) return;
    _badge = count;
    unawaited(PushManager.setBadge(count));
  }

  /// Приложение вернулось на передний план — переставить бейдж по локальному
  /// списку, даже если число не менялось: в фоне его ставили пуши (сервер не
  /// знает о скрытых профилях, а прочтение на другом устройстве могло прийти
  /// без тихого пуша), и иначе на иконке оставалась бы «1» при всём прочитанном.
  void refreshBadge() {
    if (!Platform.isIOS || !_enabled) return;
    unawaited(
      _countUnread().then(
        (counts) => _setBadge(counts.total, force: true),
        onError: (Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace),
      ),
    );
  }

  /// Непрочитанные чаты: видимые незаглушённые диалоги с непрочитанными
  /// входящими или ручной пометкой (как на сервере, `badge:<user>`); в
  /// [ChatsUnread.byChat] — сколько сообщений, в [ChatsUnread.total] — сколько
  /// чатов. Ветки комментариев и каналы без подписки не считаем. Личные чаты с локально скрытыми
  /// профилями (HiddenProfiles) не считаем — сервер о них не знает, поэтому
  /// бейдж из пуша в фоне их ещё включает. Секретные чаты этого устройства
  /// считаем тоже (заглушить их нельзя) — сервер их не видит. «Ответы» (4.6)
  /// с непрочитанными — тоже 1 чат (заглушения нет), как
  /// элемент `replies` в `badge:<user>` на сервере.
  @visibleForTesting
  Future<ChatsUnread> countUnread() => _countUnread();

  Future<ChatsUnread> _countUnread() async {
    if (!_auth.isAuthorized) return ChatsUnread.empty;
    final now = DateTime.now();
    final repositories = _scope.repositories;
    final hidden = await repositories.hiddenProfiles.hashByHex();
    final byChat = <String, int>{};
    // Публичные каналы без подписки (4.4) — не диалоги списка.
    final browsed = {for (final b in await _store.browsed(userID: me)) idHex(b.chatID)};
    for (final row in await _store.dialogs(userID: me)) {
      if (mutedFromPb(row.mutedUntil, now).muted) continue;
      if (browsed.contains(idHex(row.chatID))) continue;
      // Ветки комментариев (THREAD) — не диалоги списка.
      if (!showsChatType(row.type)) continue;
      if (row.peerUserID case final peer? when hidden.containsKey(idHex(peer))) continue;
      final count = row.unreadCount > 0 ? row.unreadCount : (row.markedUnread ? 1 : 0);
      if (count > 0) byChat[idHex(row.chatID)] = count;
    }
    for (final record in await repositories.secretChats.chats(sessionID: _auth.session.sessionID)) {
      if (record.unreadCount <= 0 || hidden.containsKey(idHex(record.peerUserID))) continue;
      byChat[secretChatListID(record.secretChatID)] = record.unreadCount;
    }
    final replies = await _store.repliesState(userID: me);
    if (replies != null && replies.unreadCount > 0) byChat[models.repliesChatID] = replies.unreadCount;
    return ChatsUnread(byChat);
  }

  final _incoming = StreamController<ChatsIncoming>.broadcast();

  /// Новые входящие, пришедшие вживую push'ем `UPDATES` (не догон после
  /// подключения), — для баннера в приложении (`InAppNotices`). Событие — уже
  /// после записи в БД. Упоминание меня в группе приходит отдельным
  /// обновлением — тогда событие повторяется с `mentioned` (пробивает «Без
  /// звука»).
  Stream<ChatsIncoming> get incoming => _incoming.stream;

  final _repliesIncoming = StreamController<pb.ThreadReply>.broadcast();

  /// Новые непрочитанные «Ответы» (4.6), пришедшие вживую push'ем `UPDATES`
  /// (не догон) — для баннера в приложении. Событие — после записи в БД.
  Stream<pb.ThreadReply> get repliesIncoming => _repliesIncoming.stream;

  /// Для кого уже убедились, что «Избранное» есть (hex userID).
  final _selfEnsured = <String>{};

  bool _connecting = false;

  /// Стрим (пере)подключился (зовёт [API]): догнать журнал — с нуля полным
  /// списком диалогов, если pts ещё нет, иначе GET_DIFFERENCE, — затем
  /// отправить outbox.
  Future<void> onConnected() async {
    if (!_enabled || !_auth.isAuthorized || _connecting) return;
    _connecting = true;
    try {
      await _locked(_catchUp);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    } finally {
      _connecting = false;
    }
    await flushOutbox();
    await flushReactions();
    await flushDrafts();
    await flushContents();
    await flushRepliesRead();
    if (!_browsedPruned) {
      _browsedPruned = true;
      unawaited(pruneBrowsed().catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)));
    }
    // Временные подписки (открытые ветки комментариев) живут до конца стрима —
    // после переподключения подписываемся заново и догоняем пропущенное.
    for (final watched in _watched.values.toList()) {
      unawaited(_sendWatch(watched.chatID, true));
    }
    // Докачка истории открытых чатов, прерванная обрывом связи.
    unawaited(_runBackfill());
  }

  // --- временные подписки (Chats.Watch, подэтап 4.3) ---

  /// Открытые окна чатов без членства (ветки комментариев): hex chatID →
  /// chatID и сколько окон его держат.
  final _watched = <String, ({Uint8List chatID, int refs})>{};

  /// Что сейчас держим подпиской (hex chatID) — для тестов.
  @visibleForTesting
  Set<String> get watched => _watched.keys.toSet();

  /// Окно ветки открыто: пока оно открыто, стрим получает её журнал
  /// (`Chats.Watch`), а пропущенное догоняется `GetChatDifference`. Нет сети
  /// — подпишемся при подключении ([onConnected]).
  void watch(Uint8List chatID) {
    final key = idHex(chatID);
    final current = _watched[key];
    _watched[key] = (chatID: chatID, refs: (current?.refs ?? 0) + 1);
    if (current == null) unawaited(_sendWatch(chatID, true));
  }

  /// Окно ветки закрыто — снять подписку (последнее из открытых окон). Ушли в
  /// фон — стрим закрывается, а с ним и подписки на сервере. [send] = false —
  /// только забыть локально: пока окно было открыто, на канал подписались
  /// (4.4), и его журнал теперь идёт стриму и без Watch — снимать нечего.
  void unwatch(Uint8List chatID, {bool send = true}) {
    final key = idHex(chatID);
    final current = _watched[key];
    if (current == null) return;
    if (current.refs > 1) {
      _watched[key] = (chatID: chatID, refs: current.refs - 1);
      return;
    }
    _watched.remove(key);
    if (send) unawaited(_sendWatch(chatID, false));
  }

  Future<void> _sendWatch(Uint8List chatID, bool on) async {
    if (!_enabled || !_auth.isAuthorized) return;
    // Без стрима подписка не нужна (и не переживёт его открытие).
    if (!getIt.isRegistered<API>() || _api.connectionStatus != ApiConnectionStatus.connected) return;
    try {
      final response = await chats(
        pb.Chats_Request(
          watch: pb.Chats_Watch(chatID: chatID, on: on),
        ),
      );
      if (!on || !_watched.containsKey(idHex(chatID))) return;
      final user = me;
      final info = response.watch.hasChat() ? response.watch.chat : null;
      var fresh = false;
      await _locked(() async {
        final group = await _store.group(userID: user, chatID: chatID);
        if (info != null && group != null) {
          await _store.setGroupInfo(userID: user, info: info);
          // Публичный канал открыт без подписки впервые (4.4): pts ещё нет —
          // журнал с текущего, а пропущенное до него — свежей страницей
          // истории (не с начала журнала канала).
          if (group.pts == 0 && info.pts > 0) {
            await _store.setGroupPts(userID: user, chatID: chatID, pts: info.pts.toInt());
            fresh = true;
            return;
          }
        }
        await _catchUpChats([chatID]);
      });
      if (fresh) await loadHistory(chatID);
    } on ChatsOfflineException {
      // Подпишемся при следующем подключении.
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: watch ${idHex(chatID)} on=$on failed: $error');
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  // --- публичный канал без подписки (подэтап 4.4) ---

  /// Сколько каналов без подписки держим в кэше (последние открытые).
  static const browsedKeep = 10;

  /// Сколько держим кэш канала без подписки после последнего открытия.
  static const browsedMaxAge = Duration(days: 7);

  /// Предпросмотр публичного канала (`canViewHistory`) — в кэш как канал без
  /// подписки ([ChatsRepository.saveBrowsedChannel]). `false` — уже подписаны.
  Future<bool> saveBrowsedChannel(pb.ChatInfo info) {
    final user = me;
    final now = DateTime.now().millisecondsSinceEpoch;
    return _locked(() => _store.transaction((tx) => tx.saveBrowsedChannel(userID: user, info: info, at: now)));
  }

  /// Канал без подписки — да / нет (окно чата: Watch, отложенные, докачка).
  Future<bool> isBrowsing(Uint8List chatID) async => (await _store.group(userID: me, chatID: chatID))?.browsing ?? false;

  /// Окно канала без подписки открыли / закрыли — он «свежий» для чистки.
  Future<void> touchBrowsed(Uint8List chatID) {
    final user = me;
    final now = DateTime.now().millisecondsSinceEpoch;
    return _locked(() => _store.touchBrowsed(userID: user, chatID: chatID, at: now));
  }

  /// Чистка кэша каналов без подписки (при закрытии окна и при первом
  /// подключении за запуск): остаются [browsedKeep] последних открытых, не
  /// старше [browsedMaxAge]; открытые сейчас ([watched]) — всегда.
  Future<void> pruneBrowsed({DateTime? now}) async {
    if (!_auth.isAuthorized) return;
    final user = me;
    final at = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final keep = watched;
    final deleted = await _locked(
      () => _store.transaction((tx) => tx.pruneBrowsed(userID: user, now: at, maxAge: browsedMaxAge, maxCount: browsedKeep, keep: keep)),
    );
    for (final chatID in deleted) {
      _noOlder.remove(idHex(chatID));
      _logger.info('chats: browsed channel ${idHex(chatID)} pruned');
    }
  }

  /// Чистка при старте — раз за запуск.
  bool _browsedPruned = false;

  // --- ветки комментариев (подэтап 4.3) ---

  /// Ответ OpenComments — ветка в кэш (см. [ChatsRepository.saveThread]).
  Future<void> saveThread(pb.ChatInfo info, int readInboxMaxID) {
    final user = me;
    return _locked(() => _store.transaction((tx) => tx.saveThread(userID: user, info: info, readInboxMaxID: readInboxMaxID)));
  }

  /// Ветку прочитали до [maxID] (ответ ReadHistory): у ветки и у поста.
  Future<void> markThreadRead(Uint8List threadChatID, int maxID) {
    final user = me;
    return _locked(() => _store.transaction((tx) => tx.setThreadRead(userID: user, threadChatID: threadChatID, maxID: maxID)));
  }

  /// Свежие комментарии постов (GetViews, SetCommentsClosed) — в кэш.
  Future<void> savePostComments(Uint8List chatID, Map<int, pb.MessageComments> comments) {
    if (comments.isEmpty) return Future.value();
    final user = me;
    return _locked(
      () => _store.transaction((tx) async {
        for (final MapEntry(key: postID, value: c) in comments.entries) {
          await tx.setPostComments(userID: user, chatID: chatID, postID: postID, comments: c);
        }
      }),
    );
  }

  Future<void> _catchUp() async {
    final user = me;
    if (await _store.getPts(userID: user) == null || _reloadOnConnect) {
      _reloadOnConnect = false;
      await _reloadDialogs();
    } else if (await _store.folders(userID: user) == null) {
      // Журнал уже был до папок (обновили приложение) — снимок отдельно.
      await _loadFolders();
    }
    // Пока листали страницы списка, могли прийти обновления — догоняем от pts
    // первой страницы (повторное применение идемпотентно).
    await _getDifference();
    // Журналы групп и каналов — каждый свой: что изменилось, пока нас не было.
    await _syncGroups();
    // «Ответы» (4.6) — первая страница, если её ещё нет или журнал отстал.
    await _syncReplies();
    await _ensureSelfChat(user);
  }

  /// «Избранное» (личный чат с собой) должно быть в списке всегда: нет — просим
  /// сервер создать (раз за запуск).
  Future<void> _ensureSelfChat(Uint8List user) async {
    final key = idHex(user);
    if (_selfEnsured.contains(key)) return;
    if (await _store.dialogByPeer(userID: user, peerUserID: user) == null) {
      final response = await chats(pb.Chats_Request(openPrivate: pb.Chats_OpenPrivate(userID: user)));
      if (response.hasOpenPrivate() && response.openPrivate.hasDialog()) {
        await _store.upsertDialog(userID: user, dialog: response.openPrivate.dialog);
      }
    }
    _selfEnsured.add(key);
  }

  /// Полный список диалогов (все страницы) заменяет локальный; pts — с первой
  /// страницы. [staleHistory] — журнал отстал (`tooLong`): кэш истории не
  /// стирается, а становится несверенным — сверится страницами при открытии
  /// чатов ([loadHistory], [loadOlder]).
  Future<void> _reloadDialogs({bool staleHistory = false}) async {
    final user = me;
    // Кэш несверен — «старше нет» больше не верно.
    if (staleHistory) _noOlder.clear();
    // Обновления «Ответов» тоже могли пропасть — первая страница заново.
    _repliesReload = true;
    final dialogs = <pb.Dialog>[];
    pb.UpdatesState? state;
    var offsetDate = Int64.ZERO;
    List<int> offsetChatID = const [];
    while (true) {
      final response = await chats(
        pb.Chats_Request(
          list: pb.Chats_List(offsetDate: offsetDate, offsetChatID: offsetChatID, limit: _pageLimit),
        ),
      );
      final list = response.list;
      state ??= list.state;
      dialogs.addAll(list.dialogs);
      if (!list.hasMore || list.dialogs.isEmpty) break;
      // Курсор — дата последнего сообщения последнего диалога страницы (у
      // пустого диалога — дата создания) + его chatID.
      final last = list.dialogs.last;
      offsetDate = last.hasTopMessage() ? last.topMessage.date : last.createdAt;
      offsetChatID = last.chatID;
    }
    final pts = state.pts.toInt();
    final date = state.date.toInt();
    await _store.transaction((tx) async {
      await tx.replaceDialogs(userID: user, dialogs: dialogs, staleHistory: staleHistory);
      await tx.setPts(userID: user, pts: pts, date: date);
    });
    // Изменения папок после этого pts придут обновлениями folders.
    await _loadFolders();
    // Отложенные могли разойтись — перечитаем при открытии чата.
    _scheduledLoaded.clear();
  }

  /// Чаты, отложенные которых уже загружены за этот запуск (hex chatID):
  /// дальше их ведут обновления scheduledMessage / scheduledDeleted.
  final _scheduledLoaded = <String>{};

  /// Мои отложенные в чате с сервера (открыли чат) — раз за запуск; без сети
  /// — из кэша, попробуем при следующем открытии.
  Future<void> loadScheduled(Uint8List chatID) async {
    final key = idHex(chatID);
    if (!_enabled || _scheduledLoaded.contains(key) || !await hasNetwork()) return;
    try {
      final response = await messages(pb.Messages_Request(scheduled: pb.Messages_Scheduled(chatID: chatID)));
      final user = me;
      await _locked(
        () => _store.transaction((tx) => tx.replaceScheduled(userID: user, chatID: chatID, messages: response.scheduled.messages)),
      );
      _scheduledLoaded.add(key);
    } on ChatsOfflineException {
      // Попробуем при следующем открытии.
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: scheduled load failed: $error');
    }
  }

  /// Снимок папок (первый вход, перезагрузка диалогов). Сбой — не повод
  /// ронять догон: без папок список чатов работает, повторим при подключении.
  Future<void> _loadFolders() async {
    final user = me;
    try {
      final response = await chats(pb.Chats_Request(getFolders: pb.Chats_GetFolders()));
      if (!response.hasGetFolders()) return;
      await _store.setFolders(userID: user, folders: response.getFolders.folders);
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: get folders failed: $error');
    }
  }

  /// GET_DIFFERENCE от локального pts, пока сервер говорит `hasMore`.
  Future<void> _getDifference() async {
    final user = me;
    for (var page = 0; page < _maxDifferencePages; page++) {
      final pts = await _store.getPts(userID: user);
      if (pts == null) {
        await _reloadDialogs();
        return;
      }
      final response = pb.GetDifference_Response.fromBuffer(
        await _request(MessageType.GET_DIFFERENCE, pb.GetDifference_Request(pts: Int64(pts), limit: _pageLimit).writeToBuffer()),
      );
      if (response.tooLong) {
        // Журнал на сервере уже обрезан — перезагружаем диалоги с нуля, а кэш
        // истории помечаем несверенным: он мог разойтись с сервером, но
        // стирать его незачем — сверится при открытии чатов.
        await _reloadDialogs(staleHistory: true);
        return;
      }
      // Пустой ответ с state.pts == нашему (параллельная запись ещё идёт) —
      // pts остаётся, обновление придёт push'ем.
      final result = await _applyBatch(response.updates, setPts: response.state.pts.toInt());
      await _catchUpChats(result.chatGaps);
      if (!response.hasMore) return;
    }
  }

  // --- журналы групп ---

  /// Предел групп в одном `GetChatsState` (как на сервере).
  static const _chatsStateLimit = 500;

  /// После подключения: у каких моих групп журнал ушёл вперёд (их догоняем
  /// [_getChatDifference]) и из каких меня уже нет (удаляем локально).
  Future<void> _syncGroups() async {
    final user = me;
    // Каналы без подписки (4.4) сервер счёл бы «ушедшими» — их догоняет
    // `Chats.Watch` при открытии окна.
    final groups = [
      for (final g in await _store.groups(userID: user))
        if (showsChatType(g.info.type.value) && !g.browsing) g,
    ];
    for (var from = 0; from < groups.length; from += _chatsStateLimit) {
      final chunk = groups.sublist(from, math.min(groups.length, from + _chatsStateLimit));
      final response = await chats(
        pb.Chats_Request(
          getChatsState: pb.Chats_GetChatsState(
            chats: [for (final g in chunk) pb.Chats_ChatPts(chatID: g.chatID, pts: Int64(g.pts))],
          ),
        ),
      );
      final state = response.getChatsState;
      if (state.gone.isNotEmpty) {
        await _store.transaction((tx) async {
          for (final chatID in state.gone) {
            _logger.info('chats: group ${idHex(chatID)} gone');
            await tx.deleteDialog(userID: user, chatID: chatID);
            unawaited(PushManager.clearChatNotifications(chatID, all: true));
          }
        });
      }
      await _catchUpChats([for (final c in state.changed) Uint8List.fromList(c.chatID)]);
    }
  }

  /// Догнать журналы [chatIDs] (дыра в пачке / изменились, пока нас не было).
  /// Без сети — при следующем подключении.
  Future<void> _catchUpChats(List<Uint8List> chatIDs) async {
    for (final chatID in chatIDs) {
      try {
        await _getChatDifference(chatID);
      } on ChatsRequestException catch (error) {
        _logger.warning('chats: chat difference ${idHex(chatID)} failed: $error');
      }
    }
  }

  /// `GetChatDifference` от pts группы, пока сервер говорит `hasMore`.
  /// `tooLong` — журнал после нашего pts обрезан: диалог — из ответа, pts —
  /// его, кэш истории чата — несверенный (сверится при открытии).
  Future<void> _getChatDifference(Uint8List chatID) async {
    final user = me;
    final key = idHex(chatID);
    for (var page = 0; page < _maxDifferencePages; page++) {
      final group = await _store.group(userID: user, chatID: chatID);
      if (group == null) return;
      final response = await chats(
        pb.Chats_Request(
          getChatDifference: pb.Chats_GetChatDifference(chatID: chatID, pts: Int64(group.pts), limit: _pageLimit),
        ),
      );
      final diff = response.getChatDifference;
      if (diff.tooLong) {
        _logger.info('chats: chat difference too long $key');
        if (!diff.hasDialog()) return;
        await _store.transaction((tx) async {
          await tx.markChatHistoryStale(userID: user, chatID: chatID);
          await tx.upsertDialog(userID: user, dialog: diff.dialog);
          if (diff.dialog.hasChat()) await tx.upsertGroup(userID: user, dialog: diff.dialog, resetPts: true);
        });
        _noOlder.remove(key);
        return;
      }
      await _applyBatch(diff.updates, chatSetPts: {key: diff.pts.toInt()});
      if (!diff.hasMore) return;
    }
  }

  // --- обновления ---

  /// Push `UPDATES` по стриму (зовёт `API._handleMessage`). Не ждём: догон по
  /// дыре идёт по сети и не должен держать очередь входящих стрима.
  void handlePush(Uint8List payload) {
    if (!_enabled) return;
    final updates = pb.Updates.fromBuffer(payload);
    unawaited(applyLive(updates).catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)));
  }

  /// Как [applyUpdates], но вживую по стриму: новые входящие идут в [incoming].
  @visibleForTesting
  Future<void> applyLive(pb.Updates updates) => _locked(() => _applyUpdatesLocked(updates, live: true));

  /// Обновления из ответа на запрос или push: применить подряд идущие, при
  /// дыре — догнать.
  Future<void> applyUpdates(pb.Updates updates) => _locked(() => _applyUpdatesLocked(updates));

  /// [live] — push по стриму: новые входящие из него идут в [incoming].
  Future<void> _applyUpdatesLocked(pb.Updates updates, {bool live = false}) async {
    final result = await _applyBatch(updates.updates, statePts: updates.hasState() ? updates.state.pts.toInt() : 0, live: live);
    try {
      if (result.gap) await _getDifference();
      await _catchUpChats(result.chatGaps);
    } on ChatsOfflineException {
      // Догоним при следующем подключении.
    }
  }

  /// Применяет пачку в одной транзакции (диалоги + сообщения + pts атомарно).
  /// [setPts] — pts, до которого пачка покрывает журнал (ответ GET_DIFFERENCE);
  /// [chatSetPts] — то же для журналов групп (hex chatID → pts, ответ
  /// GetChatDifference). Обновления с `chatPts > 0` — журналы групп
  /// ([planChatUpdates]), применяются после журнала пользователя: его
  /// dialogNew из той же пачки заводит группу. Возвращает, есть ли дыра в
  /// журнале пользователя и в каких группах. [live] — push по стриму (см.
  /// [incoming]).
  Future<({bool gap, List<Uint8List> chatGaps})> _applyBatch(
    List<pb.Update> updates, {
    int statePts = 0,
    int? setPts,
    Map<String, int> chatSetPts = const {},
    bool live = false,
  }) async {
    final user = me;
    final followUps = _FollowUps();
    final own = <int>[];
    final shared = <int>[];
    for (final (i, update) in updates.indexed) {
      (update.chatPts > 0 ? shared : own).add(i);
    }
    final result = await _store.transaction((tx) async {
      final local = await tx.getPts(userID: user);
      // Журнал ещё не загружен — всё придёт полным списком при подключении.
      if (local == null) return (gap: false, chatGaps: const <Uint8List>[]);
      final plan = planUpdates(local, [for (final i in own) updates[i].pts.toInt()], statePts: setPts == null ? statePts : 0);
      for (final j in plan.apply) {
        await _applyOne(tx, user, updates[own[j]], followUps);
      }
      final pts = setPts == null ? plan.pts : math.max(plan.pts, setPts);
      if (pts != local) await tx.setPts(userID: user, pts: pts);

      final chatGaps = <Uint8List>[];
      if (shared.isNotEmpty || chatSetPts.isNotEmpty) {
        final known = {for (final g in await tx.groups(userID: user)) idHex(g.chatID): g.pts};
        final chatPlan = planChatUpdates(known, [
          for (final i in shared) (chatID: idHex(updates[i].chatID), chatPts: updates[i].chatPts.toInt()),
        ]);
        for (final MapEntry(key: chatID, value: chat) in chatPlan.chats.entries) {
          for (final i in chat.apply) {
            await _applyOne(tx, user, updates[shared[i]], followUps);
          }
          // Группу могли удалить этой же пачкой (dialogDeleted) — pts уже некуда.
          final ptsNow = math.max(chat.pts, chatSetPts[chatID] ?? 0);
          if (ptsNow != known[chatID]) await tx.setGroupPts(userID: user, chatID: idBytes(chatID), pts: ptsNow);
          if (chat.gap) chatGaps.add(idBytes(chatID));
        }
        // Ответ GetChatDifference без обновлений — pts всё равно сдвигается.
        for (final MapEntry(key: chatID, value: forced) in chatSetPts.entries) {
          if (chatPlan.chats.containsKey(chatID)) continue;
          final current = known[chatID];
          if (current != null && forced > current) await tx.setGroupPts(userID: user, chatID: idBytes(chatID), pts: forced);
        }
        if (chatPlan.unknown.isNotEmpty) _logger.debug('chats: ${chatPlan.unknown.length} updates of unknown groups skipped');
      }
      return (gap: plan.gap, chatGaps: chatGaps);
    });
    for (final chatID in followUps.membersChanged) {
      _membersChanged.add(chatID);
    }
    for (final chatID in followUps.joinRequestsChanged) {
      _joinRequestsChanged.add(chatID);
    }
    if (live) {
      for (final message in followUps.incoming) {
        final mentioned = followUps.mentions.remove((chatID: message.chatID, messageID: message.messageID));
        _incoming.add((chatID: message.chatID, messageID: message.messageID, fromUserID: message.fromUserID, mentioned: mentioned));
      }
      // Упоминание в сообщении из прошлой пачки (автор — в БД).
      for (final mention in followUps.mentions) {
        _incoming.add((chatID: mention.chatID, messageID: mention.messageID, fromUserID: '', mentioned: true));
      }
      followUps.replies.forEach(_repliesIncoming.add);
    }
    if (followUps.reloadDialogs || followUps.refreshTop.isNotEmpty || followUps.refreshPinned.isNotEmpty) {
      unawaited(_runFollowUps(followUps));
    }
    if (followUps.chatCatchUp.isEmpty) return result;
    final gaps = {for (final id in result.chatGaps) idHex(id)};
    return (gap: result.gap, chatGaps: [...result.chatGaps, ...followUps.chatCatchUp.where((id) => !gaps.contains(idHex(id)))]);
  }

  Future<void> _applyOne(ChatsRepository tx, Uint8List user, pb.Update update, _FollowUps followUps) async {
    switch (update.whichUpdate()) {
      case pb.Update_Update.newMessage:
        var message = update.newMessage.message;
        final chatID = message.chatID;
        // Пост канала без автора (fromUserID пуст): мой — по postOut (ответ
        // мне) или по своему outbox (общее обновление журнала его не несёт).
        final outgoing =
            sameID(message.fromUserID, user) ||
            message.postOut ||
            (message.fromUserID.isEmpty &&
                message.randomID != 0 &&
                await tx.outboxByRandomID(userID: user, randomID: message.randomID.toInt()) != null);
        if (outgoing && message.fromUserID.isEmpty && !message.postOut) message = message.deepCopy()..postOut = true;
        final fresh = update.newMessage.hasDialog();
        // Чат появился этим сообщением — диалог с сервера (счётчики уже в нём).
        if (fresh) await tx.upsertDialog(userID: user, dialog: update.newMessage.dialog);
        var dialog = await tx.dialog(userID: user, chatID: chatID);
        if (dialog == null) {
          // Диалога у нас нет, а сервер его не прислал — заводим пустой и
          // перечитываем список (у исходящего с другого устройства собеседник
          // неизвестен).
          await tx.ensureDialog(
            userID: user,
            chatID: chatID,
            peerUserID: outgoing || message.fromUserID.isEmpty ? null : message.fromUserID,
          );
          followUps.reloadDialogs = true;
          dialog = await tx.dialog(userID: user, chatID: chatID);
        }
        await tx.upsertMessage(userID: user, message: message, shared: update.chatPts > 0);
        // Написал — больше не «печатает…».
        if (!outgoing && message.fromUserID.isNotEmpty) ChatsTyping.instance.clear(chatID, message.fromUserID);
        final id = message.messageID.toInt();
        final top = dialog?.topMessageID ?? 0;
        if (id >= top) await tx.setTopMessage(userID: user, chatID: chatID, message: message);
        // Канал без подписки (4.4) — не диалог списка: ни счётчиков, ни баннера.
        final browsing =
            dialog?.type == pb.ChatType.CHAT_TYPE_CHANNEL.value && ((await tx.group(userID: user, chatID: chatID))?.browsing ?? false);
        if (outgoing) {
          // Наше (с этого или другого устройства) — из outbox, если оно оттуда.
          if (message.randomID != 0) await tx.deleteOutbox(userID: user, randomID: message.randomID.toInt());
        } else if (!browsing && !fresh && dialog != null && id > top && id > dialog.readInboxMaxID && !skipsUnread(message.content)) {
          // Новое входящее: счётчик локально, точное значение — с ReadInbox/Dialog.
          await tx.updateDialog(userID: user, chatID: chatID, fields: {'unreadCount': dialog.unreadCount + 1});
        }
        // Баннер в приложении — о новом непрочитанном (звонок — не сообщение:
        // о пропущенном есть свои уведомления).
        // Ветка комментариев — не диалог списка: ни баннера, ни счётчиков.
        final thread = dialog?.type == pb.ChatType.CHAT_TYPE_THREAD.value;
        if (!outgoing &&
            !thread &&
            !browsing &&
            !skipsUnread(message.content) &&
            !message.content.hasCall() &&
            id > (dialog?.readInboxMaxID ?? 0)) {
          followUps.incoming.add((chatID: idHex(chatID), messageID: id, fromUserID: idHex(message.fromUserID)));
        }

      case pb.Update_Update.editMessage:
        var message = update.editMessage.message;
        final chatID = message.chatID;
        final id = message.messageID.toInt();
        final dialog = await tx.dialog(userID: user, chatID: chatID);
        final cached = await tx.message(userID: user, chatID: chatID, messageID: id);
        // Мой пост канала остаётся моим (правка из журнала — без postOut).
        if (cached != null && cached.postOut && !message.postOut) message = message.deepCopy()..postOut = true;
        // Нет в кэше — не заводим «островок» в истории, подтянется с историей.
        if (cached != null || dialog?.topMessageID == id) {
          await tx.upsertMessage(userID: user, message: message, shared: update.chatPts > 0);
        }
        // Вложения заменили (Edit.replaceMedia) — скачанные старые на
        // устройстве больше не нужны, если на них ничто не ссылается; новые
        // скачаются под своими cdnID (кэш файлов — по cdnID, старый не
        // покажется вместо нового).
        if (cached != null) {
          final replaced = replacedMediaIDs(cached.content, message.content);
          if (replaced.isNotEmpty) ChatsRepository.onMediaReleased?.call(replaced);
        }
        if (dialog != null && dialog.topMessageID == id) await tx.setTopMessage(userID: user, chatID: chatID, message: message);
        // Комментарий из «Ответов» (4.6) — и там.
        if (dialog?.type == pb.ChatType.CHAT_TYPE_THREAD.value) await tx.updateReplyMessage(userID: user, message: message);

      case pb.Update_Update.deleteMessages:
        final chatID = update.deleteMessages.chatID;
        final ids = [for (final id in update.deleteMessages.messageIDs) id.toInt()];
        await _deleteLocally(tx, user, chatID, ids, followUps);

      case pb.Update_Update.readInbox:
        final read = update.readInbox;
        unawaited(PushManager.clearChatNotifications(read.chatID, maxID: read.maxID.toInt()));
        final dialog = await tx.dialog(userID: user, chatID: read.chatID);
        if (dialog == null) return;
        if (dialog.type == pb.ChatType.CHAT_TYPE_THREAD.value) {
          // Ветка: счётчик — по кэшу, и readMaxID у поста (точка гаснет).
          await tx.setThreadRead(userID: user, threadChatID: read.chatID, maxID: read.maxID.toInt());
          return;
        }
        await tx.updateDialog(
          userID: user,
          chatID: read.chatID,
          fields: {'readInboxMaxID': math.max(dialog.readInboxMaxID, read.maxID.toInt()), 'unreadCount': read.unreadCount},
        );

      case pb.Update_Update.readOutbox:
        final read = update.readOutbox;
        final dialog = await tx.dialog(userID: user, chatID: read.chatID);
        if (dialog == null) return;
        await tx.updateDialog(
          userID: user,
          chatID: read.chatID,
          fields: {'readOutboxMaxID': math.max(dialog.readOutboxMaxID, read.maxID.toInt())},
        );

      case pb.Update_Update.readContents:
        final read = update.readContents;
        _logger.info('chats: read contents applied chat=${idHex(read.chatID)} ids=${read.messageIDs} pts=${update.pts}');
        await tx.readContents(userID: user, chatID: read.chatID, messageIDs: [for (final id in read.messageIDs) id.toInt()]);

      case pb.Update_Update.dialogSettings:
        final dialog = update.dialogSettings.dialog;
        if (await tx.dialog(userID: user, chatID: dialog.chatID) == null) {
          await tx.upsertDialog(userID: user, dialog: dialog);
        } else {
          // Только настройки: последнее сообщение и счётчики ведут свои обновления.
          await tx.updateDialog(
            userID: user,
            chatID: dialog.chatID,
            fields: {
              'pinned': dialog.pinned ? 1 : 0,
              'archived': dialog.archived ? 1 : 0,
              'markedUnread': dialog.markedUnread ? 1 : 0,
              'mutedUntil': dialog.mutedUntil.toInt(),
              // Автоудаление (Chats.SetTTL — мной, собеседником или таймер по умолчанию).
              'ttlPeriod': dialog.ttlPeriod,
              // Защита содержимого (Chats.SetNoForwards).
              'noForwards': ChatsRepository.noForwardsColumn(dialog),
            },
          );
          await tx.setServerDraft(userID: user, chatID: dialog.chatID, draft: dialog.draft);
        }
        // Группа: моя роль / права / звание (назначили или сняли админа,
        // «Чтение» ⇄ «Запись», передали владение).
        if ((dialog.type == pb.ChatType.CHAT_TYPE_GROUP || dialog.type == pb.ChatType.CHAT_TYPE_CHANNEL) &&
            dialog.role != pb.ChatRole.CHAT_ROLE_NONE) {
          if (dialog.hasChat()) {
            await tx.upsertGroup(userID: user, dialog: dialog);
          } else if (await tx.group(userID: user, chatID: dialog.chatID) != null) {
            await tx.setGroupRole(
              userID: user,
              chatID: dialog.chatID,
              role: dialog.role,
              rights: dialog.rights,
              rank: dialog.rank,
              inviteCode: dialog.inviteCode,
              pendingRequests: dialog.pendingRequests,
            );
          }
          followUps.membersChanged.add(idHex(dialog.chatID));
        }

      case pb.Update_Update.dialogDeleted:
        _logger.info('chats: dialog deleted ${idHex(update.dialogDeleted.chatID)} pts=${update.pts}');
        await tx.deleteDialog(userID: user, chatID: update.dialogDeleted.chatID);
        unawaited(PushManager.clearChatNotifications(update.dialogDeleted.chatID, all: true));

      case pb.Update_Update.pinnedMessages:
        final pins = update.pinnedMessages;
        final missing = await tx.setPinned(
          userID: user,
          chatID: pins.chatID,
          messageIDs: [for (final id in pins.messageIDs) id.toInt()],
          pinned: pins.pinned,
          shared: pins.shared,
        );
        // Закрепили сообщение старше скачанной истории — содержимое с сервера.
        if (missing.isNotEmpty) followUps.refreshPinned.add(Uint8List.fromList(pins.chatID));

      case pb.Update_Update.messageReactions:
        final changed = update.messageReactions;
        final messageID = changed.messageID.toInt();
        // Канал (4.2): мой набор приходит в журнал пользователя без actor —
        // счётчики глазами меня целиком (снял все — ни одной chosenOrder, и
        // старые мои не должны остаться). Журнал канала — слитно, без actor:
        // свои не трогаем ([mergeSharedReactions]).
        final mine =
            update.chatPts == 0 &&
            changed.actorUserID.isEmpty &&
            (await tx.dialog(userID: user, chatID: changed.chatID))?.type == pb.ChatType.CHAT_TYPE_CHANNEL.value;
        // Группа: счётчики без моего порядка + кто изменил ([mergeSharedReactions]).
        final reactions = changed.reactions.counts.isEmpty || mine
            ? changed.reactions
            : mergeSharedReactions(
                await tx.messageReactions(userID: user, chatID: changed.chatID, messageID: messageID),
                changed.reactions,
                actorUserID: changed.actorUserID,
                actorEmojis: changed.actorEmojis,
                myUserID: user,
              );
        // Непрочитанные реакции автору — только в журнале пользователя; в
        // общем журнале группы счётчик и флаг не значимы.
        final own = update.chatPts == 0;
        await tx.setReactions(
          userID: user,
          chatID: changed.chatID,
          messageID: messageID,
          reactions: reactions,
          unread: own ? changed.reactionsUnread : null,
        );
        if (own) await tx.updateDialog(userID: user, chatID: changed.chatID, fields: {'unreadReactions': changed.unreadReactionsCount});

      case pb.Update_Update.mentions:
        // Упоминания меня в группе (журнал пользователя): новые / прочитаны /
        // сообщения удалены; счётчик — как на сервере.
        final mentions = update.mentions;
        final ids = [for (final id in mentions.messageIDs) id.toInt()];
        if (mentions.unread) {
          await tx.addMentions(userID: user, chatID: mentions.chatID, messageIDs: ids);
          for (final id in ids) {
            followUps.mentions.add((chatID: idHex(mentions.chatID), messageID: id));
          }
        } else {
          await tx.removeMentions(userID: user, chatID: mentions.chatID, messageIDs: ids.isEmpty ? null : ids);
        }
        await tx.updateDialog(userID: user, chatID: mentions.chatID, fields: {'unreadMentions': mentions.unreadMentionsCount});

      case pb.Update_Update.messagePoll:
        // Итоги опроса. Общий журнал чата (или с actor) — без моего выбора:
        // свой выбор меняю, только если голосовал я; журнал пользователя без
        // actor — глазами меня целиком.
        final changed = update.messagePoll;
        final messageID = changed.messageID.toInt();
        final shared = update.chatPts > 0 || changed.actorUserID.isNotEmpty;
        final stored = await tx.pollResults(userID: user, chatID: changed.chatID, messageID: messageID);
        await tx.setPollResults(
          userID: user,
          chatID: changed.chatID,
          messageID: messageID,
          results: mergePollResults(
            stored,
            changed.results,
            shared: shared,
            actorIsMe: changed.actorUserID.isNotEmpty && sameID(changed.actorUserID, user),
            actorOptions: changed.actorOptions,
          ),
        );

      case pb.Update_Update.readReactions:
        final read = update.readReactions;
        final ids = [for (final id in read.messageIDs) id.toInt()];
        await tx.readReactions(userID: user, chatID: read.chatID, messageIDs: ids);
        await tx.updateDialog(userID: user, chatID: read.chatID, fields: {'unreadReactions': read.unreadReactionsCount});
        // Пуш о реакции несёт id моего сообщения — снимаем по нему.
        unawaited(PushManager.clearChatNotifications(read.chatID, messageIDs: ids));

      case pb.Update_Update.scheduledMessage:
        await tx.upsertScheduled(userID: user, message: update.scheduledMessage.message);

      case pb.Update_Update.scheduledDeleted:
        final deleted = update.scheduledDeleted;
        if (deleted.reason == pb.Update_ScheduledDeleted_Reason.FAILED) {
          _logger.warning('chats: scheduled not sent chat=${idHex(deleted.chatID)} ids=${deleted.scheduledIDs}');
        }
        await tx.deleteScheduled(userID: user, chatID: deleted.chatID, scheduledIDs: [for (final id in deleted.scheduledIDs) id.toInt()]);

      case pb.Update_Update.folders:
        await tx.setFolders(userID: user, folders: update.folders);

      case pb.Update_Update.dialogNew:
        // Меня добавили в группу (создал, добавили): диалог + сведения + pts
        // журнала чата. Снимок мог отстать от уже разосланного журнала —
        // догоняем этот чат после пачки.
        final dialog = update.dialogNew.dialog;
        _logger.info('chats: dialog new ${idHex(dialog.chatID)} pts=${update.pts} chatPts=${dialog.chat.pts}');
        await tx.upsertDialog(userID: user, dialog: dialog);
        if (dialog.hasChat()) followUps.chatCatchUp.add(Uint8List.fromList(dialog.chatID));

      case pb.Update_Update.chatInfo:
        // Название / описание / аватар / число участников — журнал чата; pts
        // ведёт сам журнал.
        final info = update.chatInfo.chat;
        if (await tx.group(userID: user, chatID: info.chatID) != null) await tx.setGroupInfo(userID: user, info: info);

      case pb.Update_Update.chatMembers:
        final changed = update.chatMembers;
        final chatID = changed.chatID.isNotEmpty ? changed.chatID : update.chatID;
        final group = await tx.group(userID: user, chatID: chatID);
        if (group == null) return;
        await tx.upsertGroupMembers(userID: user, chatID: chatID, members: changed.added);
        // Роль / права / звание (админы, «Чтение» ⇄ «Запись», владение).
        await tx.upsertGroupMembers(userID: user, chatID: chatID, members: changed.updated);
        await tx.removeGroupMembers(userID: user, chatID: chatID, memberUserIDs: changed.removedUserIDs);
        // Только смена ролей (updated) может прийти без числа участников.
        if (changed.membersCount > 0 || changed.added.isNotEmpty || changed.removedUserIDs.isNotEmpty) {
          await tx.setGroupInfo(userID: user, info: group.info.deepCopy()..membersCount = changed.membersCount);
        }
        followUps.membersChanged.add(idHex(chatID));

      case pb.Update_Update.joinRequests:
        // Заявки на вступление (журнал пользователя — только владельцу и
        // админам с правом приглашать): число — в плашку «Заявки на
        // вступление», открытый список перечитается.
        final requests = update.joinRequests;
        await tx.setGroupPendingRequests(userID: user, chatID: requests.chatID, pending: requests.pendingCount);
        followUps.joinRequestsChanged.add(idHex(requests.chatID));

      case pb.Update_Update.postComments:
        // Комментарии к посту (журнал канала, слитно): число, последние
        // комментаторы, срок / «закрыто», ветка. Моего readMaxID в нём нет —
        // не уменьшаем ([mergeComments]).
        final changed = update.postComments;
        final chatID = changed.chatID.isNotEmpty ? changed.chatID : update.chatID;
        await tx.setPostComments(userID: user, chatID: chatID, postID: changed.postID.toInt(), comments: changed.comments);
        // Ветка уже открыта у меня — её срок тоже (закрыли / открыли).
        final thread = await tx.thread(userID: user, chatID: chatID, postID: changed.postID.toInt());
        final info = thread == null ? null : (await tx.group(userID: user, chatID: thread))?.info;
        if (info != null && info.commentsCloseDate != changed.comments.closeDate) {
          await tx.setGroupInfo(userID: user, info: info.deepCopy()..commentsCloseDate = changed.comments.closeDate);
        }

      case pb.Update_Update.replies:
        // «Ответы» (4.6, журнал пользователя): новый ответ / прочитано /
        // удалено; число непрочитанных — как на сервере.
        final changed = update.replies;
        if (changed.hasReply()) await tx.upsertReply(userID: user, reply: changed.reply);
        await tx.deleteReplies(userID: user, replyIDs: [for (final id in changed.deletedIDs) id.toInt()]);
        // Прочитаны чтением своей ветки (readMaxID «Ответов» не меняется).
        await tx.markRepliesRead(userID: user, replyIDs: [for (final id in changed.readIDs) id.toInt()]);
        await tx.setRepliesState(userID: user, readMaxID: changed.readMaxID.toInt(), unreadCount: changed.unreadCount);
        if (changed.hasReply() &&
            !changed.reply.read &&
            !changed.deletedIDs.contains(changed.reply.replyID) &&
            !changed.readIDs.contains(changed.reply.replyID)) {
          final read = (await tx.repliesState(userID: user))?.readMaxID ?? 0;
          if (changed.reply.replyID > read) followUps.replies.add(changed.reply);
        }

      case pb.Update_Update.notSet:
        // Пустое обновление (например, новое сообщение, которое потом удалили):
        // ничего не меняем, но pts сдвигается — это не дыра.
        _logger.debug('chats: empty update pts=${update.pts}');
    }
  }

  /// Удаляет сообщения из кэша (Update.deleteMessages, автоудаление) и
  /// поправляет счётчики и последнее сообщение диалога.
  Future<void> _deleteLocally(ChatsRepository tx, Uint8List user, List<int> chatID, List<int> ids, _FollowUps followUps) async {
    final dialog = await tx.dialog(userID: user, chatID: chatID);
    // Удаляются мои с непрочитанными реакциями — бейдж ❤️ меньше.
    _messagesDeleted.add((chatID: idHex(chatID), messageIDs: [for (final id in ids) '$id']));
    final reactions = await tx.countUnreadReactions(userID: user, chatID: chatID, messageIDs: ids);
    final unread = await tx.deleteMessages(userID: user, chatID: chatID, messageIDs: ids, readInboxMaxID: dialog?.readInboxMaxID ?? 0);
    unawaited(PushManager.clearChatNotifications(chatID, messageIDs: ids));
    if (dialog == null) return;
    if (unread > 0 || reactions > 0) {
      await tx.updateDialog(
        userID: user,
        chatID: chatID,
        fields: {
          'unreadCount': math.max(0, dialog.unreadCount - unread),
          'unreadReactions': math.max(0, dialog.unreadReactions - reactions),
        },
      );
    }
    if (ids.contains(dialog.topMessageID)) {
      // Удалили последнее — новое последнее из кэша; кэш пуст — спросим сервер.
      final latest = await tx.latestMessage(userID: user, chatID: chatID);
      await tx.setTopMessage(userID: user, chatID: chatID, message: latest);
      if (latest == null) followUps.refreshTop.add(Uint8List.fromList(chatID));
    }
  }

  // --- автоудаление ---

  /// Как часто проверять истёкшие (сообщение пропадает не позже чем через
  /// столько после срока).
  static const _sweepEvery = Duration(seconds: 5);

  Timer? _sweepTimer;

  /// Автоудаление на этом устройстве — пока включены серверные чаты.
  void _watchExpired(bool enabled) {
    _sweepTimer?.cancel();
    _sweepTimer = null;
    if (!enabled) return;
    unawaited(sweepExpired());
    _sweepTimer = Timer.periodic(_sweepEvery, (_) => unawaited(sweepExpired()));
  }

  /// Удаляет у себя сообщения с истёкшим автоудалением (ChatMessage.ttlPeriod)
  /// — в срок и без сети, как в Telegram; сервер удалит их у всех сам
  /// (Update.deleteMessages потом ничего не найдёт).
  Future<void> sweepExpired() async {
    if (!_auth.isAuthorized) return;
    try {
      final user = me;
      // Чаще всего истёкших нет — без очереди и транзакции записи.
      if ((await _store.expiredMessages(userID: user, now: DateTime.now().millisecondsSinceEpoch)).isEmpty) return;
      final followUps = _FollowUps();
      await _locked(
        () => _store.transaction((tx) async {
          final expired = await tx.expiredMessages(userID: user, now: DateTime.now().millisecondsSinceEpoch);
          for (final chat in expired.values) {
            _logger.debug('chats: expired ${chat.messageIDs.length} in ${idHex(chat.chatID)}');
            await _deleteLocally(tx, user, chat.chatID, chat.messageIDs, followUps);
          }
        }),
      );
      if (followUps.refreshTop.isNotEmpty) unawaited(_runFollowUps(followUps));
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Дозапросы после применения (вне транзакции и очереди): последнее
  /// сообщение чата, у которого кэш опустел, и список диалогов.
  Future<void> _runFollowUps(_FollowUps followUps) async {
    try {
      for (final chatID in followUps.refreshTop) {
        await loadHistory(chatID, limit: 1);
      }
      for (final chatID in followUps.refreshPinned) {
        await loadPinned(chatID);
      }
      if (followUps.reloadDialogs) {
        await _locked(() async {
          await _reloadDialogs();
          await _getDifference();
        });
      }
    } on ChatsOfflineException {
      // Подтянется при следующем подключении.
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Группы у меня больше нет (вышел / удалил — сервер принял): диалог,
  /// история и участники — из кэша, не дожидаясь dialogDeleted по стриму.
  Future<void> forgetChat(Uint8List chatID) {
    final user = me;
    return _locked(() async {
      await _store.transaction((tx) => tx.deleteDialog(userID: user, chatID: chatID));
      unawaited(PushManager.clearChatNotifications(chatID, all: true));
    });
  }

  /// Диалог из ответа (OpenPrivate) — в кэш, в общей очереди с обновлениями.
  Future<void> saveDialog(pb.Dialog dialog) {
    final user = me;
    return _locked(
      () => _store.transaction((tx) async {
        await tx.upsertDialog(userID: user, dialog: dialog);
        // Подписались на канал, который читали без подписки (4.4), а сведений
        // в ответе нет: роль — из диалога, иначе он так и остался бы вне списка.
        if (dialog.hasChat() || dialog.role == pb.ChatRole.CHAT_ROLE_NONE) return;
        if ((await tx.group(userID: user, chatID: dialog.chatID))?.browsing ?? false) {
          await tx.setGroupRole(
            userID: user,
            chatID: dialog.chatID,
            role: dialog.role,
            rights: dialog.rights,
            rank: dialog.rank,
            inviteCode: dialog.inviteCode,
            pendingRequests: dialog.pendingRequests,
          );
        }
      }),
    );
  }

  // --- история ---

  /// Последние [limit] сообщений чата с сервера — в кэш (открытие чата). Нет
  /// сети — молча: показываем кэш.
  ///
  /// Кэш истории сверен с сервером и непрерывен выше границы
  /// `historyStaleBelow` (новые приходят журналом без дыр, старые — страницами
  /// [loadOlder]). Ниже неё — несверенное после долгого офлайна (`tooLong`)
  /// или дыры (свежая страница не дотянулась до кэша): его показываем, а
  /// страницы с сервера сверяют и сдвигают границу вниз
  /// ([ChatsRepository.applyHistoryPage]).
  Future<void> loadHistory(Uint8List chatID, {int limit = _pageLimit}) async {
    if (!await hasNetwork()) return;
    final response = await messages(
      pb.Messages_Request(
        history: pb.Messages_History(chatID: chatID, offsetID: Int64.ZERO, limit: limit),
      ),
    );
    final history = response.history.messages;
    final hasMore = response.history.hasMore;
    final user = me;
    if (!hasMore) _noOlder.add(idHex(chatID));
    await _locked(
      () => _store.transaction((tx) async {
        final dialog = await tx.dialog(userID: user, chatID: chatID);
        if (dialog == null) return;
        final stale = await tx.applyHistoryPage(userID: user, chatID: chatID, messages: history, offsetID: 0, hasMore: hasMore);
        // Ниже есть несверенное — [loadOlder] пойдёт к нему.
        if (stale > 0) _noOlder.remove(idHex(chatID));
        // Ветка: сервер счётчик непрочитанного не ведёт — считаем по кэшу (окно
        // чата прочитает их и сдвинет readMaxID у поста).
        if (dialog.type == pb.ChatType.CHAT_TYPE_THREAD.value) {
          final unread = await tx.countIncomingAfter(userID: user, chatID: chatID, afterID: dialog.readInboxMaxID);
          if (unread != dialog.unreadCount) await tx.updateDialog(userID: user, chatID: chatID, fields: {'unreadCount': unread});
        }
        // История DESC: первое — самое новое.
        final newest = history.isEmpty ? null : history.first;
        if (newest != null && newest.messageID.toInt() >= dialog.topMessageID) {
          await tx.setTopMessage(userID: user, chatID: chatID, message: newest);
        }
      }),
    );
  }

  /// Закреплённые сообщения чата с сервера — в кэш (открытие чата; закрепили
  /// то, чего нет в кэше истории). Нет сети — молча: показываем кэш.
  Future<void> loadPinned(Uint8List chatID) async {
    if (!await hasNetwork()) return;
    final response = await messages(pb.Messages_Request(pinned: pb.Messages_Pinned(chatID: chatID)));
    final pinned = response.pinned.messages;
    final user = me;
    await _locked(
      () => _store.transaction((tx) async {
        if (await tx.dialog(userID: user, chatID: chatID) == null) return;
        await tx.replacePinned(
          userID: user,
          chatID: chatID,
          messages: pinned,
          sharedIDs: {for (final id in response.pinned.sharedIDs) id.toInt()},
        );
      }),
    );
  }

  /// Сообщение с сервера заново (Messages.Get) — со свежими ссылками на файлы:
  /// старая ссылка на вложение не открылась (истёк срок, файл переехал в другое
  /// хранилище). Есть в кэше — обновляем там. Не видно / удалено — null.
  Future<pb.ChatMessage?> refreshMessage(Uint8List chatID, int messageID) async {
    final response = await messages(
      pb.Messages_Request(
        get: pb.Messages_Get(chatID: chatID, messageIDs: [Int64(messageID)]),
      ),
    );
    final found = response.get.messages.where((m) => m.messageID.toInt() == messageID).firstOrNull;
    if (found == null) return null;
    final user = me;
    await _locked(
      () => _store.transaction((tx) async {
        if (await tx.message(userID: user, chatID: chatID, messageID: messageID) != null) {
          await tx.upsertMessage(userID: user, message: found);
        }
      }),
    );
    return found;
  }

  /// Итоги опроса глазами меня (ответ VotePoll / ClosePoll) — в кэш.
  Future<void> savePollResults(Uint8List chatID, int messageID, pb.PollResults results) {
    final user = me;
    return _locked(() => _store.setPollResults(userID: user, chatID: chatID, messageID: messageID, results: results));
  }

  /// Найденное поиском на сервере — в кэш (см. [ChatsRepository.applySearchHits]),
  /// в общей очереди с обновлениями.
  Future<void> saveSearchHits(Uint8List chatID, List<pb.ChatMessage> found) {
    final user = me;
    return _locked(
      () => _store.transaction((tx) async {
        if (await tx.dialog(userID: user, chatID: chatID) == null) return;
        await tx.applySearchHits(userID: user, chatID: chatID, messages: found);
      }),
    );
  }

  /// Страница истории с сервера как есть — для окна «вокруг сообщения»
  /// (`HistoryWindow`): [aroundID] — окно вокруг него (половина — оно и
  /// старше, половина — новее), иначе — старше [offsetID]. Без сети —
  /// [ChatsOfflineException].
  Future<pb.Messages_HistoryResult> historyPage(Uint8List chatID, {int offsetID = 0, int aroundID = 0, required int limit}) async {
    if (!await hasNetwork()) throw const ChatsOfflineException();
    final response = await messages(
      pb.Messages_Request(
        history: pb.Messages_History(chatID: chatID, offsetID: Int64(offsetID), aroundID: Int64(aroundID), limit: limit),
      ),
    );
    return response.history;
  }

  /// Страница окна, оторванного от ленты, — в кэш скрытой из ленты
  /// (`ChatsRepository.applyWindowPage`).
  Future<void> applyWindowPage(Uint8List chatID, List<pb.ChatMessage> page, {required int from, required int to}) {
    final user = me;
    return _locked(
      () => _store.transaction((tx) async {
        if (await tx.dialog(userID: user, chatID: chatID) == null) return;
        await tx.applyWindowPage(userID: user, chatID: chatID, messages: page, from: from, to: to);
      }),
    );
  }

  /// Окно дошло до ленты — оно становится её частью
  /// (`ChatsRepository.joinWindow`).
  Future<void> joinWindow(Uint8List chatID, List<pb.ChatMessage> window, {required bool hasOlder, required bool reachesTop}) async {
    final user = me;
    await _locked(
      () => _store.transaction((tx) async {
        if (await tx.dialog(userID: user, chatID: chatID) == null) return;
        await tx.joinWindow(userID: user, chatID: chatID, messages: window, hasOlder: hasOlder, reachesTop: reachesTop);
      }),
    );
    if (!hasOlder) _noOlder.add(idHex(chatID));
  }

  /// История чата скачана до самого начала и сверена: сервер старше ничего
  /// не отдаст (поиск на сервере не нужен).
  Future<bool> historyComplete(Uint8List chatID) async {
    final user = me;
    if (await _store.historyStaleBelow(userID: user, chatID: chatID) > 0) return false;
    if (_noOlder.contains(idHex(chatID))) return true;
    return await _store.oldestMessageID(userID: user, chatID: chatID) == 1;
  }

  /// Чаты, у которых на сервере старше уже нет (hex chatID).
  final _noOlder = <String>{};

  /// Следующая страница истории старше сверенной части кэша (несверенной
  /// нет — старше самого старого в кэше); несверенное в её диапазоне
  /// сверяется ([ChatsRepository.applyHistoryPage]). Возвращает,
  /// сколько сообщений пришло, и есть ли ещё (false — дошли до начала). Нет
  /// сети — (0, true): попробуем при следующей прокрутке.
  Future<({int loaded, bool hasMore})> loadOlder(Uint8List chatID) {
    // Прокрутка и фоновая докачка могут попросить одну и ту же страницу —
    // один запрос на чат за раз.
    final key = idHex(chatID);
    return _olderInFlight[key] ??= _loadOlder(chatID).whenComplete(() => _olderInFlight.remove(key));
  }

  final _olderInFlight = <String, Future<({int loaded, bool hasMore})>>{};

  Future<({int loaded, bool hasMore})> _loadOlder(Uint8List chatID) async {
    final key = idHex(chatID);
    if (_noOlder.contains(key)) return (loaded: 0, hasMore: false);
    if (!await hasNetwork()) return (loaded: 0, hasMore: true);
    final user = me;
    final stale = await _store.historyStaleBelow(userID: user, chatID: chatID);
    final offset = stale > 0 ? stale : await _store.oldestMessageID(userID: user, chatID: chatID);
    // Самое старое (сверенное) — №1: старше нет.
    if (offset == 1) {
      _noOlder.add(key);
      return (loaded: 0, hasMore: false);
    }
    final response = await messages(
      pb.Messages_Request(
        history: pb.Messages_History(chatID: chatID, offsetID: Int64(offset), limit: _pageLimit),
      ),
    );
    final history = response.history.messages;
    await _locked(
      () => _store.transaction((tx) async {
        if (await tx.dialog(userID: user, chatID: chatID) == null) return;
        // Пустой кэш (offset 0) — это самая новая страница.
        await tx.applyHistoryPage(userID: user, chatID: chatID, messages: history, offsetID: offset, hasMore: response.history.hasMore);
      }),
    );
    if (!response.history.hasMore) _noOlder.add(key);
    return (loaded: history.length, hasMore: response.history.hasMore);
  }

  // --- докачка всей истории ---

  /// Чаты, чью историю докачиваем (hex chatID → chatID), по очереди открытия.
  final _backfillQueue = <String, Uint8List>{};
  bool _backfilling = false;

  /// Пауза между страницами докачки — не забивать канал и сервер.
  static const _backfillPause = Duration(milliseconds: 300);

  /// Докачать в фоне всю историю открытого чата — от самого старого в кэше до
  /// первого сообщения, страницами по [_pageLimit]: локальный поиск (FTS5)
  /// идёт по скачанному, сервер ищет лишь по целым словам (подэтап 3.6). По
  /// одному чату за раз; нет сети — остановится и продолжит при следующем
  /// подключении ([onConnected]).
  void backfill(Uint8List chatID) {
    if (!_enabled) return;
    final key = idHex(chatID);
    if (_noOlder.contains(key)) return;
    _backfillQueue[key] = chatID;
    unawaited(_runBackfill());
  }

  Future<void> _runBackfill() async {
    if (_backfilling) return;
    _backfilling = true;
    try {
      while (_backfillQueue.isNotEmpty && _enabled && _auth.isAuthorized) {
        final key = _backfillQueue.keys.first;
        final result = await loadOlder(_backfillQueue[key]!);
        if (!result.hasMore) {
          _backfillQueue.remove(key);
          continue;
        }
        // Ничего не пришло, а старше есть — нет сети: ждём подключения.
        if (result.loaded == 0) return;
        await Future<void>.delayed(_backfillPause);
      }
    } catch (error, stackTrace) {
      // Чат остаётся в очереди — повторим при следующем подключении.
      if (error is! ChatsOfflineException) _logger.handle(error, stackTrace);
    } finally {
      _backfilling = false;
    }
  }

  // --- «Ответы» (подэтап 4.6) ---

  /// Страница `Messages.Replies` (≤ 100, сервер по умолчанию — 50).
  static const _repliesPage = 50;

  /// Журнал отстал (полный список диалогов) — первая страница «Ответов»
  /// заново при следующем догоне.
  bool _repliesReload = false;

  Future<pb.Messages_RepliesResult> _requestReplies(int offsetID) async {
    final response = await messages(
      pb.Messages_Request(
        replies: pb.Messages_Replies(offsetID: Int64(offsetID), limit: _repliesPage),
      ),
    );
    return response.replies;
  }

  /// Страница «Ответов» — в кэш. [first] — первая (с начала): readMaxID и
  /// число непрочитанных из неё; [replace] — кэш с нуля (и курсор — её);
  /// иначе (более старая) — только курсор дальше.
  Future<void> _saveRepliesPage(
    ChatsRepository tx,
    Uint8List user,
    pb.Messages_RepliesResult page, {
    required bool first,
    bool replace = false,
  }) async {
    if (replace) await tx.clearReplies(userID: user);
    for (final reply in page.replies) {
      await tx.upsertReply(userID: user, reply: reply);
    }
    await tx.saveRepliesChats(userID: user, chats: page.chats);
    if (first) {
      await tx.setRepliesState(
        userID: user,
        readMaxID: page.readMaxID.toInt(),
        unreadCount: page.unreadCount,
        nextOffsetID: replace ? page.nextOffsetID.toInt() : null,
        loaded: true,
      );
    } else {
      await tx.setRepliesState(userID: user, nextOffsetID: page.nextOffsetID.toInt());
    }
  }

  /// Догон (внутри [_locked]): первой страницы ещё не было или журнал
  /// отстал — кэш «Ответов» с нуля. Сбой — не повод ронять догон.
  Future<void> _syncReplies() async {
    final user = me;
    if (!_repliesReload && ((await _store.repliesState(userID: user))?.loaded ?? false)) return;
    try {
      final page = await _requestReplies(0);
      await _store.transaction((tx) => _saveRepliesPage(tx, user, page, first: true, replace: true));
      _repliesReload = false;
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: replies load failed: $error');
    }
  }

  /// Экран «Ответы» открыт: свежая первая страница поверх кэша (без сети —
  /// молча, показываем кэш).
  Future<void> refreshReplies() async {
    if (!_auth.isAuthorized || !await hasNetwork()) return;
    final page = await _requestReplies(0);
    final user = me;
    await _locked(
      () => _store.transaction((tx) async {
        final loaded = (await tx.repliesState(userID: user))?.loaded ?? false;
        await _saveRepliesPage(tx, user, page, first: true, replace: !loaded);
      }),
    );
  }

  /// Следующая (более старая) страница «Ответов»; `false` — дальше нет. Нет
  /// сети — [ChatsOfflineException] (попробуем при следующей прокрутке).
  Future<bool> loadOlderReplies() async {
    if (!_auth.isAuthorized) return false;
    final user = me;
    final state = await _store.repliesState(userID: user);
    if (state != null && state.loaded && state.nextOffsetID == 0) return false;
    if (!await hasNetwork()) throw const ChatsOfflineException();
    if (state == null || !state.loaded) {
      await refreshReplies();
      return ((await _store.repliesState(userID: user))?.nextOffsetID ?? 0) != 0;
    }
    final page = await _requestReplies(state.nextOffsetID);
    await _locked(() => _store.transaction((tx) => _saveRepliesPage(tx, user, page, first: false)));
    return page.nextOffsetID != 0;
  }

  /// До какого replyID прочитать (ещё не ушло на сервер); 0 — нечего.
  int _repliesReadPending = 0;
  bool _readingReplies = false;

  /// Показали «Ответы» до [maxID] — на сервер сейчас или при подключении
  /// (как ReadHistory: без сети счётчик честно остаётся до ответа сервера).
  Future<void> readReplies(int maxID) async {
    if (maxID <= _repliesReadPending || !_auth.isAuthorized) return;
    if (maxID <= ((await _store.repliesState(userID: me))?.readMaxID ?? 0)) return;
    _repliesReadPending = maxID;
    await flushRepliesRead();
  }

  /// «Прочитать все» (меню строки «Ответы»): явное действие — без сети
  /// [ChatsOfflineException].
  Future<void> readAllReplies() async {
    if (!await hasNetwork()) throw const ChatsOfflineException();
    final newest = await _store.replies(userID: me, limit: 1);
    if (newest.isEmpty) return;
    await readReplies(newest.first.replyID.toInt());
  }

  /// Отправить отложенное прочтение «Ответов» ([readReplies]).
  Future<void> flushRepliesRead() async {
    if (_readingReplies || _repliesReadPending == 0 || !_auth.isAuthorized) return;
    if (!await hasNetwork()) return;
    _readingReplies = true;
    final maxID = _repliesReadPending;
    try {
      final response = await messages(pb.Messages_Request(readReplies: pb.Messages_ReadReplies(maxID: Int64(maxID))));
      if (_repliesReadPending == maxID) _repliesReadPending = 0;
      final user = me;
      await _locked(() async {
        await _applyUpdatesLocked(response.readReplies.updates);
        // Обновления в ответе не оказалось (уже применено / журнал не загружен)
        // — прочитано всё равно: readMaxID и счётчик по кэшу.
        final state = await _store.repliesState(userID: user);
        if ((state?.readMaxID ?? 0) < maxID) {
          final left = await _store.countRepliesAfter(userID: user, afterID: maxID);
          await _store.setRepliesState(userID: user, readMaxID: maxID, unreadCount: math.min(state?.unreadCount ?? 0, left));
        }
      });
    } on ChatsOfflineException {
      // Уйдёт при подключении.
    } on ChatsRequestException catch (error) {
      _logger.warning('chats: read replies failed: $error');
      if (_repliesReadPending == maxID) _repliesReadPending = 0;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    } finally {
      _readingReplies = false;
    }
    if (_repliesReadPending > maxID) await flushRepliesRead();
  }

  // --- outbox ---

  bool _flushing = false;

  /// Пока шла отправка, в outbox добавили ещё — пройти снова.
  bool _flushAgain = false;

  /// Лимит частоты отправки: до этого момента outbox стоит (сообщения ждут с
  /// часиками), потом [_floodTimer] сам его отправит. `null` — не ждём.
  DateTime? _floodUntil;
  Timer? _floodTimer;
  final _floodChanged = StreamController<DateTime?>.broadcast();

  DateTime? get floodUntil {
    final until = _floodUntil;
    return until != null && until.isAfter(DateTime.now()) ? until : null;
  }

  /// Изменился [floodUntil] — окно чата ведёт по нему обратный отсчёт.
  Stream<DateTime?> get floodChanged => _floodChanged.stream;

  void _setFlood(int seconds) {
    final until = DateTime.now().add(Duration(seconds: seconds));
    _floodUntil = until;
    _floodTimer?.cancel();
    _floodTimer = Timer(until.difference(DateTime.now()), () {
      _floodUntil = null;
      _floodChanged.add(null);
      unawaited(flushOutbox());
    });
    _floodChanged.add(until);
  }

  /// Отправить накопленное в outbox по порядку. Нет сети / сервер недоступен —
  /// остаётся до следующего подключения; сервер отклонил — помечаем `failed`
  /// и больше не шлём.
  Future<void> flushOutbox() async {
    if (!_auth.isAuthorized) return;
    if (_flushing) {
      _flushAgain = true;
      return;
    }
    _flushing = true;
    try {
      do {
        _flushAgain = false;
        if (!await _flushOnce()) return;
      } while (_flushAgain);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    } finally {
      _flushing = false;
      unawaited(_cleanOutboxFiles());
    }
  }

  /// Медленный режим групп: до какого времени ждёт outbox чата (hex chatID)
  /// — его сообщения стоят с часиками, по таймеру уходят сами; остальные
  /// чаты не ждут.
  final _slowModeWait = <String, DateTime>{};
  final _slowModeTimers = <String, Timer>{};

  bool _slowModeWaiting(Uint8List? chatID) {
    if (chatID == null) return false;
    final until = _slowModeWait[idHex(chatID)];
    return until != null && until.isAfter(DateTime.now());
  }

  /// Сервер ответил «slowModeWait»: отсчёт в окне чата (`Chat.slowModeUntil`)
  /// и повтор, когда он закончится.
  Future<void> _waitSlowMode(Uint8List chatID, int seconds) async {
    final key = idHex(chatID);
    final until = DateTime.now().add(Duration(seconds: seconds));
    _slowModeWait[key] = until;
    _slowModeTimers[key]?.cancel();
    _slowModeTimers[key] = Timer(until.difference(DateTime.now()), () {
      _slowModeWait.remove(key);
      _slowModeTimers.remove(key);
      unawaited(flushOutbox());
    });
    final user = me;
    await _locked(() => _store.setGroupSlowModeUntil(userID: user, chatID: chatID, until: until.millisecondsSinceEpoch));
  }

  /// Один проход по outbox; `false` — прервались (нет сети / разлогин).
  Future<bool> _flushOnce() async {
    final user = me;
    // Ждём лимит частоты — отправит таймер (_setFlood).
    if (floodUntil != null) return false;
    for (final row in await _store.outbox(userID: user)) {
      if (row.failed) continue;
      // Медленный режим: чат ждёт (порядок его сообщений сохраняется), а
      // отложенные он не касается.
      if (!row.isScheduled && _slowModeWaiting(row.chatID)) continue;
      if (!await hasNetwork()) return false;
      var content = pb.MessageContent.fromBuffer(row.content);
      if (row.media.isNotEmpty) {
        switch (await _uploadMedia(user, row, content)) {
          case _Upload.done:
            break;
          case _Upload.stop:
            return false;
          case _Upload.skip:
            continue;
        }
        // Вложения загружены (cdnID записаны) — шлём с ними.
        final saved = await _store.outboxByRandomID(userID: user, randomID: row.randomID);
        if (saved == null) continue;
        content = pb.MessageContent.fromBuffer(saved.content);
      }
      final pb.Messages_Response response;
      try {
        response = await messages(
          pb.Messages_Request(
            send: pb.Messages_Send(
              chatID: row.chatID,
              peerUserID: row.peerUserID,
              randomID: Int64(row.randomID),
              // Пересылка — только ссылка на исходное, содержимое соберёт сервер.
              content: row.isForward ? null : content,
              forwardFrom: row.isForward
                  ? pb.Messages_ForwardFrom(chatID: row.forwardChatID, messageID: Int64(row.forwardMessageID))
                  : null,
              silent: row.silent,
              scheduleDate: row.isScheduled ? Int64(row.scheduleDate) : null,
            ),
          ),
        );
      } on ChatsOfflineException {
        return false;
      } on ChatsFloodException catch (error) {
        // Не ошибка сообщения: ждём и шлём его же (randomID тот же — дубля не будет).
        _logger.info('chats: send flood wait ${error.seconds}s randomID=${row.randomID}');
        _setFlood(error.seconds);
        return false;
      } on ChatsSlowModeException catch (error) {
        // Медленный режим группы — тоже не ошибка сообщения: оно ждёт с
        // часиками, в окне чата — отсчёт, потом уходит само.
        final chatID = row.chatID;
        _logger.info('chats: send slow mode wait ${error.seconds}s randomID=${row.randomID}');
        if (chatID == null) return false;
        await _waitSlowMode(chatID, error.seconds);
        _sendRejected.add((chatID: chatID, error: 'slowModeWait'));
        continue;
      } on ChatsRequestException catch (error) {
        if (error.statusCode == StatusCode.unauthenticated) return false;
        _logger.warning('chats: send rejected randomID=${row.randomID}: $error');
        await _store.markOutboxFailed(userID: user, randomID: row.randomID);
        if (error.isPrivacyRestricted) {
          _writeRestricted.add((chatID: row.chatID ?? Uint8List(0), peerUserID: row.peerUserID, restricted: true));
        }
        if (row.chatID case final chatID?) _sendRejected.add((chatID: chatID, error: error.error));
        continue;
      }
      final result = response.send;
      _logger.debug(
        'chats: sent randomID=${row.randomID} chat=${idHex(result.message.chatID)} messageID=${result.message.messageID} '
        'outboxChat=${row.chatID == null ? '-' : idHex(row.chatID!)} updates=${result.updates.updates.length}',
      );
      await _locked(() async {
        await _store.transaction((tx) async {
          // Отложенное принято — на экран «Отложенные» с сервера.
          if (result.hasScheduled()) await tx.upsertScheduled(userID: user, message: result.scheduled);
          if (result.hasMessage()) {
            final message = result.message;
            var dialog = await tx.dialog(userID: user, chatID: message.chatID);
            if (dialog == null) {
              await tx.ensureDialog(userID: user, chatID: message.chatID, peerUserID: row.peerUserID);
              dialog = await tx.dialog(userID: user, chatID: message.chatID);
            }
            await tx.upsertMessage(userID: user, message: message);
            if (message.messageID.toInt() >= (dialog?.topMessageID ?? 0)) {
              await tx.setTopMessage(userID: user, chatID: message.chatID, message: message);
            }
            // Группа с медленным режимом: когда можно следующее (0 — сразу).
            if (!result.hasScheduled()) {
              await tx.setGroupSlowModeUntil(userID: user, chatID: message.chatID, until: result.slowModeUntil.toInt());
            }
          }
          await tx.deleteOutbox(userID: user, randomID: row.randomID);
        });
        if (result.hasUpdates()) await _applyUpdatesLocked(result.updates);
      });
    }
    return true;
  }

  // --- реакции ---

  bool _flushingReactions = false;
  bool _flushReactionsAgain = false;

  /// Лимит частоты реакций (отдельный от отправки: у сервера свои окна, и
  /// отсчёт в окне чата — только про сообщения): по таймеру — снова.
  Timer? _reactionsFloodTimer;

  /// Отправить мои неотправленные наборы реакций (как outbox: без сети ждут
  /// подключения). Сервер отклонил (сообщение удалено, собеседник ограничил,
  /// кто может ему писать) — набор выбрасываем: в ленте снова серверные.
  Future<void> flushReactions() async {
    if (!_auth.isAuthorized) return;
    if (_flushingReactions) {
      _flushReactionsAgain = true;
      return;
    }
    _flushingReactions = true;
    try {
      do {
        _flushReactionsAgain = false;
        if (!await _flushReactionsOnce()) return;
      } while (_flushReactionsAgain);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    } finally {
      _flushingReactions = false;
    }
  }

  /// Один проход; `false` — прервались (нет сети / лимит / разлогин).
  Future<bool> _flushReactionsOnce() async {
    final user = me;
    if (_reactionsFloodTimer?.isActive ?? false) return false;
    for (final row in await _store.pendingReactions(userID: user)) {
      if (!await hasNetwork()) return false;
      final pb.Messages_Response response;
      try {
        response = await messages(
          pb.Messages_Request(
            setReactions: pb.Messages_SetReactions(chatID: row.chatID, messageID: Int64(row.messageID), emojis: row.emojis),
          ),
        );
      } on ChatsOfflineException {
        return false;
      } on ChatsFloodException catch (error) {
        _logger.info('chats: reactions flood wait ${error.seconds}s message=${row.messageID}');
        _reactionsFloodTimer?.cancel();
        _reactionsFloodTimer = Timer(Duration(seconds: error.seconds), () => unawaited(flushReactions()));
        return false;
      } on ChatsRequestException catch (error) {
        if (error.statusCode == StatusCode.unauthenticated) return false;
        _logger.warning('chats: reactions rejected chat=${idHex(row.chatID)} message=${row.messageID}: $error');
        if (error.isPrivacyRestricted) _writeRestricted.add((chatID: row.chatID, peerUserID: null, restricted: true));
        // Канал: под постом уже набран «Максимум реакций» — окно объяснит.
        if (error.isReactionsLimit) _sendRejected.add((chatID: row.chatID, error: error.error));
        // Канал без подписки (4.4): реакции — только подписчикам.
        if (error.isSubscribeRequired) _sendRejected.add((chatID: row.chatID, error: error.error));
        await _store.deletePendingReactions(userID: user, chatID: row.chatID, messageID: row.messageID, createdAt: row.createdAt);
        continue;
      }
      // Сначала серверные реакции, потом убираем свой набор — без мигания
      // старым состоянием между ними.
      await _locked(() async {
        await _applyUpdatesLocked(response.setReactions.updates);
        await _store.deletePendingReactions(userID: user, chatID: row.chatID, messageID: row.messageID, createdAt: row.createdAt);
      });
    }
    return true;
  }

  // --- черновики ---

  bool _flushingDrafts = false;
  bool _flushDraftsAgain = false;

  /// Отправить мои черновики, ещё не принятые сервером (без сети ждут
  /// подключения). Сервер отклонил (чата нет, слишком длинный) — оставляем
  /// только локально.
  Future<void> flushDrafts() async {
    if (!_auth.isAuthorized) return;
    if (_flushingDrafts) {
      _flushDraftsAgain = true;
      return;
    }
    _flushingDrafts = true;
    try {
      do {
        _flushDraftsAgain = false;
        final user = me;
        for (final row in await _store.pendingDrafts(userID: user)) {
          if (!await hasNetwork()) return;
          try {
            final response = await chats(
              pb.Chats_Request(
                saveDraft: pb.Chats_SaveDraft(chatID: row.chatID, text: row.draft),
              ),
            );
            await _locked(() async {
              await _store.draftSent(userID: user, chatID: row.chatID, draft: row.draft);
              await _applyUpdatesLocked(response.saveDraft.updates);
            });
          } on ChatsOfflineException {
            return;
          } on ChatsRequestException catch (error) {
            if (error.statusCode == StatusCode.unauthenticated) return;
            _logger.warning('chats: draft rejected chat=${idHex(row.chatID)}: $error');
            await _store.draftSent(userID: user, chatID: row.chatID, draft: row.draft);
          }
        }
      } while (_flushDraftsAgain);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    } finally {
      _flushingDrafts = false;
    }
  }

  // --- «прослушано» ---

  /// Прослушанные без сети (chatID hex → messageID) — уйдут при подключении
  /// (до перезапуска приложения; потом точка останется до следующего раза).
  final _pendingContents = <String, Set<int>>{};

  /// Голосовые [messageIDs] чата прослушаны: на сервер сейчас или при
  /// подключении (точка у длительности снимется по ответу — у обоих).
  Future<void> readContents(List<int> chatID, List<int> messageIDs) async {
    if (messageIDs.isEmpty) return;
    _logger.info('chats: read contents queued chat=${idHex(chatID)} ids=$messageIDs');
    (_pendingContents[idHex(chatID)] ??= {}).addAll(messageIDs);
    await flushContents();
  }

  Future<void> flushContents() async {
    if (!_auth.isAuthorized) return;
    for (final chat in _pendingContents.keys.toList()) {
      final ids = _pendingContents[chat];
      if (ids == null || ids.isEmpty) continue;
      if (!await hasNetwork()) {
        _logger.info('chats: read contents waits for network');
        return;
      }
      final sent = ids.toList();
      try {
        final response = await messages(
          pb.Messages_Request(
            readContents: pb.Messages_ReadContents(chatID: idBytes(chat), messageIDs: [for (final id in sent) Int64(id)]),
          ),
        );
        _pendingContents[chat]?.removeAll(sent);
        final updates = response.readContents.updates;
        _logger.info(
          'chats: read contents sent chat=$chat ids=$sent updates=${updates.updates.length} '
          'pts=${[for (final u in updates.updates) u.pts.toInt()]}',
        );
        await applyUpdates(updates);
      } on ChatsOfflineException {
        _logger.info('chats: read contents offline, retry on connect');
        return;
      } on ChatsRequestException catch (error) {
        if (error.statusCode == StatusCode.unauthenticated) return;
        _logger.warning('chats: read contents rejected chat=$chat: $error');
        _pendingContents[chat]?.removeAll(sent);
      }
    }
    _pendingContents.removeWhere((_, ids) => ids.isEmpty);
  }

  // --- вложения outbox ---

  /// Прогресс загрузки вложений неотправленных (randomID → байты исходных
  /// файлов: загружено / всего). Нет записи — не грузится сейчас.
  final _uploads = <int, ({int sent, int total})>{};

  /// Отменённые пользователем загрузки (randomID) — `CDNManager` проверяет
  /// между чанками.
  final _cancelledUploads = <int>{};

  final _uploadChanged = StreamController<void>.broadcast();

  /// Изменился прогресс загрузки вложений (экран чата перечитывает ленту).
  Stream<void> get uploadChanged => _uploadChanged.stream;

  ({int sent, int total})? uploadProgress(int randomID) => _uploads[randomID];

  /// Отклонённое сервером — снова в очередь (тот же randomID: если сервер его
  /// всё-таки принял, дубля не будет).
  Future<void> retryOutbox(int randomID) async {
    await _store.unmarkOutboxFailed(userID: me, randomID: randomID);
    unawaited(flushOutbox());
  }

  /// Отменить загрузку и само неотправленное сообщение.
  Future<void> cancelUpload(int randomID) async {
    _cancelledUploads.add(randomID);
    await _store.deleteOutbox(userID: me, randomID: randomID);
  }

  /// Загрузить на CDN ещё не загруженные вложения [row] (cdnID пишется в
  /// outbox после каждого файла — обрыв не заставит грузить всё заново).
  Future<_Upload> _uploadMedia(Uint8List user, ChatOutboxRow row, pb.MessageContent content) async {
    final randomID = row.randomID;
    // Отменили, пока ждало очереди.
    if (await _store.outboxByRandomID(userID: user, randomID: randomID) == null) return _Upload.skip;
    final local = OutboxMedia.decode(row.media);
    final dir = await outboxMediaDir();
    final cdn = _scope.cdn;

    // Что грузить: (индекс вложения, обложка ли, файл).
    final jobs = <({int index, bool thumb, File file})>[];
    for (final (i, media) in content.media.indexed) {
      final item = i < local.length ? local[i] : null;
      if (item == null) continue;
      if (media.cdnID.isEmpty) jobs.add((index: i, thumb: false, file: File(outboxFilePath(dir, item.path))));
      if (item.thumb.isNotEmpty && media.thumbCdnID.isEmpty) {
        jobs.add((index: i, thumb: true, file: File(outboxFilePath(dir, item.thumb))));
      }
    }
    if (jobs.isEmpty) return _Upload.done;

    final sizes = <int>[];
    try {
      for (final job in jobs) {
        sizes.add(await job.file.length());
      }
    } on FileSystemException catch (error) {
      // Файл пропал (удалили / очистили данные) — отправить уже не выйдет.
      _logger.warning('chats: outbox media missing randomID=$randomID: $error');
      await _store.markOutboxFailed(userID: user, randomID: randomID);
      return _Upload.skip;
    }
    final total = sizes.fold(0, (a, b) => a + b);
    var done = 0;
    var lastNotify = DateTime.fromMillisecondsSinceEpoch(0);
    void progress(int sent) {
      _uploads[randomID] = (sent: sent, total: total);
      final now = DateTime.now();
      if (now.difference(lastNotify) < const Duration(milliseconds: 200)) return;
      lastNotify = now;
      _uploadChanged.add(null);
    }

    progress(0);
    // Собеседник видит «отправляет фото / видео / файл…», пока грузится.
    final chatID = row.chatID;
    final activity = _uploadActivity(content);
    final typing = chatID == null || activity == null ? null : ChatsTyping.instance.begin(idHex(chatID), activity);
    try {
      for (final (j, job) in jobs.indexed) {
        final file = await cdn.uploadFile(
          file: job.file,
          folder: chatMediaFolder,
          contentType: chatMediaContentType(job.file.path),
          isCancelled: () => _cancelledUploads.contains(randomID),
          onProgress: (sent, cipherTotal) => progress(uploadedBytes(done: done, current: sizes[j], sent: sent, total: cipherTotal)),
        );
        done += sizes[j];
        progress(done);
        final media = content.media[job.index];
        if (job.thumb) {
          media.thumbCdnID = file.cdnID;
        } else {
          media.cdnID = file.cdnID;
        }
        // Строку могли удалить (отменили), пока грузился последний файл.
        if (await _store.outboxByRandomID(userID: user, randomID: randomID) == null) return _Upload.skip;
        await _store.updateOutboxContent(userID: user, randomID: randomID, content: content.writeToBuffer());
      }
      return _Upload.done;
    } on UploadCancelledException {
      return _Upload.skip;
    } on FileSystemException catch (error) {
      _logger.warning('chats: outbox media unreadable randomID=$randomID: $error');
      await _store.markOutboxFailed(userID: user, randomID: randomID);
      return _Upload.skip;
    } catch (error, stackTrace) {
      // Сеть / сервер: попробуем позже (при подключении или по таймеру).
      _logger.handle(error, stackTrace);
      _retryTimer ??= Timer(const Duration(seconds: 30), () {
        _retryTimer = null;
        unawaited(flushOutbox());
      });
      return _Upload.stop;
    } finally {
      if (typing != null) ChatsTyping.instance.end(typing);
      _uploads.remove(randomID);
      _cancelledUploads.remove(randomID);
      _uploadChanged.add(null);
    }
  }

  /// Что показать собеседнику при загрузке вложений: видео, если оно есть в
  /// альбоме, иначе фото; файл. Голосовое грузится за миг (а «записывает
  /// аудио…» уже показали при записи) — `null`, ничего.
  static models.ChatActivity? _uploadActivity(pb.MessageContent content) {
    final kinds = {for (final media in content.media) media.kind};
    if (kinds.contains(pb.MessageKind.MESSAGE_KIND_VIDEO)) return models.ChatActivity.uploadVideo;
    if (kinds.contains(pb.MessageKind.MESSAGE_KIND_PHOTO)) return models.ChatActivity.uploadPhoto;
    if (kinds.contains(pb.MessageKind.MESSAGE_KIND_FILE)) return models.ChatActivity.uploadFile;
    return null;
  }

  Timer? _retryTimer;

  /// Копии файлов уже отправленных / удалённых сообщений больше не нужны:
  /// отправленные лежат в кэше скачиваний под своим cdnID.
  Future<void> _cleanOutboxFiles() async {
    try {
      final keep = <String>{for (final raw in await _store.outboxMediaAll()) ...OutboxMedia.names(raw)};
      await cleanOutboxFiles(keep);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }
}

/// Итог загрузки вложений одного неотправленного: [done] — можно отправлять,
/// [stop] — прервать проход (нет сети), [skip] — к следующему (отменено или
/// помечено `failed`).
enum _Upload { done, stop, skip }

class _FollowUps {
  bool reloadDialogs = false;
  final refreshTop = <Uint8List>[];
  final refreshPinned = <Uint8List>[];

  /// Группы, которые догнать после пачки (появились через dialogNew).
  final chatCatchUp = <Uint8List>[];

  /// Группы, у которых изменился состав (hex chatID).
  final membersChanged = <String>{};

  /// Группы, у которых изменились заявки на вступление (hex chatID).
  final joinRequestsChanged = <String>{};

  /// Новые входящие (для [ChatsSync.incoming]).
  final incoming = <({String chatID, int messageID, String fromUserID})>[];

  /// Новые упоминания меня.
  final mentions = <({String chatID, int messageID})>{};

  /// Новые непрочитанные «Ответы» (для [ChatsSync.repliesIncoming]).
  final replies = <pb.ThreadReply>[];
}

/// Новое входящее сообщение ([ChatsSync.incoming]): hex chatID, id сообщения,
/// hex автора (пусто — неизвестен), упоминает ли меня.
typedef ChatsIncoming = ({String chatID, int messageID, String fromUserID, bool mentioned});

/// Непрочитанные по чатам ([ChatsSync.unread]): id строки списка чатов (hex
/// chatID / `secret:<hex>`) → сколько в нём непрочитанных сообщений (ручная
/// пометка без непрочитанных — 1); заглушённых и скрытых здесь нет.
///
/// Общая цифра [total] (иконка iOS, вкладка «Чаты», «‹ N» у «назад») — число
/// **чатов**, а не сообщений (4.5, как режим «чаты» в Telegram и как `badge:`
/// на сервере): каждый непрочитанный чат даёт 1.
@immutable
class ChatsUnread {
  final Map<String, int> byChat;
  final int total;

  ChatsUnread(this.byChat) : total = byChat.values.where((count) => count > 0).length;

  static final empty = ChatsUnread(const {});

  /// Без чата [chatID] — счётчик у «назад» в его окне (тоже в чатах).
  int except(String chatID) => total - ((byChat[chatID] ?? 0) > 0 ? 1 : 0);

  @override
  bool operator ==(Object other) => other is ChatsUnread && mapEquals(other.byChat, byChat);

  @override
  int get hashCode => Object.hashAllUnordered(byChat.entries.map((e) => Object.hash(e.key, e.value)));
}
