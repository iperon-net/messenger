import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/cubit/auth/auth_cubit.dart';
import 'package:messenger/cubit/auth/auth_sdk.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' show PhoneNumberModel;
import 'package:messenger/protobuf.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/settings.dart';
import 'package:messenger/utils.dart';
import 'package:passkeys/types.dart';
import 'package:yandex_login_sdk/yandex_login_sdk.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late FakeAccounts accounts;
  late FakeUtils utils;
  late FakePasskeySdk passkeySdk;
  late FakeYandexSdk yandexSdk;
  late AuthCubit cubit;
  late List<({Object error, String reason})> reportedErrors;

  setUp(() async {
    api = FakeApi();
    accounts = FakeAccounts();
    utils = FakeUtils();
    passkeySdk = FakePasskeySdk();
    yandexSdk = FakeYandexSdk();
    reportedErrors = [];
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(utils);
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Settings>(FakeSettings());
    getIt.registerSingleton<DeviceRepositories>(FakeDeviceRepositories(accounts));
    cubit = AuthCubit(
      passkeySdk: passkeySdk,
      yandexSdk: yandexSdk,
      reportError: (error, stackTrace, reason) => reportedErrors.add((error: error, reason: reason)),
    );
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

  void enqueuePasskeyBegin({String? publicKey}) {
    api.enqueueResponse(
      MessageType.PASSKEY_LOGIN_BEGIN,
      Message(
        messageType: MessageType.PASSKEY_LOGIN_BEGIN,
        message: PasskeyLoginBegin_Response(
          loginSession: [3, 4],
          publicKey: utf8.encode(
            publicKey ??
                jsonEncode({
                  'publicKey': {'challenge': 'Y2hhbGxlbmdl', 'rpId': 'iperon.net'},
                }),
          ),
        ).writeToBuffer(),
      ),
    );
  }

  test('успех: отправляет нормализованный телефон и открывает подтверждение', () async {
    api.enqueueResponse(
      MessageType.AUTH_CALL_PASSWORD,
      Message(
        messageType: MessageType.AUTH_CALL_PASSWORD,
        message: AuthCallPassword_Response(
          callPasswordSession: [1, 2, 255],
          confirmationPhoneNumber: '+7 *** ***-**-44',
          timeout: 60,
        ).writeToBuffer(),
      ),
    );

    await cubit.onPressed('8 (909) 160-00-44');

    final request = AuthCallPassword_Request.fromBuffer(api.requests.single.message);
    expect(api.requests.single.messageType, MessageType.AUTH_CALL_PASSWORD);
    expect(request.phoneNumber, '79091600044');
    expect(cubit.state.error, isEmpty);

    final uri = Uri.parse(cubit.state.redirectURI);
    expect(uri.path, '/auth/call_password_confirmation');
    expect(uri.queryParameters, {'callPasswordSession': '0102ff', 'confirmationPhoneNumber': '+7 *** ***-**-44', 'timeout': '60.0'});
  });

  test('тестовый аккаунт: открывает store moderation с session и телефоном', () async {
    api.enqueueResponse(
      MessageType.AUTH_CALL_PASSWORD,
      Message(
        messageType: MessageType.AUTH_CALL_PASSWORD,
        message: AuthCallPassword_Response(fixedCode: true, fixedCodeSession: [10, 11]).writeToBuffer(),
      ),
    );

    await cubit.onPressed('8 (909) 160-00-44');

    final uri = Uri.parse(cubit.state.redirectURI);
    expect(uri.path, '/auth/moderation_application_store');
    expect(uri.queryParameters['moderationApplicationStoreSession'], '0a0b');
    expect(uri.queryParameters['phoneNumber'], '+7 909 160-00-44');
  });

  test('offline: показывает ошибку соединения без redirect', () async {
    api.enqueueCallResult(
      const APICallStatus(
        status: APIStatus.error,
        statusCode: StatusCode.unavailable,
        error: 'grpcError.errorConnectingServer',
        isGrpc: true,
      ),
    );

    await cubit.onPressed('8 (909) 160-00-44');

    expect(cubit.state.error, 'grpcError.errorConnectingServer');
    expect(cubit.state.redirectURI, isEmpty);
    expect(api.requests, isEmpty);
  });

  test('уже добавленный аккаунт: не запрашивает новый звонок', () async {
    accounts.slots = [
      (
        accountID: 'other',
        userID: Uint8List.fromList([1]),
        phoneNumber: '+7 (909) 160-00-44',
        name: '',
        avatarPath: '',
        active: false,
        environment: 'staging',
      ),
    ];

    await cubit.onPressed('8 (909) 160-00-44');

    expect(cubit.state.error, 'grpcError.accountAlreadyAdded');
    expect(cubit.state.redirectURI, isEmpty);
    expect(api.callCount, 0);
    expect(api.requests, isEmpty);
  });

  test('тот же телефон в другом окружении не считается добавленным', () async {
    accounts.slots = [
      (
        accountID: 'production',
        userID: Uint8List.fromList([1]),
        phoneNumber: '79091600044',
        name: '',
        avatarPath: '',
        active: false,
        environment: 'production',
      ),
    ];
    api.enqueueCallResult(const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'offline'));

    await cubit.onPressed('8 (909) 160-00-44');

    expect(cubit.state.error, 'offline');
    expect(api.callCount, 1);
  });

  test('passkey offline не открывает нативный промпт и не вызывает API', () async {
    final result = await cubit.passkeySignIn();

    expect(result.error, 'grpcError.unableConnectServer');
    expect(result.redirectURI, isEmpty);
    expect(passkeySdk.requests, isEmpty);
    expect(api.callCount, 0);
  });

  test('Yandex offline не открывает SDK и не вызывает API', () async {
    final result = await cubit.yandexSignIn();

    expect(result.error, 'grpcError.unableConnectServer');
    expect(result.redirectURI, isEmpty);
    expect(yandexSdk.clientIDs, isEmpty);
    expect(api.callCount, 0);
  });

  test('passkey: ошибка LOGIN_BEGIN не открывает нативный промпт', () async {
    utils.network = true;
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'grpcError.errorConnectingServer'),
    );

    final result = await cubit.passkeySignIn();

    expect(result.error, 'grpcError.errorConnectingServer');
    expect(result.redirectURI, isEmpty);
    expect(passkeySdk.requests, isEmpty);
    expect(api.requests, isEmpty);
    expect(api.calls.single.retryTransient, isTrue);
  });

  test('passkey: повреждённые WebAuthn options не доходят до SDK и LOGIN_FINISH', () async {
    utils.network = true;
    enqueuePasskeyBegin(publicKey: 'not-json');

    final result = await cubit.passkeySignIn();

    expect(result.error, 'passkey.verificationFailed');
    expect(result.redirectURI, isEmpty);
    expect(passkeySdk.requests, isEmpty);
    expect(api.requests.map((request) => request.messageType), [MessageType.PASSKEY_LOGIN_BEGIN]);
  });

  test('passkey: отмена нативного промпта не считается ошибкой', () async {
    utils.network = true;
    enqueuePasskeyBegin();
    passkeySdk.error = PasskeyAuthCancelledException();

    final result = await cubit.passkeySignIn();

    expect(result.error, isEmpty);
    expect(result.redirectURI, isEmpty);
    expect(passkeySdk.requests, hasLength(1));
    expect(api.requests.map((request) => request.messageType), [MessageType.PASSKEY_LOGIN_BEGIN]);
  });

  test('passkey: ошибка SDK возвращает verificationFailed без LOGIN_FINISH', () async {
    utils.network = true;
    enqueuePasskeyBegin();
    passkeySdk.error = StateError('authenticator unavailable');

    final result = await cubit.passkeySignIn();

    expect(result.error, 'passkey.verificationFailed');
    expect(result.redirectURI, isEmpty);
    expect(api.requests.map((request) => request.messageType), [MessageType.PASSKEY_LOGIN_BEGIN]);
  });

  test('passkey: ошибка LOGIN_FINISH сохраняет пользователя на экране входа', () async {
    utils.network = true;
    enqueuePasskeyBegin();
    api.enqueueCallResult(const APICallStatus(status: APIStatus.success, statusCode: 0));
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'grpcError.errorConnectingServer'),
    );

    final result = await cubit.passkeySignIn();

    expect(result.error, 'grpcError.errorConnectingServer');
    expect(result.redirectURI, isEmpty);
    expect(passkeySdk.requests, hasLength(1));
    expect(api.requests.map((request) => request.messageType), [MessageType.PASSKEY_LOGIN_BEGIN]);
  });

  test('passkey успешно передаёт assertion и открывает облачный пароль', () async {
    utils.network = true;
    enqueuePasskeyBegin();
    api.enqueueResponse(
      MessageType.PASSKEY_LOGIN_FINISH,
      Message(
        messageType: MessageType.PASSKEY_LOGIN_FINISH,
        message: PasskeyLoginFinish_Response(hasTwoStepVerification: true, confirmationSession: [10, 11, 255]).writeToBuffer(),
      ),
    );

    final result = await cubit.passkeySignIn();

    expect(result.error, isEmpty);
    expect(Uri.parse(result.redirectURI).path, '/auth/cloud_password');
    expect(Uri.parse(result.redirectURI).queryParameters['confirmationSession'], '0a0bff');
    expect(passkeySdk.requests.single.challenge, 'Y2hhbGxlbmdl');
    expect(api.requests.map((request) => request.messageType), [MessageType.PASSKEY_LOGIN_BEGIN, MessageType.PASSKEY_LOGIN_FINISH]);
    final finish = PasskeyLoginFinish_Request.fromBuffer(api.requests.last.message);
    expect(finish.loginSession, [3, 4]);
    expect(jsonDecode(utf8.decode(finish.credential))['id'], 'credential-id');
  });

  test('Yandex: отмена и повторный вход не показывают ошибку', () async {
    utils.network = true;
    yandexSdk.error = const YandexAuthCancelledException();

    final cancelled = await cubit.yandexSignIn();
    yandexSdk.error = const YandexAuthInProgressException();
    final inProgress = await cubit.yandexSignIn();

    expect(cancelled, (error: '', redirectURI: ''));
    expect(inProgress, (error: '', redirectURI: ''));
    expect(yandexSdk.clientIDs, hasLength(2));
    expect(api.callCount, 0);
  });

  test('Yandex: ошибка SDK логируется и не вызывает API', () async {
    utils.network = true;
    yandexSdk.error = const YandexAuthException('native failure', code: 'FAILED');

    final result = await cubit.yandexSignIn();

    expect(result.error, 'yandex.failed');
    expect(result.redirectURI, isEmpty);
    expect(api.callCount, 0);
    expect(reportedErrors.single.error, isA<YandexAuthException>());
    expect(reportedErrors.single.reason, contains('FAILED native failure'));
  });

  test('Yandex: пустой OAuth token не отправляется на сервер', () async {
    utils.network = true;
    yandexSdk.token = '';

    final result = await cubit.yandexSignIn();

    expect(result.error, 'yandex.failed');
    expect(result.redirectURI, isEmpty);
    expect(api.callCount, 0);
  });

  test('Yandex: отсутствие подтверждённого телефона показывает ошибку сервера', () async {
    utils.network = true;
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.failedPrecondition, error: 'yandex.phoneMissing'),
    );

    final result = await cubit.yandexSignIn();

    expect(result.error, 'yandex.phoneMissing');
    expect(result.redirectURI, isEmpty);
    expect(api.requests, isEmpty);
  });

  test('Yandex успешно передаёт OAuth token и открывает облачный пароль', () async {
    utils.network = true;
    api.enqueueResponse(
      MessageType.AUTH_YANDEX,
      Message(
        messageType: MessageType.AUTH_YANDEX,
        message: AuthYandex_Response(hasTwoStepVerification: true, confirmationSession: [12, 13, 255]).writeToBuffer(),
      ),
    );

    final result = await cubit.yandexSignIn();

    expect(result.error, isEmpty);
    expect(Uri.parse(result.redirectURI).path, '/auth/cloud_password');
    expect(Uri.parse(result.redirectURI).queryParameters['confirmationSession'], '0c0dff');
    expect(yandexSdk.clientIDs, ['test-yandex-client']);
    final request = AuthYandex_Request.fromBuffer(api.requests.single.message);
    expect(request.token, 'oauth-token');
  });
}

