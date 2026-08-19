import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../components.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class AuthModerationApplicationStoreCupertino extends StatefulWidget {
  const AuthModerationApplicationStoreCupertino({super.key});

  @override
  State<AuthModerationApplicationStoreCupertino> createState() => _AuthModerationApplicationStoreCupertino();
}

class _AuthModerationApplicationStoreCupertino extends State<AuthModerationApplicationStoreCupertino> {
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthModerationApplicationStoreCubit, AuthModerationApplicationStoreState>(
      listenWhen: (previous, current) => previous.redirectURI != current.redirectURI,
      listener: (context, state) async {
        await context.read<CommonCubit>().setPasscode(passcode: []);
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
                                context.t.auth.enterTheCode,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: const TextScaler.linear(1.3).scale(16)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.only(top: 10, left: 30, right: 30, bottom: 30),
                              child: Text(
                                context.t.auth.sentConfirmationCodeToNumber(phoneNumber: state.phoneNumber),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            MaterialPinField(
                              length: 4,
                              pinController: pinInputController,
                              enableAutofill: true,
                              autofillHints: [AutofillHints.oneTimeCode],
                              onCompleted: (verificationCode) async {
                                final cubit = context.read<AuthModerationApplicationStoreCubit>();
                                final error = await cubit.onCompleted(verificationCode: verificationCode);

                                if (!context.mounted) return;

                                final redirectURI = cubit.state.redirectURI;
                                if (redirectURI != null) {
                                  context.go(redirectURI.toString());
                                  return;
                                } else if (error) {
                                  pinInputController.triggerError();
                                  return;
                                }

                                return;
                              },
                              autoFocus: true,
                              // keyboardAppearance: brightness,
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
                                  fontSize: const TextScaler.linear(1.5).scale(16),
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
