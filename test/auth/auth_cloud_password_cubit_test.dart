import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/cubit/auth/auth_cloud_password_cubit.dart';
import 'package:messenger/cubit/auth/auth_cloud_password_state.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late FakeUtils utils;
  late AuthCloudPasswordCubit cubit;

  setUp(() async {
    api = FakeApi();
    utils = FakeUtils();
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(utils);
    getIt.registerSingleton<API>(api);
    cubit = AuthCloudPasswordCubit()..initialization(confirmationSession: '0102ff');
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

  test('инициализация сохраняет confirmationSession', () {
    expect(cubit.state.confirmationSession, [1, 2, 255]);
    expect(cubit.state.phase, AuthCloudPasswordPhase.enterPassword);
  });

  test('пустой пароль отклоняется локально', () async {
    await cubit.submit('');

    expect(cubit.state.error, 'cloudPassword.passwordRequired');
    expect(api.callCount, 0);
  });

  test('истёкшая сессия при проверке пароля возвращает на /auth', () async {
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unauthenticated, error: 'grpcError.unauthenticated'),
    );

    await cubit.submit('secret');

    expect(cubit.state.error, 'grpcError.unauthenticated');
    expect(cubit.state.redirectURI, '/auth');
    expect(api.requests, isEmpty);
  });

  test('offline при восстановлении не отправляет email', () async {
    utils.network = false;
    cubit.startRecovery();

    await cubit.submitRecoveryEmail('user@example.com');

    expect(cubit.state.phase, AuthCloudPasswordPhase.enterEmail);
    expect(cubit.state.error, 'grpcError.unableConnectServer');
    expect(api.callCount, 0);
  });

  test('ответ восстановления не раскрывает наличие email', () async {
    cubit.startRecovery();
    api.enqueueResponse(MessageType.AUTH_CLOUD_PASSWORD_RECOVERY, Message(messageType: MessageType.AUTH_CLOUD_PASSWORD_RECOVERY));

    await cubit.submitRecoveryEmail('user@example.com');

    expect(cubit.state.phase, AuthCloudPasswordPhase.recovery);
    expect(cubit.state.pendingEmail, 'user@example.com');
    expect(cubit.state.error, isEmpty);
    final request = AuthCloudPasswordRecovery_Request.fromBuffer(api.requests.single.message);
    expect(request.confirmationSession, [1, 2, 255]);
    expect(request.email, 'user@example.com');
  });

  test('unauthenticated при восстановлении начинает вход заново', () async {
    cubit.startRecovery();
    api.enqueueCallResult(
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unauthenticated, error: 'grpcError.unauthenticated'),
    );

    await cubit.submitRecoveryEmail('user@example.com');

    expect(cubit.state.phase, AuthCloudPasswordPhase.enterEmail);
    expect(cubit.state.error, 'grpcError.unauthenticated');
    expect(cubit.state.redirectURI, '/auth');
  });

  test('код и новый пароль обязательны', () async {
    await cubit.recoveryConfirm(code: '', newPassword: 'new-secret');
    expect(cubit.state.error, 'cloudPassword.codeRequired');

    await cubit.recoveryConfirm(code: '123456', newPassword: '');
    expect(cubit.state.error, 'cloudPassword.passwordRequired');
    expect(api.callCount, 0);
  });
}

final class FakeUtils implements Utils {
  var network = true;

  @override
  Future<bool> hasNetwork() async => network;

  @override
  Uint8List hexToBytes(String hex) {
    return Uint8List.fromList([for (var index = 0; index < hex.length; index += 2) int.parse(hex.substring(index, index + 2), radix: 16)]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
