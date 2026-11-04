import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/calls.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/cubit/calls/calls_cubit.dart';
import 'package:messenger/cubit/calls/calls_state.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/profile_v1.pb.dart';
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../support/fake_api.dart';

void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);

  late FakeApi api;
  late HistoryFakeCalls calls;
  late HistoryRepositories repositories;
  late CallsCubit cubit;

  setUp(() async {
    api = FakeApi();
    calls = HistoryFakeCalls();
    repositories = HistoryRepositories(SqliteDatabase(path: ':memory:'));
    await repositories.db.execute('CREATE TABLE callLogs (id INTEGER);');
    repositories.callLogs.items = [
      models.CallLog(
        id: 1,
        callID: 'call-1',
        userID: Uint8List.fromList(peer),
        displayName: 'Old name',
        direction: models.CallDirection.incoming,
        missed: true,
        createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
      ),
    ];
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Auth>(HistoryAuth(models.Session(userID: me)));
    getIt.registerSingleton<Utils>(HistoryUtils());
    getIt.registerSingleton<Repositories>(repositories);
    getIt.registerSingleton<Calls>(calls);
    cubit = CallsCubit();
  });

  tearDown(() async {
    await cubit.close();
    await calls.dispose();
    await api.dispose();
    await repositories.dispose();
    await getIt.reset();
  });

  test('журнал читается из локального хранилища, имена обновляются из кэша', () async {
    cubit.initialization();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(cubit.state.status, Status.success);
    expect(cubit.state.calls, hasLength(1));
    expect(cubit.state.hasMissed, isTrue);
    expect(cubit.state.names.values, ['Peer contact']);

    cubit.setFilter(CallsFilter.missed);
    await cubit.search('peer');
    expect(cubit.state.filter, CallsFilter.missed);
    expect(cubit.state.query, 'peer');
  });

  test('новая локальная запись и изменение таблицы перечитывают журнал', () async {
    cubit.initialization();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    repositories.callLogs.items = [];

    calls.logged();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(cubit.state.calls, isEmpty);

    repositories.callLogs.items = [
      models.CallLog(id: 2, userID: Uint8List.fromList(peer), createdAt: DateTime.fromMillisecondsSinceEpoch(2000)),
    ];
    await repositories.db.execute('INSERT INTO callLogs (id) VALUES (2);');
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(cubit.state.calls.single.id, 2);
  });

  test('PROFILE обновляет имя только присутствующего в журнале собеседника', () async {
    repositories.contacts.entries = [];
    cubit.initialization();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    api.emitMessage(MessageType.PROFILE, Profile_Response(userID: peer, firstName: 'Fresh').writeToBuffer());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(cubit.state.names.values, ['Fresh']);

    api.emitMessage(MessageType.PROFILE, Profile_Response(userID: me, firstName: 'Other').writeToBuffer());
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(cubit.state.names.values, ['Fresh']);
  });

  test('скрытый профиль раскрывается только совпавшей код-фразой', () async {
    repositories.hiddenProfiles.items = [HiddenProfileEntry(userID: peer, phraseHash: 'hash:secret')];
    cubit.initialization();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await cubit.search('/wrong');
    expect(cubit.state.hiddenHashByHex, hasLength(1));
    expect(cubit.state.revealedHex, isEmpty);

    await cubit.search('/secret');
    final hex = getIt.get<Utils>().bytesToHex(Uint8List.fromList(peer));
    expect(cubit.state.revealedHex, {hex});
  });

  test('удаление скрывает запись через хранилище и перечитывает список', () async {
    cubit.initialization();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await cubit.delete(cubit.state.calls.single);

    expect(repositories.callLogs.deleted, [1]);
    expect(cubit.state.calls, isEmpty);
  });

  test('флаги баннеров и фильтр не требуют платформенных разрешений на macOS', () async {
    await cubit.checkCallPermissions();
    await cubit.checkPipPermission();
    cubit.dismissCallBanner();
    cubit.dismissPipBanner();

    expect(cubit.state.callMicMissing, isFalse);
    expect(cubit.state.pipMissing, isFalse);
    expect(cubit.state.bannerDismissed, isTrue);
    expect(cubit.state.pipBannerDismissed, isTrue);
  });

  test('CallLogs в SQLite сохраняет сортировку, дедупликацию, владельца и удаление', () async {
    final dir = await Directory.systemTemp.createTemp('call_logs_test');
    final db = SqliteDatabase(path: '${dir.path}/test.db');
    addTearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });
    await db.execute('''
      CREATE TABLE callLogs (
        id INTEGER PRIMARY KEY AUTOINCREMENT, callID TEXT NOT NULL DEFAULT '', ownerID BLOB NOT NULL DEFAULT X'',
        userID BLOB NOT NULL, displayName TEXT NOT NULL DEFAULT '', direction TEXT NOT NULL,
        video INTEGER NOT NULL DEFAULT 0, missed INTEGER NOT NULL DEFAULT 0,
        durationSeconds INTEGER NOT NULL DEFAULT 0, createdAt INTEGER NOT NULL, hidden INTEGER NOT NULL DEFAULT 0
      );
    ''');
    final store = CallLogs(logger: Logger(), db: db);
    final log = models.CallLog(
      callID: 'call-1',
      userID: Uint8List.fromList(peer),
      direction: models.CallDirection.incoming,
      video: true,
      missed: true,
      durationSeconds: 12,
      createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
    );

    await store.insert(ownerID: me, log: log);
    await store.insert(ownerID: me, log: log);
    await store.insert(
      ownerID: peer,
      log: log.copyWith(callID: 'other-owner'),
    );
    await store.insert(
      ownerID: me,
      log: log.copyWith(callID: 'call-2', createdAt: DateTime.fromMillisecondsSinceEpoch(2000)),
    );

    final own = await store.getAll(ownerID: me);
    expect(own.map((entry) => entry.callID), ['call-2', 'call-1']);
    expect(own.last.direction, models.CallDirection.incoming);
    expect(own.last.video, isTrue);
    expect(own.last.missed, isTrue);
    expect(own.last.durationSeconds, 12);
    expect((await store.getAll(ownerID: peer)).single.callID, 'other-owner');

    await store.deleteByID(own.last.id);
    expect((await store.getAll(ownerID: me)).map((entry) => entry.callID), ['call-2']);
    await store.deleteAll(ownerID: me);
    expect(await store.getAll(ownerID: me), isEmpty);
  });
}

