import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

import '../../cubit/app_cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

class WidgetWrapper extends StatefulWidget {
  final Widget child;
  const WidgetWrapper({super.key, required this.child});

  @override
  State<WidgetWrapper> createState() => _WidgetWrapper();
}


class _WidgetWrapper extends State<WidgetWrapper> with WidgetsBindingObserver {
  final _logger = getIt.get<Logger>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      await context.read<AppCubit>().viewTaskSwitching(true);
    } else if (state == AppLifecycleState.resumed) {
      await context.read<AppCubit>().viewTaskSwitching(false);
    } else if (state == AppLifecycleState.paused) {
      await context.read<AppCubit>().setPassCodeTimer((DateTime.now().millisecondsSinceEpoch / 1000).toInt());
    }
    _logger.debug(state.toString());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {

          if (state.passCode.isNotEmpty && state.passCodeTtl > 0 && state.passCodeTimer > 0) {
            final calculateTimer = (DateTime.now().millisecondsSinceEpoch / 1000).toInt() - (state.passCodeTimer).toInt();
            if (calculateTimer >= state.passCodeTtl) {
              return Scaffold(
                body: ScreenLock(
                  cancelButton: Text(context.t.settings.privacyAndSecurity.passcode.cancel),
                  title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
                  correctString: state.passCode,
                  onUnlocked: () async => await context.read<AppCubit>().setPassCodeTimer(0),
                  secretsConfig: SecretsConfig(
                    spacing: 15,
                    padding: const EdgeInsets.all(40),
                  ),
                ),
              );
            }
          } else if (state.passCode.isEmpty) {
            context.read<AppCubit>().setPassCodeTimer(0);
          }

          if (state.viewTaskSwitchingEnable == 1 && state.viewTaskSwitching) {
            return Blur(
              blur: 10,
              blurColor: CupertinoColors.transparent,
              colorOpacity: 0,
              child: widget.child,
            );
          } else {
            return widget.child;
          }
        }
    );
  }
}
