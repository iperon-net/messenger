import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/cubit/settings/settings_two_step_verification_state.dart';

import '../../cubit/settings/settings_two_step_verification_cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';



class SettingsTwoStepVerificationScreenCupertino extends StatefulWidget {
  final String screen;

  const SettingsTwoStepVerificationScreenCupertino({
    super.key,
    required this.screen,
  });

  @override
  State<SettingsTwoStepVerificationScreenCupertino> createState() => _SettingsTwoStepVerificationScreenCupertino();
}

class _SettingsTwoStepVerificationScreenCupertino extends State<SettingsTwoStepVerificationScreenCupertino> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();

  final emailController = TextEditingController();
  final emailFocus = FocusNode();


  final logger = getIt.get<Logger>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsTwoStepVerificationCubit, SettingsTwoStepVerificationState>(
      listenWhen: (previous, current) => previous.redirectURL != current.redirectURL,
      listener: (context, state) {
        if(state.redirectURL.isNotEmpty) {
          context.go(state.redirectURL);
        }
      },
      builder: (context, state) {

        if (widget.screen == "newEmail") {
          return newEmail(state);
        }
        return newPassword(state);

        // if (state.step == "email") {
        //   return newEmail(state);
        // }
        //
        // emailController.clear();
        // emailFocus.unfocus();
        // passwordFocus.requestFocus();
        // return newPassword(state);
      },
    );
  }

  Widget newPassword(SettingsTwoStepVerificationState state) {
    return CupertinoPageScaffold(
      key: const ValueKey('password'),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        middle: Text(context.t.newPassword),
        trailing: state.nextButton ? CupertinoButton(padding: EdgeInsets.zero, onPressed: () async {
          if(!formKey.currentState!.validate()) return;
          passwordFocus.unfocus();
          await context.read<SettingsTwoStepVerificationCubit>().submit(passwordController.text);
        }, child: Text(context.t.next)) : null,
        previousPageTitle: context.t.back,
      ),
      child: SafeArea(
        child: Form(
          key: formKey,
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
                    controller: passwordController,
                    focusNode: passwordFocus,
                    prefix: Text(context.t.password),
                    obscureText: true,
                    autofocus: true,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.route,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    autofillHints: const [
                      AutofillHints.newPassword,
                      AutofillHints.password,
                    ],
                    onChanged: (data) {
                      if (data.length >= 5) {
                        context.read<SettingsTwoStepVerificationCubit>().setNextButton(true);
                      } else {
                        context.read<SettingsTwoStepVerificationCubit>().setNextButton(false);
                      }
                    },
                    onEditingComplete: () async {
                      if(!formKey.currentState!.validate()) return;
                      await context.read<SettingsTwoStepVerificationCubit>().submit(passwordController.text);
                    },
                    validator: (data) {
                      if (data!.length < 5) {
                        return context.t.passwordIsToSmall;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newEmail(SettingsTwoStepVerificationState state) {
    return CupertinoPageScaffold(
      key: const ValueKey('email'),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        automaticBackgroundVisibility: false,
        middle: Text(context.t.email),
        trailing: state.nextButton ? CupertinoButton(padding: EdgeInsets.zero, onPressed: () async {
          if(!formKey.currentState!.validate()) return;
          // await context.read<SettingsTwoStepVerificationCubit>().submit(passwordController.text);
        }, child: Text(context.t.next)) : null,
      ),
      child: SafeArea(
        child: Form(
          key: formKey,
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
                    controller: emailController,
                    focusNode: emailFocus,
                    prefix: Text(context.t.emailEnglish),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.route,
                    autofocus: true,
                    autofillHints: const [
                      AutofillHints.email,
                    ],
                    onChanged: (data) {
                      if (data.length >= 5) {
                        context.read<SettingsTwoStepVerificationCubit>().setNextButton(true);
                      } else {
                        context.read<SettingsTwoStepVerificationCubit>().setNextButton(false);
                      }
                    },
                    onEditingComplete: () async {
                      if(!formKey.currentState!.validate()) return;
                      // await context.read<SettingsTwoStepVerificationCubit>().submit(passwordController.text);
                    },
                    validator: (data) {
                      if (data!.length <= 5) {
                        return context.t.passwordIsToSmall;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
