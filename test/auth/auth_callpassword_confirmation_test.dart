import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/cubit/auth/auth_callpassword_confirmation_cubit.dart';
import 'package:messenger/cubit/auth/auth_callpassword_confirmation_state.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/settings.dart';
import 'package:messenger/utils.dart';
import 'package:pqcrypto/pqcrypto.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../support/fake_api.dart';

// Вход по звонку-паролю (docs/plans/06-callpassword-reconnect.md): разрыв
// стрима — норма (пользователь в звонилке), кубит переподключается и сверяет
// таймер с сервером; терминальные исходы чистят незавершённую сессию
// (pendingCallPassword), восстановление после смерти процесса — через
// Routers._redirect.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeApi api;
  late Directory dir;
  late SqliteDatabase db;
  late PendingCallPassword pending;
  late FakeAuth auth;
  late Uint8List serverPublicKey;
  late Uint8List serverSecretKey;
  late AuthCallpasswordConfirmationCubit cubit;

  setUpAll(() {
    (serverPublicKey, serverSecretKey) = MlDsa.generateKeyPair(DilithiumParams.mlDsa65);
  });

  setUp(() async {
    api = FakeApi();
    auth = FakeAuth();
    dir = await Directory.systemTemp.createTemp('auth_callpassword_confirmation');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    pending = PendingCallPassword(logger: Logger(), db: db);
    await db.execute('''
      CREATE TABLE pendingCallPassword (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        callPasswordSession TEXT NOT NULL,
        confirmationPhoneNumber TEXT NOT NULL,
        timeout INTEGER NOT NULL,
        createdAt INTEGER NOT NULL
      );
    ''');
    await db.execute('CREATE TABLE users (userID BLOB PRIMARY KEY, phoneNumber TEXT NOT NULL)');
    await db.execute('''
      CREATE TABLE sessions (
        sessionID BLOB PRIMARY KEY,
        userID BLOB NOT NULL,
        session BLOB NOT NULL,
        sharedKey BLOB NOT NULL,
        salt BLOB NOT NULL,
        isActive INTEGER NOT NULL,
        createAt INTEGER NOT NULL
      )
    ''');

    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Settings>(FakeSettings());
    getIt.registerSingleton<DeviceRepositories>(FakeDeviceRepositories(pending, FakeAccounts()));
    getIt.registerSingleton<Repositories>(
      FakeRepositories(Users(logger: Logger(), db: db), Sessions(logger: Logger(), db: db, accounts: FakeAccounts())),
    );
    getIt.registerSingleton<Auth>(auth);
    cubit = AuthCallpasswordConfirmationCubit();
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
    await db.close();
    await dir.delete(recursive: true);
  });

  Future<void> initialize({String timeout = '60'}) async {
    await cubit.initialization(callPasswordSession: '0102ff', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: timeout);
    await Future<void>.delayed(Duration.zero);
  }

  /// Дождаться открытия стрима с номером [index] (нумерация с 1) и его запроса.
  Future<void> awaitStream(int index) async {
    final deadline = DateTime.now().add(const Duration(seconds: 4));
    while (api.responseStreams.length < index || api.requests.length < index) {
      if (DateTime.now().isAfter(deadline)) fail('stream $index did not open');
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  StreamController<Message> server(int index) => api.responseStreams[index - 1];

  void respond(AuthCallPasswordConfirmation_Response response, {int index = 1}) {
    server(index).add(Message(messageType: MessageType.AUTH_CALL_PASSWORD_CONFIRMATION, message: response.writeToBuffer()));
  }

  test('открывает стрим и отправляет session из параметров экрана', () async {
    await initialize();

    expect(cubit.state.callPasswordSession, [1, 2, 255]);
    expect(cubit.state.confirmationPhoneNumber, '+7 *** ***-**-44');
    expect(cubit.state.tickerSecond, 60);
    expect(cubit.state.result, AuthCallPasswordConfirmationResult.waiting);

    final request = AuthCallPasswordConfirmation_Request.fromBuffer(api.requests.single.message);
    expect(api.requests.single.messageType, MessageType.AUTH_CALL_PASSWORD_CONFIRMATION);
    expect(request.callPasswordSession, [1, 2, 255]);
  });

  test('первый healthcheck синхронизирует остаток таймера, повторный не сбивает', () async {
    await initialize();

    respond(AuthCallPasswordConfirmation_Response(timer: Int64(42)));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.tickerSecond, 42);
    expect(cubit.state.result, AuthCallPasswordConfirmationResult.waiting);
    expect(cubit.state.redirectURI, isEmpty);

    respond(AuthCallPasswordConfirmation_Response(timer: Int64(10)));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.tickerSecond, 42);
  });

  test('успех с облачным паролем ведёт на его ввод и чистит незавершённую сессию', () async {
    await pending.set(callPasswordSession: '0102ff', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: 60);
    await initialize();

    respond(
      AuthCallPasswordConfirmation_Response(
        authCallPasswordStatus: AuthCallPasswordStatus.success,
        hasTwoStepVerification: true,
        confirmationSession: [10, 11, 255],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final uri = Uri.parse(cubit.state.redirectURI);
    expect(uri.path, '/auth/cloud_password');
    expect(uri.queryParameters['confirmationSession'], '0a0bff');
    expect(pending.session, isNull);
  });

  test('ошибка подтверждения показывает сообщение, чистит сессию и возвращает на вход', () async {
    await pending.set(callPasswordSession: '0102ff', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: 60);
    await initialize();

    respond(AuthCallPasswordConfirmation_Response(authCallPasswordStatus: AuthCallPasswordStatus.error, errorMessage: 'callExpired'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.error);
    expect(cubit.state.error, 'callExpired');
    expect(cubit.state.redirectURI, '/auth');
    expect(pending.session, isNull);
  });

  test('блокировка без confirmationSession ведёт на экран блокировки', () async {
    await initialize();

    respond(AuthCallPasswordConfirmation_Response(isBlocked: true));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.blocked);
    expect(cubit.state.redirectURI, '/auth/blocked');
  });

  test('разрыв стрима переподключается с той же сессией и заново сверяет таймер', () async {
    await initialize();
    await awaitStream(1);

    server(1).addError(GrpcError.unavailable('connectionLost'));
    await awaitStream(2);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.waiting);
    expect(cubit.state.redirectURI, isEmpty);
    final request = AuthCallPasswordConfirmation_Request.fromBuffer(api.requests[1].message);
    expect(request.callPasswordSession, [1, 2, 255]);

    // Синхронизация сброшена: первый healthcheck нового стрима выравнивает.
    respond(AuthCallPasswordConfirmation_Response(timer: Int64(30)), index: 2);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.tickerSecond, 30);
  });

  test('штатное закрытие стрима — переподключение, а не timeout', () async {
    await initialize();
    await awaitStream(1);

    await server(1).close();
    await awaitStream(2);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.waiting);
    expect(cubit.state.redirectURI, isEmpty);

    respond(AuthCallPasswordConfirmation_Response(timer: Int64(25)), index: 2);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.tickerSecond, 25);
  });

  test('истекшая сессия (not found in redis) — терминальный timeout без ретраев', () async {
    await pending.set(callPasswordSession: '0102ff', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: 60);
    await initialize();
    await awaitStream(1);

    server(1).addError(GrpcError.unknown('not found in redis'));

    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(cubit.state.result, AuthCallPasswordConfirmationResult.timeout);
    expect(cubit.state.tickerSecond, 0);
    expect(cubit.state.redirectURI, '/auth');
    expect(pending.session, isNull);
    // Дольше backoff — переподключений нет.
    await Future<void>.delayed(const Duration(seconds: 1, milliseconds: 200));
    expect(api.responseStreams, hasLength(1));
  });

  test('локальный таймер на нуле — финальная сверка: сервер вернул остаток', () async {
    await initialize(timeout: '1');

    // Тикер дошёл до нуля, кубит переподключился.
    await awaitStream(2);

    respond(AuthCallPasswordConfirmation_Response(timer: Int64(45)), index: 2);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.waiting);
    expect(cubit.state.redirectURI, isEmpty);
    expect(cubit.state.tickerSecond, 45);
  });

  test('локальный таймер на нуле — финальная сверка: сервер сессию не нашёл', () async {
    await pending.set(callPasswordSession: '0102ff', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: 1);
    await initialize(timeout: '1');

    await awaitStream(2);
    server(2).addError(GrpcError.unknown('not found in redis'));

    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(cubit.state.result, AuthCallPasswordConfirmationResult.timeout);
    expect(cubit.state.tickerSecond, 0);
    expect(cubit.state.redirectURI, '/auth');
    expect(pending.session, isNull);
  });

  test('success без двухшаговой проверки завершает вход', () async {
    api.enqueueResponse(
      MessageType.META_DATA_INFO,
      Message(
        messageType: MessageType.META_DATA_INFO,
        message: MetadataInfo_Response(mldsa: MetadataInfo_MLDSA(publicKey: serverPublicKey)).writeToBuffer(),
      ),
    );
    api.enqueueResponseHandler(MessageType.AUTH_CONFIRMATION, (message) {
      final request = AuthConfirmation_Request.fromBuffer(message.message);
      final (ciphertextSharedKey, _) = PqcKem.kyber768.encapsulate(Uint8List.fromList(request.publicKeySharedKey));
      final (ciphertextSalt, _) = PqcKem.kyber768.encapsulate(Uint8List.fromList(request.publicKeySalt));
      return Message(
        messageType: MessageType.AUTH_CONFIRMATION,
        message: AuthConfirmation_Response(
          userID: [1, 2, 3],
          phoneNumber: '+79091600044',
          sessionID: [4, 5, 6],
          session: [7, 8, 9],
          ciphertextSharedKey: ciphertextSharedKey,
          signatureSharedKey: MlDsa.sign(serverSecretKey, ciphertextSharedKey, DilithiumParams.mlDsa65),
          ciphertextSalt: ciphertextSalt,
          signatureSalt: MlDsa.sign(serverSecretKey, ciphertextSalt, DilithiumParams.mlDsa65),
        ).writeToBuffer(),
      );
    });
    await pending.set(callPasswordSession: '0102ff', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: 60);
    await initialize();

    respond(
      AuthCallPasswordConfirmation_Response(authCallPasswordStatus: AuthCallPasswordStatus.success, confirmationSession: [10, 11, 255]),
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(cubit.state.redirectURI, '/chats');
    expect(cubit.state.error, isEmpty);
    expect(auth.refreshCount, 1);
    expect(pending.session, isNull);
    final confirmation = AuthConfirmation_Request.fromBuffer(api.requests.last.message);
    expect(confirmation.confirmationSession, [10, 11, 255]);
  });
}

final class FakeUtils implements Utils {
  @override
  Uint8List hexToBytes(String hex) {
    return Uint8List.fromList([for (var index = 0; index < hex.length; index += 2) int.parse(hex.substring(index, index + 2), radix: 16)]);
  }

  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  @override
  Future<models.PackageInfoModel> packageInfo() async => const models.PackageInfoModel(appVersion: '1.2.3', appBuildNumber: '42');

  @override
  Future<models.DeviceInfoModel> deviceInfo() async =>
      const models.DeviceInfoModel(deviceModel: 'Test Phone', os: models.OS.android, osCode: 2, osVersion: '16', isPhysicalDevice: true);

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
  Future<void> activate({required List<int> userID, required String phoneNumber, required String environment}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeDeviceRepositories implements DeviceRepositories {
  @override
  final PendingCallPassword pendingCallPassword;

  @override
  final Accounts accounts;

  FakeDeviceRepositories(this.pendingCallPassword, this.accounts);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeAuth implements Auth {
  var refreshCount = 0;

  @override
  Future<void> refresh() async {
    refreshCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements Repositories {
  @override
  final Users users;

  @override
  final Sessions sessions;

  const FakeRepositories(this.users, this.sessions);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
