// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_language_state.dart';

class SettingsLanguageStateMapper
    extends ClassMapperBase<SettingsLanguageState> {
  SettingsLanguageStateMapper._();

  static SettingsLanguageStateMapper? _instance;
  static SettingsLanguageStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsLanguageStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsLanguageState';

  static Status _$status(SettingsLanguageState v) => v.status;
  static const Field<SettingsLanguageState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(SettingsLanguageState v) => v.error;
  static const Field<SettingsLanguageState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static AppLocale _$locale(SettingsLanguageState v) => v.locale;
  static const Field<SettingsLanguageState, AppLocale> _f$locale = Field(
    'locale',
    _$locale,
    opt: true,
    def: AppLocale.en,
  );

  @override
  final MappableFields<SettingsLanguageState> fields = const {
    #status: _f$status,
    #error: _f$error,
    #locale: _f$locale,
  };

  static SettingsLanguageState _instantiate(DecodingData data) {
    return SettingsLanguageState(
      status: data.dec(_f$status),
      error: data.dec(_f$error),
      locale: data.dec(_f$locale),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsLanguageState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsLanguageState>(map);
  }

  static SettingsLanguageState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsLanguageState>(json);
  }
}

mixin SettingsLanguageStateMappable {
  String toJson() {
    return SettingsLanguageStateMapper.ensureInitialized()
        .encodeJson<SettingsLanguageState>(this as SettingsLanguageState);
  }

  Map<String, dynamic> toMap() {
    return SettingsLanguageStateMapper.ensureInitialized()
        .encodeMap<SettingsLanguageState>(this as SettingsLanguageState);
  }

  SettingsLanguageStateCopyWith<
    SettingsLanguageState,
    SettingsLanguageState,
    SettingsLanguageState
  >
  get copyWith =>
      _SettingsLanguageStateCopyWithImpl<
        SettingsLanguageState,
        SettingsLanguageState
      >(this as SettingsLanguageState, $identity, $identity);
  @override
  String toString() {
    return SettingsLanguageStateMapper.ensureInitialized().stringifyValue(
      this as SettingsLanguageState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsLanguageStateMapper.ensureInitialized().equalsValue(
      this as SettingsLanguageState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsLanguageStateMapper.ensureInitialized().hashValue(
      this as SettingsLanguageState,
    );
  }
}

extension SettingsLanguageStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsLanguageState, $Out> {
  SettingsLanguageStateCopyWith<$R, SettingsLanguageState, $Out>
  get $asSettingsLanguageState => $base.as(
    (v, t, t2) => _SettingsLanguageStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsLanguageStateCopyWith<
  $R,
  $In extends SettingsLanguageState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Status? status, String? error, AppLocale? locale});
  SettingsLanguageStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsLanguageStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsLanguageState, $Out>
    implements SettingsLanguageStateCopyWith<$R, SettingsLanguageState, $Out> {
  _SettingsLanguageStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsLanguageState> $mapper =
      SettingsLanguageStateMapper.ensureInitialized();
  @override
  $R call({Status? status, String? error, AppLocale? locale}) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (error != null) #error: error,
      if (locale != null) #locale: locale,
    }),
  );
  @override
  SettingsLanguageState $make(CopyWithData data) => SettingsLanguageState(
    status: data.get(#status, or: $value.status),
    error: data.get(#error, or: $value.error),
    locale: data.get(#locale, or: $value.locale),
  );

  @override
  SettingsLanguageStateCopyWith<$R2, SettingsLanguageState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsLanguageStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

