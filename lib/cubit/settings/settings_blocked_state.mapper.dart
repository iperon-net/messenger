// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_blocked_state.dart';

class BlockedUserMapper extends ClassMapperBase<BlockedUser> {
  BlockedUserMapper._();

  static BlockedUserMapper? _instance;
  static BlockedUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BlockedUserMapper._());
      MapperContainer.globals.useAll([Uint8ListMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'BlockedUser';

  static Uint8List _$userID(BlockedUser v) => v.userID;
  static const Field<BlockedUser, Uint8List> _f$userID = Field(
    'userID',
    _$userID,
  );
  static String _$name(BlockedUser v) => v.name;
  static const Field<BlockedUser, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<BlockedUser> fields = const {
    #userID: _f$userID,
    #name: _f$name,
  };

  static BlockedUser _instantiate(DecodingData data) {
    return BlockedUser(userID: data.dec(_f$userID), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static BlockedUser fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BlockedUser>(map);
  }

  static BlockedUser fromJson(String json) {
    return ensureInitialized().decodeJson<BlockedUser>(json);
  }
}

mixin BlockedUserMappable {
  String toJson() {
    return BlockedUserMapper.ensureInitialized().encodeJson<BlockedUser>(
      this as BlockedUser,
    );
  }

  Map<String, dynamic> toMap() {
    return BlockedUserMapper.ensureInitialized().encodeMap<BlockedUser>(
      this as BlockedUser,
    );
  }

  BlockedUserCopyWith<BlockedUser, BlockedUser, BlockedUser> get copyWith =>
      _BlockedUserCopyWithImpl<BlockedUser, BlockedUser>(
        this as BlockedUser,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BlockedUserMapper.ensureInitialized().stringifyValue(
      this as BlockedUser,
    );
  }

  @override
  bool operator ==(Object other) {
    return BlockedUserMapper.ensureInitialized().equalsValue(
      this as BlockedUser,
      other,
    );
  }

  @override
  int get hashCode {
    return BlockedUserMapper.ensureInitialized().hashValue(this as BlockedUser);
  }
}

extension BlockedUserValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BlockedUser, $Out> {
  BlockedUserCopyWith<$R, BlockedUser, $Out> get $asBlockedUser =>
      $base.as((v, t, t2) => _BlockedUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BlockedUserCopyWith<$R, $In extends BlockedUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Uint8List? userID, String? name});
  BlockedUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BlockedUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BlockedUser, $Out>
    implements BlockedUserCopyWith<$R, BlockedUser, $Out> {
  _BlockedUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BlockedUser> $mapper =
      BlockedUserMapper.ensureInitialized();
  @override
  $R call({Uint8List? userID, String? name}) => $apply(
    FieldCopyWithData({
      if (userID != null) #userID: userID,
      if (name != null) #name: name,
    }),
  );
  @override
  BlockedUser $make(CopyWithData data) => BlockedUser(
    userID: data.get(#userID, or: $value.userID),
    name: data.get(#name, or: $value.name),
  );

  @override
  BlockedUserCopyWith<$R2, BlockedUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BlockedUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SettingsBlockedStateMapper extends ClassMapperBase<SettingsBlockedState> {
  SettingsBlockedStateMapper._();

  static SettingsBlockedStateMapper? _instance;
  static SettingsBlockedStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsBlockedStateMapper._());
      BlockedUserMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsBlockedState';

  static Status _$status(SettingsBlockedState v) => v.status;
  static const Field<SettingsBlockedState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static List<BlockedUser> _$users(SettingsBlockedState v) => v.users;
  static const Field<SettingsBlockedState, List<BlockedUser>> _f$users = Field(
    'users',
    _$users,
    opt: true,
    def: const [],
  );
  static int _$offlineNotice(SettingsBlockedState v) => v.offlineNotice;
  static const Field<SettingsBlockedState, int> _f$offlineNotice = Field(
    'offlineNotice',
    _$offlineNotice,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<SettingsBlockedState> fields = const {
    #status: _f$status,
    #users: _f$users,
    #offlineNotice: _f$offlineNotice,
  };

  static SettingsBlockedState _instantiate(DecodingData data) {
    return SettingsBlockedState(
      status: data.dec(_f$status),
      users: data.dec(_f$users),
      offlineNotice: data.dec(_f$offlineNotice),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsBlockedState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsBlockedState>(map);
  }

  static SettingsBlockedState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsBlockedState>(json);
  }
}

mixin SettingsBlockedStateMappable {
  String toJson() {
    return SettingsBlockedStateMapper.ensureInitialized()
        .encodeJson<SettingsBlockedState>(this as SettingsBlockedState);
  }

  Map<String, dynamic> toMap() {
    return SettingsBlockedStateMapper.ensureInitialized()
        .encodeMap<SettingsBlockedState>(this as SettingsBlockedState);
  }

  SettingsBlockedStateCopyWith<
    SettingsBlockedState,
    SettingsBlockedState,
    SettingsBlockedState
  >
  get copyWith =>
      _SettingsBlockedStateCopyWithImpl<
        SettingsBlockedState,
        SettingsBlockedState
      >(this as SettingsBlockedState, $identity, $identity);
  @override
  String toString() {
    return SettingsBlockedStateMapper.ensureInitialized().stringifyValue(
      this as SettingsBlockedState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsBlockedStateMapper.ensureInitialized().equalsValue(
      this as SettingsBlockedState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsBlockedStateMapper.ensureInitialized().hashValue(
      this as SettingsBlockedState,
    );
  }
}

extension SettingsBlockedStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsBlockedState, $Out> {
  SettingsBlockedStateCopyWith<$R, SettingsBlockedState, $Out>
  get $asSettingsBlockedState => $base.as(
    (v, t, t2) => _SettingsBlockedStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsBlockedStateCopyWith<
  $R,
  $In extends SettingsBlockedState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    BlockedUser,
    BlockedUserCopyWith<$R, BlockedUser, BlockedUser>
  >
  get users;
  $R call({Status? status, List<BlockedUser>? users, int? offlineNotice});
  SettingsBlockedStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsBlockedStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsBlockedState, $Out>
    implements SettingsBlockedStateCopyWith<$R, SettingsBlockedState, $Out> {
  _SettingsBlockedStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsBlockedState> $mapper =
      SettingsBlockedStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    BlockedUser,
    BlockedUserCopyWith<$R, BlockedUser, BlockedUser>
  >
  get users => ListCopyWith(
    $value.users,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(users: v),
  );
  @override
  $R call({Status? status, List<BlockedUser>? users, int? offlineNotice}) =>
      $apply(
        FieldCopyWithData({
          if (status != null) #status: status,
          if (users != null) #users: users,
          if (offlineNotice != null) #offlineNotice: offlineNotice,
        }),
      );
  @override
  SettingsBlockedState $make(CopyWithData data) => SettingsBlockedState(
    status: data.get(#status, or: $value.status),
    users: data.get(#users, or: $value.users),
    offlineNotice: data.get(#offlineNotice, or: $value.offlineNotice),
  );

  @override
  SettingsBlockedStateCopyWith<$R2, SettingsBlockedState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsBlockedStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

