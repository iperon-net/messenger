import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';
import '../../themes.dart';

class AuthModerationApplicationStoreCupertino extends StatefulWidget {
  const AuthModerationApplicationStoreCupertino({super.key});

  @override
  State<AuthModerationApplicationStoreCupertino> createState() => _AuthModerationApplicationStoreCupertino();
}

class _AuthModerationApplicationStoreCupertino extends State<AuthModerationApplicationStoreCupertino> {
  final formKey = GlobalKey<FormState>();
  final pinInputController = PinInputController();

  String? error;

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
    return BlocConsumer<AuthModerationApplicationStoreCubit, AuthModerationApplicationStoreState>(
      listenWhen: (previous, current) => previous.redirectURI != current.redirectURI || previous.error != current.error,
      listener: (context, state) async {
        if (state.error.isNotEmpty) {
          pinInputController.triggerError();
          try {
            error = context.t[state.error];
          } catch (e) {
            error = context.t.grpcError.unknownError;
          }
        } else if (state.status == Status.success && state.redirectURI.isNotEmpty) {
          await context.read<CommonCubit>().setPasscode(passcode: []);
          if (context.mounted) context.go(state.redirectURI.toString());
        }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          navigationBar: AppCupertinoNavigationBar(child: CupertinoNavigationBar()),
          child: Form(
            key: formKey,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 50),
                child: Column(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30, width: double.infinity),
                            SvgPicture.asset(
                              CupertinoTheme.brightnessOf(context) == Brightness.light
                                  ? 'assets/images/logo_light.svg'
                                  : 'assets/images/logo_dark.svg',
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.only(top: 30, left: 30, right: 30),
                              child: Text(
                                context.t.screenAuthModerationApplicationStore.enterTheCode,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFontSizes.emphasis),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.only(top: 10, left: 30, right: 30, bottom: 30),
                              child: Text(
                                context.t.screenAuthModerationApplicationStore.sentConfirmationCodeToNumber(phoneNumber: state.phoneNumber),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // if (error != null) ...[Text(error!, style: TextStyle(color: CupertinoColors.systemRed),)],
                            MaterialPinField(
                              length: 4,
                              pinController: pinInputController,
                              enableAutofill: true,
                              autofillHints: [AutofillHints.oneTimeCode],
                              onCompleted: (verificationCode) async =>
                                  await context.read<AuthModerationApplicationStoreCubit>().onCompleted(verificationCode: verificationCode),
                              autoFocus: true,
                              keyboardAppearance: CupertinoTheme.brightnessOf(context),
                              theme: MaterialPinTheme(
                                entryAnimation: MaterialPinAnimation.none,
                                animateCursor: false,
                                borderWidth: 1.5,
                                focusedBorderWidth: 1.5,
                                spacing: 4,
                                shape: MaterialPinShape.underlined,
                                borderRadius: BorderRadius.circular(8),
                                cursorWidth: 1,
                                animationDuration: const Duration(milliseconds: 0),

                                fillColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xffffffff), darkColor: Color(0xff1b263b)),
                                  context,
                                ),
                                focusedFillColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xffffffff), darkColor: Color(0xff1b263b)),
                                  context,
                                ),
                                followingFillColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xffffffff), darkColor: Color(0xff1b263b)),
                                  context,
                                ),
                                completeFillColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xffffffff), darkColor: Color(0xff1b263b)),
                                  context,
                                ),
                                filledFillColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xfff4f4f5), darkColor: Color(0xff1b263b)),
                                  context,
                                ),
                                filledBorderColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xff1b263b), darkColor: Color(0xfff4f4f5)),
                                  context,
                                ),
                                focusedBorderColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xff1b263b), darkColor: Color(0xffffffff)),
                                  context,
                                ),
                                completeBorderColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xff1b263b), darkColor: Color(0xffffffff)),
                                  context,
                                ),
                                followingBorderColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xff1b263b), darkColor: Color(0xffffffff)),
                                  context,
                                ),
                                cursorColor: CupertinoDynamicColor.resolve(
                                  CupertinoDynamicColor.withBrightness(color: Color(0xff1b263b), darkColor: Color(0xffffffff)),
                                  context,
                                ),
                                textStyle: TextStyle(
                                  color: CupertinoDynamicColor.resolve(
                                    CupertinoDynamicColor.withBrightness(color: Color(0xff1b263b), darkColor: Color(0xffffffff)),
                                    context,
                                  ),
                                  fontSize: AppFontSizes.emphasisLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
