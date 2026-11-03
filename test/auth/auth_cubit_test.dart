import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/cubit/auth/auth_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' show PhoneNumberModel;
import 'package:messenger/protobuf.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/settings.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late FakeAccounts accounts;
  late AuthCubit cubit;

  setUp(() async {
    api = FakeApi();
    accounts = FakeAccounts();
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Settings>(FakeSettings());
    getIt.registerSingleton<DeviceRepositories>(FakeDeviceRepositories(accounts));
    cubit = AuthCubit();
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

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
}

final class FakeUtils implements Utils {
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
