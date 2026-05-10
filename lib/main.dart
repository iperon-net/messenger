import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'api.dart';
import 'cubit/main_cubit.dart';
import 'di.dart';
import 'i18n/translations.g.dart';
import 'logger.dart';
import 'repositories/repositories.dart';
import 'routers.dart';
import 'screens/auth/auth_callpassword_cubit.dart';
import 'screens/auth/auth_cubit.dart';
import 'screens/home/home_cubit.dart';
import 'services/services.dart';
import 'themes_cupertino.dart';
import 'themes_material.dart';
import 'models/models.dart' as models;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependencies
  await registerCommonDependencies();

  //
  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  // Get all settings
  final settingsDevice = await repositories.settingsDevice.getAll();

  // Get active user
  final user = await repositories.users.getActive();

  // Language
  if (settingsDevice.language == "ru") {
    LocaleSettings.setLocale(AppLocale.ru);
  } else if (settingsDevice.language == "en") {
    LocaleSettings.setLocale(AppLocale.en);
  } else {
    AppLocale appLocale = await LocaleSettings.useDeviceLocale();
    LocaleSettings.setLocale(appLocale);
  }

  logger.info('startup application');

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: <BlocProvider>[
          BlocProvider<MainCubit>(
            create: (_) => MainCubit(),
          ),
          BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
          ),
          BlocProvider<AuthCallpasswordCubit>(
            create: (_) => AuthCallpasswordCubit(),
          ),
          BlocProvider<HomeCubit>(
            create: (_) => HomeCubit(),
          ),
        ],
        child: Platform.isIOS ? const IperonMessengerCupertino() : IperonMessengerMaterial(settingsDevice: settingsDevice, user: user),
      ),
    ),
  );
}

// Material app
class IperonMessengerMaterial extends StatefulWidget {
  final models.SettingsDevice settingsDevice;
  final models.User user;

  const IperonMessengerMaterial({
    required this.settingsDevice,
    required this.user,
    super.key,
  });

  @override
  State<IperonMessengerMaterial> createState() => _IperonMessengerMaterial();
}

// Cupertino app
class IperonMessengerCupertino extends StatefulWidget {
  const IperonMessengerCupertino({super.key});

  @override
  State<IperonMessengerCupertino> createState() => _IperonMessengerCupertino();
}

// Material
class _IperonMessengerMaterial extends State<IperonMessengerMaterial> with WidgetsBindingObserver {
  final logger = getIt.get<Logger>();
  final routers = getIt.get<Routers>();

  final navigatorGoRouterKey = GlobalKey<NavigatorState>();
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    context.read<MainCubit>().initialization(
      settingsDevice: widget.settingsDevice,
      user: widget.user,
    );

    LocaleSettings.getLocaleStream().listen((event) {
      logger.debug(event);
    });

    _router = routers.material(navigatorGoRouterKey);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorSchemeLight = ThemesMaterial().blueLightScheme;
    final colorSchemeDark = ThemesMaterial().blueDarkScheme;

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(0.95)
          ),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: AppLocaleUtils.supportedLocales,
            locale: TranslationProvider
                .of(context)
                .flutterLocale,
            routerConfig: _router,
            theme: ThemeData(
              colorScheme: colorSchemeLight,
              brightness: colorSchemeLight.brightness,
              appBarTheme: AppBarTheme(
                backgroundColor: colorSchemeLight.primary,
                foregroundColor: colorSchemeLight.surface,
              ),
              scaffoldBackgroundColor: colorSchemeLight.surfaceDim,
              listTileTheme: ListTileThemeData(
                iconColor: colorSchemeLight.primary,
              ),
              radioTheme: RadioThemeData(
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: colorSchemeLight.primary,
                  disabledForegroundColor: Colors.white,
                  disabledBackgroundColor: colorSchemeLight.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              snackBarTheme: SnackBarThemeData(
                backgroundColor: colorSchemeLight.error,
                actionTextColor: colorSchemeLight.onError,
                contentTextStyle: TextStyle(color: colorSchemeLight.onError),
              ),
              inputDecorationTheme: InputDecorationTheme(
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 11, color: colorSchemeLight.primary),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: colorSchemeLight.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: colorSchemeLight.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: colorSchemeLight.primary),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                labelStyle: TextStyle(
                  color: colorSchemeLight.primary,
                ),
                // isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: colorSchemeDark,
              brightness: colorSchemeDark.brightness,
              appBarTheme: AppBarTheme(
                backgroundColor: colorSchemeDark.onSecondary,
                foregroundColor: colorSchemeDark.onSurface,
              ),
              drawerTheme: DrawerThemeData(
                backgroundColor: colorSchemeDark.surfaceContainer,
              ),
              scaffoldBackgroundColor: colorSchemeDark.surfaceContainer,
              radioTheme: RadioThemeData(
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                ),
              ),
              cardColor: colorSchemeDark.surfaceDim,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: colorSchemeLight.primary,
                  disabledForegroundColor: Colors.white,
                  disabledBackgroundColor: colorSchemeLight.primary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              snackBarTheme: SnackBarThemeData(
                backgroundColor: colorSchemeDark.error,
                actionTextColor: colorSchemeDark.onError,
                contentTextStyle: TextStyle(color: colorSchemeDark.onError),
              ),
              inputDecorationTheme: InputDecorationTheme(
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: colorSchemeDark.primary),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: colorSchemeDark.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: colorSchemeDark.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(width: 1, color: colorSchemeDark.primary),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                labelStyle: TextStyle(
                  color: colorSchemeDark.primary,
                ),
                // isDense: true,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
        );
      },
    );
  }

}


// Cupertino
class _IperonMessengerCupertino extends State<IperonMessengerCupertino> with WidgetsBindingObserver {
  final logger = getIt.get<Logger>();
  final routers = getIt.get<Routers>();

  final navigatorGoRouterKey = GlobalKey<NavigatorState>();
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = routers.cupertino(navigatorGoRouterKey);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorSchemeSystem = ThemesCupertino().blueScheme;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(0.95)
      ),
      child: CupertinoApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocaleUtils.supportedLocales,
        locale: TranslationProvider
            .of(context)
            .flutterLocale,

        theme: CupertinoThemeData(
          primaryColor: colorSchemeSystem,
          scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
            color: Colors.grey,
            darkColor: Color(0xff1b263b),
          ),
        ),
      ),
    );
  }

}

