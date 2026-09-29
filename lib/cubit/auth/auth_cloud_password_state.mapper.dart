// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_cloud_password_state.dart';

class AuthCloudPasswordStateMapper
    extends ClassMapperBase<AuthCloudPasswordState> {
  AuthCloudPasswordStateMapper._();

  static AuthCloudPasswordStateMapper? _instance;
  static AuthCloudPasswordStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthCloudPasswordStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthCloudPasswordState';

  static Status _$status(AuthCloudPasswordState v) => v.status;
  static const Field<AuthCloudPasswordState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static Status _$networkStatus(AuthCloudPasswordState v) => v.networkStatus;
  static const Field<AuthCloudPasswordState, Status> _f$networkStatus = Field(
    'networkStatus',
    _$networkStatus,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(AuthCloudPasswordState v) => v.error;
  static const Field<AuthCloudPasswordState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static String _$redirectURI(AuthCloudPasswordState v) => v.redirectURI;
  static const Field<AuthCloudPasswordState, String> _f$redirectURI = Field(
    'redirectURI',
    _$redirectURI,
    opt: true,
    def: "",
  );
  static List<int> _$confirmationSession(AuthCloudPasswordState v) =>
      v.confirmationSession;
  static const Field<AuthCloudPasswordState, List<int>> _f$confirmationSession =
      Field(
        'confirmationSession',
        _$confirmationSession,
        opt: true,
        def: const [],
      );
  static AuthCloudPasswordPhase _$phase(AuthCloudPasswordState v) => v.phase;
  static const Field<AuthCloudPasswordState, AuthCloudPasswordPhase> _f$phase =
      Field(
        'phase',
        _$phase,
        opt: true,
        def: AuthCloudPasswordPhase.enterPassword,
      );
  static int _$attemptsLeft(AuthCloudPasswordState v) => v.attemptsLeft;
  static const Field<AuthCloudPasswordState, int> _f$attemptsLeft = Field(
    'attemptsLeft',
    _$attemptsLeft,
    opt: true,
    def: -1,
  );
  static String _$maskedEmail(AuthCloudPasswordState v) => v.maskedEmail;
  static const Field<AuthCloudPasswordState, String> _f$maskedEmail = Field(
    'maskedEmail',
    _$maskedEmail,
    opt: true,
    def: "",
  );
  static String _$pendingEmail(AuthCloudPasswordState v) => v.pendingEmail;
  static const Field<AuthCloudPasswordState, String> _f$pendingEmail = Field(
    'pendingEmail',
    _$pendingEmail,
    opt: true,
    def: "",
  );

  @override
  final MappableFields<AuthCloudPasswordState> fields = const {
    #status: _f$status,
    #networkStatus: _f$networkStatus,
    #error: _f$error,
    #redirectURI: _f$redirectURI,
    #confirmationSession: _f$confirmationSession,
    #phase: _f$phase,
    #attemptsLeft: _f$attemptsLeft,
    #maskedEmail: _f$maskedEmail,
    #pendingEmail: _f$pendingEmail,
  };

  static AuthCloudPasswordState _instantiate(DecodingData data) {
    return AuthCloudPasswordState(
      status: data.dec(_f$status),
      networkStatus: data.dec(_f$networkStatus),
      error: data.dec(_f$error),
      redirectURI: data.dec(_f$redirectURI),
      confirmationSession: data.dec(_f$confirmationSession),
      phase: data.dec(_f$phase),
      attemptsLeft: data.dec(_f$attemptsLeft),
      maskedEmail: data.dec(_f$maskedEmail),
      pendingEmail: data.dec(_f$pendingEmail),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthCloudPasswordState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthCloudPasswordState>(map);
  }

  static AuthCloudPasswordState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthCloudPasswordState>(json);
  }
}

mixin AuthCloudPasswordStateMappable {
  String toJson() {
    return AuthCloudPasswordStateMapper.ensureInitialized()
        .encodeJson<AuthCloudPasswordState>(this as AuthCloudPasswordState);
  }

  Map<String, dynamic> toMap() {
    return AuthCloudPasswordStateMapper.ensureInitialized()
        .encodeMap<AuthCloudPasswordState>(this as AuthCloudPasswordState);
  }

  AuthCloudPasswordStateCopyWith<
    AuthCloudPasswordState,
    AuthCloudPasswordState,
    AuthCloudPasswordState
  >
  get copyWith =>
      _AuthCloudPasswordStateCopyWithImpl<
        AuthCloudPasswordState,
        AuthCloudPasswordState
      >(this as AuthCloudPasswordState, $identity, $identity);
  @override
  String toString() {
    return AuthCloudPasswordStateMapper.ensureInitialized().stringifyValue(
      this as AuthCloudPasswordState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthCloudPasswordStateMapper.ensureInitialized().equalsValue(
      this as AuthCloudPasswordState,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthCloudPasswordStateMapper.ensureInitialized().hashValue(
      this as AuthCloudPasswordState,
    );
  }
}

extension AuthCloudPasswordStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthCloudPasswordState, $Out> {
  AuthCloudPasswordStateCopyWith<$R, AuthCloudPasswordState, $Out>
  get $asAuthCloudPasswordState => $base.as(
    (v, t, t2) => _AuthCloudPasswordStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AuthCloudPasswordStateCopyWith<
  $R,
  $In extends AuthCloudPasswordState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get confirmationSession;
  $R call({
    Status? status,
    Status? networkStatus,
    String? error,
    String? redirectURI,
    List<int>? confirmationSession,
    AuthCloudPasswordPhase? phase,
    int? attemptsLeft,
    String? maskedEmail,
    String? pendingEmail,
  });
  AuthCloudPasswordStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AuthCloudPasswordStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthCloudPasswordState, $Out>
    implements
        AuthCloudPasswordStateCopyWith<$R, AuthCloudPasswordState, $Out> {
  _AuthCloudPasswordStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthCloudPasswordState> $mapper =
      AuthCloudPasswordStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get confirmationSession =>
      ListCopyWith(
        $value.confirmationSession,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(confirmationSession: v),
      );
  @override
  $R call({
    Status? status,
    Status? networkStatus,
    String? error,
    String? redirectURI,
    List<int>? confirmationSession,
    AuthCloudPasswordPhase? phase,
    int? attemptsLeft,
    String? maskedEmail,
    String? pendingEmail,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (networkStatus != null) #networkStatus: networkStatus,
      if (error != null) #error: error,
      if (redirectURI != null) #redirectURI: redirectURI,
      if (confirmationSession != null)
        #confirmationSession: confirmationSession,
      if (phase != null) #phase: phase,
      if (attemptsLeft != null) #attemptsLeft: attemptsLeft,
      if (maskedEmail != null) #maskedEmail: maskedEmail,
      if (pendingEmail != null) #pendingEmail: pendingEmail,
    }),
  );
  @override
  AuthCloudPasswordState $make(CopyWithData data) => AuthCloudPasswordState(
    status: data.get(#status, or: $value.status),
    networkStatus: data.get(#networkStatus, or: $value.networkStatus),
    error: data.get(#error, or: $value.error),
    redirectURI: data.get(#redirectURI, or: $value.redirectURI),
    confirmationSession: data.get(
      #confirmationSession,
      or: $value.confirmationSession,
    ),
    phase: data.get(#phase, or: $value.phase),
    attemptsLeft: data.get(#attemptsLeft, or: $value.attemptsLeft),
    maskedEmail: data.get(#maskedEmail, or: $value.maskedEmail),
    pendingEmail: data.get(#pendingEmail, or: $value.pendingEmail),
  );

  @override
  AuthCloudPasswordStateCopyWith<$R2, AuthCloudPasswordState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AuthCloudPasswordStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

