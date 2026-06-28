// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_device_sessions_state.dart';

class SettingsDeviceSessionsStateMapper
    extends ClassMapperBase<SettingsDeviceSessionsState> {
  SettingsDeviceSessionsStateMapper._();

  static SettingsDeviceSessionsStateMapper? _instance;
  static SettingsDeviceSessionsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsDeviceSessionsStateMapper._(),
      );
      models.DeviceSessionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsDeviceSessionsState';

  static List<models.DeviceSession> _$deviceSessions(
    SettingsDeviceSessionsState v,
  ) => v.deviceSessions;
  static const Field<SettingsDeviceSessionsState, List<models.DeviceSession>>
  _f$deviceSessions = Field(
    'deviceSessions',
    _$deviceSessions,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<SettingsDeviceSessionsState> fields = const {
    #deviceSessions: _f$deviceSessions,
  };

  static SettingsDeviceSessionsState _instantiate(DecodingData data) {
    return SettingsDeviceSessionsState(
      deviceSessions: data.dec(_f$deviceSessions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsDeviceSessionsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsDeviceSessionsState>(map);
  }

  static SettingsDeviceSessionsState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsDeviceSessionsState>(json);
  }
}

mixin SettingsDeviceSessionsStateMappable {
  String toJson() {
    return SettingsDeviceSessionsStateMapper.ensureInitialized()
        .encodeJson<SettingsDeviceSessionsState>(
          this as SettingsDeviceSessionsState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsDeviceSessionsStateMapper.ensureInitialized()
        .encodeMap<SettingsDeviceSessionsState>(
          this as SettingsDeviceSessionsState,
        );
  }

  SettingsDeviceSessionsStateCopyWith<
    SettingsDeviceSessionsState,
    SettingsDeviceSessionsState,
    SettingsDeviceSessionsState
  >
  get copyWith =>
      _SettingsDeviceSessionsStateCopyWithImpl<
        SettingsDeviceSessionsState,
        SettingsDeviceSessionsState
      >(this as SettingsDeviceSessionsState, $identity, $identity);
  @override
  String toString() {
    return SettingsDeviceSessionsStateMapper.ensureInitialized().stringifyValue(
      this as SettingsDeviceSessionsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsDeviceSessionsStateMapper.ensureInitialized().equalsValue(
      this as SettingsDeviceSessionsState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsDeviceSessionsStateMapper.ensureInitialized().hashValue(
      this as SettingsDeviceSessionsState,
    );
  }
}

extension SettingsDeviceSessionsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsDeviceSessionsState, $Out> {
  SettingsDeviceSessionsStateCopyWith<$R, SettingsDeviceSessionsState, $Out>
  get $asSettingsDeviceSessionsState => $base.as(
    (v, t, t2) => _SettingsDeviceSessionsStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsDeviceSessionsStateCopyWith<
  $R,
  $In extends SettingsDeviceSessionsState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    models.DeviceSession,
    models.DeviceSessionCopyWith<$R, models.DeviceSession, models.DeviceSession>
  >
  get deviceSessions;
  $R call({List<models.DeviceSession>? deviceSessions});
  SettingsDeviceSessionsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsDeviceSessionsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsDeviceSessionsState, $Out>
    implements
        SettingsDeviceSessionsStateCopyWith<
          $R,
          SettingsDeviceSessionsState,
          $Out
        > {
  _SettingsDeviceSessionsStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SettingsDeviceSessionsState> $mapper =
      SettingsDeviceSessionsStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    models.DeviceSession,
    models.DeviceSessionCopyWith<$R, models.DeviceSession, models.DeviceSession>
  >
  get deviceSessions => ListCopyWith(
    $value.deviceSessions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(deviceSessions: v),
  );
  @override
  $R call({List<models.DeviceSession>? deviceSessions}) => $apply(
    FieldCopyWithData({
      if (deviceSessions != null) #deviceSessions: deviceSessions,
    }),
  );
  @override
  SettingsDeviceSessionsState $make(CopyWithData data) =>
      SettingsDeviceSessionsState(
        deviceSessions: data.get(#deviceSessions, or: $value.deviceSessions),
      );

  @override
  SettingsDeviceSessionsStateCopyWith<$R2, SettingsDeviceSessionsState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsDeviceSessionsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

