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

class MetadataInfoResponse_GitCommit extends $pb.GeneratedMessage {
  factory MetadataInfoResponse_GitCommit({
    $core.String? full,
    $core.String? short,
  }) {
    final result = create();
    if (full != null) result.full = full;
    if (short != null) result.short = short;
    return result;
  }

  MetadataInfoResponse_GitCommit._();

  factory MetadataInfoResponse_GitCommit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfoResponse_GitCommit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfoResponse.GitCommit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'full')
    ..aOS(2, _omitFieldNames ? '' : 'short')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfoResponse_GitCommit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfoResponse_GitCommit copyWith(
          void Function(MetadataInfoResponse_GitCommit) updates) =>
      super.copyWith(
              (message) => updates(message as MetadataInfoResponse_GitCommit))
          as MetadataInfoResponse_GitCommit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfoResponse_GitCommit create() =>
      MetadataInfoResponse_GitCommit._();
  @$core.override
  MetadataInfoResponse_GitCommit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfoResponse_GitCommit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfoResponse_GitCommit>(create);
  static MetadataInfoResponse_GitCommit? _defaultInstance;

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

class MetadataInfoResponse_ECDH extends $pb.GeneratedMessage {
  factory MetadataInfoResponse_ECDH({
    $core.List<$core.int>? publicKey,
    $core.String? fingerprint,
  }) {
    final result = create();
    if (publicKey != null) result.publicKey = publicKey;
    if (fingerprint != null) result.fingerprint = fingerprint;
    return result;
  }

  MetadataInfoResponse_ECDH._();

  factory MetadataInfoResponse_ECDH.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataInfoResponse_ECDH.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataInfoResponse.ECDH',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'publicKey', $pb.PbFieldType.OY,
        protoName: 'publicKey')
    ..aOS(2, _omitFieldNames ? '' : 'fingerprint')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfoResponse_ECDH clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataInfoResponse_ECDH copyWith(
          void Function(MetadataInfoResponse_ECDH) updates) =>
      super.copyWith((message) => updates(message as MetadataInfoResponse_ECDH))
          as MetadataInfoResponse_ECDH;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataInfoResponse_ECDH create() => MetadataInfoResponse_ECDH._();
  @$core.override
  MetadataInfoResponse_ECDH createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataInfoResponse_ECDH getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataInfoResponse_ECDH>(create);
  static MetadataInfoResponse_ECDH? _defaultInstance;

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

