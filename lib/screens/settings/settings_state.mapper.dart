// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_state.dart';

class SettingsStateMapper extends ClassMapperBase<SettingsState> {
  SettingsStateMapper._();

  static SettingsStateMapper? _instance;
  static SettingsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsState';

  static Status _$status(SettingsState v) => v.status;
  static const Field<SettingsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(SettingsState v) => v.error;
  static const Field<SettingsState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static bool _$logout(SettingsState v) => v.logout;
  static const Field<SettingsState, bool> _f$logout = Field(
    'logout',
    _$logout,
    opt: true,
    def: false,
  );
  static int _$deviceCount(SettingsState v) => v.deviceCount;
  static const Field<SettingsState, int> _f$deviceCount = Field(
    'deviceCount',
    _$deviceCount,
    opt: true,
    def: 0,
  );
  static AppLocale _$locale(SettingsState v) => v.locale;
  static const Field<SettingsState, AppLocale> _f$locale = Field(
    'locale',
    _$locale,
    opt: true,
    def: AppLocale.en,
  );

  @override
  final MappableFields<SettingsState> fields = const {
    #status: _f$status,
    #error: _f$error,
    #logout: _f$logout,
    #deviceCount: _f$deviceCount,
    #locale: _f$locale,
  };

  static SettingsState _instantiate(DecodingData data) {
    return SettingsState(
      status: data.dec(_f$status),
      error: data.dec(_f$error),
      logout: data.dec(_f$logout),
      deviceCount: data.dec(_f$deviceCount),
      locale: data.dec(_f$locale),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsState>(map);
  }

  static SettingsState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsState>(json);
  }
}

mixin SettingsStateMappable {
  String toJson() {
    return SettingsStateMapper.ensureInitialized().encodeJson<SettingsState>(
      this as SettingsState,
    );
  }

  Map<String, dynamic> toMap() {
    return SettingsStateMapper.ensureInitialized().encodeMap<SettingsState>(
      this as SettingsState,
    );
  }

  SettingsStateCopyWith<SettingsState, SettingsState, SettingsState>
  get copyWith => _SettingsStateCopyWithImpl<SettingsState, SettingsState>(
    this as SettingsState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SettingsStateMapper.ensureInitialized().stringifyValue(
      this as SettingsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsStateMapper.ensureInitialized().equalsValue(
      this as SettingsState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsStateMapper.ensureInitialized().hashValue(
      this as SettingsState,
    );
  }
}

extension SettingsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsState, $Out> {
  SettingsStateCopyWith<$R, SettingsState, $Out> get $asSettingsState =>
      $base.as((v, t, t2) => _SettingsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SettingsStateCopyWith<$R, $In extends SettingsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Status? status,
    String? error,
    bool? logout,
    int? deviceCount,
    AppLocale? locale,
  });
  SettingsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SettingsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsState, $Out>
    implements SettingsStateCopyWith<$R, SettingsState, $Out> {
  _SettingsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsState> $mapper =
      SettingsStateMapper.ensureInitialized();
  @override
  $R call({
    Status? status,
    String? error,
    bool? logout,
    int? deviceCount,
    AppLocale? locale,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (error != null) #error: error,
      if (logout != null) #logout: logout,
      if (deviceCount != null) #deviceCount: deviceCount,
      if (locale != null) #locale: locale,
    }),
  );
  @override
  SettingsState $make(CopyWithData data) => SettingsState(
    status: data.get(#status, or: $value.status),
    error: data.get(#error, or: $value.error),
    logout: data.get(#logout, or: $value.logout),
    deviceCount: data.get(#deviceCount, or: $value.deviceCount),
    locale: data.get(#locale, or: $value.locale),
  );

  @override
  SettingsStateCopyWith<$R2, SettingsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SettingsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

