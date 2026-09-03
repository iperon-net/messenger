// This is a generated file - do not edit.
//
// Generated from protos/models.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'models.pbenum.dart';

class Date extends $pb.GeneratedMessage {
  factory Date({
    $core.int? year,
    $core.int? month,
    $core.int? day,
  }) {
    final result = create();
    if (year != null) result.year = year;
    if (month != null) result.month = month;
    if (day != null) result.day = day;
    return result;
  }

  Date._();

  factory Date.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Date.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Date',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'year')
    ..aI(2, _omitFieldNames ? '' : 'month')
    ..aI(3, _omitFieldNames ? '' : 'day')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Date clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Date copyWith(void Function(Date) updates) => super.copyWith((message) => updates(message as Date)) as Date;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Date create() => Date._();
  @$core.override
  Date createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Date getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Date>(create);
  static Date? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get year => $_getIZ(0);
  @$pb.TagNumber(1)
  set year($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasYear() => $_has(0);
  @$pb.TagNumber(1)
  void clearYear() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get month => $_getIZ(1);
  @$pb.TagNumber(2)
  set month($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMonth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get day => $_getIZ(2);
  @$pb.TagNumber(3)
  set day($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDay() => $_clearField(3);
}

class CDN extends $pb.GeneratedMessage {
  factory CDN({
    $core.List<$core.int>? cdnID,
    $core.String? url,
    $core.List<$core.int>? hashSum,
    $core.List<$core.int>? hashSumEncrypted,
    $core.List<$core.int>? signatureKey,
    $core.List<$core.int>? salt,
    $0.Timestamp? createAt,
  }) {
    final result = create();
    if (cdnID != null) result.cdnID = cdnID;
    if (url != null) result.url = url;
    if (hashSum != null) result.hashSum = hashSum;
    if (hashSumEncrypted != null) result.hashSumEncrypted = hashSumEncrypted;
    if (signatureKey != null) result.signatureKey = signatureKey;
    if (salt != null) result.salt = salt;
    if (createAt != null) result.createAt = createAt;
    return result;
  }

  CDN._();

  factory CDN.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CDN.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CDN',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'cdnID', $pb.PbFieldType.OY, protoName: 'cdnID')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'hashSum', $pb.PbFieldType.OY, protoName: 'hashSum')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'hashSumEncrypted', $pb.PbFieldType.OY, protoName: 'hashSumEncrypted')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'signatureKey', $pb.PbFieldType.OY, protoName: 'signatureKey')
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'salt', $pb.PbFieldType.OY)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createAt', protoName: 'createAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CDN clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CDN copyWith(void Function(CDN) updates) => super.copyWith((message) => updates(message as CDN)) as CDN;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CDN create() => CDN._();
  @$core.override
  CDN createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CDN getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CDN>(create);
  static CDN? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get cdnID => $_getN(0);
  @$pb.TagNumber(1)
  set cdnID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCdnID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCdnID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get hashSum => $_getN(2);
  @$pb.TagNumber(3)
  set hashSum($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHashSum() => $_has(2);
  @$pb.TagNumber(3)
  void clearHashSum() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get hashSumEncrypted => $_getN(3);
  @$pb.TagNumber(4)
  set hashSumEncrypted($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHashSumEncrypted() => $_has(3);
  @$pb.TagNumber(4)
  void clearHashSumEncrypted() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get signatureKey => $_getN(4);
  @$pb.TagNumber(5)
  set signatureKey($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSignatureKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearSignatureKey() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get salt => $_getN(5);
  @$pb.TagNumber(6)
  set salt($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSalt() => $_has(5);
  @$pb.TagNumber(6)
  void clearSalt() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get createAt => $_getN(6);
  @$pb.TagNumber(7)
  set createAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCreateAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreateAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCreateAt() => $_ensure(6);
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
