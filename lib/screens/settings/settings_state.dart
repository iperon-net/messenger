part of 'settings_cubit.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const SettingsState._();

  const factory SettingsState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
    @Default("") String versionApplication,
  }) = _SettingsState;
}
