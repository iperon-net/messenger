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
    $core.Iterable<$core.List<$core.int>>? callsAllow,
    $core.Iterable<$core.List<$core.int>>? callsDeny,
    PrivacySettings_Audience? birthday,
    $core.Iterable<$core.List<$core.int>>? birthdayAllow,
    $core.Iterable<$core.List<$core.int>>? birthdayDeny,
    $core.bool? hideBirthYear,
    PrivacySettings_Audience? aboutMe,
    $core.Iterable<$core.List<$core.int>>? aboutMeAllow,
    $core.Iterable<$core.List<$core.int>>? aboutMeDeny,
  }) {
    final result = create();
    if (calls != null) result.calls = calls;
    if (callsAllow != null) result.callsAllow.addAll(callsAllow);
    if (callsDeny != null) result.callsDeny.addAll(callsDeny);
    if (birthday != null) result.birthday = birthday;
    if (birthdayAllow != null) result.birthdayAllow.addAll(birthdayAllow);
    if (birthdayDeny != null) result.birthdayDeny.addAll(birthdayDeny);
    if (hideBirthYear != null) result.hideBirthYear = hideBirthYear;
    if (aboutMe != null) result.aboutMe = aboutMe;
    if (aboutMeAllow != null) result.aboutMeAllow.addAll(aboutMeAllow);
    if (aboutMeDeny != null) result.aboutMeDeny.addAll(aboutMeDeny);
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
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'callsAllow', $pb.PbFieldType.PY)
    ..p<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'callsDeny', $pb.PbFieldType.PY)
    ..aE<PrivacySettings_Audience>(4, _omitFieldNames ? '' : 'birthday', enumValues: PrivacySettings_Audience.values)
    ..p<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'birthdayAllow', $pb.PbFieldType.PY)
    ..p<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'birthdayDeny', $pb.PbFieldType.PY)
    ..aOB(7, _omitFieldNames ? '' : 'hideBirthYear')
    ..aE<PrivacySettings_Audience>(8, _omitFieldNames ? '' : 'aboutMe', enumValues: PrivacySettings_Audience.values)
    ..p<$core.List<$core.int>>(9, _omitFieldNames ? '' : 'aboutMeAllow', $pb.PbFieldType.PY)
    ..p<$core.List<$core.int>>(10, _omitFieldNames ? '' : 'aboutMeDeny', $pb.PbFieldType.PY)
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

  /// Allow-list «всегда разрешать» для звонков: userID (ObjectID, 12 байт),
  /// которым звонок разрешён независимо от `calls` (в т.ч. при NOBODY).
  @$pb.TagNumber(2)
  $pb.PbList<$core.List<$core.int>> get callsAllow => $_getList(1);

  /// Deny-list «всегда запрещать» для звонков: userID (ObjectID, 12 байт),
  /// которым звонок запрещён независимо от `calls` (в т.ч. при CONTACTS).
  @$pb.TagNumber(3)
  $pb.PbList<$core.List<$core.int>> get callsDeny => $_getList(2);

  /// Аудитория «кто может видеть мою дату рождения» + её allow/deny-списки
  /// (та же семантика, что у звонков). Гейт применяется на стороне владельца
  /// профиля при отдаче Profile.Response.
  @$pb.TagNumber(4)
  PrivacySettings_Audience get birthday => $_getN(3);
  @$pb.TagNumber(4)
  set birthday(PrivacySettings_Audience value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBirthday() => $_has(3);
  @$pb.TagNumber(4)
  void clearBirthday() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.List<$core.int>> get birthdayAllow => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<$core.List<$core.int>> get birthdayDeny => $_getList(5);

  /// Скрывать год рождения (и возраст) от тех, кому дата рождения видна: сервер
  /// отдаёт им дату с обнулённым годом (sentinel) и Profile.hide_birth_year=true.
  @$pb.TagNumber(7)
  $core.bool get hideBirthYear => $_getBF(6);
  @$pb.TagNumber(7)
  set hideBirthYear($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHideBirthYear() => $_has(6);
  @$pb.TagNumber(7)
  void clearHideBirthYear() => $_clearField(7);

  /// Аудитория «кто может видеть моё „О себе“» + её allow/deny-списки (та же
  /// семантика, что у звонков/дня рождения). Гейт применяется на стороне
  /// владельца профиля: не разрешено — aboutMe в Profile.Response не отдаётся.
  @$pb.TagNumber(8)
  PrivacySettings_Audience get aboutMe => $_getN(7);
  @$pb.TagNumber(8)
  set aboutMe(PrivacySettings_Audience value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAboutMe() => $_has(7);
  @$pb.TagNumber(8)
  void clearAboutMe() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.List<$core.int>> get aboutMeAllow => $_getList(8);

  @$pb.TagNumber(10)
  $pb.PbList<$core.List<$core.int>> get aboutMeDeny => $_getList(9);
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

/// Изменение аудитории «кто может звонить».
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

class PrivacyCallsAllowUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyCallsAllowUpdate_Request({
    $core.Iterable<$core.List<$core.int>>? userIds,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  PrivacyCallsAllowUpdate_Request._();

  factory PrivacyCallsAllowUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyCallsAllowUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyCallsAllowUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userIds', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsAllowUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsAllowUpdate_Request copyWith(void Function(PrivacyCallsAllowUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyCallsAllowUpdate_Request)) as PrivacyCallsAllowUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyCallsAllowUpdate_Request create() => PrivacyCallsAllowUpdate_Request._();
  @$core.override
  PrivacyCallsAllowUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyCallsAllowUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyCallsAllowUpdate_Request>(create);
  static PrivacyCallsAllowUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get userIds => $_getList(0);
}

class PrivacyCallsAllowUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyCallsAllowUpdate_Response() => create();

  PrivacyCallsAllowUpdate_Response._();

  factory PrivacyCallsAllowUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyCallsAllowUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyCallsAllowUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsAllowUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsAllowUpdate_Response copyWith(void Function(PrivacyCallsAllowUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyCallsAllowUpdate_Response)) as PrivacyCallsAllowUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyCallsAllowUpdate_Response create() => PrivacyCallsAllowUpdate_Response._();
  @$core.override
  PrivacyCallsAllowUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyCallsAllowUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyCallsAllowUpdate_Response>(create);
  static PrivacyCallsAllowUpdate_Response? _defaultInstance;
}

/// Полная замена allow-list «всегда разрешать» для звонков.
class PrivacyCallsAllowUpdate extends $pb.GeneratedMessage {
  factory PrivacyCallsAllowUpdate() => create();

  PrivacyCallsAllowUpdate._();

  factory PrivacyCallsAllowUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyCallsAllowUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyCallsAllowUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsAllowUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsAllowUpdate copyWith(void Function(PrivacyCallsAllowUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyCallsAllowUpdate)) as PrivacyCallsAllowUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyCallsAllowUpdate create() => PrivacyCallsAllowUpdate._();
  @$core.override
  PrivacyCallsAllowUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyCallsAllowUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyCallsAllowUpdate>(create);
  static PrivacyCallsAllowUpdate? _defaultInstance;
}

class PrivacyCallsDenyUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyCallsDenyUpdate_Request({
    $core.Iterable<$core.List<$core.int>>? userIds,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  PrivacyCallsDenyUpdate_Request._();

  factory PrivacyCallsDenyUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyCallsDenyUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyCallsDenyUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userIds', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsDenyUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsDenyUpdate_Request copyWith(void Function(PrivacyCallsDenyUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyCallsDenyUpdate_Request)) as PrivacyCallsDenyUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyCallsDenyUpdate_Request create() => PrivacyCallsDenyUpdate_Request._();
  @$core.override
  PrivacyCallsDenyUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyCallsDenyUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyCallsDenyUpdate_Request>(create);
  static PrivacyCallsDenyUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get userIds => $_getList(0);
}

class PrivacyCallsDenyUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyCallsDenyUpdate_Response() => create();

  PrivacyCallsDenyUpdate_Response._();

  factory PrivacyCallsDenyUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyCallsDenyUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyCallsDenyUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsDenyUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsDenyUpdate_Response copyWith(void Function(PrivacyCallsDenyUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyCallsDenyUpdate_Response)) as PrivacyCallsDenyUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyCallsDenyUpdate_Response create() => PrivacyCallsDenyUpdate_Response._();
  @$core.override
  PrivacyCallsDenyUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyCallsDenyUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyCallsDenyUpdate_Response>(create);
  static PrivacyCallsDenyUpdate_Response? _defaultInstance;
}

/// Полная замена deny-list «всегда запрещать» для звонков.
class PrivacyCallsDenyUpdate extends $pb.GeneratedMessage {
  factory PrivacyCallsDenyUpdate() => create();

  PrivacyCallsDenyUpdate._();

  factory PrivacyCallsDenyUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyCallsDenyUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyCallsDenyUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsDenyUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyCallsDenyUpdate copyWith(void Function(PrivacyCallsDenyUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyCallsDenyUpdate)) as PrivacyCallsDenyUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyCallsDenyUpdate create() => PrivacyCallsDenyUpdate._();
  @$core.override
  PrivacyCallsDenyUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyCallsDenyUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyCallsDenyUpdate>(create);
  static PrivacyCallsDenyUpdate? _defaultInstance;
}

class PrivacyBirthdayUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyBirthdayUpdate_Request({
    PrivacySettings_Audience? birthday,
  }) {
    final result = create();
    if (birthday != null) result.birthday = birthday;
    return result;
  }

  PrivacyBirthdayUpdate_Request._();

  factory PrivacyBirthdayUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<PrivacySettings_Audience>(1, _omitFieldNames ? '' : 'birthday', enumValues: PrivacySettings_Audience.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayUpdate_Request copyWith(void Function(PrivacyBirthdayUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayUpdate_Request)) as PrivacyBirthdayUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayUpdate_Request create() => PrivacyBirthdayUpdate_Request._();
  @$core.override
  PrivacyBirthdayUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayUpdate_Request>(create);
  static PrivacyBirthdayUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  PrivacySettings_Audience get birthday => $_getN(0);
  @$pb.TagNumber(1)
  set birthday(PrivacySettings_Audience value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBirthday() => $_has(0);
  @$pb.TagNumber(1)
  void clearBirthday() => $_clearField(1);
}

class PrivacyBirthdayUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyBirthdayUpdate_Response() => create();

  PrivacyBirthdayUpdate_Response._();

  factory PrivacyBirthdayUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayUpdate_Response copyWith(void Function(PrivacyBirthdayUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayUpdate_Response)) as PrivacyBirthdayUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayUpdate_Response create() => PrivacyBirthdayUpdate_Response._();
  @$core.override
  PrivacyBirthdayUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayUpdate_Response>(create);
  static PrivacyBirthdayUpdate_Response? _defaultInstance;
}

/// Изменение аудитории «кто может видеть мою дату рождения».
class PrivacyBirthdayUpdate extends $pb.GeneratedMessage {
  factory PrivacyBirthdayUpdate() => create();

  PrivacyBirthdayUpdate._();

  factory PrivacyBirthdayUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayUpdate copyWith(void Function(PrivacyBirthdayUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayUpdate)) as PrivacyBirthdayUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayUpdate create() => PrivacyBirthdayUpdate._();
  @$core.override
  PrivacyBirthdayUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayUpdate>(create);
  static PrivacyBirthdayUpdate? _defaultInstance;
}

class PrivacyBirthdayAllowUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyBirthdayAllowUpdate_Request({
    $core.Iterable<$core.List<$core.int>>? userIds,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  PrivacyBirthdayAllowUpdate_Request._();

  factory PrivacyBirthdayAllowUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayAllowUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayAllowUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userIds', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayAllowUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayAllowUpdate_Request copyWith(void Function(PrivacyBirthdayAllowUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayAllowUpdate_Request)) as PrivacyBirthdayAllowUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayAllowUpdate_Request create() => PrivacyBirthdayAllowUpdate_Request._();
  @$core.override
  PrivacyBirthdayAllowUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayAllowUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayAllowUpdate_Request>(create);
  static PrivacyBirthdayAllowUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get userIds => $_getList(0);
}

class PrivacyBirthdayAllowUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyBirthdayAllowUpdate_Response() => create();

  PrivacyBirthdayAllowUpdate_Response._();

  factory PrivacyBirthdayAllowUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayAllowUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayAllowUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayAllowUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayAllowUpdate_Response copyWith(void Function(PrivacyBirthdayAllowUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayAllowUpdate_Response)) as PrivacyBirthdayAllowUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayAllowUpdate_Response create() => PrivacyBirthdayAllowUpdate_Response._();
  @$core.override
  PrivacyBirthdayAllowUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayAllowUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayAllowUpdate_Response>(create);
  static PrivacyBirthdayAllowUpdate_Response? _defaultInstance;
}

/// Полная замена allow-list «всегда разрешать» для дня рождения.
class PrivacyBirthdayAllowUpdate extends $pb.GeneratedMessage {
  factory PrivacyBirthdayAllowUpdate() => create();

  PrivacyBirthdayAllowUpdate._();

  factory PrivacyBirthdayAllowUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayAllowUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayAllowUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayAllowUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayAllowUpdate copyWith(void Function(PrivacyBirthdayAllowUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayAllowUpdate)) as PrivacyBirthdayAllowUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayAllowUpdate create() => PrivacyBirthdayAllowUpdate._();
  @$core.override
  PrivacyBirthdayAllowUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayAllowUpdate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayAllowUpdate>(create);
  static PrivacyBirthdayAllowUpdate? _defaultInstance;
}

class PrivacyBirthdayDenyUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyBirthdayDenyUpdate_Request({
    $core.Iterable<$core.List<$core.int>>? userIds,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  PrivacyBirthdayDenyUpdate_Request._();

  factory PrivacyBirthdayDenyUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayDenyUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayDenyUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userIds', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayDenyUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayDenyUpdate_Request copyWith(void Function(PrivacyBirthdayDenyUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayDenyUpdate_Request)) as PrivacyBirthdayDenyUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayDenyUpdate_Request create() => PrivacyBirthdayDenyUpdate_Request._();
  @$core.override
  PrivacyBirthdayDenyUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayDenyUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayDenyUpdate_Request>(create);
  static PrivacyBirthdayDenyUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get userIds => $_getList(0);
}

class PrivacyBirthdayDenyUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyBirthdayDenyUpdate_Response() => create();

  PrivacyBirthdayDenyUpdate_Response._();

  factory PrivacyBirthdayDenyUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayDenyUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayDenyUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayDenyUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayDenyUpdate_Response copyWith(void Function(PrivacyBirthdayDenyUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayDenyUpdate_Response)) as PrivacyBirthdayDenyUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayDenyUpdate_Response create() => PrivacyBirthdayDenyUpdate_Response._();
  @$core.override
  PrivacyBirthdayDenyUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayDenyUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayDenyUpdate_Response>(create);
  static PrivacyBirthdayDenyUpdate_Response? _defaultInstance;
}

/// Полная замена deny-list «всегда запрещать» для дня рождения.
class PrivacyBirthdayDenyUpdate extends $pb.GeneratedMessage {
  factory PrivacyBirthdayDenyUpdate() => create();

  PrivacyBirthdayDenyUpdate._();

  factory PrivacyBirthdayDenyUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyBirthdayDenyUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyBirthdayDenyUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayDenyUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyBirthdayDenyUpdate copyWith(void Function(PrivacyBirthdayDenyUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyBirthdayDenyUpdate)) as PrivacyBirthdayDenyUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayDenyUpdate create() => PrivacyBirthdayDenyUpdate._();
  @$core.override
  PrivacyBirthdayDenyUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyBirthdayDenyUpdate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyBirthdayDenyUpdate>(create);
  static PrivacyBirthdayDenyUpdate? _defaultInstance;
}

class PrivacyHideBirthYearUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyHideBirthYearUpdate_Request({
    $core.bool? hide,
  }) {
    final result = create();
    if (hide != null) result.hide = hide;
    return result;
  }

  PrivacyHideBirthYearUpdate_Request._();

  factory PrivacyHideBirthYearUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyHideBirthYearUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyHideBirthYearUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'hide')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyHideBirthYearUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyHideBirthYearUpdate_Request copyWith(void Function(PrivacyHideBirthYearUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyHideBirthYearUpdate_Request)) as PrivacyHideBirthYearUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyHideBirthYearUpdate_Request create() => PrivacyHideBirthYearUpdate_Request._();
  @$core.override
  PrivacyHideBirthYearUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyHideBirthYearUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyHideBirthYearUpdate_Request>(create);
  static PrivacyHideBirthYearUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get hide => $_getBF(0);
  @$pb.TagNumber(1)
  set hide($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHide() => $_has(0);
  @$pb.TagNumber(1)
  void clearHide() => $_clearField(1);
}

class PrivacyHideBirthYearUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyHideBirthYearUpdate_Response() => create();

  PrivacyHideBirthYearUpdate_Response._();

  factory PrivacyHideBirthYearUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyHideBirthYearUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyHideBirthYearUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyHideBirthYearUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyHideBirthYearUpdate_Response copyWith(void Function(PrivacyHideBirthYearUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyHideBirthYearUpdate_Response)) as PrivacyHideBirthYearUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyHideBirthYearUpdate_Response create() => PrivacyHideBirthYearUpdate_Response._();
  @$core.override
  PrivacyHideBirthYearUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyHideBirthYearUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyHideBirthYearUpdate_Response>(create);
  static PrivacyHideBirthYearUpdate_Response? _defaultInstance;
}

/// Переключение «скрывать год рождения и возраст».
class PrivacyHideBirthYearUpdate extends $pb.GeneratedMessage {
  factory PrivacyHideBirthYearUpdate() => create();

  PrivacyHideBirthYearUpdate._();

  factory PrivacyHideBirthYearUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyHideBirthYearUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyHideBirthYearUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyHideBirthYearUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyHideBirthYearUpdate copyWith(void Function(PrivacyHideBirthYearUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyHideBirthYearUpdate)) as PrivacyHideBirthYearUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyHideBirthYearUpdate create() => PrivacyHideBirthYearUpdate._();
  @$core.override
  PrivacyHideBirthYearUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyHideBirthYearUpdate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyHideBirthYearUpdate>(create);
  static PrivacyHideBirthYearUpdate? _defaultInstance;
}

class PrivacyAboutMeUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyAboutMeUpdate_Request({
    PrivacySettings_Audience? aboutMe,
  }) {
    final result = create();
    if (aboutMe != null) result.aboutMe = aboutMe;
    return result;
  }

  PrivacyAboutMeUpdate_Request._();

  factory PrivacyAboutMeUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<PrivacySettings_Audience>(1, _omitFieldNames ? '' : 'aboutMe', enumValues: PrivacySettings_Audience.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeUpdate_Request copyWith(void Function(PrivacyAboutMeUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeUpdate_Request)) as PrivacyAboutMeUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeUpdate_Request create() => PrivacyAboutMeUpdate_Request._();
  @$core.override
  PrivacyAboutMeUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeUpdate_Request>(create);
  static PrivacyAboutMeUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  PrivacySettings_Audience get aboutMe => $_getN(0);
  @$pb.TagNumber(1)
  set aboutMe(PrivacySettings_Audience value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAboutMe() => $_has(0);
  @$pb.TagNumber(1)
  void clearAboutMe() => $_clearField(1);
}

class PrivacyAboutMeUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyAboutMeUpdate_Response() => create();

  PrivacyAboutMeUpdate_Response._();

  factory PrivacyAboutMeUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeUpdate_Response copyWith(void Function(PrivacyAboutMeUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeUpdate_Response)) as PrivacyAboutMeUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeUpdate_Response create() => PrivacyAboutMeUpdate_Response._();
  @$core.override
  PrivacyAboutMeUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeUpdate_Response>(create);
  static PrivacyAboutMeUpdate_Response? _defaultInstance;
}

/// Изменение аудитории «кто может видеть моё „О себе“».
class PrivacyAboutMeUpdate extends $pb.GeneratedMessage {
  factory PrivacyAboutMeUpdate() => create();

  PrivacyAboutMeUpdate._();

  factory PrivacyAboutMeUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeUpdate copyWith(void Function(PrivacyAboutMeUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeUpdate)) as PrivacyAboutMeUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeUpdate create() => PrivacyAboutMeUpdate._();
  @$core.override
  PrivacyAboutMeUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeUpdate>(create);
  static PrivacyAboutMeUpdate? _defaultInstance;
}

class PrivacyAboutMeAllowUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyAboutMeAllowUpdate_Request({
    $core.Iterable<$core.List<$core.int>>? userIds,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  PrivacyAboutMeAllowUpdate_Request._();

  factory PrivacyAboutMeAllowUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeAllowUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeAllowUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userIds', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeAllowUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeAllowUpdate_Request copyWith(void Function(PrivacyAboutMeAllowUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeAllowUpdate_Request)) as PrivacyAboutMeAllowUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeAllowUpdate_Request create() => PrivacyAboutMeAllowUpdate_Request._();
  @$core.override
  PrivacyAboutMeAllowUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeAllowUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeAllowUpdate_Request>(create);
  static PrivacyAboutMeAllowUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get userIds => $_getList(0);
}

class PrivacyAboutMeAllowUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyAboutMeAllowUpdate_Response() => create();

  PrivacyAboutMeAllowUpdate_Response._();

  factory PrivacyAboutMeAllowUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeAllowUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeAllowUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeAllowUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeAllowUpdate_Response copyWith(void Function(PrivacyAboutMeAllowUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeAllowUpdate_Response)) as PrivacyAboutMeAllowUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeAllowUpdate_Response create() => PrivacyAboutMeAllowUpdate_Response._();
  @$core.override
  PrivacyAboutMeAllowUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeAllowUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeAllowUpdate_Response>(create);
  static PrivacyAboutMeAllowUpdate_Response? _defaultInstance;
}

/// Полная замена allow-list «всегда разрешать» для «О себе».
class PrivacyAboutMeAllowUpdate extends $pb.GeneratedMessage {
  factory PrivacyAboutMeAllowUpdate() => create();

  PrivacyAboutMeAllowUpdate._();

  factory PrivacyAboutMeAllowUpdate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeAllowUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeAllowUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeAllowUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeAllowUpdate copyWith(void Function(PrivacyAboutMeAllowUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeAllowUpdate)) as PrivacyAboutMeAllowUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeAllowUpdate create() => PrivacyAboutMeAllowUpdate._();
  @$core.override
  PrivacyAboutMeAllowUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeAllowUpdate getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeAllowUpdate>(create);
  static PrivacyAboutMeAllowUpdate? _defaultInstance;
}

class PrivacyAboutMeDenyUpdate_Request extends $pb.GeneratedMessage {
  factory PrivacyAboutMeDenyUpdate_Request({
    $core.Iterable<$core.List<$core.int>>? userIds,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  PrivacyAboutMeDenyUpdate_Request._();

  factory PrivacyAboutMeDenyUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeDenyUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeDenyUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userIds', $pb.PbFieldType.PY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeDenyUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeDenyUpdate_Request copyWith(void Function(PrivacyAboutMeDenyUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeDenyUpdate_Request)) as PrivacyAboutMeDenyUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeDenyUpdate_Request create() => PrivacyAboutMeDenyUpdate_Request._();
  @$core.override
  PrivacyAboutMeDenyUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeDenyUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeDenyUpdate_Request>(create);
  static PrivacyAboutMeDenyUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get userIds => $_getList(0);
}

class PrivacyAboutMeDenyUpdate_Response extends $pb.GeneratedMessage {
  factory PrivacyAboutMeDenyUpdate_Response() => create();

  PrivacyAboutMeDenyUpdate_Response._();

  factory PrivacyAboutMeDenyUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeDenyUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeDenyUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeDenyUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeDenyUpdate_Response copyWith(void Function(PrivacyAboutMeDenyUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeDenyUpdate_Response)) as PrivacyAboutMeDenyUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeDenyUpdate_Response create() => PrivacyAboutMeDenyUpdate_Response._();
  @$core.override
  PrivacyAboutMeDenyUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeDenyUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeDenyUpdate_Response>(create);
  static PrivacyAboutMeDenyUpdate_Response? _defaultInstance;
}

/// Полная замена deny-list «всегда запрещать» для «О себе».
class PrivacyAboutMeDenyUpdate extends $pb.GeneratedMessage {
  factory PrivacyAboutMeDenyUpdate() => create();

  PrivacyAboutMeDenyUpdate._();

  factory PrivacyAboutMeDenyUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrivacyAboutMeDenyUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PrivacyAboutMeDenyUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeDenyUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrivacyAboutMeDenyUpdate copyWith(void Function(PrivacyAboutMeDenyUpdate) updates) =>
      super.copyWith((message) => updates(message as PrivacyAboutMeDenyUpdate)) as PrivacyAboutMeDenyUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeDenyUpdate create() => PrivacyAboutMeDenyUpdate._();
  @$core.override
  PrivacyAboutMeDenyUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrivacyAboutMeDenyUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PrivacyAboutMeDenyUpdate>(create);
  static PrivacyAboutMeDenyUpdate? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
