import 'dart:typed_data';

import 'api.dart';
import 'crypto.dart';
import 'protobuf.dart';

/// Обмены OPAQUE облачного пароля из-под сессии (настройки, передача владения
/// группой). Проверка пароля даёт `token` на действия (живёт на сервере 10 минут,
/// у пользователя один; смена пароля его гасит). См. cloud_password_v1.proto.
///
/// Ошибки — i18n-ключи: сервер отдаёт `cloudPassword.*`, неверный пароль клиент
/// узнаёт сам на KE2 (`cloudPassword.wrongPassword`) и KE3 не шлёт.
abstract final class CloudPassword {
  /// Проверка пароля: token или ключ ошибки.
  static Future<({List<int> token, String error})> unlock(API api, String password) async {
    final client = cloudPasswordClient();
    final (ke1, login) = client.loginStart(cloudPasswordBytes(password));

    final (startStatus, startPayload) = await api.unaryEncodedWithResponse(
      MessageType.CLOUD_PASSWORD_AUTH_START,
      CloudPasswordAuthStart_Request(ke1: ke1).writeToBuffer(),
    );
    final startError = _error(startStatus, startPayload);
    if (startError.isNotEmpty) return (token: const <int>[], error: startError);

    final OpaqueLoginResult result;
    try {
      result = await client.loginFinish(login, CloudPasswordAuthStart_Response.fromBuffer(startPayload!).ke2);
    } on OpaqueException catch (e) {
      return (token: const <int>[], error: _opaqueError(e));
    }

    final (finishStatus, finishPayload) = await api.unaryEncodedWithResponse(
      MessageType.CLOUD_PASSWORD_AUTH_FINISH,
      CloudPasswordAuthFinish_Request(ke3: result.ke3).writeToBuffer(),
    );
    final finishError = _error(finishStatus, finishPayload);
    if (finishError.isNotEmpty) return (token: const <int>[], error: finishError);

    return (token: CloudPasswordAuthFinish_Response.fromBuffer(finishPayload!).token, error: '');
  }

  /// Установка / смена / сброс пароля: '' или ключ ошибки. [token] не нужен,
  /// только если пароля ещё нет; после успеха прежний token не действует.
  static Future<String> register(API api, String password, List<int> token) async {
    final client = cloudPasswordClient();
    final (request, registration) = client.registrationStart(cloudPasswordBytes(password));

    final (startStatus, startPayload) = await api.unaryEncodedWithResponse(
      MessageType.CLOUD_PASSWORD_REGISTER_START,
      CloudPasswordRegisterStart_Request(token: token, registrationRequest: request).writeToBuffer(),
    );
    final startError = _error(startStatus, startPayload);
    if (startError.isNotEmpty) return startError;

    final OpaqueRegistrationResult result;
    try {
      result = await client.registrationFinish(
        registration,
        CloudPasswordRegisterStart_Response.fromBuffer(startPayload!).registrationResponse,
      );
    } on OpaqueException catch (e) {
      return _opaqueError(e);
    }

    final status = await api.unaryEncoded(
      MessageType.CLOUD_PASSWORD_REGISTER_FINISH,
      CloudPasswordRegisterFinish_Request(token: token, record: result.record).writeToBuffer(),
    );
    return status.status == APIStatus.success ? '' : _statusError(status);
  }

  static String _error(APICallStatus status, Uint8List? payload) {
    if (status.status != APIStatus.success) return _statusError(status);
    return payload == null ? 'grpcError.internalServerError' : '';
  }

  static String _statusError(APICallStatus status) => status.error.isNotEmpty ? status.error : 'grpcError.internalServerError';

  /// Ошибка клиентской стороны OPAQUE → i18n-ключ.
  static String _opaqueError(OpaqueException e) => switch (e.error) {
    OpaqueError.wrongPassword => 'cloudPassword.wrongPassword',
    OpaqueError.serverAuthentication || OpaqueError.invalidMessage => 'cloudPassword.invalidMessage',
  };
}
