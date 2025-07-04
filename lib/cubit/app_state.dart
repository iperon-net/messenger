part of 'app_cubit.dart';

enum ThemeColor { blue, green }
enum DarkMode { system, disabled, alwaysOn }

@freezed
abstract class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    @Default(Status.initial) Status status,
    @Default(ThemeColor.blue) ThemeColor themeColor,
    @Default(DarkMode.system) DarkMode darkMode,
  }) = _AppState;
}
