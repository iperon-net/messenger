// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_device.dart';

class SettingsDeviceModelMapper extends ClassMapperBase<SettingsDeviceModel> {
  SettingsDeviceModelMapper._();

  static SettingsDeviceModelMapper? _instance;
  static SettingsDeviceModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsDeviceModelMapper._());
      DarkModeModelMapper.ensureInitialized();
      ColorThemeModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsDeviceModel';

  static AppLocale? _$locale(SettingsDeviceModel v) => v.locale;
  static const Field<SettingsDeviceModel, AppLocale> _f$locale = Field(
    'locale',
    _$locale,
    opt: true,
  );
  static DarkModeModel _$darkMode(SettingsDeviceModel v) => v.darkMode;
  static const Field<SettingsDeviceModel, DarkModeModel> _f$darkMode = Field(
    'darkMode',
    _$darkMode,
    opt: true,
    def: DarkModeModel.system,
  );
  static ColorThemeModel _$colorTheme(SettingsDeviceModel v) => v.colorTheme;
  static const Field<SettingsDeviceModel, ColorThemeModel> _f$colorTheme =
      Field('colorTheme', _$colorTheme, opt: true, def: ColorThemeModel.blue);
  static bool _$isBlurOnInactive(SettingsDeviceModel v) => v.isBlurOnInactive;
  static const Field<SettingsDeviceModel, bool> _f$isBlurOnInactive = Field(
    'isBlurOnInactive',
    _$isBlurOnInactive,
    opt: true,
    def: false,
  );
  static List<int> _$passcode(SettingsDeviceModel v) => v.passcode;
  static const Field<SettingsDeviceModel, List<int>> _f$passcode = Field(
    'passcode',
    _$passcode,
    opt: true,
    def: const [],
  );
  static bool _$passcodeBiometric(SettingsDeviceModel v) => v.passcodeBiometric;
  static const Field<SettingsDeviceModel, bool> _f$passcodeBiometric = Field(
    'passcodeBiometric',
    _$passcodeBiometric,
    opt: true,
    def: false,
  );
  static int _$passcodeAutoLock(SettingsDeviceModel v) => v.passcodeAutoLock;
  static const Field<SettingsDeviceModel, int> _f$passcodeAutoLock = Field(
    'passcodeAutoLock',
    _$passcodeAutoLock,
    opt: true,
    def: 0,
  );
  static bool _$passcodeForceLocked(SettingsDeviceModel v) =>
      v.passcodeForceLocked;
  static const Field<SettingsDeviceModel, bool> _f$passcodeForceLocked = Field(
    'passcodeForceLocked',
    _$passcodeForceLocked,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<SettingsDeviceModel> fields = const {
    #locale: _f$locale,
    #darkMode: _f$darkMode,
    #colorTheme: _f$colorTheme,
    #isBlurOnInactive: _f$isBlurOnInactive,
    #passcode: _f$passcode,
    #passcodeBiometric: _f$passcodeBiometric,
    #passcodeAutoLock: _f$passcodeAutoLock,
    #passcodeForceLocked: _f$passcodeForceLocked,
  };

  static SettingsDeviceModel _instantiate(DecodingData data) {
    return SettingsDeviceModel(
      locale: data.dec(_f$locale),
      darkMode: data.dec(_f$darkMode),
      colorTheme: data.dec(_f$colorTheme),
      isBlurOnInactive: data.dec(_f$isBlurOnInactive),
      passcode: data.dec(_f$passcode),
      passcodeBiometric: data.dec(_f$passcodeBiometric),
      passcodeAutoLock: data.dec(_f$passcodeAutoLock),
      passcodeForceLocked: data.dec(_f$passcodeForceLocked),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsDeviceModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsDeviceModel>(map);
  }

  static SettingsDeviceModel fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsDeviceModel>(json);
  }
}

