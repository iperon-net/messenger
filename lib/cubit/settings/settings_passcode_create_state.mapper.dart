// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_passcode_create_state.dart';

class SettingsPasscodeCreateStateMapper
    extends ClassMapperBase<SettingsPasscodeCreateState> {
  SettingsPasscodeCreateStateMapper._();

  static SettingsPasscodeCreateStateMapper? _instance;
  static SettingsPasscodeCreateStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsPasscodeCreateStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsPasscodeCreateState';

  static Status _$status(SettingsPasscodeCreateState v) => v.status;
  static const Field<SettingsPasscodeCreateState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static List<int> _$passcode(SettingsPasscodeCreateState v) => v.passcode;
  static const Field<SettingsPasscodeCreateState, List<int>> _f$passcode =
      Field('passcode', _$passcode, opt: true, def: const []);

  @override
  final MappableFields<SettingsPasscodeCreateState> fields = const {
    #status: _f$status,
    #passcode: _f$passcode,
  };

  static SettingsPasscodeCreateState _instantiate(DecodingData data) {
    return SettingsPasscodeCreateState(
      status: data.dec(_f$status),
      passcode: data.dec(_f$passcode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsPasscodeCreateState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsPasscodeCreateState>(map);
  }

  static SettingsPasscodeCreateState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsPasscodeCreateState>(json);
  }
}

mixin SettingsPasscodeCreateStateMappable {
  String toJson() {
    return SettingsPasscodeCreateStateMapper.ensureInitialized()
        .encodeJson<SettingsPasscodeCreateState>(
          this as SettingsPasscodeCreateState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsPasscodeCreateStateMapper.ensureInitialized()
        .encodeMap<SettingsPasscodeCreateState>(
          this as SettingsPasscodeCreateState,
        );
  }

  SettingsPasscodeCreateStateCopyWith<
    SettingsPasscodeCreateState,
    SettingsPasscodeCreateState,
    SettingsPasscodeCreateState
  >
  get copyWith =>
      _SettingsPasscodeCreateStateCopyWithImpl<
        SettingsPasscodeCreateState,
        SettingsPasscodeCreateState
      >(this as SettingsPasscodeCreateState, $identity, $identity);
  @override
  String toString() {
    return SettingsPasscodeCreateStateMapper.ensureInitialized().stringifyValue(
      this as SettingsPasscodeCreateState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsPasscodeCreateStateMapper.ensureInitialized().equalsValue(
      this as SettingsPasscodeCreateState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsPasscodeCreateStateMapper.ensureInitialized().hashValue(
      this as SettingsPasscodeCreateState,
    );
  }
}

extension SettingsPasscodeCreateStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsPasscodeCreateState, $Out> {
  SettingsPasscodeCreateStateCopyWith<$R, SettingsPasscodeCreateState, $Out>
  get $asSettingsPasscodeCreateState => $base.as(
    (v, t, t2) => _SettingsPasscodeCreateStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsPasscodeCreateStateCopyWith<
  $R,
  $In extends SettingsPasscodeCreateState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get passcode;
  $R call({Status? status, List<int>? passcode});
  SettingsPasscodeCreateStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsPasscodeCreateStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsPasscodeCreateState, $Out>
    implements
        SettingsPasscodeCreateStateCopyWith<
          $R,
          SettingsPasscodeCreateState,
          $Out
        > {
  _SettingsPasscodeCreateStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SettingsPasscodeCreateState> $mapper =
      SettingsPasscodeCreateStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get passcode =>
      ListCopyWith(
        $value.passcode,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(passcode: v),
      );
  @override
  $R call({Status? status, List<int>? passcode}) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (passcode != null) #passcode: passcode,
    }),
  );
  @override
  SettingsPasscodeCreateState $make(CopyWithData data) =>
      SettingsPasscodeCreateState(
        status: data.get(#status, or: $value.status),
        passcode: data.get(#passcode, or: $value.passcode),
      );

  @override
  SettingsPasscodeCreateStateCopyWith<$R2, SettingsPasscodeCreateState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsPasscodeCreateStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

