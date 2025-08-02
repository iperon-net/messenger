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
    return WidgetWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
        ),
        body: SafeArea(
          child: BlocBuilder<PasscodeCubit, PasscodeState>(
            builder: (context, state) {
              if (state.passCode.isNotEmpty) {
                return Text("dddd");
              } else {
                return Center(
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
              }
            },
          ),
        ),
      ),
    );
  }

}
