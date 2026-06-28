// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'device_sessions.dart';

class DeviceSessionMapper extends ClassMapperBase<DeviceSession> {
  DeviceSessionMapper._();

  static DeviceSessionMapper? _instance;
  static DeviceSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeviceSessionMapper._());
      MapperContainer.globals.useAll([BoolMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'DeviceSession';

  static String _$deviceModel(DeviceSession v) => v.deviceModel;
  static const Field<DeviceSession, String> _f$deviceModel = Field(
    'deviceModel',
    _$deviceModel,
    opt: true,
    def: "",
  );
  static String _$osVersion(DeviceSession v) => v.osVersion;
  static const Field<DeviceSession, String> _f$osVersion = Field(
    'osVersion',
    _$osVersion,
    opt: true,
    def: "",
  );
  static String _$appVersion(DeviceSession v) => v.appVersion;
  static const Field<DeviceSession, String> _f$appVersion = Field(
    'appVersion',
    _$appVersion,
    opt: true,
    def: "",
  );
  static String _$appBuildNumber(DeviceSession v) => v.appBuildNumber;
  static const Field<DeviceSession, String> _f$appBuildNumber = Field(
    'appBuildNumber',
    _$appBuildNumber,
    opt: true,
    def: "",
  );
  static String _$locationRussian(DeviceSession v) => v.locationRussian;
  static const Field<DeviceSession, String> _f$locationRussian = Field(
    'locationRussian',
    _$locationRussian,
    opt: true,
    def: "",
  );
  static String _$locationEnglish(DeviceSession v) => v.locationEnglish;
  static const Field<DeviceSession, String> _f$locationEnglish = Field(
    'locationEnglish',
    _$locationEnglish,
    opt: true,
    def: "",
  );
  static DateTime _$updateAt(DeviceSession v) => v.updateAt;
  static const Field<DeviceSession, DateTime> _f$updateAt = Field(
    'updateAt',
    _$updateAt,
    opt: true,
  );

  @override
  final MappableFields<DeviceSession> fields = const {
    #deviceModel: _f$deviceModel,
    #osVersion: _f$osVersion,
    #appVersion: _f$appVersion,
    #appBuildNumber: _f$appBuildNumber,
    #locationRussian: _f$locationRussian,
    #locationEnglish: _f$locationEnglish,
    #updateAt: _f$updateAt,
  };

  static DeviceSession _instantiate(DecodingData data) {
    return DeviceSession(
      deviceModel: data.dec(_f$deviceModel),
      osVersion: data.dec(_f$osVersion),
      appVersion: data.dec(_f$appVersion),
      appBuildNumber: data.dec(_f$appBuildNumber),
      locationRussian: data.dec(_f$locationRussian),
      locationEnglish: data.dec(_f$locationEnglish),
      updateAt: data.dec(_f$updateAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeviceSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeviceSession>(map);
  }

  static DeviceSession fromJson(String json) {
    return ensureInitialized().decodeJson<DeviceSession>(json);
  }
}

mixin DeviceSessionMappable {
  String toJson() {
    return DeviceSessionMapper.ensureInitialized().encodeJson<DeviceSession>(
      this as DeviceSession,
    );
  }

  Map<String, dynamic> toMap() {
    return DeviceSessionMapper.ensureInitialized().encodeMap<DeviceSession>(
      this as DeviceSession,
    );
  }

  DeviceSessionCopyWith<DeviceSession, DeviceSession, DeviceSession>
  get copyWith => _DeviceSessionCopyWithImpl<DeviceSession, DeviceSession>(
    this as DeviceSession,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return DeviceSessionMapper.ensureInitialized().stringifyValue(
      this as DeviceSession,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeviceSessionMapper.ensureInitialized().equalsValue(
      this as DeviceSession,
      other,
    );
  }

  @override
  int get hashCode {
    return DeviceSessionMapper.ensureInitialized().hashValue(
      this as DeviceSession,
    );
  }
}

extension DeviceSessionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeviceSession, $Out> {
  DeviceSessionCopyWith<$R, DeviceSession, $Out> get $asDeviceSession =>
      $base.as((v, t, t2) => _DeviceSessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeviceSessionCopyWith<$R, $In extends DeviceSession, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? deviceModel,
    String? osVersion,
    String? appVersion,
    String? appBuildNumber,
    String? locationRussian,
    String? locationEnglish,
    DateTime? updateAt,
  });
  DeviceSessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeviceSessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeviceSession, $Out>
    implements DeviceSessionCopyWith<$R, DeviceSession, $Out> {
  _DeviceSessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeviceSession> $mapper =
      DeviceSessionMapper.ensureInitialized();
  @override
  $R call({
    String? deviceModel,
    String? osVersion,
    String? appVersion,
    String? appBuildNumber,
    String? locationRussian,
    String? locationEnglish,
    Object? updateAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (deviceModel != null) #deviceModel: deviceModel,
      if (osVersion != null) #osVersion: osVersion,
      if (appVersion != null) #appVersion: appVersion,
      if (appBuildNumber != null) #appBuildNumber: appBuildNumber,
      if (locationRussian != null) #locationRussian: locationRussian,
      if (locationEnglish != null) #locationEnglish: locationEnglish,
      if (updateAt != $none) #updateAt: updateAt,
    }),
  );
  @override
  DeviceSession $make(CopyWithData data) => DeviceSession(
    deviceModel: data.get(#deviceModel, or: $value.deviceModel),
    osVersion: data.get(#osVersion, or: $value.osVersion),
    appVersion: data.get(#appVersion, or: $value.appVersion),
    appBuildNumber: data.get(#appBuildNumber, or: $value.appBuildNumber),
    locationRussian: data.get(#locationRussian, or: $value.locationRussian),
    locationEnglish: data.get(#locationEnglish, or: $value.locationEnglish),
    updateAt: data.get(#updateAt, or: $value.updateAt),
  );

  @override
  DeviceSessionCopyWith<$R2, DeviceSession, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DeviceSessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

