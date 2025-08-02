import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/widget_wrapper/widget_wrapper.dart';
import '../../i18n/translations.g.dart';
import 'passcode_cubit.dart';

class PasscodeScreenMaterial extends StatefulWidget {
  const PasscodeScreenMaterial({super.key});

  @override
  State<PasscodeScreenMaterial> createState() => _PasscodeScreenMaterial();
}

class _PasscodeScreenMaterial extends State<PasscodeScreenMaterial> {

  @override
  void initState() {
    context.read<PasscodeCubit>().initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget createPassCode = Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.read<PasscodeCubit>().createPassCode(context),
              child: Text(context.t.settings.privacyAndSecurity.passcode.setPasscode),
            ),
            SizedBox(height: 10),
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
    );

    return WidgetWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
        ),
        body: SafeArea(
          child: BlocBuilder<PasscodeCubit, PasscodeState>(
            builder: (context, state) {
              if (state.passCode.isNotEmpty) {
                return ListView(
                  padding: EdgeInsets.all(8.0),
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(context.t.settings.privacyAndSecurity.passcode.change_passcode),
                            leading: Icon(Icons.change_circle_sharp),
                            onTap: () => null,
                          ),
                          ListTile(
                            title: Text(context.t.settings.privacyAndSecurity.passcode.disable_passcode),
                            leading: Icon(Icons.close),
                            onTap: () => null,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return createPassCode;
              }
            },
          ),
        ),
      ),
    );
  }

}