class MetadataInfoResponse extends $pb.GeneratedMessage {
  factory MetadataInfoResponse({
    MetadataInfoResponse_ECDH? ecdh,
    MetadataInfoResponse_GitCommit? gitCommit,
    $core.String? buildDate,
    $core.String? version,
  }) {
    final result = create();
    if (ecdh != null) result.ecdh = ecdh;
    if (gitCommit != null) result.gitCommit = gitCommit;
    if (buildDate != null) result.buildDate = buildDate;
    if (version != null) result.version = version;
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
    ..aOM<MetadataInfoResponse_ECDH>(1, _omitFieldNames ? '' : 'ecdh',
        subBuilder: MetadataInfoResponse_ECDH.create)
    ..aOM<MetadataInfoResponse_GitCommit>(2, _omitFieldNames ? '' : 'gitCommit',
        protoName: 'gitCommit',
        subBuilder: MetadataInfoResponse_GitCommit.create)
    ..aOS(3, _omitFieldNames ? '' : 'buildDate', protoName: 'buildDate')
    ..aOS(4, _omitFieldNames ? '' : 'version')
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
  MetadataInfoResponse_ECDH get ecdh => $_getN(0);
  @$pb.TagNumber(1)
  set ecdh(MetadataInfoResponse_ECDH value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEcdh() => $_has(0);
  @$pb.TagNumber(1)
  void clearEcdh() => $_clearField(1);
  @$pb.TagNumber(1)
  MetadataInfoResponse_ECDH ensureEcdh() => $_ensure(0);

  @$pb.TagNumber(2)
  MetadataInfoResponse_GitCommit get gitCommit => $_getN(1);
  @$pb.TagNumber(2)
  set gitCommit(MetadataInfoResponse_GitCommit value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGitCommit() => $_has(1);
  @$pb.TagNumber(2)
  void clearGitCommit() => $_clearField(2);
  @$pb.TagNumber(2)
  MetadataInfoResponse_GitCommit ensureGitCommit() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get buildDate => $_getSZ(2);
  @$pb.TagNumber(3)
  set buildDate($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBuildDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearBuildDate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);
}

/// GeoIP
class MetadataGeoIPRequest extends $pb.GeneratedMessage {
  factory MetadataGeoIPRequest({
    $core.String? ip,
  }) {
    final result = create();
    if (ip != null) result.ip = ip;
    return result;
  }

  MetadataGeoIPRequest._();

  factory MetadataGeoIPRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIPRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIPRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPRequest copyWith(void Function(MetadataGeoIPRequest) updates) =>
      super.copyWith((message) => updates(message as MetadataGeoIPRequest))
          as MetadataGeoIPRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPRequest create() => MetadataGeoIPRequest._();
  @$core.override
  MetadataGeoIPRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataGeoIPRequest>(create);
  static MetadataGeoIPRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ip => $_getSZ(0);
  @$pb.TagNumber(1)
  set ip($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIp() => $_has(0);
  @$pb.TagNumber(1)
  void clearIp() => $_clearField(1);
}

class MetadataGeoIPResponse_MetadataGeoIPLocation extends $pb.GeneratedMessage {
  factory MetadataGeoIPResponse_MetadataGeoIPLocation({
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final result = create();
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    return result;
  }

  MetadataGeoIPResponse_MetadataGeoIPLocation._();

  factory MetadataGeoIPResponse_MetadataGeoIPLocation.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIPResponse_MetadataGeoIPLocation.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIPResponse.MetadataGeoIPLocation',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'latitude', fieldType: $pb.PbFieldType.OF)
    ..aD(2, _omitFieldNames ? '' : 'longitude', fieldType: $pb.PbFieldType.OF)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPResponse_MetadataGeoIPLocation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPResponse_MetadataGeoIPLocation copyWith(
          void Function(MetadataGeoIPResponse_MetadataGeoIPLocation) updates) =>
      super.copyWith((message) =>
              updates(message as MetadataGeoIPResponse_MetadataGeoIPLocation))
          as MetadataGeoIPResponse_MetadataGeoIPLocation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPResponse_MetadataGeoIPLocation create() =>
      MetadataGeoIPResponse_MetadataGeoIPLocation._();
  @$core.override
  MetadataGeoIPResponse_MetadataGeoIPLocation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPResponse_MetadataGeoIPLocation getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          MetadataGeoIPResponse_MetadataGeoIPLocation>(create);
  static MetadataGeoIPResponse_MetadataGeoIPLocation? _defaultInstance;

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

class MetadataGeoIPResponse_MetadataGeoIPCountry extends $pb.GeneratedMessage {
  factory MetadataGeoIPResponse_MetadataGeoIPCountry({
    $core.String? russianName,
    $core.String? englishName,
  }) {
    final result = create();
    if (russianName != null) result.russianName = russianName;
    if (englishName != null) result.englishName = englishName;
    return result;
  }

  MetadataGeoIPResponse_MetadataGeoIPCountry._();

  factory MetadataGeoIPResponse_MetadataGeoIPCountry.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIPResponse_MetadataGeoIPCountry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIPResponse.MetadataGeoIPCountry',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'russianName', protoName: 'russianName')
    ..aOS(2, _omitFieldNames ? '' : 'englishName', protoName: 'englishName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPResponse_MetadataGeoIPCountry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPResponse_MetadataGeoIPCountry copyWith(
          void Function(MetadataGeoIPResponse_MetadataGeoIPCountry) updates) =>
      super.copyWith((message) =>
              updates(message as MetadataGeoIPResponse_MetadataGeoIPCountry))
          as MetadataGeoIPResponse_MetadataGeoIPCountry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPResponse_MetadataGeoIPCountry create() =>
      MetadataGeoIPResponse_MetadataGeoIPCountry._();
  @$core.override
  MetadataGeoIPResponse_MetadataGeoIPCountry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPResponse_MetadataGeoIPCountry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          MetadataGeoIPResponse_MetadataGeoIPCountry>(create);
  static MetadataGeoIPResponse_MetadataGeoIPCountry? _defaultInstance;

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

class MetadataGeoIPResponse_MetadataGeoIPCity extends $pb.GeneratedMessage {
  factory MetadataGeoIPResponse_MetadataGeoIPCity({
    $core.String? russianName,
    $core.String? englishName,
  }) {
    final result = create();
    if (russianName != null) result.russianName = russianName;
    if (englishName != null) result.englishName = englishName;
    return result;
  }

  MetadataGeoIPResponse_MetadataGeoIPCity._();

  factory MetadataGeoIPResponse_MetadataGeoIPCity.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIPResponse_MetadataGeoIPCity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIPResponse.MetadataGeoIPCity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'russianName', protoName: 'russianName')
    ..aOS(2, _omitFieldNames ? '' : 'englishName', protoName: 'englishName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPResponse_MetadataGeoIPCity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPResponse_MetadataGeoIPCity copyWith(
          void Function(MetadataGeoIPResponse_MetadataGeoIPCity) updates) =>
      super.copyWith((message) =>
              updates(message as MetadataGeoIPResponse_MetadataGeoIPCity))
          as MetadataGeoIPResponse_MetadataGeoIPCity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPResponse_MetadataGeoIPCity create() =>
      MetadataGeoIPResponse_MetadataGeoIPCity._();
  @$core.override
  MetadataGeoIPResponse_MetadataGeoIPCity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPResponse_MetadataGeoIPCity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          MetadataGeoIPResponse_MetadataGeoIPCity>(create);
  static MetadataGeoIPResponse_MetadataGeoIPCity? _defaultInstance;

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

class MetadataGeoIPResponse extends $pb.GeneratedMessage {
  factory MetadataGeoIPResponse({
    $core.String? timeZone,
    $core.String? isoCode,
    MetadataGeoIPResponse_MetadataGeoIPLocation? location,
    MetadataGeoIPResponse_MetadataGeoIPCountry? country,
    MetadataGeoIPResponse_MetadataGeoIPCity? city,
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

  MetadataGeoIPResponse._();

  factory MetadataGeoIPResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MetadataGeoIPResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MetadataGeoIPResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'timeZone', protoName: 'timeZone')
    ..aOS(2, _omitFieldNames ? '' : 'isoCode', protoName: 'isoCode')
    ..aOM<MetadataGeoIPResponse_MetadataGeoIPLocation>(
        3, _omitFieldNames ? '' : 'location',
        subBuilder: MetadataGeoIPResponse_MetadataGeoIPLocation.create)
    ..aOM<MetadataGeoIPResponse_MetadataGeoIPCountry>(
        4, _omitFieldNames ? '' : 'country',
        subBuilder: MetadataGeoIPResponse_MetadataGeoIPCountry.create)
    ..aOM<MetadataGeoIPResponse_MetadataGeoIPCity>(
        5, _omitFieldNames ? '' : 'city',
        subBuilder: MetadataGeoIPResponse_MetadataGeoIPCity.create)
    ..aOS(6, _omitFieldNames ? '' : 'ip')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MetadataGeoIPResponse copyWith(
          void Function(MetadataGeoIPResponse) updates) =>
      super.copyWith((message) => updates(message as MetadataGeoIPResponse))
          as MetadataGeoIPResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPResponse create() => MetadataGeoIPResponse._();
  @$core.override
  MetadataGeoIPResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MetadataGeoIPResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MetadataGeoIPResponse>(create);
  static MetadataGeoIPResponse? _defaultInstance;

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
  MetadataGeoIPResponse_MetadataGeoIPLocation get location => $_getN(2);
  @$pb.TagNumber(3)
  set location(MetadataGeoIPResponse_MetadataGeoIPLocation value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => $_clearField(3);
  @$pb.TagNumber(3)
  MetadataGeoIPResponse_MetadataGeoIPLocation ensureLocation() => $_ensure(2);

  @$pb.TagNumber(4)
  MetadataGeoIPResponse_MetadataGeoIPCountry get country => $_getN(3);
  @$pb.TagNumber(4)
  set country(MetadataGeoIPResponse_MetadataGeoIPCountry value) =>
      $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCountry() => $_has(3);
  @$pb.TagNumber(4)
  void clearCountry() => $_clearField(4);
  @$pb.TagNumber(4)
  MetadataGeoIPResponse_MetadataGeoIPCountry ensureCountry() => $_ensure(3);

  @$pb.TagNumber(5)
  MetadataGeoIPResponse_MetadataGeoIPCity get city => $_getN(4);
  @$pb.TagNumber(5)
  set city(MetadataGeoIPResponse_MetadataGeoIPCity value) =>
      $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCity() => $_has(4);
  @$pb.TagNumber(5)
  void clearCity() => $_clearField(5);
  @$pb.TagNumber(5)
  MetadataGeoIPResponse_MetadataGeoIPCity ensureCity() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get ip => $_getSZ(5);
  @$pb.TagNumber(6)
  set ip($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIp() => $_has(5);
  @$pb.TagNumber(6)
  void clearIp() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
