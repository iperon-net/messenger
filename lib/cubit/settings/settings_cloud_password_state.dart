import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'settings_cloud_password_state.mapper.dart';

/// Шаг раздела «Облачный пароль». Все шаги — полноэкранные (без диалогов).
enum SettingsCloudPasswordStep {
  loading,
  // Установка (пароль ещё не задан): email → код → пароль.
  setupEmail,
  setupVerify,
  setupPassword,
  // Пароль задан: сначала «разблокировка» вводом текущего пароля.
  unlock,
  // Разблокированное меню.
  menu,
  changePassword,
  changeEmail,
  changeEmailVerify,
  // Восстановление: код на сохранённый email → код + новый пароль.
  recoveryConfirm,
}

@MappableClass()
class SettingsCloudPasswordState with SettingsCloudPasswordStateMappable {
  final SettingsCloudPasswordStep step;
  // networkStatus == loading — запрос в полёте (спиннер на кнопке).
  final Status networkStatus;
  final bool loadError;
  // Стартовая загрузка не прошла из-за отсутствия сети (а не ошибки сервера) —
  // показываем отдельную offline-страницу вместо общей [loadError]-заглушки.
  final bool offline;

  final bool isEnabled;
  final String maskedEmail;
  final bool isEmailVerified;

  final String error;

  // Token проверки пароля (CloudPasswordAuthFinish, на сервере живёт 10 минут) —
  // действия меню (сменить пароль/email/отключить) идут с ним, не переспрашивая
  // пароль; истёк — снова разблокировка. На шаге восстановления — token сброса
  // по коду из письма. Только в памяти.
  final List<int> heldToken;
  // Email, ожидающий подтверждения (показывается на экране ввода кода).
  final String pendingEmail;

  const SettingsCloudPasswordState({
    this.step = SettingsCloudPasswordStep.loading,
    this.networkStatus = Status.initialization,
    this.loadError = false,
    this.offline = false,
    this.isEnabled = false,
    this.maskedEmail = "",
    this.isEmailVerified = false,
    this.error = "",
    this.heldToken = const [],
    this.pendingEmail = "",
  });

  /// Корневой шаг — системный «назад» закрывает экран; иначе возвращает на
  /// предыдущий шаг (см. [SettingsCloudPasswordCubit.back]).
  bool get isRootStep =>
      step == SettingsCloudPasswordStep.loading ||
      step == SettingsCloudPasswordStep.setupEmail ||
      step == SettingsCloudPasswordStep.setupPassword ||
      step == SettingsCloudPasswordStep.unlock ||
      step == SettingsCloudPasswordStep.menu;
}
