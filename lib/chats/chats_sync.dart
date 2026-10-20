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
import 'updates_plan.dart';
import 'chats_media_cleanup.dart';
import 'chats_typing.dart';

/// Capability сессии «умеет группы» (`Subscribe.capabilities`, флаг «Группы»
/// на экране «Разработчик»): групповое сервер отдаёт только таким сессиям.
const groupsCapability = 'groups';

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
  ChatsSync._() {
    // Удалённые сообщения / чаты — их файлы с устройства, если больше не нужны.
    ChatsRepository.onMediaReleased = ChatsMediaCleanup.release;
  }

  static final ChatsSync instance = ChatsSync._();

  Logger get _logger => getIt.get<Logger>();
  API get _api => getIt.get<API>();
  ChatsRepository get _store => getIt.get<Repositories>().chats;
  Auth get _auth => getIt.get<Auth>();

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
    _watchBadge(value);
    _watchExpired(value);
    if (value && getIt.isRegistered<API>() && getIt.get<API>().connectionStatus == ApiConnectionStatus.connected) {
      unawaited(onConnected());
    }
  }

  bool _groups = false;

  /// Флаг «Группы» (экран «Разработчик»): capability `groups` в Subscribe,
  /// журналы групп и группы в списке. Выключен — кэш групп не стирается.
  bool get groups => _groups;

  /// Включили — после переподключения перечитать список диалогов целиком:
  /// группы, созданные без флага, в журнал этой сессии не попадали.
  bool _reloadOnConnect = false;

  final _groupsChanged = StreamController<void>.broadcast();

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

  /// Переключили «Группы» — список чатов перечитывается (группы появляются /
  /// скрываются).
  Stream<void> get groupsChanged => _groupsChanged.stream;

  /// Ставит [CommonCubit]: при старте ([initial] — без перезагрузки списка) и
  /// при переключении. Набор capability поменялся — стрим переподписывается.
  void setGroups(bool value, {bool initial = false}) {
    if (_groups == value) return;
    _groups = value;
    if (value && !initial) _reloadOnConnect = true;
    _groupsChanged.add(null);
    if (getIt.isRegistered<API>()) unawaited(getIt.get<API>().resubscribe());
  }

  StreamSubscription<int>? _badgeSub;

  /// Бейдж на иконке (iOS) — из локального списка диалогов при каждом его
  /// изменении: так он сходится с тем, что видно в «Чатах», и падает сразу после
  /// прочтения здесь. В фоне его ведут пуши (сервер считает так же, см. `badge`
  /// в `services/chats.go`). Выключили серверные чаты — снимаем.
  void _watchBadge(bool enabled) {
    if (!Platform.isIOS) return;
    unawaited(_badgeSub?.cancel());
    _badgeSub = null;
    if (!enabled) {
      unawaited(PushManager.setBadge(0));
      return;
    }
    final repositories = getIt.get<Repositories>();
    // Скрыли/показали профиль — его личный чат входит в бейдж или выходит.
    final changes = StreamController<void>();
    final dialogsSub = repositories.db.onChange([ChatsRepository.dialogsTable]).listen(changes.add, onError: changes.addError);
    final hiddenSub = repositories.hiddenProfiles.changes.listen(changes.add);
    final groupsSub = _groupsChanged.stream.listen(changes.add);
    changes.onCancel = () async {
      await dialogsSub.cancel();
      await hiddenSub.cancel();
      await groupsSub.cancel();
    };
    _badgeSub = changes.stream
        .asyncMap((_) => _badge())
        .distinct()
        .listen(
          (count) => unawaited(PushManager.setBadge(count)),
          onError: (Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace),
        );
  }

  /// Непрочитанные во всех незаглушённых диалогах; ручная пометка без
  /// непрочитанных — 1 (как на сервере). Личные чаты с локально скрытыми
  /// профилями (HiddenProfiles) не считаем — сервер о них не знает, поэтому
  /// бейдж из пуша в фоне их ещё включает.
  Future<int> _badge() async {
    if (!_auth.isAuthorized) return 0;
    final now = DateTime.now();
    final hidden = await getIt.get<Repositories>().hiddenProfiles.hashByHex();
    var total = 0;
    for (final row in await _store.dialogs(userID: me)) {
      if (mutedFromPb(row.mutedUntil, now).muted) continue;
      // Группы без флага «Группы» не видны — и в бейдж не идут (как на сервере).
      if (!_groups && row.type != pb.ChatType.CHAT_TYPE_PRIVATE.value) continue;
      if (row.peerUserID case final peer? when hidden.containsKey(idHex(peer))) continue;
      total += row.unreadCount > 0 ? row.unreadCount : (row.markedUnread ? 1 : 0);
    }
    return total;
  }

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
    // Докачка истории открытых чатов, прерванная обрывом связи.
    unawaited(_runBackfill());
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
    // Журналы групп — каждый свой: что изменилось, пока нас не было.
    if (_groups) await _syncGroups();
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
      await tx.replaceDialogs(userID: user, dialogs: dialogs, staleHistory: staleHistory, keepGroups: !_groups);
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
    final groups = await _store.groups(userID: user);
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
    unawaited(applyUpdates(updates).catchError((Object error, StackTrace stackTrace) => _logger.handle(error, stackTrace)));
  }

  /// Обновления из ответа на запрос или push: применить подряд идущие, при
  /// дыре — догнать.
  Future<void> applyUpdates(pb.Updates updates) => _locked(() => _applyUpdatesLocked(updates));

  Future<void> _applyUpdatesLocked(pb.Updates updates) async {
    final result = await _applyBatch(updates.updates, statePts: updates.hasState() ? updates.state.pts.toInt() : 0);
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
  /// журнале пользователя и в каких группах.
  Future<({bool gap, List<Uint8List> chatGaps})> _applyBatch(
    List<pb.Update> updates, {
    int statePts = 0,
    int? setPts,
    Map<String, int> chatSetPts = const {},
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
        final message = update.newMessage.message;
        final chatID = message.chatID;
        final outgoing = sameID(message.fromUserID, user);
        final fresh = update.newMessage.hasDialog();
        // Чат появился этим сообщением — диалог с сервера (счётчики уже в нём).
        if (fresh) await tx.upsertDialog(userID: user, dialog: update.newMessage.dialog);
        var dialog = await tx.dialog(userID: user, chatID: chatID);
        if (dialog == null) {
          // Диалога у нас нет, а сервер его не прислал — заводим пустой и
          // перечитываем список (у исходящего с другого устройства собеседник
          // неизвестен).
          await tx.ensureDialog(userID: user, chatID: chatID, peerUserID: outgoing ? null : message.fromUserID);
          followUps.reloadDialogs = true;
          dialog = await tx.dialog(userID: user, chatID: chatID);
        }
        await tx.upsertMessage(userID: user, message: message, shared: update.chatPts > 0);
        // Написал — больше не «печатает…».
        if (!outgoing) ChatsTyping.instance.clear(chatID, message.fromUserID);
        final id = message.messageID.toInt();
        final top = dialog?.topMessageID ?? 0;
        if (id >= top) await tx.setTopMessage(userID: user, chatID: chatID, message: message);
        if (outgoing) {
          // Наше (с этого или другого устройства) — из outbox, если оно оттуда.
          if (message.randomID != 0) await tx.deleteOutbox(userID: user, randomID: message.randomID.toInt());
        } else if (!fresh && dialog != null && id > top && id > dialog.readInboxMaxID && !skipsUnread(message.content)) {
          // Новое входящее: счётчик локально, точное значение — с ReadInbox/Dialog.
          await tx.updateDialog(userID: user, chatID: chatID, fields: {'unreadCount': dialog.unreadCount + 1});
        }

      case pb.Update_Update.editMessage:
        final message = update.editMessage.message;
        final chatID = message.chatID;
        final id = message.messageID.toInt();
        final dialog = await tx.dialog(userID: user, chatID: chatID);
        final cached = await tx.message(userID: user, chatID: chatID, messageID: id);
        // Нет в кэше — не заводим «островок» в истории, подтянется с историей.
        if (cached != null || dialog?.topMessageID == id) {
          await tx.upsertMessage(userID: user, message: message, shared: update.chatPts > 0);
        }
        if (dialog != null && dialog.topMessageID == id) await tx.setTopMessage(userID: user, chatID: chatID, message: message);

      case pb.Update_Update.deleteMessages:
        final chatID = update.deleteMessages.chatID;
        final ids = [for (final id in update.deleteMessages.messageIDs) id.toInt()];
        await _deleteLocally(tx, user, chatID, ids, followUps);

      case pb.Update_Update.readInbox:
        final read = update.readInbox;
        unawaited(PushManager.clearChatNotifications(read.chatID, maxID: read.maxID.toInt()));
        final dialog = await tx.dialog(userID: user, chatID: read.chatID);
        if (dialog == null) return;
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
        if (dialog.type == pb.ChatType.CHAT_TYPE_GROUP && dialog.role != pb.ChatRole.CHAT_ROLE_NONE) {
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
        // Группа: счётчики без моего порядка + кто изменил ([mergeSharedReactions]).
        final reactions = changed.reactions.counts.isEmpty
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
    return _locked(() => _store.upsertDialog(userID: user, dialog: dialog));
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
    final cdn = getIt.get<CDNManager>();

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
}
