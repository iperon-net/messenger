import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_sms_state.mapper.dart';

@MappableClass()
class AuthSmsState with AuthSmsStateMappable {
  final Status status;
  final String error;

  const AuthSmsState({
    this.status = Status.initialization,
    this.error = "",
  });
}
