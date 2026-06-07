// This is a generated file - do not edit.
//
// Generated from protos/messages/pub_sub_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class PubSubUser extends $pb.GeneratedMessage {
  factory PubSubUser({
    $core.bool? user,
  }) {
    final result = create();
    if (user != null) result.user = user;
    return result;
  }

  PubSubUser._();

  factory PubSubUser.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PubSubUser.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PubSubUser',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'user')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PubSubUser clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PubSubUser copyWith(void Function(PubSubUser) updates) =>
      super.copyWith((message) => updates(message as PubSubUser)) as PubSubUser;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PubSubUser create() => PubSubUser._();
  @$core.override
  PubSubUser createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PubSubUser getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PubSubUser>(create);
  static PubSubUser? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get user => $_getBF(0);
  @$pb.TagNumber(1)
  set user($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
