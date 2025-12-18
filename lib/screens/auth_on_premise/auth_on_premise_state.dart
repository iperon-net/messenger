part of 'auth_on_premise_cubit.dart';

@freezed
abstract class AuthOnPremiseState with _$AuthOnPremiseState {
  const factory AuthOnPremiseState({
    // @Default(Status.initialization) Status loadingStatus,
    // @Default(Status.initialization) Status processingStatus,

    @Default(false) bool debugListServers,
    @Default("") String errorFieldOrganizationServerUrl,

    @Default("") String error,
  }) = _AuthOnPremiseState;
}
