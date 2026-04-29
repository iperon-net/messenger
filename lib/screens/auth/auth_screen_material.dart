import 'package:flutter/material.dart';
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
    context.read<AuthCubit>().initialization();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) phoneNumberFocus.requestFocus();
      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    logger.debug("initState auth");
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
    logger.debug("dispose auth");
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
                          errorMaxLines: 5,
                        ),
                        inputFormatters: [
                          PhoneInputFormatter(),
                        ],
                        textInputAction: TextInputAction.next,
                        validator: (value) => context.read<AuthCubit>().validatorPhoneNumber(context, value),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (BuildContext context, AuthState state) {
                    if (state.error.isNotEmpty) return context.go("/auth");

                    if (state.status == Status.success && state.callPasswordSession.isNotEmpty){
                      Map<String, String> queryParams = {
                        'callPasswordSession': convertor.hex.encode(state.callPasswordSession),
                        'confirmationPhoneNumber': state.confirmationPhoneNumber.toString(),
                        'timeout': state.timeout.toString(),
                      };

                      String queryString = Uri(queryParameters: queryParams).query;
                      if(context.mounted) {
                        context.go("/auth/callpassword?$queryString");
                      }
                    }

                  },
                  builder: (context, AuthState state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: [Status.success, Status.initialization].contains(state.status) ? () async => await context.read<AuthCubit>().validator(context, formKey, phoneNumberController) : null,
                        child: [Status.success, Status.initialization].contains(state.status) ? Text(context.t.kContinue) : Transform.scale(scale: 0.5, child: CircularProgressIndicator(color: Color(0xffffffff))),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
