part of 'auth_sms_cubit.dart';

@freezed
abstract class AuthSmsState with _$AuthSmsState {
  const factory AuthSmsState({
    @Default(Status.initialization) Status status,
    @Default("") String error,
  }) = _AuthSmsState;
}
