import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../widgets/divider_text.dart';
import 'auth_cubit.dart';


class AuthCupertinoScreen extends StatefulWidget {
  const AuthCupertinoScreen({super.key});

  @override
  State<AuthCupertinoScreen> createState() => _AuthCupertinoScreen();
}

class _AuthCupertinoScreen extends State<AuthCupertinoScreen> {
  final logger = getIt.get<Logger>();

  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final phoneNumberFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    phoneNumberController.clear();
    phoneNumberController.dispose();
    phoneNumberFocus.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.withBrightness(
        color: Color(0xffffffff),
        darkColor: Color(0xff1b263b),
      ),
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
                      SvgPicture.asset(MediaQuery.of(context).platformBrightness == Brightness.light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
                      SizedBox(height: 30, width: double.infinity),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 1, 0, 1),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: const CupertinoDynamicColor.withBrightness(
                                color: Color(0x1F000000),
                                darkColor: Color(0x3DFFFFFF),
                              ).resolveFrom(context),
                            ),
                            bottom: BorderSide(
                              color: const CupertinoDynamicColor.withBrightness(
                                color: Color(0x1F000000),
                                darkColor: Color(0x3DFFFFFF),
                              ).resolveFrom(context),
                            ),
                          ),
                        ),
                        child: CupertinoTextFormFieldRow(
                          controller: phoneNumberController,
                          focusNode: phoneNumberFocus,
                          autocorrect: true,
                          keyboardType: TextInputType.phone,
                          prefix: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Icon(
                              CupertinoIcons.phone,
                            ),
                          ),
                          inputFormatters: [
                            PhoneInputFormatter(),
                          ],
                          autofillHints: [
                            AutofillHints.telephoneNumber,
                          ],
                          placeholder: context.t.mobilePhone,
                          validator: (value) => context.read<AuthCubit>().validatorPhoneNumber(context, value),
                        ),
                      ),
                    ],
                  ),
                  ),
                ),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoButton.filled(
                        disabledColor: Color.fromARGB(255, 56, 96, 143),
                        onPressed: [Status.success, Status.initialization].contains(state.status) ? () async => await context.read<AuthCubit>().validator(context, formKey, phoneNumberController) : null,
                        child: [Status.success, Status.initialization].contains(state.status) ? Text(context.t.kContinue) : CupertinoActivityIndicator(color: Color(0xffffffff)),
                      ),
                    );
                  }
                ),
                DividerTextWidget(text: context.t.loginInWith),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 30,
                  children: [
                    GestureDetector(
                      onTap: () async => await context.read<AuthCubit>().signIn(),
                      child: SvgPicture.asset('assets/images/yandex_id.svg'),
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/user-key.svg', width: 32, theme: SvgTheme(currentColor: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
