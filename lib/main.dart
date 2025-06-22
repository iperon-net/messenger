import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:messenger/routers.dart';

import 'di.dart';
import 'i18n/translations.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  await configureGlobalDI();

  runApp(TranslationProvider(child: const IperonMessengerCupertino(),));
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

      // theme: const CupertinoThemeData(
      //   primaryColor: CupertinoDynamicColor.withBrightness(
      //     color: Color(0xffffffff),
      //     darkColor: Color(0xffffffff),
      //   ),
      //
      //   barBackgroundColor: CupertinoDynamicColor.withBrightness(
      //     color: Color(0xff605fc5),
      //     darkColor: Color(0xff1b263b),
      //   ),
      //   scaffoldBackgroundColor: CupertinoDynamicColor.withBrightness(
      //     color: Colors.grey,
      //     darkColor: Color(0xff1b263b),
      //   ),
      //   // textTheme: CupertinoTextThemeData(),
      // ),
    );
  }
}
