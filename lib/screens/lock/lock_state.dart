part of 'lock_cubit.dart';

@freezed
abstract class LockState with _$LockState {
    const LockState._();

  const factory LockState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
  }) = _LockState;
}
