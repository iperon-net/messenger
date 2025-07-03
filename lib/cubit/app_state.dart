part of 'app_cubit.dart';

enum AppTheme { system, light, dark }

@freezed
abstract class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    @Default(Status.initial) Status status,
    @Default(AppTheme.system) AppTheme theme,
  }) = _AppState;
}
