// This is a generated file - do not edit.
//
// Generated from protos/push_test_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class PushTest_Request extends $pb.GeneratedMessage {
  factory PushTest_Request() => create();

  PushTest_Request._();

  factory PushTest_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushTest_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushTest.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushTest_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushTest_Request copyWith(void Function(PushTest_Request) updates) =>
      super.copyWith((message) => updates(message as PushTest_Request)) as PushTest_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushTest_Request create() => PushTest_Request._();
  @$core.override
  PushTest_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushTest_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushTest_Request>(create);
  static PushTest_Request? _defaultInstance;
}

class PushTest_Response extends $pb.GeneratedMessage {
  factory PushTest_Response({
    $core.int? apnsSent,
    $core.int? fcmSent,
    $core.int? failed,
  }) {
    final result = create();
    if (apnsSent != null) result.apnsSent = apnsSent;
    if (fcmSent != null) result.fcmSent = fcmSent;
    if (failed != null) result.failed = failed;
    return result;
  }

  PushTest_Response._();

  factory PushTest_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushTest_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushTest.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'apnsSent', protoName: 'apnsSent')
    ..aI(2, _omitFieldNames ? '' : 'fcmSent', protoName: 'fcmSent')
    ..aI(3, _omitFieldNames ? '' : 'failed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushTest_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushTest_Response copyWith(void Function(PushTest_Response) updates) =>
      super.copyWith((message) => updates(message as PushTest_Response)) as PushTest_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushTest_Response create() => PushTest_Response._();
  @$core.override
  PushTest_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushTest_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushTest_Response>(create);
  static PushTest_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get apnsSent => $_getIZ(0);
  @$pb.TagNumber(1)
  set apnsSent($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApnsSent() => $_has(0);
  @$pb.TagNumber(1)
  void clearApnsSent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get fcmSent => $_getIZ(1);
  @$pb.TagNumber(2)
  set fcmSent($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFcmSent() => $_has(1);
  @$pb.TagNumber(2)
  void clearFcmSent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failed => $_getIZ(2);
  @$pb.TagNumber(3)
  set failed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailed() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailed() => $_clearField(3);
}

/// PushTest — отладочный push на все устройства вызывающего пользователя (включая
/// текущее), минуя presence-гейт. Нужен, чтобы проверить доставку APNs/FCM на
/// реальных устройствах (экран «Разработчик»). Ответ — сколько уникальных
/// токенов было адресовано и сколько отправок прошло/упало.
class PushTest extends $pb.GeneratedMessage {
  factory PushTest() => create();

  PushTest._();

  factory PushTest.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushTest.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushTest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushTest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushTest copyWith(void Function(PushTest) updates) => super.copyWith((message) => updates(message as PushTest)) as PushTest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushTest create() => PushTest._();
  @$core.override
  PushTest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushTest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushTest>(create);
  static PushTest? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