final class FakePasskeySdk implements PasskeySdk {
  final requests = <AuthenticateRequestType>[];
  Object? error;

  @override
  Future<AuthenticateResponseType> authenticate(AuthenticateRequestType request) async {
    requests.add(request);
    if (error case final error?) throw error;
    return const AuthenticateResponseType(
      id: 'credential-id',
      rawId: 'cmF3LWlk',
      clientDataJSON: 'Y2xpZW50LWRhdGE',
      authenticatorData: 'YXV0aGVudGljYXRvci1kYXRh',
      signature: 'c2lnbmF0dXJl',
      userHandle: 'dXNlci1oYW5kbGU',
    );
  }
}

final class FakeYandexSdk implements YandexSdk {
  final clientIDs = <String>[];
  Object? error;
  String token = 'oauth-token';

  @override
  Future<String> signIn(String clientId) async {
    clientIDs.add(clientId);
    if (error case final error?) throw error;
    return token;
  }
}

final class FakeUtils implements Utils {
  var network = false;

  @override
  Future<bool> hasNetwork() async => network;

  @override
  PhoneNumberModel phoneNormalization({required String phoneNumber}) {
    return const PhoneNumberModel(
      international: '+7 909 160-00-44',
      national: '8 (909) 160-00-44',
      e164: '+79091600044',
      rfc3966: 'tel:+79091600044',
      raw: '79091600044',
    );
  }

  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeSettings implements Settings {
  @override
  String environment = 'staging';

  @override
  String yandexOauthClientID = 'test-yandex-client';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeAccounts implements Accounts {
  List<AccountSlot> slots = [];

  @override
  Future<List<AccountSlot>> all() async => slots;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeDeviceRepositories implements DeviceRepositories {
  @override
  final FakeAccounts accounts;

  FakeDeviceRepositories(this.accounts);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
