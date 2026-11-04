import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/cubit/contacts/contacts_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeApi api;
  late FakeContacts contacts;
  late FakeUtils utils;

  setUp(() async {
    await getIt.reset();
    api = FakeApi();
    contacts = FakeContacts();
    utils = FakeUtils();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Utils>(utils);
    getIt.registerSingleton<Crypto>(FakeCrypto());
    getIt.registerSingleton<Auth>(FakeAuth());
    getIt.registerSingleton<Repositories>(FakeRepositories(contacts));
  });

  tearDown(() async {
    await api.dispose();
    await getIt.reset();
  });

  Future<ContactsCubit> createCubit() async {
    final cubit = ContactsCubit();
    addTearDown(cubit.close);
    await Future<void>.delayed(Duration.zero);
    return cubit;
  }

  test('preload показывает кэш offline, ошибка CONTACTS_LIST его сохраняет', () async {
    contacts.rows.addAll([
      const ContactCacheEntry(phoneE164: '+79000000001', displayName: 'Книжный', phone: '+7 900 000-00-01'),
      const ContactCacheEntry(phoneE164: '+79000000002', displayName: 'Облачный', phone: '+7 900 000-00-02', isCloud: true, oprf: [2]),
    ]);
    final cubit = await createCubit();
    api.enqueueUnaryResult(MessageType.CONTACTS_LIST, const APICallStatus(status: APIStatus.error, statusCode: 14, error: 'unavailable'));

    await cubit.preload();
    await cubit.refresh();

    expect(cubit.state.invitable.map((item) => item.displayName), ['Книжный']);
    expect(cubit.state.cloud.map((item) => item.displayName), ['Облачный']);
    expect(contacts.rows, hasLength(2));
  });

  test('CONTACTS_LIST заменяет облако, push добавляет и удаляет по OPRF', () async {
    final cubit = await createCubit();
    api.enqueueUnaryResponse(
      MessageType.CONTACTS_LIST,
      ContactsList_Response(
        contacts: [
          Contact(phoneNumber: '+79000000002', firstName: 'Анна', oprf: [2]),
        ],
      ).writeToBuffer(),
    );

    await cubit.refresh();
    expect(cubit.state.cloud.single.displayName, 'Анна');
    expect(contacts.rows.single.isCloud, isTrue);

    api.emitMessage(
      MessageType.CONTACTS_UPDATED,
      ContactsUpdated(
        upserted: [
          Contact(phoneNumber: '+79000000003', firstName: 'Иван', oprf: [3]),
        ],
      ).writeToBuffer(),
    );
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.cloud.map((item) => item.displayName), ['Анна', 'Иван']);

    api.emitMessage(
      MessageType.CONTACTS_UPDATED,
      ContactsUpdated(
        removedOprf: [
          [2],
        ],
      ).writeToBuffer(),
    );
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.cloud.map((item) => item.displayName), ['Иван']);
    expect(contacts.rows.map((row) => row.phoneE164), ['+79000000003']);
  });

  test('некорректный номер и offline не вызывают API', () async {
    final cubit = await createCubit();

    expect(await cubit.addByNumber(firstName: '', lastName: '', rawNumber: 'abc'), ContactAddResult.invalidNumber);
    expect(await cubit.addByNumber(firstName: 'Анна', lastName: '', rawNumber: '+79000000002'), ContactAddResult.noConnection);
    expect(await cubit.removeByPhone('+79000000002'), ContactRemoveResult.noConnection);
    expect(api.unaryCalls, isEmpty);
  });
}

final class FakeContacts implements Contacts {
  final rows = <ContactCacheEntry>[];

  @override
  Future<List<ContactCacheEntry>> getAll() async => List.of(rows);

  @override
  Future<void> replaceCloud(List<ContactCacheEntry> entries) async {
    rows
      ..removeWhere((row) => row.isCloud)
      ..addAll(entries);
  }

  @override
  Future<void> upsertCloudOne(ContactCacheEntry entry) async {
    rows.removeWhere((row) => row.phoneE164 == entry.phoneE164);
    rows.add(entry);
  }

  @override
  Future<void> removeCloudOne(String phoneE164) async {
    rows.removeWhere((row) => row.phoneE164 == phoneE164 && row.isCloud);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeHiddenProfiles implements HiddenProfiles {
  @override
  Stream<void> get changes => const Stream.empty();

  @override
  Future<List<HiddenProfileEntry>> getAll() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeProfiles implements Profiles {
  @override
  Future<Map<String, DateTime>> getLastSeenByUserIDs({required List<List<int>> userIDs, required String Function(List<int>) toHex}) async =>
      const {};

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeCache implements Cache {
  @override
  Future<String?> getString({required Uint8List userID, required String key}) async => null;

  @override
  Future<void> setString({required Uint8List userID, required String key, required String value, Duration? ttl}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements Repositories {
  @override
  final Contacts contacts;

  @override
  late final Cache cache = FakeCache();

  @override
  late final HiddenProfiles hiddenProfiles = FakeHiddenProfiles();

  @override
  late final Profiles profiles = FakeProfiles();

  FakeRepositories(this.contacts);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeUtils implements Utils {
  var network = false;

  @override
  Future<bool> hasNetwork() async => network;

  @override
  models.PhoneNumberModel phoneNormalization({required String phoneNumber}) {
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final valid = digits.length == 11 && digits.startsWith('7');
    final e164 = valid ? '+$digits' : '';
    return models.PhoneNumberModel(international: valid ? e164 : '', national: '', e164: e164, rfc3966: '', raw: valid ? digits : '');
  }

  @override
  String bytesToHex(List<int> bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  @override
  Uint8List hexToBytes(String hex) =>
      Uint8List.fromList([for (var index = 0; index < hex.length; index += 2) int.parse(hex.substring(index, index + 2), radix: 16)]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeAuth implements Auth {
  @override
  final models.Session session = const models.Session(userID: [1]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeCrypto implements Crypto {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
