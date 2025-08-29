import 'package:flutter/cupertino.dart';

import '../../components/widget_wrapper/widget_wrapper.dart';
import '../../i18n/translations.g.dart';

class PasscodeScreenCupertino extends StatefulWidget {
  const PasscodeScreenCupertino({super.key});

  @override
  State<PasscodeScreenCupertino> createState() => _PasscodeScreenCupertino();
}

class _PasscodeScreenCupertino extends State<PasscodeScreenCupertino> {

  @override
  void initState() {
    super.initState();
  }

  bool showError = false;

  @override
  Widget build(BuildContext context) {

    return WidgetWrapper(
      child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          previousPageTitle: t.settings.language.back,
          middle: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton.filled(
                    onPressed: () => null,
                    child: Text(context.t.settings.privacyAndSecurity.passcode.setPasscode),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      context.t.settings.privacyAndSecurity.passcode.importantDescription,
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
