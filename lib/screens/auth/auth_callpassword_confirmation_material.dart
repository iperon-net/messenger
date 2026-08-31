import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../utils.dart';

class AuthCallpasswordConfirmationMaterial extends StatefulWidget {
  const AuthCallpasswordConfirmationMaterial({super.key});

  @override
  State<AuthCallpasswordConfirmationMaterial> createState() => _AuthCallpasswordConfirmationMaterial();
}

class _AuthCallpasswordConfirmationMaterial extends State<AuthCallpasswordConfirmationMaterial> {
  final formKey = GlobalKey<FormState>();
  final utils = getIt.get<Utils>();
  String? error;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCallpasswordConfirmationCubit, AuthCallpasswordConfirmationState>(
      listenWhen: (previous, current) => previous.redirectURI != current.redirectURI || previous.error != current.error,
      listener: (context, state) async {
        // Таймаут / ошибка / блокировка уводят обратно на /auth. Успех пока
        // без перехода — второй шаг входа (two-step) ещё не реализован.
        if (state.redirectURI.toString().isNotEmpty) {
          context.go(state.redirectURI.toString());
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Color(0xFF1B263B)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 50),
              child: Column(
                spacing: 20,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30, width: double.infinity),
                        SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg',
                        ),
                        const SizedBox(height: 30, width: double.infinity),
                        Text(
                          context.t.screenAuthCallpasswordConfirmation.confirmYourNumberDetail(
                            confirmationPhoneNumberRu: utils.phoneNormalization(phoneNumber: state.confirmationPhoneNumber).international,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30, width: double.infinity),
                        Text(
                          context.t.screenAuthCallpasswordConfirmation.weAreExpectingYourCallWithin(
                            duration: utils.formatDuration(Duration(seconds: state.tickerSecond)),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50, width: double.infinity),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            onPressed: () async => await utils.makePhoneCall(state.confirmationPhoneNumber),
                            child: Text(context.t.screenAuthCallpasswordConfirmation.callForFree),
                          ),
                        ),
                      ],
                    ),
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
