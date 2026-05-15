part of 'settings_cubit.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(Status.initialization) Status status,
    @Default("") String error,
  }) = _SettingsState;
}
