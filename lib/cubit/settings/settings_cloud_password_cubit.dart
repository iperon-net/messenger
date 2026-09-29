import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../utils.dart';
import '../../protobuf.dart';
import 'settings_cloud_password_state.dart';

/// Настройки облачного пароля (двухшаговая проверка) — пошаговый полноэкранный
/// flow (без диалогов). Authenticated: `api.unaryEncoded[WithResponse]`. Клиент
/// шлёт pre-hash пароля (`cloudPasswordHash`), не plaintext.
///
/// Flow:
/// - не задан: email → код → пароль (одно поле) → включено;
/// - задан: ввод текущего пароля («разблокировка») → меню; «Забыли пароль?» →
///   код на сохранённый email → код + новый пароль (email при этом очищается).
class SettingsCloudPasswordCubit extends Cubit<SettingsCloudPasswordState> {
  SettingsCloudPasswordCubit() : super(const SettingsCloudPasswordState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();

  /// Минимальная длина облачного пароля.
  static const minPasswordLength = 5;

  /// Загрузка состояния и выбор стартового шага.
  Future<void> initialization() async {
    emit(state.copyWith(step: SettingsCloudPasswordStep.loading, loadError: false));

    final info = await _loadInfo();
    if (info == null) {
      emit(state.copyWith(loadError: true, step: SettingsCloudPasswordStep.loading));
      return;
    }

    emit(state.copyWith(step: _stepForInfo(info), loadError: false));
  }

  /// Пересчитывает стартовый/возвратный шаг по состоянию с сервера.
  SettingsCloudPasswordStep _stepForInfo(CloudPasswordInfo_Response info) {
    if (info.isEnabled) return SettingsCloudPasswordStep.unlock;
    // Установка (пароль ещё не задан) всегда начинается с ввода email: пользователь
    // видит/подтверждает адрес, затем код, затем пароль. Шаг «Подтвердить email»
    // и «Новый пароль» достижимы только по ходу флоу, а не как стартовые — иначе
    // выход/вход кидал бы в середину.
    return SettingsCloudPasswordStep.setupEmail;
  }

  Future<CloudPasswordInfo_Response?> _loadInfo() async {
    final (status, payload) = await api.unaryEncodedWithResponse(
      MessageType.CLOUD_PASSWORD_INFO,
      CloudPasswordInfo_Request().writeToBuffer(),
    );
    if (status.status != APIStatus.success || payload == null) {
      logger.warning('cloud password: load info failed (${status.error})');
      return null;
    }
    final info = CloudPasswordInfo_Response.fromBuffer(payload);
    emit(state.copyWith(isEnabled: info.isEnabled, maskedEmail: info.maskedEmail, isEmailVerified: info.isEmailVerified));
    return info;
  }

  /// Возврат на предыдущий шаг (для кнопки/системного «назад» на не-корневых шагах).
  void back() {
    switch (state.step) {
      case SettingsCloudPasswordStep.setupVerify:
        emit(state.copyWith(step: SettingsCloudPasswordStep.setupEmail, error: ""));
      case SettingsCloudPasswordStep.changeEmailVerify:
        emit(state.copyWith(step: SettingsCloudPasswordStep.changeEmail, error: ""));
      case SettingsCloudPasswordStep.changePassword:
      case SettingsCloudPasswordStep.changeEmail:
        emit(state.copyWith(step: SettingsCloudPasswordStep.menu, error: ""));
      case SettingsCloudPasswordStep.recoveryConfirm:
        emit(state.copyWith(step: SettingsCloudPasswordStep.unlock, error: ""));
      default:
        break;
    }
  }

  void goChangePassword() => emit(state.copyWith(step: SettingsCloudPasswordStep.changePassword, error: ""));
  void goChangeEmail() => emit(state.copyWith(step: SettingsCloudPasswordStep.changeEmail, error: ""));

  // ── Установка (пароль не задан) ─────────────────────────────────────────

  Future<void> submitSetupEmail(String email) => _setEmail(email, next: SettingsCloudPasswordStep.setupVerify);

  Future<void> submitSetupVerify(String code) async {
    if (!await _verifyEmail(code)) return;
    // email подтверждён → к вводу пароля. Сбрасываем loading, иначе кнопка
    // следующего шага останется со спиннером.
    emit(state.copyWith(step: SettingsCloudPasswordStep.setupPassword, networkStatus: Status.success, error: ""));
  }

  Future<void> submitSetupPassword(String password) async {
    if (!_validPassword(password)) return;
    if (!await _guard()) return;

    _busy();
    final newPwHash = await cloudPasswordHash(password);
    final status = await api.unaryEncoded(
      MessageType.CLOUD_PASSWORD_SET,
      CloudPasswordSet_Request(currentPwHash: state.heldPwHash, newPwHash: newPwHash).writeToBuffer(),
    );
    if (!_ok(status)) return;

    emit(state.copyWith(heldPwHash: newPwHash));
    await _loadInfo();
    emit(state.copyWith(step: SettingsCloudPasswordStep.menu, networkStatus: Status.success, error: ""));
  }

  // ── Разблокировка (пароль задан) ────────────────────────────────────────

  Future<void> unlock(String password) async {
    if (password.isEmpty) return _fail("cloudPassword.passwordRequired");
    if (!await _guard()) return;

    _busy();
    final pwHash = await cloudPasswordHash(password);
    final status = await api.unaryEncoded(MessageType.CLOUD_PASSWORD_VERIFY, CloudPasswordVerify_Request(pwHash: pwHash).writeToBuffer());
    if (!_ok(status)) return;

    emit(state.copyWith(heldPwHash: pwHash, step: SettingsCloudPasswordStep.menu, networkStatus: Status.success, error: ""));
  }

  // ── Меню: смена пароля / email / отключение ─────────────────────────────

  Future<void> submitChangePassword(String password) async {
    if (!_validPassword(password)) return;
    if (!await _guard()) return;

    _busy();
    final newPwHash = await cloudPasswordHash(password);
    final status = await api.unaryEncoded(
      MessageType.CLOUD_PASSWORD_SET,
      CloudPasswordSet_Request(currentPwHash: state.heldPwHash, newPwHash: newPwHash).writeToBuffer(),
    );
    if (!_ok(status)) return;

    emit(state.copyWith(heldPwHash: newPwHash, step: SettingsCloudPasswordStep.menu, networkStatus: Status.success, error: ""));
  }

  Future<void> submitChangeEmail(String email) => _setEmail(email, next: SettingsCloudPasswordStep.changeEmailVerify);

  Future<void> submitChangeEmailVerify(String code) async {
    if (!await _verifyEmail(code)) return;
    await _loadInfo();
    emit(state.copyWith(step: SettingsCloudPasswordStep.menu, networkStatus: Status.success, error: ""));
  }

  /// Отключение. Возвращает true — экран закрывается.
  Future<bool> disable() async {
    if (!await _guard()) return false;

    _busy();
    final status = await api.unaryEncoded(
      MessageType.CLOUD_PASSWORD_DISABLE,
      CloudPasswordDisable_Request(currentPwHash: state.heldPwHash).writeToBuffer(),
    );
    if (!_ok(status)) return false;

    emit(state.copyWith(networkStatus: Status.success));
    return true;
  }

  // ── Восстановление ──────────────────────────────────────────────────────

  Future<void> forgotPassword() async {
    if (!await _guard()) return;

    _busy();
    final (status, payload) = await api.unaryEncodedWithResponse(
      MessageType.CLOUD_PASSWORD_RECOVERY_SEND,
      CloudPasswordRecoverySend_Request().writeToBuffer(),
    );
    if (!_ok(status) || payload == null) {
      if (payload == null && status.status == APIStatus.success) _fail("grpcError.internalServerError");
      return;
    }
    final response = CloudPasswordRecoverySend_Response.fromBuffer(payload);
    emit(
      state.copyWith(
        maskedEmail: response.maskedEmail,
        step: SettingsCloudPasswordStep.recoveryConfirm,
        networkStatus: Status.success,
        error: "",
      ),
    );
  }

  Future<void> submitRecovery({required String code, required String newPassword}) async {
    if (code.isEmpty) return _fail("cloudPassword.codeRequired");
    if (!_validPassword(newPassword)) return;
    if (!await _guard()) return;

    _busy();
    final newPwHash = await cloudPasswordHash(newPassword);
    final status = await api.unaryEncoded(
      MessageType.CLOUD_PASSWORD_RESET,
      CloudPasswordReset_Request(code: code, newPwHash: newPwHash).writeToBuffer(),
    );
    if (!_ok(status)) return;

    // Пароль сброшен, email очищен сервером — держим новый пароль, идём в меню.
    emit(state.copyWith(heldPwHash: newPwHash));
    await _loadInfo();
    emit(state.copyWith(step: SettingsCloudPasswordStep.menu, networkStatus: Status.success, error: ""));
  }

  // ── Общие помощники ─────────────────────────────────────────────────────

  /// Привязка/смена email + переход к вводу кода. currentPwHash берётся из
  /// heldPwHash (пусто при первичной установке — сервер это допускает).
  Future<void> _setEmail(String email, {required SettingsCloudPasswordStep next}) async {
    if (email.isEmpty) return _fail("cloudPassword.emailRequired");
    if (!await _guard()) return;

    _busy();
    final status = await api.unaryEncoded(
      MessageType.CLOUD_PASSWORD_EMAIL_SET,
      CloudPasswordEmailSet_Request(currentPwHash: state.heldPwHash, email: email).writeToBuffer(),
    );
    if (!_ok(status)) return;

    emit(state.copyWith(pendingEmail: email, step: next, networkStatus: Status.success, error: ""));
  }

  Future<bool> _verifyEmail(String code) async {
    if (code.isEmpty) {
      _fail("cloudPassword.codeRequired");
      return false;
    }
    if (!await _guard()) return false;

    _busy();
    final status = await api.unaryEncoded(
      MessageType.CLOUD_PASSWORD_EMAIL_VERIFY,
      CloudPasswordEmailVerify_Request(code: code).writeToBuffer(),
    );
    return _ok(status);
  }

  /// Проверка пароля: не пустой и не короче [minPasswordLength]. При ошибке
  /// выставляет её в state и возвращает false.
  bool _validPassword(String password) {
    if (password.isEmpty) {
      _fail("cloudPassword.passwordRequired");
      return false;
    }
    if (password.length < minPasswordLength) {
      _fail("cloudPassword.passwordTooShort");
      return false;
    }
    return true;
  }

  Future<bool> _guard() async {
    if (!await utils.hasNetwork()) {
      _fail("grpcError.unableConnectServer");
      return false;
    }
    return true;
  }

  void _busy() => emit(state.copyWith(networkStatus: Status.loading, error: ""));

  void _fail(String key) => emit(state.copyWith(networkStatus: Status.success, error: key));

  /// true — успех; иначе выставляет ошибку из статуса и возвращает false.
  bool _ok(APICallStatus status) {
    if (status.status == APIStatus.success) return true;
    _fail(status.error.isNotEmpty ? status.error : "grpcError.internalServerError");
    return false;
  }
}
