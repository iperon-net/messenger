import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../utils.dart';

class AuthCallpasswordConfirmationCupertino extends StatefulWidget {
  const AuthCallpasswordConfirmationCupertino({super.key});

  @override
  State<AuthCallpasswordConfirmationCupertino> createState() =>
      _AuthCallpasswordConfirmationCupertino();
}

class _AuthCallpasswordConfirmationCupertino
    extends State<AuthCallpasswordConfirmationCupertino> {
  final formKey = GlobalKey<FormState>();
  final utils = getIt.get<Utils>();

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
    return BlocConsumer<
      AuthCallpasswordConfirmationCubit,
      AuthCallpasswordConfirmationState
    >(
      listenWhen: (previous, current) =>
          previous.redirectURI != current.redirectURI,
      listener: (context, state) {
        // Таймаут / ошибка / блокировка уводят обратно на /auth. Успех пока
        // без перехода — второй шаг входа (two-step) ещё не реализован.
        if (state.redirectURI != null) {
          context.go(state.redirectURI.toString());
        }
      },
      builder: (context, state) {
        return CupertinoPageScaffold(
          backgroundColor: CupertinoDynamicColor.withBrightness(
            color: Color(0xffffffff),
            darkColor: Color(0xff1b263b),
          ),
          navigationBar: CupertinoNavigationBar(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 50),
              child: Column(
                spacing: 20,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30, width: double.infinity),
                        SvgPicture.asset(
                          CupertinoTheme.brightnessOf(context) ==
                                  Brightness.light
                              ? 'assets/images/logo_light.svg'
                              : 'assets/images/logo_dark.svg',
                        ),
                        SizedBox(height: 30, width: double.infinity),
                        Text(
                          context.t.auth.confirmYourNumberDetail(
                            confirmationPhoneNumberRu: utils
                                .phoneNormalization(
                                  phoneNumber: state.confirmationPhoneNumber,
                                )
                                .international,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30, width: double.infinity),
                        Text(
                          context.t.auth.weAreExpectingYourCallWithin(
                            duration: utils.formatDuration(
                              Duration(seconds: state.tickerSecond),
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 50, width: double.infinity),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: CupertinoButton.filled(
                            onPressed: () async => await utils.makePhoneCall(
                              state.confirmationPhoneNumber,
                            ),
                            child: Text(context.t.auth.callForFree),
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
