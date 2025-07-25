part of 'passcode_cubit.dart';

@freezed
abstract class PasscodeState with _$PasscodeState {
    const PasscodeState._();

  const factory PasscodeState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
  }) = _PasscodeState;
}
