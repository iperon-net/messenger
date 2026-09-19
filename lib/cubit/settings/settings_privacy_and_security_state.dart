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

  /// Нечего показать: серверную настройку не загрузили и локального кэша нет
  /// (offline при первом запуске / ошибка). Пока `true`, экран не выдаёт
  /// [callsAudience] за реальное значение, а показывает «не загрузилось» +
  /// повтор. Сбрасывается, как только появляется значение (кэш или сервер).
  final bool callsLoadError;

  /// Значение показываем из локального кэша, но изменить его сейчас нельзя —
  /// нет сети (гейт серверный). Экран блокирует выбор и поясняет почему.
  /// Сбрасывается при успешной загрузке/сохранении с сервера.
  final bool callsReadOnly;

  const SettingsPrivacyAndSecurityState({
    this.status = Status.initialization,
    this.isBiometricAvailable = false,
    this.callsAudience = CallsPrivacyAudience.contacts,
    this.callsLoadError = false,
    this.callsReadOnly = false,
  });
}
