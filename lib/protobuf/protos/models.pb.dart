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

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'models.pbenum.dart';

class Location extends $pb.GeneratedMessage {
  factory Location({
    $core.String? russianName,
    $core.String? englishName,
  }) {
    final result = create();
    if (russianName != null) result.russianName = russianName;
    if (englishName != null) result.englishName = englishName;
    return result;
  }

  Location._();

  factory Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Location',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'russianName', protoName: 'russianName')
    ..aOS(2, _omitFieldNames ? '' : 'englishName', protoName: 'englishName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Location copyWith(void Function(Location) updates) =>
      super.copyWith((message) => updates(message as Location)) as Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Location create() => Location._();
  @$core.override
  Location createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Location getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location>(create);
  static Location? _defaultInstance;

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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
