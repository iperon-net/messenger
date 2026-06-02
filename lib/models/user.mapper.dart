// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user.dart';

class UserMapper extends ClassMapperBase<User> {
  UserMapper._();

  static UserMapper? _instance;
  static UserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserMapper._());
      MapperContainer.globals.useAll([BoolMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'User';

  static List<int> _$userID(User v) => v.userID;
  static const Field<User, List<int>> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
    def: const [],
  );
  static String _$phoneNumber(User v) => v.phoneNumber;
  static const Field<User, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
    opt: true,
    def: "",
  );

  @override
  final MappableFields<User> fields = const {
    #userID: _f$userID,
    #phoneNumber: _f$phoneNumber,
  };

  static User _instantiate(DecodingData data) {
    return User(
      userID: data.dec(_f$userID),
      phoneNumber: data.dec(_f$phoneNumber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static User fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<User>(map);
  }

  static User fromJson(String json) {
    return ensureInitialized().decodeJson<User>(json);
  }
}

mixin UserMappable {
  String toJson() {
    return UserMapper.ensureInitialized().encodeJson<User>(this as User);
  }

  Map<String, dynamic> toMap() {
    return UserMapper.ensureInitialized().encodeMap<User>(this as User);
  }

  UserCopyWith<User, User, User> get copyWith =>
      _UserCopyWithImpl<User, User>(this as User, $identity, $identity);
  @override
  String toString() {
    return UserMapper.ensureInitialized().stringifyValue(this as User);
  }

  @override
  bool operator ==(Object other) {
    return UserMapper.ensureInitialized().equalsValue(this as User, other);
  }

  @override
  int get hashCode {
    return UserMapper.ensureInitialized().hashValue(this as User);
  }
}

extension UserValueCopy<$R, $Out> on ObjectCopyWith<$R, User, $Out> {
  UserCopyWith<$R, User, $Out> get $asUser =>
      $base.as((v, t, t2) => _UserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserCopyWith<$R, $In extends User, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID;
  $R call({List<int>? userID, String? phoneNumber});
  UserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, User, $Out>
    implements UserCopyWith<$R, User, $Out> {
  _UserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<User> $mapper = UserMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID =>
      ListCopyWith(
        $value.userID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userID: v),
      );
  @override
  $R call({List<int>? userID, String? phoneNumber}) => $apply(
    FieldCopyWithData({
      if (userID != null) #userID: userID,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
    }),
  );
  @override
  User $make(CopyWithData data) => User(
    userID: data.get(#userID, or: $value.userID),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
  );

  @override
  UserCopyWith<$R2, User, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

