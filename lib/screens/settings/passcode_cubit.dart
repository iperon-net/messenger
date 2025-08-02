import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:messenger/repositories/repositories.dart';

import '../../crypto/crypto.dart';
import '../../cubit/constants.dart';
import '../../di.dart';
import '../../i18n/translations.g.dart';
import '../../logger.dart';

part 'passcode_cubit.freezed.dart';
part 'passcode_state.dart';

class PasscodeCubit extends Cubit<PasscodeState> {
  PasscodeCubit() : super(const PasscodeState());

  final _logger = getIt.get<Logger>();
  final _repositories = getIt.get<Repositories>();
  final _crypto = getIt.get<Crypto>();

  final inputController = InputController();

  Future<void> initialization() async {
    final settings = await _repositories.settingsDevice.getAllSettings();
    emit(state.copyWith(passCode: settings.passCode));
    _logger.debug(settings.toString());
  }

  void createPassCode(BuildContext context) {
    screenLockCreate(
      context: context,
      onConfirmed: (String value) async {
        final deviceInfo = DeviceInfoPlugin();

        String identifier = "";

        if (Platform.isAndroid) {
          final build = await deviceInfo.androidInfo;
          identifier = build.id;
        } else if (Platform.isIOS) {
          final data = await deviceInfo.iosInfo;
          identifier = data.identifierForVendor!;
        }

        final hexDigest = _crypto.sha256.hexDigest("$identifier:$value");
        await _repositories.settingsDevice.setPassCode(hexDigest);

        final settings = await _repositories.settingsDevice.getAllSettings();
        emit(state.copyWith(passCode: settings.passCode));
        if (context.mounted) Navigator.pop(context);
      },

      title: Text(context.t.settings.privacyAndSecurity.passcode.newPasscode),
      confirmTitle: Text(context.t.settings.privacyAndSecurity.passcode.confirmNewPasscode),
      cancelButton: Text(context.t.settings.privacyAndSecurity.passcode.cancel),
      secretsConfig: SecretsConfig(
        spacing: 15,
      ),

    );
  }
}
