import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/constants.dart';
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

  test('пустой кэш: preload эмитит неблокирующее ожидание discovery', () async {
    final cubit = await createCubit();
    await cubit.preload();
    // План 01-contacts-loading, шаг 3: первый запуск (кэша нет) больше не
    // остаётся в молчаливом initialization — экран сразу показывает прогресс,
    // пока discovery не заполнит списки.
    expect(cubit.state.status, Status.loading);
    expect(cubit.state.discovering, isFalse);
    expect(cubit.state.registered, isEmpty);
    expect(cubit.state.invitable, isEmpty);
  });

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

  test('добавление: OPRF, upsert и match сохраняют зарегистрированный контакт', () async {
    final cubit = await createCubit();
    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.CONTACTS_DISCOVERY_EVALUATE,
      ContactsDiscoveryEvaluate_Response(
        evaluatedElements: [
          [1],
        ],
      ).writeToBuffer(),
    );
    api.enqueueUnaryResponse(
      MessageType.CONTACTS_DISCOVERY_MATCH,
      ContactsDiscoveryMatch_Response(
        matches: [
          ContactsDiscoveryMatch_Match(oprf: [9], userID: [7]),
        ],
      ).writeToBuffer(),
    );

    final result = await cubit.addByNumber(firstName: ' Анна ', lastName: ' Смирнова ', rawNumber: '+79000000002');

    expect(result, ContactAddResult.addedRegistered);
    expect(cubit.state.cloud.single.displayName, 'Анна Смирнова');
    expect(cubit.state.cloud.single.userID, [7]);
    expect(contacts.rows.single.oprf, [9]);
    final upsert = ContactsUpsert_Request.fromBuffer(
      api.unaryCalls.singleWhere((call) => call.type == MessageType.CONTACTS_UPSERT).payload,
    );
    expect(upsert.items.single.source, ContactsUpsert_Source.MANUAL);
    expect(upsert.items.single.phoneNumber, '+79000000002');
  });

  test('добавление: пустой match означает ожидание, лимит не меняет кэш', () async {
    final cubit = await createCubit();
    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.CONTACTS_DISCOVERY_EVALUATE,
      ContactsDiscoveryEvaluate_Response(
        evaluatedElements: [
          [1],
        ],
      ).writeToBuffer(),
    );
    api.enqueueUnaryResponse(MessageType.CONTACTS_DISCOVERY_MATCH, ContactsDiscoveryMatch_Response().writeToBuffer());

    expect(await cubit.addByNumber(firstName: '', lastName: '', rawNumber: '+79000000002'), ContactAddResult.addedPending);
    expect(cubit.state.cloud.single.userID, isNull);

    api.enqueueUnaryResponse(
      MessageType.CONTACTS_DISCOVERY_EVALUATE,
      ContactsDiscoveryEvaluate_Response(
        evaluatedElements: [
          [1],
        ],
      ).writeToBuffer(),
    );
    api.enqueueUnaryResult(MessageType.CONTACTS_UPSERT, const APICallStatus(status: APIStatus.error, statusCode: 8));
    expect(await cubit.addByNumber(firstName: '', lastName: '', rawNumber: '+79000000003'), ContactAddResult.limitReached);
    expect(contacts.rows, hasLength(1));
  });

  test('удаление восстанавливает книжную запись, ручной контакт попадает в exclusion-set', () async {
    contacts.rows.addAll([
      const ContactCacheEntry(phoneE164: '+79000000002', displayName: 'Книжная Анна', phone: '+79000000002', userID: [7]),
      const ContactCacheEntry(phoneE164: '+79000000003', displayName: 'Иван', phone: '+79000000003', isCloud: true, oprf: [9]),
    ]);
    final cubit = await createCubit();
    await cubit.preload();
    utils.network = true;
    for (var index = 0; index < 2; index++) {
      api.enqueueUnaryResponse(
        MessageType.CONTACTS_DISCOVERY_EVALUATE,
        ContactsDiscoveryEvaluate_Response(
          evaluatedElements: [
            [1],
          ],
        ).writeToBuffer(),
      );
    }

    expect(await cubit.removeByPhone('+79000000002'), ContactRemoveResult.removed);
    expect(contacts.rows.singleWhere((row) => row.phoneE164 == '+79000000002').displayName, 'Книжная Анна');
    expect(contacts.rows.singleWhere((row) => row.phoneE164 == '+79000000002').isCloud, isFalse);

    expect(await cubit.removeByPhone('+79000000003'), ContactRemoveResult.removed);
    expect(contacts.rows.map((row) => row.phoneE164), ['+79000000002']);
    expect(cubit.repositories.cache, isA<FakeCache>());
    final cache = cubit.repositories.cache as FakeCache;
    expect(jsonDecode(cache.values['contacts_excluded_e164']!), ['+79000000003']);
  });

  test('присутствие обновляется ответом и push, кодовая фраза остаётся локальной', () async {
    final cubit = await createCubit();
    api.emitMessage(
      MessageType.CONTACTS_UPDATED,
      ContactsUpdated(
        upserted: [
          Contact(phoneNumber: '+79000000002', firstName: 'Анна', contactUserID: [7], oprf: [9]),
        ],
      ).writeToBuffer(),
    );
    await Future<void>.delayed(Duration.zero);
    api.enqueueUnaryResponse(
      MessageType.PRESENCE,
      Presence_Response(
        items: [
          Presence_Item(userID: [7], online: true),
        ],
      ).writeToBuffer(),
    );

    await cubit.refreshPresence();
    expect(cubit.state.cloud.single.online, isTrue);

    api.emitMessage(
      MessageType.PRESENCE,
      Presence_Response(
        items: [
          Presence_Item(userID: [7], lastSeen: Int64(100)),
        ],
      ).writeToBuffer(),
    );
    // Пуш применяется с дебаунсом (шаг 3 плана 01): состояние собирается раз
    // за окно дебаунса, а не на каждый item — ждём чуть больше задержки.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    expect(cubit.state.cloud.single.online, isFalse);
    expect(cubit.state.cloud.single.lastSeen, DateTime.fromMillisecondsSinceEpoch(100000));

    await cubit.search('/secret');
    expect(cubit.state.revealedHex, {'07'});
    expect(api.unaryCalls.where((call) => call.type == MessageType.CHATS), isEmpty);
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
  Future<void> upsertBookOne(ContactCacheEntry entry) async {
    rows.removeWhere((row) => row.phoneE164 == entry.phoneE164);
    rows.add(entry);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeHiddenProfiles implements HiddenProfiles {
  @override
  Stream<void> get changes => const Stream.empty();

  @override
  Future<List<HiddenProfileEntry>> getAll() async => const [
    HiddenProfileEntry(userID: [7], phraseHash: 'hash:secret'),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeProfiles implements Profiles {
  @override
  Future<Map<String, DateTime>> getLastSeenByUserIDs({required List<List<int>> userIDs, required String Function(List<int>) toHex}) async =>
      const {};

  @override
  Future<void> updateLastSeen({required List<int> userID, required DateTime lastSeen}) async {}

  @override
  Future<void> clearLastSeen({required List<int> userID}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeCache implements Cache {
  final values = <String, String>{};

  @override
  Future<String?> getString({required Uint8List userID, required String key}) async => values[key];

  @override
  Future<void> setString({required Uint8List userID, required String key, required String value, Duration? ttl}) async {
    values[key] = value;
  }

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
  Future<String> passphraseHash(String phrase) async => 'hash:${phrase.trim().toLowerCase()}';

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
  late final Oprf oprf = FakeOprf();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeOprf implements Oprf {
  @override
  Future<(List<Uint8List> blinds, List<Uint8List> blindedElements)> blindBatch(List<List<int>> inputs) async => (
    [for (final _ in inputs) Uint8List(0)],
    [
      for (final _ in inputs) Uint8List.fromList([1]),
    ],
  );

  @override
  Future<List<Uint8List>> finalizeBatch({
    required List<List<int>> inputs,
    required List<Uint8List> blinds,
    required List<Uint8List> evaluations,
  }) async => [
    for (final _ in inputs) Uint8List.fromList([9]),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