final class HistoryFakeCalls implements Calls {
  final _logged = StreamController<void>.broadcast();
  @override
  Stream<void> get callLogged => _logged.stream;
  void logged() => _logged.add(null);
  @override
  Future<void> dispose() => _logged.close();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class HistoryAuth implements Auth {
  @override
  final models.Session session;
  const HistoryAuth(this.session);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class HistoryUtils implements Utils {
  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  @override
  Future<String> passphraseHash(String phrase) async => 'hash:$phrase';
  @override
  models.PhoneNumberModel phoneNormalization({required String phoneNumber}) =>
      const models.PhoneNumberModel(international: '', national: '', e164: '', rfc3966: '', raw: '');
  @override
  List<String> composeNameLines({
    String contactName = '',
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String username,
  }) => [if (contactName.isNotEmpty) contactName else if (firstName.isNotEmpty) firstName];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class HistoryRepositories implements Repositories {
  HistoryRepositories(this.db);

  @override
  late final HistoryCallLogs callLogs = HistoryCallLogs();
  @override
  final SqliteDatabase db;
  @override
  late final HistoryHiddenProfiles hiddenProfiles = HistoryHiddenProfiles();
  @override
  late final HistoryContacts contacts = HistoryContacts();
  @override
  late final HistoryProfiles profiles = HistoryProfiles();
  Future<void> dispose() async {
    await db.close();
    await hiddenProfiles.dispose();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class HistoryCallLogs implements CallLogs {
  var items = <models.CallLog>[];
  final deleted = <int>[];
  @override
  Future<List<models.CallLog>> getAll({required List<int> ownerID, int limit = 500}) async => List.of(items);
  @override
  Future<void> deleteByID(int id) async {
    deleted.add(id);
    items = items.where((item) => item.id != id).toList();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class HistoryHiddenProfiles implements HiddenProfiles {
  final _changes = StreamController<void>.broadcast();
  var items = <HiddenProfileEntry>[];
  @override
  Stream<void> get changes => _changes.stream;
  @override
  Future<List<HiddenProfileEntry>> getAll() async => items;
  Future<void> dispose() => _changes.close();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class HistoryContacts implements Contacts {
  var entries = <ContactCacheEntry>[
    ContactCacheEntry(phoneE164: '+79000000002', displayName: 'Peer contact', phone: '+79000000002', userID: List<int>.filled(12, 2)),
  ];
  @override
  Future<Map<String, String>> namesByUserID({required String Function(List<int>) toHex, List<List<int>>? userIDs}) async => {
    for (final entry in entries)
      if (entry.userID != null) toHex(entry.userID!): entry.displayName,
  };
  @override
  Future<String?> phoneByUserID(List<int> userID) async => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class HistoryProfiles implements Profiles {
  @override
  Future<models.Profile> getByUserID({required List<int> userID}) async => models.Profile(userID: userID);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
