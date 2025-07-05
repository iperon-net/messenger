import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'cubit/app_cubit.dart';
import 'cubit/constants.dart';
import 'di.dart';
import 'i18n/translations.g.dart';
import 'routers.dart';
import 'screens/contacts/contacts_cubit.dart';
import 'screens/settings/appearance_cubit.dart';
import 'screens/settings/language_cubit.dart';
import 'screens/settings/privacy_and_security_cubit.dart';
import 'screens/settings/settings_cubit.dart';
import 'secure_storage.dart';
import 'themes_material.dart';

// import 'themes/material_blue.dart' as material_blue;
// import 'themes/material_green.dart' as material_green;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureGlobalDI();
  final secureStorage = getIt.get<SecureStorage>();

  // Language
  final language = await secureStorage.getLanguage();
  if (language == AppLocale.ru) {
    LocaleSettings.setLocale(AppLocale.ru);
  } else if (language == AppLocale.en) {
    LocaleSettings.setLocale(AppLocale.en);
  } else {
    LocaleSettings.useDeviceLocale();
  }

  // darkMode
  final themeMode = await secureStorage.getThemeMode();

  // color shames
  final themeColor = await secureStorage.getThemeColor();

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
          providers: [
            BlocProvider<AppCubit>(
              create: (BuildContext context) => AppCubit(),
            ),
            BlocProvider<SettingsCubit>(
              create: (BuildContext context) => SettingsCubit(),
            ),
            BlocProvider<LanguageCubit>(
              create: (BuildContext context) => LanguageCubit(),
            ),
            BlocProvider<AppearanceCubit>(
              create: (BuildContext context) => AppearanceCubit(),
            ),
            BlocProvider<ContactsCubit>(
              create: (BuildContext context) => ContactsCubit(),
            ),
            BlocProvider<PrivacyAndSecurityCubit>(
              create: (BuildContext context) => PrivacyAndSecurityCubit(),
            ),
          ],
        child: Platform.isIOS ?
          IperonMessengerCupertino(globalThemeMode: themeMode, globalThemeColor: themeColor) :
          IperonMessengerMaterial(globalThemeMode: themeMode, globalThemeColor: themeColor),
      ),
    )
  );
}

// Material app
class IperonMessengerMaterial extends StatelessWidget {
  final ThemeMode globalThemeMode;
  final ThemeColor globalThemeColor;
  const IperonMessengerMaterial({super.key, required this.globalThemeMode, required this.globalThemeColor});

  @override
  Widget build(BuildContext context) {
    final routerConfig = getIt.get<Routers>().routerMaterial();
    ThemeMode themeMode = globalThemeMode;

    late ColorScheme colorSchemeLight;
    late ColorScheme colorSchemeDark;

    if (globalThemeColor == ThemeColor.blue){
      colorSchemeLight = MaterialTheme.blueLightScheme();
      colorSchemeDark = MaterialTheme.blueDarkScheme();
    } else if (globalThemeColor == ThemeColor.green) {
      colorSchemeLight = MaterialTheme.greenLightScheme();
      colorSchemeDark = MaterialTheme.greenDarkScheme();
    } else if (globalThemeColor == ThemeColor.purple) {
      colorSchemeLight = MaterialTheme.purpleLightScheme();
      colorSchemeDark = MaterialTheme.purpleDarkScheme();
    }

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {

        if (state.status == Status.success && state.darkMode == DarkMode.alwaysOn) {
          themeMode = ThemeMode.dark;
        } else if (state.status == Status.success && state.darkMode == DarkMode.disabled) {
          themeMode = ThemeMode.light;
        } else if (state.status == Status.success && state.darkMode == DarkMode.system) {
          themeMode = ThemeMode.system;
        }

        if (state.status == Status.success && state.themeColor == ThemeColor.blue) {
          colorSchemeLight = MaterialTheme.blueLightScheme();
          colorSchemeDark = MaterialTheme.blueDarkScheme();
        } else if (state.status == Status.success && state.themeColor == ThemeColor.green) {
          colorSchemeLight = MaterialTheme.greenLightScheme();
          colorSchemeDark = MaterialTheme.greenDarkScheme();
        } else if (state.status == Status.success && state.themeColor == ThemeColor.purple) {
          colorSchemeLight = MaterialTheme.purpleLightScheme();
          colorSchemeDark = MaterialTheme.purpleDarkScheme();
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(0.95)
          ),
          child: MaterialApp.router(
            key: key,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: AppLocaleUtils.supportedLocales,
            locale: TranslationProvider.of(context).flutterLocale,
            routerConfig: routerConfig,
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
            ),
            themeMode: themeMode,
          ),
        );
      },
    );
  }
}

// Cupertino app
class IperonMessengerCupertino extends StatelessWidget {
  final ThemeMode globalThemeMode;
  final ThemeColor globalThemeColor;
  const IperonMessengerCupertino({super.key, required this.globalThemeMode, required this.globalThemeColor});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = globalThemeMode;
    Brightness? brightness;
    final routerConfig = getIt.get<Routers>().routerCupertino();

    if (themeMode == ThemeMode.light){
      brightness = Brightness.light;
    } else if (themeMode == ThemeMode.dark) {
      brightness = Brightness.dark;
    }

    CupertinoDynamicColor colors = CupertinoColors.systemTeal;
    if (globalThemeColor == ThemeColor.blue) {
      colors = CupertinoColors.systemTeal;
    } else if (globalThemeColor == ThemeColor.green) {
      colors = CupertinoColors.activeGreen;
    } else if (globalThemeColor == ThemeColor.purple) {
      colors = CupertinoColors.systemPurple;
    }

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {

        if (state.status == Status.success && state.darkMode == DarkMode.alwaysOn) {
          brightness = Brightness.dark;
        } else if (state.status == Status.success && state.darkMode == DarkMode.disabled) {
          brightness = Brightness.light;
        } else if (state.status == Status.success && state.darkMode == DarkMode.system) {
          brightness = null;
        }


        if (state.status == Status.success && state.themeColor == ThemeColor.blue) {
          colors = CupertinoColors.activeBlue;
        } else if (state.status == Status.success && state.themeColor == ThemeColor.green) {
          colors = CupertinoColors.activeGreen;
        } else if (state.status == Status.success && state.themeColor == ThemeColor.purple) {
          colors = CupertinoColors.systemPurple;
        }

        return CupertinoApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocaleUtils.supportedLocales,
          locale: TranslationProvider.of(context).flutterLocale,
          routerConfig: routerConfig,
          theme: CupertinoThemeData(
            brightness: brightness,
            primaryColor: colors,
            scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
               color: CupertinoColors.systemGrey6,
               darkColor: CupertinoColors.black,
            ),
          ),

        );
      },
    );
  }
}