mixin SettingsDeviceModelMappable {
  String toJson() {
    return SettingsDeviceModelMapper.ensureInitialized()
        .encodeJson<SettingsDeviceModel>(this as SettingsDeviceModel);
  }

  Map<String, dynamic> toMap() {
    return SettingsDeviceModelMapper.ensureInitialized()
        .encodeMap<SettingsDeviceModel>(this as SettingsDeviceModel);
  }

  SettingsDeviceModelCopyWith<
    SettingsDeviceModel,
    SettingsDeviceModel,
    SettingsDeviceModel
  >
  get copyWith =>
      _SettingsDeviceModelCopyWithImpl<
        SettingsDeviceModel,
        SettingsDeviceModel
      >(this as SettingsDeviceModel, $identity, $identity);
  @override
  String toString() {
    return SettingsDeviceModelMapper.ensureInitialized().stringifyValue(
      this as SettingsDeviceModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsDeviceModelMapper.ensureInitialized().equalsValue(
      this as SettingsDeviceModel,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsDeviceModelMapper.ensureInitialized().hashValue(
      this as SettingsDeviceModel,
    );
  }
}

extension SettingsDeviceModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsDeviceModel, $Out> {
  SettingsDeviceModelCopyWith<$R, SettingsDeviceModel, $Out>
  get $asSettingsDeviceModel => $base.as(
    (v, t, t2) => _SettingsDeviceModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsDeviceModelCopyWith<
  $R,
  $In extends SettingsDeviceModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get passcode;
  $R call({
    AppLocale? locale,
    DarkModeModel? darkMode,
    ColorThemeModel? colorTheme,
    bool? isBlurOnInactive,
    List<int>? passcode,
    bool? passcodeBiometric,
    int? passcodeAutoLock,
    bool? passcodeForceLocked,
  });
  SettingsDeviceModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsDeviceModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsDeviceModel, $Out>
    implements SettingsDeviceModelCopyWith<$R, SettingsDeviceModel, $Out> {
  _SettingsDeviceModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsDeviceModel> $mapper =
      SettingsDeviceModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get passcode =>
      ListCopyWith(
        $value.passcode,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(passcode: v),
      );
  @override
  $R call({
    Object? locale = $none,
    DarkModeModel? darkMode,
    ColorThemeModel? colorTheme,
    bool? isBlurOnInactive,
    List<int>? passcode,
    bool? passcodeBiometric,
    int? passcodeAutoLock,
    bool? passcodeForceLocked,
  }) => $apply(
    FieldCopyWithData({
      if (locale != $none) #locale: locale,
      if (darkMode != null) #darkMode: darkMode,
      if (colorTheme != null) #colorTheme: colorTheme,
      if (isBlurOnInactive != null) #isBlurOnInactive: isBlurOnInactive,
      if (passcode != null) #passcode: passcode,
      if (passcodeBiometric != null) #passcodeBiometric: passcodeBiometric,
      if (passcodeAutoLock != null) #passcodeAutoLock: passcodeAutoLock,
      if (passcodeForceLocked != null)
        #passcodeForceLocked: passcodeForceLocked,
    }),
  );
  @override
  SettingsDeviceModel $make(CopyWithData data) => SettingsDeviceModel(
    locale: data.get(#locale, or: $value.locale),
    darkMode: data.get(#darkMode, or: $value.darkMode),
    colorTheme: data.get(#colorTheme, or: $value.colorTheme),
    isBlurOnInactive: data.get(#isBlurOnInactive, or: $value.isBlurOnInactive),
    passcode: data.get(#passcode, or: $value.passcode),
    passcodeBiometric: data.get(
      #passcodeBiometric,
      or: $value.passcodeBiometric,
    ),
    passcodeAutoLock: data.get(#passcodeAutoLock, or: $value.passcodeAutoLock),
    passcodeForceLocked: data.get(
      #passcodeForceLocked,
      or: $value.passcodeForceLocked,
    ),
  );

  @override
  SettingsDeviceModelCopyWith<$R2, SettingsDeviceModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsDeviceModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

