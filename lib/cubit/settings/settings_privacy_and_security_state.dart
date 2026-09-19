import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_privacy_and_security_state.mapper.dart';

/// Кто может звонить пользователю (этап 1 приватности звонков). Совпадает с
/// серверным PrivacySettings.Audience.
enum CallsPrivacyAudience { everybody, contacts }

@MappableClass()
class SettingsPrivacyAndSecurityState with SettingsPrivacyAndSecurityStateMappable {
  final Status status;
  final bool isBiometricAvailable;

  /// Настройка «кто может мне звонить». Дефолт — только контакты (совпадает с
  /// серверным дефолтом, когда документ настроек ещё не создан).
  final CallsPrivacyAudience callsAudience;

  /// Не удалось загрузить серверную настройку звонков (offline/ошибка). Пока
  /// `true`, экран не выдаёт [callsAudience] за реальное значение, а показывает
  /// состояние «не загрузилось» + повтор. Сбрасывается при успешной загрузке.
  final bool callsLoadError;

  const SettingsPrivacyAndSecurityState({
    this.status = Status.initialization,
    this.isBiometricAvailable = false,
    this.callsAudience = CallsPrivacyAudience.contacts,
    this.callsLoadError = false,
  });
}
