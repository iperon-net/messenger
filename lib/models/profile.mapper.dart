// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'profile.dart';

class ProfileMapper extends ClassMapperBase<Profile> {
  ProfileMapper._();

  static ProfileMapper? _instance;
  static ProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileMapper._());
      MapperContainer.globals.useAll([EpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'Profile';

  static List<int> _$userID(Profile v) => v.userID;
  static const Field<Profile, List<int>> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
    def: const [],
  );
  static String _$username(Profile v) => v.username;
  static const Field<Profile, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
    def: "",
  );
  static String _$fistName(Profile v) => v.fistName;
  static const Field<Profile, String> _f$fistName = Field(
    'fistName',
    _$fistName,
    opt: true,
    def: "",
  );
  static String _$lastName(Profile v) => v.lastName;
  static const Field<Profile, String> _f$lastName = Field(
    'lastName',
    _$lastName,
    opt: true,
    def: "",
  );
  static DateTime? _$birthDate(Profile v) => v.birthDate;
  static const Field<Profile, DateTime> _f$birthDate = Field(
    'birthDate',
    _$birthDate,
    opt: true,
  );
  static String _$aboutMe(Profile v) => v.aboutMe;
  static const Field<Profile, String> _f$aboutMe = Field(
    'aboutMe',
    _$aboutMe,
    opt: true,
    def: "",
  );
  static String _$phoneNumber(Profile v) => v.phoneNumber;
  static const Field<Profile, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
    opt: true,
    def: "",
  );
  static List<int>? _$avatarCdnID(Profile v) => v.avatarCdnID;
  static const Field<Profile, List<int>> _f$avatarCdnID = Field(
    'avatarCdnID',
    _$avatarCdnID,
    opt: true,
  );

  @override
  final MappableFields<Profile> fields = const {
    #userID: _f$userID,
    #username: _f$username,
    #fistName: _f$fistName,
    #lastName: _f$lastName,
    #birthDate: _f$birthDate,
    #aboutMe: _f$aboutMe,
    #phoneNumber: _f$phoneNumber,
    #avatarCdnID: _f$avatarCdnID,
  };

  static Profile _instantiate(DecodingData data) {
    return Profile(
      userID: data.dec(_f$userID),
      username: data.dec(_f$username),
      fistName: data.dec(_f$fistName),
      lastName: data.dec(_f$lastName),
      birthDate: data.dec(_f$birthDate),
      aboutMe: data.dec(_f$aboutMe),
      phoneNumber: data.dec(_f$phoneNumber),
      avatarCdnID: data.dec(_f$avatarCdnID),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Profile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Profile>(map);
  }

  static Profile fromJson(String json) {
    return ensureInitialized().decodeJson<Profile>(json);
  }
}

mixin ProfileMappable {
  String toJson() {
    return ProfileMapper.ensureInitialized().encodeJson<Profile>(
      this as Profile,
    );
  }

  Map<String, dynamic> toMap() {
    return ProfileMapper.ensureInitialized().encodeMap<Profile>(
      this as Profile,
    );
  }

  ProfileCopyWith<Profile, Profile, Profile> get copyWith =>
      _ProfileCopyWithImpl<Profile, Profile>(
        this as Profile,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ProfileMapper.ensureInitialized().stringifyValue(this as Profile);
  }

  @override
  bool operator ==(Object other) {
    return ProfileMapper.ensureInitialized().equalsValue(
      this as Profile,
      other,
    );
  }

  @override
  int get hashCode {
    return ProfileMapper.ensureInitialized().hashValue(this as Profile);
  }
}

extension ProfileValueCopy<$R, $Out> on ObjectCopyWith<$R, Profile, $Out> {
  ProfileCopyWith<$R, Profile, $Out> get $asProfile =>
      $base.as((v, t, t2) => _ProfileCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProfileCopyWith<$R, $In extends Profile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get avatarCdnID;
  $R call({
    List<int>? userID,
    String? username,
    String? fistName,
    String? lastName,
    DateTime? birthDate,
    String? aboutMe,
    String? phoneNumber,
    List<int>? avatarCdnID,
  });
  ProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Profile, $Out>
    implements ProfileCopyWith<$R, Profile, $Out> {
  _ProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Profile> $mapper =
      ProfileMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID =>
      ListCopyWith(
        $value.userID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userID: v),
      );
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>>? get avatarCdnID =>
      $value.avatarCdnID != null
      ? ListCopyWith(
          $value.avatarCdnID!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(avatarCdnID: v),
        )
      : null;
  @override
  $R call({
    List<int>? userID,
    String? username,
    String? fistName,
    String? lastName,
    Object? birthDate = $none,
    String? aboutMe,
    String? phoneNumber,
    Object? avatarCdnID = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userID != null) #userID: userID,
      if (username != null) #username: username,
      if (fistName != null) #fistName: fistName,
      if (lastName != null) #lastName: lastName,
      if (birthDate != $none) #birthDate: birthDate,
      if (aboutMe != null) #aboutMe: aboutMe,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
      if (avatarCdnID != $none) #avatarCdnID: avatarCdnID,
    }),
  );
  @override
  Profile $make(CopyWithData data) => Profile(
    userID: data.get(#userID, or: $value.userID),
    username: data.get(#username, or: $value.username),
    fistName: data.get(#fistName, or: $value.fistName),
    lastName: data.get(#lastName, or: $value.lastName),
    birthDate: data.get(#birthDate, or: $value.birthDate),
    aboutMe: data.get(#aboutMe, or: $value.aboutMe),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
    avatarCdnID: data.get(#avatarCdnID, or: $value.avatarCdnID),
  );

  @override
  ProfileCopyWith<$R2, Profile, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProfileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

