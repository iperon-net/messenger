part of 'privacy_and_security_cubit.dart';

@freezed
abstract class PrivacyAndSecurityState with _$PrivacyAndSecurityState {
    const PrivacyAndSecurityState._();

  const factory PrivacyAndSecurityState({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
  }) = _PrivacyAndSecurityState;
}
