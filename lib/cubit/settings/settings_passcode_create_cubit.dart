import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptography/cryptography.dart';
import 'package:messenger/repositories.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import 'settings_passcode_create_state.dart';

class SettingsPasscodeCreateCubit extends Cubit<SettingsPasscodeCreateState> {
  SettingsPasscodeCreateCubit() : super(SettingsPasscodeCreateState());

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();
  final algorithm = Argon2id(parallelism: 4, memory: 10000, iterations: 3, hashLength: 32);

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    emit(state.copyWith(status: Status.success));
  }

  Future<void> setPasscode({required String passcode}) async {
    final secretKey = await algorithm.deriveKey(secretKey: SecretKey(utf8.encode(passcode)), nonce: []);
    final passcodeBytes = await secretKey.extractBytes();
    await repositories.settingsDevice.setPasscode(passcodeBytes);
    emit(state.copyWith(passcode: passcodeBytes));
  }

}
