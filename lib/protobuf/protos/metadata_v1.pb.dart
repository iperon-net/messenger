// This is a generated file - do not edit.
//
// Generated from protos/metadata_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class MetadataInfoRequest extends $pb.GeneratedMessage {
  factory MetadataInfoRequest() => create();

  MetadataInfoRequest._();

  factory MetadataInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfoRequest copyWith(void Function(MetadataInfoRequest) updates) =>
      super.copyWith((message) => updates(message as MetadataInfoRequest))
          as MetadataInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfoRequest create() => MetadataInfoRequest._();
  @$core.override
  MetadataInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfoRequest>(create);
  static MetadataInfoRequest? _defaultInstance;
}

class MetadataInfoResponse extends $pb.GeneratedMessage {
  factory MetadataInfoResponse({
    $core.String? publicKey,
  }) {
    final result = create();
    if (publicKey != null) result.publicKey = publicKey;
    return result;
  }

  MetadataInfoResponse._();

  factory MetadataInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'publicKey', protoName: 'publicKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfoResponse copyWith(void Function(MetadataInfoResponse) updates) =>
      super.copyWith((message) => updates(message as MetadataInfoResponse))
          as MetadataInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfoResponse create() => MetadataInfoResponse._();
  @$core.override
  MetadataInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfoResponse>(create);
  static MetadataInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get publicKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set publicKey($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
