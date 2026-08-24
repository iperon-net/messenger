import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_callpassword_confirmation_state.mapper.dart';

/// Итог проверки звонка-пароля.
///
/// - [waiting] — стрим открыт, ждём, пока пользователь совершит звонок и сервер
///   подтвердит его (промежуточное состояние, экран показывает таймер);
/// - [success] — сервер подтвердил звонок, в state лежат [confirmationSession]
///   и [hasTwoStepVerification] для следующего шага;
/// - [error] — сервер вернул ошибку (см. [error]);
/// - [blocked] — номер/сессия заблокированы (`isBlocked`);
/// - [timeout] — истёк таймер ожидания звонка.
enum AuthCallPasswordConfirmationResult { waiting, success, error, blocked, timeout }

@MappableClass()
class AuthCallpasswordConfirmationState with AuthCallpasswordConfirmationStateMappable {
  final Status status;
  final Status networkStatus;
  final String error;
  final String redirectURI;

  final List<int> callPasswordSession;
  final String confirmationPhoneNumber;
  final int timeout;
  final int tickerSecond;
  final AuthCallPasswordConfirmationResult result;
  final List<int> confirmationSession;
  final bool hasTwoStepVerification;

  const AuthCallpasswordConfirmationState({
    this.status = Status.initialization,
    this.networkStatus = Status.initialization,
    this.error = "",
    this.redirectURI = "",

    this.callPasswordSession = const [],
    this.confirmationPhoneNumber = "",
    this.timeout = 0,
    this.tickerSecond = 0,
    this.result = AuthCallPasswordConfirmationResult.waiting,
    this.confirmationSession = const [],
    this.hasTwoStepVerification = false,
  });
}
