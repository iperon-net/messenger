part of 'home_cubit.dart';

@freezed
abstract class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    @Default(1) int cupertinoTabIndex,
  }) = _HomeState;

}
