import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/cubit/settings/settings_two_step_verification_state.dart';

import '../../cubit/settings/settings_two_step_verification_cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';



class SettingsTwoStepVerificationScreenCupertino extends StatefulWidget {
  const SettingsTwoStepVerificationScreenCupertino({super.key});

  @override
  State<SettingsTwoStepVerificationScreenCupertino> createState() => _SettingsTwoStepVerificationScreenCupertino();
}

class _SettingsTwoStepVerificationScreenCupertino extends State<SettingsTwoStepVerificationScreenCupertino> {
  final logger = getIt.get<Logger>();

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
    return BlocConsumer<SettingsTwoStepVerificationCubit, SettingsTwoStepVerificationState>(
      // listenWhen: (previous, current) => previous.locale != current.locale,
      listener: (context, state) {
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.newPassword),
            trailing: state.nextButton ? CupertinoButton(padding: EdgeInsets.zero, onPressed: () => Navigator.pop(context), child: Text(context.t.next)) : null,
          ),
          child: SafeArea(
            child: ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  footer: Text(
                    context.t.youCanSetPasswordThatWillBeRequiredWhenLoggingInFromNewDevice,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  children: [
                    CupertinoTextFormFieldRow(
                      prefix: Text(context.t.password),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                      ],
                      onChanged: (data) {
                        if (data.length >= 5) {
                          context.read<SettingsTwoStepVerificationCubit>().setNextButton(true);
                        } else {
                          context.read<SettingsTwoStepVerificationCubit>().setNextButton(false);
                        }
                      },
                      onEditingComplete: () {
                        logger.debug("message");
                      },
                      validator: (data) {
                        return "222";
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
