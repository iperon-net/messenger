import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
// GlobalCupertinoLocalizations уже приходит из cupertino_ui — прячем дубликат.
import 'package:flutter_localizations/flutter_localizations.dart' hide GlobalCupertinoLocalizations;
// Настоящий Flutter-овский CupertinoLocalizations. cupertino_ui поставляет
// только СВОЙ тип CupertinoLocalizations, а Flutter-виджеты из сторонних
// пакетов (pin_code_fields → CupertinoTextSelectionToolbarButton) требуют
// именно flutter/cupertino-версию, иначе бросают «No CupertinoLocalizations
// found». Тянем делегат под префиксом, чтобы не конфликтовать с cupertino_ui.
import 'package:flutter_localizations/flutter_localizations.dart' as flutter_l10n show GlobalCupertinoLocalizations;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:local_auth/local_auth.dart';

import 'api.dart';
import 'cubit.dart';
import 'di.dart';
import 'i18n/translations.g.dart';
import 'logger.dart';
import 'models.dart';
import 'repositories.dart';
import 'routers.dart';
import 'themes.dart';
import 'components.dart';

// Cupertino-корень приложения (iOS). Вынесен из main.dart в отдельный файл,
// потому что импортирует cupertino_ui, а Material-корень — material_ui: держать
// оба UI-пакета в одном файле нельзя (конфликт одноимённых символов).
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
    // info (не debug): переходы жизненного цикла нужны в файловом логе для отладки
    // залипания стрима после звонков (файловый логгер пишет от info и выше).
    logger.info('lifecycle: $state');

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

        // Досбрасываем файловый лог: при убийстве процесса из фона хвост буфера
        // иначе теряется — а это как раз момент диагностики звонков.
        unawaited(logger.fileLogger.flush());
        // Ушли в фон — стрим встанет на паузу (с грейс-периодом).
        api.setForeground(false);
        // Засекаем время ухода в фон для авто-блокировки.
        context.read<CommonCubit>().onAppBackgrounded();
      case AppLifecycleState.detached:
        // detached трактуем как уход в фон (пауза), а не завершение процесса:
        // api.shutdown() навсегда сбрасывал _authorized и закрывал broadcast
        // incoming, из-за чего после звонка/пересоздания хоста стрим больше не
        // поднимался («Подключение», send() dropped authorized=false). На resumed
        // стрим переоткроется. См. app_material.dart.
        unawaited(logger.fileLogger.flush());
        api.setForeground(false);
      case AppLifecycleState.inactive:
        // `inactive` на iOS прилетает на ТРАНЗИЕНТНЫЕ помехи (шторка, переключатель
        // приложений, баннер CallKit/обычный сотовый звонок), а не только на уход в
        // фон. Стрим на нём НЕ трогаем: `setForeground(false)` здесь оставлял бы
        // свёрнутую сессию «online» риском залипания? — нет: см. ниже. Раньше тут
        // пробовали и `false` (чтобы presence в фоне ушёл в офлайн для call-пуша), и
        // `true` (чтобы поднять стрим после CallKit, когда `resumed` не пришёл) —
        // оба варианта конфликтуют между собой (presence vs resume). Сейчас входящие
        // в фоне гарантирует сервер (call-push уходит ВСЕГДА, независимо от presence
        // — см. push.go), поэтому здесь foreground НЕ трогаем: реальный уход в фон
        // ловим на `paused`/`hidden`/`detached`, возврат — на `resumed`. Блюр и
        // авто-блокировку по `inactive` оставляем — безвредны и нужны для превью в
        // переключателе.
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
              // Flutter-овский CupertinoLocalizations (см. импорт выше) — нужен
              // Flutter-виджетам (тулбар выделения текста в pin_code_fields).
              flutter_l10n.GlobalCupertinoLocalizations.delegate,
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
                      ? HugeIcon(
                          icon: HugeIcons.strokeRoundedFingerAccess,
                          size: 48,
                          color: ThemesCupertino.screenLockBiometricIcon(context),
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
