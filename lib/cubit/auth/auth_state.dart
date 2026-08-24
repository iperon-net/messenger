import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_state.mapper.dart';

enum AuthWorkflow { callpassword, moderationApplicationStore }

@MappableClass()
class AuthState with AuthStateMappable {
  final Status status;
  final Status networkStatus;
  final String error;
  final String redirectURI;

  final AuthWorkflow workflow;

  const AuthState({
    this.status = Status.initialization,
    this.networkStatus = Status.initialization,
    this.error = "",
    this.redirectURI = "",

    this.workflow = AuthWorkflow.callpassword,
  });
}
