// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_moderation_application_store_state.dart';

class AuthModerationApplicationStoreStateMapper
    extends ClassMapperBase<AuthModerationApplicationStoreState> {
  AuthModerationApplicationStoreStateMapper._();

  static AuthModerationApplicationStoreStateMapper? _instance;
  static AuthModerationApplicationStoreStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = AuthModerationApplicationStoreStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'AuthModerationApplicationStoreState';

  static Status _$status(AuthModerationApplicationStoreState v) => v.status;
  static const Field<AuthModerationApplicationStoreState, Status> _f$status =
      Field('status', _$status, opt: true, def: Status.initialization);
  static Status _$networkStatus(AuthModerationApplicationStoreState v) =>
      v.networkStatus;
  static const Field<AuthModerationApplicationStoreState, Status>
  _f$networkStatus = Field(
    'networkStatus',
    _$networkStatus,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(AuthModerationApplicationStoreState v) => v.error;
  static const Field<AuthModerationApplicationStoreState, String> _f$error =
      Field('error', _$error, opt: true, def: "");
  static String _$redirectURI(AuthModerationApplicationStoreState v) =>
      v.redirectURI;
  static const Field<AuthModerationApplicationStoreState, String>
  _f$redirectURI = Field('redirectURI', _$redirectURI, opt: true, def: "");
  static Uint8List _$moderationApplicationStoreSession(
    AuthModerationApplicationStoreState v,
  ) => v.moderationApplicationStoreSession;
  static const Field<AuthModerationApplicationStoreState, Uint8List>
  _f$moderationApplicationStoreSession = Field(
    'moderationApplicationStoreSession',
    _$moderationApplicationStoreSession,
    opt: true,
  );
  static String _$phoneNumber(AuthModerationApplicationStoreState v) =>
      v.phoneNumber;
  static const Field<AuthModerationApplicationStoreState, String>
  _f$phoneNumber = Field('phoneNumber', _$phoneNumber, opt: true, def: "");

  @override
  final MappableFields<AuthModerationApplicationStoreState> fields = const {
    #status: _f$status,
    #networkStatus: _f$networkStatus,
    #error: _f$error,
    #redirectURI: _f$redirectURI,
    #moderationApplicationStoreSession: _f$moderationApplicationStoreSession,
    #phoneNumber: _f$phoneNumber,
  };

  static AuthModerationApplicationStoreState _instantiate(DecodingData data) {
    return AuthModerationApplicationStoreState(
      status: data.dec(_f$status),
      networkStatus: data.dec(_f$networkStatus),
      error: data.dec(_f$error),
      redirectURI: data.dec(_f$redirectURI),
      moderationApplicationStoreSession: data.dec(
        _f$moderationApplicationStoreSession,
      ),
      phoneNumber: data.dec(_f$phoneNumber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthModerationApplicationStoreState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthModerationApplicationStoreState>(
      map,
    );
  }

  static AuthModerationApplicationStoreState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthModerationApplicationStoreState>(
      json,
    );
  }
}

mixin AuthModerationApplicationStoreStateMappable {
  String toJson() {
    return AuthModerationApplicationStoreStateMapper.ensureInitialized()
        .encodeJson<AuthModerationApplicationStoreState>(
          this as AuthModerationApplicationStoreState,
        );
  }

  Map<String, dynamic> toMap() {
    return AuthModerationApplicationStoreStateMapper.ensureInitialized()
        .encodeMap<AuthModerationApplicationStoreState>(
          this as AuthModerationApplicationStoreState,
        );
  }

  AuthModerationApplicationStoreStateCopyWith<
    AuthModerationApplicationStoreState,
    AuthModerationApplicationStoreState,
    AuthModerationApplicationStoreState
  >
  get copyWith =>
      _AuthModerationApplicationStoreStateCopyWithImpl<
        AuthModerationApplicationStoreState,
        AuthModerationApplicationStoreState
      >(this as AuthModerationApplicationStoreState, $identity, $identity);
  @override
  String toString() {
    return AuthModerationApplicationStoreStateMapper.ensureInitialized()
        .stringifyValue(this as AuthModerationApplicationStoreState);
  }

  @override
  bool operator ==(Object other) {
    return AuthModerationApplicationStoreStateMapper.ensureInitialized()
        .equalsValue(this as AuthModerationApplicationStoreState, other);
  }

  @override
  int get hashCode {
    return AuthModerationApplicationStoreStateMapper.ensureInitialized()
        .hashValue(this as AuthModerationApplicationStoreState);
  }
}

extension AuthModerationApplicationStoreStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthModerationApplicationStoreState, $Out> {
  AuthModerationApplicationStoreStateCopyWith<
    $R,
    AuthModerationApplicationStoreState,
    $Out
  >
  get $asAuthModerationApplicationStoreState => $base.as(
    (v, t, t2) =>
        _AuthModerationApplicationStoreStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AuthModerationApplicationStoreStateCopyWith<
  $R,
  $In extends AuthModerationApplicationStoreState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Status? status,
    Status? networkStatus,
    String? error,
    String? redirectURI,
    Uint8List? moderationApplicationStoreSession,
    String? phoneNumber,
  });
  AuthModerationApplicationStoreStateCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthModerationApplicationStoreStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthModerationApplicationStoreState, $Out>
    implements
        AuthModerationApplicationStoreStateCopyWith<
          $R,
          AuthModerationApplicationStoreState,
          $Out
        > {
  _AuthModerationApplicationStoreStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<AuthModerationApplicationStoreState> $mapper =
      AuthModerationApplicationStoreStateMapper.ensureInitialized();
  @override
  $R call({
    Status? status,
    Status? networkStatus,
    String? error,
    String? redirectURI,
    Object? moderationApplicationStoreSession = $none,
    String? phoneNumber,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (networkStatus != null) #networkStatus: networkStatus,
      if (error != null) #error: error,
      if (redirectURI != null) #redirectURI: redirectURI,
      if (moderationApplicationStoreSession != $none)
        #moderationApplicationStoreSession: moderationApplicationStoreSession,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
    }),
  );
  @override
  AuthModerationApplicationStoreState $make(CopyWithData data) =>
      AuthModerationApplicationStoreState(
        status: data.get(#status, or: $value.status),
        networkStatus: data.get(#networkStatus, or: $value.networkStatus),
        error: data.get(#error, or: $value.error),
        redirectURI: data.get(#redirectURI, or: $value.redirectURI),
        moderationApplicationStoreSession: data.get(
          #moderationApplicationStoreSession,
          or: $value.moderationApplicationStoreSession,
        ),
        phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
      );

  @override
  AuthModerationApplicationStoreStateCopyWith<
    $R2,
    AuthModerationApplicationStoreState,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AuthModerationApplicationStoreStateCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

