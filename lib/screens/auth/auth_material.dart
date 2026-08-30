import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/utils.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import '../../settings.dart';

class AuthMaterialScreen extends StatefulWidget {
  const AuthMaterialScreen({super.key});

  @override
  State<AuthMaterialScreen> createState() => _AuthMaterialScreen();
}

class _AuthMaterialScreen extends State<AuthMaterialScreen> {
  final logger = getIt.get<Logger>();
  final settings = getIt.get<Settings>();
  final utils = getIt.get<Utils>();

  final formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  final phoneNumberFocus = FocusNode();
  String? serverError;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.error.isNotEmpty) {
          try {
            serverError = context.t[state.error];
          } catch (e) {
            serverError = context.t.grpcError.unknownError;
          }
          formKey.currentState?.validate();
        } else if (state.status == Status.success && state.redirectURI.isNotEmpty) {
          context.go(state.redirectURI.toString());
        }
      },
      builder: (context, state) {
        final isReady = [Status.success, Status.initialization].contains(state.status);

        return Scaffold(
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
                            SvgPicture.asset(
                              Theme.of(context).brightness == Brightness.light
                                  ? 'assets/images/logo_light.svg'
                                  : 'assets/images/logo_dark.svg',
                            ),
                            const SizedBox(height: 30, width: double.infinity),
                            TextFormField(
                              controller: phoneNumberController,
                              focusNode: phoneNumberFocus,
                              autocorrect: true,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [PhoneInputFormatter()],
                              autofillHints: const [AutofillHints.telephoneNumber],
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.phone),
                                labelText: context.t.common.mobilePhone,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                final error = switch (context.read<AuthCubit>().validatePhoneNumber(value)) {
                                  PhoneValidationError.empty => context.t.screenAuth.enterYourMobilePhoneNumber,
                                  PhoneValidationError.notAllowRegion =>
                                    context.t.screenAuth.currentlyWeOnlySupportPhoneNumbersFromRussianMobileOperators,
                                  null => null,
                                };
                                return error ?? serverError;
                              },
                            ),

                            if (kDebugMode) ...[
                              const SizedBox(height: 30),
                              FilledButton.tonal(
                                child: Text(t.screenAuth.insertDebugPhone),
                                onPressed: () {
                                  phoneNumberController.text = utils
                                      .phoneNormalization(phoneNumber: settings.phoneNumberModerationApplicationStore)
                                      .international;
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: isReady
                            ? () async {
                                serverError = null;
                                if (formKey.currentState!.validate()) {
                                  await context.read<AuthCubit>().onPressed(phoneNumberController.text);
                                }
                              }
                            : null,
                        child: isReady
                            ? Text(context.t.screenAuth.kContinue)
                            : const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xffffffff)),
                              ),
                      ),
                    ),
                    DividerTextWidget(text: context.t.screenAuth.signInWith),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 30,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            final result = await context.read<AuthCubit>().yandexSignIn();
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(result))],
                                ),
                              );
                            }
                          },
                          child: SvgPicture.asset('assets/images/yandex_id.svg'),
                        ),
                      ],
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
