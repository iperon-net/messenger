// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_sms_state.dart';

class AuthSmsStateMapper extends ClassMapperBase<AuthSmsState> {
  AuthSmsStateMapper._();

  static AuthSmsStateMapper? _instance;
  static AuthSmsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthSmsStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthSmsState';

  static Status _$status(AuthSmsState v) => v.status;
  static const Field<AuthSmsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(AuthSmsState v) => v.error;
  static const Field<AuthSmsState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );

  @override
  final MappableFields<AuthSmsState> fields = const {
    #status: _f$status,
    #error: _f$error,
  };

  static AuthSmsState _instantiate(DecodingData data) {
    return AuthSmsState(status: data.dec(_f$status), error: data.dec(_f$error));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthSmsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthSmsState>(map);
  }

  static AuthSmsState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthSmsState>(json);
  }
}

mixin AuthSmsStateMappable {
  String toJson() {
    return AuthSmsStateMapper.ensureInitialized().encodeJson<AuthSmsState>(
      this as AuthSmsState,
    );
  }

  Map<String, dynamic> toMap() {
    return AuthSmsStateMapper.ensureInitialized().encodeMap<AuthSmsState>(
      this as AuthSmsState,
    );
  }

  AuthSmsStateCopyWith<AuthSmsState, AuthSmsState, AuthSmsState> get copyWith =>
      _AuthSmsStateCopyWithImpl<AuthSmsState, AuthSmsState>(
        this as AuthSmsState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthSmsStateMapper.ensureInitialized().stringifyValue(
      this as AuthSmsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthSmsStateMapper.ensureInitialized().equalsValue(
      this as AuthSmsState,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthSmsStateMapper.ensureInitialized().hashValue(
      this as AuthSmsState,
    );
  }
}

extension AuthSmsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthSmsState, $Out> {
  AuthSmsStateCopyWith<$R, AuthSmsState, $Out> get $asAuthSmsState =>
      $base.as((v, t, t2) => _AuthSmsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthSmsStateCopyWith<$R, $In extends AuthSmsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status, String? error});
  AuthSmsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthSmsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthSmsState, $Out>
    implements AuthSmsStateCopyWith<$R, AuthSmsState, $Out> {
  _AuthSmsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthSmsState> $mapper =
      AuthSmsStateMapper.ensureInitialized();
  @override
  $R call({Status? status, String? error}) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (error != null) #error: error,
    }),
  );
  @override
  AuthSmsState $make(CopyWithData data) => AuthSmsState(
    status: data.get(#status, or: $value.status),
    error: data.get(#error, or: $value.error),
  );

  @override
  AuthSmsStateCopyWith<$R2, AuthSmsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthSmsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

