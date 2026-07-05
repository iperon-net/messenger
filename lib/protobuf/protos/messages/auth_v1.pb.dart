// This is a generated file - do not edit.
//
// Generated from protos/messages/auth_v1.proto.

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

class Auth extends $pb.GeneratedMessage {
  factory Auth({
    $core.List<$core.int>? session,
    $core.String? osVersion,
    $core.String? appVersion,
    $core.String? appBuildNumber,
  }) {
    final result = create();
    if (session != null) result.session = session;
    if (osVersion != null) result.osVersion = osVersion;
    if (appVersion != null) result.appVersion = appVersion;
    if (appBuildNumber != null) result.appBuildNumber = appBuildNumber;
    return result;
  }

  Auth._();

  factory Auth.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Auth.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Auth',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1.messages'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'session', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'osVersion', protoName: 'osVersion')
    ..aOS(3, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(4, _omitFieldNames ? '' : 'appBuildNumber',
        protoName: 'appBuildNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Auth clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Auth copyWith(void Function(Auth) updates) =>
      super.copyWith((message) => updates(message as Auth)) as Auth;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Auth create() => Auth._();
  @$core.override
  Auth createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Auth getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Auth>(create);
  static Auth? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get session => $_getN(0);
  @$pb.TagNumber(1)
  set session($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);

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
}

class AuthResult extends $pb.GeneratedMessage {
  factory AuthResult({
    $core.List<$core.int>? salt,
    $0.Timestamp? serverAt,
  }) {
    final result = create();
    if (salt != null) result.salt = salt;
    if (serverAt != null) result.serverAt = serverAt;
    return result;
  }

  AuthResult._();

  factory AuthResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1.messages'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'salt', $pb.PbFieldType.OY)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'serverAt',
        protoName: 'serverAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthResult copyWith(void Function(AuthResult) updates) =>
      super.copyWith((message) => updates(message as AuthResult)) as AuthResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthResult create() => AuthResult._();
  @$core.override
  AuthResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthResult>(create);
  static AuthResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get salt => $_getN(0);
  @$pb.TagNumber(1)
  set salt($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSalt() => $_has(0);
  @$pb.TagNumber(1)
  void clearSalt() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get serverAt => $_getN(1);
  @$pb.TagNumber(2)
  set serverAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasServerAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearServerAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureServerAt() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
