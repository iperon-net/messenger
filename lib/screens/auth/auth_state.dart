part of 'auth_cubit.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(Status.initialization) Status status,
    @Default("") String error,

    @Default([]) List<int> callPasswordSession,
    @Default("") String confirmationPhoneNumber,
    @Default(0) double timeout,

  }) = _AuthState;
}
