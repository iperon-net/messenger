part of 'auth_callpassword_cubit.dart';

@freezed
abstract class AuthCallpasswordState with _$AuthCallpasswordState {
  const factory AuthCallpasswordState({
    @Default(Status.initialization) Status status,
    @Default("") String error,

    @Default([]) List<int> confirmationSession,
    @Default(0) int tickerSecond,
    @Default(false) bool isBlocked,
    @Default(false) bool hasCloudPassword,
    @Default(User()) User user,

  }) = _AuthCallpasswordState;
}
