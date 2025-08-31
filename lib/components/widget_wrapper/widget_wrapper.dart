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

// ==========================================

/*
class _WidgetWrapper extends State<WidgetWrapper> with WidgetsBindingObserver {
  bool _isBlurred = false;
  bool _passCodeLock = false;
  String _passCode = "";

  final _repositories = getIt.get<Repositories>();
  final _logger = getIt.get<Logger>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.inactive) {
      setState(() {
        _isBlurred = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        _isBlurred = false;
      });
      final getAllSettings = await _repositories.settingsDevice.getAllSettings();
      _logger.debug("event = ${getAllSettings.toString()}");

      if(getAllSettings.passCodeLock == 1) {
        setState(() {
          _passCodeLock = true;
          _passCode = getAllSettings.passCode;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isBlurred){
      return Blur(
        blur: 10,
        blurColor: CupertinoColors.transparent,
        colorOpacity: 0,
        child: widget.child,
      );
    }
    return widget.child;

    // return BlocBuilder<AppCubit, AppState>(
    //   builder: (context, state) {
    //     if(widget.lock && _passCode.isNotEmpty && _passCodeLock) {
    //       return Scaffold(
    //         body: ScreenLock(
    //           cancelButton: Text(context.t.settings.privacyAndSecurity.passcode.cancel),
    //           title: Text(context.t.settings.privacyAndSecurity.passcode.passcode),
    //           correctString: _passCode,
    //           onUnlocked: () async {
    //             setState(() {
    //               _passCodeLock = false;
    //             });
    //             await _repositories.settingsDevice.setPassCodeLock(0);
    //           },
    //           secretsConfig: SecretsConfig(
    //             spacing: 15,
    //             padding: const EdgeInsets.all(40),
    //           ),
    //         ),
    //       );
    //     }
    //
    //     if (_isBlurred){
    //       return Blur(
    //         blur: 10,
    //         blurColor: CupertinoColors.transparent,
    //         colorOpacity: 0,
    //         child: widget.child,
    //       );
    //     }
    //     return widget.child;
    //   }
    // );
  }

}
*/

/*
class WidgetWrapper extends StatefulWidget {
  final Widget child;

  const WidgetWrapper({super.key, required this.child});

  @override
  State<WidgetWrapper> createState() =>  _WidgetWrapperState();
}

class _WidgetWrapperState extends State<WidgetWrapper> with WidgetsBindingObserver {
  bool _isBlurred = false;
  bool _isLock = true;

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

    if (state == AppLifecycleState.inactive) {
      await context.read<AppCubit>().setPassCodeTimer((DateTime.now().millisecondsSinceEpoch / 1000).toInt());
    }

    if (state == AppLifecycleState.resumed) {
      final getAllSettings = await _repositories.settingsDevice.getAllSettings();

      if (getAllSettings.passCode.isEmpty){
        setState(() {
          _isLock = false;
        });
        return;
      }

      if (getAllSettings.passCodeTtl <= 0){
        setState(() {
          _isLock = false;
        });
        return;
      }

      final calculateTimer = (DateTime.now().millisecondsSinceEpoch / 1000).toInt() - (getAllSettings.passCodeTimer).toInt();
      _logger.debug("calculateTimer = ${calculateTimer.toString()}");
      _logger.debug("passCodeTtl = ${getAllSettings.passCodeTtl.toString()}");

      if (calculateTimer >= getAllSettings.passCodeTtl) {
        setState(() {
          _isLock = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        _logger.info("Lock application $_isLock");

        if(_isLock && state.passCode.isNotEmpty) {
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
