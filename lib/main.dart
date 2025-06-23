import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:messenger/routers.dart';

import 'di.dart';
import 'i18n/translations.g.dart';
import 'screens/settings/language_cubit.dart';
import 'screens/settings/settings_cubit.dart';
import 'secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // LocaleSettings.useDeviceLocale();

  await configureGlobalDI();
  final secureStorage = getIt.get<SecureStorage>();

  // Language
  final language = await secureStorage.read(key: "language");
  if (language.isNotEmpty && language == "ru") {
    LocaleSettings.setLocale(AppLocale.ru);
  } else {
    LocaleSettings.useDeviceLocale();
  }

  runApp(
    TranslationProvider(
      child: MultiBlocProvider(
          providers: [
            BlocProvider<SettingsCubit>(
              create: (BuildContext context) => SettingsCubit()..loading(),
            ),
            BlocProvider<LanguageCubit>(
              create: (BuildContext context) => LanguageCubit(),
            )
          ],
          child: const IperonMessengerCupertino()
      ),
    )
  );
}


// Cupertino app
class IperonMessengerCupertino extends StatelessWidget {
  const IperonMessengerCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    final routers = getIt.get<Routers>();

    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocaleUtils.supportedLocales,
      locale: TranslationProvider.of(context).flutterLocale,
      routerConfig: routers.router(),
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
