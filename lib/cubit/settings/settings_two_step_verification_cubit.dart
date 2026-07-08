import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:emails_validator/emails_validator.dart';
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

  void reset() {
    emit(state.copyWith(redirectUrl: ""));
  }

  bool emailValidator({required String? email}) {
    if (email == null) return false;

    final isValid = EmailsValidator.validate(email);
    if (isValid) return true;
    return false;
  }

  Future<void> setPassword(String password) async {
    emit(state.copyWith(password: password, redirectUrl: "/settings/private_and_security/settings_two_step_verification/new_email"));
  }

  Future<void> setEmail(String email) async {
    emit(state.copyWith(email: email, redirectUrl: "/settings/private_and_security/settings_two_step_verification/new_email/email_code"));
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
