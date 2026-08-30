import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class SettingsPasscodeCreateMaterial extends StatefulWidget {
  const SettingsPasscodeCreateMaterial({super.key});

  @override
  State<SettingsPasscodeCreateMaterial> createState() => _SettingsPasscodeCreateMaterial();
}

class _SettingsPasscodeCreateMaterial extends State<SettingsPasscodeCreateMaterial> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsPasscodeCreateCubit, SettingsPasscodeCreateState>(
      listenWhen: (previousState, currentState) => !listEquals(previousState.passcode, currentState.passcode),
      listener: (context, state) async {
        await context.read<CommonCubit>().setPasscode(passcode: state.passcode);
      },
      builder: (context, state) {
        return ScreenLock.create(
          onConfirmed: (String passcode) async {
            await context.read<SettingsPasscodeCreateCubit>().setPasscode(passcode: passcode);
            if (context.mounted) context.pop(true);
          },
          onCancelled: () => context.pop(false),
          useBlur: false,
          title: Text(context.t.settingsPasscodeCreate.pleaseEnterNewPasscode),
          confirmTitle: Text(context.t.settingsPasscodeCreate.pleaseEnterNewPasscodeAgain),
          cancelButton: Text(context.t.settingsPasscodeCreate.cancel),
        );
      },
    );
  }
}
