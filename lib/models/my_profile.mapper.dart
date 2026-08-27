// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'my_profile.dart';

class MyProfileMapper extends ClassMapperBase<MyProfile> {
  MyProfileMapper._();

  static MyProfileMapper? _instance;
  static MyProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MyProfileMapper._());
      MapperContainer.globals.useAll([EpochDateTimeMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'MyProfile';

  static List<int> _$userID(MyProfile v) => v.userID;
  static const Field<MyProfile, List<int>> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
    def: const [],
  );
  static String _$username(MyProfile v) => v.username;
  static const Field<MyProfile, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
    def: "",
  );
  static String _$fistName(MyProfile v) => v.fistName;
  static const Field<MyProfile, String> _f$fistName = Field(
    'fistName',
    _$fistName,
    opt: true,
    def: "",
  );
  static String _$lastName(MyProfile v) => v.lastName;
  static const Field<MyProfile, String> _f$lastName = Field(
    'lastName',
    _$lastName,
    opt: true,
    def: "",
  );
  static DateTime? _$birthDate(MyProfile v) => v.birthDate;
  static const Field<MyProfile, DateTime> _f$birthDate = Field(
    'birthDate',
    _$birthDate,
    opt: true,
  );
  static String _$aboutMe(MyProfile v) => v.aboutMe;
  static const Field<MyProfile, String> _f$aboutMe = Field(
    'aboutMe',
    _$aboutMe,
    opt: true,
    def: "",
  );

  @override
  final MappableFields<MyProfile> fields = const {
    #userID: _f$userID,
    #username: _f$username,
    #fistName: _f$fistName,
    #lastName: _f$lastName,
    #birthDate: _f$birthDate,
    #aboutMe: _f$aboutMe,
  };

  static MyProfile _instantiate(DecodingData data) {
    return MyProfile(
      userID: data.dec(_f$userID),
      username: data.dec(_f$username),
      fistName: data.dec(_f$fistName),
      lastName: data.dec(_f$lastName),
      birthDate: data.dec(_f$birthDate),
      aboutMe: data.dec(_f$aboutMe),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MyProfile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MyProfile>(map);
  }

  static MyProfile fromJson(String json) {
    return ensureInitialized().decodeJson<MyProfile>(json);
  }
}

mixin MyProfileMappable {
  String toJson() {
    return MyProfileMapper.ensureInitialized().encodeJson<MyProfile>(
      this as MyProfile,
    );
  }

  Map<String, dynamic> toMap() {
    return MyProfileMapper.ensureInitialized().encodeMap<MyProfile>(
      this as MyProfile,
    );
  }

  MyProfileCopyWith<MyProfile, MyProfile, MyProfile> get copyWith =>
      _MyProfileCopyWithImpl<MyProfile, MyProfile>(
        this as MyProfile,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MyProfileMapper.ensureInitialized().stringifyValue(
      this as MyProfile,
    );
  }

  @override
  bool operator ==(Object other) {
    return MyProfileMapper.ensureInitialized().equalsValue(
      this as MyProfile,
      other,
    );
  }

  @override
  int get hashCode {
    return MyProfileMapper.ensureInitialized().hashValue(this as MyProfile);
  }
}

extension MyProfileValueCopy<$R, $Out> on ObjectCopyWith<$R, MyProfile, $Out> {
  MyProfileCopyWith<$R, MyProfile, $Out> get $asMyProfile =>
      $base.as((v, t, t2) => _MyProfileCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MyProfileCopyWith<$R, $In extends MyProfile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID;
  $R call({
    List<int>? userID,
    String? username,
    String? fistName,
    String? lastName,
    DateTime? birthDate,
    String? aboutMe,
  });
  MyProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MyProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MyProfile, $Out>
    implements MyProfileCopyWith<$R, MyProfile, $Out> {
  _MyProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MyProfile> $mapper =
      MyProfileMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID =>
      ListCopyWith(
        $value.userID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userID: v),
      );
  @override
  $R call({
    List<int>? userID,
    String? username,
    String? fistName,
    String? lastName,
    Object? birthDate = $none,
    String? aboutMe,
  }) => $apply(
    FieldCopyWithData({
      if (userID != null) #userID: userID,
      if (username != null) #username: username,
      if (fistName != null) #fistName: fistName,
      if (lastName != null) #lastName: lastName,
      if (birthDate != $none) #birthDate: birthDate,
      if (aboutMe != null) #aboutMe: aboutMe,
    }),
  );
  @override
  MyProfile $make(CopyWithData data) => MyProfile(
    userID: data.get(#userID, or: $value.userID),
    username: data.get(#username, or: $value.username),
    fistName: data.get(#fistName, or: $value.fistName),
    lastName: data.get(#lastName, or: $value.lastName),
    birthDate: data.get(#birthDate, or: $value.birthDate),
    aboutMe: data.get(#aboutMe, or: $value.aboutMe),
  );

  @override
  MyProfileCopyWith<$R2, MyProfile, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MyProfileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

