import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
// GlobalCupertinoLocalizations уже приходит из cupertino_ui — прячем дубликат.
import 'package:flutter_localizations/flutter_localizations.dart' hide GlobalCupertinoLocalizations;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import 'api.dart';
import 'app_material.dart';
import 'cubit.dart';
import 'di.dart';
import 'firebase_options.dart';
import 'i18n/translations.g.dart';
import 'logger.dart';
import 'models.dart';
import 'repositories.dart';
import 'routers.dart';
import 'themes.dart';
import 'components.dart';
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

  FlutterError.onError = (errorDetails) {
    if (kDebugMode) {
      FlutterError.presentError(errorDetails);
      return;
    }
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) return false;
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
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

class IperonMessengerCupertino extends StatefulWidget {
  final SettingsDeviceModel settingsDevice;
  final bool isBiometricAvailable;

  const IperonMessengerCupertino({required this.settingsDevice, required this.isBiometricAvailable, super.key});

  @override
  State<IperonMessengerCupertino> createState() => _IperonMessengerCupertino();
}

class _IperonMessengerCupertino extends State<IperonMessengerCupertino> with WidgetsBindingObserver {
  final navigatorGoRouterKey = GlobalKey<NavigatorState>();

  final routers = getIt.get<Routers>();
  final repositories = getIt.get<Repositories>();
  final api = getIt.get<API>();
  final logger = getIt.get<Logger>();

  final themes = ThemesCupertino();
  late final GoRouter goRouter;

