import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class SettingsPasscodeCreateCupertino extends StatefulWidget {
  const SettingsPasscodeCreateCupertino({super.key});

  @override
  State<SettingsPasscodeCreateCupertino> createState() => _SettingsPasscodeCreateCupertino();
}

class _SettingsPasscodeCreateCupertino extends State<SettingsPasscodeCreateCupertino> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          config: ScreenLockConfig.defaultConfig.copyWith(backgroundColor: const Color(0xFF545454)),
          title: Text(context.t.settings.passcode.pleaseEnterNewPasscode),
          confirmTitle: Text(context.t.settings.passcode.pleaseEnterNewPasscodeAgain),
          cancelButton: Text(context.t.settings.passcode.cancel),
        );
      },
    );
  }
}
