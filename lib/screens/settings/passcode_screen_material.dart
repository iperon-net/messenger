import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:go_router/go_router.dart';

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

    Widget widgetCreatePassCode(PasscodeState state) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.goNamed("settings_privacy_security_passcode_create"),
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

    Widget widgetUnlock(PasscodeState state) {
      return ScreenLock(
        cancelButton: Text(context.t.settings.privacyAndSecurity.passcode.cancel),
        title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
        correctString: state.passCode,
        onCancelled: () => context.goNamed("settings_privacy_security"),
        onUnlocked: () async => await context.read<PasscodeCubit>().setPassCodeLock(false),
        secretsConfig: SecretsConfig(
          spacing: 20,
          padding: const EdgeInsets.all(40),
        ),
        useBlur: false,
      );
    }

    Widget widgetMenu(PasscodeState state) {
      String trailingAutoLock = "";

      switch (state.passCodeTtl) {
        case 60:
          trailingAutoLock = context.t.settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_minute;
        case 300:
          trailingAutoLock = context.t.settings.privacyAndSecurity.passcode.auto_lock_timer_in_5_minutes;
        case 3600:
          trailingAutoLock = context.t.settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_hour;
        case 18000:
          trailingAutoLock = context.t.settings.privacyAndSecurity.passcode.auto_lock_timer_in_5_hours;
        default:
          trailingAutoLock = context.t.settings.privacyAndSecurity.passcode.auto_lock_in_disabled;
      }

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
                  onTap: () => context.goNamed("settings_privacy_security_passcode_create"),
                ),
                ListTile(
                  title: Text(context.t.settings.privacyAndSecurity.passcode.disable_passcode),
                  // leading: Icon(Icons.close),
                  onTap: () async {
                    await context.read<PasscodeCubit>().disablePassCode();
                    if (context.mounted) context.goNamed("settings_privacy_security_passcode");
                  },
                ),
                ListTile(
                  title: Text(context.t.settings.privacyAndSecurity.passcode.auto_lock),
                  // leading: Icon(Icons.close),
                  onTap: ()  => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(context.t.settings.privacyAndSecurity.passcode.auto_lock),
                      content: RadioGroup(
                        groupValue: context.watch<PasscodeCubit>().state.passCodeTtl.toString(),
                        onChanged: (value) async {
                          if(value != null){
                            await context.read<PasscodeCubit>().setPassCodeTtl(value);
                          }
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                title: Text(context.t.settings.privacyAndSecurity.passcode.auto_lock_in_disabled),
                                value: "0",
                              ),
                              RadioListTile(
                                title: Text(context.t.settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_minute),
                                value: "60",
                              ),
                              RadioListTile(
                                title: Text(context.t.settings.privacyAndSecurity.passcode.auto_lock_timer_in_5_minutes),
                                value: "300",
                              ),
                              RadioListTile(
                                title: Text(context.t.settings.privacyAndSecurity.passcode.auto_lock_timer_in_1_hour),
                                value: "3600",
                              ),
                              RadioListTile(
                                title: Text(context.t.settings.privacyAndSecurity.passcode.auto_lock_timer_in_5_hours),
                                value: "18000",
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.pop(context, context.t.ui.done),
                            child: Text(context.t.ui.done)
                        ),
                      ],
                    ),
                  ),
                  trailing: Text(
                    trailingAutoLock,
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                        fontStyle: FontStyle.normal
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return BlocBuilder<PasscodeCubit, PasscodeState>(
      builder: (context, state) {

        // if (state.status == Status.loading) {
        //   return Scaffold(
        //     appBar: AppBar(
        //       title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
        //     ),
        //     body: Container(),
        //   );
        // }

        if (state.passCode.isNotEmpty) {
          if (!state.passCodeLock){
            return WidgetWrapper(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
                ),
                body: widgetMenu(state),
              ),
            );
          } else {
            return Scaffold(
              body: widgetUnlock(state),
            );
          }
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
            ),
            body: widgetCreatePassCode(state),
          );
        }
      },
    );
  }
}


class PasscodeScreenCreateMaterial extends StatefulWidget {
  const PasscodeScreenCreateMaterial({super.key});

  @override
  State<PasscodeScreenCreateMaterial> createState() => _PasscodeScreenCreateMaterial();
}

class _PasscodeScreenCreateMaterial extends State<PasscodeScreenCreateMaterial> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLock.create(
        title: Text(context.t.settings.privacyAndSecurity.passcode.newPasscode),
        confirmTitle: Text(context.t.settings.privacyAndSecurity.passcode.confirmNewPasscode),
        cancelButton: Text(context.t.settings.privacyAndSecurity.passcode.cancel),
        secretsConfig: SecretsConfig(
          spacing: 15,
          padding: const EdgeInsets.all(40),
        ),
        onConfirmed: (String value) async {
          if (context.mounted) await context.read<PasscodeCubit>().setPassCode(value);
          if (context.mounted) await context.read<PasscodeCubit>().setPassCodeLock(false);
          if (context.mounted) context.goNamed("settings_privacy_security_passcode");
        },
        onCancelled: () => context.goNamed("settings_privacy_security_passcode"),
      ),
    );
  }

}
