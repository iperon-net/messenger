import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState, WidgetsBinding, WidgetsBindingObserver;
import 'package:grpc/grpc.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../repositories.dart';
import '../../utils.dart';
import '../../protobuf.dart';
import 'auth_login_completer.dart';
import 'auth_callpassword_confirmation_state.dart';

class AuthCallpasswordConfirmationCubit extends Cubit<AuthCallpasswordConfirmationState> with WidgetsBindingObserver {
  AuthCallpasswordConfirmationCubit() : super(AuthCallpasswordConfirmationState()) {
    WidgetsBinding.instance.addObserver(this);
  }

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();

  // Информационный обратный отсчёт ожидания звонка. Реальный таймаут ведёт
  // сервер: локальный ноль — не приговор, а повод финально свериться с ним
  // (см. [_startTicker]).
  Timer? _ticker;

  // Сервер считает таймаут от момента создания сессии (в CallPassword), а не от
  // открытия этого экрана, поэтому его остаток меньше нашего полного timeout.
  // Первый healthcheck каждого стрима несёт реальный остаток — по нему
  // одноразово выравниваем локальный отсчёт. Синхронизация сбрасывается при
  // каждом (пере)открытии стрима; в пределах одного стрима повторно не
  // синхронизируем, иначе тикер «прыгал» бы (все healthcheck несут одно
  // значение, посчитанное на старте обработчика).
  bool _serverTimerSynced = false;

  // Выделенный (незашифрованный) двунаправленный стрим проверки звонка-пароля.
  // Пользователь ещё не авторизован и сессионного ключа нет, поэтому постоянный
  // зашифрованный стрим в [API] здесь не применим — как и unary-вызовы pre-auth
  // flow, открываем отдельный стрим и шлём/принимаем открытый protobuf.
  StreamController<Message>? _outgoing;
  StreamSubscription<Message>? _subscription;

  // Success уже обработан: success может прийти и по старому, и по свежему
  // стриму (переподключение) — вход завершаем один раз.
  bool _completed = false;

  // Подряд сорвавшиеся переподключения без единого сообщения от сервера:
  // выше предела считаем сессию неживой и уводим на /auth. Любое входящее
  // сообщение сбрасывает счётчик.
  int _reconnectAttempt = 0;
  static const _maxReconnectAttempts = 15;

  Timer? _reconnectTimer;

  Future<void> initialization({
    required String callPasswordSession,
    required String confirmationPhoneNumber,
    required String timeout,
  }) async {
    emit(state.copyWith(status: Status.loading));

    // timeout приходит с сервера уже в секундах (time.Duration.Seconds() на бэкенде).
    final timeoutSeconds = (double.tryParse(timeout) ?? 0).round();

    emit(
      state.copyWith(
        status: Status.success,
        callPasswordSession: utils.hexToBytes(callPasswordSession),
        confirmationPhoneNumber: confirmationPhoneNumber,
        timeout: timeoutSeconds,
        tickerSecond: timeoutSeconds,
        result: AuthCallPasswordConfirmationResult.waiting,
      ),
    );

    _startTicker();
    _openStream();
  }

