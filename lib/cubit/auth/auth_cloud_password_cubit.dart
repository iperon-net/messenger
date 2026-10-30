import 'package:bloc/bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessage;

import '../../api.dart';
import '../../constants.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../utils.dart';
import '../../protobuf.dart';
import 'auth_login_completer.dart';
import 'auth_cloud_password_state.dart';

/// Второй шаг входа — облачный пароль (двухшаговая проверка). Все pre-auth: сессии
/// ещё нет, поэтому обычный `api.client.unary` (открытый protobuf), как в
/// call-password flow. Пароль проверяется по OPAQUE ([cloudPasswordClient]) — на
/// сервер не уходит. При успехе вход завершает общий [AuthLoginCompleter].
class AuthCloudPasswordCubit extends Cubit<AuthCloudPasswordState> {
  AuthCloudPasswordCubit() : super(const AuthCloudPasswordState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();

  void initialization({required String confirmationSession}) {
    emit(state.copyWith(status: Status.success, confirmationSession: utils.hexToBytes(confirmationSession)));
  }

  /// Проверка облачного пароля: KE1 → KE2, неверный пароль виден уже тут (KE3
  /// не шлём), иначе KE3. Попытку сервер засчитывает на KE1 и сообщает остаток;
  /// попытки кончились (или лимит аккаунта) — сессия сброшена, уходим на /auth.
  Future<void> submit(String password) async {
    if (password.isEmpty) {
      emit(state.copyWith(error: "cloudPassword.passwordRequired"));
      return;
    }

    emit(state.copyWith(networkStatus: Status.loading, error: "", attemptsLeft: -1));

    final client = cloudPasswordClient();
    final (ke1, login) = client.loginStart(cloudPasswordBytes(password));
    final start = await _unary(
      MessageType.AUTH_CLOUD_PASSWORD_START,
      AuthCloudPasswordStart_Request(confirmationSession: state.confirmationSession, ke1: ke1),
    );
    if (start == null) return;
    final started = AuthCloudPasswordStart_Response.fromBuffer(start);

    final OpaqueLoginResult result;
    try {
      result = await client.loginFinish(login, started.ke2);
    } on OpaqueException catch (e) {
      if (e.error != OpaqueError.wrongPassword) {
        emit(state.copyWith(networkStatus: Status.success, error: "cloudPassword.invalidMessage"));
        return;
      }
      if (started.attemptsLeft <= 0) {
        emit(
          state.copyWith(networkStatus: Status.success, error: "cloudPassword.tooManyAttempts", redirectURI: Uri.parse("/auth").toString()),
        );
        return;
      }
      emit(state.copyWith(networkStatus: Status.success, error: "cloudPassword.wrongPassword", attemptsLeft: started.attemptsLeft));
      return;
    }

    final finish = await _unary(
      MessageType.AUTH_CLOUD_PASSWORD_FINISH,
      AuthCloudPasswordFinish_Request(confirmationSession: state.confirmationSession, ke3: result.ke3),
    );
    if (finish == null) return;

    await _completeLogin();
  }

  /// «Забыли пароль?»: переход к вводу email восстановления (без запроса к
  /// серверу — код запросим после ввода адреса).
  void startRecovery() => emit(state.copyWith(phase: AuthCloudPasswordPhase.enterEmail, error: ""));

  /// Ввод email восстановления. Сервер шлёт код только если адрес совпадает с
  /// привязанным, но ответ всегда одинаков — поэтому вне зависимости от совпадения
  /// переходим к вводу кода и нового пароля (анти-энумерация email в базе).
  Future<void> submitRecoveryEmail(String email) async {
    if (email.isEmpty) {
      emit(state.copyWith(error: "cloudPassword.emailRequired"));
      return;
    }
    if (!await utils.hasNetwork()) {
      emit(state.copyWith(error: "grpcError.unableConnectServer"));
      return;
    }

    emit(state.copyWith(networkStatus: Status.loading, error: ""));

    final request = Message(
      messageType: MessageType.AUTH_CLOUD_PASSWORD_RECOVERY,
      message: AuthCloudPasswordRecovery_Request(confirmationSession: state.confirmationSession, email: email).writeToBuffer(),
    );

    final grpcError = await api.call(() async {
      await api.client.unary(request);
    });

    if (grpcError.status == APIStatus.error) {
      final redirect = grpcError.statusCode == StatusCode.unauthenticated ? Uri.parse("/auth").toString() : "";
      emit(state.copyWith(networkStatus: Status.success, error: grpcError.error, redirectURI: redirect));
      return;
    }

    emit(state.copyWith(networkStatus: Status.success, phase: AuthCloudPasswordPhase.recovery, pendingEmail: email, error: ""));
  }

  /// Подтверждение восстановления: код из письма, затем регистрация нового
  /// пароля по OPAQUE. При успехе сервер помечает сессию пройденной — завершаем
  /// вход.
  Future<void> recoveryConfirm({required String code, required String newPassword}) async {
    if (code.isEmpty && !state.recoveryCodeAccepted) {
      emit(state.copyWith(error: "cloudPassword.codeRequired"));
      return;
    }
    if (newPassword.isEmpty) {
      emit(state.copyWith(error: "cloudPassword.passwordRequired"));
      return;
    }

    emit(state.copyWith(networkStatus: Status.loading, error: ""));

    if (!state.recoveryCodeAccepted) {
      final confirmed = await _unary(
        MessageType.AUTH_CLOUD_PASSWORD_RECOVERY_CONFIRM,
        AuthCloudPasswordRecoveryConfirm_Request(confirmationSession: state.confirmationSession, code: code),
      );
      if (confirmed == null) return;
      emit(state.copyWith(recoveryCodeAccepted: true));
    }

    final client = cloudPasswordClient();
    final (request, registration) = client.registrationStart(cloudPasswordBytes(newPassword));
    final start = await _unary(
      MessageType.AUTH_CLOUD_PASSWORD_REGISTER_START,
      AuthCloudPasswordRegisterStart_Request(confirmationSession: state.confirmationSession, registrationRequest: request),
    );
    if (start == null) return;

    final OpaqueRegistrationResult result;
    try {
      result = await client.registrationFinish(
        registration,
        AuthCloudPasswordRegisterStart_Response.fromBuffer(start).registrationResponse,
      );
    } on OpaqueException {
      emit(state.copyWith(networkStatus: Status.success, error: "cloudPassword.invalidMessage"));
      return;
    }

    final finish = await _unary(
      MessageType.AUTH_CLOUD_PASSWORD_REGISTER_FINISH,
      AuthCloudPasswordRegisterFinish_Request(confirmationSession: state.confirmationSession, record: result.record),
    );
    if (finish == null) return;

    await _completeLogin();
  }

  /// Pre-auth запрос: payload ответа или null (ошибка уже в state). Истёкшая
  /// сессия (`Unauthenticated`) или исчерпанные попытки (`ResourceExhausted`) —
  /// вход начинается заново, на /auth.
  Future<List<int>?> _unary(MessageType type, GeneratedMessage request) async {
    late Message response;
    final grpcError = await api.call(() async {
      response = await api.client.unary(Message(messageType: type, message: request.writeToBuffer()));
    });
    if (grpcError.status == APIStatus.error) {
      final restart = grpcError.statusCode == StatusCode.unauthenticated || grpcError.statusCode == StatusCode.resourceExhausted;
      emit(
        state.copyWith(networkStatus: Status.success, error: grpcError.error, redirectURI: restart ? Uri.parse("/auth").toString() : ""),
      );
      return null;
    }

    return response.message;
  }

  /// Завершение входа общей последовательностью (см. [AuthLoginCompleter]).
  Future<void> _completeLogin() async {
    final completion = await AuthLoginCompleter().complete(state.confirmationSession);
    if (completion.redirectURI.isNotEmpty) {
      emit(state.copyWith(networkStatus: Status.success, error: completion.error, redirectURI: completion.redirectURI));
    } else {
      emit(state.copyWith(networkStatus: Status.success, error: completion.error));
    }
  }
}
