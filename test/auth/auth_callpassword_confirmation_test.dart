import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:messenger/api.dart';
import 'package:messenger/cubit/auth/auth_callpassword_confirmation_cubit.dart';
import 'package:messenger/cubit/auth/auth_callpassword_confirmation_state.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late AuthCallpasswordConfirmationCubit cubit;

  setUp(() async {
    api = FakeApi();
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<API>(api);
    cubit = AuthCallpasswordConfirmationCubit();
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

  Future<void> initialize({String timeout = '60'}) async {
    await cubit.initialization(callPasswordSession: '0102ff', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: timeout);
    await Future<void>.delayed(Duration.zero);
  }

  StreamController<Message> server() => api.responseStreams.single;

  void respond(AuthCallPasswordConfirmation_Response response) {
    server().add(Message(messageType: MessageType.AUTH_CALL_PASSWORD_CONFIRMATION, message: response.writeToBuffer()));
  }

  test('открывает стрим и отправляет session из параметров экрана', () async {
    await initialize();

    expect(cubit.state.callPasswordSession, [1, 2, 255]);
    expect(cubit.state.confirmationPhoneNumber, '+7 *** ***-**-44');
    expect(cubit.state.tickerSecond, 60);
    expect(cubit.state.result, AuthCallPasswordConfirmationResult.waiting);

    final request = AuthCallPasswordConfirmation_Request.fromBuffer(api.requests.single.message);
    expect(api.requests.single.messageType, MessageType.AUTH_CALL_PASSWORD_CONFIRMATION);
    expect(request.callPasswordSession, [1, 2, 255]);
  });

  test('первый healthcheck синхронизирует остаток таймера', () async {
    await initialize();

    respond(AuthCallPasswordConfirmation_Response(timer: Int64(42)));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.tickerSecond, 42);
    expect(cubit.state.result, AuthCallPasswordConfirmationResult.waiting);
    expect(cubit.state.redirectURI, isEmpty);
  });

  test('успех с облачным паролем ведёт на его ввод', () async {
    await initialize();

    respond(
      AuthCallPasswordConfirmation_Response(
        authCallPasswordStatus: AuthCallPasswordStatus.success,
        hasTwoStepVerification: true,
        confirmationSession: [10, 11, 255],
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final uri = Uri.parse(cubit.state.redirectURI);
    expect(uri.path, '/auth/cloud_password');
    expect(uri.queryParameters['confirmationSession'], '0a0bff');
  });

  test('ошибка подтверждения показывает сообщение и возвращает на вход', () async {
    await initialize();

    respond(AuthCallPasswordConfirmation_Response(authCallPasswordStatus: AuthCallPasswordStatus.error, errorMessage: 'callExpired'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.error);
    expect(cubit.state.error, 'callExpired');
    expect(cubit.state.redirectURI, '/auth');
  });

  test('блокировка без confirmationSession ведёт на экран блокировки', () async {
    await initialize();

    respond(AuthCallPasswordConfirmation_Response(isBlocked: true));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.blocked);
    expect(cubit.state.redirectURI, '/auth/blocked');
  });

  test('ошибка gRPC-стрима прекращает ожидание и возвращает на вход', () async {
    await initialize();

    server().addError(GrpcError.unavailable('connectionLost'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.error);
    expect(cubit.state.error, 'connectionLost');
    expect(cubit.state.redirectURI, '/auth');
  });

  test('штатное закрытие стрима означает timeout', () async {
    await initialize();

    await server().close();
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.timeout);
    expect(cubit.state.tickerSecond, 60);
    expect(cubit.state.redirectURI, '/auth');
  });

  test('локальный таймер завершает ожидание', () async {
    await initialize(timeout: '1');

    await Future<void>.delayed(const Duration(milliseconds: 1100));

    expect(cubit.state.result, AuthCallPasswordConfirmationResult.timeout);
    expect(cubit.state.tickerSecond, 0);
    expect(cubit.state.redirectURI, '/auth');
  });
}

final class FakeUtils implements Utils {
  @override
  Uint8List hexToBytes(String hex) {
    return Uint8List.fromList([for (var index = 0; index < hex.length; index += 2) int.parse(hex.substring(index, index + 2), radix: 16)]);
  }

  @override
  String bytesToHex(Uint8List bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
