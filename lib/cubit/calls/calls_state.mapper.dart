// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'calls_state.dart';

class CallsFilterMapper extends EnumMapper<CallsFilter> {
  CallsFilterMapper._();

  static CallsFilterMapper? _instance;
  static CallsFilterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CallsFilterMapper._());
    }
    return _instance!;
  }

  static CallsFilter fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CallsFilter decode(dynamic value) {
    switch (value) {
      case r'all':
        return CallsFilter.all;
      case r'missed':
        return CallsFilter.missed;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CallsFilter self) {
    switch (self) {
      case CallsFilter.all:
        return r'all';
      case CallsFilter.missed:
        return r'missed';
    }
  }
}

extension CallsFilterMapperExtension on CallsFilter {
  String toValue() {
    CallsFilterMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CallsFilter>(this) as String;
  }
}

class CallsStateMapper extends ClassMapperBase<CallsState> {
  CallsStateMapper._();

  static CallsStateMapper? _instance;
  static CallsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CallsStateMapper._());
      models.CallLogMapper.ensureInitialized();
      CallsFilterMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CallsState';

  static Status _$status(CallsState v) => v.status;
  static const Field<CallsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static List<models.CallLog> _$calls(CallsState v) => v.calls;
  static const Field<CallsState, List<models.CallLog>> _f$calls = Field(
    'calls',
    _$calls,
    opt: true,
    def: const [],
  );
  static String _$query(CallsState v) => v.query;
  static const Field<CallsState, String> _f$query = Field(
    'query',
    _$query,
    opt: true,
    def: "",
  );
  static CallsFilter _$filter(CallsState v) => v.filter;
  static const Field<CallsState, CallsFilter> _f$filter = Field(
    'filter',
    _$filter,
    opt: true,
    def: CallsFilter.all,
  );
  static Map<String, String> _$names(CallsState v) => v.names;
  static const Field<CallsState, Map<String, String>> _f$names = Field(
    'names',
    _$names,
    opt: true,
    def: const {},
  );
  static Map<String, String> _$hiddenHashByHex(CallsState v) =>
      v.hiddenHashByHex;
  static const Field<CallsState, Map<String, String>> _f$hiddenHashByHex =
      Field('hiddenHashByHex', _$hiddenHashByHex, opt: true, def: const {});
  static Set<String> _$revealedHex(CallsState v) => v.revealedHex;
  static const Field<CallsState, Set<String>> _f$revealedHex = Field(
    'revealedHex',
    _$revealedHex,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<CallsState> fields = const {
    #status: _f$status,
    #calls: _f$calls,
    #query: _f$query,
    #filter: _f$filter,
    #names: _f$names,
    #hiddenHashByHex: _f$hiddenHashByHex,
    #revealedHex: _f$revealedHex,
  };

  static CallsState _instantiate(DecodingData data) {
    return CallsState(
      status: data.dec(_f$status),
      calls: data.dec(_f$calls),
      query: data.dec(_f$query),
      filter: data.dec(_f$filter),
      names: data.dec(_f$names),
      hiddenHashByHex: data.dec(_f$hiddenHashByHex),
      revealedHex: data.dec(_f$revealedHex),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CallsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CallsState>(map);
  }

  static CallsState fromJson(String json) {
    return ensureInitialized().decodeJson<CallsState>(json);
  }
}

mixin CallsStateMappable {
  String toJson() {
    return CallsStateMapper.ensureInitialized().encodeJson<CallsState>(
      this as CallsState,
    );
  }

  Map<String, dynamic> toMap() {
    return CallsStateMapper.ensureInitialized().encodeMap<CallsState>(
      this as CallsState,
    );
  }

  CallsStateCopyWith<CallsState, CallsState, CallsState> get copyWith =>
      _CallsStateCopyWithImpl<CallsState, CallsState>(
        this as CallsState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CallsStateMapper.ensureInitialized().stringifyValue(
      this as CallsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return CallsStateMapper.ensureInitialized().equalsValue(
      this as CallsState,
      other,
    );
  }

  @override
  int get hashCode {
    return CallsStateMapper.ensureInitialized().hashValue(this as CallsState);
  }
}

extension CallsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CallsState, $Out> {
  CallsStateCopyWith<$R, CallsState, $Out> get $asCallsState =>
      $base.as((v, t, t2) => _CallsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CallsStateCopyWith<$R, $In extends CallsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    models.CallLog,
    models.CallLogCopyWith<$R, models.CallLog, models.CallLog>
  >
  get calls;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>> get names;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get hiddenHashByHex;
  $R call({
    Status? status,
    List<models.CallLog>? calls,
    String? query,
    CallsFilter? filter,
    Map<String, String>? names,
    Map<String, String>? hiddenHashByHex,
    Set<String>? revealedHex,
  });
  CallsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CallsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CallsState, $Out>
    implements CallsStateCopyWith<$R, CallsState, $Out> {
  _CallsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CallsState> $mapper =
      CallsStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    models.CallLog,
    models.CallLogCopyWith<$R, models.CallLog, models.CallLog>
  >
  get calls => ListCopyWith(
    $value.calls,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(calls: v),
  );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get names => MapCopyWith(
    $value.names,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(names: v),
  );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get hiddenHashByHex => MapCopyWith(
    $value.hiddenHashByHex,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(hiddenHashByHex: v),
  );
  @override
  $R call({
    Status? status,
    List<models.CallLog>? calls,
    String? query,
    CallsFilter? filter,
    Map<String, String>? names,
    Map<String, String>? hiddenHashByHex,
    Set<String>? revealedHex,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (calls != null) #calls: calls,
      if (query != null) #query: query,
      if (filter != null) #filter: filter,
      if (names != null) #names: names,
      if (hiddenHashByHex != null) #hiddenHashByHex: hiddenHashByHex,
      if (revealedHex != null) #revealedHex: revealedHex,
    }),
  );
  @override
  CallsState $make(CopyWithData data) => CallsState(
    status: data.get(#status, or: $value.status),
    calls: data.get(#calls, or: $value.calls),
    query: data.get(#query, or: $value.query),
    filter: data.get(#filter, or: $value.filter),
    names: data.get(#names, or: $value.names),
    hiddenHashByHex: data.get(#hiddenHashByHex, or: $value.hiddenHashByHex),
    revealedHex: data.get(#revealedHex, or: $value.revealedHex),
  );

  @override
  CallsStateCopyWith<$R2, CallsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CallsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

