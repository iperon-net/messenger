// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'connection_state.dart';

class ConnectionStateMapper extends ClassMapperBase<ConnectionState> {
  ConnectionStateMapper._();

  static ConnectionStateMapper? _instance;
  static ConnectionStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ConnectionStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ConnectionState';

  static Status _$status(ConnectionState v) => v.status;
  static const Field<ConnectionState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static ConnectionStatusModel _$connection(ConnectionState v) => v.connection;
  static const Field<ConnectionState, ConnectionStatusModel> _f$connection =
      Field(
        'connection',
        _$connection,
        opt: true,
        def: ConnectionStatusModel.connecting,
      );

  @override
  final MappableFields<ConnectionState> fields = const {
    #status: _f$status,
    #connection: _f$connection,
  };

  static ConnectionState _instantiate(DecodingData data) {
    return ConnectionState(
      status: data.dec(_f$status),
      connection: data.dec(_f$connection),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ConnectionState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ConnectionState>(map);
  }

  static ConnectionState fromJson(String json) {
    return ensureInitialized().decodeJson<ConnectionState>(json);
  }
}

mixin ConnectionStateMappable {
  String toJson() {
    return ConnectionStateMapper.ensureInitialized()
        .encodeJson<ConnectionState>(this as ConnectionState);
  }

  Map<String, dynamic> toMap() {
    return ConnectionStateMapper.ensureInitialized().encodeMap<ConnectionState>(
      this as ConnectionState,
    );
  }

  ConnectionStateCopyWith<ConnectionState, ConnectionState, ConnectionState>
  get copyWith =>
      _ConnectionStateCopyWithImpl<ConnectionState, ConnectionState>(
        this as ConnectionState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ConnectionStateMapper.ensureInitialized().stringifyValue(
      this as ConnectionState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ConnectionStateMapper.ensureInitialized().equalsValue(
      this as ConnectionState,
      other,
    );
  }

  @override
  int get hashCode {
    return ConnectionStateMapper.ensureInitialized().hashValue(
      this as ConnectionState,
    );
  }
}

extension ConnectionStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ConnectionState, $Out> {
  ConnectionStateCopyWith<$R, ConnectionState, $Out> get $asConnectionState =>
      $base.as((v, t, t2) => _ConnectionStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ConnectionStateCopyWith<$R, $In extends ConnectionState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status, ConnectionStatusModel? connection});
  ConnectionStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ConnectionStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ConnectionState, $Out>
    implements ConnectionStateCopyWith<$R, ConnectionState, $Out> {
  _ConnectionStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ConnectionState> $mapper =
      ConnectionStateMapper.ensureInitialized();
  @override
  $R call({Status? status, ConnectionStatusModel? connection}) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (connection != null) #connection: connection,
    }),
  );
  @override
  ConnectionState $make(CopyWithData data) => ConnectionState(
    status: data.get(#status, or: $value.status),
    connection: data.get(#connection, or: $value.connection),
  );

  @override
  ConnectionStateCopyWith<$R2, ConnectionState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ConnectionStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

