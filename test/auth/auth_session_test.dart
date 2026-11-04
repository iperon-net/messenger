import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late FakeSessions sessions;
  late Auth auth;

  setUp(() async {
    api = FakeApi();
    sessions = FakeSessions(const Session(sessionID: [1, 2], session: [3, 4], userID: [5, 6], isActive: true));
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Repositories>(FakeRepositories(sessions));
    getIt.registerSingleton<DeviceRepositories>(FakeDeviceRepositories());
    auth = await Auth.initialization();
  });

  tearDown(() async {
    auth.dispose();
    await api.dispose();
    await getIt.reset();
  });

  test('initialization восстанавливает активную сессию и передаёт её в API', () {
    expect(auth.isAuthorized, isTrue);
    expect(auth.session.sessionID, [1, 2]);
    expect(api.sessionUpdates.single?.sessionID, [1, 2]);
  });

  test('отзыв активной сессии удаляет её и уведомляет роутер', () async {
    var notifications = 0;
    auth.addListener(() => notifications++);

    api.onUnauthenticated!(const Session(sessionID: [1, 2]));
    await Future<void>.delayed(Duration.zero);

    expect(sessions.deleteCount, 1);
    expect(auth.isAuthorized, isFalse);
    expect(auth.session.sessionID, isEmpty);
    expect(api.sessionUpdates.last, isNull);
    expect(notifications, 1);
  });

  test('запоздалый отзыв старой сессии не завершает новый вход', () async {
    var notifications = 0;
    auth.addListener(() => notifications++);

    api.onUnauthenticated!(const Session(sessionID: [9, 9]));
    await Future<void>.delayed(Duration.zero);

    expect(sessions.deleteCount, 0);
    expect(auth.isAuthorized, isTrue);
    expect(auth.session.sessionID, [1, 2]);
    expect(api.sessionUpdates, hasLength(1));
    expect(notifications, 0);
  });
}

final class FakeSessions implements Sessions {
  Session active;
  var deleteCount = 0;

  FakeSessions(this.active);

  @override
  Future<Session> getActive() async => active;

  @override
  Future<void> deleteActive() async {
    deleteCount++;
    active = const Session();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements Repositories {
  @override
  final FakeSessions sessions;

  const FakeRepositories(this.sessions);

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

final class FakeUtils implements Utils {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
