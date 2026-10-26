import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'account_scope.dart';
import 'app_cupertino.dart';
import 'app_material.dart';
import 'crash_reports.dart';
import 'cubit.dart';
import 'desktop.dart';
import 'di.dart';
import 'logger_livekit.dart';
import 'firebase_options.dart';
import 'i18n/translations.g.dart';
import 'models.dart';
import 'platform.dart';
import 'repositories.dart';
import 'split_layout.dart';
import 'utils.dart';
import 'device_performance.dart';

// @pragma('vm:entry-point')
// Future<bool> helloWorldWorker(Map<String, dynamic>? input) async {
//   await registerCommonDependencies();
//   final logger = getIt.get<Logger>();
//   logger.debug('hello world! background worker fired at ${DateTime.now()}');
//   return true;
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Авторство анимированных эмодзи (CC BY 4.0) — в списке лицензий приложения.
  LicenseRegistry.addLicense(
    () => Stream.value(
      const LicenseEntryWithLineBreaks(
        ['Noto Animated Emoji'],
        'Animated emoji: Google Noto Emoji Animation (https://googlefonts.github.io/noto-emoji-animation/), '
        'licensed under CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/).',
      ),
    ),
  );

  // Пакет cryptography_flutter подключён как зависимость намеренно: он
  // автоматически (через регистрацию плагина) подменяет pure-Dart реализации
  // AES-GCM/SHA-256/HKDF в package:cryptography на нативные (платформенные).
  // Расшифровка аватаров и медиа (CDNManager.download → FileEncryptor.decryptFile
  // + Sha256) — CPU-тяжёлая и раньше блокировала UI-изолят на медленных
  // Android-устройствах на несколько секунд; нативный бэкенд ускоряет её кратно.
  // Явный FlutterCryptography.enable() больше не нужен (deprecated) — плагин
  // включается сам.

  // Firebase (Crashlytics, Remote Config, пуши) — только на мобильных; на
  // десктопе сбои собираем сами (CrashReports, docs/plans/desktop-client.md §3.1).
  if (AppPlatform.hasFirebase) {
    await _initFirebase();
  } else {
    _initCrashReports();
  }

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
  if (!AppPlatform.hasFirebase) await CrashReports.instance.attach(getIt.get<DeviceRepositories>().db);
  // Десктоп: уведомления, счётчик в Dock, «в сети» по присутствию за компьютером.
  unawaited(Desktop.start());
  // iPad — двухпанельные «Чаты» (до роутера: от этого зависят маршруты).
  await SplitLayout.detect();
  await SplitLayout.loadListWidth();

  // Подробные логи LiveKit (FINE) → talker: диагностика ICE/TURN звонков видна в
  // экране «Логи» и в экспорте логов (экран «Разработчик»).
  attachLiveKitLogging();

  // Класс производительности (упрощение анимаций на слабых и в энергосбережении).
  // Не ждём: до ответа натива — «мощное», как было.
  unawaited(DevicePerformance.instance.init());

  // Get all settings
  SettingsDeviceModel settingsDevice = await getIt.get<DeviceRepositories>().settingsDevice.getAll();

  final utils = getIt.get<Utils>();

  // locale
  if (settingsDevice.locale != null) {
    await utils.applyLocale(settingsDevice.locale ?? AppLocale.en);
  } else {
    AppLocale appLocale = await LocaleSettings.useDeviceLocale();
    await utils.applyLocale(appLocale);
    settingsDevice = settingsDevice.copyWith(locale: appLocale);
  }

  // Пуш-токены, мост call-пушей, спойлеры — для активного аккаунта; при
  // переключении аккаунта — заново (switchAccount).
  await startAccountServices();

  // Доступность биометрии узнаём ДО первого кадра и прокидываем в кубит, чтобы
  // экран блокировки на холодном старте эмитился синхронно (без await) — иначе
  // на миг мелькает основной экран, пока идёт асинхронная проверка биометрии.
  final isBiometricAvailable = await getIt.get<Utils>().isBiometricAvailable();

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: <BlocProvider>[BlocProvider<CommonCubit>(create: (_) => CommonCubit())],
        // child: Platform.isIOS ? const IperonMessengerCupertino() : const IperonMessengerCupertino(),
        // Корень приложения — на аккаунт: при переключении (AccountScope.generation)
        // собирается заново, кубиты и подписки — уже на новом аккаунте. Пока идёт
        // переключение — застывший снимок прежнего экрана; новый корень
        // собирается под ним, и снимок плавно гаснет, когда тот уже нарисован
        // (без чёрного кадра и мерцания).
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ValueListenableBuilder<bool>(
            valueListenable: accountSwitching,
            builder: (context, switching, _) => Stack(
              fit: StackFit.expand,
              children: [
                if (!switching)
                  RepaintBoundary(
                    key: accountRootKey,
                    child: ValueListenableBuilder<int>(
                      valueListenable: AccountScope.generation,
                      builder: (context, generation, _) => Platform.isIOS
                          ? IperonMessengerCupertino(
                              key: ValueKey(generation),
                              settingsDevice: settingsDevice,
                              isBiometricAvailable: isBiometricAvailable,
                            )
                          : IperonMessengerMaterial(
                              key: ValueKey(generation),
                              settingsDevice: settingsDevice,
                              isBiometricAvailable: isBiometricAvailable,
                            ),
                    ),
                  ),
                ValueListenableBuilder(
                  key: const ValueKey('accountSwitchSnapshot'),
                  valueListenable: accountSwitchSnapshot,
                  builder: (context, image, _) => image == null && !switching
                      ? const SizedBox.shrink()
                      : AccountSwitchSnapshot(key: ObjectKey(image), image: image, fading: !switching),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _initFirebase() async {
  FlutterError.onError = (errorDetails) {
    if (kDebugMode) {
      FlutterError.presentError(errorDetails);
      return;
    }
    // MissingPluginException на listen/cancel platform-stream — безобидная гонка
    // teardown, а не краш. Так, flutter_webrtc заводит EventChannel на каждый
    // PeerConnection (FlutterWebRTC/peerConnectionEvent<id>); при room.dispose()
    // натив снимает обработчик раньше, чем Dart успевает отменить подписку, и
    // `cancel` прилетает на уже несуществующий канал. Flutter SDK репортит это
    // через FlutterError.reportError — не даём ему стать ложным fatal.
    if (errorDetails.exception is MissingPluginException) {
      FirebaseCrashlytics.instance.recordError(
        errorDetails.exception,
        errorDetails.stack,
        reason: errorDetails.context?.toString(),
        fatal: false,
      );
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
}

/// Сбор сбоев без Crashlytics (десктоп): то же разделение, что в [_initFirebase]
/// — в debug только в консоль, в release в [CrashReports].
void _initCrashReports() {
  FlutterError.onError = (errorDetails) {
    if (kDebugMode) {
      FlutterError.presentError(errorDetails);
      return;
    }
    CrashReports.instance.record(
      errorDetails.exception,
      errorDetails.stack,
      reason: errorDetails.context?.toString(),
      // Гонка teardown platform-stream — не краш (см. _initFirebase).
      fatal: errorDetails.exception is! MissingPluginException,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) return false;
    CrashReports.instance.record(error, stack);
    return true;
  };
}
