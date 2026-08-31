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
import 'cubit.dart';
import 'di.dart';
import 'i18n/translations.g.dart';
import 'logger.dart';
import 'models.dart';
import 'repositories.dart';
import 'routers.dart';
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
  final logger = getIt.get<Logger>();

  final themes = ThemesMaterial();
  late final GoRouter goRouter;

  bool isBlur = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    goRouter = routers.material(navigatorGoRouterKey);
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
        api.setForeground(true);
        context.read<CommonCubit>().onAppResumed();
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        setState(() => isBlur = true);
        api.setForeground(false);
        context.read<CommonCubit>().onAppBackgrounded();
      case AppLifecycleState.detached:
        api.shutdown();
      case AppLifecycleState.inactive:
        setState(() => isBlur = true);
        context.read<CommonCubit>().onAppBackgrounded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommonCubit, CommonState>(
      builder: (context, state) {
        // На /auth (и подпутях) тема принудительно синяя — как в Cupertino.
        final ColorThemeModel colorTheme = state.isAuthRoute ? ColorThemeModel.blue : state.settingsDevice.colorTheme;

        ThemeMode themeMode = ThemeMode.system;
        if (state.settingsDevice.darkMode == DarkModeModel.alwaysOn) {
          themeMode = ThemeMode.dark;
        } else if (state.settingsDevice.darkMode == DarkModeModel.disabled) {
          themeMode = ThemeMode.light;
        }

        return MaterialApp.router(
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
              return ScreenLock(
                correctString: '0000',
                onValidate: (input) => context.read<CommonCubit>().verifyPasscode(input),
                onUnlocked: () => context.read<CommonCubit>().unlock(),
                useBlur: false,
                keyPadConfig: ThemesMaterial.screenLockKeyPad(context),
                config: ThemesMaterial.screenLockConfig(context),
                title: Text(context.t.common.biometricPleaseEnterPasscode),
                customizedButtonChild: state.settingsDevice.passcodeBiometric && state.isBiometricAvailable
                    ? const Icon(Icons.fingerprint, size: 48)
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
        );
      },
    );
  }
}
