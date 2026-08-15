import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_privacy_and_security_state.mapper.dart';

@MappableClass()
class SettingsPrivacyAndSecurityState with SettingsPrivacyAndSecurityStateMappable {
  final Status status;

  const SettingsPrivacyAndSecurityState({
    this.status = Status.initialization,
  });
}
