import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';
import 'package:yandex_login_sdk/yandex_login_sdk.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../settings.dart';
import '../../utils.dart';
import '../../protobuf.dart';

import 'auth_login_completer.dart';
import 'auth_state.dart';

enum PhoneValidationError { empty, notAllowRegion }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final settings = getIt.get<Settings>();

  final phoneUtil = PhoneNumberUtil.instance;

  final _passkeyAuthenticator = PasskeyAuthenticator();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // Insert code initialization

    emit(state.copyWith(status: Status.success));
  }

  PhoneValidationError? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return PhoneValidationError.empty;

    final PhoneNumber phoneNumber;
    try {
      phoneNumber = phoneUtil.parse(value, "RU");
    } catch (err) {
      logger.error(err);
      return PhoneValidationError.empty;
    }

    if (phoneUtil.getNumberType(phoneNumber) != PhoneNumberType.mobile) {
      return PhoneValidationError.notAllowRegion;
    }

    return null;
  }

  Future<void> onPressed(String phoneNumber) async {
    emit(state.copyWith(status: Status.loading, error: null));

    final phoneNumberNormalization = utils.phoneNormalization(phoneNumber: phoneNumber);

    // Workflow moderation application store
    final phoneNumberEnable = settings.phoneNumberModerationApplicationStoreEnable;
    if (phoneNumberEnable && settings.phoneNumberModerationApplicationStore == phoneNumberNormalization.raw) {
      final messageRequest = Message(
        messageType: MessageType.AUTH_MODERATION_APPLICATION_STORE,
        message: AuthModerationApplicationStore_Request(phoneNumber: phoneNumberNormalization.raw).writeToBuffer(),
      );

      late Message response;
      final grpcError = await api.call(() async {
        response = await api.client.unary(messageRequest);
      });

      if (grpcError.status == APIStatus.error) {
        emit(state.copyWith(status: Status.success, error: grpcError.error));
        return;
      }

      final messageResponse = AuthModerationApplicationStore_Response.fromBuffer(response.message);
      final moderationApplicationStoreSession = utils.bytesToHex(Uint8List.fromList(messageResponse.moderationApplicationStoreSession));

      final phoneNormalization = utils.phoneNormalization(phoneNumber: phoneNumber);

      final uri = Uri.parse("/auth/moderation_application_store").replace(
        queryParameters: {
          "moderationApplicationStoreSession": moderationApplicationStoreSession,
          "phoneNumber": phoneNormalization.international,
        },
      );

      emit(state.copyWith(status: Status.success, error: "", redirectURI: uri.toString()));
      return;
    }

    // Workflow call password
    final messageRequest = Message(
      messageType: MessageType.AUTH_CALL_PASSWORD,
      message: AuthCallPassword_Request(phoneNumber: phoneNumberNormalization.raw).writeToBuffer(),
    );

    late Message response;
    final grpcError = await api.call(() async {
      response = await api.client.unary(messageRequest);
    });

    if (grpcError.status == APIStatus.error) {
      emit(state.copyWith(status: Status.success, error: grpcError.error));
      return;
    }

    final messageResponse = AuthCallPassword_Response.fromBuffer(response.message);

    final callPasswordSession = utils.bytesToHex(Uint8List.fromList(messageResponse.callPasswordSession));

    final uri = Uri.parse("/auth/call_password_confirmation").replace(
      queryParameters: {
        "callPasswordSession": callPasswordSession,
        "confirmationPhoneNumber": messageResponse.confirmationPhoneNumber,
        "timeout": messageResponse.timeout.toString(),
      },
    );

    emit(state.copyWith(status: Status.success, error: "", redirectURI: uri.toString()));
    return;
  }

  /// Вход по ключу доступа (passkey), discoverable — без ввода телефона.
  /// LOGIN_BEGIN (сервер отдаёт WebAuthn RequestOptions) → нативный промпт →
  /// LOGIN_FINISH (сервер проверяет assertion и выдаёт confirmationSession).
  /// Если у аккаунта включён облачный пароль — уводим на его ввод (как в
  /// call-password flow); иначе завершаем вход общим [AuthLoginCompleter].
  ///
  /// Возвращает результат для экрана (пустой [error]+[redirectURI] = пользователь
  /// отменил промпт, ничего не показываем). Не бросает.
  Future<({String error, String redirectURI})> passkeySignIn() async {
    if (!await utils.hasNetwork()) {
      return (error: "grpcError.unableConnectServer", redirectURI: "");
    }

    // Begin — сервер генерирует challenge и отдаёт RequestOptions (JSON).
    // Идемпотентен, поэтому с retryTransient: сразу после выхода первый unary
    // может попасть на рвущееся соединение (см. API.call).
    final beginRequest = Message(messageType: MessageType.PASSKEY_LOGIN_BEGIN);
    late Message beginMessage;
    final beginError = await api.call(() async {
      beginMessage = await api.client.unary(beginRequest);
    }, retryTransient: true);
    if (beginError.status == APIStatus.error) {
      return (error: beginError.error, redirectURI: "");
    }
    final begin = PasskeyLoginBegin_Response.fromBuffer(beginMessage.message);

    // Нативный промпт (Face ID / Touch ID / отпечаток).
    final AuthenticateResponseType assertion;
    try {
      final decoded = jsonDecode(utf8.decode(begin.publicKey)) as Map<String, dynamic>;
      // Сервер (go-webauthn) присылает опции в обёртке {"publicKey": {...}}.
      final options = decoded['publicKey'] as Map<String, dynamic>? ?? decoded;
      final request = AuthenticateRequestType.fromJson(
        options,
        mediation: MediationType.Optional,
        preferImmediatelyAvailableCredentials: false,
      );
      assertion = await _passkeyAuthenticator.authenticate(request);
    } on PasskeyAuthCancelledException {
      // Пользователь закрыл промпт — не ошибка.
      return (error: "", redirectURI: "");
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, "passkey authenticate failed");
      return (error: "passkey.verificationFailed", redirectURI: "");
    }

    // Finish — сервер проверяет assertion и выдаёт confirmationSession.
    final finishRequest = Message(
      messageType: MessageType.PASSKEY_LOGIN_FINISH,
      message: PasskeyLoginFinish_Request(
        loginSession: begin.loginSession,
        credential: utf8.encode(assertion.toJsonString()),
      ).writeToBuffer(),
    );
    late Message finishMessage;
    final finishError = await api.call(() async {
      finishMessage = await api.client.unary(finishRequest);
    });
    if (finishError.status == APIStatus.error) {
      return (error: finishError.error, redirectURI: "");
    }
    final finish = PasskeyLoginFinish_Response.fromBuffer(finishMessage.message);

    // Двухшаговая проверка: passkey её НЕ обходит — уводим на ввод облачного
    // пароля, передав confirmationSession (как в call-password flow).
    if (finish.hasTwoStepVerification) {
      final confirmationSessionHex = utils.bytesToHex(Uint8List.fromList(finish.confirmationSession));
      return (error: "", redirectURI: Uri.parse("/auth/cloud_password?confirmationSession=$confirmationSessionHex").toString());
    }

    // Иначе завершаем вход общей последовательностью.
    final completion = await AuthLoginCompleter().complete(finish.confirmationSession);
    return (error: completion.error, redirectURI: completion.redirectURI);
  }

  Future<String> yandexSignIn() async {
    try {
      final result = await YandexLoginSdk.signIn(clientId: settings.yandexOauthClientID, strategy: YandexLoginStrategy.auto);
      logger.debug('Access token: ${result.token}');
      logger.debug('JWT (iOS only): ${result.jwt}');
      logger.debug('Expires at (Android only): ${result.expiresAt}');
      return result.token;
    } on YandexAuthCancelledException {
      // User dismissed the sheet — no need to show an error.
    } on YandexAuthInProgressException {
      // A sign-in is already running — ignore the extra tap.
    } on YandexAuthUnsupportedException {
      // Web/desktop or unsupported — fall back to your own WebView.
    } on YandexAuthException catch (e) {
      logger.error('Yandex SDK error: $e');
    }
    return "";
  }
}
