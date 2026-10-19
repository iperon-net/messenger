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
/// рождения, «О себе», последнее посещение или «кто может мне писать». Пикер контактов один на все —
/// различается только тем, какой список настройки он заменяет через
/// [SettingsPrivacyAndSecurityCubit].
enum PrivacyChannel { calls, birthday, aboutMe, lastSeen, messages, forwards, phoneNumber, groupInvites }

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

  /// Настройка «кто может видеть моё последнее посещение и онлайн-статус».
  /// Семантика и дефолт — как у [callsAudience]. Приходит в том же ответе
  /// PRIVACY_SETTINGS. ВЗАИМНОСТЬ: если выбрано «Никто», пользователь и сам не
  /// видит чужое присутствие (кроме премиум) — гейт применяется на сервере.
  final CallsPrivacyAudience lastSeenAudience;

  /// Allow/deny-списки исключений для последнего посещения (см. [callsAllow]).
  final List<Uint8List> lastSeenAllow;
  final List<Uint8List> lastSeenDeny;

  /// Настройка «кто может мне писать» (личные сообщения). Дефолт — ВСЕ (как в
  /// Telegram и на сервере; у остальных каналов — контакты). Гейт серверный: при
  /// отправке по стороне получателя; ответить тому, кто уже написал, можно всегда.
  final CallsPrivacyAudience messagesAudience;

  /// Allow/deny-списки исключений для сообщений (см. [callsAllow]/[callsDeny]).
  final List<Uint8List> messagesAllow;
  final List<Uint8List> messagesDeny;

  /// «Кто может добавить ссылку на мой аккаунт при пересылке моих сообщений».
  /// Дефолт — ВСЕ (как в Telegram и на сервере). Гейт серверный, по
  /// пересылающему: нельзя — «Переслано от …» только с именем, без профиля.
  final CallsPrivacyAudience forwardsAudience;

  /// Allow/deny-списки исключений для пересылки (см. [callsAllow]/[callsDeny]).
  final List<Uint8List> forwardsAllow;
  final List<Uint8List> forwardsDeny;

  /// «Кто может добавлять меня в группы». Дефолт — ВСЕ (как в Telegram и на
  /// сервере). Гейт серверный, при создании группы / добавлении участников:
  /// нельзя — меня в группу не добавят (у добавляющего — «не добавлены»).
  final CallsPrivacyAudience groupInvitesAudience;

  /// Allow/deny-списки исключений для групп (см. [callsAllow]/[callsDeny]).
  final List<Uint8List> groupInvitesAllow;
  final List<Uint8List> groupInvitesDeny;

  /// «Скрывать время прочтения» (в «Последнем посещении»): «Прочитано в 12:30»
  /// не видно тем, кому не видно моё последнее посещение. Взаимно — включив,
  /// сам не видишь чужое. Галочки ✓✓ остаются.
  final bool hideReadTime;

  /// Автоудаление по умолчанию для новых чатов (секунды; 0 — выключено): чат,
  /// который я начинаю, получает такой таймер.
  final int messagesTTL;

  /// Заблокированные пользователи (userID) — строка «Заблокированные» и её
  /// счётчик; меняются поштучно (`PrivacyBlocks.setBlocked`).
  final List<Uint8List> blocked;

  /// «Кто видит мой номер телефона». Дефолт — контакты (как в Telegram и на
  /// сервере). Гейт серверный, при отдаче профиля; у кого номер уже есть в
  /// книге, тот видит его всегда.
  final CallsPrivacyAudience phoneNumberAudience;

  /// Allow/deny-списки исключений для номера (см. [callsAllow]/[callsDeny]).
  final List<Uint8List> phoneNumberAllow;
  final List<Uint8List> phoneNumberDeny;

  /// «Кто может найти меня по номеру»: только [CallsPrivacyAudience.everybody]
  /// (дефолт) или [CallsPrivacyAudience.contacts]. Показывается, когда номер
  /// виден не всем.
  final CallsPrivacyAudience phoneNumberFind;

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
    this.lastSeenAudience = CallsPrivacyAudience.contacts,
    this.lastSeenAllow = const [],
    this.lastSeenDeny = const [],
    this.messagesAudience = CallsPrivacyAudience.everybody,
    this.messagesAllow = const [],
    this.messagesDeny = const [],
    this.forwardsAudience = CallsPrivacyAudience.everybody,
    this.forwardsAllow = const [],
    this.forwardsDeny = const [],
    this.groupInvitesAudience = CallsPrivacyAudience.everybody,
    this.groupInvitesAllow = const [],
    this.groupInvitesDeny = const [],
    this.hideReadTime = false,
    this.messagesTTL = 0,
    this.blocked = const [],
    this.phoneNumberAudience = CallsPrivacyAudience.contacts,
    this.phoneNumberAllow = const [],
    this.phoneNumberDeny = const [],
    this.phoneNumberFind = CallsPrivacyAudience.everybody,
  });
}
