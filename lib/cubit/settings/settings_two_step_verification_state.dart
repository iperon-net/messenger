import 'package:dart_mappable/dart_mappable.dart';

part 'settings_two_step_verification_state.mapper.dart';

@MappableClass()
class SettingsTwoStepVerificationState with SettingsTwoStepVerificationStateMappable {
  bool nextButton = false;

  SettingsTwoStepVerificationState({
    this.nextButton = false,
  });

}
