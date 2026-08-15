// This is a generated file - do not edit.
//
// Generated from protos/device_sessions_v1.proto.

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

class DeviceSessions_DeviceSession extends $pb.GeneratedMessage {
  factory DeviceSessions_DeviceSession({
    $core.List<$core.int>? sessionID,
    $0.Timestamp? updateAt,
    $core.String? deviceModel,
    $core.int? os,
    $core.String? osVersion,
    $core.String? appVersion,
    $core.String? appBuildNumber,
    $core.String? locationEnglish,
    $core.String? locationRussian,
  }) {
    final result = create();
    if (sessionID != null) result.sessionID = sessionID;
    if (updateAt != null) result.updateAt = updateAt;
    if (deviceModel != null) result.deviceModel = deviceModel;
    if (os != null) result.os = os;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    if (locationEnglish != null) result.locationEnglish = locationEnglish;
    if (locationRussian != null) result.locationRussian = locationRussian;
    return result;
  }

  DeviceSessions_DeviceSession._();

  factory DeviceSessions_DeviceSession.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessions_DeviceSession.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessions.DeviceSession',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'sessionID', $pb.PbFieldType.OY,
        protoName: 'sessionID')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'updateAt',
        protoName: 'updateAt', subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..aI(4, _omitFieldNames ? '' : 'os')
    ..aOS(5, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(6, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(7, _omitFieldNames ? '' : 'appBuildNumber',
        protoName: 'appBuildNumber')
    ..aOS(8, _omitFieldNames ? '' : 'LocationEnglish',
        protoName: 'LocationEnglish')
    ..aOS(9, _omitFieldNames ? '' : 'LocationRussian',
        protoName: 'LocationRussian')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessions_DeviceSession clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessions_DeviceSession copyWith(
          void Function(DeviceSessions_DeviceSession) updates) =>
      super.copyWith(
              (message) => updates(message as DeviceSessions_DeviceSession))
          as DeviceSessions_DeviceSession;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessions_DeviceSession create() =>
      DeviceSessions_DeviceSession._();
  @$core.override
  DeviceSessions_DeviceSession createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessions_DeviceSession getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessions_DeviceSession>(create);
  static DeviceSessions_DeviceSession? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get sessionID => $_getN(0);
  @$pb.TagNumber(1)
  set sessionID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionID() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get updateAt => $_getN(1);
  @$pb.TagNumber(2)
  set updateAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdateAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureUpdateAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get deviceModel => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceModel($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceModel() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceModel() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get os => $_getIZ(3);
  @$pb.TagNumber(4)
  set os($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOs() => $_has(3);
  @$pb.TagNumber(4)
  void clearOs() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get osVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set osVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOsVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearOsVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get appVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set appVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAppVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get appBuildNumber => $_getSZ(6);
  @$pb.TagNumber(7)
  set appBuildNumber($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAppBuildNumber() => $_has(6);
  @$pb.TagNumber(7)
  void clearAppBuildNumber() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get locationEnglish => $_getSZ(7);
  @$pb.TagNumber(8)
  set locationEnglish($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLocationEnglish() => $_has(7);
  @$pb.TagNumber(8)
  void clearLocationEnglish() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get locationRussian => $_getSZ(8);
  @$pb.TagNumber(9)
  set locationRussian($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLocationRussian() => $_has(8);
  @$pb.TagNumber(9)
  void clearLocationRussian() => $_clearField(9);
}

class DeviceSessions_Request extends $pb.GeneratedMessage {
  factory DeviceSessions_Request() => create();

  DeviceSessions_Request._();

  factory DeviceSessions_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessions_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessions.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessions_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessions_Request copyWith(
          void Function(DeviceSessions_Request) updates) =>
      super.copyWith((message) => updates(message as DeviceSessions_Request))
          as DeviceSessions_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessions_Request create() => DeviceSessions_Request._();
  @$core.override
  DeviceSessions_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessions_Request getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessions_Request>(create);
  static DeviceSessions_Request? _defaultInstance;
}

class DeviceSessions_Response extends $pb.GeneratedMessage {
  factory DeviceSessions_Response({
    $core.Iterable<DeviceSessions_DeviceSession>? results,
  }) {
    final result = create();
    if (results != null) result.results.addAll(results);
    return result;
  }

  DeviceSessions_Response._();

  factory DeviceSessions_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessions_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessions.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..pPM<DeviceSessions_DeviceSession>(1, _omitFieldNames ? '' : 'results',
        subBuilder: DeviceSessions_DeviceSession.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessions_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessions_Response copyWith(
          void Function(DeviceSessions_Response) updates) =>
      super.copyWith((message) => updates(message as DeviceSessions_Response))
          as DeviceSessions_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessions_Response create() => DeviceSessions_Response._();
  @$core.override
  DeviceSessions_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessions_Response getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessions_Response>(create);
  static DeviceSessions_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DeviceSessions_DeviceSession> get results => $_getList(0);
}

class DeviceSessions extends $pb.GeneratedMessage {
  factory DeviceSessions() => create();

  DeviceSessions._();

  factory DeviceSessions.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessions.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessions copyWith(void Function(DeviceSessions) updates) =>
      super.copyWith((message) => updates(message as DeviceSessions))
          as DeviceSessions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessions create() => DeviceSessions._();
  @$core.override
  DeviceSessions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessions getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessions>(create);
  static DeviceSessions? _defaultInstance;
}

class DeviceSessionsTerminate_Request extends $pb.GeneratedMessage {
  factory DeviceSessionsTerminate_Request({
    $core.Iterable<$core.List<$core.int>>? sessionID,
  }) {
    final result = create();
    if (sessionID != null) result.sessionID.addAll(sessionID);
    return result;
  }

  DeviceSessionsTerminate_Request._();

  factory DeviceSessionsTerminate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessionsTerminate_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessionsTerminate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..p<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'sessionID', $pb.PbFieldType.PY,
        protoName: 'sessionID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsTerminate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsTerminate_Request copyWith(
          void Function(DeviceSessionsTerminate_Request) updates) =>
      super.copyWith(
              (message) => updates(message as DeviceSessionsTerminate_Request))
          as DeviceSessionsTerminate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessionsTerminate_Request create() =>
      DeviceSessionsTerminate_Request._();
  @$core.override
  DeviceSessionsTerminate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessionsTerminate_Request getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessionsTerminate_Request>(
          create);
  static DeviceSessionsTerminate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get sessionID => $_getList(0);
}

class DeviceSessionsTerminate_Response extends $pb.GeneratedMessage {
  factory DeviceSessionsTerminate_Response() => create();

  DeviceSessionsTerminate_Response._();

  factory DeviceSessionsTerminate_Response.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessionsTerminate_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessionsTerminate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsTerminate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsTerminate_Response copyWith(
          void Function(DeviceSessionsTerminate_Response) updates) =>
      super.copyWith(
              (message) => updates(message as DeviceSessionsTerminate_Response))
          as DeviceSessionsTerminate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessionsTerminate_Response create() =>
      DeviceSessionsTerminate_Response._();
  @$core.override
  DeviceSessionsTerminate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessionsTerminate_Response getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessionsTerminate_Response>(
          create);
  static DeviceSessionsTerminate_Response? _defaultInstance;
}

/// Device sessions terminate
class DeviceSessionsTerminate extends $pb.GeneratedMessage {
  factory DeviceSessionsTerminate() => create();

  DeviceSessionsTerminate._();

  factory DeviceSessionsTerminate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceSessionsTerminate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceSessionsTerminate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsTerminate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceSessionsTerminate copyWith(
          void Function(DeviceSessionsTerminate) updates) =>
      super.copyWith((message) => updates(message as DeviceSessionsTerminate))
          as DeviceSessionsTerminate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceSessionsTerminate create() => DeviceSessionsTerminate._();
  @$core.override
  DeviceSessionsTerminate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceSessionsTerminate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceSessionsTerminate>(create);
  static DeviceSessionsTerminate? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
