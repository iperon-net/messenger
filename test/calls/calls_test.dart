import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/calls.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/call_v1.pb.dart';
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/settings.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);
  final other = List<int>.filled(12, 3);
  const callID = '0f4ba7a4-46bd-4f24-9ea4-1e483cb01c74';

  late CallsFakeApi api;
  late FakeUtils utils;
  late FakeCallLogs callLogs;
  late Calls calls;

  const audioChannels = [MethodChannel('xyz.luan/audioplayers'), MethodChannel('xyz.luan/audioplayers.global')];

  setUp(() async {
    for (final channel in audioChannels) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (_) async => null);
    }
    api = CallsFakeApi();
    utils = FakeUtils();
    callLogs = FakeCallLogs();
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Auth>(FakeAuth(models.Session(userID: me)));
    getIt.registerSingleton<Settings>(FakeSettings());
    getIt.registerSingleton<Utils>(utils);
    getIt.registerSingleton<Crypto>(FakeCrypto());
    getIt.registerSingleton<Repositories>(FakeRepositories(callLogs));
    calls = Calls();
  });

  tearDown(() async {
    await calls.dispose();
    await api.dispose();
    await getIt.reset();
  });

  CallRing ring({String id = callID, List<int>? from, bool video = false, bool busy = false}) =>
      CallRing(callId: id, fromUserID: from ?? peer, video: video, busy: busy);

  Future<void> receive(MessageType type, CallRing message) async {
    api.emitMessage(type, message.writeToBuffer());
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }

  test('исходящий без сети завершается noConnection и пишется в локальный журнал', () async {
    await calls.startCall(toUserID: peer, video: true);

    expect(calls.snapshot.status, CallStatus.ended);
    expect(calls.snapshot.endReason, CallEndReason.noConnection);
    expect(calls.snapshot.remoteUserID, peer);
    expect(calls.snapshot.video, isTrue);
    expect(calls.snapshot.callId, matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(api.unaryCalls, isEmpty);
    expect(api.sentMessages, isEmpty);
    await Future<void>.delayed(Duration.zero);
    expect(callLogs.logs, hasLength(1));
    expect(callLogs.logs.single.direction, models.CallDirection.outgoing);
    expect(callLogs.logs.single.missed, isFalse);
    expect(callLogs.logs.single.durationSeconds, 0);
  });

  test('входящий RING создаёт снимок и одно системное уведомление, дубль игнорируется', () async {
    final rings = <CallSnapshot>[];
    final sub = calls.incomingRings.listen(rings.add);

    await receive(MessageType.CALL_RING, ring(video: true));
    await receive(MessageType.CALL_RING, ring(video: true));

    expect(calls.snapshot.status, CallStatus.incoming);
    expect(calls.snapshot.callId, callID);
    expect(calls.snapshot.remoteUserID, peer);
    expect(calls.snapshot.video, isTrue);
    expect(calls.snapshot.speakerOn, isTrue);
    expect(calls.hasActiveCall, isTrue);
    expect(rings, hasLength(1));
    expect(api.sentMessages, isEmpty);
    await sub.cancel();
  });

  test('второй входящий во время звонка получает busy, текущий не меняется', () async {
    await receive(MessageType.CALL_RING, ring());
    await receive(MessageType.CALL_RING, ring(id: 'second', from: other, video: true));

    expect(calls.snapshot.callId, callID);
    expect(calls.snapshot.remoteUserID, peer);
    expect(calls.snapshot.video, isFalse);
    expect(api.sentMessages, hasLength(1));
    expect(api.sentMessages.single.type, MessageType.CALL_REJECT);
    final rejection = CallRing.fromBuffer(api.sentMessages.single.payload);
    expect(rejection.callId, 'second');
    expect(rejection.toUserID, other);
    expect(rejection.busy, isTrue);
  });

  test('reject отправляет CALL_REJECT и сохраняет отклонённый, не пропущенный вызов', () async {
    await receive(MessageType.CALL_RING, ring());

    await calls.reject();
    await Future<void>.delayed(Duration.zero);

    expect(calls.snapshot.status, CallStatus.ended);
    expect(calls.snapshot.endReason, CallEndReason.rejected);
    expect(api.sentMessages.single.type, MessageType.CALL_REJECT);
    expect(CallRing.fromBuffer(api.sentMessages.single.payload).toUserID, peer);
    expect(api.callActive, [false]);
    expect(callLogs.logs.single.direction, models.CallDirection.incoming);
    expect(callLogs.logs.single.missed, isFalse);
  });

  test('hangup отправляет CALL_HANGUP и помечает неотвеченный входящий пропущенным', () async {
    await receive(MessageType.CALL_RING, ring());

    await calls.hangup();
    await Future<void>.delayed(Duration.zero);

    expect(calls.snapshot.endReason, CallEndReason.hangup);
    expect(api.sentMessages.single.type, MessageType.CALL_HANGUP);
    expect(CallRing.fromBuffer(api.sentMessages.single.payload).callId, callID);
    expect(callLogs.logs.single.missed, isTrue);
  });

  test('удалённый HANGUP завершает входящий без ответного сигнала', () async {
    await receive(MessageType.CALL_RING, ring());

    await receive(MessageType.CALL_HANGUP, ring());

    expect(calls.snapshot.status, CallStatus.ended);
    expect(calls.snapshot.endReason, CallEndReason.hangup);
    expect(api.sentMessages, isEmpty);
    expect(api.unaryCalls, isEmpty);
  });

  test('сигнал чужого callId не затрагивает текущий входящий', () async {
    await receive(MessageType.CALL_RING, ring());

    await receive(MessageType.CALL_REJECT, ring(id: 'other-call'));

    expect(calls.snapshot.status, CallStatus.incoming);
    expect(calls.snapshot.callId, callID);
    expect(api.sentMessages, isEmpty);
  });

  test('CALL_ACCEPT с другого устройства завершает локальный входящий', () async {
    await receive(MessageType.CALL_RING, ring());

    await receive(MessageType.CALL_ACCEPT, ring(from: me));

    expect(calls.snapshot.status, CallStatus.ended);
    expect(calls.snapshot.endReason, CallEndReason.none);
    expect(api.sentMessages, isEmpty);
    expect(callLogs.logs.single.missed, isTrue);
  });

  test('CALL_ACCEPT без локального снимка снимает нативный баннер по callId', () async {
    final dismissed = <String>[];
    final sub = calls.incomingDismiss.listen(dismissed.add);

    await receive(MessageType.CALL_ACCEPT, ring(from: me));

    expect(calls.snapshot.status, CallStatus.idle);
    expect(dismissed, [callID]);
    await sub.cancel();
  });

  test('повреждённый сигнал не меняет состояние', () async {
    api.emitMessage(MessageType.CALL_RING, [0xff, 0xff]);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(calls.snapshot.status, CallStatus.idle);
    expect(api.sentMessages, isEmpty);
  });

  test('rejectFromPush без активного стрима использует unary', () async {
    api.streamActive = false;
    await calls.rejectFromPush(callID, peer);
    await Future<void>.delayed(Duration.zero);

    expect(api.sentMessages, isEmpty);
    expect(api.unaryCalls.single.type, MessageType.CALL_REJECT);
    final rejection = CallRing.fromBuffer(api.unaryCalls.single.payload);
    expect(rejection.callId, callID);
    expect(rejection.toUserID, peer);
    expect(rejection.busy, isFalse);
    expect(calls.snapshot.status, CallStatus.idle);
  });

  test('endIncomingFromNative завершает только совпавший входящий', () async {
    await receive(MessageType.CALL_RING, ring());

    await calls.endIncomingFromNative('other-call');
    expect(calls.snapshot.status, CallStatus.incoming);

    await calls.endIncomingFromNative(callID);
    expect(calls.snapshot.status, CallStatus.ended);
    expect(calls.snapshot.endReason, CallEndReason.none);
    expect(api.sentMessages, isEmpty);
  });

  test('ошибка CALL_TOKEN после accept завершает звонок failed и освобождает API', () async {
    api.enqueueUnaryResult(MessageType.CALL_TOKEN, const APICallStatus(status: APIStatus.error, statusCode: 14, error: 'offline'));
    await receive(MessageType.CALL_RING, ring());

    await calls.accept();
    await Future<void>.delayed(Duration.zero);

    expect(calls.snapshot.status, CallStatus.ended);
    expect(calls.snapshot.endReason, CallEndReason.failed);
    expect(api.unaryCalls.map((call) => call.type), contains(MessageType.CALL_TOKEN));
    expect(api.sentMessages.single.type, MessageType.CALL_ACCEPT);
    expect(CallRing.fromBuffer(api.sentMessages.single.payload).toUserID, me);
    expect(api.callActive, [true, false]);
    expect(callLogs.logs.single.direction, models.CallDirection.incoming);
  });

  test('повторный accept не создаёт второй запрос CALL_TOKEN', () async {
    api.gateToken = Completer<void>();
    await receive(MessageType.CALL_RING, ring());

    final first = calls.accept();
    await calls.accept();
    expect(calls.snapshot.status, CallStatus.connecting);
    api.gateToken!.complete();
    await first;

    expect(api.unaryCalls.where((call) => call.type == MessageType.CALL_TOKEN), hasLength(1));
    expect(calls.snapshot.endReason, CallEndReason.failed);
  });

  test('ошибка CALL_TOKEN на исходящем сохраняет направление и причину failed', () async {
    utils.network = true;

    await calls.startCall(toUserID: peer, video: false);
    await Future<void>.delayed(Duration.zero);

    expect(calls.snapshot.status, CallStatus.ended);
    expect(calls.snapshot.endReason, CallEndReason.failed);
    expect(calls.isOwnOutgoingCall(calls.snapshot.callId), isTrue);
    expect(api.unaryCalls.single.type, MessageType.CALL_TOKEN);
    final token = CallToken_Request.fromBuffer(api.unaryCalls.single.payload);
    expect(token.toUserID, peer);
    expect(api.sentMessages.where((call) => call.type == MessageType.CALL_RING), isEmpty);
    expect(callLogs.logs.single.direction, models.CallDirection.outgoing);
  });

  test('групповой RING сохраняет участников без нас самих', () async {
    await receive(MessageType.CALL_RING, CallRing(callId: callID, fromUserID: peer, participants: [me, peer, other]));

    expect(calls.snapshot.group, isTrue);
    expect(calls.snapshot.participants.map((participant) => participant.userID), [peer, other]);
    expect(calls.snapshot.remoteUserID, peer);
  });

  test('toggleMic без комнаты меняет только локальный снимок', () async {
    await calls.toggleMic();
    expect(calls.snapshot.micMuted, isTrue);

    await calls.toggleMic();
    expect(calls.snapshot.micMuted, isFalse);
    expect(api.unaryCalls, isEmpty);
  });

  test('запрос минимизации потребляется один раз, focus транслируется подписчику', () async {
    var focusCount = 0;
    final sub = calls.focusRequests.listen((_) => focusCount++);

    expect(calls.consumeMinimizeRequest(), isFalse);
    calls.markMinimizeRequest();
    expect(calls.consumeMinimizeRequest(), isTrue);
    expect(calls.consumeMinimizeRequest(), isFalse);
    calls.requestFocus();
    await Future<void>.delayed(Duration.zero);
    expect(focusCount, 1);
    await sub.cancel();
  });
}

