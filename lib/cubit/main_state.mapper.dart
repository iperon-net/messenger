// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'main_state.dart';

class MainStateMapper extends ClassMapperBase<MainState> {
  MainStateMapper._();

  static MainStateMapper? _instance;
  static MainStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MainStateMapper._());
      SettingsDeviceMapper.ensureInitialized();
      UserMapper.ensureInitialized();
      SessionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MainState';

  static Status _$status(MainState v) => v.status;
  static const Field<MainState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static SettingsDevice _$settingsDevice(MainState v) => v.settingsDevice;
  static const Field<MainState, SettingsDevice> _f$settingsDevice = Field(
    'settingsDevice',
    _$settingsDevice,
  );
  static User _$user(MainState v) => v.user;
  static const Field<MainState, User> _f$user = Field('user', _$user);
  static Session _$session(MainState v) => v.session;
  static const Field<MainState, Session> _f$session = Field(
    'session',
    _$session,
  );

  @override
  final MappableFields<MainState> fields = const {
    #status: _f$status,
    #settingsDevice: _f$settingsDevice,
    #user: _f$user,
    #session: _f$session,
  };

  static MainState _instantiate(DecodingData data) {
    return MainState(
      status: data.dec(_f$status),
      settingsDevice: data.dec(_f$settingsDevice),
      user: data.dec(_f$user),
      session: data.dec(_f$session),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MainState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MainState>(map);
  }

  static MainState fromJson(String json) {
    return ensureInitialized().decodeJson<MainState>(json);
  }
}

mixin MainStateMappable {
  String toJson() {
    return MainStateMapper.ensureInitialized().encodeJson<MainState>(
      this as MainState,
    );
  }

  Map<String, dynamic> toMap() {
    return MainStateMapper.ensureInitialized().encodeMap<MainState>(
      this as MainState,
    );
  }

  MainStateCopyWith<MainState, MainState, MainState> get copyWith =>
      _MainStateCopyWithImpl<MainState, MainState>(
        this as MainState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MainStateMapper.ensureInitialized().stringifyValue(
      this as MainState,
    );
  }

  @override
  bool operator ==(Object other) {
    return MainStateMapper.ensureInitialized().equalsValue(
      this as MainState,
      other,
    );
  }

  @override
  int get hashCode {
    return MainStateMapper.ensureInitialized().hashValue(this as MainState);
  }
}

extension MainStateValueCopy<$R, $Out> on ObjectCopyWith<$R, MainState, $Out> {
  MainStateCopyWith<$R, MainState, $Out> get $asMainState =>
      $base.as((v, t, t2) => _MainStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MainStateCopyWith<$R, $In extends MainState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  SettingsDeviceCopyWith<$R, SettingsDevice, SettingsDevice> get settingsDevice;
  UserCopyWith<$R, User, User> get user;
  SessionCopyWith<$R, Session, Session> get session;
  $R call({
    Status? status,
    SettingsDevice? settingsDevice,
    User? user,
    Session? session,
  });
  MainStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MainStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MainState, $Out>
    implements MainStateCopyWith<$R, MainState, $Out> {
  _MainStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MainState> $mapper =
      MainStateMapper.ensureInitialized();
  @override
  SettingsDeviceCopyWith<$R, SettingsDevice, SettingsDevice>
  get settingsDevice =>
      $value.settingsDevice.copyWith.$chain((v) => call(settingsDevice: v));
  @override
  UserCopyWith<$R, User, User> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  SessionCopyWith<$R, Session, Session> get session =>
      $value.session.copyWith.$chain((v) => call(session: v));
  @override
  $R call({
    Status? status,
    SettingsDevice? settingsDevice,
    User? user,
    Session? session,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (settingsDevice != null) #settingsDevice: settingsDevice,
      if (user != null) #user: user,
      if (session != null) #session: session,
    }),
  );
  @override
  MainState $make(CopyWithData data) => MainState(
    status: data.get(#status, or: $value.status),
    settingsDevice: data.get(#settingsDevice, or: $value.settingsDevice),
    user: data.get(#user, or: $value.user),
    session: data.get(#session, or: $value.session),
  );

  @override
  MainStateCopyWith<$R2, MainState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MainStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

