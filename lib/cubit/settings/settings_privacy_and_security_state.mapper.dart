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

  @override
  final MappableFields<SettingsPrivacyAndSecurityState> fields = const {
    #status: _f$status,
  };

  static SettingsPrivacyAndSecurityState _instantiate(DecodingData data) {
    return SettingsPrivacyAndSecurityState(status: data.dec(_f$status));
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
  $R call({Status? status});
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
  $R call({Status? status}) =>
      $apply(FieldCopyWithData({if (status != null) #status: status}));
  @override
  SettingsPrivacyAndSecurityState $make(CopyWithData data) =>
      SettingsPrivacyAndSecurityState(
        status: data.get(#status, or: $value.status),
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

