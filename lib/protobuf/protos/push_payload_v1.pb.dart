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
    $core.String? senderPhone,
    $core.bool? titleFromContact,
    $core.String? chatTitle,
    $core.bool? isChannel,
    $core.List<$core.int>? parentChatID,
    $fixnum.Int64? postID,
    $core.String? callID,
    $core.bool? video,
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
    if (senderPhone != null) result.senderPhone = senderPhone;
    if (titleFromContact != null) result.titleFromContact = titleFromContact;
    if (chatTitle != null) result.chatTitle = chatTitle;
    if (isChannel != null) result.isChannel = isChannel;
    if (parentChatID != null) result.parentChatID = parentChatID;
    if (postID != null) result.postID = postID;
    if (callID != null) result.callID = callID;
    if (video != null) result.video = video;
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
    ..aOS(12, _omitFieldNames ? '' : 'senderPhone', protoName: 'senderPhone')
    ..aOB(13, _omitFieldNames ? '' : 'titleFromContact', protoName: 'titleFromContact')
    ..aOS(14, _omitFieldNames ? '' : 'chatTitle', protoName: 'chatTitle')
    ..aOB(15, _omitFieldNames ? '' : 'isChannel', protoName: 'isChannel')
    ..a<$core.List<$core.int>>(16, _omitFieldNames ? '' : 'parentChatID', $pb.PbFieldType.OY, protoName: 'parentChatID')
    ..aInt64(17, _omitFieldNames ? '' : 'postID', protoName: 'postID')
    ..aOS(18, _omitFieldNames ? '' : 'callID', protoName: 'callID')
    ..aOB(19, _omitFieldNames ? '' : 'video')
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

  /// Счётчик на иконке приложения — сколько незаглушённых ЧАТОВ не прочитано
  /// (личные, группы, каналы — по одному на чат; решение 2026-10-22, план
  /// chats-channels.md, 4.5). Не
  /// задан — не трогать, 0 — снять. На iOS alert-пуш несёт его ещё и в
  /// aps.badge (система ставит сама), тихий — только здесь (ставит приложение).
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

  /// Номер отправителя (E.164, «+7…»). titleFromContact = false — устройство
  /// ищет номер в своей адресной книге и, если нашло, показывает имя оттуда
  /// вместо title (имён из книги на сервере нет). Порядок имени везде:
  /// облачный контакт → адресная книга → профиль → номер.
  @$pb.TagNumber(12)
  $core.String get senderPhone => $_getSZ(11);
  @$pb.TagNumber(12)
  set senderPhone($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSenderPhone() => $_has(11);
  @$pb.TagNumber(12)
  void clearSenderPhone() => $_clearField(12);

  /// title — имя из облачного контакта получателя: главнее адресной книги.
  @$pb.TagNumber(13)
  $core.bool get titleFromContact => $_getBF(12);
  @$pb.TagNumber(13)
  set titleFromContact($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTitleFromContact() => $_has(12);
  @$pb.TagNumber(13)
  void clearTitleFromContact() => $_clearField(13);

  /// Сообщение в группе: название группы. Устройство показывает его
  /// заголовком, а имя отправителя (title / книга) — в начале текста
  /// («Имя: текст»). Пусто — личный чат. Скрытый на устройстве чат — как
  /// скрытый профиль: без названия и текста.
  @$pb.TagNumber(14)
  $core.String get chatTitle => $_getSZ(13);
  @$pb.TagNumber(14)
  set chatTitle($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasChatTitle() => $_has(13);
  @$pb.TagNumber(14)
  void clearChatTitle() => $_clearField(14);

  /// Пост канала (срез 4): chatTitle — название канала, отправителя нет —
  /// текст без «Имя:».
  @$pb.TagNumber(15)
  $core.bool get isChannel => $_getBF(14);
  @$pb.TagNumber(15)
  set isChannel($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasIsChannel() => $_has(14);
  @$pb.TagNumber(15)
  void clearIsChannel() => $_clearField(15);

  /// Комментарий к посту канала (подэтап 4.3: ответ на мой комментарий или
  /// упоминание — только адресату): chatID — ветка, parentChatID / postID —
  /// канал и пост (тап открывает ветку); chatTitle — название канала, текст —
  /// «Имя: текст», как в группе.
  @$pb.TagNumber(16)
  $core.List<$core.int> get parentChatID => $_getN(15);
  @$pb.TagNumber(16)
  set parentChatID($core.List<$core.int> value) => $_setBytes(15, value);
  @$pb.TagNumber(16)
  $core.bool hasParentChatID() => $_has(15);
  @$pb.TagNumber(16)
  void clearParentChatID() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get postID => $_getI64(16);
  @$pb.TagNumber(17)
  set postID($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasPostID() => $_has(16);
  @$pb.TagNumber(17)
  void clearPostID() => $_clearField(17);

  /// CALL_INCOMING / CALL_CANCEL: идентификатор звонка и вид (видео / аудио).
  @$pb.TagNumber(18)
  $core.String get callID => $_getSZ(17);
  @$pb.TagNumber(18)
  set callID($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCallID() => $_has(17);
  @$pb.TagNumber(18)
  void clearCallID() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get video => $_getBF(18);
  @$pb.TagNumber(19)
  set video($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasVideo() => $_has(18);
  @$pb.TagNumber(19)
  void clearVideo() => $_clearField(19);
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
