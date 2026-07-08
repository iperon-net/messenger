import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/cubit/settings/settings_two_step_verification_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();


  final logger = getIt.get<Logger>();

  late final SettingsTwoStepVerificationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SettingsTwoStepVerificationCubit>();
  }

  @override
  void dispose() {
    cubit.reset();
    passwordController.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsTwoStepVerificationCubit, SettingsTwoStepVerificationState>(
      listenWhen: (previous, current) => previous.redirectUrl != current.redirectUrl,
      listener: (context, state) {
        // Кубит общий для всей цепочки, поэтому пушим следующий экран
        // только с верхнего маршрута — иначе нижние экраны, оставшиеся
        // подписанными, продублируют переход.
        if(state.redirectUrl.isNotEmpty && (ModalRoute.of(context)?.isCurrent ?? false)) {
          final cubit = context.read<SettingsTwoStepVerificationCubit>();
          cubit.reset();
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: const SettingsTwoStepVerificationNewEmailScreenCupertino(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          key: const ValueKey('password'),
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            padding: const EdgeInsetsDirectional.only(start: 1, end: 16),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(CupertinoIcons.back, size: 28),
            ),
            middle: Text(context.t.newPassword),
            trailing: state.nextButton ? CupertinoButton(padding: EdgeInsets.zero, onPressed: () async {
              if(!formKey.currentState!.validate()) return;
              await cubit.setPassword(passwordController.text);
              passwordController.clear();
              cubit.setNextButton(false);
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
                            cubit.setNextButton(true);
                          } else {
                            cubit.setNextButton(false);
                          }
                        },
                        onEditingComplete: () async {
                          if(!formKey.currentState!.validate()) return;
                          await cubit.setPassword(passwordController.text);
                          passwordController.clear();
                          cubit.setNextButton(false);
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
      },
    );
  }
}

class SettingsTwoStepVerificationNewEmailScreenCupertino extends StatefulWidget {
  const SettingsTwoStepVerificationNewEmailScreenCupertino({super.key});

  @override
  State<SettingsTwoStepVerificationNewEmailScreenCupertino> createState() => _SettingsTwoStepVerificationNewEmailScreenCupertino();
}

class _SettingsTwoStepVerificationNewEmailScreenCupertino extends State<SettingsTwoStepVerificationNewEmailScreenCupertino> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final emailFocus = FocusNode();


  final logger = getIt.get<Logger>();

  late final SettingsTwoStepVerificationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SettingsTwoStepVerificationCubit>();
  }

  @override
  void dispose() {
    cubit.reset();
    emailController.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsTwoStepVerificationCubit, SettingsTwoStepVerificationState>(
      listenWhen: (previous, current) => previous.redirectUrl != current.redirectUrl,
      listener: (context, state) {
        // См. комментарий выше: пушим только с верхнего маршрута.
        if(state.redirectUrl.isNotEmpty && (ModalRoute.of(context)?.isCurrent ?? false)) {
          final cubit = context.read<SettingsTwoStepVerificationCubit>();
          cubit.reset();
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: const SettingsTwoStepVerificationCodeScreenCupertino(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          key: const ValueKey('email'),
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.email),
            trailing: state.nextButton ? CupertinoButton(padding: EdgeInsets.zero, onPressed: () async {
              if(!formKey.currentState!.validate()) return;
              await cubit.setEmail(emailController.text);
              emailController.clear();
              cubit.setNextButton(false);
            }, child: Text(context.t.next)) : null,
          ),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    footer: Text(
                      context.t.enterYourEmailForgetYourPassword,
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
                          context.read<SettingsTwoStepVerificationCubit>().setNextButton(true);
                        },
                        onEditingComplete: () async {
                          if(!formKey.currentState!.validate()) return;
                          await cubit.setEmail(emailController.text);
                          emailController.clear();
                          cubit.setNextButton(false);
                          // await context.read<SettingsTwoStepVerificationCubit>().submit(passwordController.text);
                        },
                        validator: (data) {
                          final isValid = context.read<SettingsTwoStepVerificationCubit>().emailValidator(email: data);
                          if (!isValid) return context.t.invalidEmail;
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
    );
  }
}

class SettingsTwoStepVerificationCodeScreenCupertino extends StatefulWidget {
  const SettingsTwoStepVerificationCodeScreenCupertino({super.key});

  @override
  State<SettingsTwoStepVerificationCodeScreenCupertino> createState() => _SettingsTwoStepVerificationCodeScreenCupertino();
}


class _SettingsTwoStepVerificationCodeScreenCupertino extends State<SettingsTwoStepVerificationCodeScreenCupertino> {
  final formKey = GlobalKey<FormState>();

  final codeController = PinInputController();
  final codeFocus = FocusNode();


  final logger = getIt.get<Logger>();

  late final SettingsTwoStepVerificationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SettingsTwoStepVerificationCubit>();
  }

  @override
  void dispose() {
    cubit.reset();
    codeController.dispose();
    codeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Brightness.light;
    if (MediaQuery.platformBrightnessOf(context) == Brightness.dark){
      brightness = Brightness.dark;
    }

    return BlocConsumer<SettingsTwoStepVerificationCubit, SettingsTwoStepVerificationState>(
      listenWhen: (previous, current) => previous.redirectUrl != current.redirectUrl,
      listener: (context, state) {
          // if(state.redirectURL.isNotEmpty) {
          //   context.go(state.redirectURL);
          // }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          key: const ValueKey('email'),
          backgroundColor: CupertinoColors.systemGroupedBackground,
          navigationBar: CupertinoNavigationBar(
            automaticBackgroundVisibility: false,
            middle: Text(context.t.confirmYourEmail),
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
                    backgroundColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                    decoration: const BoxDecoration(color: Color(0x00000000)),
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 50),
                          MaterialPinField(
                            length: 6,
                            pinController: codeController,
                            enableAutofill: true,
                            autofillHints: [
                              AutofillHints.oneTimeCode
                            ],
                            onCompleted: (verificationCode) async {
                              codeController.triggerError();
                            },
                            autoFocus: true,
                            keyboardAppearance: brightness,
                            theme: MaterialPinTheme(
                              entryAnimation: MaterialPinAnimation.none,
                              animateCursor: false,
                              borderWidth: 1.5,
                              focusedBorderWidth: 1.5,
                              spacing: 8,
                              shape: MaterialPinShape.underlined,
                              borderRadius: BorderRadius.circular(8),
                              cursorWidth: 1,
                              animationDuration: const Duration(milliseconds: 0),
                              fillColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                              focusedFillColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                              followingFillColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                              completeFillColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                              filledFillColor: CupertinoColors.systemGroupedBackground.resolveFrom(context),
                              filledBorderColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                                color: Color(0xff1b263b),
                                darkColor: Color(0xfff4f4f5),
                              ), context),
                              focusedBorderColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                                color: Color(0xff1b263b),
                                darkColor: Color(0xffffffff),
                              ), context),
                              completeBorderColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                                color: Color(0xff1b263b),
                                darkColor: Color(0xffffffff),
                              ), context),
                              followingBorderColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                                color: Color(0xff1b263b),
                                darkColor: Color(0xffffffff),
                              ), context),
                              cursorColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                                color: Color(0xff1b263b),
                                darkColor: Color(0xffffffff),
                              ), context),
                              textStyle: TextStyle(color: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                                color: Color(0xff1b263b),
                                darkColor: Color(0xffffffff),
                              ), context), fontSize: const TextScaler.linear(1.5).scale(16)),
                            ),
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
