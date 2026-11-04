import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/cubit/auth/auth_login_completer.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' show DeviceInfoModel, OS, PackageInfoModel;
import 'package:messenger/protobuf.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/settings.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late FakeSettings settings;
  late FakeRepositories repositories;
  late AuthLoginCompleter completer;

  setUp(() async {
    api = FakeApi();
    settings = FakeSettings();
    repositories = FakeRepositories();
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Settings>(settings);
    getIt.registerSingleton<DeviceRepositories>(FakeDeviceRepositories());
    getIt.registerSingleton<Repositories>(repositories);
    completer = AuthLoginCompleter();
  });

  tearDown(() async {
    await api.dispose();
    await getIt.reset();
  });

  void enqueueMetadata({List<int> publicKey = const [1, 2, 3]}) {
    api.enqueueResponse(
      MessageType.META_DATA_INFO,
      Message(
        messageType: MessageType.META_DATA_INFO,
        message: MetadataInfo_Response(mldsa: MetadataInfo_MLDSA(publicKey: publicKey)).writeToBuffer(),
      ),
    );
  }

  void enqueueAuthConfirmation([AuthConfirmation_Response? response]) {
    api.enqueueResponse(
      MessageType.AUTH_CONFIRMATION,
      Message(messageType: MessageType.AUTH_CONFIRMATION, message: (response ?? AuthConfirmation_Response()).writeToBuffer()),
    );
  }

  test('ошибка metadata возвращается без запроса подтверждения', () async {
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'grpcError.errorConnectingServer'),
    );

    final result = await completer.complete([10, 11]);

    expect(result.error, 'grpcError.errorConnectingServer');
    expect(result.redirectURI, isEmpty);
    expect(api.requests, isEmpty);
    expect(api.callCount, 1);
  });

  test('недоверенный ML-DSA ключ останавливает вход', () async {
    settings.serverMlDsaFingerprint = 'wrong-fingerprint';
    enqueueMetadata();

    final result = await completer.complete([10, 11]);

    expect(result.error, 'screenAuthCallpasswordConfirmation.serverKeyMismatch');
    expect(result.redirectURI, isEmpty);
    expect(api.requests.map((request) => request.messageType), [MessageType.META_DATA_INFO]);
  });

  test('блокировка возвращает подробности из trailers', () async {
    enqueueMetadata();
    api.enqueueCallResult(const APICallStatus(status: APIStatus.success, statusCode: 0));
    api.enqueueCallResult(
      const APICallStatus(
        status: APIStatus.error,
        statusCode: StatusCode.permissionDenied,
        error: accountBlockedError,
        trailers: {'iperon-block-reason': 'spam', 'iperon-block-until': '1900000000', 'iperon-support': 'support@iperon.net'},
      ),
    );

    final result = await completer.complete([10, 11]);

    expect(result.error, isEmpty);
    final uri = Uri.parse(result.redirectURI);
    expect(uri.path, '/auth/blocked');
    expect(uri.queryParameters, {'reason': 'spam', 'until': '1900000000', 'support': 'support@iperon.net'});

    expect(api.requests.map((request) => request.messageType), [MessageType.META_DATA_INFO]);
  });

  test('недействительная confirmationSession возвращает на ввод телефона', () async {
    enqueueMetadata();
    api.enqueueCallResult(const APICallStatus(status: APIStatus.success, statusCode: 0));
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.invalidArgument, error: 'confirmationExpired'),
    );

    final result = await completer.complete([10, 11]);

    expect(result.error, 'confirmationExpired');
    expect(result.redirectURI, '/auth');
  });

  test('временная ошибка подтверждения оставляет пользователя на экране', () async {
    enqueueMetadata();
    api.enqueueCallResult(const APICallStatus(status: APIStatus.success, statusCode: 0));
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.deadlineExceeded, error: 'grpcError.unableConnectServer'),
    );

    final result = await completer.complete([10, 11]);

    expect(result.error, 'grpcError.unableConnectServer');
    expect(result.redirectURI, isEmpty);
  });

  test('неверные подписи ciphertext не сохраняют сессию', () async {
    enqueueMetadata();
    enqueueAuthConfirmation();

    final result = await completer.complete([10, 11]);

    expect(result.error, 'screenAuthCallpasswordConfirmation.signatureVerificationFailed');
    expect(result.redirectURI, isEmpty);
    expect(repositories.sessions.createCount, 0);
    expect(api.requests.map((request) => request.messageType), [MessageType.META_DATA_INFO, MessageType.AUTH_CONFIRMATION]);
    final request = AuthConfirmation_Request.fromBuffer(api.requests[1].message);
    expect(request.confirmationSession, [10, 11]);
    expect(request.deviceId, 'test-device-id');
    expect(request.deviceModel, 'Test Phone');
    expect(request.os, 2);
    expect(request.osVersion, '16');
    expect(request.appVersion, '1.2.3');
    expect(request.appBuildNumber, '42');
    expect(request.publicKeySharedKey, isNotEmpty);
    expect(request.publicKeySalt, isNotEmpty);
  });
}

final class FakeUtils implements Utils {
  @override
  Future<PackageInfoModel> packageInfo() async => const PackageInfoModel(appVersion: '1.2.3', appBuildNumber: '42');

  @override
  Future<DeviceInfoModel> deviceInfo() async =>
      const DeviceInfoModel(deviceModel: 'Test Phone', os: OS.android, osCode: 2, osVersion: '16', isPhysicalDevice: true);

  @override
  Future<String> deviceID() async => 'test-device-id';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeSettings implements Settings {
  @override
  String serverMlDsaFingerprint = '';

  @override
  String environment = 'staging';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeAccounts implements Accounts {
  @override
  Future<List<AccountSlot>> all() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeDeviceRepositories implements DeviceRepositories {
  @override
  final FakeAccounts accounts = FakeAccounts();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements Repositories {
  @override
  final FakeSessions sessions = FakeSessions();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeSessions implements Sessions {
  var createCount = 0;

  @override
  Future<void> deleteAndCreate({
    required List<int> userID,
    required List<int> session,
    required List<int> sessionID,
    required List<int> sharedKey,
    required List<int> sharedSalt,
    required DateTime createAt,
  }) async {
    createCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
