import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:messenger/routers.dart';

import 'di.dart';
import 'i18n/translations.g.dart';
import 'screens/contacts/contacts_cubit.dart';
import 'screens/settings/language_cubit.dart';
import 'screens/settings/settings_cubit.dart';
import 'secure_storage.dart';
import 'theme_material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // LocaleSettings.useDeviceLocale();

  await configureGlobalDI();
  final secureStorage = getIt.get<SecureStorage>();

  // Language
  final language = await secureStorage.read(key: "language");
  print(language);
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
            BlocProvider<SettingsCubit>(
              create: (BuildContext context) => SettingsCubit(),
            ),
            BlocProvider<LanguageCubit>(
              create: (BuildContext context) => LanguageCubit(),
            ),
            BlocProvider<ContactsCubit>(
              create: (BuildContext context) => ContactsCubit(),
            )
          ],
          child: Platform.isIOS ? const IperonMessengerCupertino() : const IperonMessengerMaterial(),
      ),
    )
  );
}

// Material app
class IperonMessengerMaterial extends StatelessWidget {
  const IperonMessengerMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorSchemeLight = MaterialTheme.lightScheme();
    final ColorScheme colorSchemeDark = MaterialTheme.darkScheme();

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
        routerConfig: getIt.get<Routers>().routerMaterial(),
        theme: ThemeData(
          colorScheme: colorSchemeLight,
          appBarTheme: AppBarTheme(
            backgroundColor: colorSchemeLight.primary,
            foregroundColor: colorSchemeLight.surface,
          ),
          scaffoldBackgroundColor: colorSchemeLight.surfaceDim,
        ),
        darkTheme: ThemeData(
          colorScheme: colorSchemeDark,
          appBarTheme: AppBarTheme(
            backgroundColor: colorSchemeDark.onSecondary,
            foregroundColor: colorSchemeDark.onSurface,
          ),
          drawerTheme: DrawerThemeData(
            backgroundColor: colorSchemeDark.surface,
          ),
          scaffoldBackgroundColor: colorSchemeDark.surfaceDim,
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}

// Cupertino app
class IperonMessengerCupertino extends StatelessWidget {
  const IperonMessengerCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocaleUtils.supportedLocales,
      locale: TranslationProvider.of(context).flutterLocale,
      routerConfig: getIt.get<Routers>().routerCupertino(),
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
