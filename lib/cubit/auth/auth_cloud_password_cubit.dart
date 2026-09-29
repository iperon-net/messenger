import 'package:bloc/bloc.dart';
import 'package:grpc/grpc.dart';

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
/// call-password flow. Клиент шлёт pre-hash пароля (`cloudPasswordHash`), не
/// plaintext. При успехе вход завершает общий [AuthLoginCompleter].
class AuthCloudPasswordCubit extends Cubit<AuthCloudPasswordState> {
  AuthCloudPasswordCubit() : super(const AuthCloudPasswordState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();

  void initialization({required String confirmationSession}) {
    emit(state.copyWith(status: Status.success, confirmationSession: utils.hexToBytes(confirmationSession)));
  }

  /// Проверка облачного пароля. Неверный пароль — не ошибка транспорта: сервер
  /// возвращает `success=false` + `attemptsLeft` в payload; при 0 попыток сессия
  /// уже инвалидирована — уходим на /auth.
  Future<void> submit(String password) async {
    if (password.isEmpty) {
      emit(state.copyWith(error: "cloudPassword.passwordRequired"));
      return;
    }

    emit(state.copyWith(networkStatus: Status.loading, error: "", attemptsLeft: -1));

    final pwHash = await cloudPasswordHash(password);

    final request = Message(
      messageType: MessageType.AUTH_CLOUD_PASSWORD,
      message: AuthCloudPassword_Request(confirmationSession: state.confirmationSession, pwHash: pwHash).writeToBuffer(),
    );

    late Message response;
    final grpcError = await api.call(() async {
      response = await api.client.unary(request);
    });

    if (grpcError.status == APIStatus.error) {
      // Истёкшая/битая confirmationSession (Unauthenticated) — начинаем заново.
      final redirect = grpcError.statusCode == StatusCode.unauthenticated ? Uri.parse("/auth").toString() : "";
      emit(state.copyWith(networkStatus: Status.success, error: grpcError.error, redirectURI: redirect));
      return;
    }

    final result = AuthCloudPassword_Response.fromBuffer(response.message);

    if (result.success) {
      await _completeLogin();
      return;
    }

    // Неверный пароль.
    if (result.attemptsLeft <= 0) {
      // Попытки исчерпаны, сессия сброшена сервером — на /auth.
      emit(
        state.copyWith(
          networkStatus: Status.success,
          error: result.hasError() ? result.error : "cloudPassword.tooManyAttempts",
          redirectURI: Uri.parse("/auth").toString(),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        networkStatus: Status.success,
        error: result.hasError() ? result.error : "cloudPassword.wrongPassword",
        attemptsLeft: result.attemptsLeft,
      ),
    );
  }

  /// «Забыли пароль?»: запрашивает код восстановления на привязанный email и
  /// переходит в фазу восстановления, показывая маскированный адрес.
  Future<void> startRecovery() async {
    if (!await utils.hasNetwork()) {
      emit(state.copyWith(error: "grpcError.unableConnectServer"));
      return;
    }

    emit(state.copyWith(networkStatus: Status.loading, error: ""));

    final request = Message(
      messageType: MessageType.AUTH_CLOUD_PASSWORD_RECOVERY,
      message: AuthCloudPasswordRecovery_Request(confirmationSession: state.confirmationSession).writeToBuffer(),
    );

    late Message response;
    final grpcError = await api.call(() async {
      response = await api.client.unary(request);
    });

    if (grpcError.status == APIStatus.error) {
      final redirect = grpcError.statusCode == StatusCode.unauthenticated ? Uri.parse("/auth").toString() : "";
      emit(state.copyWith(networkStatus: Status.success, error: grpcError.error, redirectURI: redirect));
      return;
    }

    final result = AuthCloudPasswordRecovery_Response.fromBuffer(response.message);
    emit(state.copyWith(networkStatus: Status.success, phase: AuthCloudPasswordPhase.recovery, maskedEmail: result.maskedEmail));
  }

  /// Подтверждение восстановления: код из письма + новый пароль. При успехе сервер
  /// ставит новый пароль и помечает сессию пройденной — завершаем вход.
  Future<void> recoveryConfirm({required String code, required String newPassword}) async {
    if (code.isEmpty) {
      emit(state.copyWith(error: "cloudPassword.codeRequired"));
      return;
    }
    if (newPassword.isEmpty) {
      emit(state.copyWith(error: "cloudPassword.passwordRequired"));
      return;
    }

    emit(state.copyWith(networkStatus: Status.loading, error: ""));

    final newPwHash = await cloudPasswordHash(newPassword);

    final request = Message(
      messageType: MessageType.AUTH_CLOUD_PASSWORD_RECOVERY_CONFIRM,
      message: AuthCloudPasswordRecoveryConfirm_Request(
        confirmationSession: state.confirmationSession,
        code: code,
        newPwHash: newPwHash,
      ).writeToBuffer(),
    );

    final grpcError = await api.call(() async {
      await api.client.unary(request);
    });

    if (grpcError.status == APIStatus.error) {
      final redirect = grpcError.statusCode == StatusCode.unauthenticated ? Uri.parse("/auth").toString() : "";
      emit(state.copyWith(networkStatus: Status.success, error: grpcError.error, redirectURI: redirect));
      return;
    }

    await _completeLogin();
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
