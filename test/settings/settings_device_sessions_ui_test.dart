import 'dart:typed_data';

import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart' as m;
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/cubit/settings/settings_device_sessions_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf.dart';
import 'package:messenger/repositories/repositories.dart' as repo;
import 'package:messenger/screens/settings/settings_device_sessions_cupertino.dart';
import 'package:messenger/screens/settings/settings_device_sessions_material.dart';

import '../support/fake_api.dart';

void main() {
  late Translations t;
  late FakeApi api;
  late FakeDeviceSessions deviceSessions;
  late SettingsDeviceSessionsCubit cubit;

  setUpAll(() async {
    await initializeDateFormatting('ru');
    t = await AppLocale.ru.build();
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  setUp(() async {
    api = FakeApi();
    deviceSessions = FakeDeviceSessions();
    deviceSessions.cached = [
      models.DeviceSessionsModel(sessionID: Uint8List.fromList([1]), deviceModel: 'Current Phone', os: 2, osVersion: '16'),
      models.DeviceSessionsModel(sessionID: Uint8List.fromList([2]), deviceModel: 'Other Mac', os: 3),
    ];
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Auth>(FakeAuth(models.Session(sessionID: [1])));
    getIt.registerSingleton<repo.Repositories>(FakeRepositories(deviceSessions));
    cubit = SettingsDeviceSessionsCubit();
    await cubit.initialization();
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

  Future<void> pumpScreen(WidgetTester tester, {required bool material}) {
    final child = BlocProvider.value(value: cubit, child: material ? SettingsDeviceSessionsMaterial() : SettingsDeviceSessionsCupertino());
    return tester.pumpWidget(
      TranslationProvider(
        child: material ? m.MaterialApp(home: child) : c.CupertinoApp(home: child),
      ),
    );
  }

  void enqueueTerminationError() {
    api.enqueueUnaryResult(
      MessageType.DEVICE_SESSIONS_TERMINATE,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'grpcError.unableConnectServer'),
    );
  }

  Future<void> terminateAll(WidgetTester tester) async {
    await tester.tap(find.text(t.screenSettingsDevices.terminateAllOtherDeviceSessions));
    await tester.pumpAndSettle();
  }

  for (final material in [false, true]) {
    final platform = material ? 'Material' : 'Cupertino';

    testWidgets('$platform: ошибка видна, список сохраняется, retry отправляет один запрос', (tester) async {
      await pumpScreen(tester, material: material);
      enqueueTerminationError();
      enqueueTerminationError();

      await terminateAll(tester);

      expect(find.text(t.grpcError.unableConnectServer), findsOneWidget);
      expect(material ? find.byType(m.SnackBar) : find.byType(c.CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Current Phone'), findsOneWidget);
      expect(find.text('Other Mac'), findsOneWidget);
      expect(api.unaryCalls, hasLength(1));

      if (!material) {
        await tester.tap(find.text(t.screenMyProfile.close));
        await tester.pumpAndSettle();
      }
      await terminateAll(tester);

      expect(api.unaryCalls, hasLength(2));
      for (final call in api.unaryCalls) {
        expect(call.type, MessageType.DEVICE_SESSIONS_TERMINATE);
        final request = DeviceSessionsTerminate_Request.fromBuffer(call.payload);
        expect(request.sessionID, [
          [2],
        ]);
      }
      expect(find.text(t.grpcError.unableConnectServer), findsOneWidget);
      expect(find.text('Other Mac'), findsOneWidget);
    });

    testWidgets('$platform: успешное завершение удаляет устройство после обновления стрима', (tester) async {
      await pumpScreen(tester, material: material);

      await terminateAll(tester);
      expect(api.unaryCalls.single.type, MessageType.DEVICE_SESSIONS_TERMINATE);
      expect(find.text('Other Mac'), findsOneWidget);

      api.emitMessage(
        MessageType.DEVICE_SESSIONS,
        DeviceSessions_Response(
          results: [
            DeviceSessions_DeviceSession(sessionID: [1], deviceModel: 'Current Phone', os: 2, osVersion: '16'),
          ],
        ).writeToBuffer(),
      );
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      expect(cubit.state.deviceSessions, hasLength(1));
      await tester.pump();

      expect(find.text('Current Phone'), findsOneWidget);
      expect(find.text('Other Mac'), findsNothing);
      expect(find.text(t.screenSettingsDevices.terminateAllOtherDeviceSessions), findsNothing);
    });
  }
}

final class FakeAuth implements Auth {
  @override
  final models.Session session;

  const FakeAuth(this.session);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeDeviceSessions implements repo.DeviceSessions {
  List<models.DeviceSessionsModel> cached = [];

  @override
  Future<List<models.DeviceSessionsModel>> getAll() async => cached;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements repo.Repositories {
  @override
  final FakeDeviceSessions deviceSessions;

  const FakeRepositories(this.deviceSessions);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
