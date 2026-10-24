import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/repositories.dart';
import 'account_scope.dart';
import 'chats/spoiler_reveals.dart';
import 'logger.dart';
import 'routers.dart';
import 'auth.dart';
import 'settings.dart';
import 'utils.dart';
import 'api.dart';
import 'calls.dart';
import 'crypto.dart';
import 'cdn.dart';
import 'push.dart';
import 'call_push.dart';

GetIt getIt = GetIt.instance;

/// Имя scope get_it с сервисами аккаунта (docs/plans/multi-account.md, этап 3):
/// корневой scope — общее для устройства, этот — активный аккаунт.
const _accountScopeName = 'account';

/// Общие зависимости (логи, настройки, `device.db`, крипта) и сервисы
/// активного аккаунта ([openAccount]).
Future<void> registerCommonDependencies() async {
  if (!getIt.isRegistered<Logger>()) {
    getIt.registerSingletonAsync<Logger>(() async => Logger.initialization());
  }
  if (!getIt.isRegistered<Settings>()) {
    getIt.registerSingletonAsync<Settings>(() async => Settings.initialization(), dependsOn: [Logger]);
  }
  if (!getIt.isRegistered<Utils>()) {
    getIt.registerSingletonAsync<Utils>(() async => Utils());
  }
  if (!getIt.isRegistered<Crypto>()) {
    getIt.registerSingletonAsync<Crypto>(() async => Crypto(), dependsOn: [Settings, Utils]);
  }
  if (!getIt.isRegistered<DeviceRepositories>()) {
    getIt.registerSingletonAsync<DeviceRepositories>(() async => DeviceRepositories.initialization(), dependsOn: [Settings]);
  }
  await getIt.allReady();

  if (!getIt.hasScope(_accountScopeName)) await openAccount(getIt.get<DeviceRepositories>().activeAccountID);
}

/// Сервисы аккаунта [accountID] — в новом scope get_it; он становится
/// активным ([AccountScope.current]).
Future<void> openAccount(String accountID) async {
  final scope = AccountScope(accountID);
  AccountScope.activate(scope);
  final device = getIt.get<DeviceRepositories>();
  getIt.pushNewScope(
    scopeName: _accountScopeName,
    init: (getIt) {
      getIt.registerSingletonAsync<Repositories>(
        () async => Repositories.initialization(device: device, accountID: accountID),
        dispose: (repositories) => repositories.close(),
      );
      getIt.registerSingletonAsync<API>(() async => API(), dependsOn: [Settings], dispose: (api) => api.shutdown());
      getIt.registerSingletonAsync<Auth>(() async => Auth.initialization(), dependsOn: [Repositories, API]);
      getIt.registerSingletonAsync<Routers>(() async => Routers(), dependsOn: [Repositories, Auth]);
      getIt.registerSingletonAsync<CDNManager>(() async => CDNManager(), dependsOn: [API, Crypto, Auth, Repositories]);
      getIt.registerSingletonAsync<Calls>(() async => Calls(), dependsOn: [Settings, API, Auth], dispose: (calls) => calls.dispose());
      getIt.registerSingletonAsync<PushManager>(
        () async => PushManager(),
        dependsOn: [API, Auth, Repositories],
        dispose: (push) => push.dispose(),
      );
      getIt.registerSingletonAsync<CallPush>(
        () async => CallPush(),
        dependsOn: [Calls, Utils, PushManager, Repositories],
        dispose: (callPush) => callPush.dispose(),
      );
    },
  );
  await getIt.allReady();
  scope.bind();
}

/// Закрыть сервисы активного аккаунта: синглтоны чатов, затем его scope
/// get_it (стрим, база, звонки, пуши).
Future<void> closeAccount() async {
  await AccountScope.current.dispose();
  if (getIt.hasScope(_accountScopeName)) await getIt.popScope();
}

/// Запуск фоновой работы аккаунта после [openAccount]: регистрация пуш-
/// токенов, мост call-пушей, раскрытые спойлеры.
Future<void> startAccountServices() async {
  final settingsDevice = await getIt.get<DeviceRepositories>().settingsDevice.getAll();
  // Само-гейтится на авторизацию; VoIP-токен iOS синхронизирует CallPush. См.
  // docs/plans/push-notifications.md.
  // Fire-and-forget: не задерживает запуск.
  unawaited(
    getIt.get<PushManager>().start(passcodeEnabled: settingsDevice.passcode.isNotEmpty && !settingsDevice.passcodeNotificationContent),
  );
  // Раскрытые спойлеры — в память до первого открытого чата.
  unawaited(SpoilerReveals.preload());
  // Мост call-пуш → нативный входящий (CallKit/ConnectionService) → Calls.
  getIt.get<CallPush>().start();
}

/// Идёт переключение аккаунта: корень приложения на это время пустой — старое
/// дерево не должно обращаться к сервисам закрываемого аккаунта.
final accountSwitching = ValueNotifier<bool>(false);

/// Сделать активным аккаунт [accountID] (слот в `device.db`). Во время звонка
/// нельзя — [StateError].
Future<void> switchAccount(String accountID) async {
  if (accountID == AccountScope.current.accountID) return;
  final status = getIt.get<Calls>().snapshot.status;
  if (status != CallStatus.idle && status != CallStatus.ended) throw StateError('switchAccount: a call is in progress');

  final logger = getIt.get<Logger>();
  logger.info('account: switching ${AccountScope.current.accountID} → $accountID');
  accountSwitching.value = true;
  try {
    // Старое дерево виджетов (кубиты, подписки) уходит до закрытия сервисов.
    await WidgetsBinding.instance.endOfFrame;
    await closeAccount();
    await getIt.get<DeviceRepositories>().accounts.ensureActive(accountID);
    await openAccount(accountID);
    await startAccountServices();
  } finally {
    AccountScope.generation.value++;
    accountSwitching.value = false;
  }
}

Future<void> unregisterCommonDependencies() async {
  await closeAccount();
  if (getIt.isRegistered<Logger>()) {
    await getIt.get<Logger>().fileLogger.dispose();
    await getIt.unregister<Logger>();
  }
  if (getIt.isRegistered<Settings>()) await getIt.unregister<Settings>();
  if (getIt.isRegistered<DeviceRepositories>()) await getIt.unregister<DeviceRepositories>();
  if (getIt.isRegistered<Utils>()) {
    await getIt.unregister<Utils>(disposingFunction: (utils) => utils.dispose());
  }
  if (getIt.isRegistered<Crypto>()) await getIt.unregister<Crypto>();
}