  /// Запускает посекундный обратный отсчёт. По достижении нуля — финальная
  /// сверка с сервером: свежий стрим вернёт healthcheck с реальным остатком и
  /// отсчёт продолжится или закроется (сессия истекла) — тогда терминальный
  /// таймаут (см. [_timeoutOutcome]).
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.tickerSecond - 1;
      if (next <= 0) {
        _stop();
        emit(state.copyWith(tickerSecond: 0));
        _scheduleReconnect();
        return;
      }
      emit(state.copyWith(tickerSecond: next));
    });
  }

  /// Переподключение с экспоненциальным backoff (1с, 2с, 4с, дальше 5с) —
  /// разрыв соединения во время звонка в звонилке — норма, а не ошибка.
  void _scheduleReconnect() {
    if (isClosed || _completed) return;
    if (++_reconnectAttempt > _maxReconnectAttempts) {
      _timeoutOutcome();
      return;
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: min(1 << (_reconnectAttempt - 1), 5)), _openStream);
  }

  /// Терминальный таймаут: сервер подтвердил, что сессии больше нет.
  void _timeoutOutcome() {
    _stop();
    _clearPending();
    emit(state.copyWith(tickerSecond: 0, result: AuthCallPasswordConfirmationResult.timeout, redirectURI: Uri.parse("/auth").toString()));
  }

  /// Открывает двунаправленный gRPC-стрим, отправляет запрос проверки и
  /// слушает ответы сервера, пока пользователь ждёт подтверждения звонка.
  void _openStream() {
    if (isClosed || _completed) return;
    if (_outgoing != null) return;

    _serverTimerSynced = false;
    _outgoing = StreamController<Message>();

    try {
      final responseStream = api.client.stream(_outgoing!.stream);

      _subscription = responseStream.listen(
        _onMessage,
        onError: (error, stackTrace) {
          logger.handle(error, stackTrace);
          if (_outgoing == null) return;
          if (_isSessionGone(error)) {
            _timeoutOutcome();
            return;
          }
          // Разрыв соединения (ушли в звонилку, звонок подвесил сеть) —
          // переподключаемся: сервер хранит confirmation-событие до конца TTL
          // сессии и отдаст его свежему стриму с той же сессией (ephemeral
          // JetStream-консьюмер, DeliverAll).
          _stopStream();
          _scheduleReconnect();
        },
        onDone: () {
          // Сервер штатно закрыл стрим: истёк его таймаут ожидания звонка
          // (ctx.Done() -> return nil) или обработчик перезапустился. Если
          // стрим закрыли мы сами, _outgoing уже null и ветку пропускаем.
          if (_outgoing == null) return;
          _stopStream();
          _scheduleReconnect();
        },
        cancelOnError: true,
      );

      _outgoing!.add(
        Message(
          messageType: MessageType.AUTH_CALL_PASSWORD_CONFIRMATION,
          message: AuthCallPasswordConfirmation_Request(callPasswordSession: state.callPasswordSession).writeToBuffer(),
        ),
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      _stopStream();
      _scheduleReconnect();
    }
  }

  /// Сервер сказал, что сессии больше нет (TTL Redis истёк): ErrNotFoundInRedis
  /// уходит в трейлер стрима сырым текстом "not found in redis" (код Unknown;
  /// в других местах API тот же сервис мапится в NotFound/Unauthenticated).
  /// Отличаем истечение от разрыва сети: первое — терминальное.
  bool _isSessionGone(Object error) {
    final message = error is GrpcError ? (error.message ?? '') : error.toString();
    return message.contains("not found in redis");
  }

  /// Разбор входящего сообщения стрима. Остаток сервер ведёт сам: локальный
  /// тикер — только зеркало, выровненное по первому healthcheck стрима.
  Future<void> _onMessage(Message message) async {
    if (message.messageType != MessageType.AUTH_CALL_PASSWORD_CONFIRMATION) {
      logger.debug('call password check: unexpected message type ${message.messageType}');
      return;
    }

    // Стрим жив — накопленные неудачные переподключения больше не в счёт.
    _reconnectAttempt = 0;

    final response = AuthCallPasswordConfirmation_Response.fromBuffer(message.message);

    // Одноразово (на каждый стрим) выравниваем отсчёт по реальному серверному
    // остатку (первый healthcheck с timer). Ноль — сессия на сервере истекла.
    if (!_serverTimerSynced && response.hasTimer()) {
      _serverTimerSynced = true;
      final serverSeconds = response.timer.toInt();
      if (serverSeconds <= 0) {
        _timeoutOutcome();
        return;
      }
      emit(state.copyWith(tickerSecond: serverSeconds));
      _startTicker();
    }

    if (response.isBlocked) {
      _stop();
      _clearPending();
      // Подробности (причина, срок, поддержка) отдаёт гейт входа: идём в
      // AUTH_CONFIRMATION напрямую (облачный пароль заблокированному не нужен)
      // — он ответит accountBlocked с ними в трейлере.
      var redirectURI = accountBlockedURI(const {});
      if (response.confirmationSession.isNotEmpty) {
        final completion = await AuthLoginCompleter().complete(response.confirmationSession);
        if (completion.redirectURI.startsWith("/auth/blocked")) redirectURI = completion.redirectURI;
      }
      if (isClosed) return;
      emit(state.copyWith(result: AuthCallPasswordConfirmationResult.blocked, status: Status.success, redirectURI: redirectURI));
      return;
    }

    switch (response.authCallPasswordStatus) {
      case AuthCallPasswordStatus.success:
        if (_completed) return;
        _completed = true;
        _stop();
        _clearPending();

        // Двухшаговая проверка: если у аккаунта включён облачный пароль, вход здесь
        // не завершаем — уводим на экран ввода пароля, передав confirmationSession
        // (hex) в query. Завершение входа произойдёт там после проверки пароля.
        if (response.hasTwoStepVerification) {
          final confirmationSessionHex = utils.bytesToHex(Uint8List.fromList(response.confirmationSession));
          emit(state.copyWith(redirectURI: Uri.parse("/auth/cloud_password?confirmationSession=$confirmationSessionHex").toString()));
          return;
        }

        // Иначе завершаем вход общей последовательностью (META_DATA →
        // AUTH_CONFIRMATION → persist → Auth.refresh), вынесенной в AuthLoginCompleter.
        final completion = await AuthLoginCompleter().complete(response.confirmationSession);
        if (completion.redirectURI.isNotEmpty) {
          emit(state.copyWith(status: Status.success, error: completion.error, redirectURI: completion.redirectURI));
        } else {
          emit(state.copyWith(status: Status.success, error: completion.error));
        }

      case AuthCallPasswordStatus.error:
        _stop();
        _clearPending();
        emit(
          state.copyWith(
            result: AuthCallPasswordConfirmationResult.error,
            error: response.hasErrorMessage() ? response.errorMessage : null,
            redirectURI: Uri.parse("/auth").toString(),
          ),
        );

      // healthcheck и прочие промежуточные статусы — продолжаем ждать звонок.
      default:
        logger.debug('call password check: waiting (status=${response.authCallPasswordStatus})');
    }
  }

  /// Гасит стрим (переподключение, тикер не трогает). Идемпотентно.
  void _stopStream() {
    _subscription?.cancel();
    _subscription = null;

    final outgoing = _outgoing;
    _outgoing = null;
    if (outgoing != null && !outgoing.isClosed) {
      outgoing.close();
    }
  }

  /// Гасит таймер и стрим — терминальный исход или close(). Идемпотентно.
  void _stop() {
    _ticker?.cancel();
    _ticker = null;
    _stopStream();
  }

  /// Незавершённая сессия закрыта — рестарт приложения больше не должен
  /// восстанавливать экран подтверждения.
  Future<void> _clearPending() async {
    try {
      await getIt.get<DeviceRepositories>().pendingCallPassword.clear();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, "call password: clear pending session failed");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Вернулись из звонилки/фона: пока приложение было там, стрим мог умереть
    // (iOS засыпает изолят, Android рвёт сеть) — переподключаемся сразу.
    // Остаток таймера снова выровняет первый healthcheck свежего стрима.
    if (state != AppLifecycleState.resumed) return;
    if (isClosed || _completed || _outgoing != null) return;
    _reconnectTimer?.cancel();
    _reconnectAttempt = 0;
    _openStream();
  }

  @override
  Future<void> close() {
    _reconnectTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _stop();
    return super.close();
  }
}
