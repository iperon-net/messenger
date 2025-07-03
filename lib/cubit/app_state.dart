part of 'app_cubit.dart';

enum ColorTheme { blue, green }
enum DarkMode { system, disabled, alwaysOn }

@freezed
abstract class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    @Default(Status.initial) Status status,
    @Default(ColorTheme.blue) ColorTheme colorTheme,
    @Default(DarkMode.system) DarkMode darkMode,
  }) = _AppState;
}
