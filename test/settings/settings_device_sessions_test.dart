import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/cubit/settings/settings_device_sessions_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf.dart';
import 'package:messenger/repositories/repositories.dart' as repo;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late FakeDeviceSessions deviceSessions;
  late SettingsDeviceSessionsCubit cubit;

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
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

  test('сначала показывает кэш и отмечает текущее устройство', () async {
    await cubit.initialization();

    expect(cubit.state.status, Status.success);
    expect(cubit.state.deviceSessions, hasLength(2));
    expect(cubit.state.deviceSessions[0].isCurrent, isTrue);
    expect(cubit.state.deviceSessions[1].isCurrent, isFalse);
    expect(api.sentMessages.single.type, MessageType.DEVICE_SESSIONS);
  });

  test('stream заменяет список свежими устройствами', () async {
    await cubit.initialization();

    api.emitMessage(
      MessageType.DEVICE_SESSIONS,
      DeviceSessions_Response(
        results: [
          DeviceSessions_DeviceSession(
            sessionID: [3],
            deviceModel: 'New iPhone',
            os: 1,
            osVersion: '19.0',
            appVersion: '2.0.0',
            appBuildNumber: '100',
            locationEnglish: 'Berlin',
            locationRussian: 'Берлин',
            updateAt: Timestamp(seconds: Int64(1700000000)),
          ),
        ],
      ).writeToBuffer(),
    );
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.deviceSessions, hasLength(1));
    final session = cubit.state.deviceSessions.single;
    expect(session.sessionID, [3]);
    expect(session.isCurrent, isFalse);
    expect(session.deviceModel, 'New iPhone');
    expect(session.appVersion, '2.0.0');
    expect(session.locationRussian, 'Берлин');
    expect(session.updateAt.millisecondsSinceEpoch, 1700000000000);
  });

  test('завершение сессии отправляет sessionID и завершает loading', () async {
    await cubit.terminate([
      Uint8List.fromList([7, 8, 255]),
    ]);

    expect(cubit.state.requestStatus, Status.success);
    expect(api.unaryCalls.single.type, MessageType.DEVICE_SESSIONS_TERMINATE);
    final request = DeviceSessionsTerminate_Request.fromBuffer(api.unaryCalls.single.payload);
    expect(request.sessionID, [
      [7, 8, 255],
    ]);
  });

  test('ошибка завершения не выдаётся за успех и сохраняет список', () async {
    await cubit.initialization();
    final cachedSessions = cubit.state.deviceSessions;
    api.enqueueUnaryResult(
      MessageType.DEVICE_SESSIONS_TERMINATE,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'grpcError.unableConnectServer'),
    );

    await cubit.terminate([
      Uint8List.fromList([2]),
    ]);

    expect(cubit.state.requestStatus, Status.success);
    expect(cubit.state.error, 'grpcError.unableConnectServer');
    expect(cubit.state.deviceSessions, cachedSessions);
  });
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
