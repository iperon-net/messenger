// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chats_state.dart';

class ChatsStateMapper extends ClassMapperBase<ChatsState> {
  ChatsStateMapper._();

  static ChatsStateMapper? _instance;
  static ChatsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatsStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatsState';

  static Status _$status(ChatsState v) => v.status;
  static const Field<ChatsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );

  @override
  final MappableFields<ChatsState> fields = const {#status: _f$status};

  static ChatsState _instantiate(DecodingData data) {
    return ChatsState(status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static ChatsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatsState>(map);
  }

  static ChatsState fromJson(String json) {
    return ensureInitialized().decodeJson<ChatsState>(json);
  }
}

mixin ChatsStateMappable {
  String toJson() {
    return ChatsStateMapper.ensureInitialized().encodeJson<ChatsState>(
      this as ChatsState,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatsStateMapper.ensureInitialized().encodeMap<ChatsState>(
      this as ChatsState,
    );
  }

  ChatsStateCopyWith<ChatsState, ChatsState, ChatsState> get copyWith =>
      _ChatsStateCopyWithImpl<ChatsState, ChatsState>(
        this as ChatsState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatsStateMapper.ensureInitialized().stringifyValue(
      this as ChatsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatsStateMapper.ensureInitialized().equalsValue(
      this as ChatsState,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatsStateMapper.ensureInitialized().hashValue(this as ChatsState);
  }
}

extension ChatsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatsState, $Out> {
  ChatsStateCopyWith<$R, ChatsState, $Out> get $asChatsState =>
      $base.as((v, t, t2) => _ChatsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatsStateCopyWith<$R, $In extends ChatsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status});
  ChatsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatsState, $Out>
    implements ChatsStateCopyWith<$R, ChatsState, $Out> {
  _ChatsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatsState> $mapper =
      ChatsStateMapper.ensureInitialized();
  @override
  $R call({Status? status}) =>
      $apply(FieldCopyWithData({if (status != null) #status: status}));
  @override
  ChatsState $make(CopyWithData data) =>
      ChatsState(status: data.get(#status, or: $value.status));

  @override
  ChatsStateCopyWith<$R2, ChatsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

