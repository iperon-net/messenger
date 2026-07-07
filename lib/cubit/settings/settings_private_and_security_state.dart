import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_private_and_security_state.mapper.dart';

@MappableClass()
class SettingsPrivateAndSecurityState with SettingsPrivateAndSecurityStateMappable {
  final Status status;

  const SettingsPrivateAndSecurityState({
    this.status = Status.initialization,
  });
}
