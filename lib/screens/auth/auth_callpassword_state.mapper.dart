// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_callpassword_state.dart';

class AuthCallpasswordStateMapper
    extends ClassMapperBase<AuthCallpasswordState> {
  AuthCallpasswordStateMapper._();

  static AuthCallpasswordStateMapper? _instance;
  static AuthCallpasswordStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthCallpasswordStateMapper._());
      UserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthCallpasswordState';

  static Status _$status(AuthCallpasswordState v) => v.status;
  static const Field<AuthCallpasswordState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(AuthCallpasswordState v) => v.error;
  static const Field<AuthCallpasswordState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static List<int> _$confirmationSession(AuthCallpasswordState v) =>
      v.confirmationSession;
  static const Field<AuthCallpasswordState, List<int>> _f$confirmationSession =
      Field(
        'confirmationSession',
        _$confirmationSession,
        opt: true,
        def: const [],
      );
  static int _$tickerSecond(AuthCallpasswordState v) => v.tickerSecond;
  static const Field<AuthCallpasswordState, int> _f$tickerSecond = Field(
    'tickerSecond',
    _$tickerSecond,
    opt: true,
    def: 0,
  );
  static bool _$isBlocked(AuthCallpasswordState v) => v.isBlocked;
  static const Field<AuthCallpasswordState, bool> _f$isBlocked = Field(
    'isBlocked',
    _$isBlocked,
    opt: true,
    def: false,
  );
  static bool _$hasCloudPassword(AuthCallpasswordState v) => v.hasCloudPassword;
  static const Field<AuthCallpasswordState, bool> _f$hasCloudPassword = Field(
    'hasCloudPassword',
    _$hasCloudPassword,
    opt: true,
    def: false,
  );
  static User _$user(AuthCallpasswordState v) => v.user;
  static const Field<AuthCallpasswordState, User> _f$user = Field(
    'user',
    _$user,
    opt: true,
    def: const User(),
  );

  @override
  final MappableFields<AuthCallpasswordState> fields = const {
    #status: _f$status,
    #error: _f$error,
    #confirmationSession: _f$confirmationSession,
    #tickerSecond: _f$tickerSecond,
    #isBlocked: _f$isBlocked,
    #hasCloudPassword: _f$hasCloudPassword,
    #user: _f$user,
  };

  static AuthCallpasswordState _instantiate(DecodingData data) {
    return AuthCallpasswordState(
      status: data.dec(_f$status),
      error: data.dec(_f$error),
      confirmationSession: data.dec(_f$confirmationSession),
      tickerSecond: data.dec(_f$tickerSecond),
      isBlocked: data.dec(_f$isBlocked),
      hasCloudPassword: data.dec(_f$hasCloudPassword),
      user: data.dec(_f$user),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthCallpasswordState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthCallpasswordState>(map);
  }

  static AuthCallpasswordState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthCallpasswordState>(json);
  }
}

mixin AuthCallpasswordStateMappable {
  String toJson() {
    return AuthCallpasswordStateMapper.ensureInitialized()
        .encodeJson<AuthCallpasswordState>(this as AuthCallpasswordState);
  }

  Map<String, dynamic> toMap() {
    return AuthCallpasswordStateMapper.ensureInitialized()
        .encodeMap<AuthCallpasswordState>(this as AuthCallpasswordState);
  }

  AuthCallpasswordStateCopyWith<
    AuthCallpasswordState,
    AuthCallpasswordState,
    AuthCallpasswordState
  >
  get copyWith =>
      _AuthCallpasswordStateCopyWithImpl<
        AuthCallpasswordState,
        AuthCallpasswordState
      >(this as AuthCallpasswordState, $identity, $identity);
  @override
  String toString() {
    return AuthCallpasswordStateMapper.ensureInitialized().stringifyValue(
      this as AuthCallpasswordState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthCallpasswordStateMapper.ensureInitialized().equalsValue(
      this as AuthCallpasswordState,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthCallpasswordStateMapper.ensureInitialized().hashValue(
      this as AuthCallpasswordState,
    );
  }
}

extension AuthCallpasswordStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthCallpasswordState, $Out> {
  AuthCallpasswordStateCopyWith<$R, AuthCallpasswordState, $Out>
  get $asAuthCallpasswordState => $base.as(
    (v, t, t2) => _AuthCallpasswordStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AuthCallpasswordStateCopyWith<
  $R,
  $In extends AuthCallpasswordState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get confirmationSession;
  UserCopyWith<$R, User, User> get user;
  $R call({
    Status? status,
    String? error,
    List<int>? confirmationSession,
    int? tickerSecond,
    bool? isBlocked,
    bool? hasCloudPassword,
    User? user,
  });
  AuthCallpasswordStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AuthCallpasswordStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthCallpasswordState, $Out>
    implements AuthCallpasswordStateCopyWith<$R, AuthCallpasswordState, $Out> {
  _AuthCallpasswordStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthCallpasswordState> $mapper =
      AuthCallpasswordStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get confirmationSession =>
      ListCopyWith(
        $value.confirmationSession,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(confirmationSession: v),
      );
  @override
  UserCopyWith<$R, User, User> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  $R call({
    Status? status,
    String? error,
    List<int>? confirmationSession,
    int? tickerSecond,
    bool? isBlocked,
    bool? hasCloudPassword,
    User? user,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (error != null) #error: error,
      if (confirmationSession != null)
        #confirmationSession: confirmationSession,
      if (tickerSecond != null) #tickerSecond: tickerSecond,
      if (isBlocked != null) #isBlocked: isBlocked,
      if (hasCloudPassword != null) #hasCloudPassword: hasCloudPassword,
      if (user != null) #user: user,
    }),
  );
  @override
  AuthCallpasswordState $make(CopyWithData data) => AuthCallpasswordState(
    status: data.get(#status, or: $value.status),
    error: data.get(#error, or: $value.error),
    confirmationSession: data.get(
      #confirmationSession,
      or: $value.confirmationSession,
    ),
    tickerSecond: data.get(#tickerSecond, or: $value.tickerSecond),
    isBlocked: data.get(#isBlocked, or: $value.isBlocked),
    hasCloudPassword: data.get(#hasCloudPassword, or: $value.hasCloudPassword),
    user: data.get(#user, or: $value.user),
  );

  @override
  AuthCallpasswordStateCopyWith<$R2, AuthCallpasswordState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AuthCallpasswordStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

