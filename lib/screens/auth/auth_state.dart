part of 'auth_cubit.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(Status.initialization) Status status,
    @Default("") String error,
  }) = _AuthState;
}
