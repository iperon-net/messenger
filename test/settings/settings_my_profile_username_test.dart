import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/cubit/settings/settings_my_profile_username_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/myprofile_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../support/fake_api.dart';

void main() {
  final userID = List<int>.filled(12, 1);
  late Directory dir;
  late SqliteDatabase db;
  late MyProfile myProfile;
  late FakeApi api;
  late SettingsMyProfileUsernameCubit cubit;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('settings_username');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    await db.execute('''
      CREATE TABLE myProfile (
        userID BLOB PRIMARY KEY,
        username TEXT NOT NULL DEFAULT '',
        fistName TEXT NOT NULL DEFAULT '',
        lastName TEXT NOT NULL DEFAULT '',
        birthDate INTEGER,
        aboutMe TEXT NOT NULL DEFAULT '',
        emojiStatus TEXT NOT NULL DEFAULT '',
        emojiStatusExpiresAt INTEGER,
        emojiStatusDoNotDisturb INTEGER NOT NULL DEFAULT 0,
        avatarCdnID BLOB
      )
    ''');
    await db.execute('INSERT INTO myProfile (userID, username) VALUES (?, ?)', [userID, 'cached_name']);
    myProfile = MyProfile(logger: Logger(), db: db);
    api = FakeApi();

    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Auth>(_FakeAuth(models.Session(userID: userID)));
    getIt.registerSingleton<Repositories>(_FakeRepositories(myProfile));

    cubit = SettingsMyProfileUsernameCubit();
    await cubit.initialization(locale: AppLocale.ru);
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
    await db.close();
    await dir.delete(recursive: true);
  });

  test('сначала показывает username из локального кэша', () {
    expect(cubit.state.username, 'cached_name');
    expect(api.unaryCalls, isEmpty);
  });

  test('успех: нормализует имя, сохраняет в кэш и открывает профиль', () async {
    await cubit.setUsername(username: 'New_Name');

    expect(cubit.state.username, 'new_name');
    expect(cubit.state.error, isEmpty);
    expect(cubit.state.redirectURI, '/settings/profile');
    expect((await myProfile.getByUserID(userID: userID)).username, 'new_name');

    expect(api.unaryCalls.single.type, MessageType.MY_PROFILE_USERNAME_UPDATE);
    expect(pb.MyProfileUserNameUpdate_Request.fromBuffer(api.unaryCalls.single.payload).username, 'new_name');
  });

  test('занятое имя: показывает ошибку сервера и не меняет кэш', () async {
    api.enqueueUnaryResult(
      MessageType.MY_PROFILE_USERNAME_UPDATE,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.alreadyExists, error: 'screenMyProfile.usernameTaken'),
    );

    await cubit.setUsername(username: 'taken_name');

    expect(cubit.state.error, 'screenMyProfile.usernameTaken');
    expect(cubit.state.redirectURI, isEmpty);
    expect(cubit.state.username, 'cached_name');
    expect((await myProfile.getByUserID(userID: userID)).username, 'cached_name');
  });

  test('offline: показывает ошибку сохранения и не выдаёт её за успех', () async {
    api.enqueueUnaryResult(
      MessageType.MY_PROFILE_USERNAME_UPDATE,
      const APICallStatus(
        status: APIStatus.error,
        statusCode: StatusCode.unavailable,
        error: 'grpcError.errorConnectingServer',
        isGrpc: true,
      ),
    );

    await cubit.setUsername(username: 'offline_name');

    expect(cubit.state.error, 'screenMyProfile.errorSavingUsername');
    expect(cubit.state.redirectURI, isEmpty);
    expect(cubit.state.username, 'cached_name');
    expect((await myProfile.getByUserID(userID: userID)).username, 'cached_name');
  });

  test('невалидное имя отклоняется локально без запроса', () async {
    await cubit.setUsername(username: 'no');

    expect(cubit.state.error, 'screenMyProfile.usernameInvalid');
    expect(api.unaryCalls, isEmpty);
    expect((await myProfile.getByUserID(userID: userID)).username, 'cached_name');
  });
}

final class _FakeRepositories implements Repositories {
  @override
  final MyProfile myProfile;

  const _FakeRepositories(this.myProfile);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeAuth implements Auth {
  @override
  final models.Session session;

  const _FakeAuth(this.session);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
