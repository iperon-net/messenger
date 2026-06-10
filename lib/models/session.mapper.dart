// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'session.dart';

class SessionMapper extends ClassMapperBase<Session> {
  SessionMapper._();

  static SessionMapper? _instance;
  static SessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SessionMapper._());
      MapperContainer.globals.useAll([BoolMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'Session';

  static List<int> _$session(Session v) => v.session;
  static const Field<Session, List<int>> _f$session = Field(
    'session',
    _$session,
    opt: true,
    def: const [],
  );
  static List<int> _$userID(Session v) => v.userID;
  static const Field<Session, List<int>> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
    def: const [],
  );
  static List<int> _$sharedKey(Session v) => v.sharedKey;
  static const Field<Session, List<int>> _f$sharedKey = Field(
    'sharedKey',
    _$sharedKey,
    opt: true,
    def: const [],
  );
  static List<int> _$sharedSalt(Session v) => v.sharedSalt;
  static const Field<Session, List<int>> _f$sharedSalt = Field(
    'sharedSalt',
    _$sharedSalt,
    opt: true,
    def: const [],
  );
  static bool _$isActive(Session v) => v.isActive;
  static const Field<Session, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<Session> fields = const {
    #session: _f$session,
    #userID: _f$userID,
    #sharedKey: _f$sharedKey,
    #sharedSalt: _f$sharedSalt,
    #isActive: _f$isActive,
  };

  static Session _instantiate(DecodingData data) {
    return Session(
      session: data.dec(_f$session),
      userID: data.dec(_f$userID),
      sharedKey: data.dec(_f$sharedKey),
      sharedSalt: data.dec(_f$sharedSalt),
      isActive: data.dec(_f$isActive),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Session fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Session>(map);
  }

  static Session fromJson(String json) {
    return ensureInitialized().decodeJson<Session>(json);
  }
}

mixin SessionMappable {
  String toJson() {
    return SessionMapper.ensureInitialized().encodeJson<Session>(
      this as Session,
    );
  }

  Map<String, dynamic> toMap() {
    return SessionMapper.ensureInitialized().encodeMap<Session>(
      this as Session,
    );
  }

  SessionCopyWith<Session, Session, Session> get copyWith =>
      _SessionCopyWithImpl<Session, Session>(
        this as Session,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SessionMapper.ensureInitialized().stringifyValue(this as Session);
  }

  @override
  bool operator ==(Object other) {
    return SessionMapper.ensureInitialized().equalsValue(
      this as Session,
      other,
    );
  }

  @override
  int get hashCode {
    return SessionMapper.ensureInitialized().hashValue(this as Session);
  }
}

extension SessionValueCopy<$R, $Out> on ObjectCopyWith<$R, Session, $Out> {
  SessionCopyWith<$R, Session, $Out> get $asSession =>
      $base.as((v, t, t2) => _SessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SessionCopyWith<$R, $In extends Session, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get session;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get sharedKey;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get sharedSalt;
  $R call({
    List<int>? session,
    List<int>? userID,
    List<int>? sharedKey,
    List<int>? sharedSalt,
    bool? isActive,
  });
  SessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Session, $Out>
    implements SessionCopyWith<$R, Session, $Out> {
  _SessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Session> $mapper =
      SessionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get session =>
      ListCopyWith(
        $value.session,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(session: v),
      );
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID =>
      ListCopyWith(
        $value.userID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userID: v),
      );
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get sharedKey =>
      ListCopyWith(
        $value.sharedKey,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(sharedKey: v),
      );
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get sharedSalt =>
      ListCopyWith(
        $value.sharedSalt,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(sharedSalt: v),
      );
  @override
  $R call({
    List<int>? session,
    List<int>? userID,
    List<int>? sharedKey,
    List<int>? sharedSalt,
    bool? isActive,
  }) => $apply(
    FieldCopyWithData({
      if (session != null) #session: session,
      if (userID != null) #userID: userID,
      if (sharedKey != null) #sharedKey: sharedKey,
      if (sharedSalt != null) #sharedSalt: sharedSalt,
      if (isActive != null) #isActive: isActive,
    }),
  );
  @override
  Session $make(CopyWithData data) => Session(
    session: data.get(#session, or: $value.session),
    userID: data.get(#userID, or: $value.userID),
    sharedKey: data.get(#sharedKey, or: $value.sharedKey),
    sharedSalt: data.get(#sharedSalt, or: $value.sharedSalt),
    isActive: data.get(#isActive, or: $value.isActive),
  );

  @override
  SessionCopyWith<$R2, Session, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

