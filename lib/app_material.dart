import 'dart:async';

import 'package:hugeicons/hugeicons.dart';
import 'package:material_ui/material_ui.dart';
// CupertinoActivityIndicator из cupertino_ui (внутри ConnectionTitle) требует
// локализацию именно cupertino_ui-типа, поэтому берём делегат оттуда — точечным
// show, чтобы не тянуть конфликтующие с material_ui символы.
import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter/foundation.dart';
// GlobalMaterialLocalizations уже приходит из material_ui — прячем дубликат.
// GlobalCupertinoLocalizations берём из cupertino_ui — тоже прячем flutter-версию.
import 'package:flutter_localizations/flutter_localizations.dart' hide GlobalMaterialLocalizations, GlobalCupertinoLocalizations;
// Настоящие Flutter-овские Material/Cupertino Localizations. material_ui и
// cupertino_ui поставляют только СВОИ типы, а Flutter-виджеты из сторонних
// пакетов (pin_code_fields → Adaptive/Cupertino/Material тулбар выделения)
// требуют flutter-версии, иначе бросают «No CupertinoLocalizations found».
// Тянем делегаты под префиксом, чтобы не конфликтовать с *_ui.
import 'package:flutter_localizations/flutter_localizations.dart'
    as flutter_l10n
    show GlobalMaterialLocalizations, GlobalCupertinoLocalizations;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import 'api.dart';
import 'calls.dart';
import 'cubit.dart';
import 'di.dart';
import 'push.dart';
import 'i18n/translations.g.dart';
import 'logger.dart';
import 'models.dart';
import 'repositories.dart';
import 'routers.dart';
import 'screens/call/call_material.dart';
import 'themes.dart';
import 'components.dart';

// Material-корень приложения (Android). Вынесен из main.dart в отдельный файл,
// потому что импортирует material_ui, а Cupertino-корень — cupertino_ui: держать
// оба UI-пакета в одном файле нельзя (конфликт одноимённых символов).
class IperonMessengerMaterial extends StatefulWidget {
  final SettingsDeviceModel settingsDevice;
  final bool isBiometricAvailable;

  const IperonMessengerMaterial({required this.settingsDevice, required this.isBiometricAvailable, super.key});

  @override
  State<IperonMessengerMaterial> createState() => _IperonMessengerMaterial();
}

class _IperonMessengerMaterial extends State<IperonMessengerMaterial> with WidgetsBindingObserver {
  final navigatorGoRouterKey = GlobalKey<NavigatorState>();

  final routers = getIt.get<Routers>();
  final repositories = getIt.get<Repositories>();
  final api = getIt.get<API>();
  final calls = getIt.get<Calls>();
  final logger = getIt.get<Logger>();

  final themes = ThemesMaterial();
  late final GoRouter goRouter;

  bool isBlur = false;

  // Снимок звонка для passcode-гейта: при блокировке экран `/call` из роутера не
  // рисуется (builder возвращает ScreenLock ВМЕСТО child — весь навигатор уходит
  // из дерева), поэтому активный звонок надо детектить здесь напрямую по
  // синглтону Calls и рисовать поверх локера отдельным экраном. Разговор при
  // этом жив всегда (LiveKit-комната живёт в синглтоне, не в дереве виджетов).
  CallSnapshot _callSnapshot = const CallSnapshot();
  StreamSubscription<CallSnapshot>? _callSub;

  // Активен ли звонок в смысле «показываем свой экран»: исходящий/соединение/
  // разговор. `incoming` ведёт системная звонилка (ConnectionService) — свой
  // экран не наш; `idle`/`ended` — звонка нет. Зеркалит CallGate._isActive.
  bool get _isCallActive => switch (_callSnapshot.status) {
    CallStatus.idle || CallStatus.ended || CallStatus.incoming => false,
    _ => true,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    goRouter = routers.material(navigatorGoRouterKey);
    goRouter.routerDelegate.addListener(_onRouteChanged);
    context.read<CommonCubit>().initialization(settingsDevice: widget.settingsDevice, isBiometricAvailable: widget.isBiometricAvailable);
    _onRouteChanged();
    // Следим за звонком, чтобы поднимать/убирать экран звонка поверх локера.
    _callSnapshot = calls.snapshot;
    _callSub = calls.snapshots.listen((s) {
      if (mounted) setState(() => _callSnapshot = s);
    });
  }

  void _onRouteChanged() {
    final location = goRouter.routerDelegate.currentConfiguration.uri.path;
    final isAuthRoute = location == "/auth" || location.startsWith("/auth/");
    context.read<CommonCubit>().setIsAuthRoute(isAuthRoute: isAuthRoute);
  }

