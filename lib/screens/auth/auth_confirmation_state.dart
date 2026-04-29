part of 'auth_confirmation_cubit.dart';

@freezed
abstract class AuthConfirmationState with _$AuthConfirmationState {
  const factory AuthConfirmationState({
    @Default(Status.initialization) Status status,
    @Default("") String error,
  }) = _AuthConfirmationState;
}
