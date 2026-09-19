import 'package:bloc/bloc.dart';

import '../../api.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf.dart';
import '../../utils.dart';
import 'settings_privacy_and_security_state.dart';

class SettingsPrivacyAndSecurityCubit extends Cubit<SettingsPrivacyAndSecurityState> {
  SettingsPrivacyAndSecurityCubit() : super(SettingsPrivacyAndSecurityState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final api = getIt.get<API>();

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

  /// Загружает серверную настройку «кто может звонить». Настройка
  /// server-authoritative, локального кэша нет — поэтому при сбое (offline или
  /// ошибка) НЕ выдаём дефолт за реальное значение, а поднимаем [callsLoadError]:
  /// экран покажет «не загрузилось» + повтор (см. offline-раздел CLAUDE.md).
  Future<void> _loadCalls() async {
    try {
      final (status, payload) = await api.unaryEncodedWithResponse(MessageType.PRIVACY_SETTINGS, PrivacySettings_Request().writeToBuffer());
      if (isClosed) return;

      if (status.status != APIStatus.success || payload == null) {
        logger.warning('privacy: load calls audience failed (${status.error})');
        emit(state.copyWith(callsLoadError: true));
        return;
      }

      final response = PrivacySettings_Response.fromBuffer(payload);
      emit(state.copyWith(callsAudience: _fromProto(response.calls), callsLoadError: false));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      if (!isClosed) emit(state.copyWith(callsLoadError: true));
    }
  }

  /// Меняет настройку «кто может звонить». Настройку нельзя применить offline
  /// (гейт серверный) — поэтому сперва проверяем сеть и НЕ делаем оптимистичный
  /// emit с откатом (галочка визуально не прыгает). Возвращает `false`, если
  /// изменение не применилось (offline/ошибка) — UI показывает фидбек.
  Future<bool> setCallsAudience(CallsPrivacyAudience audience) async {
    if (audience == state.callsAudience && !state.callsLoadError) return true;

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

    // Успех подтверждает и связь, и новое значение — фиксируем, снимаем ошибку.
    if (!isClosed) emit(state.copyWith(callsAudience: audience, callsLoadError: false));
    return true;
  }

  CallsPrivacyAudience _fromProto(PrivacySettings_Audience audience) {
    return audience == PrivacySettings_Audience.EVERYBODY ? CallsPrivacyAudience.everybody : CallsPrivacyAudience.contacts;
  }

  PrivacySettings_Audience _toProto(CallsPrivacyAudience audience) {
    return audience == CallsPrivacyAudience.everybody ? PrivacySettings_Audience.EVERYBODY : PrivacySettings_Audience.CONTACTS;
  }
}
