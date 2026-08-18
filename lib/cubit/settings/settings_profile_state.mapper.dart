// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_profile_state.dart';

class SettingsProfileStateMapper extends ClassMapperBase<SettingsProfileState> {
  SettingsProfileStateMapper._();

  static SettingsProfileStateMapper? _instance;
  static SettingsProfileStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsProfileStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsProfileState';

  static Status _$status(SettingsProfileState v) => v.status;
  static const Field<SettingsProfileState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );

  @override
  final MappableFields<SettingsProfileState> fields = const {
    #status: _f$status,
  };

  static SettingsProfileState _instantiate(DecodingData data) {
    return SettingsProfileState(status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsProfileState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsProfileState>(map);
  }

  static SettingsProfileState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsProfileState>(json);
  }
}

mixin SettingsProfileStateMappable {
  String toJson() {
    return SettingsProfileStateMapper.ensureInitialized()
        .encodeJson<SettingsProfileState>(this as SettingsProfileState);
  }

  Map<String, dynamic> toMap() {
    return SettingsProfileStateMapper.ensureInitialized()
        .encodeMap<SettingsProfileState>(this as SettingsProfileState);
  }

  SettingsProfileStateCopyWith<
    SettingsProfileState,
    SettingsProfileState,
    SettingsProfileState
  >
  get copyWith =>
      _SettingsProfileStateCopyWithImpl<
        SettingsProfileState,
        SettingsProfileState
      >(this as SettingsProfileState, $identity, $identity);
  @override
  String toString() {
    return SettingsProfileStateMapper.ensureInitialized().stringifyValue(
      this as SettingsProfileState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsProfileStateMapper.ensureInitialized().equalsValue(
      this as SettingsProfileState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsProfileStateMapper.ensureInitialized().hashValue(
      this as SettingsProfileState,
    );
  }
}

extension SettingsProfileStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsProfileState, $Out> {
  SettingsProfileStateCopyWith<$R, SettingsProfileState, $Out>
  get $asSettingsProfileState => $base.as(
    (v, t, t2) => _SettingsProfileStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsProfileStateCopyWith<
  $R,
  $In extends SettingsProfileState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status});
  SettingsProfileStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsProfileStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsProfileState, $Out>
    implements SettingsProfileStateCopyWith<$R, SettingsProfileState, $Out> {
  _SettingsProfileStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsProfileState> $mapper =
      SettingsProfileStateMapper.ensureInitialized();
  @override
  $R call({Status? status}) =>
      $apply(FieldCopyWithData({if (status != null) #status: status}));
  @override
  SettingsProfileState $make(CopyWithData data) =>
      SettingsProfileState(status: data.get(#status, or: $value.status));

  @override
  SettingsProfileStateCopyWith<$R2, SettingsProfileState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsProfileStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

