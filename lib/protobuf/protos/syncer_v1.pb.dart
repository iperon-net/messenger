// This is a generated file - do not edit.
//
// Generated from protos/syncer_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Messages
class SyncerMessageRequest extends $pb.GeneratedMessage {
  factory SyncerMessageRequest({
    $core.List<$core.int>? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  SyncerMessageRequest._();

  factory SyncerMessageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncerMessageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncerMessageRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'message', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncerMessageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncerMessageRequest copyWith(void Function(SyncerMessageRequest) updates) =>
      super.copyWith((message) => updates(message as SyncerMessageRequest))
          as SyncerMessageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncerMessageRequest create() => SyncerMessageRequest._();
  @$core.override
  SyncerMessageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncerMessageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncerMessageRequest>(create);
  static SyncerMessageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get message => $_getN(0);
  @$pb.TagNumber(1)
  set message($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

class SyncerMessageResponse extends $pb.GeneratedMessage {
  factory SyncerMessageResponse({
    $core.List<$core.int>? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  SyncerMessageResponse._();

  factory SyncerMessageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncerMessageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncerMessageResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'message', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncerMessageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncerMessageResponse copyWith(
          void Function(SyncerMessageResponse) updates) =>
      super.copyWith((message) => updates(message as SyncerMessageResponse))
          as SyncerMessageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncerMessageResponse create() => SyncerMessageResponse._();
  @$core.override
  SyncerMessageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncerMessageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncerMessageResponse>(create);
  static SyncerMessageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get message => $_getN(0);
  @$pb.TagNumber(1)
  set message($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
