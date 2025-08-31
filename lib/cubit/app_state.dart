part of 'app_cubit.dart';

@freezed
abstract class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    @Default(Status.initial) Status status,
    @Default(models.SettingsDeviceThemeColor.blue) models.SettingsDeviceThemeColor themeColor,
    @Default(models.SettingsDeviceDarkMode.system) models.SettingsDeviceDarkMode darkMode,
    @Default("") String passCode,
    @Default(0) int passCodeTtl,
    @Default(0) int passCodeTimer,

    @Default(0) int viewTaskSwitchingEnable,
    @Default(false) bool viewTaskSwitching,
  }) = _AppState;
}
