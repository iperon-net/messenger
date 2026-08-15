import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_state.mapper.dart';

enum AuthWorkflow { callpassword, moderationApplicationStore }


@MappableClass()
class AuthState with AuthStateMappable {
  final Status status;
  final String? error;
  final AuthWorkflow workflow;
  final Uri? redirectURI;

  const AuthState({
    this.status = Status.initialization,
    this.error,
    this.workflow = AuthWorkflow.callpassword,
    this.redirectURI,
  });
}
