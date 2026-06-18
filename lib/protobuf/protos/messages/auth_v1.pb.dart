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

class AuthRequest extends $pb.GeneratedMessage {
  factory AuthRequest({
    $core.List<$core.int>? session,
  }) {
    final result = create();
    if (session != null) result.session = session;
    return result;
  }

  AuthRequest._();

  factory AuthRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'session', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthRequest copyWith(void Function(AuthRequest) updates) =>
      super.copyWith((message) => updates(message as AuthRequest))
          as AuthRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthRequest create() => AuthRequest._();
  @$core.override
  AuthRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthRequest>(create);
  static AuthRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get session => $_getN(0);
  @$pb.TagNumber(1)
  set session($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
}

class AuthResponse extends $pb.GeneratedMessage {
  factory AuthResponse({
    $core.List<$core.int>? salt,
    $0.Timestamp? serverAt,
  }) {
    final result = create();
    if (salt != null) result.salt = salt;
    if (serverAt != null) result.serverAt = serverAt;
    return result;
  }

  AuthResponse._();

  factory AuthResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AuthResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AuthResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'salt', $pb.PbFieldType.OY)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'serverAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AuthResponse copyWith(void Function(AuthResponse) updates) =>
      super.copyWith((message) => updates(message as AuthResponse))
          as AuthResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthResponse create() => AuthResponse._();
  @$core.override
  AuthResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AuthResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AuthResponse>(create);
  static AuthResponse? _defaultInstance;

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
