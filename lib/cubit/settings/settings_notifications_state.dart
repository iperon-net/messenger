import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_notifications_state.mapper.dart';

/// Тип чатов, к которому относится настройка уведомлений (серверный
/// NotifySettings.Scope). Порядок задаёт вывод в списке.
enum NotifyScope { privateChats, groups, channels }

/// Настройка уведомлений одного типа чатов.
@MappableClass()
class NotifyScopeSettings with NotifyScopeSettingsMappable {
  /// Показывать уведомления о сообщениях.
  final bool enabled;

  /// Текст сообщения в уведомлении.
  final bool showPreviews;

  /// Со звуком.
  final bool sound;

  const NotifyScopeSettings({this.enabled = true, this.showPreviews = true, this.sound = true});
}

@MappableClass()
class SettingsNotificationsState with SettingsNotificationsStateMappable {
  final Status status;

  /// Нечего показать: с сервера не загрузили и локального кэша нет (offline при
  /// первом открытии). Пока `true`, экран не выдаёт дефолты за реальные
  /// значения, а показывает «не загрузилось» + повтор.
  final bool loadError;

  /// Значения из локального кэша, но менять их сейчас нельзя — нет сети
  /// (настройки применяет сервер). Экран блокирует переключатели.
  final bool readOnly;

  final NotifyScopeSettings privateChats;
  final NotifyScopeSettings groups;
  final NotifyScopeSettings channels;

  /// «Контакт присоединился к Iperon».
  final bool contactJoined;

  /// «Пропущенный звонок».
  final bool missedCalls;

  /// Системное разрешение на уведомления не выдано — серверные настройки ничего
  /// не покажут, пока его не включить.
  final bool permissionMissing;

  const SettingsNotificationsState({
    this.status = Status.initialization,
    this.loadError = false,
    this.readOnly = false,
    this.privateChats = const NotifyScopeSettings(),
    this.groups = const NotifyScopeSettings(),
    this.channels = const NotifyScopeSettings(),
    this.contactJoined = true,
    this.missedCalls = true,
    this.permissionMissing = false,
  });

  NotifyScopeSettings scope(NotifyScope scope) => switch (scope) {
    NotifyScope.privateChats => privateChats,
    NotifyScope.groups => groups,
    NotifyScope.channels => channels,
  };
}
