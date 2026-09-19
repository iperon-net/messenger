import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models/mapper.dart';

part 'settings_privacy_and_security_state.mapper.dart';

/// Кто может звонить пользователю (этап 1 приватности звонков). Совпадает с
/// серверным PrivacySettings.Audience. Порядок задаёт вывод в списке (UI
/// итерирует `values`) — по убыванию доступности: все → контакты → никто.
enum CallsPrivacyAudience { everybody, contacts, nobody }

@MappableClass(includeCustomMappers: [Uint8ListMapper()])
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

  /// Allow-list «всегда разрешать» для звонков: userID (сырые байты ObjectID),
  /// которым звонок разрешён независимо от [callsAudience]. Редактируется на
  /// экране-пикере; используется секцией «Исключения» под «Никто».
  final List<Uint8List> callsAllow;

  const SettingsPrivacyAndSecurityState({
    this.status = Status.initialization,
    this.isBiometricAvailable = false,
    this.callsAudience = CallsPrivacyAudience.contacts,
    this.callsLoadError = false,
    this.callsReadOnly = false,
    this.callsAllow = const [],
  });
}
