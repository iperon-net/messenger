// This is a generated file - do not edit.
//
// Generated from protos/secret_payload_v1.proto.

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

enum SecretPayload_Payload { text, read, delete, notSet }

/// SecretPayload — открытый текст конверта секретного чата (до шифрования
/// храповиком, lib/crypto/secret_chat.dart). Сервер его не видит и не разбирает
/// — он здесь только ради общего описания формата (как push_payload_v1.proto).
/// Конверт уходит в SecretChats.Send.envelope; см. secret_chats_v1.proto и
/// docs/plans/secret-chats-e2ee.md в репозитории клиента.
class SecretPayload extends $pb.GeneratedMessage {
  factory SecretPayload({
    $core.int? layer,
    SecretText? text,
    SecretRead? read,
    SecretDelete? delete,
  }) {
    final result = create();
    if (layer != null) result.layer = layer;
    if (text != null) result.text = text;
    if (read != null) result.read = read;
    if (delete != null) result.delete = delete;
    return result;
  }

  SecretPayload._();

  factory SecretPayload.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretPayload.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, SecretPayload_Payload> _SecretPayload_PayloadByTag = {
    2: SecretPayload_Payload.text,
    3: SecretPayload_Payload.read,
    4: SecretPayload_Payload.delete,
    0: SecretPayload_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretPayload',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4])
    ..aI(1, _omitFieldNames ? '' : 'layer')
    ..aOM<SecretText>(2, _omitFieldNames ? '' : 'text', subBuilder: SecretText.create)
    ..aOM<SecretRead>(3, _omitFieldNames ? '' : 'read', subBuilder: SecretRead.create)
    ..aOM<SecretDelete>(4, _omitFieldNames ? '' : 'delete', subBuilder: SecretDelete.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretPayload copyWith(void Function(SecretPayload) updates) =>
      super.copyWith((message) => updates(message as SecretPayload)) as SecretPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretPayload create() => SecretPayload._();
  @$core.override
  SecretPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretPayload getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretPayload>(create);
  static SecretPayload? _defaultInstance;

  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  SecretPayload_Payload whichPayload() => _SecretPayload_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  void clearPayload() => $_clearField($_whichOneof(0));

  /// Версия формата у отправителя (как layer в Telegram): новые поля / действия
  /// — новый layer; получатель, не знающий действия, его пропускает.
  @$pb.TagNumber(1)
  $core.int get layer => $_getIZ(0);
  @$pb.TagNumber(1)
  set layer($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayer() => $_clearField(1);

  @$pb.TagNumber(2)
  SecretText get text => $_getN(1);
  @$pb.TagNumber(2)
  set text(SecretText value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
  @$pb.TagNumber(2)
  SecretText ensureText() => $_ensure(1);

  @$pb.TagNumber(3)
  SecretRead get read => $_getN(2);
  @$pb.TagNumber(3)
  set read(SecretRead value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRead() => $_has(2);
  @$pb.TagNumber(3)
  void clearRead() => $_clearField(3);
  @$pb.TagNumber(3)
  SecretRead ensureRead() => $_ensure(2);

  @$pb.TagNumber(4)
  SecretDelete get delete => $_getN(3);
  @$pb.TagNumber(4)
  set delete(SecretDelete value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDelete() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelete() => $_clearField(4);
  @$pb.TagNumber(4)
  SecretDelete ensureDelete() => $_ensure(3);
}

/// Текстовое сообщение. randomID — в SecretChats.Send (одно на отправку).
class SecretText extends $pb.GeneratedMessage {
  factory SecretText({
    $core.String? text,
    $fixnum.Int64? replyToRandomID,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (replyToRandomID != null) result.replyToRandomID = replyToRandomID;
    return result;
  }

  SecretText._();

  factory SecretText.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretText.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretText',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aInt64(2, _omitFieldNames ? '' : 'replyToRandomID', protoName: 'replyToRandomID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretText clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretText copyWith(void Function(SecretText) updates) => super.copyWith((message) => updates(message as SecretText)) as SecretText;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretText create() => SecretText._();
  @$core.override
  SecretText createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretText getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretText>(create);
  static SecretText? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  /// Ответ на сообщение (его randomID); 0 — не ответ.
  @$pb.TagNumber(2)
  $fixnum.Int64 get replyToRandomID => $_getI64(1);
  @$pb.TagNumber(2)
  set replyToRandomID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReplyToRandomID() => $_has(1);
  @$pb.TagNumber(2)
  void clearReplyToRandomID() => $_clearField(2);
}

/// Прочитаны мои сообщения с этими randomID (галочки у отправителя).
class SecretRead extends $pb.GeneratedMessage {
  factory SecretRead({
    $core.Iterable<$fixnum.Int64>? randomIDs,
  }) {
    final result = create();
    if (randomIDs != null) result.randomIDs.addAll(randomIDs);
    return result;
  }

  SecretRead._();

  factory SecretRead.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretRead.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretRead',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'randomIDs', $pb.PbFieldType.K6, protoName: 'randomIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretRead clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretRead copyWith(void Function(SecretRead) updates) => super.copyWith((message) => updates(message as SecretRead)) as SecretRead;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretRead create() => SecretRead._();
  @$core.override
  SecretRead createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretRead getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretRead>(create);
  static SecretRead? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get randomIDs => $_getList(0);
}

/// Удалить сообщения с этими randomID у обоих.
class SecretDelete extends $pb.GeneratedMessage {
  factory SecretDelete({
    $core.Iterable<$fixnum.Int64>? randomIDs,
  }) {
    final result = create();
    if (randomIDs != null) result.randomIDs.addAll(randomIDs);
    return result;
  }

  SecretDelete._();

  factory SecretDelete.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretDelete.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretDelete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$fixnum.Int64>(1, _omitFieldNames ? '' : 'randomIDs', $pb.PbFieldType.K6, protoName: 'randomIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretDelete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretDelete copyWith(void Function(SecretDelete) updates) =>
      super.copyWith((message) => updates(message as SecretDelete)) as SecretDelete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretDelete create() => SecretDelete._();
  @$core.override
  SecretDelete createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretDelete getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretDelete>(create);
  static SecretDelete? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get randomIDs => $_getList(0);
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
