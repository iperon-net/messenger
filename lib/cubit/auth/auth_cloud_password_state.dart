import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_cloud_password_state.mapper.dart';

/// Фаза экрана облачного пароля на входе:
/// - [enterPassword] — ввод пароля (второй шаг после звонка-пароля);
/// - [recovery] — восстановление: код с email + новый пароль.
enum AuthCloudPasswordPhase { enterPassword, recovery }

@MappableClass()
class AuthCloudPasswordState with AuthCloudPasswordStateMappable {
  final Status status;
  // networkStatus == loading — запрос в полёте (спиннер на кнопке).
  final Status networkStatus;
  final String error;
  final String redirectURI;

  final List<int> confirmationSession;
  final AuthCloudPasswordPhase phase;
  // Остаток попыток после неверного пароля; -1 — не показывать.
  final int attemptsLeft;
  // Маскированный email, показывается в фазе восстановления.
  final String maskedEmail;

  const AuthCloudPasswordState({
    this.status = Status.initialization,
    this.networkStatus = Status.initialization,
    this.error = "",
    this.redirectURI = "",
    this.confirmationSession = const [],
    this.phase = AuthCloudPasswordPhase.enterPassword,
    this.attemptsLeft = -1,
    this.maskedEmail = "",
  });
}
