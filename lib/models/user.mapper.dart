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
      SharedKeyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'User';

  static String _$userID(User v) => v.userID;
  static const Field<User, String> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
    def: "",
  );
  static String _$phoneNumber(User v) => v.phoneNumber;
  static const Field<User, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
    opt: true,
    def: "",
  );
  static List<int> _$session(User v) => v.session;
  static const Field<User, List<int>> _f$session = Field(
    'session',
    _$session,
    opt: true,
    def: const [],
  );
  static List<SharedKey> _$sharedKeys(User v) => v.sharedKeys;
  static const Field<User, List<SharedKey>> _f$sharedKeys = Field(
    'sharedKeys',
    _$sharedKeys,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<User> fields = const {
    #userID: _f$userID,
    #phoneNumber: _f$phoneNumber,
    #session: _f$session,
    #sharedKeys: _f$sharedKeys,
  };

  static User _instantiate(DecodingData data) {
    return User(
      userID: data.dec(_f$userID),
      phoneNumber: data.dec(_f$phoneNumber),
      session: data.dec(_f$session),
      sharedKeys: data.dec(_f$sharedKeys),
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
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get session;
  ListCopyWith<$R, SharedKey, SharedKeyCopyWith<$R, SharedKey, SharedKey>>
  get sharedKeys;
  $R call({
    String? userID,
    String? phoneNumber,
    List<int>? session,
    List<SharedKey>? sharedKeys,
  });
  UserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, User, $Out>
    implements UserCopyWith<$R, User, $Out> {
  _UserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<User> $mapper = UserMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get session =>
      ListCopyWith(
        $value.session,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(session: v),
      );
  @override
  ListCopyWith<$R, SharedKey, SharedKeyCopyWith<$R, SharedKey, SharedKey>>
  get sharedKeys => ListCopyWith(
    $value.sharedKeys,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(sharedKeys: v),
  );
  @override
  $R call({
    String? userID,
    String? phoneNumber,
    List<int>? session,
    List<SharedKey>? sharedKeys,
  }) => $apply(
    FieldCopyWithData({
      if (userID != null) #userID: userID,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
      if (session != null) #session: session,
      if (sharedKeys != null) #sharedKeys: sharedKeys,
    }),
  );
  @override
  User $make(CopyWithData data) => User(
    userID: data.get(#userID, or: $value.userID),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
    session: data.get(#session, or: $value.session),
    sharedKeys: data.get(#sharedKeys, or: $value.sharedKeys),
  );

  @override
  UserCopyWith<$R2, User, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SharedKeyMapper extends ClassMapperBase<SharedKey> {
  SharedKeyMapper._();

  static SharedKeyMapper? _instance;
  static SharedKeyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SharedKeyMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SharedKey';

  static String _$sharedKeyID(SharedKey v) => v.sharedKeyID;
  static const Field<SharedKey, String> _f$sharedKeyID = Field(
    'sharedKeyID',
    _$sharedKeyID,
    opt: true,
    def: "",
  );
  static List<int> _$sharedKey(SharedKey v) => v.sharedKey;
  static const Field<SharedKey, List<int>> _f$sharedKey = Field(
    'sharedKey',
    _$sharedKey,
    opt: true,
    def: const [],
  );
  static DateTime? _$expiredAt(SharedKey v) => v.expiredAt;
  static const Field<SharedKey, DateTime> _f$expiredAt = Field(
    'expiredAt',
    _$expiredAt,
    opt: true,
  );

  @override
  final MappableFields<SharedKey> fields = const {
    #sharedKeyID: _f$sharedKeyID,
    #sharedKey: _f$sharedKey,
    #expiredAt: _f$expiredAt,
  };

  static SharedKey _instantiate(DecodingData data) {
    return SharedKey(
      sharedKeyID: data.dec(_f$sharedKeyID),
      sharedKey: data.dec(_f$sharedKey),
      expiredAt: data.dec(_f$expiredAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SharedKey fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SharedKey>(map);
  }

  static SharedKey fromJson(String json) {
    return ensureInitialized().decodeJson<SharedKey>(json);
  }
}

mixin SharedKeyMappable {
  String toJson() {
    return SharedKeyMapper.ensureInitialized().encodeJson<SharedKey>(
      this as SharedKey,
    );
  }

  Map<String, dynamic> toMap() {
    return SharedKeyMapper.ensureInitialized().encodeMap<SharedKey>(
      this as SharedKey,
    );
  }

  SharedKeyCopyWith<SharedKey, SharedKey, SharedKey> get copyWith =>
      _SharedKeyCopyWithImpl<SharedKey, SharedKey>(
        this as SharedKey,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SharedKeyMapper.ensureInitialized().stringifyValue(
      this as SharedKey,
    );
  }

  @override
  bool operator ==(Object other) {
    return SharedKeyMapper.ensureInitialized().equalsValue(
      this as SharedKey,
      other,
    );
  }

  @override
  int get hashCode {
    return SharedKeyMapper.ensureInitialized().hashValue(this as SharedKey);
  }
}

extension SharedKeyValueCopy<$R, $Out> on ObjectCopyWith<$R, SharedKey, $Out> {
  SharedKeyCopyWith<$R, SharedKey, $Out> get $asSharedKey =>
      $base.as((v, t, t2) => _SharedKeyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SharedKeyCopyWith<$R, $In extends SharedKey, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get sharedKey;
  $R call({String? sharedKeyID, List<int>? sharedKey, DateTime? expiredAt});
  SharedKeyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SharedKeyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SharedKey, $Out>
    implements SharedKeyCopyWith<$R, SharedKey, $Out> {
  _SharedKeyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SharedKey> $mapper =
      SharedKeyMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get sharedKey =>
      ListCopyWith(
        $value.sharedKey,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(sharedKey: v),
      );
  @override
  $R call({
    String? sharedKeyID,
    List<int>? sharedKey,
    Object? expiredAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (sharedKeyID != null) #sharedKeyID: sharedKeyID,
      if (sharedKey != null) #sharedKey: sharedKey,
      if (expiredAt != $none) #expiredAt: expiredAt,
    }),
  );
  @override
  SharedKey $make(CopyWithData data) => SharedKey(
    sharedKeyID: data.get(#sharedKeyID, or: $value.sharedKeyID),
    sharedKey: data.get(#sharedKey, or: $value.sharedKey),
    expiredAt: data.get(#expiredAt, or: $value.expiredAt),
  );

  @override
  SharedKeyCopyWith<$R2, SharedKey, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SharedKeyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

