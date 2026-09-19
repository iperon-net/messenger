import 'dart:typed_data';

import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../repositories/repositories.dart';
import '../../utils.dart';
import 'settings_privacy_and_security_state.dart';

class SettingsPrivacyAndSecurityCubit extends Cubit<SettingsPrivacyAndSecurityState> {
  SettingsPrivacyAndSecurityCubit() : super(SettingsPrivacyAndSecurityState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  /// Ключ локального кэша настройки «кто может звонить» (per-user, бессрочно).
  static const _callsCacheKey = "privacy.calls.audience";

  Future<void> initialization() async {
    emit(state.copyWith(status: Status.loading));
    final isBiometricAvailable = await utils.isBiometricAvailable();
    emit(state.copyWith(status: Status.success, isBiometricAvailable: isBiometricAvailable));
    await _loadCalls();
  }

  /// Перечитывает серверную настройку звонков. Вызывается родительским экраном
  /// «Конфиденциальность» после возврата с детейл-экрана «Звонки» (у которого
  /// свой инстанс cubit), чтобы label в списке не остался устаревшим.
  Future<void> reloadCalls() => _loadCalls();

  /// Загружает настройку «кто может звонить». Сначала мгновенно поднимаем
  /// последнее значение из локального кэша (видно и offline), затем пробуем
  /// сервер. Успех — обновляем значение + кэш, снимаем блокировки. Сбой:
  /// показываем кэш read-only (offline, менять нельзя — гейт серверный), а если
  /// кэша нет — [callsLoadError] с повтором (см. offline-раздел CLAUDE.md).
  Future<void> _loadCalls() async {
    final cached = await _readCache();
    if (isClosed) return;
    if (cached != null) emit(state.copyWith(callsAudience: cached, callsLoadError: false));

    try {
      final (status, payload) = await api.unaryEncodedWithResponse(MessageType.PRIVACY_SETTINGS, PrivacySettings_Request().writeToBuffer());
      if (isClosed) return;

      if (status.status != APIStatus.success || payload == null) {
        logger.warning('privacy: load calls audience failed (${status.error})');
        emit(state.copyWith(callsLoadError: cached == null, callsReadOnly: cached != null));
        return;
      }

      final audience = _fromProto(PrivacySettings_Response.fromBuffer(payload).calls);
      await _writeCache(audience);
      if (!isClosed) emit(state.copyWith(callsAudience: audience, callsLoadError: false, callsReadOnly: false));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(callsLoadError: cached == null, callsReadOnly: cached != null));
    }
  }

  /// Меняет настройку «кто может звонить». Настройку нельзя применить offline
  /// (гейт серверный) — поэтому сперва проверяем сеть и НЕ делаем оптимистичный
  /// emit с откатом (галочка визуально не прыгает). При успехе обновляем кэш.
  /// Возвращает `false`, если изменение не применилось (offline/ошибка).
  Future<bool> setCallsAudience(CallsPrivacyAudience audience) async {
    if (audience == state.callsAudience && !state.callsLoadError && !state.callsReadOnly) return true;

    if (!await utils.hasNetwork()) {
      logger.info('privacy: set calls audience aborted, no network');
      return false;
    }

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_SETTINGS_UPDATE,
      PrivacySettingsUpdate_Request(calls: _toProto(audience)).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update calls audience failed (${status.error})');
      return false;
    }

    // Успех подтверждает и связь, и новое значение — фиксируем, кэшируем, снимаем блокировки.
    await _writeCache(audience);
    if (!isClosed) emit(state.copyWith(callsAudience: audience, callsLoadError: false, callsReadOnly: false));
    return true;
  }

  /// Читает закэшированное значение звонков; null — кэша нет или он битый.
  Future<CallsPrivacyAudience?> _readCache() async {
    try {
      final raw = await repositories.cache.getString(userID: Uint8List.fromList(auth.session.userID), key: _callsCacheKey);
      if (raw == null) return null;
      return CallsPrivacyAudience.values.asNameMap()[raw];
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return null;
    }
  }

  Future<void> _writeCache(CallsPrivacyAudience audience) async {
    try {
      await repositories.cache.setString(userID: Uint8List.fromList(auth.session.userID), key: _callsCacheKey, value: audience.name);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  CallsPrivacyAudience _fromProto(PrivacySettings_Audience audience) {
    return audience == PrivacySettings_Audience.EVERYBODY ? CallsPrivacyAudience.everybody : CallsPrivacyAudience.contacts;
  }

  PrivacySettings_Audience _toProto(CallsPrivacyAudience audience) {
    return audience == CallsPrivacyAudience.everybody ? PrivacySettings_Audience.EVERYBODY : PrivacySettings_Audience.CONTACTS;
  }
}