  bool isBlur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    goRouter = routers.cupertino(navigatorGoRouterKey);
    // Смена маршрута не меняет CommonState сама по себе (переход на /auth роутер
    // делает через Auth.refresh → redirect). Поэтому слушаем роутер и прокидываем
    // признак «мы на /auth» в кубит, чтобы тема и код-пароль реагировали.
    goRouter.routerDelegate.addListener(_onRouteChanged);
    context.read<CommonCubit>().initialization(settingsDevice: widget.settingsDevice, isBiometricAvailable: widget.isBiometricAvailable);
    _onRouteChanged();
  }

  void _onRouteChanged() {
    final location = goRouter.routerDelegate.currentConfiguration.uri.path;
    final isAuthRoute = location == "/auth" || location.startsWith("/auth/");
    context.read<CommonCubit>().setIsAuthRoute(isAuthRoute: isAuthRoute);
  }

  @override
  void dispose() {
    goRouter.routerDelegate.removeListener(_onRouteChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> localAuth(BuildContext context) async {
    final localAuth = LocalAuthentication();

    bool didAuthenticate = false;

    try {
      didAuthenticate = await localAuth.authenticate(localizedReason: context.t.common.biometricAuthenticateReason);
    } on LocalAuthException catch (e, stack) {
      if (e.code == LocalAuthExceptionCode.userCanceled) {
        logger.warning("passcode biometric user canceled");
        return;
      }

      // При любой ошибке биометрии просто не разблокируем — остаётся код-пароль.
      logger.handle(e, stack);
      return;
    }

    if (context.mounted && didAuthenticate) {
      context.read<CommonCubit>().unlock();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.debug(state.toString());

    switch (state) {
      case AppLifecycleState.resumed:
        setState(() => isBlur = false);

        // Приложение снова на переднем плане — стрим поднимется через координатор.
        api.setForeground(true);
        // Проверяем, не пора ли заблокировать экран по таймауту авто-блокировки.
        context.read<CommonCubit>().onAppResumed();
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        setState(() => isBlur = true);

        // Ушли в фон — стрим встанет на паузу (с грейс-периодом).
        api.setForeground(false);
        // Засекаем время ухода в фон для авто-блокировки.
        context.read<CommonCubit>().onAppBackgrounded();
      case AppLifecycleState.detached:
        // Приложение завершается — полностью закрываем стрим.
        api.shutdown();
      case AppLifecycleState.inactive:
        // Транзиентное состояние (шторка, app switcher, звонок) — соединение не
        // трогаем, чтобы не дёргать его на каждый чих. Но время ухода в фон
        // фиксируем: на iOS `inactive` доставляется надёжно, а `hidden`/`paused`
        // могут прийти уже после заморозки изолята — иначе авто-блокировка по
        // таймауту не сработает при возврате в рамках живого процесса.
        setState(() => isBlur = true);
        context.read<CommonCubit>().onAppBackgrounded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonCubit, CommonState>(
      builder: (context, state) {
        CupertinoDynamicColor colorSchemeSystem = themes.blueScheme;

        if (state.settingsDevice.colorTheme == ColorThemeModel.green) {
          colorSchemeSystem = themes.green;
        } else if (state.settingsDevice.colorTheme == ColorThemeModel.purple) {
          colorSchemeSystem = CupertinoColors.systemPurple;
        } else if (state.settingsDevice.colorTheme == ColorThemeModel.orange) {
          colorSchemeSystem = themes.orange;
        }

        Brightness? brightness;
        if (state.settingsDevice.darkMode == DarkModeModel.alwaysOn) {
          brightness = Brightness.dark;
        } else if (state.settingsDevice.darkMode == DarkModeModel.disabled) {
          brightness = Brightness.light;
        }

        // На /auth (и подпутях) тема принудительно синяя. Признак приходит из
        // кубита — его обновляет слушатель роутера (_onRouteChanged).
        if (state.isAuthRoute) {
          colorSchemeSystem = themes.blueScheme;
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.95)),
          child: CupertinoApp.router(
            debugShowCheckedModeBanner: kDebugMode,
            routerConfig: goRouter,
            localizationsDelegates: const <LocalizationsDelegate<Object>>[
              // Некоторые Material-виджеты (напр. flutter_screen_lock) требуют
              // MaterialLocalizations, которых нет в GlobalCupertinoLocalizations.delegates.
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocaleUtils.supportedLocales,
            locale: TranslationProvider.of(context).flutterLocale,
            theme: CupertinoThemeData(
              brightness: brightness,
              primaryColor: colorSchemeSystem,
              scaffoldBackgroundColor: const CupertinoDynamicColor.withBrightness(color: Color(0xffffffff), darkColor: Color(0xff1b263b)),
            ),
            builder: (context, child) {
              // На экранах авторизации (/auth и подпути) код-пароль не показываем:
              // пользователь ещё логинится, блокировать нечего.
              if (!state.isAuthRoute && state.settingsDevice.passcode.isNotEmpty && state.isLocked) {
                return ScreenLock(
                  // correctString здесь лишь задаёт число вводимых цифр (digits),
                  // реальная проверка идёт через onValidate по сохранённому хешу.
                  correctString: '0000',
                  onValidate: (input) => context.read<CommonCubit>().verifyPasscode(input),
                  onUnlocked: () => context.read<CommonCubit>().unlock(),
                  useBlur: false,
                  keyPadConfig: ThemesCupertino.screenLockKeyPad(context),
                  config: ThemesCupertino.screenLockConfig(context),
                  title: Text(context.t.common.biometricPleaseEnterPasscode),
                  customizedButtonChild: state.settingsDevice.passcodeBiometric && state.isBiometricAvailable
                      ? SvgPicture.string(
                          utf8.decode(
                            base64.decode(
                              "PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm"
                              "9uZSIgc3Ryb2tlPSJjdXJyZW50Q29sb3IiIHN0cm9rZS13aWR0aD0iMS41IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0"
                              "icm91bmQiPgogIDxwYXRoIGQ9Ik00IDdWNWExIDEgMCAwIDEgMS0xaDIiLz4KICA8cGF0aCBkPSJNMTcgNGgyYTEgMSAwIDAgMSAxIDF2MiIvPgog"
                              "IDxwYXRoIGQ9Ik0yMCAxN3YyYTEgMSAwIDAgMS0xIDFoLTIiLz4KICA8cGF0aCBkPSJNNyAyMEg1YTEgMSAwIDAgMS0xLTF2LTIiLz4KICA8cGF0a"
                              "CBkPSJNOSA5djEiLz4KICA8cGF0aCBkPSJNMTUgOXYxIi8+CiAgPHBhdGggZD0iTTkuNSAxNWMuNi42IDEuNSAxIDIuNSAxczEuOS0uNCAyLjUtMS"
                              "IvPgogIDxwYXRoIGQ9Ik0xMiA4djRoLTEiLz4KPC9zdmc+Cg==",
                            ),
                          ),
                          width: 48,
                          height: 48,
                          // Тот же цвет, что и у цифр клавиатуры: ScreenLock
                          // рендерит их белыми (ScreenLockConfig.defaultConfig →
                          // buttonStyle.foregroundColor = 0xFFFFFFFF).
                          colorFilter: ColorFilter.mode(ThemesCupertino.screenLockBiometricIcon(context), BlendMode.srcIn),
                        )
                      : null,
                  customizedButtonTap: () async =>
                      state.settingsDevice.passcodeBiometric && state.isBiometricAvailable ? await localAuth(context) : null,
                  onOpened: () async => state.settingsDevice.passcodeBiometric && state.isBiometricAvailable && state.autoBiometrics
                      ? await localAuth(context)
                      : null,
                );
              }

              if (state.settingsDevice.isBlurOnInactive && isBlur) {
                return Blur(
                  blur: 5,
                  blurColor: CupertinoTheme.brightnessOf(context) == Brightness.dark
                      ? CupertinoColors.darkBackgroundGray
                      : CupertinoColors.inactiveGray,
                  child: child ?? const SizedBox.shrink(),
                );
              }

              return child ?? const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
