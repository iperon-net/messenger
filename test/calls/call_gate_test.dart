import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/calls.dart';
import 'package:messenger/components/calls/call_gate.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const desktopChannel = MethodChannel('net.iperon.messenger/desktop');

  late FakeCalls calls;

  setUpAll(() async {
    await AppLocale.ru.build();
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  setUp(() async {
    calls = FakeCalls();
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Calls>(calls);
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<Repositories>(FakeRepositories());
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(desktopChannel, (_) async => null);
  });

  tearDown(() async {
    await calls.dispose();
    await getIt.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(desktopChannel, null);
  });

  Future<GoRouter> pumpGate(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) => CallGate(child: child),
          routes: [GoRoute(path: '/home', builder: (_, _) => const Text('home screen'))],
        ),
        GoRoute(path: '/call', builder: (_, _) => const Text('call screen')),
        GoRoute(path: '/detail', builder: (_, _) => const Text('detail screen')),
      ],
    );
    await tester.pumpWidget(TranslationProvider(child: MaterialApp.router(routerConfig: router)));
    await tester.pump();
    return router;
  }

  testWidgets('macOS: быстрый ответ на другом устройстве не оставляет экран звонка', (tester) async {
    await pumpGate(tester);

    calls.emit(const CallSnapshot(status: CallStatus.incoming, callId: 'call-1', remoteUserID: [2]));
    calls.emit(const CallSnapshot(status: CallStatus.ended, callId: 'call-1', remoteUserID: [2]));
    await tester.pump();
    await tester.pump();

    expect(find.text('home screen'), findsOneWidget);
    expect(find.text('call screen'), findsNothing);
  });

  testWidgets('macOS: завершение открытого звонка возвращает на предыдущий экран', (tester) async {
    await pumpGate(tester);

    calls.emit(const CallSnapshot(status: CallStatus.incoming, callId: 'call-1', remoteUserID: [2]));
    await tester.pump();
    await tester.pump();
    expect(find.text('call screen'), findsOneWidget);

    calls.emit(const CallSnapshot(status: CallStatus.ended, callId: 'call-1', remoteUserID: [2]));
    await tester.pump();
    await tester.pump();

    expect(find.text('home screen'), findsOneWidget);
    expect(find.text('call screen'), findsNothing);
  });

  testWidgets('свёрнутый звонок снова открывается по focusRequest', (tester) async {
    final router = await pumpGate(tester);
    calls.emit(const CallSnapshot(status: CallStatus.outgoing, callId: 'call-1', remoteUserID: [2]));
    await tester.pump();
    await tester.pump();
    expect(find.text('call screen'), findsOneWidget);

    router.pop();
    await tester.pump();
    await tester.pump();
    expect(find.text('home screen'), findsOneWidget);
    expect(find.text('call screen'), findsNothing);

    calls.focus();
    await tester.pump();
    await tester.pump();
    expect(find.text('call screen'), findsOneWidget);
  });

  testWidgets('быстрый новый звонок не закрывается отложенным pop предыдущего', (tester) async {
    await pumpGate(tester);
    calls.emit(const CallSnapshot(status: CallStatus.outgoing, callId: 'call-1', remoteUserID: [2]));
    await tester.pump();
    await tester.pump();
    expect(find.text('call screen'), findsOneWidget);

    calls.emit(const CallSnapshot(status: CallStatus.ended, callId: 'call-1', remoteUserID: [2]));
    calls.emit(const CallSnapshot(status: CallStatus.outgoing, callId: 'call-2', remoteUserID: [2]));
    await tester.pump();
    await tester.pump();

    expect(find.text('call screen'), findsOneWidget);
    expect(find.text('home screen'), findsNothing);
  });

  testWidgets('завершение звонка не закрывает открытый поверх него detail', (tester) async {
    final router = await pumpGate(tester);
    calls.emit(const CallSnapshot(status: CallStatus.outgoing, callId: 'call-1', remoteUserID: [2]));
    await tester.pump();
    await tester.pump();
    router.push('/detail');
    await tester.pump();
    await tester.pump();
    expect(find.text('detail screen'), findsOneWidget);

    calls.emit(const CallSnapshot(status: CallStatus.ended, callId: 'call-1', remoteUserID: [2]));
    await tester.pump();
    await tester.pump();

    expect(find.text('detail screen'), findsOneWidget);
    expect(find.text('home screen'), findsNothing);

    router.pop();
    await tester.pump();
    await tester.pump();
    expect(find.text('home screen'), findsOneWidget);
    expect(find.text('call screen'), findsNothing);
  });
}

final class FakeCalls implements Calls {
  final _snapshots = StreamController<CallSnapshot>.broadcast(sync: true);
  final _focus = StreamController<void>.broadcast(sync: true);

  @override
  CallSnapshot snapshot = const CallSnapshot();

  @override
  Stream<CallSnapshot> get snapshots => _snapshots.stream;

  @override
  Stream<void> get focusRequests => _focus.stream;

  @override
  bool consumeMinimizeRequest() => false;

  void emit(CallSnapshot value) {
    snapshot = value;
    _snapshots.add(value);
  }

  void focus() => _focus.add(null);

  @override
  Future<void> dispose() async {
    await _snapshots.close();
    await _focus.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeUtils implements Utils {
  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

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
  }) => [if (contactName.isNotEmpty) contactName];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements Repositories {
  @override
  late final Contacts contacts = FakeContacts();

  @override
  late final Profiles profiles = FakeProfiles();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeContacts implements Contacts {
  @override
  Future<Map<String, String>> namesByUserID({required String Function(List<int>) toHex, List<List<int>>? userIDs}) async => {
    for (final userID in userIDs ?? const <List<int>>[]) toHex(userID): 'Peer',
  };

  @override
  Future<String?> phoneByUserID(List<int> userID) async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeProfiles implements Profiles {
  @override
  Future<models.Profile> getByUserID({required List<int> userID}) async => const models.Profile();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
