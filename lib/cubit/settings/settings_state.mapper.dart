// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_state.dart';

class SettingsStateMapper extends ClassMapperBase<SettingsState> {
  SettingsStateMapper._();

  static SettingsStateMapper? _instance;
  static SettingsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsState';

  static Status _$status(SettingsState v) => v.status;
  static const Field<SettingsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static int _$countDeviceSessions(SettingsState v) => v.countDeviceSessions;
  static const Field<SettingsState, int> _f$countDeviceSessions = Field(
    'countDeviceSessions',
    _$countDeviceSessions,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<SettingsState> fields = const {
    #status: _f$status,
    #countDeviceSessions: _f$countDeviceSessions,
  };

  static SettingsState _instantiate(DecodingData data) {
    return SettingsState(
      status: data.dec(_f$status),
      countDeviceSessions: data.dec(_f$countDeviceSessions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsState>(map);
  }

  static SettingsState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsState>(json);
  }
}

mixin SettingsStateMappable {
  String toJson() {
    return SettingsStateMapper.ensureInitialized().encodeJson<SettingsState>(
      this as SettingsState,
    );
  }

  Map<String, dynamic> toMap() {
    return SettingsStateMapper.ensureInitialized().encodeMap<SettingsState>(
      this as SettingsState,
    );
  }

  SettingsStateCopyWith<SettingsState, SettingsState, SettingsState>
  get copyWith => _SettingsStateCopyWithImpl<SettingsState, SettingsState>(
    this as SettingsState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SettingsStateMapper.ensureInitialized().stringifyValue(
      this as SettingsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsStateMapper.ensureInitialized().equalsValue(
      this as SettingsState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsStateMapper.ensureInitialized().hashValue(
      this as SettingsState,
    );
  }
}

extension SettingsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsState, $Out> {
  SettingsStateCopyWith<$R, SettingsState, $Out> get $asSettingsState =>
      $base.as((v, t, t2) => _SettingsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SettingsStateCopyWith<$R, $In extends SettingsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status, int? countDeviceSessions});
  SettingsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SettingsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsState, $Out>
    implements SettingsStateCopyWith<$R, SettingsState, $Out> {
  _SettingsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsState> $mapper =
      SettingsStateMapper.ensureInitialized();
  @override
  $R call({Status? status, int? countDeviceSessions}) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (countDeviceSessions != null)
        #countDeviceSessions: countDeviceSessions,
    }),
  );
  @override
  SettingsState $make(CopyWithData data) => SettingsState(
    status: data.get(#status, or: $value.status),
    countDeviceSessions: data.get(
      #countDeviceSessions,
      or: $value.countDeviceSessions,
    ),
  );

  @override
  SettingsStateCopyWith<$R2, SettingsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SettingsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

