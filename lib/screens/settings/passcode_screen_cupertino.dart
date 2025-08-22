import 'package:flutter/cupertino.dart';
import 'package:pinput/pinput.dart';

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

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: CupertinoTheme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: CupertinoTheme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(8),
    );

    final formKey = GlobalKey<FormState>();

    // screenLockCreate(
    //   context: context,
    //   onConfirmed: (value) => print(value),
    //   title: Text("Задайте новый пин код"),
    //   confirmTitle: Text("Задайте новый пин код"),
    //   canCancel: false,
    // );

    // formKey.currentState!.validate();

    return CupertinoPageScaffold(
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
    );
  }

}
