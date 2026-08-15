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

class MetadataInfo_GitCommit extends $pb.GeneratedMessage {
  factory MetadataInfo_GitCommit({
    $core.String? full,
    $core.String? short,
  }) {
    final result = create();
    if (full != null) result.full = full;
    if (short != null) result.short = short;
    return result;
  }

  MetadataInfo_GitCommit._();

  factory MetadataInfo_GitCommit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfo_GitCommit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfo.GitCommit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'full')
    ..aOS(2, _omitFieldNames ? '' : 'short')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_GitCommit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_GitCommit copyWith(
          void Function(MetadataInfo_GitCommit) updates) =>
      super.copyWith((message) => updates(message as MetadataInfo_GitCommit))
          as MetadataInfo_GitCommit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfo_GitCommit create() => MetadataInfo_GitCommit._();
  @$core.override
  MetadataInfo_GitCommit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfo_GitCommit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfo_GitCommit>(create);
  static MetadataInfo_GitCommit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get full => $_getSZ(0);
  @$pb.TagNumber(1)
  set full($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFull() => $_has(0);
  @$pb.TagNumber(1)
  void clearFull() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get short => $_getSZ(1);
  @$pb.TagNumber(2)
  set short($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShort() => $_has(1);
  @$pb.TagNumber(2)
  void clearShort() => $_clearField(2);
}

class MetadataInfo_EdDSA extends $pb.GeneratedMessage {
  factory MetadataInfo_EdDSA({
    $core.List<$core.int>? publicKey,
    $core.String? fingerprint,
  }) {
    final result = create();
    if (publicKey != null) result.publicKey = publicKey;
    if (fingerprint != null) result.fingerprint = fingerprint;
    return result;
  }

  MetadataInfo_EdDSA._();

  factory MetadataInfo_EdDSA.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfo_EdDSA.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfo.EdDSA',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY,
        protoName: 'publicKey')
    ..aOS(2, _omitFieldNames ? '' : 'fingerprint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_EdDSA clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_EdDSA copyWith(void Function(MetadataInfo_EdDSA) updates) =>
      super.copyWith((message) => updates(message as MetadataInfo_EdDSA))
          as MetadataInfo_EdDSA;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfo_EdDSA create() => MetadataInfo_EdDSA._();
  @$core.override
  MetadataInfo_EdDSA createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfo_EdDSA getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfo_EdDSA>(create);
  static MetadataInfo_EdDSA? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fingerprint => $_getSZ(1);
  @$pb.TagNumber(2)
  set fingerprint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearFingerprint() => $_clearField(2);
}

class MetadataInfo_VOPRF extends $pb.GeneratedMessage {
  factory MetadataInfo_VOPRF({
    $core.List<$core.int>? publicKey,
    $core.String? fingerprint,
  }) {
    final result = create();
    if (publicKey != null) result.publicKey = publicKey;
    if (fingerprint != null) result.fingerprint = fingerprint;
    return result;
  }

  MetadataInfo_VOPRF._();

  factory MetadataInfo_VOPRF.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfo_VOPRF.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfo.VOPRF',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY,
        protoName: 'publicKey')
    ..aOS(2, _omitFieldNames ? '' : 'fingerprint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_VOPRF clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_VOPRF copyWith(void Function(MetadataInfo_VOPRF) updates) =>
      super.copyWith((message) => updates(message as MetadataInfo_VOPRF))
          as MetadataInfo_VOPRF;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfo_VOPRF create() => MetadataInfo_VOPRF._();
  @$core.override
  MetadataInfo_VOPRF createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfo_VOPRF getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfo_VOPRF>(create);
  static MetadataInfo_VOPRF? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get publicKey => $_getN(0);
  @$pb.TagNumber(1)
  set publicKey($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPublicKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearPublicKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fingerprint => $_getSZ(1);
  @$pb.TagNumber(2)
  set fingerprint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearFingerprint() => $_clearField(2);
}

/// Request
class MetadataInfo_Request extends $pb.GeneratedMessage {
  factory MetadataInfo_Request() => create();

  MetadataInfo_Request._();

  factory MetadataInfo_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfo_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfo.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_Request copyWith(void Function(MetadataInfo_Request) updates) =>
      super.copyWith((message) => updates(message as MetadataInfo_Request))
          as MetadataInfo_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfo_Request create() => MetadataInfo_Request._();
  @$core.override
  MetadataInfo_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfo_Request getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfo_Request>(create);
  static MetadataInfo_Request? _defaultInstance;
}

/// Response
class MetadataInfo_Response extends $pb.GeneratedMessage {
  factory MetadataInfo_Response({
    MetadataInfo_EdDSA? eddsa,
    MetadataInfo_VOPRF? voprf,
    MetadataInfo_GitCommit? gitCommit,
    $core.String? buildDate,
    $core.String? version,
  }) {
    final result = create();
    if (eddsa != null) result.eddsa = eddsa;
    if (voprf != null) result.voprf = voprf;
    if (gitCommit != null) result.gitCommit = gitCommit;
    if (buildDate != null) result.buildDate = buildDate;
    if (version != null) result.version = version;
    return result;
  }

  MetadataInfo_Response._();

  factory MetadataInfo_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfo_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfo.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOM<MetadataInfo_EdDSA>(2, _omitFieldNames ? '' : 'eddsa',
        subBuilder: MetadataInfo_EdDSA.create)
    ..aOM<MetadataInfo_VOPRF>(3, _omitFieldNames ? '' : 'voprf',
        subBuilder: MetadataInfo_VOPRF.create)
    ..aOM<MetadataInfo_GitCommit>(4, _omitFieldNames ? '' : 'gitCommit',
        protoName: 'gitCommit', subBuilder: MetadataInfo_GitCommit.create)
    ..aOS(5, _omitFieldNames ? '' : 'buildDate', protoName: 'buildDate')
    ..aOS(6, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo_Response copyWith(
          void Function(MetadataInfo_Response) updates) =>
      super.copyWith((message) => updates(message as MetadataInfo_Response))
          as MetadataInfo_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfo_Response create() => MetadataInfo_Response._();
  @$core.override
  MetadataInfo_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfo_Response getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfo_Response>(create);
  static MetadataInfo_Response? _defaultInstance;

  @$pb.TagNumber(2)
  MetadataInfo_EdDSA get eddsa => $_getN(0);
  @$pb.TagNumber(2)
  set eddsa(MetadataInfo_EdDSA value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEddsa() => $_has(0);
  @$pb.TagNumber(2)
  void clearEddsa() => $_clearField(2);
  @$pb.TagNumber(2)
  MetadataInfo_EdDSA ensureEddsa() => $_ensure(0);

  @$pb.TagNumber(3)
  MetadataInfo_VOPRF get voprf => $_getN(1);
  @$pb.TagNumber(3)
  set voprf(MetadataInfo_VOPRF value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVoprf() => $_has(1);
  @$pb.TagNumber(3)
  void clearVoprf() => $_clearField(3);
  @$pb.TagNumber(3)
  MetadataInfo_VOPRF ensureVoprf() => $_ensure(1);

  @$pb.TagNumber(4)
  MetadataInfo_GitCommit get gitCommit => $_getN(2);
  @$pb.TagNumber(4)
  set gitCommit(MetadataInfo_GitCommit value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasGitCommit() => $_has(2);
  @$pb.TagNumber(4)
  void clearGitCommit() => $_clearField(4);
  @$pb.TagNumber(4)
  MetadataInfo_GitCommit ensureGitCommit() => $_ensure(2);

  @$pb.TagNumber(5)
  $core.String get buildDate => $_getSZ(3);
  @$pb.TagNumber(5)
  set buildDate($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasBuildDate() => $_has(3);
  @$pb.TagNumber(5)
  void clearBuildDate() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get version => $_getSZ(4);
  @$pb.TagNumber(6)
  set version($core.String value) => $_setString(4, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);
}

/// MetadataInfo
class MetadataInfo extends $pb.GeneratedMessage {
  factory MetadataInfo() => create();

  MetadataInfo._();

  factory MetadataInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfo copyWith(void Function(MetadataInfo) updates) =>
      super.copyWith((message) => updates(message as MetadataInfo))
          as MetadataInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfo create() => MetadataInfo._();
  @$core.override
  MetadataInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfo>(create);
  static MetadataInfo? _defaultInstance;
}

class MetadataGeoIP_Location extends $pb.GeneratedMessage {
  factory MetadataGeoIP_Location({
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final result = create();
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    return result;
  }

  MetadataGeoIP_Location._();

  factory MetadataGeoIP_Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIP_Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIP.Location',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'latitude', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'longitude', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_Location copyWith(
          void Function(MetadataGeoIP_Location) updates) =>
      super.copyWith((message) => updates(message as MetadataGeoIP_Location))
          as MetadataGeoIP_Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_Location create() => MetadataGeoIP_Location._();
  @$core.override
  MetadataGeoIP_Location createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_Location getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataGeoIP_Location>(create);
  static MetadataGeoIP_Location? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => $_clearField(2);
}

class MetadataGeoIP_Country extends $pb.GeneratedMessage {
  factory MetadataGeoIP_Country({
    $core.String? russianName,
    $core.String? englishName,
  }) {
    final result = create();
    if (russianName != null) result.russianName = russianName;
    if (englishName != null) result.englishName = englishName;
    return result;
  }

  MetadataGeoIP_Country._();

  factory MetadataGeoIP_Country.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIP_Country.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIP.Country',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'russianName', protoName: 'russianName')
    ..aOS(2, _omitFieldNames ? '' : 'englishName', protoName: 'englishName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_Country clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_Country copyWith(
          void Function(MetadataGeoIP_Country) updates) =>
      super.copyWith((message) => updates(message as MetadataGeoIP_Country))
          as MetadataGeoIP_Country;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_Country create() => MetadataGeoIP_Country._();
  @$core.override
  MetadataGeoIP_Country createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_Country getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataGeoIP_Country>(create);
  static MetadataGeoIP_Country? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get russianName => $_getSZ(0);
  @$pb.TagNumber(1)
  set russianName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRussianName() => $_has(0);
  @$pb.TagNumber(1)
  void clearRussianName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get englishName => $_getSZ(1);
  @$pb.TagNumber(2)
  set englishName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnglishName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnglishName() => $_clearField(2);
}

class MetadataGeoIP_City extends $pb.GeneratedMessage {
  factory MetadataGeoIP_City({
    $core.String? russianName,
    $core.String? englishName,
  }) {
    final result = create();
    if (russianName != null) result.russianName = russianName;
    if (englishName != null) result.englishName = englishName;
    return result;
  }

  MetadataGeoIP_City._();

  factory MetadataGeoIP_City.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIP_City.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIP.City',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'russianName', protoName: 'russianName')
    ..aOS(2, _omitFieldNames ? '' : 'englishName', protoName: 'englishName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_City clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_City copyWith(void Function(MetadataGeoIP_City) updates) =>
      super.copyWith((message) => updates(message as MetadataGeoIP_City))
          as MetadataGeoIP_City;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_City create() => MetadataGeoIP_City._();
  @$core.override
  MetadataGeoIP_City createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_City getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataGeoIP_City>(create);
  static MetadataGeoIP_City? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get russianName => $_getSZ(0);
  @$pb.TagNumber(1)
  set russianName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRussianName() => $_has(0);
  @$pb.TagNumber(1)
  void clearRussianName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get englishName => $_getSZ(1);
  @$pb.TagNumber(2)
  set englishName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnglishName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnglishName() => $_clearField(2);
}

/// Request
class MetadataGeoIP_Request extends $pb.GeneratedMessage {
  factory MetadataGeoIP_Request({
    $core.String? ip,
  }) {
    final result = create();
    if (ip != null) result.ip = ip;
    return result;
  }

  MetadataGeoIP_Request._();

  factory MetadataGeoIP_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIP_Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIP.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_Request copyWith(
          void Function(MetadataGeoIP_Request) updates) =>
      super.copyWith((message) => updates(message as MetadataGeoIP_Request))
          as MetadataGeoIP_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_Request create() => MetadataGeoIP_Request._();
  @$core.override
  MetadataGeoIP_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_Request getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataGeoIP_Request>(create);
  static MetadataGeoIP_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ip => $_getSZ(0);
  @$pb.TagNumber(1)
  set ip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIp() => $_has(0);
  @$pb.TagNumber(1)
  void clearIp() => $_clearField(1);
}

/// Response
class MetadataGeoIP_Response extends $pb.GeneratedMessage {
  factory MetadataGeoIP_Response({
    $core.String? timeZone,
    $core.String? isoCode,
    MetadataGeoIP_Location? location,
    MetadataGeoIP_Country? country,
    MetadataGeoIP_City? city,
    $core.String? ip,
  }) {
    final result = create();
    if (timeZone != null) result.timeZone = timeZone;
    if (isoCode != null) result.isoCode = isoCode;
    if (location != null) result.location = location;
    if (country != null) result.country = country;
    if (city != null) result.city = city;
    if (ip != null) result.ip = ip;
    return result;
  }

  MetadataGeoIP_Response._();

  factory MetadataGeoIP_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIP_Response.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIP.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'timeZone', protoName: 'timeZone')
    ..aOS(2, _omitFieldNames ? '' : 'isoCode', protoName: 'isoCode')
    ..aOM<MetadataGeoIP_Location>(3, _omitFieldNames ? '' : 'location',
        subBuilder: MetadataGeoIP_Location.create)
    ..aOM<MetadataGeoIP_Country>(4, _omitFieldNames ? '' : 'country',
        subBuilder: MetadataGeoIP_Country.create)
    ..aOM<MetadataGeoIP_City>(5, _omitFieldNames ? '' : 'city',
        subBuilder: MetadataGeoIP_City.create)
    ..aOS(6, _omitFieldNames ? '' : 'ip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP_Response copyWith(
          void Function(MetadataGeoIP_Response) updates) =>
      super.copyWith((message) => updates(message as MetadataGeoIP_Response))
          as MetadataGeoIP_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_Response create() => MetadataGeoIP_Response._();
  @$core.override
  MetadataGeoIP_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP_Response getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataGeoIP_Response>(create);
  static MetadataGeoIP_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get timeZone => $_getSZ(0);
  @$pb.TagNumber(1)
  set timeZone($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimeZone() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimeZone() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get isoCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set isoCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsoCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsoCode() => $_clearField(2);

  @$pb.TagNumber(3)
  MetadataGeoIP_Location get location => $_getN(2);
  @$pb.TagNumber(3)
  set location(MetadataGeoIP_Location value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => $_clearField(3);
  @$pb.TagNumber(3)
  MetadataGeoIP_Location ensureLocation() => $_ensure(2);

  @$pb.TagNumber(4)
  MetadataGeoIP_Country get country => $_getN(3);
  @$pb.TagNumber(4)
  set country(MetadataGeoIP_Country value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCountry() => $_has(3);
  @$pb.TagNumber(4)
  void clearCountry() => $_clearField(4);
  @$pb.TagNumber(4)
  MetadataGeoIP_Country ensureCountry() => $_ensure(3);

  @$pb.TagNumber(5)
  MetadataGeoIP_City get city => $_getN(4);
  @$pb.TagNumber(5)
  set city(MetadataGeoIP_City value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCity() => $_has(4);
  @$pb.TagNumber(5)
  void clearCity() => $_clearField(5);
  @$pb.TagNumber(5)
  MetadataGeoIP_City ensureCity() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get ip => $_getSZ(5);
  @$pb.TagNumber(6)
  set ip($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIp() => $_has(5);
  @$pb.TagNumber(6)
  void clearIp() => $_clearField(6);
}

/// GeoIP
class MetadataGeoIP extends $pb.GeneratedMessage {
  factory MetadataGeoIP() => create();

  MetadataGeoIP._();

  factory MetadataGeoIP.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIP.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIP',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIP copyWith(void Function(MetadataGeoIP) updates) =>
      super.copyWith((message) => updates(message as MetadataGeoIP))
          as MetadataGeoIP;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP create() => MetadataGeoIP._();
  @$core.override
  MetadataGeoIP createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIP getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataGeoIP>(create);
  static MetadataGeoIP? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