  @override
  void dispose() {
    _callSub?.cancel();
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
        api.setForeground(true);
        // Push-токен мог смениться, пока приложение было в фоне/выгружено.
        unawaited(getIt.get<PushManager>().syncTokens());
        context.read<CommonCubit>().onAppResumed();
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        setState(() => isBlur = true);
        // Досбрасываем файловый лог перед возможным убийством процесса из фона.
        unawaited(logger.fileLogger.flush());
        api.setForeground(false);
        context.read<CommonCubit>().onAppBackgrounded();
      case AppLifecycleState.detached:
        // На Android движок кэшируется на весь процесс, а Activity пересоздаётся
        // (например, после звонка через flutter_callkit_incoming) — тогда прилетает
        // detached, хотя процесс жив. Раньше здесь звали api.shutdown(), который
        // навсегда сбрасывал _authorized и закрывал broadcast incoming: после звонка
        // стрим больше не поднимался («Подключение», send() dropped authorized=false).
        // Трактуем detached как уход в фон — пауза; на resumed стрим переоткроется.
        unawaited(logger.fileLogger.flush());
        api.setForeground(false);
      case AppLifecycleState.inactive:
        setState(() => isBlur = true);
        context.read<CommonCubit>().onAppBackgrounded();
    }
  }

  // Пользователь свернул экран звонка к чатам из-под passcode-лока
  // (CommonCubit.dismissCallOverlay). Навигатора в дереве ещё нет (рисуется
  // ScreenLock), но goRouter — контроллер, его состояние можно менять и вне
  // дерева: переводим на /chats (сбрасывая push `/call`), а calls-флаг не даёт
  // CallGate заново авто-открыть `/call` после ввода кода — останется плашка.
  void _onCallOverlayDismissed() {
    calls.markMinimizeRequest();
    goRouter.go('/chats');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommonCubit, CommonState>(
      listenWhen: (previous, current) => !previous.callOverlayDismissed && current.callOverlayDismissed,
      listener: (context, state) => _onCallOverlayDismissed(),
      builder: (context, state) {
        // На /auth (и подпутях) тема принудительно синяя — как в Cupertino.
        final ColorThemeModel colorTheme = state.isAuthRoute ? ColorThemeModel.blue : state.settingsDevice.colorTheme;

        ThemeMode themeMode = ThemeMode.system;
        if (state.settingsDevice.darkMode == DarkModeModel.alwaysOn) {
          themeMode = ThemeMode.dark;
        } else if (state.settingsDevice.darkMode == DarkModeModel.disabled) {
          themeMode = ThemeMode.light;
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(0.95)),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: kDebugMode,
            routerConfig: goRouter,
            localizationsDelegates: const <LocalizationsDelegate<Object>>[
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              // Flutter-овские Material/Cupertino Localizations (см. импорт выше) —
              // нужны Flutter-виджетам (тулбар выделения текста в pin_code_fields).
              flutter_l10n.GlobalMaterialLocalizations.delegate,
              flutter_l10n.GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocaleUtils.supportedLocales,
            locale: TranslationProvider.of(context).flutterLocale,
            theme: themes.theme(colorTheme: colorTheme, brightness: Brightness.light),
            darkTheme: themes.theme(colorTheme: colorTheme, brightness: Brightness.dark),
            themeMode: themeMode,
            builder: (context, child) {
              if (!state.isAuthRoute && state.settingsDevice.passcode.isNotEmpty && state.isLocked) {
                // Обход passcode ТОЛЬКО для активного звонка: рисуем экран звонка
                // поверх (вместо ScreenLock), остальное приложение остаётся под
                // кодом. ScreenLock при этом НЕ монтируем, иначе его onOpened
                // спровоцировал бы биометрию за спиной звонка. Когда звонок
                // завершится, подписка на calls.snapshots перерисует билд и вернёт
                // ScreenLock. Экран автономен (всё берёт из синглтона Calls).
                // callOverlayDismissed — пользователь свернул экран звонка к
                // чатам (кнопка на CallView): перестаём рисовать его в обход
                // локера, показываем ScreenLock (навигацию на /chats выполняет
                // слушатель ниже). См. CommonCubit.dismissCallOverlay.
                if (_isCallActive && !state.callOverlayDismissed) {
                  return BlocProvider<CallCubit>(create: (_) => CallCubit()..initialization(), child: const CallMaterial());
                }
                return ScreenLock(
                  correctString: '0000',
                  onValidate: (input) => context.read<CommonCubit>().verifyPasscode(input),
                  onUnlocked: () => context.read<CommonCubit>().unlock(),
                  useBlur: false,
                  keyPadConfig: ThemesMaterial.screenLockKeyPad(context),
                  config: ThemesMaterial.screenLockConfig(context),
                  title: Text(context.t.common.biometricPleaseEnterPasscode),
                  customizedButtonChild: state.settingsDevice.passcodeBiometric && state.isBiometricAvailable
                      ? const HugeIcon(icon: HugeIcons.strokeRoundedFingerAccess, size: 48.0)
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
                  blurColor: Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.white54,
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
