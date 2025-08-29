part of 'passcode_cubit.dart';

@freezed
abstract class PasscodeState with _$PasscodeState {
    const PasscodeState._();

  const factory PasscodeState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
    @Default("") String passCode,
    @Default(0) int passCodeTtl,
    @Default(false) bool passCodeLock,
  }) = _PasscodeState;
}
