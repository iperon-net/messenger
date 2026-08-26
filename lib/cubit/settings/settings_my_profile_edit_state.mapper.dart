// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_my_profile_edit_state.dart';

class SettingsMyProfileEditStateMapper
    extends ClassMapperBase<SettingsMyProfileEditState> {
  SettingsMyProfileEditStateMapper._();

  static SettingsMyProfileEditStateMapper? _instance;
  static SettingsMyProfileEditStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsMyProfileEditStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsMyProfileEditState';

  static Status _$status(SettingsMyProfileEditState v) => v.status;
  static const Field<SettingsMyProfileEditState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static Status _$networkStatus(SettingsMyProfileEditState v) =>
      v.networkStatus;
  static const Field<SettingsMyProfileEditState, Status> _f$networkStatus =
      Field(
        'networkStatus',
        _$networkStatus,
        opt: true,
        def: Status.initialization,
      );
  static String _$error(SettingsMyProfileEditState v) => v.error;
  static const Field<SettingsMyProfileEditState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static String _$redirectURI(SettingsMyProfileEditState v) => v.redirectURI;
  static const Field<SettingsMyProfileEditState, String> _f$redirectURI = Field(
    'redirectURI',
    _$redirectURI,
    opt: true,
    def: "",
  );
  static String _$firstName(SettingsMyProfileEditState v) => v.firstName;
  static const Field<SettingsMyProfileEditState, String> _f$firstName = Field(
    'firstName',
    _$firstName,
    opt: true,
    def: "",
  );
  static String _$lastName(SettingsMyProfileEditState v) => v.lastName;
  static const Field<SettingsMyProfileEditState, String> _f$lastName = Field(
    'lastName',
    _$lastName,
    opt: true,
    def: "",
  );
  static String _$aboutMe(SettingsMyProfileEditState v) => v.aboutMe;
  static const Field<SettingsMyProfileEditState, String> _f$aboutMe = Field(
    'aboutMe',
    _$aboutMe,
    opt: true,
    def: "",
  );
  static DateTime? _$birthDate(SettingsMyProfileEditState v) => v.birthDate;
  static const Field<SettingsMyProfileEditState, DateTime> _f$birthDate = Field(
    'birthDate',
    _$birthDate,
    opt: true,
  );
  static String _$boringAvatarHash(SettingsMyProfileEditState v) =>
      v.boringAvatarHash;
  static const Field<SettingsMyProfileEditState, String> _f$boringAvatarHash =
      Field('boringAvatarHash', _$boringAvatarHash, opt: true, def: "");
  static BoringAvatarType _$boringAvatarType(SettingsMyProfileEditState v) =>
      v.boringAvatarType;
  static const Field<SettingsMyProfileEditState, BoringAvatarType>
  _f$boringAvatarType = Field(
    'boringAvatarType',
    _$boringAvatarType,
    opt: true,
    def: BoringAvatarType.ring,
  );
  static int _$aboutMeLength(SettingsMyProfileEditState v) => v.aboutMeLength;
  static const Field<SettingsMyProfileEditState, int> _f$aboutMeLength = Field(
    'aboutMeLength',
    _$aboutMeLength,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<SettingsMyProfileEditState> fields = const {
    #status: _f$status,
    #networkStatus: _f$networkStatus,
    #error: _f$error,
    #redirectURI: _f$redirectURI,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #aboutMe: _f$aboutMe,
    #birthDate: _f$birthDate,
    #boringAvatarHash: _f$boringAvatarHash,
    #boringAvatarType: _f$boringAvatarType,
    #aboutMeLength: _f$aboutMeLength,
  };

  static SettingsMyProfileEditState _instantiate(DecodingData data) {
    return SettingsMyProfileEditState(
      status: data.dec(_f$status),
      networkStatus: data.dec(_f$networkStatus),
      error: data.dec(_f$error),
      redirectURI: data.dec(_f$redirectURI),
      firstName: data.dec(_f$firstName),
      lastName: data.dec(_f$lastName),
      aboutMe: data.dec(_f$aboutMe),
      birthDate: data.dec(_f$birthDate),
      boringAvatarHash: data.dec(_f$boringAvatarHash),
      boringAvatarType: data.dec(_f$boringAvatarType),
      aboutMeLength: data.dec(_f$aboutMeLength),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsMyProfileEditState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsMyProfileEditState>(map);
  }

  static SettingsMyProfileEditState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsMyProfileEditState>(json);
  }
}

mixin SettingsMyProfileEditStateMappable {
  String toJson() {
    return SettingsMyProfileEditStateMapper.ensureInitialized()
        .encodeJson<SettingsMyProfileEditState>(
          this as SettingsMyProfileEditState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsMyProfileEditStateMapper.ensureInitialized()
        .encodeMap<SettingsMyProfileEditState>(
          this as SettingsMyProfileEditState,
        );
  }

  SettingsMyProfileEditStateCopyWith<
    SettingsMyProfileEditState,
    SettingsMyProfileEditState,
    SettingsMyProfileEditState
  >
  get copyWith =>
      _SettingsMyProfileEditStateCopyWithImpl<
        SettingsMyProfileEditState,
        SettingsMyProfileEditState
      >(this as SettingsMyProfileEditState, $identity, $identity);
  @override
  String toString() {
    return SettingsMyProfileEditStateMapper.ensureInitialized().stringifyValue(
      this as SettingsMyProfileEditState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsMyProfileEditStateMapper.ensureInitialized().equalsValue(
      this as SettingsMyProfileEditState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsMyProfileEditStateMapper.ensureInitialized().hashValue(
      this as SettingsMyProfileEditState,
    );
  }
}

extension SettingsMyProfileEditStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsMyProfileEditState, $Out> {
  SettingsMyProfileEditStateCopyWith<$R, SettingsMyProfileEditState, $Out>
  get $asSettingsMyProfileEditState => $base.as(
    (v, t, t2) => _SettingsMyProfileEditStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsMyProfileEditStateCopyWith<
  $R,
  $In extends SettingsMyProfileEditState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Status? status,
    Status? networkStatus,
    String? error,
    String? redirectURI,
    String? firstName,
    String? lastName,
    String? aboutMe,
    DateTime? birthDate,
    String? boringAvatarHash,
    BoringAvatarType? boringAvatarType,
    int? aboutMeLength,
  });
  SettingsMyProfileEditStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsMyProfileEditStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsMyProfileEditState, $Out>
    implements
        SettingsMyProfileEditStateCopyWith<
          $R,
          SettingsMyProfileEditState,
          $Out
        > {
  _SettingsMyProfileEditStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsMyProfileEditState> $mapper =
      SettingsMyProfileEditStateMapper.ensureInitialized();
  @override
  $R call({
    Status? status,
    Status? networkStatus,
    String? error,
    String? redirectURI,
    String? firstName,
    String? lastName,
    String? aboutMe,
    Object? birthDate = $none,
    String? boringAvatarHash,
    BoringAvatarType? boringAvatarType,
    int? aboutMeLength,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (networkStatus != null) #networkStatus: networkStatus,
      if (error != null) #error: error,
      if (redirectURI != null) #redirectURI: redirectURI,
      if (firstName != null) #firstName: firstName,
      if (lastName != null) #lastName: lastName,
      if (aboutMe != null) #aboutMe: aboutMe,
      if (birthDate != $none) #birthDate: birthDate,
      if (boringAvatarHash != null) #boringAvatarHash: boringAvatarHash,
      if (boringAvatarType != null) #boringAvatarType: boringAvatarType,
      if (aboutMeLength != null) #aboutMeLength: aboutMeLength,
    }),
  );
  @override
  SettingsMyProfileEditState $make(
    CopyWithData data,
  ) => SettingsMyProfileEditState(
    status: data.get(#status, or: $value.status),
    networkStatus: data.get(#networkStatus, or: $value.networkStatus),
    error: data.get(#error, or: $value.error),
    redirectURI: data.get(#redirectURI, or: $value.redirectURI),
    firstName: data.get(#firstName, or: $value.firstName),
    lastName: data.get(#lastName, or: $value.lastName),
    aboutMe: data.get(#aboutMe, or: $value.aboutMe),
    birthDate: data.get(#birthDate, or: $value.birthDate),
    boringAvatarHash: data.get(#boringAvatarHash, or: $value.boringAvatarHash),
    boringAvatarType: data.get(#boringAvatarType, or: $value.boringAvatarType),
    aboutMeLength: data.get(#aboutMeLength, or: $value.aboutMeLength),
  );

  @override
  SettingsMyProfileEditStateCopyWith<$R2, SettingsMyProfileEditState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsMyProfileEditStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

