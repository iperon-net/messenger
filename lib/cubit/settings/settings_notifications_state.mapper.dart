// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_notifications_state.dart';

class NotifyScopeSettingsMapper extends ClassMapperBase<NotifyScopeSettings> {
  NotifyScopeSettingsMapper._();

  static NotifyScopeSettingsMapper? _instance;
  static NotifyScopeSettingsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NotifyScopeSettingsMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NotifyScopeSettings';

  static bool _$enabled(NotifyScopeSettings v) => v.enabled;
  static const Field<NotifyScopeSettings, bool> _f$enabled = Field(
    'enabled',
    _$enabled,
    opt: true,
    def: true,
  );
  static bool _$showPreviews(NotifyScopeSettings v) => v.showPreviews;
  static const Field<NotifyScopeSettings, bool> _f$showPreviews = Field(
    'showPreviews',
    _$showPreviews,
    opt: true,
    def: true,
  );
  static bool _$sound(NotifyScopeSettings v) => v.sound;
  static const Field<NotifyScopeSettings, bool> _f$sound = Field(
    'sound',
    _$sound,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<NotifyScopeSettings> fields = const {
    #enabled: _f$enabled,
    #showPreviews: _f$showPreviews,
    #sound: _f$sound,
  };

  static NotifyScopeSettings _instantiate(DecodingData data) {
    return NotifyScopeSettings(
      enabled: data.dec(_f$enabled),
      showPreviews: data.dec(_f$showPreviews),
      sound: data.dec(_f$sound),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NotifyScopeSettings fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NotifyScopeSettings>(map);
  }

  static NotifyScopeSettings fromJson(String json) {
    return ensureInitialized().decodeJson<NotifyScopeSettings>(json);
  }
}

mixin NotifyScopeSettingsMappable {
  String toJson() {
    return NotifyScopeSettingsMapper.ensureInitialized()
        .encodeJson<NotifyScopeSettings>(this as NotifyScopeSettings);
  }

  Map<String, dynamic> toMap() {
    return NotifyScopeSettingsMapper.ensureInitialized()
        .encodeMap<NotifyScopeSettings>(this as NotifyScopeSettings);
  }

  NotifyScopeSettingsCopyWith<
    NotifyScopeSettings,
    NotifyScopeSettings,
    NotifyScopeSettings
  >
  get copyWith =>
      _NotifyScopeSettingsCopyWithImpl<
        NotifyScopeSettings,
        NotifyScopeSettings
      >(this as NotifyScopeSettings, $identity, $identity);
  @override
  String toString() {
    return NotifyScopeSettingsMapper.ensureInitialized().stringifyValue(
      this as NotifyScopeSettings,
    );
  }

  @override
  bool operator ==(Object other) {
    return NotifyScopeSettingsMapper.ensureInitialized().equalsValue(
      this as NotifyScopeSettings,
      other,
    );
  }

  @override
  int get hashCode {
    return NotifyScopeSettingsMapper.ensureInitialized().hashValue(
      this as NotifyScopeSettings,
    );
  }
}

extension NotifyScopeSettingsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NotifyScopeSettings, $Out> {
  NotifyScopeSettingsCopyWith<$R, NotifyScopeSettings, $Out>
  get $asNotifyScopeSettings => $base.as(
    (v, t, t2) => _NotifyScopeSettingsCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class NotifyScopeSettingsCopyWith<
  $R,
  $In extends NotifyScopeSettings,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? enabled, bool? showPreviews, bool? sound});
  NotifyScopeSettingsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _NotifyScopeSettingsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NotifyScopeSettings, $Out>
    implements NotifyScopeSettingsCopyWith<$R, NotifyScopeSettings, $Out> {
  _NotifyScopeSettingsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NotifyScopeSettings> $mapper =
      NotifyScopeSettingsMapper.ensureInitialized();
  @override
  $R call({bool? enabled, bool? showPreviews, bool? sound}) => $apply(
    FieldCopyWithData({
      if (enabled != null) #enabled: enabled,
      if (showPreviews != null) #showPreviews: showPreviews,
      if (sound != null) #sound: sound,
    }),
  );
  @override
  NotifyScopeSettings $make(CopyWithData data) => NotifyScopeSettings(
    enabled: data.get(#enabled, or: $value.enabled),
    showPreviews: data.get(#showPreviews, or: $value.showPreviews),
    sound: data.get(#sound, or: $value.sound),
  );

  @override
  NotifyScopeSettingsCopyWith<$R2, NotifyScopeSettings, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NotifyScopeSettingsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SettingsNotificationsStateMapper
    extends ClassMapperBase<SettingsNotificationsState> {
  SettingsNotificationsStateMapper._();

  static SettingsNotificationsStateMapper? _instance;
  static SettingsNotificationsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsNotificationsStateMapper._(),
      );
      NotifyScopeSettingsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsNotificationsState';

  static Status _$status(SettingsNotificationsState v) => v.status;
  static const Field<SettingsNotificationsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static bool _$loadError(SettingsNotificationsState v) => v.loadError;
  static const Field<SettingsNotificationsState, bool> _f$loadError = Field(
    'loadError',
    _$loadError,
    opt: true,
    def: false,
  );
  static bool _$readOnly(SettingsNotificationsState v) => v.readOnly;
  static const Field<SettingsNotificationsState, bool> _f$readOnly = Field(
    'readOnly',
    _$readOnly,
    opt: true,
    def: false,
  );
  static NotifyScopeSettings _$privateChats(SettingsNotificationsState v) =>
      v.privateChats;
  static const Field<SettingsNotificationsState, NotifyScopeSettings>
  _f$privateChats = Field(
    'privateChats',
    _$privateChats,
    opt: true,
    def: const NotifyScopeSettings(),
  );
  static NotifyScopeSettings _$groups(SettingsNotificationsState v) => v.groups;
  static const Field<SettingsNotificationsState, NotifyScopeSettings>
  _f$groups = Field(
    'groups',
    _$groups,
    opt: true,
    def: const NotifyScopeSettings(),
  );
  static NotifyScopeSettings _$channels(SettingsNotificationsState v) =>
      v.channels;
  static const Field<SettingsNotificationsState, NotifyScopeSettings>
  _f$channels = Field(
    'channels',
    _$channels,
    opt: true,
    def: const NotifyScopeSettings(),
  );
  static bool _$contactJoined(SettingsNotificationsState v) => v.contactJoined;
  static const Field<SettingsNotificationsState, bool> _f$contactJoined = Field(
    'contactJoined',
    _$contactJoined,
    opt: true,
    def: true,
  );
  static bool _$missedCalls(SettingsNotificationsState v) => v.missedCalls;
  static const Field<SettingsNotificationsState, bool> _f$missedCalls = Field(
    'missedCalls',
    _$missedCalls,
    opt: true,
    def: true,
  );
  static bool _$permissionMissing(SettingsNotificationsState v) =>
      v.permissionMissing;
  static const Field<SettingsNotificationsState, bool> _f$permissionMissing =
      Field('permissionMissing', _$permissionMissing, opt: true, def: false);

  @override
  final MappableFields<SettingsNotificationsState> fields = const {
    #status: _f$status,
    #loadError: _f$loadError,
    #readOnly: _f$readOnly,
    #privateChats: _f$privateChats,
    #groups: _f$groups,
    #channels: _f$channels,
    #contactJoined: _f$contactJoined,
    #missedCalls: _f$missedCalls,
    #permissionMissing: _f$permissionMissing,
  };

  static SettingsNotificationsState _instantiate(DecodingData data) {
    return SettingsNotificationsState(
      status: data.dec(_f$status),
      loadError: data.dec(_f$loadError),
      readOnly: data.dec(_f$readOnly),
      privateChats: data.dec(_f$privateChats),
      groups: data.dec(_f$groups),
      channels: data.dec(_f$channels),
      contactJoined: data.dec(_f$contactJoined),
      missedCalls: data.dec(_f$missedCalls),
      permissionMissing: data.dec(_f$permissionMissing),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsNotificationsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsNotificationsState>(map);
  }

  static SettingsNotificationsState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsNotificationsState>(json);
  }
}

mixin SettingsNotificationsStateMappable {
  String toJson() {
    return SettingsNotificationsStateMapper.ensureInitialized()
        .encodeJson<SettingsNotificationsState>(
          this as SettingsNotificationsState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsNotificationsStateMapper.ensureInitialized()
        .encodeMap<SettingsNotificationsState>(
          this as SettingsNotificationsState,
        );
  }

  SettingsNotificationsStateCopyWith<
    SettingsNotificationsState,
    SettingsNotificationsState,
    SettingsNotificationsState
  >
  get copyWith =>
      _SettingsNotificationsStateCopyWithImpl<
        SettingsNotificationsState,
        SettingsNotificationsState
      >(this as SettingsNotificationsState, $identity, $identity);
  @override
  String toString() {
    return SettingsNotificationsStateMapper.ensureInitialized().stringifyValue(
      this as SettingsNotificationsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsNotificationsStateMapper.ensureInitialized().equalsValue(
      this as SettingsNotificationsState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsNotificationsStateMapper.ensureInitialized().hashValue(
      this as SettingsNotificationsState,
    );
  }
}

extension SettingsNotificationsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsNotificationsState, $Out> {
  SettingsNotificationsStateCopyWith<$R, SettingsNotificationsState, $Out>
  get $asSettingsNotificationsState => $base.as(
    (v, t, t2) => _SettingsNotificationsStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsNotificationsStateCopyWith<
  $R,
  $In extends SettingsNotificationsState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  NotifyScopeSettingsCopyWith<$R, NotifyScopeSettings, NotifyScopeSettings>
  get privateChats;
  NotifyScopeSettingsCopyWith<$R, NotifyScopeSettings, NotifyScopeSettings>
  get groups;
  NotifyScopeSettingsCopyWith<$R, NotifyScopeSettings, NotifyScopeSettings>
  get channels;
  $R call({
    Status? status,
    bool? loadError,
    bool? readOnly,
    NotifyScopeSettings? privateChats,
    NotifyScopeSettings? groups,
    NotifyScopeSettings? channels,
    bool? contactJoined,
    bool? missedCalls,
    bool? permissionMissing,
  });
  SettingsNotificationsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsNotificationsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsNotificationsState, $Out>
    implements
        SettingsNotificationsStateCopyWith<
          $R,
          SettingsNotificationsState,
          $Out
        > {
  _SettingsNotificationsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsNotificationsState> $mapper =
      SettingsNotificationsStateMapper.ensureInitialized();
  @override
  NotifyScopeSettingsCopyWith<$R, NotifyScopeSettings, NotifyScopeSettings>
  get privateChats =>
      $value.privateChats.copyWith.$chain((v) => call(privateChats: v));
  @override
  NotifyScopeSettingsCopyWith<$R, NotifyScopeSettings, NotifyScopeSettings>
  get groups => $value.groups.copyWith.$chain((v) => call(groups: v));
  @override
  NotifyScopeSettingsCopyWith<$R, NotifyScopeSettings, NotifyScopeSettings>
  get channels => $value.channels.copyWith.$chain((v) => call(channels: v));
  @override
  $R call({
    Status? status,
    bool? loadError,
    bool? readOnly,
    NotifyScopeSettings? privateChats,
    NotifyScopeSettings? groups,
    NotifyScopeSettings? channels,
    bool? contactJoined,
    bool? missedCalls,
    bool? permissionMissing,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (loadError != null) #loadError: loadError,
      if (readOnly != null) #readOnly: readOnly,
      if (privateChats != null) #privateChats: privateChats,
      if (groups != null) #groups: groups,
      if (channels != null) #channels: channels,
      if (contactJoined != null) #contactJoined: contactJoined,
      if (missedCalls != null) #missedCalls: missedCalls,
      if (permissionMissing != null) #permissionMissing: permissionMissing,
    }),
  );
  @override
  SettingsNotificationsState $make(CopyWithData data) =>
      SettingsNotificationsState(
        status: data.get(#status, or: $value.status),
        loadError: data.get(#loadError, or: $value.loadError),
        readOnly: data.get(#readOnly, or: $value.readOnly),
        privateChats: data.get(#privateChats, or: $value.privateChats),
        groups: data.get(#groups, or: $value.groups),
        channels: data.get(#channels, or: $value.channels),
        contactJoined: data.get(#contactJoined, or: $value.contactJoined),
        missedCalls: data.get(#missedCalls, or: $value.missedCalls),
        permissionMissing: data.get(
          #permissionMissing,
          or: $value.permissionMissing,
        ),
      );

  @override
  SettingsNotificationsStateCopyWith<$R2, SettingsNotificationsState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsNotificationsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

