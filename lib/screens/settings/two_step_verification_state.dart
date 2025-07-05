part of 'two_step_verification_cubit.dart';

@freezed
abstract class TwoStepVerificationState with _$TwoStepVerificationState {
    const TwoStepVerificationState._();

  const factory TwoStepVerificationState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
  }) = _TwoStepVerificationState;
}
