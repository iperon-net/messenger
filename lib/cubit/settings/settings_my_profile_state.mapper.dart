// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_my_profile_state.dart';

class SettingsMyProfileStateMapper
    extends ClassMapperBase<SettingsMyProfileState> {
  SettingsMyProfileStateMapper._();

  static SettingsMyProfileStateMapper? _instance;
  static SettingsMyProfileStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsMyProfileStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsMyProfileState';

  static Status _$status(SettingsMyProfileState v) => v.status;
  static const Field<SettingsMyProfileState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$boringAvatarHash(SettingsMyProfileState v) =>
      v.boringAvatarHash;
  static const Field<SettingsMyProfileState, String> _f$boringAvatarHash =
      Field('boringAvatarHash', _$boringAvatarHash, opt: true, def: "");
  static BoringAvatarType _$boringAvatarType(SettingsMyProfileState v) =>
      v.boringAvatarType;
  static const Field<SettingsMyProfileState, BoringAvatarType>
  _f$boringAvatarType = Field(
    'boringAvatarType',
    _$boringAvatarType,
    opt: true,
    def: BoringAvatarType.ring,
  );
  static DateTime? _$birthDate(SettingsMyProfileState v) => v.birthDate;
  static const Field<SettingsMyProfileState, DateTime> _f$birthDate = Field(
    'birthDate',
    _$birthDate,
    opt: true,
  );
  static int _$aboutMeLength(SettingsMyProfileState v) => v.aboutMeLength;
  static const Field<SettingsMyProfileState, int> _f$aboutMeLength = Field(
    'aboutMeLength',
    _$aboutMeLength,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<SettingsMyProfileState> fields = const {
    #status: _f$status,
    #boringAvatarHash: _f$boringAvatarHash,
    #boringAvatarType: _f$boringAvatarType,
    #birthDate: _f$birthDate,
    #aboutMeLength: _f$aboutMeLength,
  };

  static SettingsMyProfileState _instantiate(DecodingData data) {
    return SettingsMyProfileState(
      status: data.dec(_f$status),
      boringAvatarHash: data.dec(_f$boringAvatarHash),
      boringAvatarType: data.dec(_f$boringAvatarType),
      birthDate: data.dec(_f$birthDate),
      aboutMeLength: data.dec(_f$aboutMeLength),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsMyProfileState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsMyProfileState>(map);
  }

  static SettingsMyProfileState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsMyProfileState>(json);
  }
}

mixin SettingsMyProfileStateMappable {
  String toJson() {
    return SettingsMyProfileStateMapper.ensureInitialized()
        .encodeJson<SettingsMyProfileState>(this as SettingsMyProfileState);
  }

  Map<String, dynamic> toMap() {
    return SettingsMyProfileStateMapper.ensureInitialized()
        .encodeMap<SettingsMyProfileState>(this as SettingsMyProfileState);
  }

  SettingsMyProfileStateCopyWith<
    SettingsMyProfileState,
    SettingsMyProfileState,
    SettingsMyProfileState
  >
  get copyWith =>
      _SettingsMyProfileStateCopyWithImpl<
        SettingsMyProfileState,
        SettingsMyProfileState
      >(this as SettingsMyProfileState, $identity, $identity);
  @override
  String toString() {
    return SettingsMyProfileStateMapper.ensureInitialized().stringifyValue(
      this as SettingsMyProfileState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsMyProfileStateMapper.ensureInitialized().equalsValue(
      this as SettingsMyProfileState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsMyProfileStateMapper.ensureInitialized().hashValue(
      this as SettingsMyProfileState,
    );
  }
}

extension SettingsMyProfileStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsMyProfileState, $Out> {
  SettingsMyProfileStateCopyWith<$R, SettingsMyProfileState, $Out>
  get $asSettingsMyProfileState => $base.as(
    (v, t, t2) => _SettingsMyProfileStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsMyProfileStateCopyWith<
  $R,
  $In extends SettingsMyProfileState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Status? status,
    String? boringAvatarHash,
    BoringAvatarType? boringAvatarType,
    DateTime? birthDate,
    int? aboutMeLength,
  });
  SettingsMyProfileStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsMyProfileStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsMyProfileState, $Out>
    implements
        SettingsMyProfileStateCopyWith<$R, SettingsMyProfileState, $Out> {
  _SettingsMyProfileStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsMyProfileState> $mapper =
      SettingsMyProfileStateMapper.ensureInitialized();
  @override
  $R call({
    Status? status,
    String? boringAvatarHash,
    BoringAvatarType? boringAvatarType,
    Object? birthDate = $none,
    int? aboutMeLength,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (boringAvatarHash != null) #boringAvatarHash: boringAvatarHash,
      if (boringAvatarType != null) #boringAvatarType: boringAvatarType,
      if (birthDate != $none) #birthDate: birthDate,
      if (aboutMeLength != null) #aboutMeLength: aboutMeLength,
    }),
  );
  @override
  SettingsMyProfileState $make(CopyWithData data) => SettingsMyProfileState(
    status: data.get(#status, or: $value.status),
    boringAvatarHash: data.get(#boringAvatarHash, or: $value.boringAvatarHash),
    boringAvatarType: data.get(#boringAvatarType, or: $value.boringAvatarType),
    birthDate: data.get(#birthDate, or: $value.birthDate),
    aboutMeLength: data.get(#aboutMeLength, or: $value.aboutMeLength),
  );

  @override
  SettingsMyProfileStateCopyWith<$R2, SettingsMyProfileState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsMyProfileStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

