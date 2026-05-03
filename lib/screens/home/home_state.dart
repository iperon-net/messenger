part of 'home_cubit.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int destinationSelectedIndex
  }) = _HomeState;
}
