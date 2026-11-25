import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:passkeys/types.dart';
import 'package:yandex_login_sdk/yandex_login_sdk.dart';

import '../../accounts.dart';
import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../repositories.dart';
import '../../settings.dart';
import '../../utils.dart';
import '../../protobuf.dart';

import 'auth_login_completer.dart';
import 'auth_sdk.dart';
import 'auth_state.dart';

enum PhoneValidationError { empty, notAllowRegion }

void _reportCrashlyticsError(Object error, StackTrace stackTrace, String reason) {
  unawaited(FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason));
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({PasskeySdk? passkeySdk, YandexSdk? yandexSdk, VkSdk? vkSdk, void Function(Object, StackTrace, String)? reportError})
    : _passkeySdk = passkeySdk ?? NativePasskeySdk(),
      _yandexSdk = yandexSdk ?? NativeYandexSdk(),
      _vkSdk = vkSdk ?? NativeVkSdk(),
      _reportError = reportError ?? _reportCrashlyticsError,
      super(AuthState());

  final PasskeySdk _passkeySdk;
  final YandexSdk _yandexSdk;
  final VkSdk _vkSdk;
  final void Function(Object, StackTrace, String) _reportError;

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final settings = getIt.get<Settings>();

  final phoneUtil = PhoneNumberUtil.instance;

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

    // Этот аккаунт уже вошёл на устройстве (другой слот): повторный вход
    // заменил бы его сессию на сервере.
    if (await isPhoneSignedIn(phoneNumberNormalization.raw)) {
      emit(state.copyWith(status: Status.success, error: "grpcError.accountAlreadyAdded"));
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

    // Тестовый аккаунт (админка → «Тестовые аккаунты»): сервер не звонит, а
    // сразу даёт сессию входа по постоянному коду.
    if (messageResponse.fixedCode) {
      final uri = Uri.parse("/auth/moderation_application_store").replace(
        queryParameters: {
          "moderationApplicationStoreSession": utils.bytesToHex(Uint8List.fromList(messageResponse.fixedCodeSession)),
          "phoneNumber": phoneNumberNormalization.international,
        },
      );
      emit(state.copyWith(status: Status.success, error: "", redirectURI: uri.toString()));
      return;
    }

    final callPasswordSession = utils.bytesToHex(Uint8List.fromList(messageResponse.callPasswordSession));

    // Незавершённая сессия в device.db (docs/plans/06-callpassword-
    // reconnect.md): переживает смерть процесса во время ожидания звонка —
    // после рестарта Routers._redirect восстановит экран подтверждения.
    // Сбой записи вход не ломает: стрим и так держит сессию в памяти.
    try {
      await getIt.get<DeviceRepositories>().pendingCallPassword.set(
        callPasswordSession: callPasswordSession,
        confirmationPhoneNumber: messageResponse.confirmationPhoneNumber,
        timeout: messageResponse.timeout.round(),
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, "call password: persist pending session failed");
    }

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
      assertion = await _passkeySdk.authenticate(request);
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

  /// Вход через Яндекс ID: нативный SDK (приложение Яндекса или браузер) →
  /// OAuth access_token → AUTH_YANDEX. Сервер сам проверяет токен (в т.ч. что он
  /// выдан нашему client_id), берёт подтверждённый телефон аккаунта и выдаёт
  /// confirmationSession — дальше как у passkey: облачный пароль или
  /// [AuthLoginCompleter]. Регион номера не ограничен (в отличие от звонка).
  ///
  /// Возвращает результат для экрана (пустой [error]+[redirectURI] = пользователь
  /// отменил вход, ничего не показываем). Не бросает.
  Future<({String error, String redirectURI})> yandexSignIn() async {
    if (!await utils.hasNetwork()) {
      return (error: "grpcError.unableConnectServer", redirectURI: "");
    }

    // Диагностика SDK (в т.ч. нативные логи iOS/Android) — в наш логгер.
    YandexLoginSdk.onLog ??= (level, message, {error, stackTrace}) =>
        logger.debug('YandexLoginSdk [${level.name}] $message${error == null ? '' : ' $error'}');

    final String token;
    try {
      token = await _yandexSdk.signIn(settings.yandexOauthClientID);
    } on YandexAuthCancelledException {
      // Пользователь закрыл окно Яндекса — не ошибка.
      return (error: "", redirectURI: "");
    } on YandexAuthInProgressException {
      // Вход уже идёт — лишнее нажатие игнорируем.
      return (error: "", redirectURI: "");
    } on YandexAuthException catch (error, stackTrace) {
      logger.handle(error, stackTrace, "yandex sign in failed");
      // Non-fatal в Crashlytics: причина сбоя SDK (код + текст) иначе не видна —
      // запрос до нашего сервера в этом случае не доходит.
      _reportError(error, stackTrace, "yandex sign in failed: ${error.code} ${error.message}");
      return (error: "yandex.failed", redirectURI: "");
    }
    if (token.isEmpty) {
      return (error: "yandex.failed", redirectURI: "");
    }

    final request = Message(
      messageType: MessageType.AUTH_YANDEX,
      message: AuthYandex_Request(token: token).writeToBuffer(),
    );
    late Message responseMessage;
    final callError = await api.call(() async {
      responseMessage = await api.client.unary(request);
    });
    if (callError.status == APIStatus.error) {
      return (error: callError.error, redirectURI: "");
    }
    final response = AuthYandex_Response.fromBuffer(responseMessage.message);

    // Двухшаговая проверка: вход через Яндекс её НЕ обходит.
    if (response.hasTwoStepVerification) {
      final confirmationSessionHex = utils.bytesToHex(Uint8List.fromList(response.confirmationSession));
      return (error: "", redirectURI: Uri.parse("/auth/cloud_password?confirmationSession=$confirmationSessionHex").toString());
    }

    final completion = await AuthLoginCompleter().complete(response.confirmationSession);
    return (error: completion.error, redirectURI: completion.redirectURI);
  }

  /// Вход через VK ID доступен, если в сборку вшит client_id VK (iOS —
  /// Info.plist, Android — манифест). Явной проверки платформы не нужно: на
  /// macOS плагина нет, и `clientId()` вернёт пустую строку (см. auth_sdk.dart).
  Future<bool> vkSignInAvailable() async => (await _vkSdk.clientId()).isNotEmpty;

  /// Вход через VK ID: нативный SDK (приложение VK или браузер) → OAuth
  /// access_token с правом `phone` → AUTH_VK. Сервер сам проверяет токен (в т.ч.
  /// пару «client_id + токен» у VK), берёт телефон аккаунта и выдаёт
  /// confirmationSession — дальше как у Яндекса: облачный пароль или
  /// [AuthLoginCompleter]. Регион номера не ограничен.
  ///
  /// Возвращает результат для экрана (пустой [error]+[redirectURI] = пользователь
  /// закрыл окно VK, ничего не показываем). Не бросает.
  Future<({String error, String redirectURI})> vkSignIn() async {
    if (!await utils.hasNetwork()) {
      return (error: "grpcError.unableConnectServer", redirectURI: "");
    }

    // VK не настроен в этой сборке (нет client_id/секрета в нативной
    // конфигурации) — кнопки на экране быть не должно, но на всякий случай.
    final clientId = await _vkSdk.clientId();
    if (clientId.isEmpty) {
      return (error: "vk.failed", redirectURI: "");
    }

    final String token;
    try {
      token = await _vkSdk.signIn();
    } on VkAuthCancelledException {
      // Пользователь закрыл окно VK — не ошибка.
      return (error: "", redirectURI: "");
    } on VkAuthException catch (error, stackTrace) {
      logger.handle(error, stackTrace, "vk sign in failed");
      // Non-fatal в Crashlytics: причина сбоя SDK (текст) иначе не видна —
      // запрос до нашего сервера в этом случае не доходит.
      _reportError(error, stackTrace, "vk sign in failed: ${error.description}");
      return (error: "vk.failed", redirectURI: "");
    }
    if (token.isEmpty) {
      return (error: "vk.failed", redirectURI: "");
    }

    try {
      final request = Message(
        messageType: MessageType.AUTH_VK,
        message: AuthVK_Request(token: token, clientId: clientId).writeToBuffer(),
      );
      late Message responseMessage;
      final callError = await api.call(() async {
        responseMessage = await api.client.unary(request);
      });
      if (callError.status == APIStatus.error) {
        return (error: callError.error, redirectURI: "");
      }
      final response = AuthVK_Response.fromBuffer(responseMessage.message);

      // Двухшаговая проверка: вход через VK её НЕ обходит.
      if (response.hasTwoStepVerification) {
        final confirmationSessionHex = utils.bytesToHex(Uint8List.fromList(response.confirmationSession));
        return (error: "", redirectURI: Uri.parse("/auth/cloud_password?confirmationSession=$confirmationSessionHex").toString());
      }

      final completion = await AuthLoginCompleter().complete(response.confirmationSession);
      return (error: completion.error, redirectURI: completion.redirectURI);
    } finally {
      // logout VK SDK — запрос на сервер VK, отзывающий токен: зовём строго
      // после ответа AUTH_VK (иначе сервер не успел бы подтвердить номер), но
      // обязательно — чтобы VK-сессия не оставалась на устройстве. Ошибки
      // logout не важны — обёртка их не бросает.
      unawaited(_vkSdk.logout());
    }
  }
}
