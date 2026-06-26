// This is a generated file - do not edit.
//
// Generated from protos/messages/sessions_v1.proto.

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

class Session extends $pb.GeneratedMessage {
  factory Session({
    $core.String? deviceModel,
    $core.String? osVersion,
    $core.String? appVersion,
    $core.String? appBuildNumber,
    $core.String? locationRussian,
    $core.String? locationEnglish,
    $0.Timestamp? updateAt,
  }) {
    final result = create();
    if (deviceModel != null) result.deviceModel = deviceModel;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    if (locationRussian != null) result.locationRussian = locationRussian;
    if (locationEnglish != null) result.locationEnglish = locationEnglish;
    if (updateAt != null) result.updateAt = updateAt;
    return result;
  }

  Session._();

  factory Session.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Session.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Session',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceModel', protoName: 'deviceModel')
    ..aOS(2, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(3, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(4, _omitFieldNames ? '' : 'appBuildNumber',
        protoName: 'appBuildNumber')
    ..aOS(5, _omitFieldNames ? '' : 'locationRussian',
        protoName: 'locationRussian')
    ..aOS(6, _omitFieldNames ? '' : 'locationEnglish',
        protoName: 'locationEnglish')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'updateAt',
        protoName: 'updateAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Session copyWith(void Function(Session) updates) =>
      super.copyWith((message) => updates(message as Session)) as Session;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Session create() => Session._();
  @$core.override
  Session createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Session getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Session>(create);
  static Session? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceModel => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceModel($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceModel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get osVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set osVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOsVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearOsVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get appVersion => $_getSZ(2);
  @$pb.TagNumber(3)
  set appVersion($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAppVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearAppVersion() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get appBuildNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set appBuildNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAppBuildNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppBuildNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get locationRussian => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationRussian($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationRussian() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationRussian() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get locationEnglish => $_getSZ(5);
  @$pb.TagNumber(6)
  set locationEnglish($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationEnglish() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationEnglish() => $_clearField(6);

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
}

class SessionsRequest extends $pb.GeneratedMessage {
  factory SessionsRequest() => create();

  SessionsRequest._();

  factory SessionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionsRequest copyWith(void Function(SessionsRequest) updates) =>
      super.copyWith((message) => updates(message as SessionsRequest))
          as SessionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionsRequest create() => SessionsRequest._();
  @$core.override
  SessionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionsRequest>(create);
  static SessionsRequest? _defaultInstance;
}

class SessionsResponse extends $pb.GeneratedMessage {
  factory SessionsResponse({
    $core.Iterable<Session>? sessions,
  }) {
    final result = create();
    if (sessions != null) result.sessions.addAll(sessions);
    return result;
  }

  SessionsResponse._();

  factory SessionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..pPM<Session>(1, _omitFieldNames ? '' : 'sessions',
        subBuilder: Session.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionsResponse copyWith(void Function(SessionsResponse) updates) =>
      super.copyWith((message) => updates(message as SessionsResponse))
          as SessionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionsResponse create() => SessionsResponse._();
  @$core.override
  SessionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionsResponse>(create);
  static SessionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Session> get sessions => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
