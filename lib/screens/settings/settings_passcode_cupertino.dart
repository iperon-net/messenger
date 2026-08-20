import 'package:cupertino_ui/cupertino_ui.dart';
import '../../themes.dart';

import '../../components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';

class SettingsPasscodeCupertino extends StatefulWidget {
  const SettingsPasscodeCupertino({super.key});

  @override
  State<SettingsPasscodeCupertino> createState() => _SettingsPasscodeCupertino();
}

class _SettingsPasscodeCupertino extends State<SettingsPasscodeCupertino> {
  final formKey = GlobalKey<FormState>();
  final pinInputController = PinInputController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _autoLockLabel(BuildContext context, int seconds) {
    if (seconds == 0) return context.t.settings.passcode.autoLockOff;
    if (seconds < 3600) {
      return context.t.settings.passcode.autoLockMinutes(n: seconds ~/ 60);
    }
    return context.t.settings.passcode.autoLockHours(n: seconds ~/ 3600);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsPasscodeCubit, SettingsPasscodeState>(
      listenWhen: (previousState, currentState) =>
          !listEquals(previousState.passcode, currentState.passcode) ||
          previousState.isBiometric != currentState.isBiometric ||
          previousState.autoLockSeconds != currentState.autoLockSeconds,
      listener: (context, state) async {
        final commonCubit = context.read<CommonCubit>();
        await commonCubit.setPasscode(passcode: state.passcode);
        await commonCubit.setPasscodeBiometric(biometric: state.isBiometric);
        await commonCubit.setPasscodeAutoLockSeconds(seconds: state.autoLockSeconds);
      },
      builder: (context, state) {
        // Если passcode установлен, но ещё не разблокирован — показываем ScreenLock.
        if (state.passcode.isNotEmpty && !state.unlocked) {
          return ScreenLock(
            correctString: '0000',
            onValidate: (input) => context.read<SettingsPasscodeCubit>().verifyPasscode(input),
            onUnlocked: () {},
            onCancelled: () => context.go("/settings/privacy_and_security"),
            useBlur: false,
            keyPadConfig: ThemesCupertino.screenLockKeyPad(context),
            config: ThemesCupertino.screenLockConfig(context),
            title: Text(context.t.settings.passcode.pleaseEnterPasscode),
            cancelButton: Text(context.t.settings.passcode.cancel),
            // maxRetries: 3,
            // retryDelay: Duration(minutes: 10),
            // delayBuilder: (context, delay) => Text("delay"),
            // onOpened: () {
            //   print("onOpened");
            // },
            // onMaxRetries: (data) {
            //   print(data);
            // },
          );
        }

        return CupertinoPageScaffold(
          backgroundColor: ThemesCupertino.groupedBackground,
          navigationBar: AppCupertinoNavigationBar(
            child: CupertinoNavigationBar(
              automaticBackgroundVisibility: false,
              backgroundColor: ThemesCupertino.groupedBackground,
              middle: state.isBiometricAvailable ? Text(context.t.settings.passcodeAndFaceID) : Text(context.t.settings.passcode.title),
            ),
          ),
          child: SafeArea(
            child: ListView(
              children: [
                if (state.passcode.isNotEmpty) ...[
                  CupertinoListSection.insetGrouped(
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.only(left: 13),
                      child: Text(context.t.settings.passcode.note, style: TextStyle(fontSize: 13)),
                    ),
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.settings.passcode.passcodeTurnOff),
                        onTap: () => context.read<SettingsPasscodeCubit>().turnOff(),
                      ),
                      CupertinoListTile(
                        title: Text(context.t.settings.passcode.changePasscode),
                        onTap: () async {
                          final cubit = context.read<SettingsPasscodeCubit>();
                          final created = await context.push<bool>("/settings/privacy_and_security/passcode/create");
                          await cubit.initialization();
                          if (created == true) cubit.setUnlocked(true);
                        },
                      ),
                    ],
                  ),
                  CupertinoListSection.insetGrouped(
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.settings.passcode.autoLock),
                        trailing: CupertinoMenuAnchor(
                          builder: (context, controller, child) {
                            return CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => controller.isOpen ? controller.close() : controller.open(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(
                                      _autoLockLabel(context, state.autoLockSeconds),
                                      style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          menuChildren: [
                            for (final seconds in const [0, 60, 300, 3600, 18000])
                              CupertinoMenuItem(
                                trailing: state.autoLockSeconds == seconds ? const Icon(CupertinoIcons.check_mark) : null,
                                onPressed: () async => await context.read<SettingsPasscodeCubit>().setAutoLock(seconds: seconds),
                                child: Text(_autoLockLabel(context, seconds)),
                              ),
                          ],
                        ),
                      ),
                      if (state.isBiometricAvailable) ...[
                        CupertinoListTile(
                          title: Text(context.t.settings.passcode.faceIDUnlock),
                          trailing: CupertinoSwitch(
                            value: state.isBiometric,
                            onChanged: (bool value) async => await context.read<SettingsPasscodeCubit>().setBiometric(biometric: value),
                          ),
                        ),
                      ],
                    ],
                  ),
                ] else ...[
                  CupertinoListSection.insetGrouped(
                    backgroundColor: ThemesCupertino.groupedBackground.resolveFrom(context),
                    decoration: BoxDecoration(
                      color: ThemesCupertino.groupedCard.resolveFrom(context),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    children: [
                      CupertinoListTile(
                        title: Text(context.t.settings.passcode.passcodeTurnOn),
                        onTap: () async {
                          final cubit = context.read<SettingsPasscodeCubit>();
                          final created = await context.push<bool>("/settings/privacy_and_security/passcode/create");
                          await cubit.initialization();
                          if (created == true) cubit.setUnlocked(true);
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
