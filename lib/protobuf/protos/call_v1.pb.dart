// This is a generated file - do not edit.
//
// Generated from protos/call_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// CallRing — лёгкий сигнал управления звонком поверх NATS/стрима, БЕЗ SDP/ICE:
/// весь медиа-сигналинг (offer/answer/candidate) LiveKit берёт на себя внутри
/// комнаты. Тип действия задаёт MessageType конверта — один CallRing на все три:
///   - CALL_RING   — «звоню тебе»: сервер релеит адресату и дёргает call-пуш
///                   (побудка). Ответа «принял» нет — звонящий видит подключение
///                   абонента как ParticipantConnected в комнате LiveKit.
///   - CALL_HANGUP — отмена/завершение звонящим или завершение разговора.
///   - CALL_REJECT — отклонение входящего адресатом.
/// Сервер, как и раньше, аутентифицирует отправителя, перезаписывает fromUserID
/// из сессии и публикует адресату (toUserID) через NATS.
class CallRing extends $pb.GeneratedMessage {
  factory CallRing({
    $core.String? callId,
    $core.List<$core.int>? toUserID,
    $core.List<$core.int>? fromUserID,
    $core.bool? video,
  }) {
    final result = create();
    if (callId != null) result.callId = callId;
    if (toUserID != null) result.toUserID = toUserID;
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (video != null) result.video = video;
    return result;
  }

  CallRing._();

  factory CallRing.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CallRing.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CallRing',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callId', protoName: 'callId')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'toUserID', $pb.PbFieldType.OY, protoName: 'toUserID')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'fromUserID', $pb.PbFieldType.OY, protoName: 'fromUserID')
    ..aOB(4, _omitFieldNames ? '' : 'video')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallRing clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallRing copyWith(void Function(CallRing) updates) => super.copyWith((message) => updates(message as CallRing)) as CallRing;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallRing create() => CallRing._();
  @$core.override
  CallRing createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CallRing getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallRing>(create);
  static CallRing? _defaultInstance;

  /// callId — идентификатор звонка (генерит звонящий), одинаков для обеих
  /// сторон; становится именем комнаты LiveKit. Приёмник дедупит сигналы по нему.
  @$pb.TagNumber(1)
  $core.String get callId => $_getSZ(0);
  @$pb.TagNumber(1)
  set callId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallId() => $_clearField(1);

  /// toUserID — адресат (bson.ObjectID, 12 байт). Кому релеим.
  @$pb.TagNumber(2)
  $core.List<$core.int> get toUserID => $_getN(1);
  @$pb.TagNumber(2)
  set toUserID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserID() => $_clearField(2);

  /// fromUserID — отправитель. Проставляет СЕРВЕР из сессии; клиентское значение
  /// игнорируется и перезаписывается.
  @$pb.TagNumber(3)
  $core.List<$core.int> get fromUserID => $_getN(2);
  @$pb.TagNumber(3)
  set fromUserID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromUserID() => $_clearField(3);

  /// video — видеозвонок? Значимо для CALL_RING (тип входящего экрана/пуша);
  /// для HANGUP/REJECT игнорируется.
  @$pb.TagNumber(4)
  $core.bool get video => $_getBF(3);
  @$pb.TagNumber(4)
  set video($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVideo() => $_has(3);
  @$pb.TagNumber(4)
  void clearVideo() => $_clearField(4);
}

class CallToken_Request extends $pb.GeneratedMessage {
  factory CallToken_Request({
    $core.String? callId,
    $core.List<$core.int>? toUserID,
  }) {
    final result = create();
    if (callId != null) result.callId = callId;
    if (toUserID != null) result.toUserID = toUserID;
    return result;
  }

  CallToken_Request._();

  factory CallToken_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CallToken_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CallToken.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callId', protoName: 'callId')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'toUserID', $pb.PbFieldType.OY, protoName: 'toUserID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallToken_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallToken_Request copyWith(void Function(CallToken_Request) updates) =>
      super.copyWith((message) => updates(message as CallToken_Request)) as CallToken_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallToken_Request create() => CallToken_Request._();
  @$core.override
  CallToken_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CallToken_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallToken_Request>(create);
  static CallToken_Request? _defaultInstance;

  /// callId — идентификатор звонка (генерит звонящий), одинаков для обеих
  /// сторон; становится именем комнаты LiveKit.
  @$pb.TagNumber(1)
  $core.String get callId => $_getSZ(0);
  @$pb.TagNumber(1)
  set callId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallId() => $_clearField(1);

  /// toUserID — адресат (bson.ObjectID, 12 байт). Для проверки права звонить.
  @$pb.TagNumber(2)
  $core.List<$core.int> get toUserID => $_getN(1);
  @$pb.TagNumber(2)
  set toUserID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserID() => $_clearField(2);
}

class CallToken_Response extends $pb.GeneratedMessage {
  factory CallToken_Response({
    $core.String? url,
    $core.String? token,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (token != null) result.token = token;
    return result;
  }

  CallToken_Response._();

  factory CallToken_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CallToken_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CallToken.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallToken_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallToken_Response copyWith(void Function(CallToken_Response) updates) =>
      super.copyWith((message) => updates(message as CallToken_Response)) as CallToken_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallToken_Response create() => CallToken_Response._();
  @$core.override
  CallToken_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CallToken_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallToken_Response>(create);
  static CallToken_Response? _defaultInstance;

  /// url — wss-адрес LiveKit-сервера, к которому подключается клиент.
  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  /// token — LiveKit JWT для Room.connect.
  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);
}

/// CallToken — выдача доступа в комнату LiveKit SFU. Клиент запрашивает
/// шифрованным unary-типом CALL_TOKEN перед подключением к звонку (и звонящий,
/// и принимающий). Сервер чеканит LiveKit JWT: room = callId, identity =
/// userID hex сессии, гранты join/publish/subscribe. Секрет LiveKit
/// (api-secret) живёт только на сервере. Заменяет ручной SDP/ICE-сигналинг:
/// весь offer/answer/ICE-обмен LiveKit берёт на себя.
class CallToken extends $pb.GeneratedMessage {
  factory CallToken() => create();

  CallToken._();

  factory CallToken.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CallToken.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CallToken',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallToken clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CallToken copyWith(void Function(CallToken) updates) => super.copyWith((message) => updates(message as CallToken)) as CallToken;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CallToken create() => CallToken._();
  @$core.override
  CallToken createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CallToken getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CallToken>(create);
  static CallToken? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
