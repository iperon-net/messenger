// This is a generated file - do not edit.
//
// Generated from protos/presence_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Presence_Request extends $pb.GeneratedMessage {
  factory Presence_Request({
    $core.Iterable<$core.List<$core.int>>? userIDs,
  }) {
    final result = create();
    if (userIDs != null) result.userIDs.addAll(userIDs);
    return result;
  }

  Presence_Request._();

  factory Presence_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Presence_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Presence.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userIDs', $pb.PbFieldType.PY, protoName: 'userIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence_Request copyWith(void Function(Presence_Request) updates) =>
      super.copyWith((message) => updates(message as Presence_Request)) as Presence_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Presence_Request create() => Presence_Request._();
  @$core.override
  Presence_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Presence_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Presence_Request>(create);
  static Presence_Request? _defaultInstance;

  /// userID контактов (сырые байты ObjectID), по которым спрашиваем статус.
  @$pb.TagNumber(1)
  $pb.PbList<$core.List<$core.int>> get userIDs => $_getList(0);
}

class Presence_Item extends $pb.GeneratedMessage {
  factory Presence_Item({
    $core.List<$core.int>? userID,
    $core.bool? online,
    $fixnum.Int64? lastSeen,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (online != null) result.online = online;
    if (lastSeen != null) result.lastSeen = lastSeen;
    return result;
  }

  Presence_Item._();

  factory Presence_Item.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Presence_Item.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Presence.Item',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOB(2, _omitFieldNames ? '' : 'online')
    ..aInt64(3, _omitFieldNames ? '' : 'lastSeen', protoName: 'lastSeen')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence_Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence_Item copyWith(void Function(Presence_Item) updates) =>
      super.copyWith((message) => updates(message as Presence_Item)) as Presence_Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Presence_Item create() => Presence_Item._();
  @$core.override
  Presence_Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Presence_Item getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Presence_Item>(create);
  static Presence_Item? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  /// Сейчас онлайн (открыт персистентный Stream = приложение в foreground).
  @$pb.TagNumber(2)
  $core.bool get online => $_getBF(1);
  @$pb.TagNumber(2)
  set online($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOnline() => $_has(1);
  @$pb.TagNumber(2)
  void clearOnline() => $_clearField(2);

  /// Unix-время (секунды) последнего онлайна; 0 — никогда не подключался.
  @$pb.TagNumber(3)
  $fixnum.Int64 get lastSeen => $_getI64(2);
  @$pb.TagNumber(3)
  set lastSeen($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLastSeen() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastSeen() => $_clearField(3);
}

class Presence_Response extends $pb.GeneratedMessage {
  factory Presence_Response({
    $core.Iterable<Presence_Item>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  Presence_Response._();

  factory Presence_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Presence_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Presence.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Presence_Item>(1, _omitFieldNames ? '' : 'items', subBuilder: Presence_Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence_Response copyWith(void Function(Presence_Response) updates) =>
      super.copyWith((message) => updates(message as Presence_Response)) as Presence_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Presence_Response create() => Presence_Response._();
  @$core.override
  Presence_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Presence_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Presence_Response>(create);
  static Presence_Response? _defaultInstance;

  /// Только пользователи, чью видимость пропустил гейт приватности; остальные
  /// просто отсутствуют в ответе.
  @$pb.TagNumber(1)
  $pb.PbList<Presence_Item> get items => $_getList(0);
}

/// Присутствие (online / last-seen) для списка контактов. Транспорт — pull по
/// стриму (batch по userID контактов), симметрично Profile. Видимость каждого
/// целевого пользователя гейтится звонковой приватностью (ServiceContacts.CanCall
/// со стороны цели: её audience + ребро контакта) — отдельной настройки last-seen
/// на этом этапе нет.
class Presence extends $pb.GeneratedMessage {
  factory Presence() => create();

  Presence._();

  factory Presence.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Presence.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Presence',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Presence copyWith(void Function(Presence) updates) => super.copyWith((message) => updates(message as Presence)) as Presence;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Presence create() => Presence._();
  @$core.override
  Presence createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Presence getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Presence>(create);
  static Presence? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
