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

  final bool isEnabled;
  final String maskedEmail;
  final bool isEmailVerified;

  final String error;

  // Текущий пароль, введённый при разблокировке/установке — держим в памяти, чтобы
  // действия меню (сменить пароль/email/отключить) не переспрашивали его. Никуда
  // не персистится.
  final List<int> heldPwHash;
  // Email, ожидающий подтверждения (показывается на экране ввода кода).
  final String pendingEmail;

  const SettingsCloudPasswordState({
    this.step = SettingsCloudPasswordStep.loading,
    this.networkStatus = Status.initialization,
    this.loadError = false,
    this.isEnabled = false,
    this.maskedEmail = "",
    this.isEmailVerified = false,
    this.error = "",
    this.heldPwHash = const [],
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
