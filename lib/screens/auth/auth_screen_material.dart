import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegram_login/telegram_login.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../widgets/divider_text.dart';
import 'auth_cubit.dart';


class AuthMaterialScreen extends StatefulWidget {
  const AuthMaterialScreen({super.key});

  @override
  State<AuthMaterialScreen> createState() => _AuthMaterialScreen();
}

class _AuthMaterialScreen extends State<AuthMaterialScreen> {
  final logger = getIt.get<Logger>();

  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final phoneNumberFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) phoneNumberFocus.requestFocus();
      });
    });

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 5, 25, 50),
            child: Column(
              spacing: 20,
              children: [
                Expanded(
                  child: Column(
                    spacing: 30,
                    children: [
                      SvgPicture.asset(Theme.of(context).brightness == Brightness.light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
                      TextFormField(
                        controller: phoneNumberController,
                        focusNode: phoneNumberFocus,
                        autocorrect: true,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone, color: Theme.of(context).colorScheme.primary),
                          labelText: context.t.mobilePhone,
                          helperMaxLines: 2,
                          errorMaxLines: 2,
                        ),
                        inputFormatters: [
                          PhoneInputFormatter(),
                        ],
                        autofillHints: [
                          AutofillHints.telephoneNumber,
                        ],
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          final error = context.read<AuthCubit>().validatorPhoneNumber(context, value);
                          if (error == null) return null;
                          return error.contains('\n') ? error : '$error\n';
                        },
                        onEditingComplete: () async => await context.read<AuthCubit>().validator(context, formKey, phoneNumberController),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, AuthState state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: [Status.success, Status.initialization].contains(state.status) ? () async => await context.read<AuthCubit>().validator(context, formKey, phoneNumberController) : null,
                        child: [Status.success, Status.initialization].contains(state.status) ? Text(context.t.kContinue) : Transform.scale(scale: 0.5, child: CircularProgressIndicator(color: Color(0xffffffff))),
                      ),
                    );
                  },
                ),
                // dividerText(text: context.t.loginInWith),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   spacing: 30,
                //   children: [
                //     GestureDetector(
                //       onTap: () async => await context.read<AuthCubit>().signIn(),
                //       child: SvgPicture.asset('assets/images/yandex_id.svg'),
                //     ),
                //     GestureDetector(
                //       onTap: () async => null,
                //       child: Container(
                //         width: 42,
                //         height: 42,
                //         decoration: BoxDecoration(
                //           color: Colors.blueAccent,
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         child: Center(
                //           child: FaIcon(FontAwesomeIcons.telegram, size: 28, color: Colors.white),
                //         ),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () async => await context.read<AuthCubit>().telegram(),
                //       child: Container(
                //         width: 42,
                //         height: 42,
                //         decoration: BoxDecoration(
                //           color: Colors.black,
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         child: Center(
                //           child: SvgPicture.asset('assets/icons/user-key.svg', width: 32, theme: SvgTheme(currentColor: Colors.white),),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
