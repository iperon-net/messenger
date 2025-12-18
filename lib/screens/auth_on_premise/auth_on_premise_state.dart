part of 'auth_on_premise_cubit.dart';

@freezed
abstract class AuthOnPremiseState with _$AuthOnPremiseState {
  const factory AuthOnPremiseState({
    @Default(Status.initialization) Status status,
    @Default(Status.initialization) Status executeStatus,

    @Default(false) bool debugListServers,
    @Default("") String errorFieldOrganizationServerUrl,

    @Default("") String error,
  }) = _AuthOnPremiseState;
}
