import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_two_step_verification_state.dart';

class SettingsTwoStepVerificationCubit extends Cubit<SettingsTwoStepVerificationState> {
  SettingsTwoStepVerificationCubit() : super(SettingsTwoStepVerificationState());

  void setNextButton(bool value) => emit(state.copyWith(nextButton: value));

}