final class CallsFakeApi extends FakeApi {
  final callActive = <bool>[];
  Completer<void>? gateToken;

  @override
  var streamActive = true;

  @override
  void setCallActive(bool active) => callActive.add(active);

  @override
  Future<(APICallStatus, Uint8List?)> unaryEncodedWithResponse(MessageType type, Uint8List payload) async {
    unaryCalls.add(FakeApiCall(type, payload));
    if (type == MessageType.CALL_TOKEN) {
      await gateToken?.future;
      return (const APICallStatus(status: APIStatus.error, statusCode: 14, error: 'test'), null);
    }
    return super.unaryEncodedWithResponse(type, payload);
  }
}

final class FakeUtils implements Utils {
  var network = false;

  @override
  Future<bool> hasNetwork() async => network;

  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeAuth implements Auth {
  @override
  final models.Session session;

  const FakeAuth(this.session);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeSettings implements Settings {
  @override
  int get callRingTimeoutSeconds => 45;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeCrypto implements Crypto {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements Repositories {
  @override
  final FakeCallLogs callLogs;

  @override
  late final SettingsDevice settingsDevice = FakeSettingsDevice();

  FakeRepositories(this.callLogs);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeSettingsDevice implements SettingsDevice {
  @override
  Future<models.SettingsDeviceModel> getAll() async => models.SettingsDeviceModel(callsE2ee: false);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeCallLogs implements CallLogs {
  final logs = <models.CallLog>[];

  @override
  Future<void> insert({required List<int> ownerID, required models.CallLog log}) async {
    logs.add(log);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
