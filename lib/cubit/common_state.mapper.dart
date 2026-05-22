// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'common_state.dart';

class CommonStateMapper extends ClassMapperBase<CommonState> {
  CommonStateMapper._();

  static CommonStateMapper? _instance;
  static CommonStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CommonStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CommonState';

  static Status _$status(CommonState v) => v.status;
  static const Field<CommonState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );

  @override
  final MappableFields<CommonState> fields = const {#status: _f$status};

  static CommonState _instantiate(DecodingData data) {
    return CommonState(status: data.dec(_f$status));
  }

  @override
  final Function instantiate = _instantiate;

  static CommonState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CommonState>(map);
  }

  static CommonState fromJson(String json) {
    return ensureInitialized().decodeJson<CommonState>(json);
  }
}

mixin CommonStateMappable {
  String toJson() {
    return CommonStateMapper.ensureInitialized().encodeJson<CommonState>(
      this as CommonState,
    );
  }

  Map<String, dynamic> toMap() {
    return CommonStateMapper.ensureInitialized().encodeMap<CommonState>(
      this as CommonState,
    );
  }

  CommonStateCopyWith<CommonState, CommonState, CommonState> get copyWith =>
      _CommonStateCopyWithImpl<CommonState, CommonState>(
        this as CommonState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CommonStateMapper.ensureInitialized().stringifyValue(
      this as CommonState,
    );
  }

  @override
  bool operator ==(Object other) {
    return CommonStateMapper.ensureInitialized().equalsValue(
      this as CommonState,
      other,
    );
  }

  @override
  int get hashCode {
    return CommonStateMapper.ensureInitialized().hashValue(this as CommonState);
  }
}

extension CommonStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CommonState, $Out> {
  CommonStateCopyWith<$R, CommonState, $Out> get $asCommonState =>
      $base.as((v, t, t2) => _CommonStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CommonStateCopyWith<$R, $In extends CommonState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status});
  CommonStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CommonStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CommonState, $Out>
    implements CommonStateCopyWith<$R, CommonState, $Out> {
  _CommonStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CommonState> $mapper =
      CommonStateMapper.ensureInitialized();
  @override
  $R call({Status? status}) =>
      $apply(FieldCopyWithData({if (status != null) #status: status}));
  @override
  CommonState $make(CopyWithData data) =>
      CommonState(status: data.get(#status, or: $value.status));

  @override
  CommonStateCopyWith<$R2, CommonState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CommonStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

