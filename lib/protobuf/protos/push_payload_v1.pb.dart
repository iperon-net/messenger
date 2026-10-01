// This is a generated file - do not edit.
//
// Generated from protos/push_payload_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'push_payload_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'push_payload_v1.pbenum.dart';

/// PushPayload — содержимое push-уведомления. По gRPC не ходит: сервер шифрует
/// его ключом сессии получателя и кладёт в поле `p` пуша (APNs — рядом с `aps`,
/// FCM — в data). Расшифровывает устройство (iOS — Notification Service
/// Extension, Android — FCM-сервис), Apple/Google содержимого не видят.
///
/// Формат `p` (base64 standard):
///   header = version(1 байт, =1) || session[0:8] || nonce(12)
///   key    = HKDF-SHA256(ikm = sharedKey, salt = sharedSalt, info = "iperon-push-v1"), 32 байта
///   p      = base64(header || AES-256-GCM(key, nonce, plaintext = PushPayload, aad = header))
/// session[0:8] — первые 8 байт 32-байтного идентификатора сессии (session.session
/// на клиенте): по нему устройство выбирает ключ (задел под несколько аккаунтов).
/// См. docs/plans/push-notifications.md.
class PushPayload extends $pb.GeneratedMessage {
  factory PushPayload({
    PushPayload_Kind? kind,
    $core.String? id,
    $core.List<$core.int>? fromUserID,
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.String? title,
    $core.String? body,
    $core.Iterable<$core.String>? args,
    $core.int? badge,
    $fixnum.Int64? date,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (id != null) result.id = id;
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (title != null) result.title = title;
    if (body != null) result.body = body;
    if (args != null) result.args.addAll(args);
    if (badge != null) result.badge = badge;
    if (date != null) result.date = date;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  PushPayload._();

  factory PushPayload.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PushPayload.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PushPayload',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<PushPayload_Kind>(1, _omitFieldNames ? '' : 'kind', enumValues: PushPayload_Kind.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'fromUserID', $pb.PbFieldType.OY, protoName: 'fromUserID')
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(5, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOS(6, _omitFieldNames ? '' : 'title')
    ..aOS(7, _omitFieldNames ? '' : 'body')
    ..pPS(8, _omitFieldNames ? '' : 'args')
    ..aI(9, _omitFieldNames ? '' : 'badge')
    ..aInt64(10, _omitFieldNames ? '' : 'date')
    ..p<$fixnum.Int64>(11, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushPayload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PushPayload copyWith(void Function(PushPayload) updates) => super.copyWith((message) => updates(message as PushPayload)) as PushPayload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PushPayload create() => PushPayload._();
  @$core.override
  PushPayload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PushPayload getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PushPayload>(create);
  static PushPayload? _defaultInstance;

  @$pb.TagNumber(1)
  PushPayload_Kind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(PushPayload_Kind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  /// Идентификатор уведомления: им же помечается системное уведомление
  /// (iOS request identifier, Android tag) — повтор доставки заменяет, а не
  /// дублирует; по нему же уведомление потом снимают.
  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get fromUserID => $_getN(2);
  @$pb.TagNumber(3)
  set fromUserID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromUserID() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get chatID => $_getN(3);
  @$pb.TagNumber(4)
  set chatID($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChatID() => $_has(3);
  @$pb.TagNumber(4)
  void clearChatID() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get messageID => $_getI64(4);
  @$pb.TagNumber(5)
  set messageID($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMessageID() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessageID() => $_clearField(5);

  /// Готовый заголовок (имя отправителя: из облачного контакта, профиля или
  /// номер). Пусто — клиент подставит свой (например, для TEST).
  @$pb.TagNumber(6)
  $core.String get title => $_getSZ(5);
  @$pb.TagNumber(6)
  set title($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearTitle() => $_clearField(6);

  /// Текст. Пусто — без превью (настройки/код-пароль) или текст строит клиент.
  @$pb.TagNumber(7)
  $core.String get body => $_getSZ(6);
  @$pb.TagNumber(7)
  set body($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBody() => $_has(6);
  @$pb.TagNumber(7)
  void clearBody() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get args => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get badge => $_getIZ(8);
  @$pb.TagNumber(9)
  set badge($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBadge() => $_has(8);
  @$pb.TagNumber(9)
  void clearBadge() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get date => $_getI64(9);
  @$pb.TagNumber(10)
  set date($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDate() => $_has(9);
  @$pb.TagNumber(10)
  void clearDate() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(10);
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
