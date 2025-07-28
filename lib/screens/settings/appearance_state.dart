part of 'appearance_cubit.dart';

@freezed
abstract class AppearanceState with _$AppearanceState {
  const AppearanceState._();

  const factory AppearanceState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
    @Default(models.SettingsDeviceThemeColor.blue) models.SettingsDeviceThemeColor themeColor,
    @Default(models.SettingsDeviceThemeColor.blue) models.SettingsDeviceThemeColor selectedThemeColor,
    @Default(models.SettingsDeviceDarkMode.system) models.SettingsDeviceDarkMode darkMode,
    @Default(models.SettingsDeviceDarkMode.system) models.SettingsDeviceDarkMode selectedDarkMode,
    @Default("") String action,
  }) = _AppearanceState;
}
