part of 'main_cubit.dart';

@freezed
abstract class MainState with _$MainState {
  const factory MainState({
    @Default(Status.initialization) Status status,
    required SettingsDevice settingsDevice,
    required User user,

  }) = _MainState;
}
