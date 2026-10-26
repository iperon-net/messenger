// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_qr_state.dart';

class AuthQrStateMapper extends ClassMapperBase<AuthQrState> {
  AuthQrStateMapper._();

  static AuthQrStateMapper? _instance;
  static AuthQrStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthQrStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthQrState';

  static Status _$status(AuthQrState v) => v.status;
  static const Field<AuthQrState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$qrData(AuthQrState v) => v.qrData;
  static const Field<AuthQrState, String> _f$qrData = Field(
    'qrData',
    _$qrData,
    opt: true,
    def: "",
  );
  static String _$error(AuthQrState v) => v.error;
  static const Field<AuthQrState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static String _$redirectURI(AuthQrState v) => v.redirectURI;
  static const Field<AuthQrState, String> _f$redirectURI = Field(
    'redirectURI',
    _$redirectURI,
    opt: true,
    def: "",
  );
  static bool _$completing(AuthQrState v) => v.completing;
  static const Field<AuthQrState, bool> _f$completing = Field(
    'completing',
    _$completing,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<AuthQrState> fields = const {
    #status: _f$status,
    #qrData: _f$qrData,
    #error: _f$error,
    #redirectURI: _f$redirectURI,
    #completing: _f$completing,
  };

  static AuthQrState _instantiate(DecodingData data) {
    return AuthQrState(
      status: data.dec(_f$status),
      qrData: data.dec(_f$qrData),
      error: data.dec(_f$error),
      redirectURI: data.dec(_f$redirectURI),
      completing: data.dec(_f$completing),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthQrState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthQrState>(map);
  }

  static AuthQrState fromJson(String json) {
    return ensureInitialized().decodeJson<AuthQrState>(json);
  }
}

mixin AuthQrStateMappable {
  String toJson() {
    return AuthQrStateMapper.ensureInitialized().encodeJson<AuthQrState>(
      this as AuthQrState,
    );
  }

  Map<String, dynamic> toMap() {
    return AuthQrStateMapper.ensureInitialized().encodeMap<AuthQrState>(
      this as AuthQrState,
    );
  }

  AuthQrStateCopyWith<AuthQrState, AuthQrState, AuthQrState> get copyWith =>
      _AuthQrStateCopyWithImpl<AuthQrState, AuthQrState>(
        this as AuthQrState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthQrStateMapper.ensureInitialized().stringifyValue(
      this as AuthQrState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthQrStateMapper.ensureInitialized().equalsValue(
      this as AuthQrState,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthQrStateMapper.ensureInitialized().hashValue(this as AuthQrState);
  }
}

extension AuthQrStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthQrState, $Out> {
  AuthQrStateCopyWith<$R, AuthQrState, $Out> get $asAuthQrState =>
      $base.as((v, t, t2) => _AuthQrStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthQrStateCopyWith<$R, $In extends AuthQrState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Status? status,
    String? qrData,
    String? error,
    String? redirectURI,
    bool? completing,
  });
  AuthQrStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthQrStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthQrState, $Out>
    implements AuthQrStateCopyWith<$R, AuthQrState, $Out> {
  _AuthQrStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthQrState> $mapper =
      AuthQrStateMapper.ensureInitialized();
  @override
  $R call({
    Status? status,
    String? qrData,
    String? error,
    String? redirectURI,
    bool? completing,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (qrData != null) #qrData: qrData,
      if (error != null) #error: error,
      if (redirectURI != null) #redirectURI: redirectURI,
      if (completing != null) #completing: completing,
    }),
  );
  @override
  AuthQrState $make(CopyWithData data) => AuthQrState(
    status: data.get(#status, or: $value.status),
    qrData: data.get(#qrData, or: $value.qrData),
    error: data.get(#error, or: $value.error),
    redirectURI: data.get(#redirectURI, or: $value.redirectURI),
    completing: data.get(#completing, or: $value.completing),
  );

  @override
  AuthQrStateCopyWith<$R2, AuthQrState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthQrStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

