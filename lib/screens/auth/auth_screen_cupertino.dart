import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:convert/convert.dart' as convertor;
import 'package:go_router/go_router.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
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
    context.read<AuthCubit>().initialization();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
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
            padding: const EdgeInsets.fromLTRB(25, 40, 25, 50),
            child: Column(
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
                            placeholder: context.t.mobilePhone,
                            validator: (value) => context.read<AuthCubit>().validatorPhoneNumber(context, value),
                          ),
                        ),
                        // SizedBox(height: 30, width: double.infinity),
                      ],
                    ),
                  ),
                ),

                BlocConsumer<AuthCubit, AuthState>(
                    listener: (BuildContext context, AuthState state) {
                      if (state.error.isNotEmpty) return context.go("/auth");

                      if (state.status == Status.success && state.callPasswordSession.isNotEmpty){
                        Map<String, String> queryParams = {
                          'callPasswordSession': convertor.hex.encode(state.callPasswordSession),
                          'confirmationPhoneNumber': state.confirmationPhoneNumber,
                          'timeout': state.timeout.toString(),
                        };

                        String queryString = Uri(queryParameters: queryParams).query;
                        if(context.mounted) {
                          context.go("/auth/callpassword?$queryString");
                        }
                      }
                    },
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
              ],
            ),
          ),
        ),
      ),
    );
  }

}
