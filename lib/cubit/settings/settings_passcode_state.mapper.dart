// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_passcode_state.dart';

class SettingsPasscodeStateMapper
    extends ClassMapperBase<SettingsPasscodeState> {
  SettingsPasscodeStateMapper._();

  static SettingsPasscodeStateMapper? _instance;
  static SettingsPasscodeStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsPasscodeStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsPasscodeState';

  static Status _$status(SettingsPasscodeState v) => v.status;
  static const Field<SettingsPasscodeState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static List<int> _$passcode(SettingsPasscodeState v) => v.passcode;
  static const Field<SettingsPasscodeState, List<int>> _f$passcode = Field(
    'passcode',
    _$passcode,
    opt: true,
    def: const [],
  );
  static bool _$unlocked(SettingsPasscodeState v) => v.unlocked;
  static const Field<SettingsPasscodeState, bool> _f$unlocked = Field(
    'unlocked',
    _$unlocked,
    opt: true,
    def: false,
  );
  static int _$autoLockSeconds(SettingsPasscodeState v) => v.autoLockSeconds;
  static const Field<SettingsPasscodeState, int> _f$autoLockSeconds = Field(
    'autoLockSeconds',
    _$autoLockSeconds,
    opt: true,
    def: 0,
  );
  static bool _$isBiometric(SettingsPasscodeState v) => v.isBiometric;
  static const Field<SettingsPasscodeState, bool> _f$isBiometric = Field(
    'isBiometric',
    _$isBiometric,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<SettingsPasscodeState> fields = const {
    #status: _f$status,
    #passcode: _f$passcode,
    #unlocked: _f$unlocked,
    #autoLockSeconds: _f$autoLockSeconds,
    #isBiometric: _f$isBiometric,
  };

  static SettingsPasscodeState _instantiate(DecodingData data) {
    return SettingsPasscodeState(
      status: data.dec(_f$status),
      passcode: data.dec(_f$passcode),
      unlocked: data.dec(_f$unlocked),
      autoLockSeconds: data.dec(_f$autoLockSeconds),
      isBiometric: data.dec(_f$isBiometric),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsPasscodeState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsPasscodeState>(map);
  }

  static SettingsPasscodeState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsPasscodeState>(json);
  }
}

mixin SettingsPasscodeStateMappable {
  String toJson() {
    return SettingsPasscodeStateMapper.ensureInitialized()
        .encodeJson<SettingsPasscodeState>(this as SettingsPasscodeState);
  }

  Map<String, dynamic> toMap() {
    return SettingsPasscodeStateMapper.ensureInitialized()
        .encodeMap<SettingsPasscodeState>(this as SettingsPasscodeState);
  }

  SettingsPasscodeStateCopyWith<
    SettingsPasscodeState,
    SettingsPasscodeState,
    SettingsPasscodeState
  >
  get copyWith =>
      _SettingsPasscodeStateCopyWithImpl<
        SettingsPasscodeState,
        SettingsPasscodeState
      >(this as SettingsPasscodeState, $identity, $identity);
  @override
  String toString() {
    return SettingsPasscodeStateMapper.ensureInitialized().stringifyValue(
      this as SettingsPasscodeState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsPasscodeStateMapper.ensureInitialized().equalsValue(
      this as SettingsPasscodeState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsPasscodeStateMapper.ensureInitialized().hashValue(
      this as SettingsPasscodeState,
    );
  }
}

extension SettingsPasscodeStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsPasscodeState, $Out> {
  SettingsPasscodeStateCopyWith<$R, SettingsPasscodeState, $Out>
  get $asSettingsPasscodeState => $base.as(
    (v, t, t2) => _SettingsPasscodeStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsPasscodeStateCopyWith<
  $R,
  $In extends SettingsPasscodeState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get passcode;
  $R call({
    Status? status,
    List<int>? passcode,
    bool? unlocked,
    int? autoLockSeconds,
    bool? isBiometric,
  });
  SettingsPasscodeStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsPasscodeStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsPasscodeState, $Out>
    implements SettingsPasscodeStateCopyWith<$R, SettingsPasscodeState, $Out> {
  _SettingsPasscodeStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsPasscodeState> $mapper =
      SettingsPasscodeStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get passcode =>
      ListCopyWith(
        $value.passcode,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(passcode: v),
      );
  @override
  $R call({
    Status? status,
    List<int>? passcode,
    bool? unlocked,
    int? autoLockSeconds,
    bool? isBiometric,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (passcode != null) #passcode: passcode,
      if (unlocked != null) #unlocked: unlocked,
      if (autoLockSeconds != null) #autoLockSeconds: autoLockSeconds,
      if (isBiometric != null) #isBiometric: isBiometric,
    }),
  );
  @override
  SettingsPasscodeState $make(CopyWithData data) => SettingsPasscodeState(
    status: data.get(#status, or: $value.status),
    passcode: data.get(#passcode, or: $value.passcode),
    unlocked: data.get(#unlocked, or: $value.unlocked),
    autoLockSeconds: data.get(#autoLockSeconds, or: $value.autoLockSeconds),
    isBiometric: data.get(#isBiometric, or: $value.isBiometric),
  );

  @override
  SettingsPasscodeStateCopyWith<$R2, SettingsPasscodeState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsPasscodeStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

