import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../i18n/translations.g.dart';
import '../../cubit.dart';
import '../../themes.dart';

class SettingsPasscodeMaterial extends StatefulWidget {
  const SettingsPasscodeMaterial({super.key});

  @override
  State<SettingsPasscodeMaterial> createState() => _SettingsPasscodeMaterial();
}

class _SettingsPasscodeMaterial extends State<SettingsPasscodeMaterial> {
  final formKey = GlobalKey<FormState>();
  final pinInputController = PinInputController();

  String _autoLockLabel(BuildContext context, int seconds) {
    if (seconds == 0) return context.t.screenSettingsPasscode.autoLockOff;
    if (seconds < 3600) {
      return context.t.screenSettingsPasscode.autoLockMinutes(n: seconds ~/ 60);
    }
    return context.t.screenSettingsPasscode.autoLockHours(n: seconds ~/ 3600);
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
            keyPadConfig: ThemesMaterial.screenLockKeyPad(context),
            config: ThemesMaterial.screenLockConfig(context),
            useBlur: false,
            title: Text(context.t.screenSettingsPasscode.pleaseEnterPasscode),
            cancelButton: Text(context.t.screenSettingsPasscode.cancel),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: state.isBiometricAvailable
                ? Text(context.t.screenSettingsPasscode.passcodeAndBiometric)
                : Text(context.t.screenSettingsPasscode.passcode),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                if (state.passcode.isNotEmpty) ...[
                  Card(
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(context.t.screenSettingsPasscode.turnOff),
                          onTap: () => context.read<SettingsPasscodeCubit>().turnOff(),
                        ),
                        ListTile(
                          title: Text(context.t.screenSettingsPasscode.change),
                          onTap: () async {
                            final cubit = context.read<SettingsPasscodeCubit>();
                            final created = await context.push<bool>("/settings/privacy_and_security/passcode/create");
                            await cubit.initialization();
                            if (created == true) cubit.setUnlocked(true);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                    child: Text(
                      context.t.screenSettingsPasscode.note,
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(context.t.screenSettingsPasscode.autoLock),
                          trailing: PopupMenuButton<int>(
                            initialValue: state.autoLockSeconds,
                            onSelected: (seconds) async => await context.read<SettingsPasscodeCubit>().setAutoLock(seconds: seconds),
                            itemBuilder: (context) => [
                              for (final seconds in const [0, 60, 300, 3600, 18000])
                                PopupMenuItem<int>(value: seconds, child: Text(_autoLockLabel(context, seconds))),
                            ],
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _autoLockLabel(context, state.autoLockSeconds),
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                        if (state.isBiometricAvailable)
                          SwitchListTile(
                            title: Text(context.t.screenSettingsPasscode.biometricUnlock),
                            value: state.isBiometric,
                            onChanged: (bool value) async => await context.read<SettingsPasscodeCubit>().setBiometric(biometric: value),
                          ),
                      ],
                    ),
                  ),
                ] else ...[
                  Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text(context.t.screenSettingsPasscode.turnOn),
                      onTap: () async {
                        final cubit = context.read<SettingsPasscodeCubit>();
                        final created = await context.push<bool>("/settings/privacy_and_security/passcode/create");
                        await cubit.initialization();
                        if (created == true) cubit.setUnlocked(true);
                      },
                    ),
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
