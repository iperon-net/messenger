// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_privacy_and_security_state.dart';

class SettingsPrivacyAndSecurityStateMapper
    extends ClassMapperBase<SettingsPrivacyAndSecurityState> {
  SettingsPrivacyAndSecurityStateMapper._();

  static SettingsPrivacyAndSecurityStateMapper? _instance;
  static SettingsPrivacyAndSecurityStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsPrivacyAndSecurityStateMapper._(),
      );
      MapperContainer.globals.useAll([Uint8ListMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsPrivacyAndSecurityState';

  static Status _$status(SettingsPrivacyAndSecurityState v) => v.status;
  static const Field<SettingsPrivacyAndSecurityState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static bool _$isBiometricAvailable(SettingsPrivacyAndSecurityState v) =>
      v.isBiometricAvailable;
  static const Field<SettingsPrivacyAndSecurityState, bool>
  _f$isBiometricAvailable = Field(
    'isBiometricAvailable',
    _$isBiometricAvailable,
    opt: true,
    def: false,
  );
  static CallsPrivacyAudience _$callsAudience(
    SettingsPrivacyAndSecurityState v,
  ) => v.callsAudience;
  static const Field<SettingsPrivacyAndSecurityState, CallsPrivacyAudience>
  _f$callsAudience = Field(
    'callsAudience',
    _$callsAudience,
    opt: true,
    def: CallsPrivacyAudience.contacts,
  );
  static bool _$callsLoadError(SettingsPrivacyAndSecurityState v) =>
      v.callsLoadError;
  static const Field<SettingsPrivacyAndSecurityState, bool> _f$callsLoadError =
      Field('callsLoadError', _$callsLoadError, opt: true, def: false);
  static bool _$callsReadOnly(SettingsPrivacyAndSecurityState v) =>
      v.callsReadOnly;
  static const Field<SettingsPrivacyAndSecurityState, bool> _f$callsReadOnly =
      Field('callsReadOnly', _$callsReadOnly, opt: true, def: false);
  static List<Uint8List> _$callsAllow(SettingsPrivacyAndSecurityState v) =>
      v.callsAllow;
  static const Field<SettingsPrivacyAndSecurityState, List<Uint8List>>
  _f$callsAllow = Field('callsAllow', _$callsAllow, opt: true, def: const []);
  static List<Uint8List> _$callsDeny(SettingsPrivacyAndSecurityState v) =>
      v.callsDeny;
  static const Field<SettingsPrivacyAndSecurityState, List<Uint8List>>
  _f$callsDeny = Field('callsDeny', _$callsDeny, opt: true, def: const []);

  @override
  final MappableFields<SettingsPrivacyAndSecurityState> fields = const {
    #status: _f$status,
    #isBiometricAvailable: _f$isBiometricAvailable,
    #callsAudience: _f$callsAudience,
    #callsLoadError: _f$callsLoadError,
    #callsReadOnly: _f$callsReadOnly,
    #callsAllow: _f$callsAllow,
    #callsDeny: _f$callsDeny,
  };

  static SettingsPrivacyAndSecurityState _instantiate(DecodingData data) {
    return SettingsPrivacyAndSecurityState(
      status: data.dec(_f$status),
      isBiometricAvailable: data.dec(_f$isBiometricAvailable),
      callsAudience: data.dec(_f$callsAudience),
      callsLoadError: data.dec(_f$callsLoadError),
      callsReadOnly: data.dec(_f$callsReadOnly),
      callsAllow: data.dec(_f$callsAllow),
      callsDeny: data.dec(_f$callsDeny),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsPrivacyAndSecurityState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsPrivacyAndSecurityState>(map);
  }

  static SettingsPrivacyAndSecurityState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsPrivacyAndSecurityState>(
      json,
    );
  }
}

mixin SettingsPrivacyAndSecurityStateMappable {
  String toJson() {
    return SettingsPrivacyAndSecurityStateMapper.ensureInitialized()
        .encodeJson<SettingsPrivacyAndSecurityState>(
          this as SettingsPrivacyAndSecurityState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsPrivacyAndSecurityStateMapper.ensureInitialized()
        .encodeMap<SettingsPrivacyAndSecurityState>(
          this as SettingsPrivacyAndSecurityState,
        );
  }

  SettingsPrivacyAndSecurityStateCopyWith<
    SettingsPrivacyAndSecurityState,
    SettingsPrivacyAndSecurityState,
    SettingsPrivacyAndSecurityState
  >
  get copyWith =>
      _SettingsPrivacyAndSecurityStateCopyWithImpl<
        SettingsPrivacyAndSecurityState,
        SettingsPrivacyAndSecurityState
      >(this as SettingsPrivacyAndSecurityState, $identity, $identity);
  @override
  String toString() {
    return SettingsPrivacyAndSecurityStateMapper.ensureInitialized()
        .stringifyValue(this as SettingsPrivacyAndSecurityState);
  }

  @override
  bool operator ==(Object other) {
    return SettingsPrivacyAndSecurityStateMapper.ensureInitialized()
        .equalsValue(this as SettingsPrivacyAndSecurityState, other);
  }

  @override
  int get hashCode {
    return SettingsPrivacyAndSecurityStateMapper.ensureInitialized().hashValue(
      this as SettingsPrivacyAndSecurityState,
    );
  }
}

extension SettingsPrivacyAndSecurityStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsPrivacyAndSecurityState, $Out> {
  SettingsPrivacyAndSecurityStateCopyWith<
    $R,
    SettingsPrivacyAndSecurityState,
    $Out
  >
  get $asSettingsPrivacyAndSecurityState => $base.as(
    (v, t, t2) =>
        _SettingsPrivacyAndSecurityStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsPrivacyAndSecurityStateCopyWith<
  $R,
  $In extends SettingsPrivacyAndSecurityState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Uint8List, ObjectCopyWith<$R, Uint8List, Uint8List>>
  get callsAllow;
  ListCopyWith<$R, Uint8List, ObjectCopyWith<$R, Uint8List, Uint8List>>
  get callsDeny;
  $R call({
    Status? status,
    bool? isBiometricAvailable,
    CallsPrivacyAudience? callsAudience,
    bool? callsLoadError,
    bool? callsReadOnly,
    List<Uint8List>? callsAllow,
    List<Uint8List>? callsDeny,
  });
  SettingsPrivacyAndSecurityStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsPrivacyAndSecurityStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsPrivacyAndSecurityState, $Out>
    implements
        SettingsPrivacyAndSecurityStateCopyWith<
          $R,
          SettingsPrivacyAndSecurityState,
          $Out
        > {
  _SettingsPrivacyAndSecurityStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SettingsPrivacyAndSecurityState> $mapper =
      SettingsPrivacyAndSecurityStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Uint8List, ObjectCopyWith<$R, Uint8List, Uint8List>>
  get callsAllow => ListCopyWith(
    $value.callsAllow,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(callsAllow: v),
  );
  @override
  ListCopyWith<$R, Uint8List, ObjectCopyWith<$R, Uint8List, Uint8List>>
  get callsDeny => ListCopyWith(
    $value.callsDeny,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(callsDeny: v),
  );
  @override
  $R call({
    Status? status,
    bool? isBiometricAvailable,
    CallsPrivacyAudience? callsAudience,
    bool? callsLoadError,
    bool? callsReadOnly,
    List<Uint8List>? callsAllow,
    List<Uint8List>? callsDeny,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (isBiometricAvailable != null)
        #isBiometricAvailable: isBiometricAvailable,
      if (callsAudience != null) #callsAudience: callsAudience,
      if (callsLoadError != null) #callsLoadError: callsLoadError,
      if (callsReadOnly != null) #callsReadOnly: callsReadOnly,
      if (callsAllow != null) #callsAllow: callsAllow,
      if (callsDeny != null) #callsDeny: callsDeny,
    }),
  );
  @override
  SettingsPrivacyAndSecurityState $make(CopyWithData data) =>
      SettingsPrivacyAndSecurityState(
        status: data.get(#status, or: $value.status),
        isBiometricAvailable: data.get(
          #isBiometricAvailable,
          or: $value.isBiometricAvailable,
        ),
        callsAudience: data.get(#callsAudience, or: $value.callsAudience),
        callsLoadError: data.get(#callsLoadError, or: $value.callsLoadError),
        callsReadOnly: data.get(#callsReadOnly, or: $value.callsReadOnly),
        callsAllow: data.get(#callsAllow, or: $value.callsAllow),
        callsDeny: data.get(#callsDeny, or: $value.callsDeny),
      );

  @override
  SettingsPrivacyAndSecurityStateCopyWith<
    $R2,
    SettingsPrivacyAndSecurityState,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsPrivacyAndSecurityStateCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

