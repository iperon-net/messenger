import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/cubit/main_cubit.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/main.dart';
import 'package:messenger/screens/screens.dart';


void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await configureCommonDependencies();

    // Language
    AppLocale appLocale = await LocaleSettings.useDeviceLocale();
    LocaleSettings.setLocale(appLocale);

    await tester.pumpWidget(
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
    // print(tester);

    // Verify that our counter starts at 0.

    // expect(find.byKey(Key('test')), findsOneWidget);

    // expect(, findsOneWidget);

    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
