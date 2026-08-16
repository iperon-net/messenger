import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import 'api.dart';
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
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

  // locale
  if (settingsDevice.locale != null) {
    LocaleSettings.setLocale(settingsDevice.locale ?? AppLocale.en);
  } else {
    AppLocale appLocale = await LocaleSettings.useDeviceLocale();
    LocaleSettings.setLocale(appLocale);
    settingsDevice = settingsDevice.copyWith(locale: appLocale);
  }

  //settingsDevice.locale

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: <BlocProvider>[BlocProvider<CommonCubit>(create: (_) => CommonCubit())],
        // child: Platform.isIOS ? const IperonMessengerCupertino() : const IperonMessengerCupertino(),
        child: IperonMessengerCupertino(settingsDevice: settingsDevice),
      ),
    ),
  );
}

class IperonMessengerCupertino extends StatefulWidget {
  final SettingsDeviceModel settingsDevice;

  const IperonMessengerCupertino({required this.settingsDevice, super.key});

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
    context.read<CommonCubit>().initialization(settingsDevice: widget.settingsDevice);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> localAuth(BuildContext context) async {
    final localAuth = LocalAuthentication();

    bool didAuthenticate = false;

    try {
      didAuthenticate = await localAuth.authenticate(localizedReason: context.t.settings.passcode.authenticateReason);
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
          colorSchemeSystem = ThemesCupertino().green;
        } else if (state.settingsDevice.colorTheme == ColorThemeModel.purple) {
          colorSchemeSystem = CupertinoColors.systemPurple;
        } else if (state.settingsDevice.colorTheme == ColorThemeModel.red) {
          colorSchemeSystem = CupertinoColors.destructiveRed;
        }

        Brightness? brightness;
        if (state.settingsDevice.darkMode == DarkModeModel.alwaysOn) {
          brightness = Brightness.dark;
        } else if (state.settingsDevice.darkMode == DarkModeModel.disabled) {
          brightness = Brightness.light;
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.95)),
          child: CupertinoApp.router(
            debugShowCheckedModeBanner: kDebugMode,
            routerConfig: goRouter,
            localizationsDelegates: GlobalCupertinoLocalizations.delegates,
            supportedLocales: AppLocaleUtils.supportedLocales,
            locale: TranslationProvider.of(context).flutterLocale,
            theme: CupertinoThemeData(brightness: brightness, primaryColor: colorSchemeSystem),
            builder: (context, child) {
              // На экранах авторизации (/auth и подпути) код-пароль не показываем:
              // пользователь ещё логинится, блокировать нечего.
              final location = goRouter.routerDelegate.currentConfiguration.uri.path;
              final isAuthRoute = location == "/auth" || location.startsWith("/auth/");

              if (!isAuthRoute && state.settingsDevice.passcode.isNotEmpty && state.isLocked) {
                return ScreenLock(
                  // correctString здесь лишь задаёт число вводимых цифр (digits),
                  // реальная проверка идёт через onValidate по сохранённому хешу.
                  correctString: '0000',
                  onValidate: (input) => context.read<CommonCubit>().verifyPasscode(input),
                  onUnlocked: () => context.read<CommonCubit>().unlock(),
                  useBlur: false,
                  config: ScreenLockConfig.defaultConfig.copyWith(backgroundColor: const Color(0xFF545454)),
                  title: Text(context.t.settings.passcode.pleaseEnterPasscode),
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
                          colorFilter: const ColorFilter.mode(CupertinoColors.inactiveGray, BlendMode.srcIn),
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
