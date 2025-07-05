part of 'appearance_cubit.dart';

@freezed
abstract class AppearanceState with _$AppearanceState {
    const AppearanceState._();

  const factory AppearanceState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
    @Default(ThemeColor.blue) ThemeColor themeColor,
    @Default(ThemeColor.blue) ThemeColor chooseThemeColor,
    @Default(DarkMode.system) DarkMode darkMode,
    @Default(DarkMode.system) DarkMode chooseDarkMode,
  }) = _AppearanceState;
}
