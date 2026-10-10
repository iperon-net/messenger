// This is a generated file - do not edit.
//
// Generated from protos/chats_v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'chats_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'chats_v1.pbenum.dart';

/// Разметка текста (как MessageEntity на клиенте, смещения — в UTF-16).
class MessageEntity extends $pb.GeneratedMessage {
  factory MessageEntity({
    MessageEntity_Type? type,
    $core.int? offset,
    $core.int? length,
    $core.String? url,
    $core.List<$core.int>? userID,
    $core.bool? expandable,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (offset != null) result.offset = offset;
    if (length != null) result.length = length;
    if (url != null) result.url = url;
    if (userID != null) result.userID = userID;
    if (expandable != null) result.expandable = expandable;
    return result;
  }

  MessageEntity._();

  factory MessageEntity.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageEntity.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageEntity',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<MessageEntity_Type>(1, _omitFieldNames ? '' : 'type', enumValues: MessageEntity_Type.values)
    ..aI(2, _omitFieldNames ? '' : 'offset')
    ..aI(3, _omitFieldNames ? '' : 'length')
    ..aOS(4, _omitFieldNames ? '' : 'url')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOB(6, _omitFieldNames ? '' : 'expandable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageEntity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageEntity copyWith(void Function(MessageEntity) updates) =>
      super.copyWith((message) => updates(message as MessageEntity)) as MessageEntity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageEntity create() => MessageEntity._();
  @$core.override
  MessageEntity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageEntity>(create);
  static MessageEntity? _defaultInstance;

  @$pb.TagNumber(1)
  MessageEntity_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(MessageEntity_Type value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get offset => $_getIZ(1);
  @$pb.TagNumber(2)
  set offset($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get length => $_getIZ(2);
  @$pb.TagNumber(3)
  set length($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLength() => $_has(2);
  @$pb.TagNumber(3)
  void clearLength() => $_clearField(3);

  /// TEXT_URL — адрес; PRE — язык.
  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => $_clearField(4);

  /// MENTION_NAME — кого упомянули.
  @$pb.TagNumber(5)
  $core.List<$core.int> get userID => $_getN(4);
  @$pb.TagNumber(5)
  set userID($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUserID() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserID() => $_clearField(5);

  /// BLOCKQUOTE — свёрнутая цитата.
  @$pb.TagNumber(6)
  $core.bool get expandable => $_getBF(5);
  @$pb.TagNumber(6)
  set expandable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpandable() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpandable() => $_clearField(6);
}

/// Файл вложения: загружен заранее через Upload (UPLOAD_CONFIRM → cdnID).
class MessageMedia extends $pb.GeneratedMessage {
  factory MessageMedia({
    MessageKind? kind,
    $core.List<$core.int>? cdnID,
    $core.int? width,
    $core.int? height,
    $fixnum.Int64? size,
    $core.String? thumbhash,
    $core.bool? spoiler,
    $core.int? duration,
    $core.String? fileName,
    $core.String? mimeType,
    $core.List<$core.int>? waveform,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (cdnID != null) result.cdnID = cdnID;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (size != null) result.size = size;
    if (thumbhash != null) result.thumbhash = thumbhash;
    if (spoiler != null) result.spoiler = spoiler;
    if (duration != null) result.duration = duration;
    if (fileName != null) result.fileName = fileName;
    if (mimeType != null) result.mimeType = mimeType;
    if (waveform != null) result.waveform = waveform;
    return result;
  }

  MessageMedia._();

  factory MessageMedia.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageMedia.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageMedia',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<MessageKind>(1, _omitFieldNames ? '' : 'kind', enumValues: MessageKind.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'cdnID', $pb.PbFieldType.OY, protoName: 'cdnID')
    ..aI(3, _omitFieldNames ? '' : 'width')
    ..aI(4, _omitFieldNames ? '' : 'height')
    ..aInt64(5, _omitFieldNames ? '' : 'size')
    ..aOS(6, _omitFieldNames ? '' : 'thumbhash')
    ..aOB(7, _omitFieldNames ? '' : 'spoiler')
    ..aI(8, _omitFieldNames ? '' : 'duration')
    ..aOS(9, _omitFieldNames ? '' : 'fileName', protoName: 'fileName')
    ..aOS(10, _omitFieldNames ? '' : 'mimeType', protoName: 'mimeType')
    ..a<$core.List<$core.int>>(11, _omitFieldNames ? '' : 'waveform', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageMedia clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageMedia copyWith(void Function(MessageMedia) updates) =>
      super.copyWith((message) => updates(message as MessageMedia)) as MessageMedia;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageMedia create() => MessageMedia._();
  @$core.override
  MessageMedia createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageMedia getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageMedia>(create);
  static MessageMedia? _defaultInstance;

  @$pb.TagNumber(1)
  MessageKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(MessageKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get cdnID => $_getN(1);
  @$pb.TagNumber(2)
  set cdnID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCdnID() => $_has(1);
  @$pb.TagNumber(2)
  void clearCdnID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get size => $_getI64(4);
  @$pb.TagNumber(5)
  set size($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get thumbhash => $_getSZ(5);
  @$pb.TagNumber(6)
  set thumbhash($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasThumbhash() => $_has(5);
  @$pb.TagNumber(6)
  void clearThumbhash() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get spoiler => $_getBF(6);
  @$pb.TagNumber(7)
  set spoiler($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSpoiler() => $_has(6);
  @$pb.TagNumber(7)
  void clearSpoiler() => $_clearField(7);

  /// Видео / голосовое — секунд.
  @$pb.TagNumber(8)
  $core.int get duration => $_getIZ(7);
  @$pb.TagNumber(8)
  set duration($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDuration() => $_has(7);
  @$pb.TagNumber(8)
  void clearDuration() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get fileName => $_getSZ(8);
  @$pb.TagNumber(9)
  set fileName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFileName() => $_has(8);
  @$pb.TagNumber(9)
  void clearFileName() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get mimeType => $_getSZ(9);
  @$pb.TagNumber(10)
  set mimeType($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMimeType() => $_has(9);
  @$pb.TagNumber(10)
  void clearMimeType() => $_clearField(10);

  /// Голосовое — уровни громкости (0..255), Message.voiceWaveformBars столбцов.
  @$pb.TagNumber(11)
  $core.List<$core.int> get waveform => $_getN(10);
  @$pb.TagNumber(11)
  set waveform($core.List<$core.int> value) => $_setBytes(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWaveform() => $_has(10);
  @$pb.TagNumber(11)
  void clearWaveform() => $_clearField(11);
}

/// Ответ на сообщение (того же чата).
class MessageReplyTo extends $pb.GeneratedMessage {
  factory MessageReplyTo({
    $fixnum.Int64? messageID,
    $core.String? quoteText,
    $core.Iterable<MessageEntity>? quoteEntities,
    $core.int? quoteOffset,
  }) {
    final result = create();
    if (messageID != null) result.messageID = messageID;
    if (quoteText != null) result.quoteText = quoteText;
    if (quoteEntities != null) result.quoteEntities.addAll(quoteEntities);
    if (quoteOffset != null) result.quoteOffset = quoteOffset;
    return result;
  }

  MessageReplyTo._();

  factory MessageReplyTo.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageReplyTo.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageReplyTo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOS(2, _omitFieldNames ? '' : 'quoteText', protoName: 'quoteText')
    ..pPM<MessageEntity>(3, _omitFieldNames ? '' : 'quoteEntities', protoName: 'quoteEntities', subBuilder: MessageEntity.create)
    ..aI(4, _omitFieldNames ? '' : 'quoteOffset', protoName: 'quoteOffset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReplyTo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReplyTo copyWith(void Function(MessageReplyTo) updates) =>
      super.copyWith((message) => updates(message as MessageReplyTo)) as MessageReplyTo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageReplyTo create() => MessageReplyTo._();
  @$core.override
  MessageReplyTo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageReplyTo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageReplyTo>(create);
  static MessageReplyTo? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get messageID => $_getI64(0);
  @$pb.TagNumber(1)
  set messageID($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessageID() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageID() => $_clearField(1);

  /// Цитата — выделенный фрагмент исходного сообщения.
  @$pb.TagNumber(2)
  $core.String get quoteText => $_getSZ(1);
  @$pb.TagNumber(2)
  set quoteText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuoteText() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuoteText() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<MessageEntity> get quoteEntities => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get quoteOffset => $_getIZ(3);
  @$pb.TagNumber(4)
  set quoteOffset($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuoteOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuoteOffset() => $_clearField(4);
}

/// Пересланное: от кого (имя на момент пересылки; self — «Вы»).
class MessageForward extends $pb.GeneratedMessage {
  factory MessageForward({
    $core.List<$core.int>? fromUserID,
    $core.String? fromName,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (fromName != null) result.fromName = fromName;
    if (date != null) result.date = date;
    return result;
  }

  MessageForward._();

  factory MessageForward.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageForward.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageForward',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'fromUserID', $pb.PbFieldType.OY, protoName: 'fromUserID')
    ..aOS(2, _omitFieldNames ? '' : 'fromName', protoName: 'fromName')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageForward clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageForward copyWith(void Function(MessageForward) updates) =>
      super.copyWith((message) => updates(message as MessageForward)) as MessageForward;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageForward create() => MessageForward._();
  @$core.override
  MessageForward createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageForward getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageForward>(create);
  static MessageForward? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get fromUserID => $_getN(0);
  @$pb.TagNumber(1)
  set fromUserID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFromUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);
}

/// Содержимое сообщения. На сервере хранится ОДНИМ зашифрованным блобом
/// (messages.contentEncrypted, crypto.Encryptor) — открыты только chatID,
/// messageID, отправитель, дата и флаги.
class MessageContent extends $pb.GeneratedMessage {
  factory MessageContent({
    $core.String? text,
    $core.Iterable<MessageEntity>? entities,
    $core.Iterable<MessageMedia>? media,
    MessageReplyTo? replyTo,
    MessageForward? forward,
    $core.bool? noLinkPreview,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (entities != null) result.entities.addAll(entities);
    if (media != null) result.media.addAll(media);
    if (replyTo != null) result.replyTo = replyTo;
    if (forward != null) result.forward = forward;
    if (noLinkPreview != null) result.noLinkPreview = noLinkPreview;
    return result;
  }

  MessageContent._();

  factory MessageContent.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageContent.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageContent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..pPM<MessageEntity>(2, _omitFieldNames ? '' : 'entities', subBuilder: MessageEntity.create)
    ..pPM<MessageMedia>(3, _omitFieldNames ? '' : 'media', subBuilder: MessageMedia.create)
    ..aOM<MessageReplyTo>(4, _omitFieldNames ? '' : 'replyTo', protoName: 'replyTo', subBuilder: MessageReplyTo.create)
    ..aOM<MessageForward>(5, _omitFieldNames ? '' : 'forward', subBuilder: MessageForward.create)
    ..aOB(6, _omitFieldNames ? '' : 'noLinkPreview', protoName: 'noLinkPreview')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageContent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageContent copyWith(void Function(MessageContent) updates) =>
      super.copyWith((message) => updates(message as MessageContent)) as MessageContent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageContent create() => MessageContent._();
  @$core.override
  MessageContent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageContent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageContent>(create);
  static MessageContent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<MessageEntity> get entities => $_getList(1);

  /// Альбом — несколько; один файл / голосовое — один элемент.
  @$pb.TagNumber(3)
  $pb.PbList<MessageMedia> get media => $_getList(2);

  @$pb.TagNumber(4)
  MessageReplyTo get replyTo => $_getN(3);
  @$pb.TagNumber(4)
  set replyTo(MessageReplyTo value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReplyTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearReplyTo() => $_clearField(4);
  @$pb.TagNumber(4)
  MessageReplyTo ensureReplyTo() => $_ensure(3);

  @$pb.TagNumber(5)
  MessageForward get forward => $_getN(4);
  @$pb.TagNumber(5)
  set forward(MessageForward value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasForward() => $_has(4);
  @$pb.TagNumber(5)
  void clearForward() => $_clearField(5);
  @$pb.TagNumber(5)
  MessageForward ensureForward() => $_ensure(4);

  /// true — отправитель убрал превью ссылки.
  @$pb.TagNumber(6)
  $core.bool get noLinkPreview => $_getBF(5);
  @$pb.TagNumber(6)
  set noLinkPreview($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNoLinkPreview() => $_has(5);
  @$pb.TagNumber(6)
  void clearNoLinkPreview() => $_clearField(6);
}

/// Сообщение «глазами получателя»: outgoing = fromUserID == я; прочитано ли
/// исходящее — сравнением messageID с Dialog.readOutboxMaxID.
class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.List<$core.int>? fromUserID,
    $fixnum.Int64? date,
    $fixnum.Int64? editDate,
    MessageContent? content,
    $core.bool? mediaUnread,
    $core.bool? silent,
    $fixnum.Int64? randomID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (fromUserID != null) result.fromUserID = fromUserID;
    if (date != null) result.date = date;
    if (editDate != null) result.editDate = editDate;
    if (content != null) result.content = content;
    if (mediaUnread != null) result.mediaUnread = mediaUnread;
    if (silent != null) result.silent = silent;
    if (randomID != null) result.randomID = randomID;
    return result;
  }

  ChatMessage._();

  factory ChatMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'fromUserID', $pb.PbFieldType.OY, protoName: 'fromUserID')
    ..aInt64(4, _omitFieldNames ? '' : 'date')
    ..aInt64(5, _omitFieldNames ? '' : 'editDate', protoName: 'editDate')
    ..aOM<MessageContent>(6, _omitFieldNames ? '' : 'content', subBuilder: MessageContent.create)
    ..aOB(7, _omitFieldNames ? '' : 'mediaUnread', protoName: 'mediaUnread')
    ..aOB(8, _omitFieldNames ? '' : 'silent')
    ..aInt64(9, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage)) as ChatMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  @$core.override
  ChatMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get fromUserID => $_getN(2);
  @$pb.TagNumber(3)
  set fromUserID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromUserID() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get date => $_getI64(3);
  @$pb.TagNumber(4)
  set date($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearDate() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get editDate => $_getI64(4);
  @$pb.TagNumber(5)
  set editDate($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEditDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearEditDate() => $_clearField(5);

  @$pb.TagNumber(6)
  MessageContent get content => $_getN(5);
  @$pb.TagNumber(6)
  set content(MessageContent value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);
  @$pb.TagNumber(6)
  MessageContent ensureContent() => $_ensure(5);

  /// Голосовое ещё не прослушано получателем (точка у длительности).
  @$pb.TagNumber(7)
  $core.bool get mediaUnread => $_getBF(6);
  @$pb.TagNumber(7)
  set mediaUnread($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMediaUnread() => $_has(6);
  @$pb.TagNumber(7)
  void clearMediaUnread() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get silent => $_getBF(7);
  @$pb.TagNumber(8)
  set silent($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSilent() => $_has(7);
  @$pb.TagNumber(8)
  void clearSilent() => $_clearField(8);

  /// Отправитель задал при отправке (идемпотентность, сопоставление с outbox).
  @$pb.TagNumber(9)
  $fixnum.Int64 get randomID => $_getI64(8);
  @$pb.TagNumber(9)
  set randomID($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRandomID() => $_has(8);
  @$pb.TagNumber(9)
  void clearRandomID() => $_clearField(9);
}

/// Диалог пользователя: общий чат + моё состояние в нём.
class Dialog extends $pb.GeneratedMessage {
  factory Dialog({
    $core.List<$core.int>? chatID,
    ChatType? type,
    $core.List<$core.int>? peerUserID,
    ChatMessage? topMessage,
    $fixnum.Int64? readInboxMaxID,
    $fixnum.Int64? readOutboxMaxID,
    $core.int? unreadCount,
    $core.bool? pinned,
    $core.bool? archived,
    $core.bool? markedUnread,
    $fixnum.Int64? mutedUntil,
    $fixnum.Int64? createdAt,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (type != null) result.type = type;
    if (peerUserID != null) result.peerUserID = peerUserID;
    if (topMessage != null) result.topMessage = topMessage;
    if (readInboxMaxID != null) result.readInboxMaxID = readInboxMaxID;
    if (readOutboxMaxID != null) result.readOutboxMaxID = readOutboxMaxID;
    if (unreadCount != null) result.unreadCount = unreadCount;
    if (pinned != null) result.pinned = pinned;
    if (archived != null) result.archived = archived;
    if (markedUnread != null) result.markedUnread = markedUnread;
    if (mutedUntil != null) result.mutedUntil = mutedUntil;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  Dialog._();

  factory Dialog.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Dialog.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Dialog',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aE<ChatType>(2, _omitFieldNames ? '' : 'type', enumValues: ChatType.values)
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'peerUserID', $pb.PbFieldType.OY, protoName: 'peerUserID')
    ..aOM<ChatMessage>(4, _omitFieldNames ? '' : 'topMessage', protoName: 'topMessage', subBuilder: ChatMessage.create)
    ..aInt64(5, _omitFieldNames ? '' : 'readInboxMaxID', protoName: 'readInboxMaxID')
    ..aInt64(6, _omitFieldNames ? '' : 'readOutboxMaxID', protoName: 'readOutboxMaxID')
    ..aI(7, _omitFieldNames ? '' : 'unreadCount', protoName: 'unreadCount')
    ..aOB(8, _omitFieldNames ? '' : 'pinned')
    ..aOB(9, _omitFieldNames ? '' : 'archived')
    ..aOB(10, _omitFieldNames ? '' : 'markedUnread', protoName: 'markedUnread')
    ..aInt64(11, _omitFieldNames ? '' : 'mutedUntil', protoName: 'mutedUntil')
    ..aInt64(12, _omitFieldNames ? '' : 'createdAt', protoName: 'createdAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dialog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Dialog copyWith(void Function(Dialog) updates) => super.copyWith((message) => updates(message as Dialog)) as Dialog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Dialog create() => Dialog._();
  @$core.override
  Dialog createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Dialog getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dialog>(create);
  static Dialog? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  ChatType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(ChatType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  /// Личный чат — собеседник (у «Избранного» — я сам).
  @$pb.TagNumber(3)
  $core.List<$core.int> get peerUserID => $_getN(2);
  @$pb.TagNumber(3)
  set peerUserID($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeerUserID() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeerUserID() => $_clearField(3);

  /// Последнее сообщение (нет — пустой чат).
  @$pb.TagNumber(4)
  ChatMessage get topMessage => $_getN(3);
  @$pb.TagNumber(4)
  set topMessage(ChatMessage value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTopMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearTopMessage() => $_clearField(4);
  @$pb.TagNumber(4)
  ChatMessage ensureTopMessage() => $_ensure(3);

  /// До какого messageID я прочитал входящие.
  @$pb.TagNumber(5)
  $fixnum.Int64 get readInboxMaxID => $_getI64(4);
  @$pb.TagNumber(5)
  set readInboxMaxID($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReadInboxMaxID() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadInboxMaxID() => $_clearField(5);

  /// До какого messageID собеседник прочитал мои.
  @$pb.TagNumber(6)
  $fixnum.Int64 get readOutboxMaxID => $_getI64(5);
  @$pb.TagNumber(6)
  set readOutboxMaxID($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReadOutboxMaxID() => $_has(5);
  @$pb.TagNumber(6)
  void clearReadOutboxMaxID() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get unreadCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set unreadCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUnreadCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnreadCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get pinned => $_getBF(7);
  @$pb.TagNumber(8)
  set pinned($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPinned() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinned() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get archived => $_getBF(8);
  @$pb.TagNumber(9)
  set archived($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasArchived() => $_has(8);
  @$pb.TagNumber(9)
  void clearArchived() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get markedUnread => $_getBF(9);
  @$pb.TagNumber(10)
  set markedUnread($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMarkedUnread() => $_has(9);
  @$pb.TagNumber(10)
  void clearMarkedUnread() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get mutedUntil => $_getI64(10);
  @$pb.TagNumber(11)
  set mutedUntil($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMutedUntil() => $_has(10);
  @$pb.TagNumber(11)
  void clearMutedUntil() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get createdAt => $_getI64(11);
  @$pb.TagNumber(12)
  set createdAt($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
}

/// Состояние журнала обновлений пользователя.
class UpdatesState extends $pb.GeneratedMessage {
  factory UpdatesState({
    $fixnum.Int64? pts,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (pts != null) result.pts = pts;
    if (date != null) result.date = date;
    return result;
  }

  UpdatesState._();

  factory UpdatesState.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdatesState.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdatesState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pts')
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatesState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdatesState copyWith(void Function(UpdatesState) updates) =>
      super.copyWith((message) => updates(message as UpdatesState)) as UpdatesState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatesState create() => UpdatesState._();
  @$core.override
  UpdatesState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdatesState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdatesState>(create);
  static UpdatesState? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pts => $_getI64(0);
  @$pb.TagNumber(1)
  set pts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);
}

class Update_NewMessage extends $pb.GeneratedMessage {
  factory Update_NewMessage({
    ChatMessage? message,
    Dialog? dialog,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Update_NewMessage._();

  factory Update_NewMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_NewMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.NewMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatMessage>(1, _omitFieldNames ? '' : 'message', subBuilder: ChatMessage.create)
    ..aOM<Dialog>(2, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_NewMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_NewMessage copyWith(void Function(Update_NewMessage) updates) =>
      super.copyWith((message) => updates(message as Update_NewMessage)) as Update_NewMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_NewMessage create() => Update_NewMessage._();
  @$core.override
  Update_NewMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_NewMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_NewMessage>(create);
  static Update_NewMessage? _defaultInstance;

  @$pb.TagNumber(1)
  ChatMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ChatMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessage ensureMessage() => $_ensure(0);

  /// Чат появился у пользователя этим сообщением (первое в личном чате).
  @$pb.TagNumber(2)
  Dialog get dialog => $_getN(1);
  @$pb.TagNumber(2)
  set dialog(Dialog value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDialog() => $_has(1);
  @$pb.TagNumber(2)
  void clearDialog() => $_clearField(2);
  @$pb.TagNumber(2)
  Dialog ensureDialog() => $_ensure(1);
}

class Update_EditMessage extends $pb.GeneratedMessage {
  factory Update_EditMessage({
    ChatMessage? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  Update_EditMessage._();

  factory Update_EditMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_EditMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.EditMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatMessage>(1, _omitFieldNames ? '' : 'message', subBuilder: ChatMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_EditMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_EditMessage copyWith(void Function(Update_EditMessage) updates) =>
      super.copyWith((message) => updates(message as Update_EditMessage)) as Update_EditMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_EditMessage create() => Update_EditMessage._();
  @$core.override
  Update_EditMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_EditMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_EditMessage>(create);
  static Update_EditMessage? _defaultInstance;

  @$pb.TagNumber(1)
  ChatMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ChatMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessage ensureMessage() => $_ensure(0);
}

class Update_DeleteMessages extends $pb.GeneratedMessage {
  factory Update_DeleteMessages({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Update_DeleteMessages._();

  factory Update_DeleteMessages.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_DeleteMessages.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.DeleteMessages',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DeleteMessages clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DeleteMessages copyWith(void Function(Update_DeleteMessages) updates) =>
      super.copyWith((message) => updates(message as Update_DeleteMessages)) as Update_DeleteMessages;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_DeleteMessages create() => Update_DeleteMessages._();
  @$core.override
  Update_DeleteMessages createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_DeleteMessages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_DeleteMessages>(create);
  static Update_DeleteMessages? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

/// Я прочитал входящие до maxID (на этом или другом устройстве).
class Update_ReadInbox extends $pb.GeneratedMessage {
  factory Update_ReadInbox({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? maxID,
    $core.int? unreadCount,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (maxID != null) result.maxID = maxID;
    if (unreadCount != null) result.unreadCount = unreadCount;
    return result;
  }

  Update_ReadInbox._();

  factory Update_ReadInbox.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ReadInbox.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ReadInbox',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'maxID', protoName: 'maxID')
    ..aI(3, _omitFieldNames ? '' : 'unreadCount', protoName: 'unreadCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadInbox clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadInbox copyWith(void Function(Update_ReadInbox) updates) =>
      super.copyWith((message) => updates(message as Update_ReadInbox)) as Update_ReadInbox;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ReadInbox create() => Update_ReadInbox._();
  @$core.override
  Update_ReadInbox createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ReadInbox getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ReadInbox>(create);
  static Update_ReadInbox? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxID => $_getI64(1);
  @$pb.TagNumber(2)
  set maxID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get unreadCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set unreadCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnreadCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnreadCount() => $_clearField(3);
}

/// Собеседник прочитал мои до maxID (✓✓).
class Update_ReadOutbox extends $pb.GeneratedMessage {
  factory Update_ReadOutbox({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? maxID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (maxID != null) result.maxID = maxID;
    return result;
  }

  Update_ReadOutbox._();

  factory Update_ReadOutbox.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ReadOutbox.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ReadOutbox',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'maxID', protoName: 'maxID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadOutbox clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadOutbox copyWith(void Function(Update_ReadOutbox) updates) =>
      super.copyWith((message) => updates(message as Update_ReadOutbox)) as Update_ReadOutbox;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ReadOutbox create() => Update_ReadOutbox._();
  @$core.override
  Update_ReadOutbox createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ReadOutbox getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ReadOutbox>(create);
  static Update_ReadOutbox? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxID => $_getI64(1);
  @$pb.TagNumber(2)
  set maxID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxID() => $_clearField(2);
}

/// Голосовые прослушаны.
class Update_ReadContents extends $pb.GeneratedMessage {
  factory Update_ReadContents({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Update_ReadContents._();

  factory Update_ReadContents.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ReadContents.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ReadContents',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadContents clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadContents copyWith(void Function(Update_ReadContents) updates) =>
      super.copyWith((message) => updates(message as Update_ReadContents)) as Update_ReadContents;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ReadContents create() => Update_ReadContents._();
  @$core.override
  Update_ReadContents createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ReadContents getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ReadContents>(create);
  static Update_ReadContents? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

/// Изменились мои настройки диалога (закреп/архив/звук/пометка).
class Update_DialogSettings extends $pb.GeneratedMessage {
  factory Update_DialogSettings({
    Dialog? dialog,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Update_DialogSettings._();

  factory Update_DialogSettings.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_DialogSettings.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.DialogSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogSettings copyWith(void Function(Update_DialogSettings) updates) =>
      super.copyWith((message) => updates(message as Update_DialogSettings)) as Update_DialogSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_DialogSettings create() => Update_DialogSettings._();
  @$core.override
  Update_DialogSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_DialogSettings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_DialogSettings>(create);
  static Update_DialogSettings? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);
}

/// Диалог удалён у меня (история очищена).
class Update_DialogDeleted extends $pb.GeneratedMessage {
  factory Update_DialogDeleted({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Update_DialogDeleted._();

  factory Update_DialogDeleted.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_DialogDeleted.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.DialogDeleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogDeleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_DialogDeleted copyWith(void Function(Update_DialogDeleted) updates) =>
      super.copyWith((message) => updates(message as Update_DialogDeleted)) as Update_DialogDeleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_DialogDeleted create() => Update_DialogDeleted._();
  @$core.override
  Update_DialogDeleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_DialogDeleted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_DialogDeleted>(create);
  static Update_DialogDeleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

enum Update_Update { newMessage, editMessage, deleteMessages, readInbox, readOutbox, readContents, dialogSettings, dialogDeleted, notSet }

/// Одно обновление журнала. pts — номер обновления у пользователя (без дыр:
/// клиент, получив pts > своего + 1, догоняет через GET_DIFFERENCE).
class Update extends $pb.GeneratedMessage {
  factory Update({
    $fixnum.Int64? pts,
    $fixnum.Int64? date,
    Update_NewMessage? newMessage,
    Update_EditMessage? editMessage,
    Update_DeleteMessages? deleteMessages,
    Update_ReadInbox? readInbox,
    Update_ReadOutbox? readOutbox,
    Update_ReadContents? readContents,
    Update_DialogSettings? dialogSettings,
    Update_DialogDeleted? dialogDeleted,
  }) {
    final result = create();
    if (pts != null) result.pts = pts;
    if (date != null) result.date = date;
    if (newMessage != null) result.newMessage = newMessage;
    if (editMessage != null) result.editMessage = editMessage;
    if (deleteMessages != null) result.deleteMessages = deleteMessages;
    if (readInbox != null) result.readInbox = readInbox;
    if (readOutbox != null) result.readOutbox = readOutbox;
    if (readContents != null) result.readContents = readContents;
    if (dialogSettings != null) result.dialogSettings = dialogSettings;
    if (dialogDeleted != null) result.dialogDeleted = dialogDeleted;
    return result;
  }

  Update._();

  factory Update.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Update_Update> _Update_UpdateByTag = {
    3: Update_Update.newMessage,
    4: Update_Update.editMessage,
    5: Update_Update.deleteMessages,
    6: Update_Update.readInbox,
    7: Update_Update.readOutbox,
    8: Update_Update.readContents,
    9: Update_Update.dialogSettings,
    10: Update_Update.dialogDeleted,
    0: Update_Update.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8, 9, 10])
    ..aInt64(1, _omitFieldNames ? '' : 'pts')
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..aOM<Update_NewMessage>(3, _omitFieldNames ? '' : 'newMessage', protoName: 'newMessage', subBuilder: Update_NewMessage.create)
    ..aOM<Update_EditMessage>(4, _omitFieldNames ? '' : 'editMessage', protoName: 'editMessage', subBuilder: Update_EditMessage.create)
    ..aOM<Update_DeleteMessages>(5, _omitFieldNames ? '' : 'deleteMessages',
        protoName: 'deleteMessages', subBuilder: Update_DeleteMessages.create)
    ..aOM<Update_ReadInbox>(6, _omitFieldNames ? '' : 'readInbox', protoName: 'readInbox', subBuilder: Update_ReadInbox.create)
    ..aOM<Update_ReadOutbox>(7, _omitFieldNames ? '' : 'readOutbox', protoName: 'readOutbox', subBuilder: Update_ReadOutbox.create)
    ..aOM<Update_ReadContents>(8, _omitFieldNames ? '' : 'readContents', protoName: 'readContents', subBuilder: Update_ReadContents.create)
    ..aOM<Update_DialogSettings>(9, _omitFieldNames ? '' : 'dialogSettings',
        protoName: 'dialogSettings', subBuilder: Update_DialogSettings.create)
    ..aOM<Update_DialogDeleted>(10, _omitFieldNames ? '' : 'dialogDeleted',
        protoName: 'dialogDeleted', subBuilder: Update_DialogDeleted.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update copyWith(void Function(Update) updates) => super.copyWith((message) => updates(message as Update)) as Update;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update create() => Update._();
  @$core.override
  Update createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update>(create);
  static Update? _defaultInstance;

  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  Update_Update whichUpdate() => _Update_UpdateByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  void clearUpdate() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get pts => $_getI64(0);
  @$pb.TagNumber(1)
  set pts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);

  @$pb.TagNumber(3)
  Update_NewMessage get newMessage => $_getN(2);
  @$pb.TagNumber(3)
  set newMessage(Update_NewMessage value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNewMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewMessage() => $_clearField(3);
  @$pb.TagNumber(3)
  Update_NewMessage ensureNewMessage() => $_ensure(2);

  @$pb.TagNumber(4)
  Update_EditMessage get editMessage => $_getN(3);
  @$pb.TagNumber(4)
  set editMessage(Update_EditMessage value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEditMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearEditMessage() => $_clearField(4);
  @$pb.TagNumber(4)
  Update_EditMessage ensureEditMessage() => $_ensure(3);

  @$pb.TagNumber(5)
  Update_DeleteMessages get deleteMessages => $_getN(4);
  @$pb.TagNumber(5)
  set deleteMessages(Update_DeleteMessages value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeleteMessages() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeleteMessages() => $_clearField(5);
  @$pb.TagNumber(5)
  Update_DeleteMessages ensureDeleteMessages() => $_ensure(4);

  @$pb.TagNumber(6)
  Update_ReadInbox get readInbox => $_getN(5);
  @$pb.TagNumber(6)
  set readInbox(Update_ReadInbox value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReadInbox() => $_has(5);
  @$pb.TagNumber(6)
  void clearReadInbox() => $_clearField(6);
  @$pb.TagNumber(6)
  Update_ReadInbox ensureReadInbox() => $_ensure(5);

  @$pb.TagNumber(7)
  Update_ReadOutbox get readOutbox => $_getN(6);
  @$pb.TagNumber(7)
  set readOutbox(Update_ReadOutbox value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReadOutbox() => $_has(6);
  @$pb.TagNumber(7)
  void clearReadOutbox() => $_clearField(7);
  @$pb.TagNumber(7)
  Update_ReadOutbox ensureReadOutbox() => $_ensure(6);

  @$pb.TagNumber(8)
  Update_ReadContents get readContents => $_getN(7);
  @$pb.TagNumber(8)
  set readContents(Update_ReadContents value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReadContents() => $_has(7);
  @$pb.TagNumber(8)
  void clearReadContents() => $_clearField(8);
  @$pb.TagNumber(8)
  Update_ReadContents ensureReadContents() => $_ensure(7);

  @$pb.TagNumber(9)
  Update_DialogSettings get dialogSettings => $_getN(8);
  @$pb.TagNumber(9)
  set dialogSettings(Update_DialogSettings value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDialogSettings() => $_has(8);
  @$pb.TagNumber(9)
  void clearDialogSettings() => $_clearField(9);
  @$pb.TagNumber(9)
  Update_DialogSettings ensureDialogSettings() => $_ensure(8);

  @$pb.TagNumber(10)
  Update_DialogDeleted get dialogDeleted => $_getN(9);
  @$pb.TagNumber(10)
  set dialogDeleted(Update_DialogDeleted value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDialogDeleted() => $_has(9);
  @$pb.TagNumber(10)
  void clearDialogDeleted() => $_clearField(10);
  @$pb.TagNumber(10)
  Update_DialogDeleted ensureDialogDeleted() => $_ensure(9);
}

/// UPDATES — push по стриму (сервер → клиент): одно или несколько обновлений
/// подряд. Ответ на запросы MESSAGES тоже несёт обновления, которые запрос
/// породил (клиент применяет их сразу, не дожидаясь push).
class Updates extends $pb.GeneratedMessage {
  factory Updates({
    $core.Iterable<Update>? updates,
    UpdatesState? state,
  }) {
    final result = create();
    if (updates != null) result.updates.addAll(updates);
    if (state != null) result.state = state;
    return result;
  }

  Updates._();

  factory Updates.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Updates.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Updates',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Update>(1, _omitFieldNames ? '' : 'updates', subBuilder: Update.create)
    ..aOM<UpdatesState>(2, _omitFieldNames ? '' : 'state', subBuilder: UpdatesState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Updates clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Updates copyWith(void Function(Updates) updates) => super.copyWith((message) => updates(message as Updates)) as Updates;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Updates create() => Updates._();
  @$core.override
  Updates createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Updates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Updates>(create);
  static Updates? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Update> get updates => $_getList(0);

  @$pb.TagNumber(2)
  UpdatesState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(UpdatesState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdatesState ensureState() => $_ensure(1);
}

/// Страница списка диалогов: по убыванию даты последнего сообщения.
class Chats_List extends $pb.GeneratedMessage {
  factory Chats_List({
    $fixnum.Int64? offsetDate,
    $core.List<$core.int>? offsetChatID,
    $core.int? limit,
  }) {
    final result = create();
    if (offsetDate != null) result.offsetDate = offsetDate;
    if (offsetChatID != null) result.offsetChatID = offsetChatID;
    if (limit != null) result.limit = limit;
    return result;
  }

  Chats_List._();

  factory Chats_List.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_List.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.List',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'offsetDate', protoName: 'offsetDate')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'offsetChatID', $pb.PbFieldType.OY, protoName: 'offsetChatID')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_List clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_List copyWith(void Function(Chats_List) updates) => super.copyWith((message) => updates(message as Chats_List)) as Chats_List;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_List create() => Chats_List._();
  @$core.override
  Chats_List createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_List getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_List>(create);
  static Chats_List? _defaultInstance;

  /// Курсор: дата последнего сообщения последнего диалога предыдущей
  /// страницы (unix millis) + его chatID; 0/пусто — с начала.
  @$pb.TagNumber(1)
  $fixnum.Int64 get offsetDate => $_getI64(0);
  @$pb.TagNumber(1)
  set offsetDate($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOffsetDate() => $_has(0);
  @$pb.TagNumber(1)
  void clearOffsetDate() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get offsetChatID => $_getN(1);
  @$pb.TagNumber(2)
  set offsetChatID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffsetChatID() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffsetChatID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class Chats_ListResult extends $pb.GeneratedMessage {
  factory Chats_ListResult({
    $core.Iterable<Dialog>? dialogs,
    $core.bool? hasMore,
    UpdatesState? state,
  }) {
    final result = create();
    if (dialogs != null) result.dialogs.addAll(dialogs);
    if (hasMore != null) result.hasMore = hasMore;
    if (state != null) result.state = state;
    return result;
  }

  Chats_ListResult._();

  factory Chats_ListResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ListResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ListResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Dialog>(1, _omitFieldNames ? '' : 'dialogs', subBuilder: Dialog.create)
    ..aOB(2, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..aOM<UpdatesState>(3, _omitFieldNames ? '' : 'state', subBuilder: UpdatesState.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ListResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ListResult copyWith(void Function(Chats_ListResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ListResult)) as Chats_ListResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ListResult create() => Chats_ListResult._();
  @$core.override
  Chats_ListResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ListResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ListResult>(create);
  static Chats_ListResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Dialog> get dialogs => $_getList(0);

  /// Есть ещё страницы.
  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);

  /// Текущий pts — после загрузки списка клиент догоняет от него.
  @$pb.TagNumber(3)
  UpdatesState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(UpdatesState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);
  @$pb.TagNumber(3)
  UpdatesState ensureState() => $_ensure(2);
}

/// Личный чат с пользователем: существующий или новый (создаётся сразу,
/// пустой; у собеседника появится с первым сообщением).
class Chats_OpenPrivate extends $pb.GeneratedMessage {
  factory Chats_OpenPrivate({
    $core.List<$core.int>? userID,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    return result;
  }

  Chats_OpenPrivate._();

  factory Chats_OpenPrivate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_OpenPrivate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.OpenPrivate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_OpenPrivate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_OpenPrivate copyWith(void Function(Chats_OpenPrivate) updates) =>
      super.copyWith((message) => updates(message as Chats_OpenPrivate)) as Chats_OpenPrivate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_OpenPrivate create() => Chats_OpenPrivate._();
  @$core.override
  Chats_OpenPrivate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_OpenPrivate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_OpenPrivate>(create);
  static Chats_OpenPrivate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);
}

class Chats_OpenPrivateResult extends $pb.GeneratedMessage {
  factory Chats_OpenPrivateResult({
    Dialog? dialog,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Chats_OpenPrivateResult._();

  factory Chats_OpenPrivateResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_OpenPrivateResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.OpenPrivateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_OpenPrivateResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_OpenPrivateResult copyWith(void Function(Chats_OpenPrivateResult) updates) =>
      super.copyWith((message) => updates(message as Chats_OpenPrivateResult)) as Chats_OpenPrivateResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_OpenPrivateResult create() => Chats_OpenPrivateResult._();
  @$core.override
  Chats_OpenPrivateResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_OpenPrivateResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_OpenPrivateResult>(create);
  static Chats_OpenPrivateResult? _defaultInstance;

  @$pb.TagNumber(1)
  Dialog get dialog => $_getN(0);
  @$pb.TagNumber(1)
  set dialog(Dialog value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDialog() => $_has(0);
  @$pb.TagNumber(1)
  void clearDialog() => $_clearField(1);
  @$pb.TagNumber(1)
  Dialog ensureDialog() => $_ensure(0);
}

/// Прочитать входящие до maxID.
class Chats_ReadHistory extends $pb.GeneratedMessage {
  factory Chats_ReadHistory({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? maxID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (maxID != null) result.maxID = maxID;
    return result;
  }

  Chats_ReadHistory._();

  factory Chats_ReadHistory.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReadHistory.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReadHistory',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'maxID', protoName: 'maxID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadHistory clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadHistory copyWith(void Function(Chats_ReadHistory) updates) =>
      super.copyWith((message) => updates(message as Chats_ReadHistory)) as Chats_ReadHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReadHistory create() => Chats_ReadHistory._();
  @$core.override
  Chats_ReadHistory createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReadHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReadHistory>(create);
  static Chats_ReadHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxID => $_getI64(1);
  @$pb.TagNumber(2)
  set maxID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxID() => $_clearField(2);
}

class Chats_ReadHistoryResult extends $pb.GeneratedMessage {
  factory Chats_ReadHistoryResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_ReadHistoryResult._();

  factory Chats_ReadHistoryResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReadHistoryResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReadHistoryResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadHistoryResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadHistoryResult copyWith(void Function(Chats_ReadHistoryResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ReadHistoryResult)) as Chats_ReadHistoryResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReadHistoryResult create() => Chats_ReadHistoryResult._();
  @$core.override
  Chats_ReadHistoryResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReadHistoryResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReadHistoryResult>(create);
  static Chats_ReadHistoryResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Мои настройки диалога. Отсутствующее поле — не менять.
class Chats_SetDialog extends $pb.GeneratedMessage {
  factory Chats_SetDialog({
    $core.List<$core.int>? chatID,
    $core.bool? pinned,
    $core.bool? archived,
    $core.bool? markedUnread,
    $fixnum.Int64? mutedUntil,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (pinned != null) result.pinned = pinned;
    if (archived != null) result.archived = archived;
    if (markedUnread != null) result.markedUnread = markedUnread;
    if (mutedUntil != null) result.mutedUntil = mutedUntil;
    return result;
  }

  Chats_SetDialog._();

  factory Chats_SetDialog.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetDialog.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetDialog',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOB(2, _omitFieldNames ? '' : 'pinned')
    ..aOB(3, _omitFieldNames ? '' : 'archived')
    ..aOB(4, _omitFieldNames ? '' : 'markedUnread', protoName: 'markedUnread')
    ..aInt64(5, _omitFieldNames ? '' : 'mutedUntil', protoName: 'mutedUntil')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetDialog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetDialog copyWith(void Function(Chats_SetDialog) updates) =>
      super.copyWith((message) => updates(message as Chats_SetDialog)) as Chats_SetDialog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetDialog create() => Chats_SetDialog._();
  @$core.override
  Chats_SetDialog createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetDialog getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetDialog>(create);
  static Chats_SetDialog? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get pinned => $_getBF(1);
  @$pb.TagNumber(2)
  set pinned($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPinned() => $_has(1);
  @$pb.TagNumber(2)
  void clearPinned() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get archived => $_getBF(2);
  @$pb.TagNumber(3)
  set archived($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasArchived() => $_has(2);
  @$pb.TagNumber(3)
  void clearArchived() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get markedUnread => $_getBF(3);
  @$pb.TagNumber(4)
  set markedUnread($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMarkedUnread() => $_has(3);
  @$pb.TagNumber(4)
  void clearMarkedUnread() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get mutedUntil => $_getI64(4);
  @$pb.TagNumber(5)
  set mutedUntil($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMutedUntil() => $_has(4);
  @$pb.TagNumber(5)
  void clearMutedUntil() => $_clearField(5);
}

class Chats_SetDialogResult extends $pb.GeneratedMessage {
  factory Chats_SetDialogResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_SetDialogResult._();

  factory Chats_SetDialogResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SetDialogResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SetDialogResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetDialogResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SetDialogResult copyWith(void Function(Chats_SetDialogResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SetDialogResult)) as Chats_SetDialogResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SetDialogResult create() => Chats_SetDialogResult._();
  @$core.override
  Chats_SetDialogResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SetDialogResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SetDialogResult>(create);
  static Chats_SetDialogResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Удалить диалог у себя (очистить историю); forEveryone — у собеседника тоже.
class Chats_DeleteDialog extends $pb.GeneratedMessage {
  factory Chats_DeleteDialog({
    $core.List<$core.int>? chatID,
    $core.bool? forEveryone,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (forEveryone != null) result.forEveryone = forEveryone;
    return result;
  }

  Chats_DeleteDialog._();

  factory Chats_DeleteDialog.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteDialog.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteDialog',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOB(2, _omitFieldNames ? '' : 'forEveryone', protoName: 'forEveryone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteDialog clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteDialog copyWith(void Function(Chats_DeleteDialog) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteDialog)) as Chats_DeleteDialog;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteDialog create() => Chats_DeleteDialog._();
  @$core.override
  Chats_DeleteDialog createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteDialog getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteDialog>(create);
  static Chats_DeleteDialog? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get forEveryone => $_getBF(1);
  @$pb.TagNumber(2)
  set forEveryone($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasForEveryone() => $_has(1);
  @$pb.TagNumber(2)
  void clearForEveryone() => $_clearField(2);
}

class Chats_DeleteDialogResult extends $pb.GeneratedMessage {
  factory Chats_DeleteDialogResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_DeleteDialogResult._();

  factory Chats_DeleteDialogResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteDialogResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteDialogResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteDialogResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteDialogResult copyWith(void Function(Chats_DeleteDialogResult) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteDialogResult)) as Chats_DeleteDialogResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteDialogResult create() => Chats_DeleteDialogResult._();
  @$core.override
  Chats_DeleteDialogResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteDialogResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteDialogResult>(create);
  static Chats_DeleteDialogResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Когда собеседник прочитал моё сообщение (личный чат, ≤ 7 дней).
class Chats_ReadDate extends $pb.GeneratedMessage {
  factory Chats_ReadDate({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    return result;
  }

  Chats_ReadDate._();

  factory Chats_ReadDate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReadDate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReadDate',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadDate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadDate copyWith(void Function(Chats_ReadDate) updates) =>
      super.copyWith((message) => updates(message as Chats_ReadDate)) as Chats_ReadDate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReadDate create() => Chats_ReadDate._();
  @$core.override
  Chats_ReadDate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReadDate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReadDate>(create);
  static Chats_ReadDate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);
}

class Chats_ReadDateResult extends $pb.GeneratedMessage {
  factory Chats_ReadDateResult({
    Chats_ReadDateResult_Status? status,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (date != null) result.date = date;
    return result;
  }

  Chats_ReadDateResult._();

  factory Chats_ReadDateResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReadDateResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReadDateResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<Chats_ReadDateResult_Status>(1, _omitFieldNames ? '' : 'status', enumValues: Chats_ReadDateResult_Status.values)
    ..aInt64(2, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadDateResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReadDateResult copyWith(void Function(Chats_ReadDateResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ReadDateResult)) as Chats_ReadDateResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReadDateResult create() => Chats_ReadDateResult._();
  @$core.override
  Chats_ReadDateResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReadDateResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReadDateResult>(create);
  static Chats_ReadDateResult? _defaultInstance;

  @$pb.TagNumber(1)
  Chats_ReadDateResult_Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(Chats_ReadDateResult_Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get date => $_getI64(1);
  @$pb.TagNumber(2)
  set date($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDate() => $_clearField(2);
}

enum Chats_Request_Request { list, openPrivate, readHistory, setDialog, deleteDialog, readDate, notSet }

class Chats_Request extends $pb.GeneratedMessage {
  factory Chats_Request({
    Chats_List? list,
    Chats_OpenPrivate? openPrivate,
    Chats_ReadHistory? readHistory,
    Chats_SetDialog? setDialog,
    Chats_DeleteDialog? deleteDialog,
    Chats_ReadDate? readDate,
  }) {
    final result = create();
    if (list != null) result.list = list;
    if (openPrivate != null) result.openPrivate = openPrivate;
    if (readHistory != null) result.readHistory = readHistory;
    if (setDialog != null) result.setDialog = setDialog;
    if (deleteDialog != null) result.deleteDialog = deleteDialog;
    if (readDate != null) result.readDate = readDate;
    return result;
  }

  Chats_Request._();

  factory Chats_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Chats_Request_Request> _Chats_Request_RequestByTag = {
    1: Chats_Request_Request.list,
    2: Chats_Request_Request.openPrivate,
    3: Chats_Request_Request.readHistory,
    4: Chats_Request_Request.setDialog,
    5: Chats_Request_Request.deleteDialog,
    6: Chats_Request_Request.readDate,
    0: Chats_Request_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<Chats_List>(1, _omitFieldNames ? '' : 'list', subBuilder: Chats_List.create)
    ..aOM<Chats_OpenPrivate>(2, _omitFieldNames ? '' : 'openPrivate', protoName: 'openPrivate', subBuilder: Chats_OpenPrivate.create)
    ..aOM<Chats_ReadHistory>(3, _omitFieldNames ? '' : 'readHistory', protoName: 'readHistory', subBuilder: Chats_ReadHistory.create)
    ..aOM<Chats_SetDialog>(4, _omitFieldNames ? '' : 'setDialog', protoName: 'setDialog', subBuilder: Chats_SetDialog.create)
    ..aOM<Chats_DeleteDialog>(5, _omitFieldNames ? '' : 'deleteDialog', protoName: 'deleteDialog', subBuilder: Chats_DeleteDialog.create)
    ..aOM<Chats_ReadDate>(6, _omitFieldNames ? '' : 'readDate', protoName: 'readDate', subBuilder: Chats_ReadDate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Request copyWith(void Function(Chats_Request) updates) =>
      super.copyWith((message) => updates(message as Chats_Request)) as Chats_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_Request create() => Chats_Request._();
  @$core.override
  Chats_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_Request>(create);
  static Chats_Request? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  Chats_Request_Request whichRequest() => _Chats_Request_RequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  void clearRequest() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Chats_List get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(Chats_List value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  Chats_List ensureList() => $_ensure(0);

  @$pb.TagNumber(2)
  Chats_OpenPrivate get openPrivate => $_getN(1);
  @$pb.TagNumber(2)
  set openPrivate(Chats_OpenPrivate value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenPrivate() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenPrivate() => $_clearField(2);
  @$pb.TagNumber(2)
  Chats_OpenPrivate ensureOpenPrivate() => $_ensure(1);

  @$pb.TagNumber(3)
  Chats_ReadHistory get readHistory => $_getN(2);
  @$pb.TagNumber(3)
  set readHistory(Chats_ReadHistory value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReadHistory() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadHistory() => $_clearField(3);
  @$pb.TagNumber(3)
  Chats_ReadHistory ensureReadHistory() => $_ensure(2);

  @$pb.TagNumber(4)
  Chats_SetDialog get setDialog => $_getN(3);
  @$pb.TagNumber(4)
  set setDialog(Chats_SetDialog value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSetDialog() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetDialog() => $_clearField(4);
  @$pb.TagNumber(4)
  Chats_SetDialog ensureSetDialog() => $_ensure(3);

  @$pb.TagNumber(5)
  Chats_DeleteDialog get deleteDialog => $_getN(4);
  @$pb.TagNumber(5)
  set deleteDialog(Chats_DeleteDialog value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeleteDialog() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeleteDialog() => $_clearField(5);
  @$pb.TagNumber(5)
  Chats_DeleteDialog ensureDeleteDialog() => $_ensure(4);

  @$pb.TagNumber(6)
  Chats_ReadDate get readDate => $_getN(5);
  @$pb.TagNumber(6)
  set readDate(Chats_ReadDate value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReadDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearReadDate() => $_clearField(6);
  @$pb.TagNumber(6)
  Chats_ReadDate ensureReadDate() => $_ensure(5);
}

enum Chats_Response_Response { list, openPrivate, readHistory, setDialog, deleteDialog, readDate, notSet }

class Chats_Response extends $pb.GeneratedMessage {
  factory Chats_Response({
    Chats_ListResult? list,
    Chats_OpenPrivateResult? openPrivate,
    Chats_ReadHistoryResult? readHistory,
    Chats_SetDialogResult? setDialog,
    Chats_DeleteDialogResult? deleteDialog,
    Chats_ReadDateResult? readDate,
  }) {
    final result = create();
    if (list != null) result.list = list;
    if (openPrivate != null) result.openPrivate = openPrivate;
    if (readHistory != null) result.readHistory = readHistory;
    if (setDialog != null) result.setDialog = setDialog;
    if (deleteDialog != null) result.deleteDialog = deleteDialog;
    if (readDate != null) result.readDate = readDate;
    return result;
  }

  Chats_Response._();

  factory Chats_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Chats_Response_Response> _Chats_Response_ResponseByTag = {
    1: Chats_Response_Response.list,
    2: Chats_Response_Response.openPrivate,
    3: Chats_Response_Response.readHistory,
    4: Chats_Response_Response.setDialog,
    5: Chats_Response_Response.deleteDialog,
    6: Chats_Response_Response.readDate,
    0: Chats_Response_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6])
    ..aOM<Chats_ListResult>(1, _omitFieldNames ? '' : 'list', subBuilder: Chats_ListResult.create)
    ..aOM<Chats_OpenPrivateResult>(2, _omitFieldNames ? '' : 'openPrivate',
        protoName: 'openPrivate', subBuilder: Chats_OpenPrivateResult.create)
    ..aOM<Chats_ReadHistoryResult>(3, _omitFieldNames ? '' : 'readHistory',
        protoName: 'readHistory', subBuilder: Chats_ReadHistoryResult.create)
    ..aOM<Chats_SetDialogResult>(4, _omitFieldNames ? '' : 'setDialog', protoName: 'setDialog', subBuilder: Chats_SetDialogResult.create)
    ..aOM<Chats_DeleteDialogResult>(5, _omitFieldNames ? '' : 'deleteDialog',
        protoName: 'deleteDialog', subBuilder: Chats_DeleteDialogResult.create)
    ..aOM<Chats_ReadDateResult>(6, _omitFieldNames ? '' : 'readDate', protoName: 'readDate', subBuilder: Chats_ReadDateResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_Response copyWith(void Function(Chats_Response) updates) =>
      super.copyWith((message) => updates(message as Chats_Response)) as Chats_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_Response create() => Chats_Response._();
  @$core.override
  Chats_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_Response>(create);
  static Chats_Response? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  Chats_Response_Response whichResponse() => _Chats_Response_ResponseByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  void clearResponse() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Chats_ListResult get list => $_getN(0);
  @$pb.TagNumber(1)
  set list(Chats_ListResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasList() => $_has(0);
  @$pb.TagNumber(1)
  void clearList() => $_clearField(1);
  @$pb.TagNumber(1)
  Chats_ListResult ensureList() => $_ensure(0);

  @$pb.TagNumber(2)
  Chats_OpenPrivateResult get openPrivate => $_getN(1);
  @$pb.TagNumber(2)
  set openPrivate(Chats_OpenPrivateResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenPrivate() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenPrivate() => $_clearField(2);
  @$pb.TagNumber(2)
  Chats_OpenPrivateResult ensureOpenPrivate() => $_ensure(1);

  @$pb.TagNumber(3)
  Chats_ReadHistoryResult get readHistory => $_getN(2);
  @$pb.TagNumber(3)
  set readHistory(Chats_ReadHistoryResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReadHistory() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadHistory() => $_clearField(3);
  @$pb.TagNumber(3)
  Chats_ReadHistoryResult ensureReadHistory() => $_ensure(2);

  @$pb.TagNumber(4)
  Chats_SetDialogResult get setDialog => $_getN(3);
  @$pb.TagNumber(4)
  set setDialog(Chats_SetDialogResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSetDialog() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetDialog() => $_clearField(4);
  @$pb.TagNumber(4)
  Chats_SetDialogResult ensureSetDialog() => $_ensure(3);

  @$pb.TagNumber(5)
  Chats_DeleteDialogResult get deleteDialog => $_getN(4);
  @$pb.TagNumber(5)
  set deleteDialog(Chats_DeleteDialogResult value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeleteDialog() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeleteDialog() => $_clearField(5);
  @$pb.TagNumber(5)
  Chats_DeleteDialogResult ensureDeleteDialog() => $_ensure(4);

  @$pb.TagNumber(6)
  Chats_ReadDateResult get readDate => $_getN(5);
  @$pb.TagNumber(6)
  set readDate(Chats_ReadDateResult value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasReadDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearReadDate() => $_clearField(6);
  @$pb.TagNumber(6)
  Chats_ReadDateResult ensureReadDate() => $_ensure(5);
}

/// CHATS — диалоги.
class Chats extends $pb.GeneratedMessage {
  factory Chats() => create();

  Chats._();

  factory Chats.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats copyWith(void Function(Chats) updates) => super.copyWith((message) => updates(message as Chats)) as Chats;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats create() => Chats._();
  @$core.override
  Chats createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats>(create);
  static Chats? _defaultInstance;
}

/// История чата: сообщения с messageID < offsetID (0 — с последнего), по
/// убыванию messageID.
class Messages_History extends $pb.GeneratedMessage {
  factory Messages_History({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? offsetID,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (offsetID != null) result.offsetID = offsetID;
    if (limit != null) result.limit = limit;
    return result;
  }

  Messages_History._();

  factory Messages_History.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_History.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.History',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'offsetID', protoName: 'offsetID')
    ..aI(3, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_History clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_History copyWith(void Function(Messages_History) updates) =>
      super.copyWith((message) => updates(message as Messages_History)) as Messages_History;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_History create() => Messages_History._();
  @$core.override
  Messages_History createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_History getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_History>(create);
  static Messages_History? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get offsetID => $_getI64(1);
  @$pb.TagNumber(2)
  set offsetID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffsetID() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffsetID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class Messages_HistoryResult extends $pb.GeneratedMessage {
  factory Messages_HistoryResult({
    $core.Iterable<ChatMessage>? messages,
    $core.bool? hasMore,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    if (hasMore != null) result.hasMore = hasMore;
    return result;
  }

  Messages_HistoryResult._();

  factory Messages_HistoryResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_HistoryResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.HistoryResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..aOB(2, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_HistoryResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_HistoryResult copyWith(void Function(Messages_HistoryResult) updates) =>
      super.copyWith((message) => updates(message as Messages_HistoryResult)) as Messages_HistoryResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_HistoryResult create() => Messages_HistoryResult._();
  @$core.override
  Messages_HistoryResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_HistoryResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_HistoryResult>(create);
  static Messages_HistoryResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessage> get messages => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get hasMore => $_getBF(1);
  @$pb.TagNumber(2)
  set hasMore($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasMore() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasMore() => $_clearField(2);
}

/// Отправить. Личный чат адресуется chatID (из OpenPrivate) или, если чата
/// ещё нет, peerUserID. randomID — случайное число клиента: повтор с тем же
/// randomID (обрыв связи, outbox) не создаст дубль — вернётся уже созданное.
class Messages_Send extends $pb.GeneratedMessage {
  factory Messages_Send({
    $core.List<$core.int>? chatID,
    $core.List<$core.int>? peerUserID,
    $fixnum.Int64? randomID,
    MessageContent? content,
    $core.bool? silent,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (peerUserID != null) result.peerUserID = peerUserID;
    if (randomID != null) result.randomID = randomID;
    if (content != null) result.content = content;
    if (silent != null) result.silent = silent;
    return result;
  }

  Messages_Send._();

  factory Messages_Send.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Send.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Send',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'peerUserID', $pb.PbFieldType.OY, protoName: 'peerUserID')
    ..aInt64(3, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..aOM<MessageContent>(4, _omitFieldNames ? '' : 'content', subBuilder: MessageContent.create)
    ..aOB(5, _omitFieldNames ? '' : 'silent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Send clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Send copyWith(void Function(Messages_Send) updates) =>
      super.copyWith((message) => updates(message as Messages_Send)) as Messages_Send;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Send create() => Messages_Send._();
  @$core.override
  Messages_Send createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Send getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Send>(create);
  static Messages_Send? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get peerUserID => $_getN(1);
  @$pb.TagNumber(2)
  set peerUserID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeerUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerUserID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get randomID => $_getI64(2);
  @$pb.TagNumber(3)
  set randomID($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRandomID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRandomID() => $_clearField(3);

  @$pb.TagNumber(4)
  MessageContent get content => $_getN(3);
  @$pb.TagNumber(4)
  set content(MessageContent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => $_clearField(4);
  @$pb.TagNumber(4)
  MessageContent ensureContent() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get silent => $_getBF(4);
  @$pb.TagNumber(5)
  set silent($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSilent() => $_has(4);
  @$pb.TagNumber(5)
  void clearSilent() => $_clearField(5);
}

class Messages_SendResult extends $pb.GeneratedMessage {
  factory Messages_SendResult({
    ChatMessage? message,
    Updates? updates,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_SendResult._();

  factory Messages_SendResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SendResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SendResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatMessage>(1, _omitFieldNames ? '' : 'message', subBuilder: ChatMessage.create)
    ..aOM<Updates>(2, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendResult copyWith(void Function(Messages_SendResult) updates) =>
      super.copyWith((message) => updates(message as Messages_SendResult)) as Messages_SendResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SendResult create() => Messages_SendResult._();
  @$core.override
  Messages_SendResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SendResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SendResult>(create);
  static Messages_SendResult? _defaultInstance;

  @$pb.TagNumber(1)
  ChatMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ChatMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatMessage ensureMessage() => $_ensure(0);

  @$pb.TagNumber(2)
  Updates get updates => $_getN(1);
  @$pb.TagNumber(2)
  set updates(Updates value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpdates() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdates() => $_clearField(2);
  @$pb.TagNumber(2)
  Updates ensureUpdates() => $_ensure(1);
}

/// Изменить своё (текст / разметку; медиа не меняются).
class Messages_Edit extends $pb.GeneratedMessage {
  factory Messages_Edit({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.String? text,
    $core.Iterable<MessageEntity>? entities,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (text != null) result.text = text;
    if (entities != null) result.entities.addAll(entities);
    return result;
  }

  Messages_Edit._();

  factory Messages_Edit.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Edit.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Edit',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..pPM<MessageEntity>(4, _omitFieldNames ? '' : 'entities', subBuilder: MessageEntity.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Edit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Edit copyWith(void Function(Messages_Edit) updates) =>
      super.copyWith((message) => updates(message as Messages_Edit)) as Messages_Edit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Edit create() => Messages_Edit._();
  @$core.override
  Messages_Edit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Edit getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Edit>(create);
  static Messages_Edit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get messageID => $_getI64(1);
  @$pb.TagNumber(2)
  set messageID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageID() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<MessageEntity> get entities => $_getList(3);
}

class Messages_EditResult extends $pb.GeneratedMessage {
  factory Messages_EditResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_EditResult._();

  factory Messages_EditResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_EditResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.EditResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_EditResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_EditResult copyWith(void Function(Messages_EditResult) updates) =>
      super.copyWith((message) => updates(message as Messages_EditResult)) as Messages_EditResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_EditResult create() => Messages_EditResult._();
  @$core.override
  Messages_EditResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_EditResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_EditResult>(create);
  static Messages_EditResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Удалить: forEveryone — у всех (в личном чате — и чужие, как в Telegram),
/// иначе только у себя.
class Messages_Delete extends $pb.GeneratedMessage {
  factory Messages_Delete({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
    $core.bool? forEveryone,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    if (forEveryone != null) result.forEveryone = forEveryone;
    return result;
  }

  Messages_Delete._();

  factory Messages_Delete.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Delete.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Delete',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..aOB(3, _omitFieldNames ? '' : 'forEveryone', protoName: 'forEveryone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Delete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Delete copyWith(void Function(Messages_Delete) updates) =>
      super.copyWith((message) => updates(message as Messages_Delete)) as Messages_Delete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Delete create() => Messages_Delete._();
  @$core.override
  Messages_Delete createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Delete getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Delete>(create);
  static Messages_Delete? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);

  @$pb.TagNumber(3)
  $core.bool get forEveryone => $_getBF(2);
  @$pb.TagNumber(3)
  set forEveryone($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasForEveryone() => $_has(2);
  @$pb.TagNumber(3)
  void clearForEveryone() => $_clearField(3);
}

class Messages_DeleteResult extends $pb.GeneratedMessage {
  factory Messages_DeleteResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_DeleteResult._();

  factory Messages_DeleteResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_DeleteResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.DeleteResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteResult copyWith(void Function(Messages_DeleteResult) updates) =>
      super.copyWith((message) => updates(message as Messages_DeleteResult)) as Messages_DeleteResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_DeleteResult create() => Messages_DeleteResult._();
  @$core.override
  Messages_DeleteResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_DeleteResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_DeleteResult>(create);
  static Messages_DeleteResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

/// Голосовое прослушано (снять mediaUnread у обоих).
class Messages_ReadContents extends $pb.GeneratedMessage {
  factory Messages_ReadContents({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Messages_ReadContents._();

  factory Messages_ReadContents.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadContents.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadContents',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadContents clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadContents copyWith(void Function(Messages_ReadContents) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadContents)) as Messages_ReadContents;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadContents create() => Messages_ReadContents._();
  @$core.override
  Messages_ReadContents createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadContents getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadContents>(create);
  static Messages_ReadContents? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get messageIDs => $_getList(1);
}

class Messages_ReadContentsResult extends $pb.GeneratedMessage {
  factory Messages_ReadContentsResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_ReadContentsResult._();

  factory Messages_ReadContentsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadContentsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadContentsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadContentsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadContentsResult copyWith(void Function(Messages_ReadContentsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadContentsResult)) as Messages_ReadContentsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadContentsResult create() => Messages_ReadContentsResult._();
  @$core.override
  Messages_ReadContentsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadContentsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadContentsResult>(create);
  static Messages_ReadContentsResult? _defaultInstance;

  @$pb.TagNumber(1)
  Updates get updates => $_getN(0);
  @$pb.TagNumber(1)
  set updates(Updates value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasUpdates() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpdates() => $_clearField(1);
  @$pb.TagNumber(1)
  Updates ensureUpdates() => $_ensure(0);
}

enum Messages_Request_Request { history, send, edit, delete, readContents, notSet }

class Messages_Request extends $pb.GeneratedMessage {
  factory Messages_Request({
    Messages_History? history,
    Messages_Send? send,
    Messages_Edit? edit,
    Messages_Delete? delete,
    Messages_ReadContents? readContents,
  }) {
    final result = create();
    if (history != null) result.history = history;
    if (send != null) result.send = send;
    if (edit != null) result.edit = edit;
    if (delete != null) result.delete = delete;
    if (readContents != null) result.readContents = readContents;
    return result;
  }

  Messages_Request._();

  factory Messages_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Messages_Request_Request> _Messages_Request_RequestByTag = {
    1: Messages_Request_Request.history,
    2: Messages_Request_Request.send,
    3: Messages_Request_Request.edit,
    4: Messages_Request_Request.delete,
    5: Messages_Request_Request.readContents,
    0: Messages_Request_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<Messages_History>(1, _omitFieldNames ? '' : 'history', subBuilder: Messages_History.create)
    ..aOM<Messages_Send>(2, _omitFieldNames ? '' : 'send', subBuilder: Messages_Send.create)
    ..aOM<Messages_Edit>(3, _omitFieldNames ? '' : 'edit', subBuilder: Messages_Edit.create)
    ..aOM<Messages_Delete>(4, _omitFieldNames ? '' : 'delete', subBuilder: Messages_Delete.create)
    ..aOM<Messages_ReadContents>(5, _omitFieldNames ? '' : 'readContents',
        protoName: 'readContents', subBuilder: Messages_ReadContents.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Request copyWith(void Function(Messages_Request) updates) =>
      super.copyWith((message) => updates(message as Messages_Request)) as Messages_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Request create() => Messages_Request._();
  @$core.override
  Messages_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Request>(create);
  static Messages_Request? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  Messages_Request_Request whichRequest() => _Messages_Request_RequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearRequest() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Messages_History get history => $_getN(0);
  @$pb.TagNumber(1)
  set history(Messages_History value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHistory() => $_has(0);
  @$pb.TagNumber(1)
  void clearHistory() => $_clearField(1);
  @$pb.TagNumber(1)
  Messages_History ensureHistory() => $_ensure(0);

  @$pb.TagNumber(2)
  Messages_Send get send => $_getN(1);
  @$pb.TagNumber(2)
  set send(Messages_Send value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSend() => $_has(1);
  @$pb.TagNumber(2)
  void clearSend() => $_clearField(2);
  @$pb.TagNumber(2)
  Messages_Send ensureSend() => $_ensure(1);

  @$pb.TagNumber(3)
  Messages_Edit get edit => $_getN(2);
  @$pb.TagNumber(3)
  set edit(Messages_Edit value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEdit() => $_has(2);
  @$pb.TagNumber(3)
  void clearEdit() => $_clearField(3);
  @$pb.TagNumber(3)
  Messages_Edit ensureEdit() => $_ensure(2);

  @$pb.TagNumber(4)
  Messages_Delete get delete => $_getN(3);
  @$pb.TagNumber(4)
  set delete(Messages_Delete value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDelete() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelete() => $_clearField(4);
  @$pb.TagNumber(4)
  Messages_Delete ensureDelete() => $_ensure(3);

  @$pb.TagNumber(5)
  Messages_ReadContents get readContents => $_getN(4);
  @$pb.TagNumber(5)
  set readContents(Messages_ReadContents value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReadContents() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadContents() => $_clearField(5);
  @$pb.TagNumber(5)
  Messages_ReadContents ensureReadContents() => $_ensure(4);
}

enum Messages_Response_Response { history, send, edit, delete, readContents, notSet }

class Messages_Response extends $pb.GeneratedMessage {
  factory Messages_Response({
    Messages_HistoryResult? history,
    Messages_SendResult? send,
    Messages_EditResult? edit,
    Messages_DeleteResult? delete,
    Messages_ReadContentsResult? readContents,
  }) {
    final result = create();
    if (history != null) result.history = history;
    if (send != null) result.send = send;
    if (edit != null) result.edit = edit;
    if (delete != null) result.delete = delete;
    if (readContents != null) result.readContents = readContents;
    return result;
  }

  Messages_Response._();

  factory Messages_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Messages_Response_Response> _Messages_Response_ResponseByTag = {
    1: Messages_Response_Response.history,
    2: Messages_Response_Response.send,
    3: Messages_Response_Response.edit,
    4: Messages_Response_Response.delete,
    5: Messages_Response_Response.readContents,
    0: Messages_Response_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5])
    ..aOM<Messages_HistoryResult>(1, _omitFieldNames ? '' : 'history', subBuilder: Messages_HistoryResult.create)
    ..aOM<Messages_SendResult>(2, _omitFieldNames ? '' : 'send', subBuilder: Messages_SendResult.create)
    ..aOM<Messages_EditResult>(3, _omitFieldNames ? '' : 'edit', subBuilder: Messages_EditResult.create)
    ..aOM<Messages_DeleteResult>(4, _omitFieldNames ? '' : 'delete', subBuilder: Messages_DeleteResult.create)
    ..aOM<Messages_ReadContentsResult>(5, _omitFieldNames ? '' : 'readContents',
        protoName: 'readContents', subBuilder: Messages_ReadContentsResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Response copyWith(void Function(Messages_Response) updates) =>
      super.copyWith((message) => updates(message as Messages_Response)) as Messages_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Response create() => Messages_Response._();
  @$core.override
  Messages_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Response>(create);
  static Messages_Response? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  Messages_Response_Response whichResponse() => _Messages_Response_ResponseByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  void clearResponse() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Messages_HistoryResult get history => $_getN(0);
  @$pb.TagNumber(1)
  set history(Messages_HistoryResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHistory() => $_has(0);
  @$pb.TagNumber(1)
  void clearHistory() => $_clearField(1);
  @$pb.TagNumber(1)
  Messages_HistoryResult ensureHistory() => $_ensure(0);

  @$pb.TagNumber(2)
  Messages_SendResult get send => $_getN(1);
  @$pb.TagNumber(2)
  set send(Messages_SendResult value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSend() => $_has(1);
  @$pb.TagNumber(2)
  void clearSend() => $_clearField(2);
  @$pb.TagNumber(2)
  Messages_SendResult ensureSend() => $_ensure(1);

  @$pb.TagNumber(3)
  Messages_EditResult get edit => $_getN(2);
  @$pb.TagNumber(3)
  set edit(Messages_EditResult value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEdit() => $_has(2);
  @$pb.TagNumber(3)
  void clearEdit() => $_clearField(3);
  @$pb.TagNumber(3)
  Messages_EditResult ensureEdit() => $_ensure(2);

  @$pb.TagNumber(4)
  Messages_DeleteResult get delete => $_getN(3);
  @$pb.TagNumber(4)
  set delete(Messages_DeleteResult value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDelete() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelete() => $_clearField(4);
  @$pb.TagNumber(4)
  Messages_DeleteResult ensureDelete() => $_ensure(3);

  @$pb.TagNumber(5)
  Messages_ReadContentsResult get readContents => $_getN(4);
  @$pb.TagNumber(5)
  set readContents(Messages_ReadContentsResult value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReadContents() => $_has(4);
  @$pb.TagNumber(5)
  void clearReadContents() => $_clearField(5);
  @$pb.TagNumber(5)
  Messages_ReadContentsResult ensureReadContents() => $_ensure(4);
}

/// MESSAGES — сообщения.
class Messages extends $pb.GeneratedMessage {
  factory Messages() => create();

  Messages._();

  factory Messages.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages copyWith(void Function(Messages) updates) => super.copyWith((message) => updates(message as Messages)) as Messages;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages create() => Messages._();
  @$core.override
  Messages createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages>(create);
  static Messages? _defaultInstance;
}

class GetDifference_Request extends $pb.GeneratedMessage {
  factory GetDifference_Request({
    $fixnum.Int64? pts,
    $core.int? limit,
  }) {
    final result = create();
    if (pts != null) result.pts = pts;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetDifference_Request._();

  factory GetDifference_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDifference_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDifference.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'pts')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference_Request copyWith(void Function(GetDifference_Request) updates) =>
      super.copyWith((message) => updates(message as GetDifference_Request)) as GetDifference_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDifference_Request create() => GetDifference_Request._();
  @$core.override
  GetDifference_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDifference_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDifference_Request>(create);
  static GetDifference_Request? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get pts => $_getI64(0);
  @$pb.TagNumber(1)
  set pts($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPts() => $_has(0);
  @$pb.TagNumber(1)
  void clearPts() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class GetDifference_Response extends $pb.GeneratedMessage {
  factory GetDifference_Response({
    $core.Iterable<Update>? updates,
    UpdatesState? state,
    $core.bool? hasMore,
    $core.bool? tooLong,
  }) {
    final result = create();
    if (updates != null) result.updates.addAll(updates);
    if (state != null) result.state = state;
    if (hasMore != null) result.hasMore = hasMore;
    if (tooLong != null) result.tooLong = tooLong;
    return result;
  }

  GetDifference_Response._();

  factory GetDifference_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDifference_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDifference.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<Update>(1, _omitFieldNames ? '' : 'updates', subBuilder: Update.create)
    ..aOM<UpdatesState>(2, _omitFieldNames ? '' : 'state', subBuilder: UpdatesState.create)
    ..aOB(3, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..aOB(4, _omitFieldNames ? '' : 'tooLong', protoName: 'tooLong')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference_Response copyWith(void Function(GetDifference_Response) updates) =>
      super.copyWith((message) => updates(message as GetDifference_Response)) as GetDifference_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDifference_Response create() => GetDifference_Response._();
  @$core.override
  GetDifference_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDifference_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDifference_Response>(create);
  static GetDifference_Response? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Update> get updates => $_getList(0);

  @$pb.TagNumber(2)
  UpdatesState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(UpdatesState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
  @$pb.TagNumber(2)
  UpdatesState ensureState() => $_ensure(1);

  /// Есть ещё — запросить снова с state.pts.
  @$pb.TagNumber(3)
  $core.bool get hasMore => $_getBF(2);
  @$pb.TagNumber(3)
  set hasMore($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHasMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearHasMore() => $_clearField(3);

  /// Отстали слишком сильно (журнал уже обрезан): перезагрузить диалоги
  /// (Chats.List) и историю открытых чатов, затем продолжать от state.pts.
  @$pb.TagNumber(4)
  $core.bool get tooLong => $_getBF(3);
  @$pb.TagNumber(4)
  set tooLong($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTooLong() => $_has(3);
  @$pb.TagNumber(4)
  void clearTooLong() => $_clearField(4);
}

/// GET_DIFFERENCE — догон после переподключения: обновления с pts > запрошенного.
class GetDifference extends $pb.GeneratedMessage {
  factory GetDifference() => create();

  GetDifference._();

  factory GetDifference.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDifference.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDifference',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDifference copyWith(void Function(GetDifference) updates) =>
      super.copyWith((message) => updates(message as GetDifference)) as GetDifference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDifference create() => GetDifference._();
  @$core.override
  GetDifference createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDifference getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDifference>(create);
  static GetDifference? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
