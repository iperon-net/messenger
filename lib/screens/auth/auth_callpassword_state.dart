import 'package:dart_mappable/dart_mappable.dart';
import 'package:messenger/models/models.dart';

import '../../constants.dart';
import '../../models/user.dart';

part 'auth_callpassword_state.mapper.dart';

@MappableClass()
class AuthCallpasswordState with AuthCallpasswordStateMappable {
  final Status status;
  final String error;
  final List<int> confirmationSession;
  final int tickerSecond;
  final bool isBlocked;
  final bool hasCloudPassword;
  final User user;
  final Session session;

  const AuthCallpasswordState({
    this.status = Status.initialization,
    this.error = "",
    this.confirmationSession = const [],
    this.tickerSecond = 0,
    this.isBlocked = false,
    this.hasCloudPassword = false,
    this.user = const User(),
    this.session = const Session(),
  });
}
