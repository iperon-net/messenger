// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_private_and_security_state.dart';

class SettingsPrivateAndSecurityStateMapper
    extends ClassMapperBase<SettingsPrivateAndSecurityState> {
  SettingsPrivateAndSecurityStateMapper._();

  static SettingsPrivateAndSecurityStateMapper? _instance;
  static SettingsPrivateAndSecurityStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsPrivateAndSecurityStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsPrivateAndSecurityState';

  static Status _$status(SettingsPrivateAndSecurityState v) => v.status;
  static const Field<SettingsPrivateAndSecurityState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );

  @override
  final MappableFields<SettingsPrivateAndSecurityState> fields = const {
    #status: _f$status,
  };

  static SettingsPrivateAndSecurityState _instantiate(DecodingData data) {
    return SettingsPrivateAndSecurityState(status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsPrivateAndSecurityState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsPrivateAndSecurityState>(map);
  }

  static SettingsPrivateAndSecurityState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsPrivateAndSecurityState>(
      json,
    );
  }
}

mixin SettingsPrivateAndSecurityStateMappable {
  String toJson() {
    return SettingsPrivateAndSecurityStateMapper.ensureInitialized()
        .encodeJson<SettingsPrivateAndSecurityState>(
          this as SettingsPrivateAndSecurityState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsPrivateAndSecurityStateMapper.ensureInitialized()
        .encodeMap<SettingsPrivateAndSecurityState>(
          this as SettingsPrivateAndSecurityState,
        );
  }

  SettingsPrivateAndSecurityStateCopyWith<
    SettingsPrivateAndSecurityState,
    SettingsPrivateAndSecurityState,
    SettingsPrivateAndSecurityState
  >
  get copyWith =>
      _SettingsPrivateAndSecurityStateCopyWithImpl<
        SettingsPrivateAndSecurityState,
        SettingsPrivateAndSecurityState
      >(this as SettingsPrivateAndSecurityState, $identity, $identity);
  @override
  String toString() {
    return SettingsPrivateAndSecurityStateMapper.ensureInitialized()
        .stringifyValue(this as SettingsPrivateAndSecurityState);
  }

  @override
  bool operator ==(Object other) {
    return SettingsPrivateAndSecurityStateMapper.ensureInitialized()
        .equalsValue(this as SettingsPrivateAndSecurityState, other);
  }

  @override
  int get hashCode {
    return SettingsPrivateAndSecurityStateMapper.ensureInitialized().hashValue(
      this as SettingsPrivateAndSecurityState,
    );
  }
}

extension SettingsPrivateAndSecurityStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsPrivateAndSecurityState, $Out> {
  SettingsPrivateAndSecurityStateCopyWith<
    $R,
    SettingsPrivateAndSecurityState,
    $Out
  >
  get $asSettingsPrivateAndSecurityState => $base.as(
    (v, t, t2) =>
        _SettingsPrivateAndSecurityStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsPrivateAndSecurityStateCopyWith<
  $R,
  $In extends SettingsPrivateAndSecurityState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status});
  SettingsPrivateAndSecurityStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsPrivateAndSecurityStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsPrivateAndSecurityState, $Out>
    implements
        SettingsPrivateAndSecurityStateCopyWith<
          $R,
          SettingsPrivateAndSecurityState,
          $Out
        > {
  _SettingsPrivateAndSecurityStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SettingsPrivateAndSecurityState> $mapper =
      SettingsPrivateAndSecurityStateMapper.ensureInitialized();
  @override
  $R call({Status? status}) =>
      $apply(FieldCopyWithData({if (status != null) #status: status}));
  @override
  SettingsPrivateAndSecurityState $make(CopyWithData data) =>
      SettingsPrivateAndSecurityState(
        status: data.get(#status, or: $value.status),
      );

  @override
  SettingsPrivateAndSecurityStateCopyWith<
    $R2,
    SettingsPrivateAndSecurityState,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsPrivateAndSecurityStateCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

