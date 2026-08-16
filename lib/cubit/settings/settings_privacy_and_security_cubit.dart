import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import 'settings_privacy_and_security_state.dart';

class SettingsPrivacyAndSecurityCubit extends Cubit<SettingsPrivacyAndSecurityState> {
  SettingsPrivacyAndSecurityCubit() : super(SettingsPrivacyAndSecurityState());

  final logger = getIt.get<Logger>();

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));

    // Insert code initialization

    emit(state.copyWith(status: Status.success));
  }
}
