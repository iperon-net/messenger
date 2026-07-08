import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_two_step_verification_state.mapper.dart';

@MappableClass()
class SettingsTwoStepVerificationState with SettingsTwoStepVerificationStateMappable {
  final Status status;

  bool nextButton = false;
  String password = "";
  String email = "";
  String redirectUrl = "";

  SettingsTwoStepVerificationState({
    this.status = Status.initialization,
    this.nextButton = false,
    this.password = "",
    this.email = "",
    this.redirectUrl = "",
  });

}
