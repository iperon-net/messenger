import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_state.mapper.dart';

@MappableClass()
class AuthState with AuthStateMappable {
  final Status status;
  final String error;

  const AuthState({
    this.status = Status.initialization,
    this.error = "",
  });
}
