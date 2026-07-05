// This is a generated file - do not edit.
//
// Generated from protos/messages/two_step_verification_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TwoStepVerification extends $pb.GeneratedMessage {
  factory TwoStepVerification({
    $core.List<$core.int>? password,
  }) {
    final result = create();
    if (password != null) result.password = password;
    return result;
  }

  TwoStepVerification._();

  factory TwoStepVerification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwoStepVerification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwoStepVerification',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1.messages'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'password', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoStepVerification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoStepVerification copyWith(void Function(TwoStepVerification) updates) =>
      super.copyWith((message) => updates(message as TwoStepVerification))
          as TwoStepVerification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwoStepVerification create() => TwoStepVerification._();
  @$core.override
  TwoStepVerification createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwoStepVerification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwoStepVerification>(create);
  static TwoStepVerification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get password => $_getN(0);
  @$pb.TagNumber(1)
  set password($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPassword() => $_has(0);
  @$pb.TagNumber(1)
  void clearPassword() => $_clearField(1);
}

class TwoStepVerificationResult extends $pb.GeneratedMessage {
  factory TwoStepVerificationResult() => create();

  TwoStepVerificationResult._();

  factory TwoStepVerificationResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TwoStepVerificationResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TwoStepVerificationResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1.messages'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoStepVerificationResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TwoStepVerificationResult copyWith(
          void Function(TwoStepVerificationResult) updates) =>
      super.copyWith((message) => updates(message as TwoStepVerificationResult))
          as TwoStepVerificationResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TwoStepVerificationResult create() => TwoStepVerificationResult._();
  @$core.override
  TwoStepVerificationResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TwoStepVerificationResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TwoStepVerificationResult>(create);
  static TwoStepVerificationResult? _defaultInstance;
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
