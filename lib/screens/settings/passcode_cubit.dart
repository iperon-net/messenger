import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../cubit/constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

part 'passcode_cubit.freezed.dart';
part 'passcode_state.dart';

class PasscodeCubit extends Cubit<PasscodeState> {
  PasscodeCubit() : super(const PasscodeState());

  final _logger = getIt.get<Logger>();

  void createPassCode(BuildContext context) {
    screenLockCreate(
      context: context,
      onConfirmed: (String value) async {
        _logger.debug("new passcode $value");
      },
      title: Text(context.t.settings.privacyAndSecurity.passcode.newPasscode),
      confirmTitle: Text(context.t.settings.privacyAndSecurity.passcode.confirmNewPasscode),
      cancelButton: Text(context.t.settings.privacyAndSecurity.passcode.cancel),
      secretsConfig: SecretsConfig(
        spacing: 15, // or spacingRatio
      ),
    );
  }

}
