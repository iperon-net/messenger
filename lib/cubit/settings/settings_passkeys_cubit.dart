import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../utils.dart';
import '../../protobuf.dart';
import 'settings_passkeys_state.dart';

/// Раздел «Ключи доступа» (passkeys). Всё authenticated — через
/// [API.unaryEncoded]/[API.unaryEncodedWithResponse] (по userID из сессии).
/// Регистрация: BEGIN (сервер отдаёт CreationOptions) → нативное создание ключа →
/// FINISH (сервер верифицирует attestation и сохраняет). См. passkey_v1.proto.
class SettingsPasskeysCubit extends Cubit<SettingsPasskeysState> {
  SettingsPasskeysCubit() : super(const SettingsPasskeysState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();

  final _authenticator = PasskeyAuthenticator();

  Future<void> initialization() async {
    await _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(status: Status.loading, loadError: false));

    final (status, payload) = await api.unaryEncodedWithResponse(MessageType.PASSKEY_LIST, PasskeyList_Request().writeToBuffer());

    if (status.status == APIStatus.error || payload == null) {
      emit(state.copyWith(status: Status.success, loadError: true));
      return;
    }

    final response = PasskeyList_Response.fromBuffer(payload);
    emit(state.copyWith(status: Status.success, loadError: false, items: response.credentials.map(_toItem).toList()));
  }

  /// Добавление ключа: BEGIN → нативный промпт создания → FINISH → перезагрузка
  /// списка. Отмена промпта — не ошибка.
  Future<void> addPasskey() async {
    if (!await utils.hasNetwork()) {
      emit(state.copyWith(error: "grpcError.unableConnectServer"));
      return;
    }

    emit(state.copyWith(networkStatus: Status.loading, error: ""));

    final (beginStatus, beginPayload) = await api.unaryEncodedWithResponse(
      MessageType.PASSKEY_REGISTER_BEGIN,
      PasskeyRegisterBegin_Request().writeToBuffer(),
    );
    if (beginStatus.status == APIStatus.error || beginPayload == null) {
      emit(
        state.copyWith(
          networkStatus: Status.success,
          error: beginStatus.error.isNotEmpty ? beginStatus.error : "passkey.verificationFailed",
        ),
      );
      return;
    }
    final begin = PasskeyRegisterBegin_Response.fromBuffer(beginPayload);

    final RegisterResponseType attestation;
    try {
      final decoded = jsonDecode(utf8.decode(begin.publicKey)) as Map<String, dynamic>;
      // Сервер (go-webauthn) присылает опции в обёртке {"publicKey": {...}}.
      final options = decoded['publicKey'] as Map<String, dynamic>? ?? decoded;
      _normalizeCredentialTransports(options);
      attestation = await _authenticator.register(RegisterRequestType.fromJson(options));
    } on PasskeyAuthCancelledException {
      emit(state.copyWith(networkStatus: Status.success, error: ""));
      return;
    } on ExcludeCredentialsCanNotBeRegisteredException {
      // На устройстве уже есть ключ для этого аккаунта (сервер прислал его в
      // excludeCredentials) — resident-ключ один на (RP, user), дубль не создать.
      emit(state.copyWith(networkStatus: Status.success, error: "passkey.alreadyOnThisDevice"));
      return;
    } catch (error, stackTrace) {
      // Тот же дубль часть менеджеров паролей (Google Play Services, старые iOS)
      // отдаёт как необработанный InvalidState/DOM-эксепшен без стабильного кода —
      // ловим по тексту, иначе пользователь видит непонятное «Не удалось проверить».
      if (_isAlreadyRegistered(error)) {
        logger.debug("passkey register: already exists on device ($error)");
        emit(state.copyWith(networkStatus: Status.success, error: "passkey.alreadyOnThisDevice"));
        return;
      }
      logger.handle(error, stackTrace, "passkey register failed");
      emit(state.copyWith(networkStatus: Status.success, error: "passkey.verificationFailed"));
      return;
    }

    final finishStatus = await api.unaryEncoded(
      MessageType.PASSKEY_REGISTER_FINISH,
      PasskeyRegisterFinish_Request(credential: utf8.encode(attestation.toJsonString())).writeToBuffer(),
    );
    if (finishStatus.status == APIStatus.error) {
      emit(
        state.copyWith(
          networkStatus: Status.success,
          error: finishStatus.error.isNotEmpty ? finishStatus.error : "passkey.verificationFailed",
        ),
      );
      return;
    }

    emit(state.copyWith(networkStatus: Status.success, error: ""));
    await _load();
  }

  /// Пакет `passkeys` (CredentialType.fromJson) требует у каждой записи
  /// excludeCredentials непустое поле `transports` (List), а go-webauthn его не
  /// присылает (null) → краш каста при непустом exclude-списке (второе добавление).
  /// Проставляем `transports: []`, где его нет.
  void _normalizeCredentialTransports(Map<String, dynamic> options) {
    final exclude = options['excludeCredentials'];
    if (exclude is! List) return;
    for (final entry in exclude) {
      if (entry is Map && entry['transports'] == null) entry['transports'] = <String>[];
    }
  }

  /// Эвристика «ключ уже существует на этом устройстве». Разные менеджеры паролей
  /// сообщают об этом по-разному: типизированным [ExcludeCredentialsCanNotBeRegisteredException]
  /// (обрабатывается выше) либо необработанным InvalidState/DOM-эксепшеном с
  /// нестабильным кодом — здесь ловим второй случай по подстрокам кода/сообщения.
  bool _isAlreadyRegistered(Object error) {
    final text = error.toString().toLowerCase();
    const markers = [
      'excluded credential',
      'exclude-credentials',
      'already registered',
      'already exists',
      'invalidstateerror',
      'invalid state',
      'matched excluded',
      'matchedexcludedcredential',
      'one of the credentials',
    ];
    return markers.any(text.contains);
  }

  /// Удаление ключа по credentialId → перезагрузка списка.
  Future<void> deletePasskey(List<int> credentialId) async {
    emit(state.copyWith(networkStatus: Status.loading, error: ""));

    final status = await api.unaryEncoded(MessageType.PASSKEY_DELETE, PasskeyDelete_Request(credentialId: credentialId).writeToBuffer());
    if (status.status == APIStatus.error) {
      emit(state.copyWith(networkStatus: Status.success, error: status.error));
      return;
    }

    emit(state.copyWith(networkStatus: Status.success, error: ""));
    await _load();
  }

  PasskeyItem _toItem(PasskeyCredential c) => PasskeyItem(
    credentialId: c.credentialId,
    label: c.label,
    aaguid: c.aaguid,
    createdAt: c.createdAt.toInt(),
    lastUsedAt: c.lastUsedAt.toInt(),
  );
}
