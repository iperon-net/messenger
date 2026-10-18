// This is a generated file - do not edit.
//
// Generated from protos/secret_chats_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'secret_chats_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'secret_chats_v1.pbenum.dart';

class SecretChat extends $pb.GeneratedMessage {
  factory SecretChat({
    $core.List<$core.int>? secretChatID,
    $core.List<$core.int>? initiatorUserID,
    $core.List<$core.int>? peerUserID,
    SecretChat_State? state,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (secretChatID != null) result.secretChatID = secretChatID;
    if (initiatorUserID != null) result.initiatorUserID = initiatorUserID;
    if (peerUserID != null) result.peerUserID = peerUserID;
    if (state != null) result.state = state;
    if (date != null) result.date = date;
    return result;
  }

  SecretChat._();

  factory SecretChat.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChat.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChat',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'secretChatID', $pb.PbFieldType.OY, protoName: 'secretChatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'initiatorUserID', $pb.PbFieldType.OY, protoName: 'initiatorUserID')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'peerUserID', $pb.PbFieldType.OY, protoName: 'peerUserID')
    ..aE<SecretChat_State>(4, _omitFieldNames ? '' : 'state', enumValues: SecretChat_State.values)
    ..aInt64(5, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChat clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChat copyWith(void Function(SecretChat) updates) => super.copyWith((message) => updates(message as SecretChat)) as SecretChat;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChat create() => SecretChat._();
  @$core.override
  SecretChat createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChat>(create);
  static SecretChat? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get secretChatID => $_getN(0);
  @$pb.TagNumber(1)
  set secretChatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecretChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecretChatID() => $_clearField(1);

  /// Кто начал (A) и с кем (B). Сессии в протокол не выдаём: устройство знает
  /// только, что чат его.
  @$pb.TagNumber(2)
  $core.List<$core.int> get initiatorUserID => $_getN(1);
  @$pb.TagNumber(2)
  set initiatorUserID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInitiatorUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitiatorUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get peerUserID => $_getN(2);
  @$pb.TagNumber(3)
  set peerUserID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeerUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeerUserID() => $_clearField(3);

  @$pb.TagNumber(4)
  SecretChat_State get state => $_getN(3);
  @$pb.TagNumber(4)
  set state(SecretChat_State value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get date => $_getI64(4);
  @$pb.TagNumber(5)
  set date($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearDate() => $_clearField(5);
}

/// A → устройствам B: запрос на секретный чат.
class SecretUpdate_Requested extends $pb.GeneratedMessage {
  factory SecretUpdate_Requested({
    $core.List<$core.int>? fromUserID,
    $core.List<$core.int>? commitment,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (commitment != null) result.commitment = commitment;
    return result;
  }

  SecretUpdate_Requested._();

  factory SecretUpdate_Requested.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretUpdate_Requested.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretUpdate.Requested',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'fromUserID', $pb.PbFieldType.OY, protoName: 'fromUserID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'commitment', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_Requested clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_Requested copyWith(void Function(SecretUpdate_Requested) updates) =>
      super.copyWith((message) => updates(message as SecretUpdate_Requested)) as SecretUpdate_Requested;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretUpdate_Requested create() => SecretUpdate_Requested._();
  @$core.override
  SecretUpdate_Requested createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretUpdate_Requested getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretUpdate_Requested>(create);
  static SecretUpdate_Requested? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get fromUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromUserID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get commitment => $_getN(1);
  @$pb.TagNumber(2)
  set commitment($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommitment() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommitment() => $_clearField(2);
}

/// B → A: устройство B приняло.
class SecretUpdate_Accepted extends $pb.GeneratedMessage {
  factory SecretUpdate_Accepted({
    $core.List<$core.int>? ephemeralKey,
    $core.List<$core.int>? kemPublicKey,
  }) {
    final result = create();
    if (ephemeralKey != null) result.ephemeralKey = ephemeralKey;
    if (kemPublicKey != null) result.kemPublicKey = kemPublicKey;
    return result;
  }

  SecretUpdate_Accepted._();

  factory SecretUpdate_Accepted.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretUpdate_Accepted.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretUpdate.Accepted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'ephemeralKey', $pb.PbFieldType.OY, protoName: 'ephemeralKey')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'kemPublicKey', $pb.PbFieldType.OY, protoName: 'kemPublicKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_Accepted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_Accepted copyWith(void Function(SecretUpdate_Accepted) updates) =>
      super.copyWith((message) => updates(message as SecretUpdate_Accepted)) as SecretUpdate_Accepted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretUpdate_Accepted create() => SecretUpdate_Accepted._();
  @$core.override
  SecretUpdate_Accepted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretUpdate_Accepted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretUpdate_Accepted>(create);
  static SecretUpdate_Accepted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ephemeralKey => $_getN(0);
  @$pb.TagNumber(1)
  set ephemeralKey($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEphemeralKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearEphemeralKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get kemPublicKey => $_getN(1);
  @$pb.TagNumber(2)
  set kemPublicKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKemPublicKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKemPublicKey() => $_clearField(2);
}

/// A → B: раскрытие коммитмента — рукопожатие завершено.
class SecretUpdate_Committed extends $pb.GeneratedMessage {
  factory SecretUpdate_Committed({
    $core.List<$core.int>? ephemeralKey,
    $core.List<$core.int>? nonce,
    $core.List<$core.int>? kemCiphertext,
    $core.List<$core.int>? ratchetKey,
  }) {
    final result = create();
    if (ephemeralKey != null) result.ephemeralKey = ephemeralKey;
    if (nonce != null) result.nonce = nonce;
    if (kemCiphertext != null) result.kemCiphertext = kemCiphertext;
    if (ratchetKey != null) result.ratchetKey = ratchetKey;
    return result;
  }

  SecretUpdate_Committed._();

  factory SecretUpdate_Committed.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretUpdate_Committed.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretUpdate.Committed',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'ephemeralKey', $pb.PbFieldType.OY, protoName: 'ephemeralKey')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'kemCiphertext', $pb.PbFieldType.OY, protoName: 'kemCiphertext')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'ratchetKey', $pb.PbFieldType.OY, protoName: 'ratchetKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_Committed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_Committed copyWith(void Function(SecretUpdate_Committed) updates) =>
      super.copyWith((message) => updates(message as SecretUpdate_Committed)) as SecretUpdate_Committed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretUpdate_Committed create() => SecretUpdate_Committed._();
  @$core.override
  SecretUpdate_Committed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretUpdate_Committed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretUpdate_Committed>(create);
  static SecretUpdate_Committed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ephemeralKey => $_getN(0);
  @$pb.TagNumber(1)
  set ephemeralKey($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEphemeralKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearEphemeralKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get nonce => $_getN(1);
  @$pb.TagNumber(2)
  set nonce($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNonce() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonce() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get kemCiphertext => $_getN(2);
  @$pb.TagNumber(3)
  set kemCiphertext($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKemCiphertext() => $_has(2);
  @$pb.TagNumber(3)
  void clearKemCiphertext() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get ratchetKey => $_getN(3);
  @$pb.TagNumber(4)
  set ratchetKey($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRatchetKey() => $_has(3);
  @$pb.TagNumber(4)
  void clearRatchetKey() => $_clearField(4);
}

/// Сообщение собеседника: конверт храповика (шифротекст).
class SecretUpdate_NewMessage extends $pb.GeneratedMessage {
  factory SecretUpdate_NewMessage({
    $fixnum.Int64? randomID,
    $core.List<$core.int>? envelope,
  }) {
    final result = create();
    if (randomID != null) result.randomID = randomID;
    if (envelope != null) result.envelope = envelope;
    return result;
  }

  SecretUpdate_NewMessage._();

  factory SecretUpdate_NewMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretUpdate_NewMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretUpdate.NewMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'envelope', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_NewMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_NewMessage copyWith(void Function(SecretUpdate_NewMessage) updates) =>
      super.copyWith((message) => updates(message as SecretUpdate_NewMessage)) as SecretUpdate_NewMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretUpdate_NewMessage create() => SecretUpdate_NewMessage._();
  @$core.override
  SecretUpdate_NewMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretUpdate_NewMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretUpdate_NewMessage>(create);
  static SecretUpdate_NewMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get randomID => $_getI64(0);
  @$pb.TagNumber(1)
  set randomID($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRandomID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRandomID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get envelope => $_getN(1);
  @$pb.TagNumber(2)
  set envelope($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEnvelope() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnvelope() => $_clearField(2);
}

/// Чат закрыт.
class SecretUpdate_Discarded extends $pb.GeneratedMessage {
  factory SecretUpdate_Discarded({
    SecretUpdate_Discarded_Reason? reason,
    $core.bool? deleteHistory,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    if (deleteHistory != null) result.deleteHistory = deleteHistory;
    return result;
  }

  SecretUpdate_Discarded._();

  factory SecretUpdate_Discarded.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretUpdate_Discarded.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretUpdate.Discarded',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<SecretUpdate_Discarded_Reason>(1, _omitFieldNames ? '' : 'reason', enumValues: SecretUpdate_Discarded_Reason.values)
    ..aOB(2, _omitFieldNames ? '' : 'deleteHistory', protoName: 'deleteHistory')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_Discarded clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate_Discarded copyWith(void Function(SecretUpdate_Discarded) updates) =>
      super.copyWith((message) => updates(message as SecretUpdate_Discarded)) as SecretUpdate_Discarded;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretUpdate_Discarded create() => SecretUpdate_Discarded._();
  @$core.override
  SecretUpdate_Discarded createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretUpdate_Discarded getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretUpdate_Discarded>(create);
  static SecretUpdate_Discarded? _defaultInstance;

  @$pb.TagNumber(1)
  SecretUpdate_Discarded_Reason get reason => $_getN(0);
  @$pb.TagNumber(1)
  set reason(SecretUpdate_Discarded_Reason value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);

  /// Собеседник попросил удалить переписку и у меня.
  @$pb.TagNumber(2)
  $core.bool get deleteHistory => $_getBF(1);
  @$pb.TagNumber(2)
  set deleteHistory($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeleteHistory() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeleteHistory() => $_clearField(2);
}

enum SecretUpdate_Update { requested, accepted, committed, newMessage, discarded, notSet }

class SecretUpdate extends $pb.GeneratedMessage {
  factory SecretUpdate({
    $fixnum.Int64? qts,
    $fixnum.Int64? date,
    $core.List<$core.int>? secretChatID,
    SecretUpdate_Requested? requested,
    SecretUpdate_Accepted? accepted,
    SecretUpdate_Committed? committed,
    SecretUpdate_NewMessage? newMessage,
    SecretUpdate_Discarded? discarded,
  }) {
    final result = create();
    if (qts != null) result.qts = qts;
    if (date != null) result.date = date;
    if (secretChatID != null) result.secretChatID = secretChatID;
    if (requested != null) result.requested = requested;
    if (accepted != null) result.accepted = accepted;
    if (committed != null) result.committed = committed;
    if (newMessage != null) result.newMessage = newMessage;
    if (discarded != null) result.discarded = discarded;
    return result;
  }

  SecretUpdate._();

  factory SecretUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SecretUpdate_Update> _SecretUpdate_UpdateByTag = {
    4: SecretUpdate_Update.requested,
    5: SecretUpdate_Update.accepted,
    6: SecretUpdate_Update.committed,
    7: SecretUpdate_Update.newMessage,
    8: SecretUpdate_Update.discarded,
    0: SecretUpdate_Update.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretUpdate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [4, 5, 6, 7, 8])
    ..aInt64(1, _omitFieldNames ? '' : 'qts')
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'secretChatID', $pb.PbFieldType.OY, protoName: 'secretChatID')
    ..aOM<SecretUpdate_Requested>(4, _omitFieldNames ? '' : 'requested', subBuilder: SecretUpdate_Requested.create)
    ..aOM<SecretUpdate_Accepted>(5, _omitFieldNames ? '' : 'accepted', subBuilder: SecretUpdate_Accepted.create)
    ..aOM<SecretUpdate_Committed>(6, _omitFieldNames ? '' : 'committed', subBuilder: SecretUpdate_Committed.create)
    ..aOM<SecretUpdate_NewMessage>(7, _omitFieldNames ? '' : 'newMessage',
        protoName: 'newMessage', subBuilder: SecretUpdate_NewMessage.create)
    ..aOM<SecretUpdate_Discarded>(8, _omitFieldNames ? '' : 'discarded', subBuilder: SecretUpdate_Discarded.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdate copyWith(void Function(SecretUpdate) updates) =>
      super.copyWith((message) => updates(message as SecretUpdate)) as SecretUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretUpdate create() => SecretUpdate._();
  @$core.override
  SecretUpdate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretUpdate>(create);
  static SecretUpdate? _defaultInstance;

  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  SecretUpdate_Update whichUpdate() => _SecretUpdate_UpdateByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  void clearUpdate() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get qts => $_getI64(0);
  @$pb.TagNumber(1)
  set qts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasQts() => $_has(0);
  @$pb.TagNumber(1)
  void clearQts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get secretChatID => $_getN(2);
  @$pb.TagNumber(3)
  set secretChatID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSecretChatID() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecretChatID() => $_clearField(3);

  @$pb.TagNumber(4)
  SecretUpdate_Requested get requested => $_getN(3);
  @$pb.TagNumber(4)
  set requested(SecretUpdate_Requested value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRequested() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequested() => $_clearField(4);
  @$pb.TagNumber(4)
  SecretUpdate_Requested ensureRequested() => $_ensure(3);

  @$pb.TagNumber(5)
  SecretUpdate_Accepted get accepted => $_getN(4);
  @$pb.TagNumber(5)
  set accepted(SecretUpdate_Accepted value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAccepted() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccepted() => $_clearField(5);
  @$pb.TagNumber(5)
  SecretUpdate_Accepted ensureAccepted() => $_ensure(4);

  @$pb.TagNumber(6)
  SecretUpdate_Committed get committed => $_getN(5);
  @$pb.TagNumber(6)
  set committed(SecretUpdate_Committed value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCommitted() => $_has(5);
  @$pb.TagNumber(6)
  void clearCommitted() => $_clearField(6);
  @$pb.TagNumber(6)
  SecretUpdate_Committed ensureCommitted() => $_ensure(5);

  @$pb.TagNumber(7)
  SecretUpdate_NewMessage get newMessage => $_getN(6);
  @$pb.TagNumber(7)
  set newMessage(SecretUpdate_NewMessage value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNewMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearNewMessage() => $_clearField(7);
  @$pb.TagNumber(7)
  SecretUpdate_NewMessage ensureNewMessage() => $_ensure(6);

  @$pb.TagNumber(8)
  SecretUpdate_Discarded get discarded => $_getN(7);
  @$pb.TagNumber(8)
  set discarded(SecretUpdate_Discarded value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDiscarded() => $_has(7);
  @$pb.TagNumber(8)
  void clearDiscarded() => $_clearField(8);
  @$pb.TagNumber(8)
  SecretUpdate_Discarded ensureDiscarded() => $_ensure(7);
}

/// Файл секретного чата: где лежит шифротекст. Расшифровать его можно только
/// ключом из SecretPayload (SecretMedia).
class SecretFile extends $pb.GeneratedMessage {
  factory SecretFile({
    $core.List<$core.int>? fileID,
    $core.String? url,
  }) {
    final result = create();
    if (fileID != null) result.fileID = fileID;
    if (url != null) result.url = url;
    return result;
  }

  SecretFile._();

  factory SecretFile.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretFile.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretFile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'fileID', $pb.PbFieldType.OY, protoName: 'fileID')
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretFile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretFile copyWith(void Function(SecretFile) updates) => super.copyWith((message) => updates(message as SecretFile)) as SecretFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretFile create() => SecretFile._();
  @$core.override
  SecretFile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretFile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretFile>(create);
  static SecretFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get fileID => $_getN(0);
  @$pb.TagNumber(1)
  set fileID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => $_clearField(2);
}

/// Push по стриму (SECRET_UPDATES) в сессию.
class SecretUpdates extends $pb.GeneratedMessage {
  factory SecretUpdates({
    $core.Iterable<SecretUpdate>? updates,
  }) {
    final result = create();
    if (updates != null) result.updates.addAll(updates);
    return result;
  }

  SecretUpdates._();

  factory SecretUpdates.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretUpdates.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretUpdates',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<SecretUpdate>(1, _omitFieldNames ? '' : 'updates', subBuilder: SecretUpdate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdates clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretUpdates copyWith(void Function(SecretUpdates) updates) =>
      super.copyWith((message) => updates(message as SecretUpdates)) as SecretUpdates;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretUpdates create() => SecretUpdates._();
  @$core.override
  SecretUpdates createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretUpdates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretUpdates>(create);
  static SecretUpdates? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SecretUpdate> get updates => $_getList(0);
}

/// A: начать секретный чат с userID. randomID — идемпотентность повтора.
class SecretChats_Create extends $pb.GeneratedMessage {
  factory SecretChats_Create({
    $core.List<$core.int>? userID,
    $core.List<$core.int>? commitment,
    $fixnum.Int64? randomID,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (commitment != null) result.commitment = commitment;
    if (randomID != null) result.randomID = randomID;
    return result;
  }

  SecretChats_Create._();

  factory SecretChats_Create.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_Create.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.Create',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'commitment', $pb.PbFieldType.OY)
    ..aInt64(3, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Create clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Create copyWith(void Function(SecretChats_Create) updates) =>
      super.copyWith((message) => updates(message as SecretChats_Create)) as SecretChats_Create;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_Create create() => SecretChats_Create._();
  @$core.override
  SecretChats_Create createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_Create getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_Create>(create);
  static SecretChats_Create? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get commitment => $_getN(1);
  @$pb.TagNumber(2)
  set commitment($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommitment() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommitment() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get randomID => $_getI64(2);
  @$pb.TagNumber(3)
  set randomID($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRandomID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRandomID() => $_clearField(3);
}

class SecretChats_CreateResult extends $pb.GeneratedMessage {
  factory SecretChats_CreateResult({
    SecretChat? chat,
  }) {
    final result = create();
    if (chat != null) result.chat = chat;
    return result;
  }

  SecretChats_CreateResult._();

  factory SecretChats_CreateResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_CreateResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.CreateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<SecretChat>(1, _omitFieldNames ? '' : 'chat', subBuilder: SecretChat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_CreateResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_CreateResult copyWith(void Function(SecretChats_CreateResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_CreateResult)) as SecretChats_CreateResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_CreateResult create() => SecretChats_CreateResult._();
  @$core.override
  SecretChats_CreateResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_CreateResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_CreateResult>(create);
  static SecretChats_CreateResult? _defaultInstance;

  @$pb.TagNumber(1)
  SecretChat get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat(SecretChat value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => $_clearField(1);
  @$pb.TagNumber(1)
  SecretChat ensureChat() => $_ensure(0);
}

/// B: принять запрос (первое принявшее устройство забирает чат).
class SecretChats_Accept extends $pb.GeneratedMessage {
  factory SecretChats_Accept({
    $core.List<$core.int>? secretChatID,
    $core.List<$core.int>? ephemeralKey,
    $core.List<$core.int>? kemPublicKey,
  }) {
    final result = create();
    if (secretChatID != null) result.secretChatID = secretChatID;
    if (ephemeralKey != null) result.ephemeralKey = ephemeralKey;
    if (kemPublicKey != null) result.kemPublicKey = kemPublicKey;
    return result;
  }

  SecretChats_Accept._();

  factory SecretChats_Accept.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_Accept.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.Accept',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'secretChatID', $pb.PbFieldType.OY, protoName: 'secretChatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'ephemeralKey', $pb.PbFieldType.OY, protoName: 'ephemeralKey')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'kemPublicKey', $pb.PbFieldType.OY, protoName: 'kemPublicKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Accept clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Accept copyWith(void Function(SecretChats_Accept) updates) =>
      super.copyWith((message) => updates(message as SecretChats_Accept)) as SecretChats_Accept;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_Accept create() => SecretChats_Accept._();
  @$core.override
  SecretChats_Accept createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_Accept getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_Accept>(create);
  static SecretChats_Accept? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get secretChatID => $_getN(0);
  @$pb.TagNumber(1)
  set secretChatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecretChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecretChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get ephemeralKey => $_getN(1);
  @$pb.TagNumber(2)
  set ephemeralKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEphemeralKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearEphemeralKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get kemPublicKey => $_getN(2);
  @$pb.TagNumber(3)
  set kemPublicKey($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKemPublicKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearKemPublicKey() => $_clearField(3);
}

class SecretChats_AcceptResult extends $pb.GeneratedMessage {
  factory SecretChats_AcceptResult({
    SecretChat? chat,
  }) {
    final result = create();
    if (chat != null) result.chat = chat;
    return result;
  }

  SecretChats_AcceptResult._();

  factory SecretChats_AcceptResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_AcceptResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.AcceptResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<SecretChat>(1, _omitFieldNames ? '' : 'chat', subBuilder: SecretChat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_AcceptResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_AcceptResult copyWith(void Function(SecretChats_AcceptResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_AcceptResult)) as SecretChats_AcceptResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_AcceptResult create() => SecretChats_AcceptResult._();
  @$core.override
  SecretChats_AcceptResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_AcceptResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_AcceptResult>(create);
  static SecretChats_AcceptResult? _defaultInstance;

  @$pb.TagNumber(1)
  SecretChat get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat(SecretChat value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => $_clearField(1);
  @$pb.TagNumber(1)
  SecretChat ensureChat() => $_ensure(0);
}

/// A: раскрыть коммитмент.
class SecretChats_Commit extends $pb.GeneratedMessage {
  factory SecretChats_Commit({
    $core.List<$core.int>? secretChatID,
    $core.List<$core.int>? ephemeralKey,
    $core.List<$core.int>? nonce,
    $core.List<$core.int>? kemCiphertext,
    $core.List<$core.int>? ratchetKey,
  }) {
    final result = create();
    if (secretChatID != null) result.secretChatID = secretChatID;
    if (ephemeralKey != null) result.ephemeralKey = ephemeralKey;
    if (nonce != null) result.nonce = nonce;
    if (kemCiphertext != null) result.kemCiphertext = kemCiphertext;
    if (ratchetKey != null) result.ratchetKey = ratchetKey;
    return result;
  }

  SecretChats_Commit._();

  factory SecretChats_Commit.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_Commit.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.Commit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'secretChatID', $pb.PbFieldType.OY, protoName: 'secretChatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'ephemeralKey', $pb.PbFieldType.OY, protoName: 'ephemeralKey')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'nonce', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'kemCiphertext', $pb.PbFieldType.OY, protoName: 'kemCiphertext')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'ratchetKey', $pb.PbFieldType.OY, protoName: 'ratchetKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Commit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Commit copyWith(void Function(SecretChats_Commit) updates) =>
      super.copyWith((message) => updates(message as SecretChats_Commit)) as SecretChats_Commit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_Commit create() => SecretChats_Commit._();
  @$core.override
  SecretChats_Commit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_Commit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_Commit>(create);
  static SecretChats_Commit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get secretChatID => $_getN(0);
  @$pb.TagNumber(1)
  set secretChatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecretChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecretChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get ephemeralKey => $_getN(1);
  @$pb.TagNumber(2)
  set ephemeralKey($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEphemeralKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearEphemeralKey() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get nonce => $_getN(2);
  @$pb.TagNumber(3)
  set nonce($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNonce() => $_has(2);
  @$pb.TagNumber(3)
  void clearNonce() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get kemCiphertext => $_getN(3);
  @$pb.TagNumber(4)
  set kemCiphertext($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasKemCiphertext() => $_has(3);
  @$pb.TagNumber(4)
  void clearKemCiphertext() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get ratchetKey => $_getN(4);
  @$pb.TagNumber(5)
  set ratchetKey($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRatchetKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearRatchetKey() => $_clearField(5);
}

class SecretChats_CommitResult extends $pb.GeneratedMessage {
  factory SecretChats_CommitResult({
    SecretChat? chat,
  }) {
    final result = create();
    if (chat != null) result.chat = chat;
    return result;
  }

  SecretChats_CommitResult._();

  factory SecretChats_CommitResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_CommitResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.CommitResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<SecretChat>(1, _omitFieldNames ? '' : 'chat', subBuilder: SecretChat.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_CommitResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_CommitResult copyWith(void Function(SecretChats_CommitResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_CommitResult)) as SecretChats_CommitResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_CommitResult create() => SecretChats_CommitResult._();
  @$core.override
  SecretChats_CommitResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_CommitResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_CommitResult>(create);
  static SecretChats_CommitResult? _defaultInstance;

  @$pb.TagNumber(1)
  SecretChat get chat => $_getN(0);
  @$pb.TagNumber(1)
  set chat(SecretChat value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearChat() => $_clearField(1);
  @$pb.TagNumber(1)
  SecretChat ensureChat() => $_ensure(0);
}

/// Закрыть чат / отклонить запрос / отозвать свой.
class SecretChats_Discard extends $pb.GeneratedMessage {
  factory SecretChats_Discard({
    $core.List<$core.int>? secretChatID,
    $core.bool? deleteHistory,
  }) {
    final result = create();
    if (secretChatID != null) result.secretChatID = secretChatID;
    if (deleteHistory != null) result.deleteHistory = deleteHistory;
    return result;
  }

  SecretChats_Discard._();

  factory SecretChats_Discard.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_Discard.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.Discard',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'secretChatID', $pb.PbFieldType.OY, protoName: 'secretChatID')
    ..aOB(2, _omitFieldNames ? '' : 'deleteHistory', protoName: 'deleteHistory')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Discard clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Discard copyWith(void Function(SecretChats_Discard) updates) =>
      super.copyWith((message) => updates(message as SecretChats_Discard)) as SecretChats_Discard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_Discard create() => SecretChats_Discard._();
  @$core.override
  SecretChats_Discard createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_Discard getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_Discard>(create);
  static SecretChats_Discard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get secretChatID => $_getN(0);
  @$pb.TagNumber(1)
  set secretChatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecretChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecretChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get deleteHistory => $_getBF(1);
  @$pb.TagNumber(2)
  set deleteHistory($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeleteHistory() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeleteHistory() => $_clearField(2);
}

class SecretChats_DiscardResult extends $pb.GeneratedMessage {
  factory SecretChats_DiscardResult() => create();

  SecretChats_DiscardResult._();

  factory SecretChats_DiscardResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_DiscardResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.DiscardResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_DiscardResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_DiscardResult copyWith(void Function(SecretChats_DiscardResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_DiscardResult)) as SecretChats_DiscardResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_DiscardResult create() => SecretChats_DiscardResult._();
  @$core.override
  SecretChats_DiscardResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_DiscardResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_DiscardResult>(create);
  static SecretChats_DiscardResult? _defaultInstance;
}

/// Отправить конверт собеседнику. Повтор того же randomID в течение жизни
/// очереди не дублирует сообщение.
///
/// fileIDs — файлы сообщения (cdnID непрозрачных загрузок отправителя,
/// UploadConfirm.opaque): сервер прикрепляет их к чату — после этого ссылку
/// на них выдаёт GetFiles обоим участникам. Ключи файлов — внутри конверта.
class SecretChats_Send extends $pb.GeneratedMessage {
  factory SecretChats_Send({
    $core.List<$core.int>? secretChatID,
    $fixnum.Int64? randomID,
    $core.List<$core.int>? envelope,
    $core.Iterable<$core.List<$core.int>>? fileIDs,
  }) {
    final result = create();
    if (secretChatID != null) result.secretChatID = secretChatID;
    if (randomID != null) result.randomID = randomID;
    if (envelope != null) result.envelope = envelope;
    if (fileIDs != null) result.fileIDs.addAll(fileIDs);
    return result;
  }

  SecretChats_Send._();

  factory SecretChats_Send.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_Send.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.Send',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'secretChatID', $pb.PbFieldType.OY, protoName: 'secretChatID')
    ..aInt64(2, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'envelope', $pb.PbFieldType.OY)
    ..p<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'fileIDs', $pb.PbFieldType.PY, protoName: 'fileIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Send clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Send copyWith(void Function(SecretChats_Send) updates) =>
      super.copyWith((message) => updates(message as SecretChats_Send)) as SecretChats_Send;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_Send create() => SecretChats_Send._();
  @$core.override
  SecretChats_Send createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_Send getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_Send>(create);
  static SecretChats_Send? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get secretChatID => $_getN(0);
  @$pb.TagNumber(1)
  set secretChatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecretChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecretChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get randomID => $_getI64(1);
  @$pb.TagNumber(2)
  set randomID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRandomID() => $_has(1);
  @$pb.TagNumber(2)
  void clearRandomID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get envelope => $_getN(2);
  @$pb.TagNumber(3)
  set envelope($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEnvelope() => $_has(2);
  @$pb.TagNumber(3)
  void clearEnvelope() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.List<$core.int>> get fileIDs => $_getList(3);
}

class SecretChats_SendResult extends $pb.GeneratedMessage {
  factory SecretChats_SendResult({
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (date != null) result.date = date;
    return result;
  }

  SecretChats_SendResult._();

  factory SecretChats_SendResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_SendResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.SendResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_SendResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_SendResult copyWith(void Function(SecretChats_SendResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_SendResult)) as SecretChats_SendResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_SendResult create() => SecretChats_SendResult._();
  @$core.override
  SecretChats_SendResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_SendResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_SendResult>(create);
  static SecretChats_SendResult? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get date => $_getI64(0);
  @$pb.TagNumber(1)
  set date($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearDate() => $_clearField(1);
}

/// Неподтверждённые события моей очереди с qts > afterQts по порядку.
class SecretChats_GetUpdates extends $pb.GeneratedMessage {
  factory SecretChats_GetUpdates({
    $fixnum.Int64? afterQts,
    $core.int? limit,
  }) {
    final result = create();
    if (afterQts != null) result.afterQts = afterQts;
    if (limit != null) result.limit = limit;
    return result;
  }

  SecretChats_GetUpdates._();

  factory SecretChats_GetUpdates.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_GetUpdates.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.GetUpdates',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'afterQts', protoName: 'afterQts')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_GetUpdates clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_GetUpdates copyWith(void Function(SecretChats_GetUpdates) updates) =>
      super.copyWith((message) => updates(message as SecretChats_GetUpdates)) as SecretChats_GetUpdates;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_GetUpdates create() => SecretChats_GetUpdates._();
  @$core.override
  SecretChats_GetUpdates createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_GetUpdates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_GetUpdates>(create);
  static SecretChats_GetUpdates? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get afterQts => $_getI64(0);
  @$pb.TagNumber(1)
  set afterQts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAfterQts() => $_has(0);
  @$pb.TagNumber(1)
  void clearAfterQts() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class SecretChats_GetUpdatesResult extends $pb.GeneratedMessage {
  factory SecretChats_GetUpdatesResult({
    $core.Iterable<SecretUpdate>? updates,
    $core.bool? hasMore,
  }) {
    final result = create();
    if (updates != null) result.updates.addAll(updates);
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  SecretChats_GetUpdatesResult._();

  factory SecretChats_GetUpdatesResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_GetUpdatesResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.GetUpdatesResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<SecretUpdate>(1, _omitFieldNames ? '' : 'updates', subBuilder: SecretUpdate.create)
    ..aOB(2, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_GetUpdatesResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_GetUpdatesResult copyWith(void Function(SecretChats_GetUpdatesResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_GetUpdatesResult)) as SecretChats_GetUpdatesResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_GetUpdatesResult create() => SecretChats_GetUpdatesResult._();
  @$core.override
  SecretChats_GetUpdatesResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_GetUpdatesResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_GetUpdatesResult>(create);
  static SecretChats_GetUpdatesResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SecretUpdate> get updates => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);
}

/// Подтвердить обработку всего ≤ maxQts (удаляется из очереди).
class SecretChats_Ack extends $pb.GeneratedMessage {
  factory SecretChats_Ack({
    $fixnum.Int64? maxQts,
  }) {
    final result = create();
    if (maxQts != null) result.maxQts = maxQts;
    return result;
  }

  SecretChats_Ack._();

  factory SecretChats_Ack.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_Ack.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.Ack',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'maxQts', protoName: 'maxQts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Ack clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Ack copyWith(void Function(SecretChats_Ack) updates) =>
      super.copyWith((message) => updates(message as SecretChats_Ack)) as SecretChats_Ack;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_Ack create() => SecretChats_Ack._();
  @$core.override
  SecretChats_Ack createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_Ack getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_Ack>(create);
  static SecretChats_Ack? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get maxQts => $_getI64(0);
  @$pb.TagNumber(1)
  set maxQts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxQts() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxQts() => $_clearField(1);
}

class SecretChats_AckResult extends $pb.GeneratedMessage {
  factory SecretChats_AckResult() => create();

  SecretChats_AckResult._();

  factory SecretChats_AckResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_AckResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.AckResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_AckResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_AckResult copyWith(void Function(SecretChats_AckResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_AckResult)) as SecretChats_AckResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_AckResult create() => SecretChats_AckResult._();
  @$core.override
  SecretChats_AckResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_AckResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_AckResult>(create);
  static SecretChats_AckResult? _defaultInstance;
}

/// Ссылки на файлы чата (для скачивания шифротекста). Только участнику и
/// только файлы, прикреплённые к этому чату; чужие / удалённые — пропускаются.
/// Ссылка временная (как у вложений чатов): 403 — взять свежую.
class SecretChats_GetFiles extends $pb.GeneratedMessage {
  factory SecretChats_GetFiles({
    $core.List<$core.int>? secretChatID,
    $core.Iterable<$core.List<$core.int>>? fileIDs,
  }) {
    final result = create();
    if (secretChatID != null) result.secretChatID = secretChatID;
    if (fileIDs != null) result.fileIDs.addAll(fileIDs);
    return result;
  }

  SecretChats_GetFiles._();

  factory SecretChats_GetFiles.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_GetFiles.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.GetFiles',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'secretChatID', $pb.PbFieldType.OY, protoName: 'secretChatID')
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'fileIDs', $pb.PbFieldType.PY, protoName: 'fileIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_GetFiles clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_GetFiles copyWith(void Function(SecretChats_GetFiles) updates) =>
      super.copyWith((message) => updates(message as SecretChats_GetFiles)) as SecretChats_GetFiles;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_GetFiles create() => SecretChats_GetFiles._();
  @$core.override
  SecretChats_GetFiles createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_GetFiles getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_GetFiles>(create);
  static SecretChats_GetFiles? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get secretChatID => $_getN(0);
  @$pb.TagNumber(1)
  set secretChatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecretChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecretChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.List<$core.int>> get fileIDs => $_getList(1);
}

class SecretChats_GetFilesResult extends $pb.GeneratedMessage {
  factory SecretChats_GetFilesResult({
    $core.Iterable<SecretFile>? files,
  }) {
    final result = create();
    if (files != null) result.files.addAll(files);
    return result;
  }

  SecretChats_GetFilesResult._();

  factory SecretChats_GetFilesResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_GetFilesResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.GetFilesResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<SecretFile>(1, _omitFieldNames ? '' : 'files', subBuilder: SecretFile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_GetFilesResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_GetFilesResult copyWith(void Function(SecretChats_GetFilesResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_GetFilesResult)) as SecretChats_GetFilesResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_GetFilesResult create() => SecretChats_GetFilesResult._();
  @$core.override
  SecretChats_GetFilesResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_GetFilesResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_GetFilesResult>(create);
  static SecretChats_GetFilesResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SecretFile> get files => $_getList(0);
}

/// Файлы больше не нужны (удалили сообщения у обоих): сервер удалит их
/// позже (сборка мусора). Чужие / уже удалённые — без ошибки. Закрытие чата
/// освобождает все его файлы само.
class SecretChats_ReleaseFiles extends $pb.GeneratedMessage {
  factory SecretChats_ReleaseFiles({
    $core.List<$core.int>? secretChatID,
    $core.Iterable<$core.List<$core.int>>? fileIDs,
  }) {
    final result = create();
    if (secretChatID != null) result.secretChatID = secretChatID;
    if (fileIDs != null) result.fileIDs.addAll(fileIDs);
    return result;
  }

  SecretChats_ReleaseFiles._();

  factory SecretChats_ReleaseFiles.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_ReleaseFiles.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.ReleaseFiles',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'secretChatID', $pb.PbFieldType.OY, protoName: 'secretChatID')
    ..p<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'fileIDs', $pb.PbFieldType.PY, protoName: 'fileIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_ReleaseFiles clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_ReleaseFiles copyWith(void Function(SecretChats_ReleaseFiles) updates) =>
      super.copyWith((message) => updates(message as SecretChats_ReleaseFiles)) as SecretChats_ReleaseFiles;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_ReleaseFiles create() => SecretChats_ReleaseFiles._();
  @$core.override
  SecretChats_ReleaseFiles createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_ReleaseFiles getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_ReleaseFiles>(create);
  static SecretChats_ReleaseFiles? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get secretChatID => $_getN(0);
  @$pb.TagNumber(1)
  set secretChatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSecretChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearSecretChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.List<$core.int>> get fileIDs => $_getList(1);
}

class SecretChats_ReleaseFilesResult extends $pb.GeneratedMessage {
  factory SecretChats_ReleaseFilesResult() => create();

  SecretChats_ReleaseFilesResult._();

  factory SecretChats_ReleaseFilesResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_ReleaseFilesResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.ReleaseFilesResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_ReleaseFilesResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_ReleaseFilesResult copyWith(void Function(SecretChats_ReleaseFilesResult) updates) =>
      super.copyWith((message) => updates(message as SecretChats_ReleaseFilesResult)) as SecretChats_ReleaseFilesResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_ReleaseFilesResult create() => SecretChats_ReleaseFilesResult._();
  @$core.override
  SecretChats_ReleaseFilesResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_ReleaseFilesResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_ReleaseFilesResult>(create);
  static SecretChats_ReleaseFilesResult? _defaultInstance;
}

enum SecretChats_Request_Request { createChat, accept, commit, discard, send, getUpdates, ack, getFiles, releaseFiles, notSet }

class SecretChats_Request extends $pb.GeneratedMessage {
  factory SecretChats_Request({
    SecretChats_Create? createChat,
    SecretChats_Accept? accept,
    SecretChats_Commit? commit,
    SecretChats_Discard? discard,
    SecretChats_Send? send,
    SecretChats_GetUpdates? getUpdates,
    SecretChats_Ack? ack,
    SecretChats_GetFiles? getFiles,
    SecretChats_ReleaseFiles? releaseFiles,
  }) {
    final result = create();
    if (createChat != null) result.createChat = createChat;
    if (accept != null) result.accept = accept;
    if (commit != null) result.commit = commit;
    if (discard != null) result.discard = discard;
    if (send != null) result.send = send;
    if (getUpdates != null) result.getUpdates = getUpdates;
    if (ack != null) result.ack = ack;
    if (getFiles != null) result.getFiles = getFiles;
    if (releaseFiles != null) result.releaseFiles = releaseFiles;
    return result;
  }

  SecretChats_Request._();

  factory SecretChats_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SecretChats_Request_Request> _SecretChats_Request_RequestByTag = {
    1: SecretChats_Request_Request.createChat,
    2: SecretChats_Request_Request.accept,
    3: SecretChats_Request_Request.commit,
    4: SecretChats_Request_Request.discard,
    5: SecretChats_Request_Request.send,
    6: SecretChats_Request_Request.getUpdates,
    7: SecretChats_Request_Request.ack,
    8: SecretChats_Request_Request.getFiles,
    9: SecretChats_Request_Request.releaseFiles,
    0: SecretChats_Request_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..aOM<SecretChats_Create>(1, _omitFieldNames ? '' : 'createChat', protoName: 'createChat', subBuilder: SecretChats_Create.create)
    ..aOM<SecretChats_Accept>(2, _omitFieldNames ? '' : 'accept', subBuilder: SecretChats_Accept.create)
    ..aOM<SecretChats_Commit>(3, _omitFieldNames ? '' : 'commit', subBuilder: SecretChats_Commit.create)
    ..aOM<SecretChats_Discard>(4, _omitFieldNames ? '' : 'discard', subBuilder: SecretChats_Discard.create)
    ..aOM<SecretChats_Send>(5, _omitFieldNames ? '' : 'send', subBuilder: SecretChats_Send.create)
    ..aOM<SecretChats_GetUpdates>(6, _omitFieldNames ? '' : 'getUpdates',
        protoName: 'getUpdates', subBuilder: SecretChats_GetUpdates.create)
    ..aOM<SecretChats_Ack>(7, _omitFieldNames ? '' : 'ack', subBuilder: SecretChats_Ack.create)
    ..aOM<SecretChats_GetFiles>(8, _omitFieldNames ? '' : 'getFiles', protoName: 'getFiles', subBuilder: SecretChats_GetFiles.create)
    ..aOM<SecretChats_ReleaseFiles>(9, _omitFieldNames ? '' : 'releaseFiles',
        protoName: 'releaseFiles', subBuilder: SecretChats_ReleaseFiles.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Request copyWith(void Function(SecretChats_Request) updates) =>
      super.copyWith((message) => updates(message as SecretChats_Request)) as SecretChats_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_Request create() => SecretChats_Request._();
  @$core.override
  SecretChats_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_Request>(create);
  static SecretChats_Request? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  SecretChats_Request_Request whichRequest() => _SecretChats_Request_RequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  void clearRequest() => $_clearField($_whichOneof(0));

  /// createChat, а не create: в Dart `create` — служебный метод сообщения.
  @$pb.TagNumber(1)
  SecretChats_Create get createChat => $_getN(0);
  @$pb.TagNumber(1)
  set createChat(SecretChats_Create value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCreateChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateChat() => $_clearField(1);
  @$pb.TagNumber(1)
  SecretChats_Create ensureCreateChat() => $_ensure(0);

  @$pb.TagNumber(2)
  SecretChats_Accept get accept => $_getN(1);
  @$pb.TagNumber(2)
  set accept(SecretChats_Accept value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => $_clearField(2);
  @$pb.TagNumber(2)
  SecretChats_Accept ensureAccept() => $_ensure(1);

  @$pb.TagNumber(3)
  SecretChats_Commit get commit => $_getN(2);
  @$pb.TagNumber(3)
  set commit(SecretChats_Commit value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommit() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommit() => $_clearField(3);
  @$pb.TagNumber(3)
  SecretChats_Commit ensureCommit() => $_ensure(2);

  @$pb.TagNumber(4)
  SecretChats_Discard get discard => $_getN(3);
  @$pb.TagNumber(4)
  set discard(SecretChats_Discard value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscard() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscard() => $_clearField(4);
  @$pb.TagNumber(4)
  SecretChats_Discard ensureDiscard() => $_ensure(3);

  @$pb.TagNumber(5)
  SecretChats_Send get send => $_getN(4);
  @$pb.TagNumber(5)
  set send(SecretChats_Send value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSend() => $_has(4);
  @$pb.TagNumber(5)
  void clearSend() => $_clearField(5);
  @$pb.TagNumber(5)
  SecretChats_Send ensureSend() => $_ensure(4);

  @$pb.TagNumber(6)
  SecretChats_GetUpdates get getUpdates => $_getN(5);
  @$pb.TagNumber(6)
  set getUpdates(SecretChats_GetUpdates value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGetUpdates() => $_has(5);
  @$pb.TagNumber(6)
  void clearGetUpdates() => $_clearField(6);
  @$pb.TagNumber(6)
  SecretChats_GetUpdates ensureGetUpdates() => $_ensure(5);

  @$pb.TagNumber(7)
  SecretChats_Ack get ack => $_getN(6);
  @$pb.TagNumber(7)
  set ack(SecretChats_Ack value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAck() => $_has(6);
  @$pb.TagNumber(7)
  void clearAck() => $_clearField(7);
  @$pb.TagNumber(7)
  SecretChats_Ack ensureAck() => $_ensure(6);

  @$pb.TagNumber(8)
  SecretChats_GetFiles get getFiles => $_getN(7);
  @$pb.TagNumber(8)
  set getFiles(SecretChats_GetFiles value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasGetFiles() => $_has(7);
  @$pb.TagNumber(8)
  void clearGetFiles() => $_clearField(8);
  @$pb.TagNumber(8)
  SecretChats_GetFiles ensureGetFiles() => $_ensure(7);

  @$pb.TagNumber(9)
  SecretChats_ReleaseFiles get releaseFiles => $_getN(8);
  @$pb.TagNumber(9)
  set releaseFiles(SecretChats_ReleaseFiles value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReleaseFiles() => $_has(8);
  @$pb.TagNumber(9)
  void clearReleaseFiles() => $_clearField(9);
  @$pb.TagNumber(9)
  SecretChats_ReleaseFiles ensureReleaseFiles() => $_ensure(8);
}

enum SecretChats_Response_Response { createChat, accept, commit, discard, send, getUpdates, ack, getFiles, releaseFiles, notSet }

class SecretChats_Response extends $pb.GeneratedMessage {
  factory SecretChats_Response({
    SecretChats_CreateResult? createChat,
    SecretChats_AcceptResult? accept,
    SecretChats_CommitResult? commit,
    SecretChats_DiscardResult? discard,
    SecretChats_SendResult? send,
    SecretChats_GetUpdatesResult? getUpdates,
    SecretChats_AckResult? ack,
    SecretChats_GetFilesResult? getFiles,
    SecretChats_ReleaseFilesResult? releaseFiles,
  }) {
    final result = create();
    if (createChat != null) result.createChat = createChat;
    if (accept != null) result.accept = accept;
    if (commit != null) result.commit = commit;
    if (discard != null) result.discard = discard;
    if (send != null) result.send = send;
    if (getUpdates != null) result.getUpdates = getUpdates;
    if (ack != null) result.ack = ack;
    if (getFiles != null) result.getFiles = getFiles;
    if (releaseFiles != null) result.releaseFiles = releaseFiles;
    return result;
  }

  SecretChats_Response._();

  factory SecretChats_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SecretChats_Response_Response> _SecretChats_Response_ResponseByTag = {
    1: SecretChats_Response_Response.createChat,
    2: SecretChats_Response_Response.accept,
    3: SecretChats_Response_Response.commit,
    4: SecretChats_Response_Response.discard,
    5: SecretChats_Response_Response.send,
    6: SecretChats_Response_Response.getUpdates,
    7: SecretChats_Response_Response.ack,
    8: SecretChats_Response_Response.getFiles,
    9: SecretChats_Response_Response.releaseFiles,
    0: SecretChats_Response_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    ..aOM<SecretChats_CreateResult>(1, _omitFieldNames ? '' : 'createChat',
        protoName: 'createChat', subBuilder: SecretChats_CreateResult.create)
    ..aOM<SecretChats_AcceptResult>(2, _omitFieldNames ? '' : 'accept', subBuilder: SecretChats_AcceptResult.create)
    ..aOM<SecretChats_CommitResult>(3, _omitFieldNames ? '' : 'commit', subBuilder: SecretChats_CommitResult.create)
    ..aOM<SecretChats_DiscardResult>(4, _omitFieldNames ? '' : 'discard', subBuilder: SecretChats_DiscardResult.create)
    ..aOM<SecretChats_SendResult>(5, _omitFieldNames ? '' : 'send', subBuilder: SecretChats_SendResult.create)
    ..aOM<SecretChats_GetUpdatesResult>(6, _omitFieldNames ? '' : 'getUpdates',
        protoName: 'getUpdates', subBuilder: SecretChats_GetUpdatesResult.create)
    ..aOM<SecretChats_AckResult>(7, _omitFieldNames ? '' : 'ack', subBuilder: SecretChats_AckResult.create)
    ..aOM<SecretChats_GetFilesResult>(8, _omitFieldNames ? '' : 'getFiles',
        protoName: 'getFiles', subBuilder: SecretChats_GetFilesResult.create)
    ..aOM<SecretChats_ReleaseFilesResult>(9, _omitFieldNames ? '' : 'releaseFiles',
        protoName: 'releaseFiles', subBuilder: SecretChats_ReleaseFilesResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats_Response copyWith(void Function(SecretChats_Response) updates) =>
      super.copyWith((message) => updates(message as SecretChats_Response)) as SecretChats_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats_Response create() => SecretChats_Response._();
  @$core.override
  SecretChats_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats_Response>(create);
  static SecretChats_Response? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  SecretChats_Response_Response whichResponse() => _SecretChats_Response_ResponseByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  void clearResponse() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SecretChats_CreateResult get createChat => $_getN(0);
  @$pb.TagNumber(1)
  set createChat(SecretChats_CreateResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCreateChat() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreateChat() => $_clearField(1);
  @$pb.TagNumber(1)
  SecretChats_CreateResult ensureCreateChat() => $_ensure(0);

  @$pb.TagNumber(2)
  SecretChats_AcceptResult get accept => $_getN(1);
  @$pb.TagNumber(2)
  set accept(SecretChats_AcceptResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAccept() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccept() => $_clearField(2);
  @$pb.TagNumber(2)
  SecretChats_AcceptResult ensureAccept() => $_ensure(1);

  @$pb.TagNumber(3)
  SecretChats_CommitResult get commit => $_getN(2);
  @$pb.TagNumber(3)
  set commit(SecretChats_CommitResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCommit() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommit() => $_clearField(3);
  @$pb.TagNumber(3)
  SecretChats_CommitResult ensureCommit() => $_ensure(2);

  @$pb.TagNumber(4)
  SecretChats_DiscardResult get discard => $_getN(3);
  @$pb.TagNumber(4)
  set discard(SecretChats_DiscardResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDiscard() => $_has(3);
  @$pb.TagNumber(4)
  void clearDiscard() => $_clearField(4);
  @$pb.TagNumber(4)
  SecretChats_DiscardResult ensureDiscard() => $_ensure(3);

  @$pb.TagNumber(5)
  SecretChats_SendResult get send => $_getN(4);
  @$pb.TagNumber(5)
  set send(SecretChats_SendResult value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSend() => $_has(4);
  @$pb.TagNumber(5)
  void clearSend() => $_clearField(5);
  @$pb.TagNumber(5)
  SecretChats_SendResult ensureSend() => $_ensure(4);

  @$pb.TagNumber(6)
  SecretChats_GetUpdatesResult get getUpdates => $_getN(5);
  @$pb.TagNumber(6)
  set getUpdates(SecretChats_GetUpdatesResult value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGetUpdates() => $_has(5);
  @$pb.TagNumber(6)
  void clearGetUpdates() => $_clearField(6);
  @$pb.TagNumber(6)
  SecretChats_GetUpdatesResult ensureGetUpdates() => $_ensure(5);

  @$pb.TagNumber(7)
  SecretChats_AckResult get ack => $_getN(6);
  @$pb.TagNumber(7)
  set ack(SecretChats_AckResult value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAck() => $_has(6);
  @$pb.TagNumber(7)
  void clearAck() => $_clearField(7);
  @$pb.TagNumber(7)
  SecretChats_AckResult ensureAck() => $_ensure(6);

  @$pb.TagNumber(8)
  SecretChats_GetFilesResult get getFiles => $_getN(7);
  @$pb.TagNumber(8)
  set getFiles(SecretChats_GetFilesResult value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasGetFiles() => $_has(7);
  @$pb.TagNumber(8)
  void clearGetFiles() => $_clearField(8);
  @$pb.TagNumber(8)
  SecretChats_GetFilesResult ensureGetFiles() => $_ensure(7);

  @$pb.TagNumber(9)
  SecretChats_ReleaseFilesResult get releaseFiles => $_getN(8);
  @$pb.TagNumber(9)
  set releaseFiles(SecretChats_ReleaseFilesResult value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReleaseFiles() => $_has(8);
  @$pb.TagNumber(9)
  void clearReleaseFiles() => $_clearField(9);
  @$pb.TagNumber(9)
  SecretChats_ReleaseFilesResult ensureReleaseFiles() => $_ensure(8);
}

class SecretChats extends $pb.GeneratedMessage {
  factory SecretChats() => create();

  SecretChats._();

  factory SecretChats.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretChats.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretChats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretChats copyWith(void Function(SecretChats) updates) => super.copyWith((message) => updates(message as SecretChats)) as SecretChats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretChats create() => SecretChats._();
  @$core.override
  SecretChats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretChats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretChats>(create);
  static SecretChats? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
