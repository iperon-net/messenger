// This is a generated file - do not edit.
//
// Generated from protos/notify_settings_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'notify_settings_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'notify_settings_v1.pbenum.dart';

/// Настройка одного типа чатов.
class NotifySettings_ScopeSettings extends $pb.GeneratedMessage {
  factory NotifySettings_ScopeSettings({
    $core.bool? enabled,
    $core.bool? showPreviews,
    $core.bool? sound,
  }) {
    final result = create();
    if (enabled != null) result.enabled = enabled;
    if (showPreviews != null) result.showPreviews = showPreviews;
    if (sound != null) result.sound = sound;
    return result;
  }

  NotifySettings_ScopeSettings._();

  factory NotifySettings_ScopeSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettings_ScopeSettings.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettings.ScopeSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'enabled')
    ..aOB(2, _omitFieldNames ? '' : 'showPreviews')
    ..aOB(3, _omitFieldNames ? '' : 'sound')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings_ScopeSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings_ScopeSettings copyWith(void Function(NotifySettings_ScopeSettings) updates) =>
      super.copyWith((message) => updates(message as NotifySettings_ScopeSettings)) as NotifySettings_ScopeSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettings_ScopeSettings create() => NotifySettings_ScopeSettings._();
  @$core.override
  NotifySettings_ScopeSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettings_ScopeSettings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettings_ScopeSettings>(create);
  static NotifySettings_ScopeSettings? _defaultInstance;

  /// Показывать уведомления о сообщениях.
  @$pb.TagNumber(1)
  $core.bool get enabled => $_getBF(0);
  @$pb.TagNumber(1)
  set enabled($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnabled() => $_clearField(1);

  /// Текст сообщения в уведомлении; false — только «Новое сообщение» от кого.
  @$pb.TagNumber(2)
  $core.bool get showPreviews => $_getBF(1);
  @$pb.TagNumber(2)
  set showPreviews($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShowPreviews() => $_has(1);
  @$pb.TagNumber(2)
  void clearShowPreviews() => $_clearField(2);

  /// Со звуком; false — тихое уведомление.
  @$pb.TagNumber(3)
  $core.bool get sound => $_getBF(2);
  @$pb.TagNumber(3)
  set sound($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSound() => $_has(2);
  @$pb.TagNumber(3)
  void clearSound() => $_clearField(3);
}

/// Уведомления о реакциях на мои сообщения (как в Telegram). В каналах
/// реакции анонимные — о них не уведомляем.
class NotifySettings_ReactionsSettings extends $pb.GeneratedMessage {
  factory NotifySettings_ReactionsSettings({
    $core.bool? privateChats,
    $core.bool? groups,
    NotifySettings_ReactionsFrom? from,
  }) {
    final result = create();
    if (privateChats != null) result.privateChats = privateChats;
    if (groups != null) result.groups = groups;
    if (from != null) result.from = from;
    return result;
  }

  NotifySettings_ReactionsSettings._();

  factory NotifySettings_ReactionsSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettings_ReactionsSettings.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettings.ReactionsSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'privateChats')
    ..aOB(2, _omitFieldNames ? '' : 'groups')
    ..aE<NotifySettings_ReactionsFrom>(3, _omitFieldNames ? '' : 'from', enumValues: NotifySettings_ReactionsFrom.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings_ReactionsSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings_ReactionsSettings copyWith(void Function(NotifySettings_ReactionsSettings) updates) =>
      super.copyWith((message) => updates(message as NotifySettings_ReactionsSettings)) as NotifySettings_ReactionsSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettings_ReactionsSettings create() => NotifySettings_ReactionsSettings._();
  @$core.override
  NotifySettings_ReactionsSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettings_ReactionsSettings getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettings_ReactionsSettings>(create);
  static NotifySettings_ReactionsSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get privateChats => $_getBF(0);
  @$pb.TagNumber(1)
  set privateChats($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPrivateChats() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrivateChats() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get groups => $_getBF(1);
  @$pb.TagNumber(2)
  set groups($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGroups() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroups() => $_clearField(2);

  @$pb.TagNumber(3)
  NotifySettings_ReactionsFrom get from => $_getN(2);
  @$pb.TagNumber(3)
  set from(NotifySettings_ReactionsFrom value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);
}

/// Чтение текущих настроек (ответ — снимок; тот же снимок сервер рассылает
/// по стриму на устройства пользователя после каждого изменения).
class NotifySettings_Request extends $pb.GeneratedMessage {
  factory NotifySettings_Request() => create();

  NotifySettings_Request._();

  factory NotifySettings_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettings_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettings.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings_Request copyWith(void Function(NotifySettings_Request) updates) =>
      super.copyWith((message) => updates(message as NotifySettings_Request)) as NotifySettings_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettings_Request create() => NotifySettings_Request._();
  @$core.override
  NotifySettings_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettings_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettings_Request>(create);
  static NotifySettings_Request? _defaultInstance;
}

class NotifySettings_Response extends $pb.GeneratedMessage {
  factory NotifySettings_Response({
    NotifySettings_ScopeSettings? privateChats,
    NotifySettings_ScopeSettings? groups,
    NotifySettings_ScopeSettings? channels,
    $core.bool? contactJoined,
    $core.bool? missedCalls,
    NotifySettings_ReactionsSettings? reactions,
  }) {
    final result = create();
    if (privateChats != null) result.privateChats = privateChats;
    if (groups != null) result.groups = groups;
    if (channels != null) result.channels = channels;
    if (contactJoined != null) result.contactJoined = contactJoined;
    if (missedCalls != null) result.missedCalls = missedCalls;
    if (reactions != null) result.reactions = reactions;
    return result;
  }

  NotifySettings_Response._();

  factory NotifySettings_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettings_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettings.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<NotifySettings_ScopeSettings>(1, _omitFieldNames ? '' : 'privateChats', subBuilder: NotifySettings_ScopeSettings.create)
    ..aOM<NotifySettings_ScopeSettings>(2, _omitFieldNames ? '' : 'groups', subBuilder: NotifySettings_ScopeSettings.create)
    ..aOM<NotifySettings_ScopeSettings>(3, _omitFieldNames ? '' : 'channels', subBuilder: NotifySettings_ScopeSettings.create)
    ..aOB(4, _omitFieldNames ? '' : 'contactJoined')
    ..aOB(5, _omitFieldNames ? '' : 'missedCalls')
    ..aOM<NotifySettings_ReactionsSettings>(6, _omitFieldNames ? '' : 'reactions', subBuilder: NotifySettings_ReactionsSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings_Response copyWith(void Function(NotifySettings_Response) updates) =>
      super.copyWith((message) => updates(message as NotifySettings_Response)) as NotifySettings_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettings_Response create() => NotifySettings_Response._();
  @$core.override
  NotifySettings_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettings_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettings_Response>(create);
  static NotifySettings_Response? _defaultInstance;

  @$pb.TagNumber(1)
  NotifySettings_ScopeSettings get privateChats => $_getN(0);
  @$pb.TagNumber(1)
  set privateChats(NotifySettings_ScopeSettings value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrivateChats() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrivateChats() => $_clearField(1);
  @$pb.TagNumber(1)
  NotifySettings_ScopeSettings ensurePrivateChats() => $_ensure(0);

  @$pb.TagNumber(2)
  NotifySettings_ScopeSettings get groups => $_getN(1);
  @$pb.TagNumber(2)
  set groups(NotifySettings_ScopeSettings value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasGroups() => $_has(1);
  @$pb.TagNumber(2)
  void clearGroups() => $_clearField(2);
  @$pb.TagNumber(2)
  NotifySettings_ScopeSettings ensureGroups() => $_ensure(1);

  @$pb.TagNumber(3)
  NotifySettings_ScopeSettings get channels => $_getN(2);
  @$pb.TagNumber(3)
  set channels(NotifySettings_ScopeSettings value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasChannels() => $_has(2);
  @$pb.TagNumber(3)
  void clearChannels() => $_clearField(3);
  @$pb.TagNumber(3)
  NotifySettings_ScopeSettings ensureChannels() => $_ensure(2);

  /// «Контакт присоединился к Iperon».
  @$pb.TagNumber(4)
  $core.bool get contactJoined => $_getBF(3);
  @$pb.TagNumber(4)
  set contactJoined($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContactJoined() => $_has(3);
  @$pb.TagNumber(4)
  void clearContactJoined() => $_clearField(4);

  /// «Пропущенный звонок».
  @$pb.TagNumber(5)
  $core.bool get missedCalls => $_getBF(4);
  @$pb.TagNumber(5)
  set missedCalls($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMissedCalls() => $_has(4);
  @$pb.TagNumber(5)
  void clearMissedCalls() => $_clearField(5);

  /// Реакции на мои сообщения; не пришло (старый кэш клиента) — дефолт:
  /// личные и группы включены, от всех.
  @$pb.TagNumber(6)
  NotifySettings_ReactionsSettings get reactions => $_getN(5);
  @$pb.TagNumber(6)
  set reactions(NotifySettings_ReactionsSettings value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReactions() => $_has(5);
  @$pb.TagNumber(6)
  void clearReactions() => $_clearField(6);
  @$pb.TagNumber(6)
  NotifySettings_ReactionsSettings ensureReactions() => $_ensure(5);
}

/// Настройки уведомлений пользователя — общие для всех его устройств (как
/// account.getNotifySettings у Telegram). Применяет сервер: воркер push-очереди
/// не шлёт выключенные типы, а без превью и звука шлёт уведомление без текста и
/// тихо. Документ не материализуется до первого изменения: отсутствие значения —
/// дефолт «всё включено». Исключения по чату (заглушить чат на время) — вместе с
/// чатами.
class NotifySettings extends $pb.GeneratedMessage {
  factory NotifySettings() => create();

  NotifySettings._();

  factory NotifySettings.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettings.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettings copyWith(void Function(NotifySettings) updates) =>
      super.copyWith((message) => updates(message as NotifySettings)) as NotifySettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettings create() => NotifySettings._();
  @$core.override
  NotifySettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettings>(create);
  static NotifySettings? _defaultInstance;
}

class NotifySettingsUpdate_ScopeChange extends $pb.GeneratedMessage {
  factory NotifySettingsUpdate_ScopeChange({
    NotifySettings_Scope? scope,
    NotifySettings_ScopeSettings? settings,
  }) {
    final result = create();
    if (scope != null) result.scope = scope;
    if (settings != null) result.settings = settings;
    return result;
  }

  NotifySettingsUpdate_ScopeChange._();

  factory NotifySettingsUpdate_ScopeChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettingsUpdate_ScopeChange.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettingsUpdate.ScopeChange',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<NotifySettings_Scope>(1, _omitFieldNames ? '' : 'scope', enumValues: NotifySettings_Scope.values)
    ..aOM<NotifySettings_ScopeSettings>(2, _omitFieldNames ? '' : 'settings', subBuilder: NotifySettings_ScopeSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettingsUpdate_ScopeChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettingsUpdate_ScopeChange copyWith(void Function(NotifySettingsUpdate_ScopeChange) updates) =>
      super.copyWith((message) => updates(message as NotifySettingsUpdate_ScopeChange)) as NotifySettingsUpdate_ScopeChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettingsUpdate_ScopeChange create() => NotifySettingsUpdate_ScopeChange._();
  @$core.override
  NotifySettingsUpdate_ScopeChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettingsUpdate_ScopeChange getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettingsUpdate_ScopeChange>(create);
  static NotifySettingsUpdate_ScopeChange? _defaultInstance;

  @$pb.TagNumber(1)
  NotifySettings_Scope get scope => $_getN(0);
  @$pb.TagNumber(1)
  set scope(NotifySettings_Scope value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScope() => $_has(0);
  @$pb.TagNumber(1)
  void clearScope() => $_clearField(1);

  @$pb.TagNumber(2)
  NotifySettings_ScopeSettings get settings => $_getN(1);
  @$pb.TagNumber(2)
  set settings(NotifySettings_ScopeSettings value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSettings() => $_has(1);
  @$pb.TagNumber(2)
  void clearSettings() => $_clearField(2);
  @$pb.TagNumber(2)
  NotifySettings_ScopeSettings ensureSettings() => $_ensure(1);
}

enum NotifySettingsUpdate_Request_Change { scope, contactJoined, missedCalls, reactions, notSet }

class NotifySettingsUpdate_Request extends $pb.GeneratedMessage {
  factory NotifySettingsUpdate_Request({
    NotifySettingsUpdate_ScopeChange? scope,
    $core.bool? contactJoined,
    $core.bool? missedCalls,
    NotifySettings_ReactionsSettings? reactions,
  }) {
    final result = create();
    if (scope != null) result.scope = scope;
    if (contactJoined != null) result.contactJoined = contactJoined;
    if (missedCalls != null) result.missedCalls = missedCalls;
    if (reactions != null) result.reactions = reactions;
    return result;
  }

  NotifySettingsUpdate_Request._();

  factory NotifySettingsUpdate_Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettingsUpdate_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, NotifySettingsUpdate_Request_Change> _NotifySettingsUpdate_Request_ChangeByTag = {
    1: NotifySettingsUpdate_Request_Change.scope,
    2: NotifySettingsUpdate_Request_Change.contactJoined,
    3: NotifySettingsUpdate_Request_Change.missedCalls,
    4: NotifySettingsUpdate_Request_Change.reactions,
    0: NotifySettingsUpdate_Request_Change.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettingsUpdate.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<NotifySettingsUpdate_ScopeChange>(1, _omitFieldNames ? '' : 'scope', subBuilder: NotifySettingsUpdate_ScopeChange.create)
    ..aOB(2, _omitFieldNames ? '' : 'contactJoined')
    ..aOB(3, _omitFieldNames ? '' : 'missedCalls')
    ..aOM<NotifySettings_ReactionsSettings>(4, _omitFieldNames ? '' : 'reactions', subBuilder: NotifySettings_ReactionsSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettingsUpdate_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettingsUpdate_Request copyWith(void Function(NotifySettingsUpdate_Request) updates) =>
      super.copyWith((message) => updates(message as NotifySettingsUpdate_Request)) as NotifySettingsUpdate_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettingsUpdate_Request create() => NotifySettingsUpdate_Request._();
  @$core.override
  NotifySettingsUpdate_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettingsUpdate_Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettingsUpdate_Request>(create);
  static NotifySettingsUpdate_Request? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  NotifySettingsUpdate_Request_Change whichChange() => _NotifySettingsUpdate_Request_ChangeByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearChange() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  NotifySettingsUpdate_ScopeChange get scope => $_getN(0);
  @$pb.TagNumber(1)
  set scope(NotifySettingsUpdate_ScopeChange value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScope() => $_has(0);
  @$pb.TagNumber(1)
  void clearScope() => $_clearField(1);
  @$pb.TagNumber(1)
  NotifySettingsUpdate_ScopeChange ensureScope() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get contactJoined => $_getBF(1);
  @$pb.TagNumber(2)
  set contactJoined($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContactJoined() => $_has(1);
  @$pb.TagNumber(2)
  void clearContactJoined() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get missedCalls => $_getBF(2);
  @$pb.TagNumber(3)
  set missedCalls($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMissedCalls() => $_has(2);
  @$pb.TagNumber(3)
  void clearMissedCalls() => $_clearField(3);

  /// Настройка реакций целиком (как ScopeChange).
  @$pb.TagNumber(4)
  NotifySettings_ReactionsSettings get reactions => $_getN(3);
  @$pb.TagNumber(4)
  set reactions(NotifySettings_ReactionsSettings value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReactions() => $_has(3);
  @$pb.TagNumber(4)
  void clearReactions() => $_clearField(4);
  @$pb.TagNumber(4)
  NotifySettings_ReactionsSettings ensureReactions() => $_ensure(3);
}

class NotifySettingsUpdate_Response extends $pb.GeneratedMessage {
  factory NotifySettingsUpdate_Response() => create();

  NotifySettingsUpdate_Response._();

  factory NotifySettingsUpdate_Response.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettingsUpdate_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettingsUpdate.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettingsUpdate_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettingsUpdate_Response copyWith(void Function(NotifySettingsUpdate_Response) updates) =>
      super.copyWith((message) => updates(message as NotifySettingsUpdate_Response)) as NotifySettingsUpdate_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettingsUpdate_Response create() => NotifySettingsUpdate_Response._();
  @$core.override
  NotifySettingsUpdate_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettingsUpdate_Response getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettingsUpdate_Response>(create);
  static NotifySettingsUpdate_Response? _defaultInstance;
}

/// Изменение одной настройки. Одна настройка за запрос — правки с двух устройств
/// не затирают друг друга целиком.
class NotifySettingsUpdate extends $pb.GeneratedMessage {
  factory NotifySettingsUpdate() => create();

  NotifySettingsUpdate._();

  factory NotifySettingsUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifySettingsUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifySettingsUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettingsUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifySettingsUpdate copyWith(void Function(NotifySettingsUpdate) updates) =>
      super.copyWith((message) => updates(message as NotifySettingsUpdate)) as NotifySettingsUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifySettingsUpdate create() => NotifySettingsUpdate._();
  @$core.override
  NotifySettingsUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifySettingsUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifySettingsUpdate>(create);
  static NotifySettingsUpdate? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
