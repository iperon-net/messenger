// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_my_profile_username_state.dart';

class SettingsMyProfileUsernameStateMapper
    extends ClassMapperBase<SettingsMyProfileUsernameState> {
  SettingsMyProfileUsernameStateMapper._();

  static SettingsMyProfileUsernameStateMapper? _instance;
  static SettingsMyProfileUsernameStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsMyProfileUsernameStateMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsMyProfileUsernameState';

  static Status _$status(SettingsMyProfileUsernameState v) => v.status;
  static const Field<SettingsMyProfileUsernameState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static Status _$networkStatus(SettingsMyProfileUsernameState v) =>
      v.networkStatus;
  static const Field<SettingsMyProfileUsernameState, Status> _f$networkStatus =
      Field(
        'networkStatus',
        _$networkStatus,
        opt: true,
        def: Status.initialization,
      );
  static String _$error(SettingsMyProfileUsernameState v) => v.error;
  static const Field<SettingsMyProfileUsernameState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static String _$redirectURI(SettingsMyProfileUsernameState v) =>
      v.redirectURI;
  static const Field<SettingsMyProfileUsernameState, String> _f$redirectURI =
      Field('redirectURI', _$redirectURI, opt: true, def: "");
  static String _$username(SettingsMyProfileUsernameState v) => v.username;
  static const Field<SettingsMyProfileUsernameState, String> _f$username =
      Field('username', _$username, opt: true, def: "");
  static AppLocale _$locale(SettingsMyProfileUsernameState v) => v.locale;
  static const Field<SettingsMyProfileUsernameState, AppLocale> _f$locale =
      Field('locale', _$locale, opt: true, def: AppLocale.en);

  @override
  final MappableFields<SettingsMyProfileUsernameState> fields = const {
    #status: _f$status,
    #networkStatus: _f$networkStatus,
    #error: _f$error,
    #redirectURI: _f$redirectURI,
    #username: _f$username,
    #locale: _f$locale,
  };

  static SettingsMyProfileUsernameState _instantiate(DecodingData data) {
    return SettingsMyProfileUsernameState(
      status: data.dec(_f$status),
      networkStatus: data.dec(_f$networkStatus),
      error: data.dec(_f$error),
      redirectURI: data.dec(_f$redirectURI),
      username: data.dec(_f$username),
      locale: data.dec(_f$locale),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsMyProfileUsernameState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsMyProfileUsernameState>(map);
  }

  static SettingsMyProfileUsernameState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsMyProfileUsernameState>(json);
  }
}

mixin SettingsMyProfileUsernameStateMappable {
  String toJson() {
    return SettingsMyProfileUsernameStateMapper.ensureInitialized()
        .encodeJson<SettingsMyProfileUsernameState>(
          this as SettingsMyProfileUsernameState,
        );
  }

  Map<String, dynamic> toMap() {
    return SettingsMyProfileUsernameStateMapper.ensureInitialized()
        .encodeMap<SettingsMyProfileUsernameState>(
          this as SettingsMyProfileUsernameState,
        );
  }

  SettingsMyProfileUsernameStateCopyWith<
    SettingsMyProfileUsernameState,
    SettingsMyProfileUsernameState,
    SettingsMyProfileUsernameState
  >
  get copyWith =>
      _SettingsMyProfileUsernameStateCopyWithImpl<
        SettingsMyProfileUsernameState,
        SettingsMyProfileUsernameState
      >(this as SettingsMyProfileUsernameState, $identity, $identity);
  @override
  String toString() {
    return SettingsMyProfileUsernameStateMapper.ensureInitialized()
        .stringifyValue(this as SettingsMyProfileUsernameState);
  }

  @override
  bool operator ==(Object other) {
    return SettingsMyProfileUsernameStateMapper.ensureInitialized().equalsValue(
      this as SettingsMyProfileUsernameState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsMyProfileUsernameStateMapper.ensureInitialized().hashValue(
      this as SettingsMyProfileUsernameState,
    );
  }
}

extension SettingsMyProfileUsernameStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsMyProfileUsernameState, $Out> {
  SettingsMyProfileUsernameStateCopyWith<
    $R,
    SettingsMyProfileUsernameState,
    $Out
  >
  get $asSettingsMyProfileUsernameState => $base.as(
    (v, t, t2) =>
        _SettingsMyProfileUsernameStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsMyProfileUsernameStateCopyWith<
  $R,
  $In extends SettingsMyProfileUsernameState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Status? status,
    Status? networkStatus,
    String? error,
    String? redirectURI,
    String? username,
    AppLocale? locale,
  });
  SettingsMyProfileUsernameStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsMyProfileUsernameStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsMyProfileUsernameState, $Out>
    implements
        SettingsMyProfileUsernameStateCopyWith<
          $R,
          SettingsMyProfileUsernameState,
          $Out
        > {
  _SettingsMyProfileUsernameStateCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SettingsMyProfileUsernameState> $mapper =
      SettingsMyProfileUsernameStateMapper.ensureInitialized();
  @override
  $R call({
    Status? status,
    Status? networkStatus,
    String? error,
    String? redirectURI,
    String? username,
    AppLocale? locale,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (networkStatus != null) #networkStatus: networkStatus,
      if (error != null) #error: error,
      if (redirectURI != null) #redirectURI: redirectURI,
      if (username != null) #username: username,
      if (locale != null) #locale: locale,
    }),
  );
  @override
  SettingsMyProfileUsernameState $make(CopyWithData data) =>
      SettingsMyProfileUsernameState(
        status: data.get(#status, or: $value.status),
        networkStatus: data.get(#networkStatus, or: $value.networkStatus),
        error: data.get(#error, or: $value.error),
        redirectURI: data.get(#redirectURI, or: $value.redirectURI),
        username: data.get(#username, or: $value.username),
        locale: data.get(#locale, or: $value.locale),
      );

  @override
  SettingsMyProfileUsernameStateCopyWith<
    $R2,
    SettingsMyProfileUsernameState,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsMyProfileUsernameStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

