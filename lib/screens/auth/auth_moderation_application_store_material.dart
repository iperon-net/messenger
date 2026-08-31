import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants.dart';
import '../../cubit.dart';
import '../../i18n/translations.g.dart';

class AuthModerationApplicationStoreMaterial extends StatefulWidget {
  const AuthModerationApplicationStoreMaterial({super.key});

  @override
  State<AuthModerationApplicationStoreMaterial> createState() => _AuthModerationApplicationStoreMaterial();
}

class _AuthModerationApplicationStoreMaterial extends State<AuthModerationApplicationStoreMaterial> {
  final formKey = GlobalKey<FormState>();
  final pinInputController = PinInputController();

  String? error;

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
        final isDark = Theme.of(context).brightness == Brightness.dark;
        // Палитра пин-поля в тон фирменной теме: фон #1b263b в тёмной, белый в
        // светлой; акценты границ/текста инвертированы.
        final fill = isDark ? const Color(0xff1b263b) : const Color(0xffffffff);
        final filledFill = isDark ? const Color(0xff1b263b) : const Color(0xfff4f4f5);
        final accent = isDark ? const Color(0xffffffff) : const Color(0xff1b263b);

        return Scaffold(
          appBar: AppBar(backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Color(0xFF1B263B)),
          body: Form(
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
                            const SizedBox(height: 30, width: double.infinity),
                            SvgPicture.asset(isDark ? 'assets/images/logo_dark.svg' : 'assets/images/logo_light.svg'),
                            Padding(
                              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                              child: Text(
                                context.t.screenAuthModerationApplicationStore.enterTheCode,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: const TextScaler.linear(1.3).scale(16)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 30),
                              child: Text(
                                context.t.screenAuthModerationApplicationStore.sentConfirmationCodeToNumber(phoneNumber: state.phoneNumber),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            MaterialPinField(
                              length: 4,
                              pinController: pinInputController,
                              onCompleted: (verificationCode) async =>
                                  await context.read<AuthModerationApplicationStoreCubit>().onCompleted(verificationCode: verificationCode),
                              autoFocus: true,
                              keyboardAppearance: Theme.of(context).brightness,
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
                                fillColor: fill,
                                focusedFillColor: fill,
                                followingFillColor: fill,
                                completeFillColor: fill,
                                filledFillColor: filledFill,
                                filledBorderColor: accent,
                                focusedBorderColor: accent,
                                completeBorderColor: accent,
                                followingBorderColor: accent,
                                cursorColor: accent,
                                textStyle: TextStyle(color: accent, fontSize: const TextScaler.linear(1.5).scale(16)),
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
