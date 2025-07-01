part of 'app_cubit.dart';

enum AppBrightness { system, light, dark }

@freezed
abstract class AppState with _$AppState {
  const AppState._();

  const factory AppState({
    @Default(Status.initial) Status status,
    @Default(AppBrightness.system) AppBrightness appBrightness,
  }) = _AppState;
}
