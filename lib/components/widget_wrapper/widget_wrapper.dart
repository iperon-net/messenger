import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:messenger/repositories/repositories.dart';

import '../../cubit/app_cubit.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';


class WidgetWrapper extends StatefulWidget {
  final Widget child;

  const WidgetWrapper({super.key, required this.child});

  @override
  State<WidgetWrapper> createState() =>  _WidgetWrapperState();
}

class _WidgetWrapperState extends State<WidgetWrapper> with WidgetsBindingObserver {
  bool _isBlurred = false;
  bool _isLock = false;

  final _logger = getIt.get<Logger>();
  final _repositories = getIt.get<Repositories>();

  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().initialization();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _isBlurred = state == AppLifecycleState.inactive || state == AppLifecycleState.paused;
    });

    if (state == AppLifecycleState.paused) {
      await context.read<AppCubit>().setPassCodeTimer((DateTime.now().millisecondsSinceEpoch / 1000).toInt());
    }

    if (state == AppLifecycleState.resumed) {
      final getAllSettings = await _repositories.settingsDevice.getAllSettings();
      _logger.debug(getAllSettings.toString());

      if (getAllSettings.passCodeTtl > 0 && (DateTime.now().millisecondsSinceEpoch / 1000).toInt() - (getAllSettings.passCodeTimer).toInt() >= getAllSettings.passCodeTtl) {
        _isLock = true;
      }
    }

  }


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {

        if(_isLock) {
          _logger.info("Lock application");
          return Scaffold(
            body: ScreenLock(
              cancelButton: Text(context.t.settings.privacyAndSecurity.passcode.cancel),
              title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
              correctString: state.passCode,
              onUnlocked: () async {
                setState(() {
                  _isLock = false;
                });
              },
              secretsConfig: SecretsConfig(
                spacing: 15,
                padding: const EdgeInsets.all(40),
              ),
              useBlur: false,
            ),
          );
        }

        if (_isBlurred){
          return Blur(
            blur: 10,
            blurColor: CupertinoColors.transparent,
            colorOpacity: 0,
            child: widget.child,
          );
        }

        return widget.child;
      }
    );

  }
}


/*
class WidgetWrapper extends StatefulWidget {
  final Widget child;

  const WidgetWrapper({super.key, required this.child});

  @override
  State<WidgetWrapper> createState() =>  _WidgetWrapperState();
}

class _WidgetWrapperState extends State<WidgetWrapper> with WidgetsBindingObserver {
  bool _isBlurred = false;

  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().initialization();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // result.copyWith(passCoodeExpire: DateTime.now().microsecondsSinceEpoch - result.passCodeTimer);
  final _logger = getIt.get<Logger>();
  final _repositories = getIt.get<Repositories>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {
      _isBlurred = state == AppLifecycleState.inactive || state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if(context.mounted) {
    //   screenLock(
    //       context: context,
    //       correctString: '1234',
    //       canCancel: false,
    //   );
    // }
    final appLifecycleListener = AppLifecycleListener(
      onPause: () async => await context.read<AppCubit>().setPassCodeTimer((DateTime.now().millisecondsSinceEpoch / 1000).toInt()),
      onShow: () async {
      },
    );

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final logger = getIt.get<Logger>();

        if (state.passCodeTtl > 0 && (DateTime.now().millisecondsSinceEpoch / 1000).toInt() - (state.passCodeTimer).toInt() >= 3) {
          logger.info("Look application");
        }

        if (_isBlurred){
          return Blur(
            blur: 8,
            blurColor: CupertinoColors.transparent,
            colorOpacity: 0.1,
            child: widget.child,
          );
        }

        return widget.child;
      }
    );

  }
}


 */
