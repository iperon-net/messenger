import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/cubit/settings/settings_cloud_password_cubit.dart';
import 'package:messenger/cubit/settings/settings_cloud_password_state.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  late FakeApi api;
  late SettingsCloudPasswordCubit cubit;
  late List<List<int>> registrationTokens;
  var registrationError = '';

  setUp(() async {
    api = FakeApi();
    registrationTokens = [];
    registrationError = '';
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(FakeUtils());
    getIt.registerSingleton<API>(api);
    cubit = SettingsCloudPasswordCubit(
      unlockPassword: (api, password) async => (token: const [10, 11, 12], error: ''),
      registerPassword: (api, password, token) async {
        registrationTokens.add(token);
        return registrationError;
      },
    );
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

  Future<void> unlock() async {
    await cubit.unlock('current-password');
    expect(cubit.state.step, SettingsCloudPasswordStep.menu);
    expect(cubit.state.heldToken, [10, 11, 12]);
  }

  void enqueueUnlockRequired(MessageType type) {
    api.enqueueUnaryResult(
      type,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unauthenticated, error: 'cloudPassword.unlockRequired'),
    );
  }

  void expectUnlockRequired() {
    expect(cubit.state.step, SettingsCloudPasswordStep.unlock);
    expect(cubit.state.heldToken, isEmpty);
    expect(cubit.state.error, 'cloudPassword.unlockRequired');
  }

  test('истёкший token при отключении требует повторной разблокировки', () async {
    await unlock();
    enqueueUnlockRequired(MessageType.CLOUD_PASSWORD_DISABLE);

    final disabled = await cubit.disable();

    expect(disabled, isFalse);
    expectUnlockRequired();
    final request = CloudPasswordDisable_Request.fromBuffer(api.unaryCalls.single.payload);
    expect(request.token, [10, 11, 12]);
  });

  test('истёкший token при смене email не сохраняет новый адрес', () async {
    await unlock();
    cubit.goChangeEmail();
    enqueueUnlockRequired(MessageType.CLOUD_PASSWORD_EMAIL_SET);

    await cubit.submitChangeEmail('new@example.com');

    expectUnlockRequired();
    expect(cubit.state.pendingEmail, isEmpty);
    final request = CloudPasswordEmailSet_Request.fromBuffer(api.unaryCalls.single.payload);
    expect(request.token, [10, 11, 12]);
    expect(request.email, 'new@example.com');
  });

  test('истёкший token при смене пароля требует повторной разблокировки', () async {
    await unlock();
    cubit.goChangePassword();
    registrationError = 'cloudPassword.unlockRequired';

    await cubit.submitChangePassword('new-password');

    expectUnlockRequired();
    expect(registrationTokens.single, [10, 11, 12]);
    expect(api.unaryCalls, isEmpty);
  });
}

final class FakeUtils implements Utils {
  @override
  Future<bool> hasNetwork() async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
