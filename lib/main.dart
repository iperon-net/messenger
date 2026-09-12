import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_cupertino.dart';
import 'app_material.dart';
import 'calls.dart';
import 'cubit.dart';
import 'di.dart';
import 'push.dart';
import 'call_push.dart';
import 'firebase_options.dart';
import 'i18n/translations.g.dart';
import 'models.dart';
import 'repositories.dart';
import 'utils.dart';

// @pragma('vm:entry-point')
// Future<bool> helloWorldWorker(Map<String, dynamic>? input) async {
//   await registerCommonDependencies();
//   final logger = getIt.get<Logger>();
//   logger.debug('hello world! background worker fired at ${DateTime.now()}');
//   return true;
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Пакет cryptography_flutter подключён как зависимость намеренно: он
  // автоматически (через регистрацию плагина) подменяет pure-Dart реализации
  // AES-GCM/SHA-256/HKDF в package:cryptography на нативные (платформенные).
  // Расшифровка аватаров и медиа (CDNManager.download → FileEncryptor.decryptFile
  // + Sha256) — CPU-тяжёлая и раньше блокировала UI-изолят на медленных
  // Android-устройствах на несколько секунд; нативный бэкенд ускоряет её кратно.
  // Явный FlutterCryptography.enable() больше не нужен (deprecated) — плагин
  // включается сам.

  FlutterError.onError = (errorDetails) {
    if (kDebugMode) {
      FlutterError.presentError(errorDetails);
      return;
    }
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) return false;
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
    return true;
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

  // Registration tasks
  // await NativeWorkManager.initialize(debugMode: true);
  //
  // NativeWorkManager.registerDartWorker('helloWorld', helloWorldWorker);
  //
  // await NativeWorkManager.enqueue(
  //   taskId: 'hello-world-sync',
  //   trigger: TaskTrigger.oneTime(),
  //   constraints: const Constraints(requiresNetwork: true),
  //   worker: DartWorker(callbackId: 'helloWorld'),
  // );

  // Dependencies
  await registerCommonDependencies();

  final repositories = getIt.get<Repositories>();

  // Get all settings
  SettingsDeviceModel settingsDevice = await repositories.settingsDevice.getAll();

  final utils = getIt.get<Utils>();

  // locale
  if (settingsDevice.locale != null) {
    await utils.applyLocale(settingsDevice.locale ?? AppLocale.en);
  } else {
    AppLocale appLocale = await LocaleSettings.useDeviceLocale();
    await utils.applyLocale(appLocale);
    settingsDevice = settingsDevice.copyWith(locale: appLocale);
  }

  // Регистрируем push-токен устройства (Android FCM) для побудки входящих
  // звонков при закрытом стриме. Fire-and-forget и само-гейтится на авторизацию;
  // на iOS — no-op (там VoIP-токен приходит из нативного PushKit). См.
  // docs/plans/melodic-beaming-elephant.md.
  unawaited(getIt.get<PushManager>().syncFcmToken());

  // Мост call-пуш → нативный входящий (CallKit/ConnectionService) → Calls.
  getIt.get<CallPush>().start();

  // iOS: прогреваем нативную WebRTC-фабрику заранее, ДО первого звонка, чтобы на
  // cold-start по VoIP-push `CreateModularPeerConnectionFactory` не выполнялся на
  // главном потоке параллельно с поднятием ICE комнаты (гонка → EXC_BAD_ACCESS на
  // ICE-потоке, livekit #1186). Fire-and-forget, no-op вне iOS. См. Calls.warmUp.
  getIt.get<Calls>().warmUp();

  // Доступность биометрии узнаём ДО первого кадра и прокидываем в кубит, чтобы
  // экран блокировки на холодном старте эмитился синхронно (без await) — иначе
  // на миг мелькает основной экран, пока идёт асинхронная проверка биометрии.
  final isBiometricAvailable = await getIt.get<Utils>().isBiometricAvailable();

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: <BlocProvider>[BlocProvider<CommonCubit>(create: (_) => CommonCubit())],
        // child: Platform.isIOS ? const IperonMessengerCupertino() : const IperonMessengerCupertino(),
        child: Platform.isIOS
            ? IperonMessengerCupertino(settingsDevice: settingsDevice, isBiometricAvailable: isBiometricAvailable)
            : IperonMessengerMaterial(settingsDevice: settingsDevice, isBiometricAvailable: isBiometricAvailable),
      ),
    ),
  );
}
