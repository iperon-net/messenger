// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_callpassword_confirmation_state.dart';

class AuthCallpasswordConfirmationStateMapper
    extends ClassMapperBase<AuthCallpasswordConfirmationState> {
  AuthCallpasswordConfirmationStateMapper._();

  static AuthCallpasswordConfirmationStateMapper? _instance;
  static AuthCallpasswordConfirmationStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = AuthCallpasswordConfirmationStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'AuthCallpasswordConfirmationState';

  static Status _$status(AuthCallpasswordConfirmationState v) => v.status;
  static const Field<AuthCallpasswordConfirmationState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static List<int> _$callPasswordSession(AuthCallpasswordConfirmationState v) =>
      v.callPasswordSession;
  static const Field<AuthCallpasswordConfirmationState, List<int>>
  _f$callPasswordSession = Field(
    'callPasswordSession',
    _$callPasswordSession,
    opt: true,
    def: const [],
  );
  static String _$confirmationPhoneNumber(AuthCallpasswordConfirmationState v) =>
      v.confirmationPhoneNumber;
  static const Field<AuthCallpasswordConfirmationState, String>
  _f$confirmationPhoneNumber = Field(
    'confirmationPhoneNumber',
    _$confirmationPhoneNumber,
    opt: true,
    def: "",
  );
  static int _$timeout(AuthCallpasswordConfirmationState v) => v.timeout;
  static const Field<AuthCallpasswordConfirmationState, int> _f$timeout = Field(
    'timeout',
    _$timeout,
    opt: true,
    def: 0,
  );
  static int _$tickerSecond(AuthCallpasswordConfirmationState v) => v.tickerSecond;
  static const Field<AuthCallpasswordConfirmationState, int> _f$tickerSecond = Field(
    'tickerSecond',
    _$tickerSecond,
    opt: true,
    def: 0,
  );
  static AuthCallPasswordConfirmationResult _$result(AuthCallpasswordConfirmationState v) =>
      v.result;
  static const Field<AuthCallpasswordConfirmationState, AuthCallPasswordConfirmationResult>
  _f$result = Field(
    'result',
    _$result,
    opt: true,
    def: AuthCallPasswordConfirmationResult.waiting,
  );
  static String? _$error(AuthCallpasswordConfirmationState v) => v.error;
  static const Field<AuthCallpasswordConfirmationState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
  );
  static Uri? _$redirectURI(AuthCallpasswordConfirmationState v) => v.redirectURI;
  static const Field<AuthCallpasswordConfirmationState, Uri> _f$redirectURI = Field(
    'redirectURI',
    _$redirectURI,
    opt: true,
  );
  static List<int> _$confirmationSession(AuthCallpasswordConfirmationState v) =>
      v.confirmationSession;
  static const Field<AuthCallpasswordConfirmationState, List<int>>
  _f$confirmationSession = Field(
    'confirmationSession',
    _$confirmationSession,
    opt: true,
    def: const [],
  );
  static bool _$hasTwoStepVerification(AuthCallpasswordConfirmationState v) =>
      v.hasTwoStepVerification;
  static const Field<AuthCallpasswordConfirmationState, bool>
  _f$hasTwoStepVerification = Field(
    'hasTwoStepVerification',
    _$hasTwoStepVerification,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<AuthCallpasswordConfirmationState> fields = const {
    #status: _f$status,
    #callPasswordSession: _f$callPasswordSession,
    #confirmationPhoneNumber: _f$confirmationPhoneNumber,
    #timeout: _f$timeout,
    #tickerSecond: _f$tickerSecond,
    #result: _f$result,
    #error: _f$error,
    #redirectURI: _f$redirectURI,
    #confirmationSession: _f$confirmationSession,
    #hasTwoStepVerification: _f$hasTwoStepVerification,
  };

  static AuthCallpasswordConfirmationState _instantiate(DecodingData data) {
    return AuthCallpasswordConfirmationState(
      status: data.dec(_f$status),
      callPasswordSession: data.dec(_f$callPasswordSession),
      confirmationPhoneNumber: data.dec(_f$confirmationPhoneNumber),
      timeout: data.dec(_f$timeout),
      tickerSecond: data.dec(_f$tickerSecond),
      result: data.dec(_f$result),
      error: data.dec(_f$error),
      redirectURI: data.dec(_f$redirectURI),
      confirmationSession: data.dec(_f$confirmationSession),
      hasTwoStepVerification: data.dec(_f$hasTwoStepVerification),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthCallpasswordConfirmationState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthCallpasswordConfirmationState>(map);
  }

  static AuthCallpasswordConfirmationState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthCallpasswordConfirmationState>(json);
  }
}

