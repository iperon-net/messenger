// This is a generated file - do not edit.
//
// Generated from protos/messages/device_sessions_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class DeviceSession extends $pb.GeneratedMessage {
  factory DeviceSession({
    $core.List<$core.int>? session,
    $core.String? deviceModel,
    $core.int? os,
    $core.String? osVersion,
    $core.String? appVersion,
    $core.String? appBuildNumber,
    $0.Timestamp? updateAt,
    $core.String? locationRussian,
    $core.String? locationEnglish,
  }) {
    final result = create();
    if (session != null) result.session = session;
    if (deviceModel != null) result.deviceModel = deviceModel;
    if (os != null) result.os = os;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    if (updateAt != null) result.updateAt = updateAt;
    if (locationRussian != null) result.locationRussian = locationRussian;
    if (locationEnglish != null) result.locationEnglish = locationEnglish;
    return result;
  }

  DeviceSession._();

  factory DeviceSession.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSession.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSession',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'session', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..aI(3, _omitFieldNames ? '' : 'os')
    ..aOS(4, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(5, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(6, _omitFieldNames ? '' : 'appBuildNumber',
        protoName: 'appBuildNumber')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'updateAt',
        protoName: 'updateAt', subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'locationRussian',
        protoName: 'locationRussian')
    ..aOS(9, _omitFieldNames ? '' : 'locationEnglish',
        protoName: 'locationEnglish')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSession clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSession copyWith(void Function(DeviceSession) updates) =>
      super.copyWith((message) => updates(message as DeviceSession))
          as DeviceSession;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSession create() => DeviceSession._();
  @$core.override
  DeviceSession createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSession getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSession>(create);
  static DeviceSession? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get session => $_getN(0);
  @$pb.TagNumber(1)
  set session($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceModel => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceModel($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceModel() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceModel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get os => $_getIZ(2);
  @$pb.TagNumber(3)
  set os($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOs() => $_has(2);
  @$pb.TagNumber(3)
  void clearOs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get osVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set osVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOsVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearOsVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get appVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set appVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAppVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearAppVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get appBuildNumber => $_getSZ(5);
  @$pb.TagNumber(6)
  set appBuildNumber($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAppBuildNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppBuildNumber() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get updateAt => $_getN(6);
  @$pb.TagNumber(7)
  set updateAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdateAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdateAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureUpdateAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get locationRussian => $_getSZ(7);
  @$pb.TagNumber(8)
  set locationRussian($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLocationRussian() => $_has(7);
  @$pb.TagNumber(8)
  void clearLocationRussian() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get locationEnglish => $_getSZ(8);
  @$pb.TagNumber(9)
  set locationEnglish($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLocationEnglish() => $_has(8);
  @$pb.TagNumber(9)
  void clearLocationEnglish() => $_clearField(9);
}

class DeviceSessionsRequest extends $pb.GeneratedMessage {
  factory DeviceSessionsRequest() => create();

  DeviceSessionsRequest._();

  factory DeviceSessionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsRequest copyWith(
          void Function(DeviceSessionsRequest) updates) =>
      super.copyWith((message) => updates(message as DeviceSessionsRequest))
          as DeviceSessionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessionsRequest create() => DeviceSessionsRequest._();
  @$core.override
  DeviceSessionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessionsRequest>(create);
  static DeviceSessionsRequest? _defaultInstance;
}

class DeviceSessionsResponse extends $pb.GeneratedMessage {
  factory DeviceSessionsResponse({
    $core.Iterable<DeviceSession>? deviceSessions,
  }) {
    final result = create();
    if (deviceSessions != null) result.deviceSessions.addAll(deviceSessions);
    return result;
  }

  DeviceSessionsResponse._();

  factory DeviceSessionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..pPM<DeviceSession>(1, _omitFieldNames ? '' : 'deviceSessions',
        protoName: 'deviceSessions', subBuilder: DeviceSession.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsResponse copyWith(
          void Function(DeviceSessionsResponse) updates) =>
      super.copyWith((message) => updates(message as DeviceSessionsResponse))
          as DeviceSessionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessionsResponse create() => DeviceSessionsResponse._();
  @$core.override
  DeviceSessionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessionsResponse>(create);
  static DeviceSessionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DeviceSession> get deviceSessions => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
