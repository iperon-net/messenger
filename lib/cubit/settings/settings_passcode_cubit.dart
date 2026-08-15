import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import '../../repositories/repositories.dart';
import 'settings_passcode_state.dart';

class SettingsPasscodeCubit extends Cubit<SettingsPasscodeState> {
  SettingsPasscodeCubit() : super(SettingsPasscodeState());

  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  // Должен совпадать с параметрами хеширования в SettingsPasscodeCreateCubit,
  // иначе байты введённого PIN не сойдутся с сохранённым хешем.
  final algorithm = Argon2id(
    parallelism: 4,
    memory: 10000,
    iterations: 3,
    hashLength: 32,
  );

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    final settings = await repositories.settingsDevice.getAll();

    logger.debug(settings.passcodeAutoLock);

    emit(
      state.copyWith(
        status: Status.success,
        passcode: settings.passcode,
        isBiometric: settings.passcodeBiometric,
        autoLockSeconds: settings.passcodeAutoLock,
      ),
    );
  }

  /// Прогоняет введённый PIN через тот же Argon2id (nonce: []) и сравнивает
  /// полученный хеш с сохранённым в state.passcode.
  Future<bool> verifyPasscode(String passcode) async {
    if (state.passcode.isEmpty) return false;
    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(passcode)),
      nonce: [],
    );
    final passcodeBytes = await secretKey.extractBytes();

    final unlocked = listEquals(passcodeBytes, state.passcode);
    emit(state.copyWith(unlocked: unlocked));
    return unlocked;
  }

  void setUnlocked(bool unlocked) {
    emit(state.copyWith(unlocked: unlocked));
  }

  Future<void> setAutoLock({required int seconds}) async {
    await repositories.settingsDevice.setPasscodeAutoLock(seconds: seconds);
    emit(state.copyWith(autoLockSeconds: seconds));
  }

  Future<void> setPasscode({required List<int> passcode}) async {
    await repositories.settingsDevice.setPasscode(passcode);
    emit(state.copyWith(passcode: passcode));
  }

  Future<void> turnOff() async {
    await repositories.settingsDevice.setPasscode([]);
    emit(state.copyWith(unlocked: false, passcode: []));
  }

  Future<void> setBiometric({required bool biometric}) async {
    await repositories.settingsDevice.setPasscodeBiometric(
      biometric: biometric,
    );
    emit(state.copyWith(isBiometric: biometric));
  }
}
