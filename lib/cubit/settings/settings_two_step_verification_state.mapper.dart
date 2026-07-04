// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_two_step_verification_state.dart';

class SettingsTwoStepVerificationStateMapper
    extends ClassMapperBase<SettingsTwoStepVerificationState> {
  SettingsTwoStepVerificationStateMapper._();

  static SettingsTwoStepVerificationStateMapper? _instance;
  static SettingsTwoStepVerificationStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsTwoStepVerificationStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsTwoStepVerificationState';

  static bool _$nextButton(SettingsTwoStepVerificationState v) => v.nextButton;
  static const Field<SettingsTwoStepVerificationState, bool> _f$nextButton =
      Field('nextButton', _$nextButton, opt: true, def: false);

  @override
  final MappableFields<SettingsTwoStepVerificationState> fields = const {
    #nextButton: _f$nextButton,
  };

  static SettingsTwoStepVerificationState _instantiate(DecodingData data) {
    return SettingsTwoStepVerificationState(
      nextButton: data.dec(_f$nextButton),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsTwoStepVerificationState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsTwoStepVerificationState>(map);
  }

  static SettingsTwoStepVerificationState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsTwoStepVerificationState>(
      json,
    );
  }
}

mixin SettingsTwoStepVerificationStateMappable {
  String toJson() {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized()
        .encodeJson<SettingsTwoStepVerificationState>(
          this as SettingsTwoStepVerificationState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized()
        .encodeMap<SettingsTwoStepVerificationState>(
          this as SettingsTwoStepVerificationState,
        );
  }

  SettingsTwoStepVerificationStateCopyWith<
    SettingsTwoStepVerificationState,
    SettingsTwoStepVerificationState,
    SettingsTwoStepVerificationState
  >
  get copyWith =>
      _SettingsTwoStepVerificationStateCopyWithImpl<
        SettingsTwoStepVerificationState,
        SettingsTwoStepVerificationState
      >(this as SettingsTwoStepVerificationState, $identity, $identity);
  @override
  String toString() {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized()
        .stringifyValue(this as SettingsTwoStepVerificationState);
  }

  @override
  bool operator ==(Object other) {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized()
        .equalsValue(this as SettingsTwoStepVerificationState, other);
  }

  @override
  int get hashCode {
    return SettingsTwoStepVerificationStateMapper.ensureInitialized().hashValue(
      this as SettingsTwoStepVerificationState,
    );
  }
}

extension SettingsTwoStepVerificationStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsTwoStepVerificationState, $Out> {
  SettingsTwoStepVerificationStateCopyWith<
    $R,
    SettingsTwoStepVerificationState,
    $Out
  >
  get $asSettingsTwoStepVerificationState => $base.as(
    (v, t, t2) =>
        _SettingsTwoStepVerificationStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsTwoStepVerificationStateCopyWith<
  $R,
  $In extends SettingsTwoStepVerificationState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? nextButton});
  SettingsTwoStepVerificationStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsTwoStepVerificationStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsTwoStepVerificationState, $Out>
    implements
        SettingsTwoStepVerificationStateCopyWith<
          $R,
          SettingsTwoStepVerificationState,
          $Out
        > {
  _SettingsTwoStepVerificationStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SettingsTwoStepVerificationState> $mapper =
      SettingsTwoStepVerificationStateMapper.ensureInitialized();
  @override
  $R call({bool? nextButton}) => $apply(
    FieldCopyWithData({if (nextButton != null) #nextButton: nextButton}),
  );
  @override
  SettingsTwoStepVerificationState $make(CopyWithData data) =>
      SettingsTwoStepVerificationState(
        nextButton: data.get(#nextButton, or: $value.nextButton),
      );

  @override
  SettingsTwoStepVerificationStateCopyWith<
    $R2,
    SettingsTwoStepVerificationState,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsTwoStepVerificationStateCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

