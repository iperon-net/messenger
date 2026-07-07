import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di.dart';
import '../../logger.dart';
import '../../utils.dart';
import 'settings_two_step_verification_state.dart';

class SettingsTwoStepVerificationCubit extends Cubit<SettingsTwoStepVerificationState> {
  SettingsTwoStepVerificationCubit() : super(SettingsTwoStepVerificationState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final algorithmArgon2 = Argon2id(parallelism: 4, memory: 10000, iterations: 3, hashLength: 32);

  void setNextButton(bool value) => emit(state.copyWith(nextButton: value));

  Future<void> submit(String password) async {
    emit(state.copyWith(password: password, redirectURL: "/private_and_security/settings_two_step_verification/new_email"));
  }

}


// final nonce = utils.generateNonce(32);
//
// final newSecretKey = await algorithmArgon2.deriveKey(
//   secretKey: SecretKey(utf8.encode(rawPassword)),
//   nonce: nonce,
// );
//
// final newSecretKeyBytes = await newSecretKey.extractBytes();
//
// logger.debug(nonce.length);
// logger.debug(newSecretKeyBytes.length);
