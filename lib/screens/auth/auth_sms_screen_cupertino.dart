import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:convert/convert.dart' as convertor;

import '../../i18n/translations.g.dart';
import 'auth_sms_cubit.dart';

class AuthSmsScreenCupertino extends StatefulWidget {
  final String smsSession;
  final String phoneNumber;

  const AuthSmsScreenCupertino({
    required this.smsSession,
    required this.phoneNumber,
    super.key,
  });

  @override
  State<AuthSmsScreenCupertino> createState() => _AuthSmsScreenCupertino();
}

class _AuthSmsScreenCupertino extends State<AuthSmsScreenCupertino> {

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

    Brightness brightness = Brightness.light;
    if (MediaQuery.platformBrightnessOf(context) == Brightness.dark){
      brightness = Brightness.dark;
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.withBrightness(
        color: Color(0xffffffff),
        darkColor: Color(0xff1b263b),
      ),
      navigationBar: CupertinoNavigationBar(),
      child: Form(
        key: null,
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
                        SvgPicture.asset(MediaQuery.of(context).platformBrightness == Brightness.light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 30, left: 30, right: 30),
                          child: Text(
                            context.t.enterTheCode,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: const TextScaler.linear(1.3).scale(16)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(top: 10, left: 30, right: 30, bottom: 30),
                          child: Text(
                            context.t.sentConfirmationCodeToNumber(phoneNumber: widget.phoneNumber),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        MaterialPinField(
                          length: 4,
                          pinController: pinInputController,
                          enableAutofill: true,
                          autofillHints: [AutofillHints.oneTimeCode],
                          onCompleted: (verificationCode) async {
                            final result = await context.read<AuthSmsCubit>().smsCheck(context, smsSession: convertor.hex.decode(widget.smsSession), verificationCode: verificationCode);
                            if (context.mounted && !result) {
                              pinInputController.triggerError();
                            }
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
                            fillColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                              color: Color(0xffffffff),
                              darkColor: Color(0xff1b263b),
                            ), context),
                            focusedFillColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                              color: Color(0xffffffff),
                              darkColor: Color(0xff1b263b),
                            ), context),
                            followingFillColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                              color: Color(0xffffffff),
                              darkColor: Color(0xff1b263b),
                            ), context),
                            completeFillColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                              color: Color(0xffffffff),
                              darkColor: Color(0xff1b263b),
                            ), context),
                            filledFillColor: CupertinoDynamicColor.resolve(CupertinoDynamicColor.withBrightness(
                                color: Color(0xfff4f4f5),
                                darkColor: Color(0xff1b263b),
                            ), context),
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
  }
}