mixin AuthCallpasswordConfirmationStateMappable {
  String toJson() {
    return AuthCallpasswordConfirmationStateMapper.ensureInitialized()
        .encodeJson<AuthCallpasswordConfirmationState>(
          this as AuthCallpasswordConfirmationState,
        );
  }

  Map<String, dynamic> toMap() {
    return AuthCallpasswordConfirmationStateMapper.ensureInitialized()
        .encodeMap<AuthCallpasswordConfirmationState>(
          this as AuthCallpasswordConfirmationState,
        );
  }

  AuthCallpasswordConfirmationStateCopyWith<
    AuthCallpasswordConfirmationState,
    AuthCallpasswordConfirmationState,
    AuthCallpasswordConfirmationState
  >
  get copyWith =>
      _AuthCallpasswordConfirmationStateCopyWithImpl<
        AuthCallpasswordConfirmationState,
        AuthCallpasswordConfirmationState
      >(this as AuthCallpasswordConfirmationState, $identity, $identity);
  @override
  String toString() {
    return AuthCallpasswordConfirmationStateMapper.ensureInitialized().stringifyValue(
      this as AuthCallpasswordConfirmationState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthCallpasswordConfirmationStateMapper.ensureInitialized().equalsValue(
      this as AuthCallpasswordConfirmationState,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthCallpasswordConfirmationStateMapper.ensureInitialized().hashValue(
      this as AuthCallpasswordConfirmationState,
    );
  }
}

extension AuthCallpasswordConfirmationStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthCallpasswordConfirmationState, $Out> {
  AuthCallpasswordConfirmationStateCopyWith<$R, AuthCallpasswordConfirmationState, $Out>
  get $asAuthCallpasswordConfirmationState => $base.as(
    (v, t, t2) => _AuthCallpasswordConfirmationStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AuthCallpasswordConfirmationStateCopyWith<
  $R,
  $In extends AuthCallpasswordConfirmationState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get callPasswordSession;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get confirmationSession;
  $R call({
    Status? status,
    List<int>? callPasswordSession,
    String? confirmationPhoneNumber,
    int? timeout,
    int? tickerSecond,
    AuthCallPasswordConfirmationResult? result,
    String? error,
    Uri? redirectURI,
    List<int>? confirmationSession,
    bool? hasTwoStepVerification,
  });
  AuthCallpasswordConfirmationStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AuthCallpasswordConfirmationStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthCallpasswordConfirmationState, $Out>
    implements
        AuthCallpasswordConfirmationStateCopyWith<
          $R,
          AuthCallpasswordConfirmationState,
          $Out
        > {
  _AuthCallpasswordConfirmationStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthCallpasswordConfirmationState> $mapper =
      AuthCallpasswordConfirmationStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get callPasswordSession =>
      ListCopyWith(
        $value.callPasswordSession,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(callPasswordSession: v),
      );
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
    List<int>? callPasswordSession,
    String? confirmationPhoneNumber,
    int? timeout,
    int? tickerSecond,
    AuthCallPasswordConfirmationResult? result,
    Object? error = $none,
    Object? redirectURI = $none,
    List<int>? confirmationSession,
    bool? hasTwoStepVerification,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (callPasswordSession != null)
        #callPasswordSession: callPasswordSession,
      if (confirmationPhoneNumber != null)
        #confirmationPhoneNumber: confirmationPhoneNumber,
      if (timeout != null) #timeout: timeout,
      if (tickerSecond != null) #tickerSecond: tickerSecond,
      if (result != null) #result: result,
      if (error != $none) #error: error,
      if (redirectURI != $none) #redirectURI: redirectURI,
      if (confirmationSession != null)
        #confirmationSession: confirmationSession,
      if (hasTwoStepVerification != null)
        #hasTwoStepVerification: hasTwoStepVerification,
    }),
  );
  @override
  AuthCallpasswordConfirmationState $make(CopyWithData data) =>
      AuthCallpasswordConfirmationState(
        status: data.get(#status, or: $value.status),
        callPasswordSession: data.get(
          #callPasswordSession,
          or: $value.callPasswordSession,
        ),
        confirmationPhoneNumber: data.get(
          #confirmationPhoneNumber,
          or: $value.confirmationPhoneNumber,
        ),
        timeout: data.get(#timeout, or: $value.timeout),
        tickerSecond: data.get(#tickerSecond, or: $value.tickerSecond),
        result: data.get(#result, or: $value.result),
        error: data.get(#error, or: $value.error),
        redirectURI: data.get(#redirectURI, or: $value.redirectURI),
        confirmationSession: data.get(
          #confirmationSession,
          or: $value.confirmationSession,
        ),
        hasTwoStepVerification: data.get(
          #hasTwoStepVerification,
          or: $value.hasTwoStepVerification,
        ),
      );

  @override
  AuthCallpasswordConfirmationStateCopyWith<$R2, AuthCallpasswordConfirmationState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AuthCallpasswordConfirmationStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

