part of 'main_cubit.dart';

@freezed
abstract class MainState with _$MainState {
  const factory MainState({
    @Default(Status.initialization) Status loadingStatus,
    @Default(Status.initialization) Status processingStatus,
    @Default("") String error,
  }) = _MainState;

}
