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

import 'call_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'call_v1.pbenum.dart';

enum Call_Signal_Body { sdp, candidate, notSet }

class Call_Signal extends $pb.GeneratedMessage {
  factory Call_Signal({
    $core.String? callId,
    $core.List<$core.int>? toUserID,
    $core.List<$core.int>? fromUserID,
    Call_Signal_CallType? callType,
    $core.String? sdp,
    Call_IceCandidate? candidate,
  }) {
    final result = create();
    if (callId != null) result.callId = callId;
    if (toUserID != null) result.toUserID = toUserID;
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (callType != null) result.callType = callType;
    if (sdp != null) result.sdp = sdp;
    if (candidate != null) result.candidate = candidate;
    return result;
  }

  Call_Signal._();

  factory Call_Signal.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Call_Signal.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Call_Signal_Body> _Call_Signal_BodyByTag = {
    5: Call_Signal_Body.sdp,
    6: Call_Signal_Body.candidate,
    0: Call_Signal_Body.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Call.Signal',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [5, 6])
    ..aOS(1, _omitFieldNames ? '' : 'callId', protoName: 'callId')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'toUserID', $pb.PbFieldType.OY, protoName: 'toUserID')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'fromUserID', $pb.PbFieldType.OY, protoName: 'fromUserID')
    ..aE<Call_Signal_CallType>(4, _omitFieldNames ? '' : 'callType', protoName: 'callType', enumValues: Call_Signal_CallType.values)
    ..aOS(5, _omitFieldNames ? '' : 'sdp')
    ..aOM<Call_IceCandidate>(6, _omitFieldNames ? '' : 'candidate', subBuilder: Call_IceCandidate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Call_Signal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Call_Signal copyWith(void Function(Call_Signal) updates) => super.copyWith((message) => updates(message as Call_Signal)) as Call_Signal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Call_Signal create() => Call_Signal._();
  @$core.override
  Call_Signal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Call_Signal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Call_Signal>(create);
  static Call_Signal? _defaultInstance;

  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  Call_Signal_Body whichBody() => _Call_Signal_BodyByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  void clearBody() => $_clearField($_whichOneof(0));

  /// callId — идентификатор звонка (генерит звонящий), одинаков для всех
  /// сигналов одного звонка. Нужен клиенту, чтобы отличать сигналы разных
  /// звонков и гасить гонки при звонке на несколько устройств.
  @$pb.TagNumber(1)
  $core.String get callId => $_getSZ(0);
  @$pb.TagNumber(1)
  set callId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallId() => $_clearField(1);

  /// toUserID — адресат (bson.ObjectID, 12 байт). Кому публикуем.
  @$pb.TagNumber(2)
  $core.List<$core.int> get toUserID => $_getN(1);
  @$pb.TagNumber(2)
  set toUserID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearToUserID() => $_clearField(2);

  /// fromUserID — отправитель. Проставляет СЕРВЕР из сессии; всё, что прислал
  /// сюда клиент, игнорируется и перезаписывается.
  @$pb.TagNumber(3)
  $core.List<$core.int> get fromUserID => $_getN(2);
  @$pb.TagNumber(3)
  set fromUserID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromUserID() => $_clearField(3);

  @$pb.TagNumber(4)
  Call_Signal_CallType get callType => $_getN(3);
  @$pb.TagNumber(4)
  set callType(Call_Signal_CallType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCallType() => $_has(3);
  @$pb.TagNumber(4)
  void clearCallType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sdp => $_getSZ(4);
  @$pb.TagNumber(5)
  set sdp($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSdp() => $_has(4);
  @$pb.TagNumber(5)
  void clearSdp() => $_clearField(5);

  @$pb.TagNumber(6)
  Call_IceCandidate get candidate => $_getN(5);
  @$pb.TagNumber(6)
  set candidate(Call_IceCandidate value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCandidate() => $_has(5);
  @$pb.TagNumber(6)
  void clearCandidate() => $_clearField(6);
  @$pb.TagNumber(6)
  Call_IceCandidate ensureCandidate() => $_ensure(5);
}

class Call_IceCandidate extends $pb.GeneratedMessage {
  factory Call_IceCandidate({
    $core.String? candidate,
    $core.String? sdpMid,
    $core.int? sdpMLineIndex,
  }) {
    final result = create();
    if (candidate != null) result.candidate = candidate;
    if (sdpMid != null) result.sdpMid = sdpMid;
    if (sdpMLineIndex != null) result.sdpMLineIndex = sdpMLineIndex;
    return result;
  }

  Call_IceCandidate._();

  factory Call_IceCandidate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Call_IceCandidate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Call.IceCandidate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'candidate')
    ..aOS(2, _omitFieldNames ? '' : 'sdpMid', protoName: 'sdpMid')
    ..aI(3, _omitFieldNames ? '' : 'sdpMLineIndex', protoName: 'sdpMLineIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Call_IceCandidate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Call_IceCandidate copyWith(void Function(Call_IceCandidate) updates) =>
      super.copyWith((message) => updates(message as Call_IceCandidate)) as Call_IceCandidate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Call_IceCandidate create() => Call_IceCandidate._();
  @$core.override
  Call_IceCandidate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Call_IceCandidate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Call_IceCandidate>(create);
  static Call_IceCandidate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get candidate => $_getSZ(0);
  @$pb.TagNumber(1)
  set candidate($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCandidate() => $_has(0);
  @$pb.TagNumber(1)
  void clearCandidate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get sdpMid => $_getSZ(1);
  @$pb.TagNumber(2)
  set sdpMid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSdpMid() => $_has(1);
  @$pb.TagNumber(2)
  void clearSdpMid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get sdpMLineIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set sdpMLineIndex($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSdpMLineIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSdpMLineIndex() => $_clearField(3);
}

/// Call — сигналинг WebRTC-звонков 1-на-1. Сервер выступает только реле: снимает
/// крипто-конверт, аутентифицирует отправителя, перезаписывает fromUserID из
/// сессии и публикует Signal адресату (toUserID) через NATS. Медиа (SRTP) идёт
/// p2p мимо сервера. Тип действия (offer/answer/candidate/hangup/reject) задаёт
/// MessageType конверта — Signal один на все действия.
class Call extends $pb.GeneratedMessage {
  factory Call() => create();

  Call._();

  factory Call.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Call.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Call',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Call clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Call copyWith(void Function(Call) updates) => super.copyWith((message) => updates(message as Call)) as Call;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Call create() => Call._();
  @$core.override
  Call createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Call getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Call>(create);
  static Call? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
