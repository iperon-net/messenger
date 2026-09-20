import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models/mapper.dart';

part 'settings_privacy_and_security_state.mapper.dart';

/// Кто может звонить пользователю (этап 1 приватности звонков). Совпадает с
/// серверным PrivacySettings.Audience. Порядок задаёт вывод в списке (UI
/// итерирует `values`) — по убыванию доступности: все → контакты → никто.
enum CallsPrivacyAudience { everybody, contacts, nobody }

/// Какой список исключений редактирует экран-пикер: allow («всегда разрешать»,
/// секция под «Никто») или deny («всегда запрещать», секция под «Мои контакты»).
enum CallsListKind { allow, deny }

/// Канал приватности, к которому относится экран-пикер исключений: звонки, день
/// рождения или «О себе». Пикер контактов один на все — различается только тем,
/// какой список настройки он заменяет через [SettingsPrivacyAndSecurityCubit].
enum PrivacyChannel { calls, birthday, aboutMe }

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

  /// Deny-list «всегда запрещать» для звонков: userID (сырые байты ObjectID),
  /// которым звонок запрещён независимо от [callsAudience]. Редактируется на
  /// экране-пикере; используется секцией «Исключения» под «Мои контакты».
  final List<Uint8List> callsDeny;

  /// Настройка «кто может видеть мою дату рождения». Семантика и дефолт — как у
  /// [callsAudience] (та же серверная аудитория). Приходит в том же ответе
  /// PRIVACY_SETTINGS, поэтому [callsLoadError]/[callsReadOnly] покрывают и её.
  final CallsPrivacyAudience birthdayAudience;

  /// Allow/deny-списки исключений для дня рождения (см. [callsAllow]/[callsDeny]).
  final List<Uint8List> birthdayAllow;
  final List<Uint8List> birthdayDeny;

  /// Скрывать год рождения и возраст от тех, кому дата рождения видна. Дефолт —
  /// `false` (год виден). Применяется на сервере при отдаче чужого профиля.
  final bool hideBirthYear;

  /// Настройка «кто может видеть моё „О себе“». Семантика и дефолт — как у
  /// [callsAudience]. Приходит в том же ответе PRIVACY_SETTINGS, поэтому
  /// [callsLoadError]/[callsReadOnly] покрывают и её.
  final CallsPrivacyAudience aboutMeAudience;

  /// Allow/deny-списки исключений для «О себе» (см. [callsAllow]/[callsDeny]).
  final List<Uint8List> aboutMeAllow;
  final List<Uint8List> aboutMeDeny;

  const SettingsPrivacyAndSecurityState({
    this.status = Status.initialization,
    this.isBiometricAvailable = false,
    this.callsAudience = CallsPrivacyAudience.contacts,
    this.callsLoadError = false,
    this.callsReadOnly = false,
    this.callsAllow = const [],
    this.callsDeny = const [],
    this.birthdayAudience = CallsPrivacyAudience.contacts,
    this.birthdayAllow = const [],
    this.birthdayDeny = const [],
    this.hideBirthYear = false,
    this.aboutMeAudience = CallsPrivacyAudience.contacts,
    this.aboutMeAllow = const [],
    this.aboutMeDeny = const [],
  });
}
