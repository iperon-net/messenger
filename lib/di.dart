import 'dart:async';

import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:messenger/repositories/repositories.dart';
import 'account_scope.dart';
import 'accounts.dart';
import 'chats/spoiler_reveals.dart';
import 'logger.dart';
import 'platform.dart';
import 'routers.dart';
import 'auth.dart';
import 'settings.dart';
import 'storage_usage.dart';
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
  // На десктопе звонков пока нет (docs/plans/desktop-client.md, §7).
  if (AppPlatform.hasCalls) getIt.get<CallPush>().start();
  // Имя и аватар — в слот аккаунта (список аккаунтов в «Настройках»).
  AccountProfileSync.instance.start();
  // «Хранить медиа» и предел размера кэша.
  StorageUsage.instance.start();
}

/// Идёт переключение аккаунта: дерево приложения на это время снято — старое
/// не должно обращаться к сервисам закрываемого аккаунта; вместо него —
/// [accountSwitchSnapshot].
final accountSwitching = ValueNotifier<bool>(false);

/// Корень приложения (`RepaintBoundary` в main.dart) — с него снимок экрана
/// перед переключением.
final accountRootKey = GlobalKey();

/// Снимок экрана до переключения аккаунта: показывается вместо пустоты, пока
/// закрывается старый аккаунт и открывается новый.
final accountSwitchSnapshot = ValueNotifier<ui.Image?>(null);

/// Застывший снимок прежнего экрана на время переключения (нет снимка — фон).
/// С [fading] (переключение закончилось, новый корень уже под ним) ждёт, пока
/// новый экран нарисуется и подтянет данные, и плавно гаснет; погаснув —
/// убирает снимок ([accountSwitchSnapshot]) и освобождает его.
class AccountSwitchSnapshot extends StatefulWidget {
  const AccountSwitchSnapshot({required this.image, required this.fading, super.key});

  final ui.Image? image;
  final bool fading;

  @override
  State<AccountSwitchSnapshot> createState() => _AccountSwitchSnapshotState();
}

class _AccountSwitchSnapshotState extends State<AccountSwitchSnapshot> with SingleTickerProviderStateMixin {
  late final _opacity = AnimationController(vsync: this, duration: const Duration(milliseconds: 200), value: 1);
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _maybeFade();
  }

  @override
  void didUpdateWidget(AccountSwitchSnapshot oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeFade();
  }

  Future<void> _maybeFade() async {
    if (!widget.fading || _started) return;
    _started = true;
    // Первые кадры нового корня: роутер, кубиты, чтение списка из базы.
    for (var i = 0; i < 3; i++) {
      await WidgetsBinding.instance.endOfFrame;
    }
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    await _opacity.reverse();
    if (mounted && accountSwitchSnapshot.value == widget.image) accountSwitchSnapshot.value = null;
  }

  @override
  void dispose() {
    _opacity.dispose();
    // RawImage держит свою копию — исходник можно освободить сразу.
    widget.image?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.image;
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return FadeTransition(
      opacity: _opacity,
      child: image == null
          ? ColoredBox(color: brightness == Brightness.dark ? const Color(0xFF1B263B) : const Color(0xFFF2F2F7))
          : SizedBox.expand(
              child: RawImage(image: image, fit: BoxFit.cover),
            ),
    );
  }
}

Future<ui.Image?> _captureRoot() async {
  try {
    final boundary = accountRootKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary || !boundary.hasSize) return null;
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    // Без экрана (подняты в фоне) снимок может не прийти — не ждём.
    return await boundary.toImage(pixelRatio: view.devicePixelRatio).timeout(const Duration(milliseconds: 500));
  } catch (_) {
    return null;
  }
}

/// Сделать активным аккаунт [accountID] (слот в `device.db`). Во время звонка
/// нельзя — [StateError].
Future<void> switchAccount(String accountID) async {
  if (accountID == AccountScope.current.accountID) return;
  final status = getIt.get<Calls>().snapshot.status;
  if (status != CallStatus.idle && status != CallStatus.ended) throw StateError('switchAccount: a call is in progress');

  final logger = getIt.get<Logger>();
  logger.info('account: switching ${AccountScope.current.accountID} → $accountID');
  accountSwitchSnapshot.value = await _captureRoot();
  accountSwitching.value = true;
  try {
    // Старое дерево виджетов (кубиты, подписки) уходит до закрытия сервисов:
    // кадр со снимком, затем кадр, где уходящее дерево уже снято. Поднятые в
    // фоне без экрана (ответ из шторки, звонок) кадров не получают — не ждём
    // дольше доли секунды, иначе переключение висит до первого кадра.
    for (var i = 0; i < 2; i++) {
      await WidgetsBinding.instance.endOfFrame.timeout(const Duration(milliseconds: 300), onTimeout: () {});
    }
    await closeAccount();
    await getIt.get<DeviceRepositories>().accounts.ensureActive(accountID);
    await openAccount(accountID);
    await startAccountServices();
  } finally {
    AccountScope.generation.value++;
    // Снимок остаётся поверх нового корня и гаснет сам (AccountSwitchSnapshot).
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
