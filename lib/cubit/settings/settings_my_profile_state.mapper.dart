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
  static Status _$networkStatus(SettingsMyProfileState v) => v.networkStatus;
  static const Field<SettingsMyProfileState, Status> _f$networkStatus = Field(
    'networkStatus',
    _$networkStatus,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(SettingsMyProfileState v) => v.error;
  static const Field<SettingsMyProfileState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static String _$redirectURI(SettingsMyProfileState v) => v.redirectURI;
  static const Field<SettingsMyProfileState, String> _f$redirectURI = Field(
    'redirectURI',
    _$redirectURI,
    opt: true,
    def: "",
  );
  static AppLocale _$locale(SettingsMyProfileState v) => v.locale;
  static const Field<SettingsMyProfileState, AppLocale> _f$locale = Field(
    'locale',
    _$locale,
    opt: true,
    def: AppLocale.en,
  );
  static String _$firstName(SettingsMyProfileState v) => v.firstName;
  static const Field<SettingsMyProfileState, String> _f$firstName = Field(
    'firstName',
    _$firstName,
    opt: true,
    def: "",
  );
  static String _$lastName(SettingsMyProfileState v) => v.lastName;
  static const Field<SettingsMyProfileState, String> _f$lastName = Field(
    'lastName',
    _$lastName,
    opt: true,
    def: "",
  );
  static String _$aboutMe(SettingsMyProfileState v) => v.aboutMe;
  static const Field<SettingsMyProfileState, String> _f$aboutMe = Field(
    'aboutMe',
    _$aboutMe,
    opt: true,
    def: "",
  );
  static DateTime? _$birthDate(SettingsMyProfileState v) => v.birthDate;
  static const Field<SettingsMyProfileState, DateTime> _f$birthDate = Field(
    'birthDate',
    _$birthDate,
    opt: true,
  );
  static String _$username(SettingsMyProfileState v) => v.username;
  static const Field<SettingsMyProfileState, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
    def: "",
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
    #networkStatus: _f$networkStatus,
    #error: _f$error,
    #redirectURI: _f$redirectURI,
    #locale: _f$locale,
    #firstName: _f$firstName,
    #lastName: _f$lastName,
    #aboutMe: _f$aboutMe,
    #birthDate: _f$birthDate,
    #username: _f$username,
    #boringAvatarHash: _f$boringAvatarHash,
    #boringAvatarType: _f$boringAvatarType,
    #aboutMeLength: _f$aboutMeLength,
  };

  static SettingsMyProfileState _instantiate(DecodingData data) {
    return SettingsMyProfileState(
      status: data.dec(_f$status),
      networkStatus: data.dec(_f$networkStatus),
      error: data.dec(_f$error),
      redirectURI: data.dec(_f$redirectURI),
      locale: data.dec(_f$locale),
      firstName: data.dec(_f$firstName),
      lastName: data.dec(_f$lastName),
      aboutMe: data.dec(_f$aboutMe),
      birthDate: data.dec(_f$birthDate),
      username: data.dec(_f$username),
      boringAvatarHash: data.dec(_f$boringAvatarHash),
      boringAvatarType: data.dec(_f$boringAvatarType),
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
    Status? networkStatus,
    String? error,
    String? redirectURI,
    AppLocale? locale,
    String? firstName,
    String? lastName,
    String? aboutMe,
    DateTime? birthDate,
    String? username,
    String? boringAvatarHash,
    BoringAvatarType? boringAvatarType,
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
    Status? networkStatus,
    String? error,
    String? redirectURI,
    AppLocale? locale,
    String? firstName,
    String? lastName,
    String? aboutMe,
    Object? birthDate = $none,
    String? username,
    String? boringAvatarHash,
    BoringAvatarType? boringAvatarType,
    int? aboutMeLength,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (networkStatus != null) #networkStatus: networkStatus,
      if (error != null) #error: error,
      if (redirectURI != null) #redirectURI: redirectURI,
      if (locale != null) #locale: locale,
      if (firstName != null) #firstName: firstName,
      if (lastName != null) #lastName: lastName,
      if (aboutMe != null) #aboutMe: aboutMe,
      if (birthDate != $none) #birthDate: birthDate,
      if (username != null) #username: username,
      if (boringAvatarHash != null) #boringAvatarHash: boringAvatarHash,
      if (boringAvatarType != null) #boringAvatarType: boringAvatarType,
      if (aboutMeLength != null) #aboutMeLength: aboutMeLength,
    }),
  );
  @override
  SettingsMyProfileState $make(CopyWithData data) => SettingsMyProfileState(
    status: data.get(#status, or: $value.status),
    networkStatus: data.get(#networkStatus, or: $value.networkStatus),
    error: data.get(#error, or: $value.error),
    redirectURI: data.get(#redirectURI, or: $value.redirectURI),
    locale: data.get(#locale, or: $value.locale),
    firstName: data.get(#firstName, or: $value.firstName),
    lastName: data.get(#lastName, or: $value.lastName),
    aboutMe: data.get(#aboutMe, or: $value.aboutMe),
    birthDate: data.get(#birthDate, or: $value.birthDate),
    username: data.get(#username, or: $value.username),
    boringAvatarHash: data.get(#boringAvatarHash, or: $value.boringAvatarHash),
    boringAvatarType: data.get(#boringAvatarType, or: $value.boringAvatarType),
    aboutMeLength: data.get(#aboutMeLength, or: $value.aboutMeLength),
  );

  @override
  SettingsMyProfileStateCopyWith<$R2, SettingsMyProfileState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsMyProfileStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

