import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'cubit/cubit.dart';
import 'di.dart';
import 'firebase_options.dart';
import 'i18n/translations.g.dart';
import 'logger.dart';
import 'routers.dart';

import './screens/screens.dart';
import 'themes_material.dart';
import 'themes_cupertino.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Dependencies
  await configureCommonDependencies();

  final logger = getIt.get<Logger>();

  // Language
  AppLocale appLocale = await LocaleSettings.useDeviceLocale();
  logger.debug(appLocale);

  LocaleSettings.setLocale(AppLocale.ru);

  logger.info('Startup application');

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
        providers: <BlocProvider>[
          BlocProvider<MainCubit>(
            create: (BuildContext context) => MainCubit(),
          ),
          BlocProvider<AuthOnPremiseCubit>(
            create: (BuildContext context) => AuthOnPremiseCubit(),
          ),
        ],
        child: const IperonApp(),
      ),
    ),
  );
}

class IperonApp extends StatefulWidget {
  const IperonApp({super.key});

  @override
  State<IperonApp> createState() => _IperonApp();
}

class _IperonApp extends State<IperonApp> with WidgetsBindingObserver {
  final logger = getIt.get<Logger>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    logger.debug("lifecycle state=${state.name}");
  }

  @override
  Widget build(BuildContext context) => Theme.of(context).platform == TargetPlatform.android ? material(context): cupertino(context);

  // Material
  Widget material(BuildContext context) {
    final routers = getIt.get<Routers>();

    final colorSchemeLight = ThemesMaterial().blueLightScheme;
    final colorSchemeDark = ThemesMaterial().blueDarkScheme;

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routers.config,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: AppLocaleUtils.supportedLocales,
        locale: TranslationProvider.of(context).flutterLocale,
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
          inputDecorationTheme: InputDecorationTheme(
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(width: 1, color: colorSchemeLight.primary),
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

  }

  // Cupertino
  Widget cupertino(BuildContext context) {
    final routers = getIt.get<Routers>();

    final colorSchemeSystem = ThemesCupertino().blueScheme;

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) => CupertinoApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routers.config,
        localizationsDelegates: [
          ...GlobalMaterialLocalizations.delegates,
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocaleUtils.supportedLocales,
        locale: TranslationProvider.of(context).flutterLocale,
        theme: CupertinoThemeData(
          // brightness: Brightness.light
          primaryColor: colorSchemeSystem,
          scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.systemGrey6,
            darkColor: CupertinoColors.black,
          ),
        ),
      ),
    );
  }

}
