// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'device_info.dart';

class OSMapper extends EnumMapper<OS> {
  OSMapper._();

  static OSMapper? _instance;
  static OSMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OSMapper._());
    }
    return _instance!;
  }

  static OS fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  OS decode(dynamic value) {
    switch (value) {
      case r'iOS':
        return OS.iOS;
      case r'android':
        return OS.android;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(OS self) {
    switch (self) {
      case OS.iOS:
        return r'iOS';
      case OS.android:
        return r'android';
    }
  }
}

extension OSMapperExtension on OS {
  String toValue() {
    OSMapper.ensureInitialized();
    return MapperContainer.globals.toValue<OS>(this) as String;
  }
}

class DeviceInfoModelMapper extends ClassMapperBase<DeviceInfoModel> {
  DeviceInfoModelMapper._();

  static DeviceInfoModelMapper? _instance;
  static DeviceInfoModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeviceInfoModelMapper._());
      OSMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeviceInfoModel';

  static String _$deviceModel(DeviceInfoModel v) => v.deviceModel;
  static const Field<DeviceInfoModel, String> _f$deviceModel = Field(
    'deviceModel',
    _$deviceModel,
  );
  static OS _$os(DeviceInfoModel v) => v.os;
  static const Field<DeviceInfoModel, OS> _f$os = Field('os', _$os);
  static int _$osCode(DeviceInfoModel v) => v.osCode;
  static const Field<DeviceInfoModel, int> _f$osCode = Field(
    'osCode',
    _$osCode,
  );
  static String _$osVersion(DeviceInfoModel v) => v.osVersion;
  static const Field<DeviceInfoModel, String> _f$osVersion = Field(
    'osVersion',
    _$osVersion,
  );
  static bool _$isPhysicalDevice(DeviceInfoModel v) => v.isPhysicalDevice;
  static const Field<DeviceInfoModel, bool> _f$isPhysicalDevice = Field(
    'isPhysicalDevice',
    _$isPhysicalDevice,
  );

  @override
  final MappableFields<DeviceInfoModel> fields = const {
    #deviceModel: _f$deviceModel,
    #os: _f$os,
    #osCode: _f$osCode,
    #osVersion: _f$osVersion,
    #isPhysicalDevice: _f$isPhysicalDevice,
  };

  static DeviceInfoModel _instantiate(DecodingData data) {
    return DeviceInfoModel(
      deviceModel: data.dec(_f$deviceModel),
      os: data.dec(_f$os),
      osCode: data.dec(_f$osCode),
      osVersion: data.dec(_f$osVersion),
      isPhysicalDevice: data.dec(_f$isPhysicalDevice),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeviceInfoModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeviceInfoModel>(map);
  }

  static DeviceInfoModel fromJson(String json) {
    return ensureInitialized().decodeJson<DeviceInfoModel>(json);
  }
}

mixin DeviceInfoModelMappable {
  String toJson() {
    return DeviceInfoModelMapper.ensureInitialized()
        .encodeJson<DeviceInfoModel>(this as DeviceInfoModel);
  }

  Map<String, dynamic> toMap() {
    return DeviceInfoModelMapper.ensureInitialized().encodeMap<DeviceInfoModel>(
      this as DeviceInfoModel,
    );
  }

  DeviceInfoModelCopyWith<DeviceInfoModel, DeviceInfoModel, DeviceInfoModel>
  get copyWith =>
      _DeviceInfoModelCopyWithImpl<DeviceInfoModel, DeviceInfoModel>(
        this as DeviceInfoModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DeviceInfoModelMapper.ensureInitialized().stringifyValue(
      this as DeviceInfoModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeviceInfoModelMapper.ensureInitialized().equalsValue(
      this as DeviceInfoModel,
      other,
    );
  }

  @override
  int get hashCode {
    return DeviceInfoModelMapper.ensureInitialized().hashValue(
      this as DeviceInfoModel,
    );
  }
}

extension DeviceInfoModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeviceInfoModel, $Out> {
  DeviceInfoModelCopyWith<$R, DeviceInfoModel, $Out> get $asDeviceInfoModel =>
      $base.as((v, t, t2) => _DeviceInfoModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeviceInfoModelCopyWith<$R, $In extends DeviceInfoModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? deviceModel,
    OS? os,
    int? osCode,
    String? osVersion,
    bool? isPhysicalDevice,
  });
  DeviceInfoModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DeviceInfoModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeviceInfoModel, $Out>
    implements DeviceInfoModelCopyWith<$R, DeviceInfoModel, $Out> {
  _DeviceInfoModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeviceInfoModel> $mapper =
      DeviceInfoModelMapper.ensureInitialized();
  @override
  $R call({
    String? deviceModel,
    OS? os,
    int? osCode,
    String? osVersion,
    bool? isPhysicalDevice,
  }) => $apply(
    FieldCopyWithData({
      if (deviceModel != null) #deviceModel: deviceModel,
      if (os != null) #os: os,
      if (osCode != null) #osCode: osCode,
      if (osVersion != null) #osVersion: osVersion,
      if (isPhysicalDevice != null) #isPhysicalDevice: isPhysicalDevice,
    }),
  );
  @override
  DeviceInfoModel $make(CopyWithData data) => DeviceInfoModel(
    deviceModel: data.get(#deviceModel, or: $value.deviceModel),
    os: data.get(#os, or: $value.os),
    osCode: data.get(#osCode, or: $value.osCode),
    osVersion: data.get(#osVersion, or: $value.osVersion),
    isPhysicalDevice: data.get(#isPhysicalDevice, or: $value.isPhysicalDevice),
  );

  @override
  DeviceInfoModelCopyWith<$R2, DeviceInfoModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DeviceInfoModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

