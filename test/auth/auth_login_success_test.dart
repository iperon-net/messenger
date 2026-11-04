import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/cubit/auth/auth_login_completer.dart';
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

void main() {
  late FakeApi api;
  late Directory dir;
  late SqliteDatabase db;
  late Users users;
  late Sessions sessions;
  late FakeAccounts accounts;
  late FakeAuth auth;
  late Uint8List serverPublicKey;
  late Uint8List serverSecretKey;

  setUpAll(() {
    (serverPublicKey, serverSecretKey) = MlDsa.generateKeyPair(DilithiumParams.mlDsa65);
  });

  setUp(() async {
    api = FakeApi();
    accounts = FakeAccounts();
    auth = FakeAuth();
    dir = await Directory.systemTemp.createTemp('auth_login_success');
    db = SqliteDatabase(path: '${dir.path}/test.db');
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
    users = Users(logger: Logger(), db: db);
    sessions = Sessions(logger: Logger(), db: db, accounts: accounts);

    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Settings>(FakeSettings());
    getIt.registerSingleton<DeviceRepositories>(FakeDeviceRepositories(accounts));
    getIt.registerSingleton<Repositories>(FakeRepositories(users, sessions));
    getIt.registerSingleton<Auth>(auth);

    api.enqueueResponse(
      MessageType.META_DATA_INFO,
      Message(
        messageType: MessageType.META_DATA_INFO,
        message: MetadataInfo_Response(mldsa: MetadataInfo_MLDSA(publicKey: serverPublicKey)).writeToBuffer(),
      ),
    );
  });

  tearDown(() async {
    await api.dispose();
    await getIt.reset();
    await db.close();
    await dir.delete(recursive: true);
  });

  void enqueueSuccessfulConfirmation() {
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
  }

  test('успех: проверяет подписи, сохраняет сессию и обновляет Auth', () async {
    enqueueSuccessfulConfirmation();

    final result = await AuthLoginCompleter().complete([10, 11]);

    expect(result.error, isEmpty);
    expect(result.redirectURI, '/chats');
    expect(auth.refreshCount, 1);
    expect(accounts.activatedUserID, [1, 2, 3]);
    expect(accounts.activatedPhone, '+79091600044');

    final session = await sessions.getActive();
    expect(session.userID, [1, 2, 3]);
    expect(session.sessionID, [4, 5, 6]);
    expect(session.session, [7, 8, 9]);
    expect(session.sharedKey, isNotEmpty);
    expect(session.salt, isNotEmpty);
    final user = await users.getBySession(session: session);
    expect(user.phoneNumber, '+79091600044');
  });

  test('сбой сохранения возвращает ошибку и /auth без Auth.refresh', () async {
    enqueueSuccessfulConfirmation();
    await getIt.unregister<Repositories>();
    getIt.registerSingleton<Repositories>(FailingRepositories(sessions));

    final result = await AuthLoginCompleter().complete([10, 11]);

    expect(result.error, 'grpcError.internalServerError');
    expect(result.redirectURI, '/auth');
    expect(auth.refreshCount, 0);
    expect(accounts.activatedUserID, isEmpty);
  });
}

final class FakeUtils implements Utils {
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
  List<int> activatedUserID = [];
  String activatedPhone = '';

  @override
  Future<List<AccountSlot>> all() async => const [];

  @override
  Future<void> activate({required List<int> userID, required String phoneNumber, required String environment}) async {
    activatedUserID = userID;
    activatedPhone = phoneNumber;
  }

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

final class FailingRepositories implements Repositories {
  @override
  final Sessions sessions;

  @override
  late final Users users = FailingUsers(sessions.db);

  FailingRepositories(this.sessions);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FailingUsers extends Users {
  FailingUsers(SqliteDatabase db) : super(logger: Logger(), db: db);

  @override
  Future<void> createOrUpdate({required List<int> userID, required String phoneNumber}) {
    throw StateError('database is read-only');
  }
}
