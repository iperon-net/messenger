// This is a generated file - do not edit.
//
// Generated from protos/upload_confirm_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'models.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class UploadConfirm_Request extends $pb.GeneratedMessage {
  factory UploadConfirm_Request({
    $core.String? uploadId,
    $core.List<$core.int>? encryptionKey,
    $core.List<$core.int>? hkdfSalt,
    $core.String? contentType,
    $core.String? folder,
  }) {
    final result = create();
    if (uploadId != null) result.uploadId = uploadId;
    if (encryptionKey != null) result.encryptionKey = encryptionKey;
    if (hkdfSalt != null) result.hkdfSalt = hkdfSalt;
    if (contentType != null) result.contentType = contentType;
    if (folder != null) result.folder = folder;
    return result;
  }

  UploadConfirm_Request._();

  factory UploadConfirm_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadConfirm_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadConfirm.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadId', protoName: 'uploadId')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'encryptionKey', $pb.PbFieldType.OY, protoName: 'encryptionKey')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'hkdfSalt', $pb.PbFieldType.OY, protoName: 'hkdfSalt')
    ..aOS(5, _omitFieldNames ? '' : 'contentType', protoName: 'contentType')
    ..aOS(6, _omitFieldNames ? '' : 'folder')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadConfirm_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadConfirm_Request copyWith(void Function(UploadConfirm_Request) updates) =>
      super.copyWith((message) => updates(message as UploadConfirm_Request)) as UploadConfirm_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadConfirm_Request create() => UploadConfirm_Request._();
  @$core.override
  UploadConfirm_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadConfirm_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadConfirm_Request>(create);
  static UploadConfirm_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUploadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get encryptionKey => $_getN(1);
  @$pb.TagNumber(2)
  set encryptionKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncryptionKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncryptionKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get hkdfSalt => $_getN(2);
  @$pb.TagNumber(3)
  set hkdfSalt($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHkdfSalt() => $_has(2);
  @$pb.TagNumber(3)
  void clearHkdfSalt() => $_clearField(3);

  @$pb.TagNumber(5)
  $core.String get contentType => $_getSZ(3);
  @$pb.TagNumber(5)
  set contentType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(5)
  void clearContentType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get folder => $_getSZ(4);
  @$pb.TagNumber(6)
  set folder($core.String value) => $_setString(4, value);
  @$pb.TagNumber(6)
  $core.bool hasFolder() => $_has(4);
  @$pb.TagNumber(6)
  void clearFolder() => $_clearField(6);
}

class UploadConfirm_Response extends $pb.GeneratedMessage {
  factory UploadConfirm_Response({
    $0.CDN? cdn,
  }) {
    final result = create();
    if (cdn != null) result.cdn = cdn;
    return result;
  }

  UploadConfirm_Response._();

  factory UploadConfirm_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadConfirm_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadConfirm.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<$0.CDN>(1, _omitFieldNames ? '' : 'cdn', subBuilder: $0.CDN.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadConfirm_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadConfirm_Response copyWith(void Function(UploadConfirm_Response) updates) =>
      super.copyWith((message) => updates(message as UploadConfirm_Response)) as UploadConfirm_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadConfirm_Response create() => UploadConfirm_Response._();
  @$core.override
  UploadConfirm_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadConfirm_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadConfirm_Response>(create);
  static UploadConfirm_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $0.CDN get cdn => $_getN(0);
  @$pb.TagNumber(1)
  set cdn($0.CDN value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCdn() => $_has(0);
  @$pb.TagNumber(1)
  void clearCdn() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.CDN ensureCdn() => $_ensure(0);
}

class UploadConfirm extends $pb.GeneratedMessage {
  factory UploadConfirm() => create();

  UploadConfirm._();

  factory UploadConfirm.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadConfirm.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadConfirm',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadConfirm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadConfirm copyWith(void Function(UploadConfirm) updates) =>
      super.copyWith((message) => updates(message as UploadConfirm)) as UploadConfirm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadConfirm create() => UploadConfirm._();
  @$core.override
  UploadConfirm createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadConfirm getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadConfirm>(create);
  static UploadConfirm? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
