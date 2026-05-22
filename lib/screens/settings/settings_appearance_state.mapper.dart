// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_appearance_state.dart';

class SettingsAppearanceStateMapper
    extends ClassMapperBase<SettingsAppearanceState> {
  SettingsAppearanceStateMapper._();

  static SettingsAppearanceStateMapper? _instance;
  static SettingsAppearanceStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsAppearanceStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsAppearanceState';

  @override
  final MappableFields<SettingsAppearanceState> fields = const {};

  static SettingsAppearanceState _instantiate(DecodingData data) {
    return SettingsAppearanceState();
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsAppearanceState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsAppearanceState>(map);
  }

  static SettingsAppearanceState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsAppearanceState>(json);
  }
}

mixin SettingsAppearanceStateMappable {
  String toJson() {
    return SettingsAppearanceStateMapper.ensureInitialized()
        .encodeJson<SettingsAppearanceState>(this as SettingsAppearanceState);
  }

  Map<String, dynamic> toMap() {
    return SettingsAppearanceStateMapper.ensureInitialized()
        .encodeMap<SettingsAppearanceState>(this as SettingsAppearanceState);
  }

  SettingsAppearanceStateCopyWith<
    SettingsAppearanceState,
    SettingsAppearanceState,
    SettingsAppearanceState
  >
  get copyWith =>
      _SettingsAppearanceStateCopyWithImpl<
        SettingsAppearanceState,
        SettingsAppearanceState
      >(this as SettingsAppearanceState, $identity, $identity);
  @override
  String toString() {
    return SettingsAppearanceStateMapper.ensureInitialized().stringifyValue(
      this as SettingsAppearanceState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsAppearanceStateMapper.ensureInitialized().equalsValue(
      this as SettingsAppearanceState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsAppearanceStateMapper.ensureInitialized().hashValue(
      this as SettingsAppearanceState,
    );
  }
}

extension SettingsAppearanceStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsAppearanceState, $Out> {
  SettingsAppearanceStateCopyWith<$R, SettingsAppearanceState, $Out>
  get $asSettingsAppearanceState => $base.as(
    (v, t, t2) => _SettingsAppearanceStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsAppearanceStateCopyWith<
  $R,
  $In extends SettingsAppearanceState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  SettingsAppearanceStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsAppearanceStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsAppearanceState, $Out>
    implements
        SettingsAppearanceStateCopyWith<$R, SettingsAppearanceState, $Out> {
  _SettingsAppearanceStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsAppearanceState> $mapper =
      SettingsAppearanceStateMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  SettingsAppearanceState $make(CopyWithData data) => SettingsAppearanceState();

  @override
  SettingsAppearanceStateCopyWith<$R2, SettingsAppearanceState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsAppearanceStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

