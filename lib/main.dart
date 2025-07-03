import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:messenger/routers.dart';

import 'cubit/app_cubit.dart';
import 'di.dart';
import 'i18n/translations.g.dart';
import 'screens/contacts/contacts_cubit.dart';
import 'screens/settings/appearance_cubit.dart';
import 'screens/settings/language_cubit.dart';
import 'screens/settings/settings_cubit.dart';
import 'secure_storage.dart';
import 'themes/material_blue.dart' as material_blue;
import 'themes/material_green.dart' as material_green;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureGlobalDI();
  final secureStorage = getIt.get<SecureStorage>();

  // Language
  final language = await secureStorage.read(key: "language");
  if (language.isNotEmpty && language == AppLocale.ru.languageCode) {
    LocaleSettings.setLocale(AppLocale.ru);
  } else if (language.isNotEmpty && language == AppLocale.en.languageCode) {
    LocaleSettings.setLocale(AppLocale.en);
  } else {
    LocaleSettings.useDeviceLocale();
  }

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
            )
          ],
        child: Platform.isIOS ?  const IperonMessengerCupertino() :  IperonMessengerMaterial(),
      ),
    )
  );
}

// Material app
class IperonMessengerMaterial extends StatelessWidget {
  const IperonMessengerMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = getIt.get<Routers>().routerMaterial();

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {

        ThemeMode themeMode = ThemeMode.system;
        if (state.darkMode == DarkMode.alwaysOn) {
          themeMode = ThemeMode.dark;
        } else if (state.darkMode == DarkMode.disabled) {
          themeMode = ThemeMode.light;
        }

        late ColorScheme colorSchemeLight;
        late ColorScheme colorSchemeDark;

        if (state.colorTheme == ColorTheme.green) {
          colorSchemeLight = material_green.MaterialTheme.lightScheme();
          colorSchemeDark = material_green.MaterialTheme.darkScheme();
        } else {
          colorSchemeLight = material_blue.MaterialTheme.lightScheme();
          colorSchemeDark = material_blue.MaterialTheme.darkScheme();
        }

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
            locale: TranslationProvider.of(context).flutterLocale,
            routerConfig: routerConfig,
            theme: ThemeData(
              colorScheme: colorSchemeLight,
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
  const IperonMessengerCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = getIt.get<Routers>().routerCupertino();

    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocaleUtils.supportedLocales,
      locale: TranslationProvider.of(context).flutterLocale,
      routerConfig: routerConfig,
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
        scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
           color: CupertinoColors.systemGrey6,
           darkColor: CupertinoColors.black,
        ),
      ),
    );
  }
}
