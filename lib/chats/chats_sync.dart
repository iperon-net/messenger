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
import '../protobuf.dart';
import '../protobuf/protos/chats_v1.pb.dart' as pb;
import '../repositories.dart';
import '../utils.dart';
import 'chats_mapping.dart';
import 'chats_media.dart';
import 'updates_plan.dart';

/// Действие требует сети, а её нет (или сервер недоступен): ничего не
/// изменилось — UI должен честно сказать «нет сети», а не делать вид, что
/// получилось.
class ChatsOfflineException implements Exception {
  const ChatsOfflineException();

  @override
  String toString() => 'ChatsOfflineException: нет сети';
}

/// Сервер отклонил запрос чатов; [error] — i18n-ключ или текст ошибки из
/// [APICallStatus].
class ChatsRequestException implements Exception {
  final String error;
  final int statusCode;

  const ChatsRequestException(this.error, this.statusCode);

  @override
  String toString() => 'ChatsRequestException($statusCode): $error';
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
  ChatsSync._();

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
    throw ChatsRequestException(status.error, status.statusCode);
  }

  Future<pb.Chats_Response> chats(pb.Chats_Request request) async =>
      pb.Chats_Response.fromBuffer(await _request(MessageType.CHATS, request.writeToBuffer()));

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
    if (value && getIt.isRegistered<API>() && getIt.get<API>().connectionStatus == ApiConnectionStatus.connected) {
      unawaited(onConnected());
    }
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
    // Докачка истории открытых чатов, прерванная обрывом связи.
    unawaited(_runBackfill());
  }

  Future<void> _catchUp() async {
    final user = me;
    if (await _store.getPts(userID: user) == null) await _reloadDialogs();
    // Пока листали страницы списка, могли прийти обновления — догоняем от pts
    // первой страницы (повторное применение идемпотентно).
    await _getDifference();
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
  /// страницы. [dropHistory] — журнал отстал (`tooLong`): сбросить и кэш истории.
  Future<void> _reloadDialogs({bool dropHistory = false}) async {
    final user = me;
    // История сброшена — «старше нет» больше не верно.
    if (dropHistory) _noOlder.clear();
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
      await tx.replaceDialogs(userID: user, dialogs: dialogs, dropHistory: dropHistory);
      await tx.setPts(userID: user, pts: pts, date: date);
    });
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
        // истории сбрасываем: он мог разойтись с сервером.
        await _reloadDialogs(dropHistory: true);
        return;
      }
      // Пустой ответ с state.pts == нашему (параллельная запись ещё идёт) —
      // pts остаётся, обновление придёт push'ем.
      await _applyBatch(response.updates, setPts: response.state.pts.toInt());
      if (!response.hasMore) return;
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
    final gap = await _applyBatch(updates.updates, statePts: updates.hasState() ? updates.state.pts.toInt() : 0);
    if (gap) {
      try {
        await _getDifference();
      } on ChatsOfflineException {
        // Догоним при следующем подключении.
      }
    }
  }

  /// Применяет пачку в одной транзакции (диалоги + сообщения + pts атомарно).
  /// [setPts] — pts, до которого пачка покрывает журнал (ответ GET_DIFFERENCE).
  /// Возвращает, есть ли дыра.
  Future<bool> _applyBatch(List<pb.Update> updates, {int statePts = 0, int? setPts}) async {
    final user = me;
    final followUps = _FollowUps();
    final gap = await _store.transaction((tx) async {
      final local = await tx.getPts(userID: user);
      // Журнал ещё не загружен — всё придёт полным списком при подключении.
      if (local == null) return false;
      final plan = planUpdates(local, [for (final u in updates) u.pts.toInt()], statePts: setPts == null ? statePts : 0);
      for (final i in plan.apply) {
        await _applyOne(tx, user, updates[i], followUps);
      }
      final pts = setPts == null ? plan.pts : math.max(plan.pts, setPts);
      if (pts != local) await tx.setPts(userID: user, pts: pts);
      return plan.gap;
    });
    if (followUps.reloadDialogs || followUps.refreshTop.isNotEmpty) unawaited(_runFollowUps(followUps));
    return gap;
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
        await tx.upsertMessage(userID: user, message: message);
        final id = message.messageID.toInt();
        final top = dialog?.topMessageID ?? 0;
        if (id >= top) await tx.setTopMessage(userID: user, chatID: chatID, message: message);
        if (outgoing) {
          // Наше (с этого или другого устройства) — из outbox, если оно оттуда.
          if (message.randomID != 0) await tx.deleteOutbox(userID: user, randomID: message.randomID.toInt());
        } else if (!fresh && dialog != null && id > top && id > dialog.readInboxMaxID) {
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
        if (cached != null || dialog?.topMessageID == id) await tx.upsertMessage(userID: user, message: message);
        if (dialog != null && dialog.topMessageID == id) await tx.setTopMessage(userID: user, chatID: chatID, message: message);

      case pb.Update_Update.deleteMessages:
        final chatID = update.deleteMessages.chatID;
        final ids = [for (final id in update.deleteMessages.messageIDs) id.toInt()];
        final dialog = await tx.dialog(userID: user, chatID: chatID);
        final unread = await tx.deleteMessages(userID: user, chatID: chatID, messageIDs: ids, readInboxMaxID: dialog?.readInboxMaxID ?? 0);
        if (dialog == null) return;
        if (unread > 0) {
          await tx.updateDialog(userID: user, chatID: chatID, fields: {'unreadCount': math.max(0, dialog.unreadCount - unread)});
        }
        if (ids.contains(dialog.topMessageID)) {
          // Удалили последнее — новое последнее из кэша; кэш пуст — спросим сервер.
          final latest = await tx.latestMessage(userID: user, chatID: chatID);
          await tx.setTopMessage(userID: user, chatID: chatID, message: latest);
          if (latest == null) followUps.refreshTop.add(Uint8List.fromList(chatID));
        }

      case pb.Update_Update.readInbox:
        final read = update.readInbox;
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
            },
          );
        }

      case pb.Update_Update.dialogDeleted:
        await tx.deleteDialog(userID: user, chatID: update.dialogDeleted.chatID);

      case pb.Update_Update.notSet:
        // Пустое обновление (например, новое сообщение, которое потом удалили):
        // ничего не меняем, но pts сдвигается — это не дыра.
        _logger.debug('chats: empty update pts=${update.pts}');
    }
  }

  /// Дозапросы после применения (вне транзакции и очереди): последнее
  /// сообщение чата, у которого кэш опустел, и список диалогов.
  Future<void> _runFollowUps(_FollowUps followUps) async {
    try {
      for (final chatID in followUps.refreshTop) {
        await loadHistory(chatID, limit: 1);
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

  /// Диалог из ответа (OpenPrivate) — в кэш, в общей очереди с обновлениями.
  Future<void> saveDialog(pb.Dialog dialog) {
    final user = me;
    return _locked(() => _store.upsertDialog(userID: user, dialog: dialog));
  }

  // --- история ---

  /// Последние [limit] сообщений чата с сервера — в кэш (открытие чата). Нет
  /// сети — молча: показываем кэш.
  ///
  /// Кэш истории всегда непрерывен: от самого старого загруженного до
  /// последнего (новые приходят журналом без дыр, старые — [loadOlder] от
  /// самого старого). Свежая страница не дотянулась до кэша (были вне сети
  /// долго, а журнал догнан перезагрузкой) — между ними могла быть дыра:
  /// старый хвост выбрасываем, его снова подгрузит [loadOlder].
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
        final cachedNewest = await tx.newestMessageID(userID: user, chatID: chatID);
        // История DESC: последнее — самое старое на странице.
        final pageOldest = history.isEmpty ? 0 : history.last.messageID.toInt();
        if (hasMore && cachedNewest > 0 && pageOldest > cachedNewest + 1) {
          await tx.deleteMessagesBelow(userID: user, chatID: chatID, messageID: pageOldest);
          _noOlder.remove(idHex(chatID));
        }
        for (final message in history) {
          await tx.upsertMessage(userID: user, message: message);
        }
        // История DESC: первое — самое новое.
        final newest = history.isEmpty ? null : history.first;
        if (newest != null && newest.messageID.toInt() >= dialog.topMessageID) {
          await tx.setTopMessage(userID: user, chatID: chatID, message: newest);
        }
      }),
    );
  }

  /// Чаты, у которых на сервере старше уже нет (hex chatID).
  final _noOlder = <String>{};

  /// Следующая страница истории старше самого старого в кэше. Возвращает,
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
    final oldest = await _store.oldestMessageID(userID: user, chatID: chatID);
    // Самое старое — №1: старше нет.
    if (oldest == 1) {
      _noOlder.add(key);
      return (loaded: 0, hasMore: false);
    }
    final response = await messages(
      pb.Messages_Request(
        history: pb.Messages_History(chatID: chatID, offsetID: Int64(oldest), limit: _pageLimit),
      ),
    );
    final history = response.history.messages;
    await _locked(
      () => _store.transaction((tx) async {
        if (await tx.dialog(userID: user, chatID: chatID) == null) return;
        for (final message in history) {
          await tx.upsertMessage(userID: user, message: message);
        }
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
  /// первого сообщения, страницами по [_pageLimit]. Сервер искать не может
  /// (содержимое зашифровано), поэтому поиск в чате — по скачанному. По
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

  /// Один проход по outbox; `false` — прервались (нет сети / разлогин).
  Future<bool> _flushOnce() async {
    final user = me;
    for (final row in await _store.outbox(userID: user)) {
      if (row.failed) continue;
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
              content: content,
              silent: row.silent,
            ),
          ),
        );
      } on ChatsOfflineException {
        return false;
      } on ChatsRequestException catch (error) {
        if (error.statusCode == StatusCode.unauthenticated) return false;
        _logger.warning('chats: send rejected randomID=${row.randomID}: $error');
        await _store.markOutboxFailed(userID: user, randomID: row.randomID);
        continue;
      }
      final result = response.send;
      await _locked(() async {
        await _store.transaction((tx) async {
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
          }
          await tx.deleteOutbox(userID: user, randomID: row.randomID);
        });
        if (result.hasUpdates()) await _applyUpdatesLocked(result.updates);
      });
    }
    return true;
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
      _uploads.remove(randomID);
      _cancelledUploads.remove(randomID);
      _uploadChanged.add(null);
    }
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
}
