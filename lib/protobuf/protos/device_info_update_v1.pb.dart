// This is a generated file - do not edit.
//
// Generated from protos/device_info_update_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class DeviceInfoUpdate_Request extends $pb.GeneratedMessage {
  factory DeviceInfoUpdate_Request({
    $core.String? deviceModel,
    $core.int? os,
    $core.String? osVersion,
    $core.String? appVersion,
    $core.String? appBuildNumber,
  }) {
    final result = create();
    if (deviceModel != null) result.deviceModel = deviceModel;
    if (os != null) result.os = os;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    return result;
  }

  DeviceInfoUpdate_Request._();

  factory DeviceInfoUpdate_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceInfoUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceInfoUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..aI(2, _omitFieldNames ? '' : 'os')
    ..aOS(3, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(4, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(5, _omitFieldNames ? '' : 'appBuildNumber', protoName: 'appBuildNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfoUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfoUpdate_Request copyWith(void Function(DeviceInfoUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as DeviceInfoUpdate_Request)) as DeviceInfoUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfoUpdate_Request create() => DeviceInfoUpdate_Request._();
  @$core.override
  DeviceInfoUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceInfoUpdate_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceInfoUpdate_Request>(create);
  static DeviceInfoUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceModel => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceModel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceModel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get os => $_getIZ(1);
  @$pb.TagNumber(2)
  set os($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOs() => $_has(1);
  @$pb.TagNumber(2)
  void clearOs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get osVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set osVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOsVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearOsVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get appVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set appVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAppVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get appBuildNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set appBuildNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAppBuildNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearAppBuildNumber() => $_clearField(5);
}

class DeviceInfoUpdate_Response extends $pb.GeneratedMessage {
  factory DeviceInfoUpdate_Response() => create();

  DeviceInfoUpdate_Response._();

  factory DeviceInfoUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceInfoUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceInfoUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfoUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfoUpdate_Response copyWith(void Function(DeviceInfoUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as DeviceInfoUpdate_Response)) as DeviceInfoUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfoUpdate_Response create() => DeviceInfoUpdate_Response._();
  @$core.override
  DeviceInfoUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceInfoUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceInfoUpdate_Response>(create);
  static DeviceInfoUpdate_Response? _defaultInstance;
}

class DeviceInfoUpdate extends $pb.GeneratedMessage {
  factory DeviceInfoUpdate() => create();

  DeviceInfoUpdate._();

  factory DeviceInfoUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceInfoUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceInfoUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfoUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfoUpdate copyWith(void Function(DeviceInfoUpdate) updates) =>
      super.copyWith((message) => updates(message as DeviceInfoUpdate)) as DeviceInfoUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfoUpdate create() => DeviceInfoUpdate._();
  @$core.override
  DeviceInfoUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceInfoUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceInfoUpdate>(create);
  static DeviceInfoUpdate? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
