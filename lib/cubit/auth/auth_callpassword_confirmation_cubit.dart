import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cryptography/cryptography.dart';
import 'package:grpc/grpc.dart';
import 'package:pqcrypto/pqcrypto.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import '../../repositories/repositories.dart';
import '../../utils.dart';
import '../../protobuf.dart';
import 'auth_callpassword_confirmation_state.dart';

class AuthCallpasswordConfirmationCubit extends Cubit<AuthCallpasswordConfirmationState> {
  AuthCallpasswordConfirmationCubit() : super(AuthCallpasswordConfirmationState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final repositories = getIt.get<Repositories>();

  final ed25519 = Ed25519();
  final kem = PqcKem.kyber768;

  // Обратный отсчёт ожидания звонка.
  Timer? _ticker;

  // Сервер считает таймаут от момента создания сессии (в CallPassword), а не от
  // открытия этого экрана, поэтому его остаток меньше нашего полного timeout.
  // Первый healthcheck несёт реальный остаток — по нему одноразово выравниваем
  // локальный отсчёт. Повторно не синхронизируем, иначе тикер «прыгал» бы.
  bool _serverTimerSynced = false;

  // Выделенный (незашифрованный) двунаправленный стрим проверки звонка-пароля.
  // Пользователь ещё не авторизован и сессионного ключа нет, поэтому постоянный
  // зашифрованный стрим в [API] здесь не применим — как и unary-вызовы pre-auth
  // flow, открываем отдельный стрим и шлём/принимаем открытый protobuf.
  StreamController<Message>? _outgoing;
  StreamSubscription<Message>? _subscription;

  Future<void> initialization({required String callPasswordSession, required String confirmationPhoneNumber, required String timeout}) async {
    emit(state.copyWith(status: Status.loading));

    // timeout приходит с сервера уже в секундах (time.Duration.Seconds() на бэкенде).
    final timeoutSeconds = (double.tryParse(timeout) ?? 0).round();

    emit(state.copyWith(
      status: Status.success,
      callPasswordSession: utils.hexToBytes(callPasswordSession),
      confirmationPhoneNumber: confirmationPhoneNumber,
      timeout: timeoutSeconds,
      tickerSecond: timeoutSeconds,
      result: AuthCallPasswordConfirmationResult.waiting,
    ));

    _startTicker();
    _openStream();
  }

  /// Запускает посекундный обратный отсчёт. По достижении нуля — таймаут: гасим
  /// стрим и уводим пользователя обратно на /auth.
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.tickerSecond - 1;
      if (next <= 0) {
        _stop();
        emit(state.copyWith(
          tickerSecond: 0,
          result: AuthCallPasswordConfirmationResult.timeout,
          redirectURI: Uri.parse("/auth"),
        ));
        return;
      }
      emit(state.copyWith(tickerSecond: next));
    });
  }

  /// Открывает выделенный двунаправленный стрим, отправляет запрос проверки и
  /// слушает ответы сервера, пока пользователь ждёт подтверждения звонка.
  void _openStream() {
    _outgoing = StreamController<Message>();

    try {
      final responseStream = api.client.stream(_outgoing!.stream);

      _subscription = responseStream.listen(
        _onMessage,
        onError: (error, stackTrace) {
          logger.handle(error, stackTrace);
          _stop();
          final message = error is GrpcError ? (error.message ?? "errorConnectingServer") : "errorConnectingServer";
          emit(state.copyWith(
            result: AuthCallPasswordConfirmationResult.error,
            error: message,
            redirectURI: Uri.parse("/auth"),
          ));
        },
        onDone: () {
          // Сервер завершил стрим штатно (истёк серверный таймаут ожидания
          // звонка: ctx.Done() -> return nil). Это не ошибка сети — трактуем как
          // таймаут. Если стрим закрыли мы сами по терминальному статусу или
          // локальному тикеру, _outgoing уже null и ветку пропускаем.
          if (_outgoing == null) return;
          _stop();
          emit(state.copyWith(
            result: AuthCallPasswordConfirmationResult.timeout,
            redirectURI: Uri.parse("/auth"),
          ));
        },
        cancelOnError: true,
      );

      _outgoing!.add(Message(
        messageType: MessageType.AUTH_CALL_PASSWORD_CONFIRMATION,
        message: AuthCallPasswordConfirmation_Request(
          callPasswordSession: state.callPasswordSession,
        ).writeToBuffer(),
      ));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      _stop();
      emit(state.copyWith(
        result: AuthCallPasswordConfirmationResult.error,
        error: "errorConnectingServer",
        redirectURI: Uri.parse("/auth"),
      ));
    }
  }

  /// Разбор входящего сообщения стрима. Отсчёт ведёт локальный таймер от
  /// исходного [timeout] — серверное поле [timer] в ответах не перезаписывает
  /// его (иначе промежуточные healthcheck сбрасывали бы отсчёт).
  Future<void> _onMessage(Message message) async {
    if (message.messageType != MessageType.AUTH_CALL_PASSWORD_CONFIRMATION) {
      logger.debug('call password check: unexpected message type ${message.messageType}');
      return;
    }

    final response = AuthCallPasswordConfirmation_Response.fromBuffer(message.message);

    // Одноразово выравниваем отсчёт по реальному серверному остатку (первый
    // healthcheck с ненулевым timer). Дальше тикер идёт локально.
    if (!_serverTimerSynced && response.hasTimer()) {
      _serverTimerSynced = true;
      final serverSeconds = response.timer.toInt();
      if (serverSeconds > 0) {
        emit(state.copyWith(tickerSecond: serverSeconds));
      }
    }

    if (response.isBlocked) {
      _stop();
      emit(state.copyWith(
        result: AuthCallPasswordConfirmationResult.blocked,
        error: response.hasErrorMessage() ? response.errorMessage : null,
        redirectURI: Uri.parse("/auth"),
      ));
      return;
    }

    switch (response.authCallPasswordStatus) {
      case AuthCallPasswordStatus.success:
        _stop();
        // TODO: второй шаг входа (обмен ключами / two-step verification) ещё не
        // реализован — здесь появится переход на экран подтверждения с
        // confirmationSession. См. TODO «Second login workflow is unfinished».

        // Meta data info
        final messageMetaDataInfoRequest = Message(messageType: MessageType.META_DATA_INFO);

        late Message metaDataResponse;
        final metaDataGrpcError = await api.call(() async {
          metaDataResponse = await api.client.unary(messageMetaDataInfoRequest);
        });

        if (metaDataGrpcError.status == APIStatus.error) {
          emit(state.copyWith(status: Status.success, error: metaDataGrpcError.error));
          return;
        }

        final metaData = MetadataInfo_Response.fromBuffer(metaDataResponse.message);

        final (publicKeySharedKey, privateKeySharedKey) = kem.generateKeyPair();
        final (publicKeySalt, privateKeySalt) = kem.generateKeyPair();

        final packageInfo = await utils.packageInfo();
        final deviceInfo = await utils.deviceInfo();

        final messageAuthConfirmationRequest = Message(
          messageType: MessageType.AUTH_CONFIRMATION,
          message: AuthConfirmation_Request(
            confirmationSession: response.confirmationSession,
            publicKeySharedKey: publicKeySharedKey,
            publicKeySalt: publicKeySalt,
            deviceModel: deviceInfo.deviceModel,
            os: deviceInfo.osCode,
            osVersion: deviceInfo.osVersion,
            appVersion: packageInfo.appVersion,
            appBuildNumber: packageInfo.appBuildNumber,
          ).writeToBuffer(),
        );

        late Message messageAuthConfirmationResponse;
        final authConfirmationGrpcError = await api.call(() async {
          messageAuthConfirmationResponse = await api.client.unary(messageAuthConfirmationRequest);
        });

        if (authConfirmationGrpcError.status == APIStatus.error && authConfirmationGrpcError.statusCode == StatusCode.invalidArgument) {
          emit(state.copyWith(status: Status.success, error: authConfirmationGrpcError.error, redirectURI: Uri.parse("/auth")));
          return;
        } else if (authConfirmationGrpcError.status == APIStatus.error) {
          emit(state.copyWith(status: Status.success, error: authConfirmationGrpcError.error));
          return;
        }

        final authConfirmationResponse = AuthConfirmation_Response.fromBuffer(messageAuthConfirmationResponse.message);

        // Exchange
        final serverPublicKey = SimplePublicKey(metaData.eddsa.publicKey, type: KeyPairType.ed25519);

        // Ed25519 signatures must be exactly 64 bytes; an empty/short signature
        // (e.g. missing in the server response) would otherwise make verify() throw
        // instead of returning false, crashing the flow before the check below.
        if (authConfirmationResponse.signatureSharedKey.length != 64 || authConfirmationResponse.signatureSalt.length != 64) {
          logger.error('mlkem ciphertext signature has invalid length');
          emit(state.copyWith(status: Status.success, error: 'signature verification failed'));
          return;
        }

        final checkSharedKey = await ed25519.verify(
          authConfirmationResponse.ciphertextSharedKey,
          signature: Signature(authConfirmationResponse.signatureSharedKey, publicKey: serverPublicKey),
        );

        final checkSalt = await ed25519.verify(
          authConfirmationResponse.ciphertextSalt,
          signature: Signature(authConfirmationResponse.signatureSalt, publicKey: serverPublicKey),
        );

        if (!checkSharedKey || !checkSalt) {
          logger.error('mlkem ciphertext signature verification failed');
          emit(state.copyWith(status: Status.success, error: 'signature verification failed'));
          return;
        }

        final sharedKey = kem.decapsulate(privateKeySharedKey, Uint8List.fromList(authConfirmationResponse.ciphertextSharedKey));
        final sharedSalt = kem.decapsulate(privateKeySalt, Uint8List.fromList(authConfirmationResponse.ciphertextSalt));

        // Create or update user
        await repositories.users.createOrUpdate(userID: authConfirmationResponse.userID, phoneNumber: authConfirmationResponse.phoneNumber);

        await repositories.sessions.deleteAndCreate(
          session: authConfirmationResponse.session,
          sessionID: authConfirmationResponse.sessionID,
          userID: authConfirmationResponse.userID,
          sharedKey: sharedKey,
          sharedSalt: sharedSalt,
          createAt: DateTime.now(),
        );

        await getIt.get<Auth>().refresh();

        emit(state.copyWith(
          redirectURI: Uri.parse("/chats"),
        ));

      case AuthCallPasswordStatus.error:
        _stop();
        emit(state.copyWith(
          result: AuthCallPasswordConfirmationResult.error,
          error: response.hasErrorMessage() ? response.errorMessage : null,
          redirectURI: Uri.parse("/auth"),
        ));

      // healthcheck и прочие промежуточные статусы — продолжаем ждать звонок.
      default:
        logger.debug('call password check: waiting (status=${response.authCallPasswordStatus})');
    }
  }

  /// Гасит таймер и стрим. Идемпотентно.
  void _stop() {
    _ticker?.cancel();
    _ticker = null;

    _subscription?.cancel();
    _subscription = null;

    final outgoing = _outgoing;
    _outgoing = null;
    if (outgoing != null && !outgoing.isClosed) {
      outgoing.close();
    }
  }

  @override
  Future<void> close() {
    _stop();
    return super.close();
  }
}
