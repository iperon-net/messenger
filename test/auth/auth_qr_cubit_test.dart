import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/cubit/auth/auth_qr_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' show DeviceInfoModel, OS, PackageInfoModel;
import 'package:messenger/protobuf.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late FakeUtils utils;
  late AuthQrCubit cubit;

  setUp(() async {
    api = FakeApi();
    utils = FakeUtils();
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(utils);
    getIt.registerSingleton<API>(api);
    cubit = AuthQrCubit();
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

  Message qrResponse(AuthQr_Response response) {
    return Message(messageType: MessageType.AUTH_QR, message: response.writeToBuffer());
  }

  test('создание QR содержит токен и данные устройства', () async {
    api.enqueueResponse(
      MessageType.AUTH_QR,
      qrResponse(AuthQr_Response(token: [1, 2, 255], expiresAt: Int64(DateTime.now().millisecondsSinceEpoch + 60000))),
    );

    await cubit.initialization();

    expect(cubit.state.qrData, qrLoginData([1, 2, 255]));
    expect(parseQrLoginToken(cubit.state.qrData), [1, 2, 255]);
    expect(cubit.state.error, isEmpty);
    final request = AuthQr_Request.fromBuffer(api.requests.single.message);
    expect(request.newToken.device.deviceModel, 'Test Mac');
    expect(request.newToken.device.os, 3);
    expect(request.newToken.device.osVersion, '15.0');
    expect(request.newToken.device.appVersion, '1.2.3');
  });

  test('ошибка создания показывает retry без таймера и QR', () async {
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'grpcError.errorConnectingServer'),
    );

    await cubit.initialization();

    expect(cubit.state.error, 'grpcError.errorConnectingServer');
    expect(cubit.state.qrData, isEmpty);
    expect(api.requests, isEmpty);
  });

  test('подтверждение с двухшаговой проверкой ведёт к облачному паролю', () async {
    api.enqueueResponse(
      MessageType.AUTH_QR,
      qrResponse(AuthQr_Response(token: [1, 2, 3], expiresAt: Int64(DateTime.now().millisecondsSinceEpoch + 60000))),
    );
    api.enqueueResponse(
      MessageType.AUTH_QR,
      qrResponse(AuthQr_Response(status: AuthQr_Status.ACCEPTED, hasTwoStepVerification: true, confirmationSession: [10, 11, 255])),
    );

    await cubit.initialization();
    await Future<void>.delayed(const Duration(milliseconds: 2100));

    final uri = Uri.parse(cubit.state.redirectURI);
    expect(uri.path, '/auth/cloud_password');
    expect(uri.queryParameters['confirmationSession'], '0a0bff');
    expect(cubit.state.completing, isFalse);
    expect(api.requests.length, 2);
    final poll = AuthQr_Request.fromBuffer(api.requests[1].message);
    expect(poll.poll.token, [1, 2, 3]);
  });
}

final class FakeUtils implements Utils {
  var network = true;

  @override
  Future<bool> hasNetwork() async => network;

  @override
  Future<PackageInfoModel> packageInfo() async => const PackageInfoModel(appVersion: '1.2.3', appBuildNumber: '42');

  @override
  Future<DeviceInfoModel> deviceInfo() async =>
      const DeviceInfoModel(deviceModel: 'Test Mac', os: OS.macOS, osCode: 3, osVersion: '15.0', isPhysicalDevice: true);

  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
