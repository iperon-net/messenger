import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../chats/chats_replies.dart';
import '../../chats/chats_sync.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;

import 'replies_state.dart';

/// Экран «Ответы» (подэтап 4.6, как Replies в Telegram): лента из кэша
/// ([ChatsReplies.watchReplies]) — видна и без сети; при открытии — свежая
/// первая страница, вверх — дозагрузка страницами. Показанные ответы читаются
/// пакетно ([ChatsSync.readReplies]): без сети прочтение уйдёт при подключении.
class RepliesCubit extends Cubit<RepliesState> {
  RepliesCubit() : super(const RepliesState());

  final _logger = getIt.get<Logger>();

  StreamSubscription<List<models.ChatReply>>? _subscription;

  /// Пауза перед отправкой прочтения — пакет за прокрутку, а не на каждую строку.
  static const readDelay = Duration(milliseconds: 600);

  Timer? _readTimer;

  /// Максимальный показанный replyID (ещё не отправленный).
  int _seenMaxID = 0;

  void initialization() {
    emit(state.copyWith(status: Status.loading));
    _subscription = ChatsReplies.instance.watchReplies().listen((replies) {
      if (!isClosed) emit(state.copyWith(status: Status.success, replies: replies));
    });
    unawaited(_refresh());
  }

  Future<void> _refresh() async {
    try {
      await ChatsSync.instance.refreshReplies();
    } on ChatsOfflineException {
      // Без сети — кэш.
    } on ChatsRequestException catch (error) {
      _logger.warning('replies: refresh failed: $error');
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
  }

  /// Без сети дозагрузку не повторяем раньше этого времени (строка «ещё»
  /// строится снова на каждой перестройке ленты).
  DateTime? _olderPausedUntil;

  static const _olderRetry = Duration(seconds: 10);

  /// Долистали до верха — следующая страница с сервера.
  Future<void> loadOlder() async {
    if (state.loadingOlder || !state.hasOlder) return;
    final paused = _olderPausedUntil;
    if (paused != null && DateTime.now().isBefore(paused)) return;
    emit(state.copyWith(loadingOlder: true));
    var hasOlder = true;
    try {
      hasOlder = await ChatsSync.instance.loadOlderReplies();
    } on ChatsOfflineException {
      // Попробуем позже (прокрутка / перестройка ленты).
      _olderPausedUntil = DateTime.now().add(_olderRetry);
    } on ChatsRequestException catch (error) {
      _logger.warning('replies: older failed: $error');
      hasOlder = false;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
    if (!isClosed) emit(state.copyWith(loadingOlder: false, hasOlder: hasOlder));
  }

  /// Строка ответа [reply] показана на экране: непрочитанное — в пакет
  /// прочтения (ReadReplies до максимального показанного).
  void seen(models.ChatReply reply) {
    if (!reply.unread || reply.replyID <= _seenMaxID) return;
    _seenMaxID = reply.replyID;
    _readTimer ??= Timer(readDelay, _flushRead);
  }

  void _flushRead() {
    _readTimer = null;
    final maxID = _seenMaxID;
    if (maxID > 0) unawaited(ChatsSync.instance.readReplies(maxID).catchError((Object e, StackTrace s) => _logger.handle(e, s)));
  }

  @override
  Future<void> close() async {
    if (_readTimer != null) {
      _readTimer!.cancel();
      _flushRead();
    }
    await _subscription?.cancel();
    return super.close();
  }
}
