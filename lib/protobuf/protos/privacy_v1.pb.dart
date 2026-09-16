// This is a generated file - do not edit.
//
// Generated from protos/privacy_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'privacy_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'privacy_v1.pbenum.dart';

/// Чтение текущих настроек.
class PrivacySettings_Request extends $pb.GeneratedMessage {
  factory PrivacySettings_Request() => create();

  PrivacySettings_Request._();

  factory PrivacySettings_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacySettings_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacySettings.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettings_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettings_Request copyWith(void Function(PrivacySettings_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacySettings_Request)) as PrivacySettings_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacySettings_Request create() => PrivacySettings_Request._();
  @$core.override
  PrivacySettings_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacySettings_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacySettings_Request>(create);
  static PrivacySettings_Request? _defaultInstance;
}

class PrivacySettings_Response extends $pb.GeneratedMessage {
  factory PrivacySettings_Response({
    PrivacySettings_Audience? calls,
  }) {
    final result = create();
    if (calls != null) result.calls = calls;
    return result;
  }

  PrivacySettings_Response._();

  factory PrivacySettings_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacySettings_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacySettings.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<PrivacySettings_Audience>(1, _omitFieldNames ? '' : 'calls', enumValues: PrivacySettings_Audience.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettings_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettings_Response copyWith(void Function(PrivacySettings_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacySettings_Response)) as PrivacySettings_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacySettings_Response create() => PrivacySettings_Response._();
  @$core.override
  PrivacySettings_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacySettings_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacySettings_Response>(create);
  static PrivacySettings_Response? _defaultInstance;

  @$pb.TagNumber(1)
  PrivacySettings_Audience get calls => $_getN(0);
  @$pb.TagNumber(1)
  set calls(PrivacySettings_Audience value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCalls() => $_has(0);
  @$pb.TagNumber(1)
  void clearCalls() => $_clearField(1);
}

/// Настройки приватности per-channel (этап 1 — только звонки). Проверка «кто
/// может» всегда по стороне получателя. Документ настроек не материализуется до
/// первого изменения: отсутствие значения трактуется гейтом как дефолт CONTACTS.
class PrivacySettings extends $pb.GeneratedMessage {
  factory PrivacySettings() => create();

  PrivacySettings._();

  factory PrivacySettings.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacySettings.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacySettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettings copyWith(void Function(PrivacySettings) updates) =>
      super.copyWith((message) => updates(message as PrivacySettings)) as PrivacySettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacySettings create() => PrivacySettings._();
  @$core.override
  PrivacySettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacySettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacySettings>(create);
  static PrivacySettings? _defaultInstance;
}

class PrivacySettingsUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacySettingsUpdate_Request({
    PrivacySettings_Audience? calls,
  }) {
    final result = create();
    if (calls != null) result.calls = calls;
    return result;
  }

  PrivacySettingsUpdate_Request._();

  factory PrivacySettingsUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacySettingsUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacySettingsUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<PrivacySettings_Audience>(1, _omitFieldNames ? '' : 'calls', enumValues: PrivacySettings_Audience.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettingsUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettingsUpdate_Request copyWith(void Function(PrivacySettingsUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacySettingsUpdate_Request)) as PrivacySettingsUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacySettingsUpdate_Request create() => PrivacySettingsUpdate_Request._();
  @$core.override
  PrivacySettingsUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacySettingsUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacySettingsUpdate_Request>(create);
  static PrivacySettingsUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  PrivacySettings_Audience get calls => $_getN(0);
  @$pb.TagNumber(1)
  set calls(PrivacySettings_Audience value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCalls() => $_has(0);
  @$pb.TagNumber(1)
  void clearCalls() => $_clearField(1);
}

class PrivacySettingsUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacySettingsUpdate_Response() => create();

  PrivacySettingsUpdate_Response._();

  factory PrivacySettingsUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacySettingsUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacySettingsUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettingsUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettingsUpdate_Response copyWith(void Function(PrivacySettingsUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacySettingsUpdate_Response)) as PrivacySettingsUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacySettingsUpdate_Response create() => PrivacySettingsUpdate_Response._();
  @$core.override
  PrivacySettingsUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacySettingsUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacySettingsUpdate_Response>(create);
  static PrivacySettingsUpdate_Response? _defaultInstance;
}

/// Изменение настроек приватности.
class PrivacySettingsUpdate extends $pb.GeneratedMessage {
  factory PrivacySettingsUpdate() => create();

  PrivacySettingsUpdate._();

  factory PrivacySettingsUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacySettingsUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacySettingsUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettingsUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacySettingsUpdate copyWith(void Function(PrivacySettingsUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacySettingsUpdate)) as PrivacySettingsUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacySettingsUpdate create() => PrivacySettingsUpdate._();
  @$core.override
  PrivacySettingsUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacySettingsUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacySettingsUpdate>(create);
  static PrivacySettingsUpdate? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
