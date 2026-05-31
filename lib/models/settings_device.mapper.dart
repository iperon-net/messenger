// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_device.dart';

class SettingsDeviceColorThemeMapper
    extends EnumMapper<SettingsDeviceColorTheme> {
  SettingsDeviceColorThemeMapper._();

  static SettingsDeviceColorThemeMapper? _instance;
  static SettingsDeviceColorThemeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SettingsDeviceColorThemeMapper._(),
      );
    }
    return _instance!;
  }

  static SettingsDeviceColorTheme fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SettingsDeviceColorTheme decode(dynamic value) {
    switch (value) {
      case r'blue':
        return SettingsDeviceColorTheme.blue;
      case r'green':
        return SettingsDeviceColorTheme.green;
      case r'purple':
        return SettingsDeviceColorTheme.purple;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SettingsDeviceColorTheme self) {
    switch (self) {
      case SettingsDeviceColorTheme.blue:
        return r'blue';
      case SettingsDeviceColorTheme.green:
        return r'green';
      case SettingsDeviceColorTheme.purple:
        return r'purple';
    }
  }
}

extension SettingsDeviceColorThemeMapperExtension on SettingsDeviceColorTheme {
  String toValue() {
    SettingsDeviceColorThemeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SettingsDeviceColorTheme>(this)
        as String;
  }
}

class SettingsDeviceDarkModeMapper extends EnumMapper<SettingsDeviceDarkMode> {
  SettingsDeviceDarkModeMapper._();

  static SettingsDeviceDarkModeMapper? _instance;
  static SettingsDeviceDarkModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsDeviceDarkModeMapper._());
    }
    return _instance!;
  }

  static SettingsDeviceDarkMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SettingsDeviceDarkMode decode(dynamic value) {
    switch (value) {
      case r'system':
        return SettingsDeviceDarkMode.system;
      case r'disabled':
        return SettingsDeviceDarkMode.disabled;
      case r'alwaysOn':
        return SettingsDeviceDarkMode.alwaysOn;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SettingsDeviceDarkMode self) {
    switch (self) {
      case SettingsDeviceDarkMode.system:
        return r'system';
      case SettingsDeviceDarkMode.disabled:
        return r'disabled';
      case SettingsDeviceDarkMode.alwaysOn:
        return r'alwaysOn';
    }
  }
}

extension SettingsDeviceDarkModeMapperExtension on SettingsDeviceDarkMode {
  String toValue() {
    SettingsDeviceDarkModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SettingsDeviceDarkMode>(this)
        as String;
  }
}

class SettingsDeviceMapper extends ClassMapperBase<SettingsDevice> {
  SettingsDeviceMapper._();

  static SettingsDeviceMapper? _instance;
  static SettingsDeviceMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsDeviceMapper._());
      SettingsDeviceDarkModeMapper.ensureInitialized();
      SettingsDeviceColorThemeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsDevice';

  static AppLocale? _$locale(SettingsDevice v) => v.locale;
  static const Field<SettingsDevice, AppLocale> _f$locale = Field(
    'locale',
    _$locale,
    opt: true,
  );
  static SettingsDeviceDarkMode _$darkMode(SettingsDevice v) => v.darkMode;
  static const Field<SettingsDevice, SettingsDeviceDarkMode> _f$darkMode =
      Field(
        'darkMode',
        _$darkMode,
        opt: true,
        def: SettingsDeviceDarkMode.system,
      );
  static SettingsDeviceColorTheme _$colorTheme(SettingsDevice v) =>
      v.colorTheme;
  static const Field<SettingsDevice, SettingsDeviceColorTheme> _f$colorTheme =
      Field(
        'colorTheme',
        _$colorTheme,
        opt: true,
        def: SettingsDeviceColorTheme.blue,
      );
  static bool _$blurTaskSwitchingEnable(SettingsDevice v) =>
      v.blurTaskSwitchingEnable;
  static const Field<SettingsDevice, bool> _f$blurTaskSwitchingEnable = Field(
    'blurTaskSwitchingEnable',
    _$blurTaskSwitchingEnable,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<SettingsDevice> fields = const {
    #locale: _f$locale,
    #darkMode: _f$darkMode,
    #colorTheme: _f$colorTheme,
    #blurTaskSwitchingEnable: _f$blurTaskSwitchingEnable,
  };

  static SettingsDevice _instantiate(DecodingData data) {
    return SettingsDevice(
      locale: data.dec(_f$locale),
      darkMode: data.dec(_f$darkMode),
      colorTheme: data.dec(_f$colorTheme),
      blurTaskSwitchingEnable: data.dec(_f$blurTaskSwitchingEnable),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsDevice fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsDevice>(map);
  }

  static SettingsDevice fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsDevice>(json);
  }
}

mixin SettingsDeviceMappable {
  String toJson() {
    return SettingsDeviceMapper.ensureInitialized().encodeJson<SettingsDevice>(
      this as SettingsDevice,
    );
  }

  Map<String, dynamic> toMap() {
    return SettingsDeviceMapper.ensureInitialized().encodeMap<SettingsDevice>(
      this as SettingsDevice,
    );
  }

  SettingsDeviceCopyWith<SettingsDevice, SettingsDevice, SettingsDevice>
  get copyWith => _SettingsDeviceCopyWithImpl<SettingsDevice, SettingsDevice>(
    this as SettingsDevice,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SettingsDeviceMapper.ensureInitialized().stringifyValue(
      this as SettingsDevice,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsDeviceMapper.ensureInitialized().equalsValue(
      this as SettingsDevice,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsDeviceMapper.ensureInitialized().hashValue(
      this as SettingsDevice,
    );
  }
}

extension SettingsDeviceValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsDevice, $Out> {
  SettingsDeviceCopyWith<$R, SettingsDevice, $Out> get $asSettingsDevice =>
      $base.as((v, t, t2) => _SettingsDeviceCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SettingsDeviceCopyWith<$R, $In extends SettingsDevice, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    AppLocale? locale,
    SettingsDeviceDarkMode? darkMode,
    SettingsDeviceColorTheme? colorTheme,
    bool? blurTaskSwitchingEnable,
  });
  SettingsDeviceCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsDeviceCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsDevice, $Out>
    implements SettingsDeviceCopyWith<$R, SettingsDevice, $Out> {
  _SettingsDeviceCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsDevice> $mapper =
      SettingsDeviceMapper.ensureInitialized();
  @override
  $R call({
    Object? locale = $none,
    SettingsDeviceDarkMode? darkMode,
    SettingsDeviceColorTheme? colorTheme,
    bool? blurTaskSwitchingEnable,
  }) => $apply(
    FieldCopyWithData({
      if (locale != $none) #locale: locale,
      if (darkMode != null) #darkMode: darkMode,
      if (colorTheme != null) #colorTheme: colorTheme,
      if (blurTaskSwitchingEnable != null)
        #blurTaskSwitchingEnable: blurTaskSwitchingEnable,
    }),
  );
  @override
  SettingsDevice $make(CopyWithData data) => SettingsDevice(
    locale: data.get(#locale, or: $value.locale),
    darkMode: data.get(#darkMode, or: $value.darkMode),
    colorTheme: data.get(#colorTheme, or: $value.colorTheme),
    blurTaskSwitchingEnable: data.get(
      #blurTaskSwitchingEnable,
      or: $value.blurTaskSwitchingEnable,
    ),
  );

  @override
  SettingsDeviceCopyWith<$R2, SettingsDevice, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SettingsDeviceCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

