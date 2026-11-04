import 'package:cupertino_ui/cupertino_ui.dart' as c;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:material_ui/material_ui.dart' as m;
import 'package:messenger/api.dart';
import 'package:messenger/cubit/settings/settings_cloud_password_cubit.dart';
import 'package:messenger/cubit/settings/settings_cloud_password_state.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf.dart';
import 'package:messenger/screens/settings/settings_cloud_password_cupertino.dart';
import 'package:messenger/screens/settings/settings_cloud_password_material.dart';
import 'package:messenger/utils.dart';

import '../support/fake_api.dart';

void main() {
  late Translations t;
  late FakeApi api;
  late FakeUtils utils;
  late SettingsCloudPasswordCubit cubit;
  late List<String> unlockPasswords;

  setUpAll(() async {
    t = await AppLocale.ru.build();
    await LocaleSettings.setLocale(AppLocale.ru);
  });

  setUp(() async {
    api = FakeApi();
    utils = FakeUtils();
    unlockPasswords = [];
    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<Utils>(utils);
    getIt.registerSingleton<API>(api);
    cubit = SettingsCloudPasswordCubit(
      unlockPassword: (api, password) async {
        unlockPasswords.add(password);
        return (token: unlockPasswords.length == 1 ? const [10, 11] : const [20, 21], error: '');
      },
    );
  });

  tearDown(() async {
    await cubit.close();
    await api.dispose();
    await getIt.reset();
  });

  Future<void> pumpScreen(WidgetTester tester, {required bool material}) {
    final child = BlocProvider.value(
      value: cubit,
      child: material ? const SettingsCloudPasswordMaterial() : const SettingsCloudPasswordCupertino(),
    );
    return tester.pumpWidget(
      TranslationProvider(
        child: material ? m.MaterialApp(home: child) : c.CupertinoApp(home: child),
      ),
    );
  }

  void enqueueInfo({required bool enabled}) {
    api.enqueueUnaryResponse(
      MessageType.CLOUD_PASSWORD_INFO,
      CloudPasswordInfo_Response(isEnabled: enabled, maskedEmail: 'u***@example.com', isEmailVerified: true).writeToBuffer(),
    );
  }

  for (final material in [false, true]) {
    final platform = material ? 'Material' : 'Cupertino';

    testWidgets('$platform: unlockRequired виден, пароль вводится заново, старый token не используется', (tester) async {
      await cubit.unlock('current-password');
      await pumpScreen(tester, material: material);
      api.enqueueUnaryResult(
        MessageType.CLOUD_PASSWORD_DISABLE,
        const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unauthenticated, error: 'cloudPassword.unlockRequired'),
      );

      await tester.tap(find.text(t.cloudPassword.disable));
      await tester.pumpAndSettle();

      expect(find.text(t.cloudPassword.unlockRequired), findsOneWidget);
      expect(cubit.state.step, SettingsCloudPasswordStep.unlock);
      expect(cubit.state.heldToken, isEmpty);
      expect(find.text(t.cloudPassword.changePassword), findsNothing);

      final field = material ? find.byType(m.TextFormField) : find.byType(c.CupertinoTextFormFieldRow);
      await tester.enterText(field, 'new-current-password');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(unlockPasswords, ['current-password', 'new-current-password']);
      expect(cubit.state.step, SettingsCloudPasswordStep.menu);
      expect(cubit.state.heldToken, [20, 21]);
      expect(find.text(t.cloudPassword.changePassword), findsOneWidget);
      expect(api.unaryCalls, hasLength(1));
    });

    testWidgets('$platform: offline отображается и retry загружает экран разблокировки', (tester) async {
      utils.network = false;
      await cubit.initialization();
      await pumpScreen(tester, material: material);

      expect(find.text(t.common.noConnectionTitle), findsOneWidget);
      expect(find.text(t.common.noConnectionMessage), findsOneWidget);
      expect(api.unaryCalls, isEmpty);

      utils.network = true;
      enqueueInfo(enabled: true);
      await tester.tap(find.text(t.cloudPassword.retry));
      await tester.pumpAndSettle();

      expect(find.text(t.common.noConnectionTitle), findsNothing);
      expect(cubit.state.step, SettingsCloudPasswordStep.unlock);
      expect(material ? find.byType(m.TextFormField) : find.byType(c.CupertinoTextFormFieldRow), findsOneWidget);
      expect(api.unaryCalls.single.type, MessageType.CLOUD_PASSWORD_INFO);
    });

    testWidgets('$platform: ошибка загрузки отображается и retry открывает установку пароля', (tester) async {
      api.enqueueUnaryResult(
        MessageType.CLOUD_PASSWORD_INFO,
        const APICallStatus(status: APIStatus.error, statusCode: StatusCode.internal, error: 'grpcError.internalServerError'),
      );
      await cubit.initialization();
      await pumpScreen(tester, material: material);

      expect(find.text(t.cloudPassword.loadError), findsOneWidget);
      expect(find.text(t.common.noConnectionTitle), findsNothing);

      enqueueInfo(enabled: false);
      await tester.tap(find.text(t.cloudPassword.retry));
      await tester.pumpAndSettle();

      expect(find.text(t.cloudPassword.loadError), findsNothing);
      expect(cubit.state.step, SettingsCloudPasswordStep.setupEmail);
      expect(find.text(t.cloudPassword.emailPlaceholder), findsWidgets);
      expect(api.unaryCalls.map((call) => call.type), [MessageType.CLOUD_PASSWORD_INFO, MessageType.CLOUD_PASSWORD_INFO]);
    });
  }
}

final class FakeUtils implements Utils {
  var network = true;

  @override
  Future<bool> hasNetwork() async => network;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
