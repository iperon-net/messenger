import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/constants.dart';
import 'package:messenger/cubit/main_cubit.dart';
import 'package:messenger/utils.dart';

import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';
import 'auth_callpassword_cubit.dart';

class AuthCallPasswordCupertinoScreen extends StatefulWidget {
  final String callPasswordSession;
  final String confirmationPhoneNumber;
  final double timeout;

  const AuthCallPasswordCupertinoScreen({
    super.key,
    required this.callPasswordSession,
    required this.confirmationPhoneNumber,
    required this.timeout,
  });

  @override
  State<AuthCallPasswordCupertinoScreen> createState() => _AuthCallPasswordCupertinoScreen();
}

class _AuthCallPasswordCupertinoScreen extends State<AuthCallPasswordCupertinoScreen> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();

  late final Ticker _ticker;
  late final AuthCallpasswordCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = context.read<AuthCallpasswordCubit>();

    WidgetsBinding.instance.addObserver(this);

    _cubit.callPassword(
      callPasswordSession: widget.callPasswordSession,
      timeout: widget.timeout,
    );

    // Start ticker
    _ticker = createTicker((Duration elapsed) {
      if (elapsed.inSeconds >= widget.timeout.toInt()) {
        _ticker.stop();
        context.go("/auth");
        return;
      }
      _cubit.setTickerSecond(widget.timeout.toInt() - elapsed.inSeconds);
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.stop();

    _cubit.subscriptionCallPassword.cancel();
    _cubit.streamCallPassword.cancel();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:

        _cubit.callPassword(
          callPasswordSession: widget.callPasswordSession,
          timeout: widget.timeout,
        );

        break;
      case AppLifecycleState.paused:
        _cubit.subscriptionCallPassword.cancel();
        _cubit.streamCallPassword.cancel();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.withBrightness(
        color: Color(0xffffffff),
        darkColor: Color(0xff1b263b),
      ),
      navigationBar: CupertinoNavigationBar(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 50),
          child: Column(
            spacing: 30,
            children: [
              SvgPicture.asset(MediaQuery.of(context).platformBrightness == Brightness.light ? 'assets/images/logo_light.svg' : 'assets/images/logo_dark.svg'),
              Text(context.t.confirmYourNumberDetail(
                  confirmationPhoneNumberRu: utils.phoneFormat(phoneNumber: widget.confirmationPhoneNumber).international),
                  textAlign: TextAlign.center
              ),
              BlocConsumer<AuthCallpasswordCubit, AuthCallpasswordState>(
                listener: (BuildContext context, AuthCallpasswordState state) {
                  if (state.error.isNotEmpty) return context.go("/auth");
                  if (state.status == Status.success && state.confirmationSession.isEmpty && !state.isBlocked && state.user.userID != ""){
                    context.read<MainCubit>().setUser(user: state.user);
                    return context.go("/");
                  }
                },
                builder: (context, state) {
                  return Text(context.t.weAreExpectingYourCallWithin(
                    duration: utils.formatDuration(Duration(seconds: state.tickerSecond))),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton.filled(
                  onPressed: () async => await utils.makePhoneCall(widget.confirmationPhoneNumber),
                  child: Text(context.t.callForFree),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

}
