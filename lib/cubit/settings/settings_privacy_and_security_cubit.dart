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

  /// Загружает серверную настройку «кто может звонить». Ошибка не критична —
  /// остаёмся на дефолте (только контакты).
  Future<void> _loadCalls() async {
    try {
      final (status, payload) = await api.unaryEncodedWithResponse(MessageType.PRIVACY_SETTINGS, PrivacySettings_Request().writeToBuffer());
      if (isClosed || status.status != APIStatus.success || payload == null) return;

      final response = PrivacySettings_Response.fromBuffer(payload);
      emit(state.copyWith(callsAudience: _fromProto(response.calls)));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Меняет настройку «кто может звонить». Оптимистично обновляем UI, при сбое —
  /// откатываем к прежнему значению.
  Future<void> setCallsAudience(CallsPrivacyAudience audience) async {
    if (audience == state.callsAudience) return;

    final previous = state.callsAudience;
    emit(state.copyWith(callsAudience: audience));

    final status = await api.unaryEncoded(
      MessageType.PRIVACY_SETTINGS_UPDATE,
      PrivacySettingsUpdate_Request(calls: _toProto(audience)).writeToBuffer(),
    );

    if (status.status != APIStatus.success) {
      logger.warning('privacy: update calls audience failed (${status.error})');
      if (!isClosed) emit(state.copyWith(callsAudience: previous));
    }
  }

  CallsPrivacyAudience _fromProto(PrivacySettings_Audience audience) {
    return audience == PrivacySettings_Audience.EVERYBODY ? CallsPrivacyAudience.everybody : CallsPrivacyAudience.contacts;
  }

  PrivacySettings_Audience _toProto(CallsPrivacyAudience audience) {
    return audience == CallsPrivacyAudience.everybody ? PrivacySettings_Audience.EVERYBODY : PrivacySettings_Audience.CONTACTS;
  }
}
