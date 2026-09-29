import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_cloud_password_state.mapper.dart';

/// Фаза экрана облачного пароля на входе:
/// - [enterPassword] — ввод пароля (второй шаг после звонка-пароля);
/// - [enterEmail] — ввод email восстановления (код шлётся только при совпадении);
/// - [recovery] — восстановление: код с email + новый пароль.
enum AuthCloudPasswordPhase { enterPassword, enterEmail, recovery }

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
  // Email, введённый пользователем на шаге восстановления (для показа в подсказке
  // «код отправлен на …»). Не раскрывает чужие адреса — это то, что ввёл сам юзер.
  final String pendingEmail;

  const AuthCloudPasswordState({
    this.status = Status.initialization,
    this.networkStatus = Status.initialization,
    this.error = "",
    this.redirectURI = "",
    this.confirmationSession = const [],
    this.phase = AuthCloudPasswordPhase.enterPassword,
    this.attemptsLeft = -1,
    this.maskedEmail = "",
    this.pendingEmail = "",
  });
}
