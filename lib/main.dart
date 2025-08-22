import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/screens/home/home_cubit.dart';

import 'cubit/app_cubit.dart';
import 'cubit/constants.dart';
import 'di.dart';
import 'i18n/translations.g.dart';
import 'models/models.dart' as models;
import 'routers.dart';
import 'screens/contacts/contacts_cubit.dart';
import 'screens/lock/lock_cubit.dart';
import 'screens/settings/appearance_cubit.dart';
import 'screens/settings/language_cubit.dart';
import 'screens/settings/passcode_cubit.dart';
import 'screens/settings/privacy_and_security_cubit.dart';
import 'screens/settings/settings_cubit.dart';
import 'themes_material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureGlobalDI();

  final repositories = getIt.get<Repositories>();

  final getAllSettings = await repositories.settingsDevice.getAllSettings();

  // Language
  if(getAllSettings.language.isEmpty) {
    LocaleSettings.useDeviceLocale();
  } else if (getAllSettings.language.isNotEmpty && getAllSettings.language == "ru") {
    LocaleSettings.setLocale(AppLocale.ru);
  } else if (getAllSettings.language.isNotEmpty && getAllSettings.language == "en") {
    LocaleSettings.setLocale(AppLocale.en);
  }

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
          providers: [
            BlocProvider<AppCubit>(
              create: (BuildContext context) => AppCubit(),
            ),
            BlocProvider<HomeCubit>(
              create: (BuildContext context) => HomeCubit(),
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
            BlocProvider<PasscodeCubit>(
              create: (BuildContext context) => PasscodeCubit(),
            ),
            BlocProvider<LockCubit>(
              create: (BuildContext context) => LockCubit(),
            ),
          ],
          // child: IperonMessengerMaterial(globalThemeMode: getAllSettings.darkMode, globalThemeColor: getAllSettings.themeColor),
          child: Platform.isIOS ?
            IperonMessengerCupertino(globalThemeMode: getAllSettings.darkMode, globalThemeColor: getAllSettings.themeColor) :
            IperonMessengerMaterial(globalThemeMode: getAllSettings.darkMode, globalThemeColor: getAllSettings.themeColor),
      ),
    )
  );
}

// Material app
class IperonMessengerMaterial extends StatelessWidget {
  final models.SettingsDeviceDarkMode globalThemeMode;
  final models.SettingsDeviceThemeColor globalThemeColor;

  const IperonMessengerMaterial({super.key, required this.globalThemeMode, required this.globalThemeColor});

  @override
  Widget build(BuildContext context) {
    final routerConfig = getIt.get<Routers>().routerMaterial();

    late ThemeMode themeMode;
    late ColorScheme colorSchemeLight;
    late ColorScheme colorSchemeDark;

    if (globalThemeColor == models.SettingsDeviceThemeColor.blue){
      colorSchemeLight = MaterialTheme.blueLightScheme();
      colorSchemeDark = MaterialTheme.blueDarkScheme();
    } else if (globalThemeColor == models.SettingsDeviceThemeColor.green) {
      colorSchemeLight = MaterialTheme.greenLightScheme();
      colorSchemeDark = MaterialTheme.greenDarkScheme();
    } else if (globalThemeColor == models.SettingsDeviceThemeColor.purple) {
      colorSchemeLight = MaterialTheme.purpleLightScheme();
      colorSchemeDark = MaterialTheme.purpleDarkScheme();
    }

    if (globalThemeMode == models.SettingsDeviceDarkMode.alwaysOn) {
      themeMode = ThemeMode.dark;
    } else if (globalThemeMode == models.SettingsDeviceDarkMode.disabled) {
      themeMode = ThemeMode.light;
    } else if (globalThemeMode == models.SettingsDeviceDarkMode.system) {
      themeMode = ThemeMode.system;
    }

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {

        if (state.status == Status.success && state.darkMode == models.SettingsDeviceDarkMode.alwaysOn) {
          themeMode = ThemeMode.dark;
        } else if (state.status == Status.success && state.darkMode == models.SettingsDeviceDarkMode.disabled) {
          themeMode = ThemeMode.light;
        } else if (state.status == Status.success && state.darkMode == models.SettingsDeviceDarkMode.system) {
          themeMode = ThemeMode.system;
        }

        if (state.status == Status.success && state.themeColor == models.SettingsDeviceThemeColor.blue) {
          colorSchemeLight = MaterialTheme.blueLightScheme();
          colorSchemeDark = MaterialTheme.blueDarkScheme();
        } else if (state.status == Status.success && state.themeColor == models.SettingsDeviceThemeColor.green) {
          colorSchemeLight = MaterialTheme.greenLightScheme();
          colorSchemeDark = MaterialTheme.greenDarkScheme();
        } else if (state.status == Status.success && state.themeColor == models.SettingsDeviceThemeColor.purple) {
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
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
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
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
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
  final models.SettingsDeviceDarkMode globalThemeMode;
  final models.SettingsDeviceThemeColor globalThemeColor;
  const IperonMessengerCupertino({super.key, required this.globalThemeMode, required this.globalThemeColor});

  @override
  Widget build(BuildContext context) {

    Brightness? brightness;
    final routerConfig = getIt.get<Routers>().routerCupertino();

    if (globalThemeMode == models.SettingsDeviceDarkMode.system){
      brightness = Brightness.light;
    } else if (globalThemeMode == models.SettingsDeviceDarkMode.alwaysOn) {
      brightness = Brightness.dark;
    }

    CupertinoDynamicColor colors = CupertinoColors.systemTeal;

    if (globalThemeColor == models.SettingsDeviceThemeColor.blue) {
      colors = CupertinoColors.activeBlue;
    } else if (globalThemeColor == models.SettingsDeviceThemeColor.green) {
      colors = CupertinoColors.activeGreen;
    } else if (globalThemeColor == models.SettingsDeviceThemeColor.purple) {
      colors = CupertinoColors.systemPurple;
    }

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {

        if (state.status == Status.success && state.darkMode == models.SettingsDeviceDarkMode.alwaysOn) {
          brightness = Brightness.dark;
        } else if (state.status == Status.success && state.darkMode == models.SettingsDeviceDarkMode.disabled) {
          brightness = Brightness.light;
        } else if (state.status == Status.success && state.darkMode == models.SettingsDeviceDarkMode.system) {
          brightness = null;
        }

        if (state.status == Status.success && state.themeColor == models.SettingsDeviceThemeColor.blue) {
          colors = CupertinoColors.activeBlue;
        } else if (state.status == Status.success && state.themeColor == models.SettingsDeviceThemeColor.green) {
          colors = CupertinoColors.activeGreen;
        } else if (state.status == Status.success && state.themeColor == models.SettingsDeviceThemeColor.purple) {
          colors = CupertinoColors.systemPurple;
        }

        return CupertinoApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
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
