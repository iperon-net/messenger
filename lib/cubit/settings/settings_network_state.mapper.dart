// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_network_state.dart';

class SettingsNetworkStateMapper extends ClassMapperBase<SettingsNetworkState> {
  SettingsNetworkStateMapper._();

  static SettingsNetworkStateMapper? _instance;
  static SettingsNetworkStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsNetworkStateMapper._());
      NetworkKindMapper.ensureInitialized();
      TrafficCategoryMapper.ensureInitialized();
      TrafficCounterMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsNetworkState';

  static Status _$status(SettingsNetworkState v) => v.status;
  static const Field<SettingsNetworkState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static NetworkKind _$network(SettingsNetworkState v) => v.network;
  static const Field<SettingsNetworkState, NetworkKind> _f$network = Field(
    'network',
    _$network,
    opt: true,
    def: NetworkKind.mobile,
  );
  static Map<TrafficCategory, TrafficCounter> _$mobile(
    SettingsNetworkState v,
  ) => v.mobile;
  static const Field<SettingsNetworkState, Map<TrafficCategory, TrafficCounter>>
  _f$mobile = Field('mobile', _$mobile, opt: true, def: const {});
  static Map<TrafficCategory, TrafficCounter> _$wifi(SettingsNetworkState v) =>
      v.wifi;
  static const Field<SettingsNetworkState, Map<TrafficCategory, TrafficCounter>>
  _f$wifi = Field('wifi', _$wifi, opt: true, def: const {});
  static DateTime? _$since(SettingsNetworkState v) => v.since;
  static const Field<SettingsNetworkState, DateTime> _f$since = Field(
    'since',
    _$since,
    opt: true,
  );

  @override
  final MappableFields<SettingsNetworkState> fields = const {
    #status: _f$status,
    #network: _f$network,
    #mobile: _f$mobile,
    #wifi: _f$wifi,
    #since: _f$since,
  };

  static SettingsNetworkState _instantiate(DecodingData data) {
    return SettingsNetworkState(
      status: data.dec(_f$status),
      network: data.dec(_f$network),
      mobile: data.dec(_f$mobile),
      wifi: data.dec(_f$wifi),
      since: data.dec(_f$since),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsNetworkState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsNetworkState>(map);
  }

  static SettingsNetworkState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsNetworkState>(json);
  }
}

mixin SettingsNetworkStateMappable {
  String toJson() {
    return SettingsNetworkStateMapper.ensureInitialized()
        .encodeJson<SettingsNetworkState>(this as SettingsNetworkState);
  }

  Map<String, dynamic> toMap() {
    return SettingsNetworkStateMapper.ensureInitialized()
        .encodeMap<SettingsNetworkState>(this as SettingsNetworkState);
  }

  SettingsNetworkStateCopyWith<
    SettingsNetworkState,
    SettingsNetworkState,
    SettingsNetworkState
  >
  get copyWith =>
      _SettingsNetworkStateCopyWithImpl<
        SettingsNetworkState,
        SettingsNetworkState
      >(this as SettingsNetworkState, $identity, $identity);
  @override
  String toString() {
    return SettingsNetworkStateMapper.ensureInitialized().stringifyValue(
      this as SettingsNetworkState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsNetworkStateMapper.ensureInitialized().equalsValue(
      this as SettingsNetworkState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsNetworkStateMapper.ensureInitialized().hashValue(
      this as SettingsNetworkState,
    );
  }
}

extension SettingsNetworkStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsNetworkState, $Out> {
  SettingsNetworkStateCopyWith<$R, SettingsNetworkState, $Out>
  get $asSettingsNetworkState => $base.as(
    (v, t, t2) => _SettingsNetworkStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsNetworkStateCopyWith<
  $R,
  $In extends SettingsNetworkState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    TrafficCategory,
    TrafficCounter,
    TrafficCounterCopyWith<$R, TrafficCounter, TrafficCounter>
  >
  get mobile;
  MapCopyWith<
    $R,
    TrafficCategory,
    TrafficCounter,
    TrafficCounterCopyWith<$R, TrafficCounter, TrafficCounter>
  >
  get wifi;
  $R call({
    Status? status,
    NetworkKind? network,
    Map<TrafficCategory, TrafficCounter>? mobile,
    Map<TrafficCategory, TrafficCounter>? wifi,
    DateTime? since,
  });
  SettingsNetworkStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsNetworkStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsNetworkState, $Out>
    implements SettingsNetworkStateCopyWith<$R, SettingsNetworkState, $Out> {
  _SettingsNetworkStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsNetworkState> $mapper =
      SettingsNetworkStateMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    TrafficCategory,
    TrafficCounter,
    TrafficCounterCopyWith<$R, TrafficCounter, TrafficCounter>
  >
  get mobile => MapCopyWith(
    $value.mobile,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(mobile: v),
  );
  @override
  MapCopyWith<
    $R,
    TrafficCategory,
    TrafficCounter,
    TrafficCounterCopyWith<$R, TrafficCounter, TrafficCounter>
  >
  get wifi => MapCopyWith(
    $value.wifi,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(wifi: v),
  );
  @override
  $R call({
    Status? status,
    NetworkKind? network,
    Map<TrafficCategory, TrafficCounter>? mobile,
    Map<TrafficCategory, TrafficCounter>? wifi,
    Object? since = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (network != null) #network: network,
      if (mobile != null) #mobile: mobile,
      if (wifi != null) #wifi: wifi,
      if (since != $none) #since: since,
    }),
  );
  @override
  SettingsNetworkState $make(CopyWithData data) => SettingsNetworkState(
    status: data.get(#status, or: $value.status),
    network: data.get(#network, or: $value.network),
    mobile: data.get(#mobile, or: $value.mobile),
    wifi: data.get(#wifi, or: $value.wifi),
    since: data.get(#since, or: $value.since),
  );

  @override
  SettingsNetworkStateCopyWith<$R2, SettingsNetworkState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsNetworkStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

