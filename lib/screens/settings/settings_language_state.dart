part of 'settings_language_cubit.dart';

@freezed
abstract class SettingsLanguageState with _$SettingsLanguageState {
  const factory SettingsLanguageState({
    @Default(Status.initialization) Status status,
    @Default("") String error,
  }) = _SettingsLanguageState;
}
