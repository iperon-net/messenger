// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'device_sessions.dart';

class DeviceSessionsModelMapper extends ClassMapperBase<DeviceSessionsModel> {
  DeviceSessionsModelMapper._();

  static DeviceSessionsModelMapper? _instance;
  static DeviceSessionsModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeviceSessionsModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DeviceSessionsModel';

  static Uint8List _$sessionID(DeviceSessionsModel v) => v.sessionID;
  static const Field<DeviceSessionsModel, Uint8List> _f$sessionID = Field(
    'sessionID',
    _$sessionID,
  );
  static bool _$isCurrent(DeviceSessionsModel v) => v.isCurrent;
  static const Field<DeviceSessionsModel, bool> _f$isCurrent = Field(
    'isCurrent',
    _$isCurrent,
    opt: true,
    def: false,
  );
  static DateTime _$updateAt(DeviceSessionsModel v) => v.updateAt;
  static const Field<DeviceSessionsModel, DateTime> _f$updateAt = Field(
    'updateAt',
    _$updateAt,
    opt: true,
  );
  static String _$deviceModel(DeviceSessionsModel v) => v.deviceModel;
  static const Field<DeviceSessionsModel, String> _f$deviceModel = Field(
    'deviceModel',
    _$deviceModel,
    opt: true,
    def: '',
  );
  static int _$os(DeviceSessionsModel v) => v.os;
  static const Field<DeviceSessionsModel, int> _f$os = Field(
    'os',
    _$os,
    opt: true,
    def: 0,
  );
  static String _$osVersion(DeviceSessionsModel v) => v.osVersion;
  static const Field<DeviceSessionsModel, String> _f$osVersion = Field(
    'osVersion',
    _$osVersion,
    opt: true,
    def: '',
  );
  static String _$appVersion(DeviceSessionsModel v) => v.appVersion;
  static const Field<DeviceSessionsModel, String> _f$appVersion = Field(
    'appVersion',
    _$appVersion,
    opt: true,
    def: '',
  );
  static String _$appBuildNumber(DeviceSessionsModel v) => v.appBuildNumber;
  static const Field<DeviceSessionsModel, String> _f$appBuildNumber = Field(
    'appBuildNumber',
    _$appBuildNumber,
    opt: true,
    def: '',
  );
  static String _$locationEnglish(DeviceSessionsModel v) => v.locationEnglish;
  static const Field<DeviceSessionsModel, String> _f$locationEnglish = Field(
    'locationEnglish',
    _$locationEnglish,
    opt: true,
    def: '',
  );
  static String _$locationRussian(DeviceSessionsModel v) => v.locationRussian;
  static const Field<DeviceSessionsModel, String> _f$locationRussian = Field(
    'locationRussian',
    _$locationRussian,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<DeviceSessionsModel> fields = const {
    #sessionID: _f$sessionID,
    #isCurrent: _f$isCurrent,
    #updateAt: _f$updateAt,
    #deviceModel: _f$deviceModel,
    #os: _f$os,
    #osVersion: _f$osVersion,
    #appVersion: _f$appVersion,
    #appBuildNumber: _f$appBuildNumber,
    #locationEnglish: _f$locationEnglish,
    #locationRussian: _f$locationRussian,
  };

  static DeviceSessionsModel _instantiate(DecodingData data) {
    return DeviceSessionsModel(
      sessionID: data.dec(_f$sessionID),
      isCurrent: data.dec(_f$isCurrent),
      updateAt: data.dec(_f$updateAt),
      deviceModel: data.dec(_f$deviceModel),
      os: data.dec(_f$os),
      osVersion: data.dec(_f$osVersion),
      appVersion: data.dec(_f$appVersion),
      appBuildNumber: data.dec(_f$appBuildNumber),
      locationEnglish: data.dec(_f$locationEnglish),
      locationRussian: data.dec(_f$locationRussian),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeviceSessionsModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeviceSessionsModel>(map);
  }

  static DeviceSessionsModel fromJson(String json) {
    return ensureInitialized().decodeJson<DeviceSessionsModel>(json);
  }
}

mixin DeviceSessionsModelMappable {
  String toJson() {
    return DeviceSessionsModelMapper.ensureInitialized()
        .encodeJson<DeviceSessionsModel>(this as DeviceSessionsModel);
  }

  Map<String, dynamic> toMap() {
    return DeviceSessionsModelMapper.ensureInitialized()
        .encodeMap<DeviceSessionsModel>(this as DeviceSessionsModel);
  }

  DeviceSessionsModelCopyWith<
    DeviceSessionsModel,
    DeviceSessionsModel,
    DeviceSessionsModel
  >
  get copyWith =>
      _DeviceSessionsModelCopyWithImpl<
        DeviceSessionsModel,
        DeviceSessionsModel
      >(this as DeviceSessionsModel, $identity, $identity);
  @override
  String toString() {
    return DeviceSessionsModelMapper.ensureInitialized().stringifyValue(
      this as DeviceSessionsModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeviceSessionsModelMapper.ensureInitialized().equalsValue(
      this as DeviceSessionsModel,
      other,
    );
  }

  @override
  int get hashCode {
    return DeviceSessionsModelMapper.ensureInitialized().hashValue(
      this as DeviceSessionsModel,
    );
  }
}

extension DeviceSessionsModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeviceSessionsModel, $Out> {
  DeviceSessionsModelCopyWith<$R, DeviceSessionsModel, $Out>
  get $asDeviceSessionsModel => $base.as(
    (v, t, t2) => _DeviceSessionsModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DeviceSessionsModelCopyWith<
  $R,
  $In extends DeviceSessionsModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    Uint8List? sessionID,
    bool? isCurrent,
    DateTime? updateAt,
    String? deviceModel,
    int? os,
    String? osVersion,
    String? appVersion,
    String? appBuildNumber,
    String? locationEnglish,
    String? locationRussian,
  });
  DeviceSessionsModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DeviceSessionsModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeviceSessionsModel, $Out>
    implements DeviceSessionsModelCopyWith<$R, DeviceSessionsModel, $Out> {
  _DeviceSessionsModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeviceSessionsModel> $mapper =
      DeviceSessionsModelMapper.ensureInitialized();
  @override
  $R call({
    Uint8List? sessionID,
    bool? isCurrent,
    Object? updateAt = $none,
    String? deviceModel,
    int? os,
    String? osVersion,
    String? appVersion,
    String? appBuildNumber,
    String? locationEnglish,
    String? locationRussian,
  }) => $apply(
    FieldCopyWithData({
      if (sessionID != null) #sessionID: sessionID,
      if (isCurrent != null) #isCurrent: isCurrent,
      if (updateAt != $none) #updateAt: updateAt,
      if (deviceModel != null) #deviceModel: deviceModel,
      if (os != null) #os: os,
      if (osVersion != null) #osVersion: osVersion,
      if (appVersion != null) #appVersion: appVersion,
      if (appBuildNumber != null) #appBuildNumber: appBuildNumber,
      if (locationEnglish != null) #locationEnglish: locationEnglish,
      if (locationRussian != null) #locationRussian: locationRussian,
    }),
  );
  @override
  DeviceSessionsModel $make(CopyWithData data) => DeviceSessionsModel(
    sessionID: data.get(#sessionID, or: $value.sessionID),
    isCurrent: data.get(#isCurrent, or: $value.isCurrent),
    updateAt: data.get(#updateAt, or: $value.updateAt),
    deviceModel: data.get(#deviceModel, or: $value.deviceModel),
    os: data.get(#os, or: $value.os),
    osVersion: data.get(#osVersion, or: $value.osVersion),
    appVersion: data.get(#appVersion, or: $value.appVersion),
    appBuildNumber: data.get(#appBuildNumber, or: $value.appBuildNumber),
    locationEnglish: data.get(#locationEnglish, or: $value.locationEnglish),
    locationRussian: data.get(#locationRussian, or: $value.locationRussian),
  );

  @override
  DeviceSessionsModelCopyWith<$R2, DeviceSessionsModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DeviceSessionsModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

