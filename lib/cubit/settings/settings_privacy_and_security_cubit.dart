import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import '../../utils.dart';
import 'settings_privacy_and_security_state.dart';

class SettingsPrivacyAndSecurityCubit extends Cubit<SettingsPrivacyAndSecurityState> {
  SettingsPrivacyAndSecurityCubit() : super(SettingsPrivacyAndSecurityState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    final isBiometricAvailable = await utils.isBiometricAvailable();
    emit(state.copyWith(status: Status.success, isBiometricAvailable: isBiometricAvailable));
  }
}
