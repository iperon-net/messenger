// This is a generated file - do not edit.
//
// Generated from protos/logout_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Logout_Request extends $pb.GeneratedMessage {
  factory Logout_Request({
    $core.Iterable<$core.List<$core.int>>? sessionID,
  }) {
    final result = create();
    if (sessionID != null) result.sessionID.addAll(sessionID);
    return result;
  }

  Logout_Request._();

  factory Logout_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Logout_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Logout.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'sessionID', $pb.PbFieldType.PY, protoName: 'sessionID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Logout_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Logout_Request copyWith(void Function(Logout_Request) updates) =>
      super.copyWith((message) => updates(message as Logout_Request)) as Logout_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Logout_Request create() => Logout_Request._();
  @$core.override
  Logout_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Logout_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Logout_Request>(create);
  static Logout_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get sessionID => $_getList(0);
}

class Logout_Response extends $pb.GeneratedMessage {
  factory Logout_Response() => create();

  Logout_Response._();

  factory Logout_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Logout_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Logout.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Logout_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Logout_Response copyWith(void Function(Logout_Response) updates) =>
      super.copyWith((message) => updates(message as Logout_Response)) as Logout_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Logout_Response create() => Logout_Response._();
  @$core.override
  Logout_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Logout_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Logout_Response>(create);
  static Logout_Response? _defaultInstance;
}

class Logout extends $pb.GeneratedMessage {
  factory Logout() => create();

  Logout._();

  factory Logout.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Logout.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Logout',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Logout clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Logout copyWith(void Function(Logout) updates) => super.copyWith((message) => updates(message as Logout)) as Logout;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Logout create() => Logout._();
  @$core.override
  Logout createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Logout getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Logout>(create);
  static Logout? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
