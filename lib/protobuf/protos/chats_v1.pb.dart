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
import 'models.pb.dart' as $0;

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

/// Файл вложения: загружен заранее через Upload (UPLOAD_CONFIRM → cdnID) —
/// самим отправителем, иначе отправка отклоняется (PERMISSION_DENIED).
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
    $0.CDN? file,
    $core.List<$core.int>? thumbCdnID,
    $0.CDN? thumbFile,
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
    if (file != null) result.file = file;
    if (thumbCdnID != null) result.thumbCdnID = thumbCdnID;
    if (thumbFile != null) result.thumbFile = thumbFile;
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
    ..aOM<$0.CDN>(12, _omitFieldNames ? '' : 'file', subBuilder: $0.CDN.create)
    ..a<$core.List<$core.int>>(13, _omitFieldNames ? '' : 'thumbCdnID', $pb.PbFieldType.OY, protoName: 'thumbCdnID')
    ..aOM<$0.CDN>(14, _omitFieldNames ? '' : 'thumbFile', protoName: 'thumbFile', subBuilder: $0.CDN.create)
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

  /// Как скачать: адрес, ключ, соль, хеш шифротекста. Заполняет сервер при
  /// выдаче сообщения (история, обновления, догон, ответ на отправку) — адрес
  /// собирается в момент выдачи (горячее/холодное хранилище). При отправке
  /// клиент поле не заполняет (сервер его отбрасывает); в БД не хранится.
  @$pb.TagNumber(12)
  $0.CDN get file => $_getN(11);
  @$pb.TagNumber(12)
  set file($0.CDN value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasFile() => $_has(11);
  @$pb.TagNumber(12)
  void clearFile() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.CDN ensureFile() => $_ensure(11);

  /// Видео — кадр-обложка (JPEG ~320 px), загружен так же, как сам файл, чтобы
  /// получатель видел превью до скачивания видео. thumbFile — как file.
  @$pb.TagNumber(13)
  $core.List<$core.int> get thumbCdnID => $_getN(12);
  @$pb.TagNumber(13)
  set thumbCdnID($core.List<$core.int> value) => $_setBytes(12, value);
  @$pb.TagNumber(13)
  $core.bool hasThumbCdnID() => $_has(12);
  @$pb.TagNumber(13)
  void clearThumbCdnID() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.CDN get thumbFile => $_getN(13);
  @$pb.TagNumber(14)
  set thumbFile($0.CDN value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasThumbFile() => $_has(13);
  @$pb.TagNumber(14)
  void clearThumbFile() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.CDN ensureThumbFile() => $_ensure(13);
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

/// Пересланное: автор оригинала (fromName — его имя в профиле на момент
/// пересылки, на случай если профиль получателю не виден) и дата оригинала.
/// fromUserID пуст — автор запретил ссылку на свой аккаунт при пересылке
/// (PrivacySettings.forwards): только имя, без перехода в профиль.
/// Ставит только сервер (Messages.Send.forwardFrom); в обычной отправке
/// отбрасывается.
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

/// Звонок — служебное сообщение в личном чате (как messageActionPhoneCall в
/// Telegram). Пишет сервер по завершении звонка, от звонящего; клиент его не
/// отправляет. Исход — с точки зрения звонка, подпись («Пропущенный» /
/// «Отменённый» …) клиент выбирает по направлению.
class MessageCall extends $pb.GeneratedMessage {
  factory MessageCall({
    $core.String? callID,
    $core.bool? video,
    MessageCall_Outcome? outcome,
    $core.int? duration,
  }) {
    final result = create();
    if (callID != null) result.callID = callID;
    if (video != null) result.video = video;
    if (outcome != null) result.outcome = outcome;
    if (duration != null) result.duration = duration;
    return result;
  }

  MessageCall._();

  factory MessageCall.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageCall.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageCall',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'callID', protoName: 'callID')
    ..aOB(2, _omitFieldNames ? '' : 'video')
    ..aE<MessageCall_Outcome>(3, _omitFieldNames ? '' : 'outcome', enumValues: MessageCall_Outcome.values)
    ..aI(4, _omitFieldNames ? '' : 'duration')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageCall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageCall copyWith(void Function(MessageCall) updates) => super.copyWith((message) => updates(message as MessageCall)) as MessageCall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageCall create() => MessageCall._();
  @$core.override
  MessageCall createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageCall getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageCall>(create);
  static MessageCall? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get callID => $_getSZ(0);
  @$pb.TagNumber(1)
  set callID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCallID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCallID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get video => $_getBF(1);
  @$pb.TagNumber(2)
  set video($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVideo() => $_has(1);
  @$pb.TagNumber(2)
  void clearVideo() => $_clearField(2);

  @$pb.TagNumber(3)
  MessageCall_Outcome get outcome => $_getN(2);
  @$pb.TagNumber(3)
  set outcome(MessageCall_Outcome value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOutcome() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutcome() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get duration => $_getIZ(3);
  @$pb.TagNumber(4)
  set duration($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => $_clearField(4);
}

/// Закрепление сообщения — служебное (как messageActionPinMessage в Telegram).
/// Пишет сервер, когда сообщение закрепили «у всех», от закрепившего; клиент
/// его не отправляет. messageID — закреплённое сообщение того же чата.
class MessagePin extends $pb.GeneratedMessage {
  factory MessagePin({
    $fixnum.Int64? messageID,
  }) {
    final result = create();
    if (messageID != null) result.messageID = messageID;
    return result;
  }

  MessagePin._();

  factory MessagePin.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessagePin.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessagePin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagePin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessagePin copyWith(void Function(MessagePin) updates) => super.copyWith((message) => updates(message as MessagePin)) as MessagePin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessagePin create() => MessagePin._();
  @$core.override
  MessagePin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessagePin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessagePin>(create);
  static MessagePin? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get messageID => $_getI64(0);
  @$pb.TagNumber(1)
  set messageID($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMessageID() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageID() => $_clearField(1);
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
    MessageCall? call,
    MessagePin? pin,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (entities != null) result.entities.addAll(entities);
    if (media != null) result.media.addAll(media);
    if (replyTo != null) result.replyTo = replyTo;
    if (forward != null) result.forward = forward;
    if (noLinkPreview != null) result.noLinkPreview = noLinkPreview;
    if (call != null) result.call = call;
    if (pin != null) result.pin = pin;
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
    ..aOM<MessageCall>(7, _omitFieldNames ? '' : 'call', subBuilder: MessageCall.create)
    ..aOM<MessagePin>(8, _omitFieldNames ? '' : 'pin', subBuilder: MessagePin.create)
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

  /// Служебное «звонок» (только от сервера; при отправке клиентом — отказ).
  @$pb.TagNumber(7)
  MessageCall get call => $_getN(6);
  @$pb.TagNumber(7)
  set call(MessageCall value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCall() => $_has(6);
  @$pb.TagNumber(7)
  void clearCall() => $_clearField(7);
  @$pb.TagNumber(7)
  MessageCall ensureCall() => $_ensure(6);

  /// Служебное «закрепил сообщение» (только от сервера; при отправке — отказ).
  @$pb.TagNumber(8)
  MessagePin get pin => $_getN(7);
  @$pb.TagNumber(8)
  set pin(MessagePin value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPin() => $_has(7);
  @$pb.TagNumber(8)
  void clearPin() => $_clearField(8);
  @$pb.TagNumber(8)
  MessagePin ensurePin() => $_ensure(7);
}

/// Реакция участника на сообщение: кто, каким эмодзи и когда поставил.
class MessageReaction extends $pb.GeneratedMessage {
  factory MessageReaction({
    $core.List<$core.int>? userID,
    $core.String? emoji,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (userID != null) result.userID = userID;
    if (emoji != null) result.emoji = emoji;
    if (date != null) result.date = date;
    return result;
  }

  MessageReaction._();

  factory MessageReaction.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageReaction.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageReaction',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OY, protoName: 'userID')
    ..aOS(2, _omitFieldNames ? '' : 'emoji')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReaction copyWith(void Function(MessageReaction) updates) =>
      super.copyWith((message) => updates(message as MessageReaction)) as MessageReaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageReaction create() => MessageReaction._();
  @$core.override
  MessageReaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageReaction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageReaction>(create);
  static MessageReaction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get userID => $_getN(0);
  @$pb.TagNumber(1)
  set userID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserID() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get emoji => $_getSZ(1);
  @$pb.TagNumber(2)
  set emoji($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmoji() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmoji() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);
}

/// Реакции на сообщение (как MessageReactions в Telegram). Личный чат —
/// полный список, от ранних к поздним: чипы и «мои» клиент собирает сам.
/// Группы/каналы позже добавят счётчики «эмодзи → число» (там список авторов
/// — только последние или вовсе скрыт).
class MessageReactions extends $pb.GeneratedMessage {
  factory MessageReactions({
    $core.Iterable<MessageReaction>? reactions,
  }) {
    final result = create();
    if (reactions != null) result.reactions.addAll(reactions);
    return result;
  }

  MessageReactions._();

  factory MessageReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MessageReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MessageReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<MessageReaction>(1, _omitFieldNames ? '' : 'reactions', subBuilder: MessageReaction.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MessageReactions copyWith(void Function(MessageReactions) updates) =>
      super.copyWith((message) => updates(message as MessageReactions)) as MessageReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MessageReactions create() => MessageReactions._();
  @$core.override
  MessageReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MessageReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MessageReactions>(create);
  static MessageReactions? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<MessageReaction> get reactions => $_getList(0);
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
    MessageReactions? reactions,
    $core.bool? reactionsUnread,
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
    if (reactions != null) result.reactions = reactions;
    if (reactionsUnread != null) result.reactionsUnread = reactionsUnread;
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
    ..aOM<MessageReactions>(10, _omitFieldNames ? '' : 'reactions', subBuilder: MessageReactions.create)
    ..aOB(11, _omitFieldNames ? '' : 'reactionsUnread', protoName: 'reactionsUnread')
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

  /// Реакции (нет — пусто). Текущие на момент выдачи.
  @$pb.TagNumber(10)
  MessageReactions get reactions => $_getN(9);
  @$pb.TagNumber(10)
  set reactions(MessageReactions value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReactions() => $_has(9);
  @$pb.TagNumber(10)
  void clearReactions() => $_clearField(10);
  @$pb.TagNumber(10)
  MessageReactions ensureReactions() => $_ensure(9);

  /// Автор ещё не видел новые реакции собеседника на это сообщение (значимо
  /// только для автора: у получателя — игнорировать).
  @$pb.TagNumber(11)
  $core.bool get reactionsUnread => $_getBF(10);
  @$pb.TagNumber(11)
  set reactionsUnread($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReactionsUnread() => $_has(10);
  @$pb.TagNumber(11)
  void clearReactionsUnread() => $_clearField(11);
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
    $core.int? unreadReactionsCount,
    $core.String? draft,
    $fixnum.Int64? draftDate,
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
    if (unreadReactionsCount != null) result.unreadReactionsCount = unreadReactionsCount;
    if (draft != null) result.draft = draft;
    if (draftDate != null) result.draftDate = draftDate;
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
    ..aI(13, _omitFieldNames ? '' : 'unreadReactionsCount', protoName: 'unreadReactionsCount')
    ..aOS(14, _omitFieldNames ? '' : 'draft')
    ..aInt64(15, _omitFieldNames ? '' : 'draftDate', protoName: 'draftDate')
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

  /// Моих сообщений с непрочитанными реакциями (бейдж ❤️ в списке).
  @$pb.TagNumber(13)
  $core.int get unreadReactionsCount => $_getIZ(12);
  @$pb.TagNumber(13)
  set unreadReactionsCount($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasUnreadReactionsCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearUnreadReactionsCount() => $_clearField(13);

  /// Мой черновик (текст поля ввода, как есть — с markdown-ярлыками); пусто —
  /// нет. Синхронизируется между моими устройствами (Chats.SaveDraft →
  /// Update.dialogSettings).
  @$pb.TagNumber(14)
  $core.String get draft => $_getSZ(13);
  @$pb.TagNumber(14)
  set draft($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDraft() => $_has(13);
  @$pb.TagNumber(14)
  void clearDraft() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get draftDate => $_getI64(14);
  @$pb.TagNumber(15)
  set draftDate($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDraftDate() => $_has(14);
  @$pb.TagNumber(15)
  void clearDraftDate() => $_clearField(15);
}

/// Отложенное сообщение — моё, ещё не отправленное (как scheduled messages в
/// Telegram). Видно только мне (на всех моих устройствах); в момент date сервер
/// отправляет его обычным сообщением (новый messageID, дата — момент
/// отправки). scheduledID — номер внутри (я, чат), не messageID.
class ScheduledMessage extends $pb.GeneratedMessage {
  factory ScheduledMessage({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? scheduledID,
    $fixnum.Int64? date,
    MessageContent? content,
    $core.bool? silent,
    $fixnum.Int64? randomID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledID != null) result.scheduledID = scheduledID;
    if (date != null) result.date = date;
    if (content != null) result.content = content;
    if (silent != null) result.silent = silent;
    if (randomID != null) result.randomID = randomID;
    return result;
  }

  ScheduledMessage._();

  factory ScheduledMessage.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduledMessage.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScheduledMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'scheduledID', protoName: 'scheduledID')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..aOM<MessageContent>(4, _omitFieldNames ? '' : 'content', subBuilder: MessageContent.create)
    ..aOB(5, _omitFieldNames ? '' : 'silent')
    ..aInt64(6, _omitFieldNames ? '' : 'randomID', protoName: 'randomID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduledMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduledMessage copyWith(void Function(ScheduledMessage) updates) =>
      super.copyWith((message) => updates(message as ScheduledMessage)) as ScheduledMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduledMessage create() => ScheduledMessage._();
  @$core.override
  ScheduledMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduledMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScheduledMessage>(create);
  static ScheduledMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get scheduledID => $_getI64(1);
  @$pb.TagNumber(2)
  set scheduledID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScheduledID() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduledID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);

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

  @$pb.TagNumber(6)
  $fixnum.Int64 get randomID => $_getI64(5);
  @$pb.TagNumber(6)
  set randomID($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRandomID() => $_has(5);
  @$pb.TagNumber(6)
  void clearRandomID() => $_clearField(6);
}

/// Папка (таб) списка чатов — как dialogFilter в Telegram. «Все чаты» — не
/// папка (у клиента всегда первая). id выдаёт сервер; у SaveFolder 0 — новая.
/// Чат попадает в папку, если он в includeChatIDs или подходит по типу и не
/// исключён (excludeChatIDs, флаги exclude*); архивные — никогда.
class ChatFolder extends $pb.GeneratedMessage {
  factory ChatFolder({
    $core.int? id,
    $core.String? title,
    $core.bool? includeContacts,
    $core.bool? includeNonContacts,
    $core.bool? includeGroups,
    $core.bool? includeChannels,
    $core.bool? includeCommunities,
    $core.Iterable<$core.List<$core.int>>? includeChatIDs,
    $core.Iterable<$core.List<$core.int>>? excludeChatIDs,
    $core.bool? excludeMuted,
    $core.bool? excludeRead,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (includeContacts != null) result.includeContacts = includeContacts;
    if (includeNonContacts != null) result.includeNonContacts = includeNonContacts;
    if (includeGroups != null) result.includeGroups = includeGroups;
    if (includeChannels != null) result.includeChannels = includeChannels;
    if (includeCommunities != null) result.includeCommunities = includeCommunities;
    if (includeChatIDs != null) result.includeChatIDs.addAll(includeChatIDs);
    if (excludeChatIDs != null) result.excludeChatIDs.addAll(excludeChatIDs);
    if (excludeMuted != null) result.excludeMuted = excludeMuted;
    if (excludeRead != null) result.excludeRead = excludeRead;
    return result;
  }

  ChatFolder._();

  factory ChatFolder.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatFolder.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatFolder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOB(3, _omitFieldNames ? '' : 'includeContacts', protoName: 'includeContacts')
    ..aOB(4, _omitFieldNames ? '' : 'includeNonContacts', protoName: 'includeNonContacts')
    ..aOB(5, _omitFieldNames ? '' : 'includeGroups', protoName: 'includeGroups')
    ..aOB(6, _omitFieldNames ? '' : 'includeChannels', protoName: 'includeChannels')
    ..aOB(7, _omitFieldNames ? '' : 'includeCommunities', protoName: 'includeCommunities')
    ..p<$core.List<$core.int>>(8, _omitFieldNames ? '' : 'includeChatIDs', $pb.PbFieldType.PY, protoName: 'includeChatIDs')
    ..p<$core.List<$core.int>>(9, _omitFieldNames ? '' : 'excludeChatIDs', $pb.PbFieldType.PY, protoName: 'excludeChatIDs')
    ..aOB(10, _omitFieldNames ? '' : 'excludeMuted', protoName: 'excludeMuted')
    ..aOB(11, _omitFieldNames ? '' : 'excludeRead', protoName: 'excludeRead')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatFolder copyWith(void Function(ChatFolder) updates) => super.copyWith((message) => updates(message as ChatFolder)) as ChatFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatFolder create() => ChatFolder._();
  @$core.override
  ChatFolder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatFolder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatFolder>(create);
  static ChatFolder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get includeContacts => $_getBF(2);
  @$pb.TagNumber(3)
  set includeContacts($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIncludeContacts() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncludeContacts() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get includeNonContacts => $_getBF(3);
  @$pb.TagNumber(4)
  set includeNonContacts($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIncludeNonContacts() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncludeNonContacts() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get includeGroups => $_getBF(4);
  @$pb.TagNumber(5)
  set includeGroups($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIncludeGroups() => $_has(4);
  @$pb.TagNumber(5)
  void clearIncludeGroups() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get includeChannels => $_getBF(5);
  @$pb.TagNumber(6)
  set includeChannels($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIncludeChannels() => $_has(5);
  @$pb.TagNumber(6)
  void clearIncludeChannels() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get includeCommunities => $_getBF(6);
  @$pb.TagNumber(7)
  set includeCommunities($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIncludeCommunities() => $_has(6);
  @$pb.TagNumber(7)
  void clearIncludeCommunities() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.List<$core.int>> get includeChatIDs => $_getList(7);

  @$pb.TagNumber(9)
  $pb.PbList<$core.List<$core.int>> get excludeChatIDs => $_getList(8);

  @$pb.TagNumber(10)
  $core.bool get excludeMuted => $_getBF(9);
  @$pb.TagNumber(10)
  set excludeMuted($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasExcludeMuted() => $_has(9);
  @$pb.TagNumber(10)
  void clearExcludeMuted() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get excludeRead => $_getBF(10);
  @$pb.TagNumber(11)
  set excludeRead($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExcludeRead() => $_has(10);
  @$pb.TagNumber(11)
  void clearExcludeRead() => $_clearField(11);
}

/// Все мои папки по порядку (до 9, без «Все чаты»). version растёт с каждым
/// изменением: клиент не перезаписывает новый снимок старым.
class ChatFolders extends $pb.GeneratedMessage {
  factory ChatFolders({
    $core.Iterable<ChatFolder>? folders,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (folders != null) result.folders.addAll(folders);
    if (version != null) result.version = version;
    return result;
  }

  ChatFolders._();

  factory ChatFolders.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChatFolders.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatFolders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatFolder>(1, _omitFieldNames ? '' : 'folders', subBuilder: ChatFolder.create)
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatFolders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChatFolders copyWith(void Function(ChatFolders) updates) => super.copyWith((message) => updates(message as ChatFolders)) as ChatFolders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatFolders create() => ChatFolders._();
  @$core.override
  ChatFolders createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChatFolders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatFolders>(create);
  static ChatFolders? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatFolder> get folders => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
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

/// Сообщения закреплены (pinned) / откреплены у меня — на этом или другом
/// устройстве, мной или собеседником (закреп «у всех»). Содержимое
/// закреплённых, которых нет в кэше, клиент берёт запросом Messages.Pinned.
class Update_PinnedMessages extends $pb.GeneratedMessage {
  factory Update_PinnedMessages({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
    $core.bool? pinned,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    if (pinned != null) result.pinned = pinned;
    return result;
  }

  Update_PinnedMessages._();

  factory Update_PinnedMessages.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_PinnedMessages.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.PinnedMessages',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..aOB(3, _omitFieldNames ? '' : 'pinned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_PinnedMessages clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_PinnedMessages copyWith(void Function(Update_PinnedMessages) updates) =>
      super.copyWith((message) => updates(message as Update_PinnedMessages)) as Update_PinnedMessages;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_PinnedMessages create() => Update_PinnedMessages._();
  @$core.override
  Update_PinnedMessages createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_PinnedMessages getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_PinnedMessages>(create);
  static Update_PinnedMessages? _defaultInstance;

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
  $core.bool get pinned => $_getBF(2);
  @$pb.TagNumber(3)
  set pinned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPinned() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinned() => $_clearField(3);
}

/// Изменились реакции на сообщение (мои — на этом или другом устройстве — или
/// собеседника). reactions — текущие целиком (заменяют прежние).
class Update_MessageReactionsChanged extends $pb.GeneratedMessage {
  factory Update_MessageReactionsChanged({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    MessageReactions? reactions,
    $core.int? unreadReactionsCount,
    $core.bool? reactionsUnread,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (reactions != null) result.reactions = reactions;
    if (unreadReactionsCount != null) result.unreadReactionsCount = unreadReactionsCount;
    if (reactionsUnread != null) result.reactionsUnread = reactionsUnread;
    return result;
  }

  Update_MessageReactionsChanged._();

  factory Update_MessageReactionsChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_MessageReactionsChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.MessageReactionsChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOM<MessageReactions>(3, _omitFieldNames ? '' : 'reactions', subBuilder: MessageReactions.create)
    ..aI(4, _omitFieldNames ? '' : 'unreadReactionsCount', protoName: 'unreadReactionsCount')
    ..aOB(5, _omitFieldNames ? '' : 'reactionsUnread', protoName: 'reactionsUnread')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_MessageReactionsChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_MessageReactionsChanged copyWith(void Function(Update_MessageReactionsChanged) updates) =>
      super.copyWith((message) => updates(message as Update_MessageReactionsChanged)) as Update_MessageReactionsChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_MessageReactionsChanged create() => Update_MessageReactionsChanged._();
  @$core.override
  Update_MessageReactionsChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_MessageReactionsChanged getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_MessageReactionsChanged>(create);
  static Update_MessageReactionsChanged? _defaultInstance;

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
  MessageReactions get reactions => $_getN(2);
  @$pb.TagNumber(3)
  set reactions(MessageReactions value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReactions() => $_has(2);
  @$pb.TagNumber(3)
  void clearReactions() => $_clearField(3);
  @$pb.TagNumber(3)
  MessageReactions ensureReactions() => $_ensure(2);

  /// Мой текущий счётчик Dialog.unreadReactionsCount в этом чате.
  @$pb.TagNumber(4)
  $core.int get unreadReactionsCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set unreadReactionsCount($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnreadReactionsCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnreadReactionsCount() => $_clearField(4);

  /// ChatMessage.reactionsUnread сообщения (значим только для автора).
  @$pb.TagNumber(5)
  $core.bool get reactionsUnread => $_getBF(4);
  @$pb.TagNumber(5)
  set reactionsUnread($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReactionsUnread() => $_has(4);
  @$pb.TagNumber(5)
  void clearReactionsUnread() => $_clearField(5);
}

/// Реакции на мои сообщения messageIDs просмотрены (на этом или другом
/// устройстве): снять reactionsUnread; unreadReactionsCount — текущий.
class Update_ReadReactions extends $pb.GeneratedMessage {
  factory Update_ReadReactions({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
    $core.int? unreadReactionsCount,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    if (unreadReactionsCount != null) result.unreadReactionsCount = unreadReactionsCount;
    return result;
  }

  Update_ReadReactions._();

  factory Update_ReadReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ReadReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ReadReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..aI(3, _omitFieldNames ? '' : 'unreadReactionsCount', protoName: 'unreadReactionsCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ReadReactions copyWith(void Function(Update_ReadReactions) updates) =>
      super.copyWith((message) => updates(message as Update_ReadReactions)) as Update_ReadReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ReadReactions create() => Update_ReadReactions._();
  @$core.override
  Update_ReadReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ReadReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ReadReactions>(create);
  static Update_ReadReactions? _defaultInstance;

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
  $core.int get unreadReactionsCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set unreadReactionsCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnreadReactionsCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnreadReactionsCount() => $_clearField(3);
}

/// Моё отложенное создано или перенесено (всегда текущее).
class Update_ScheduledMessageChanged extends $pb.GeneratedMessage {
  factory Update_ScheduledMessageChanged({
    ScheduledMessage? message,
  }) {
    final result = create();
    if (message != null) result.message = message;
    return result;
  }

  Update_ScheduledMessageChanged._();

  factory Update_ScheduledMessageChanged.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ScheduledMessageChanged.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ScheduledMessageChanged',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ScheduledMessage>(1, _omitFieldNames ? '' : 'message', subBuilder: ScheduledMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ScheduledMessageChanged clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ScheduledMessageChanged copyWith(void Function(Update_ScheduledMessageChanged) updates) =>
      super.copyWith((message) => updates(message as Update_ScheduledMessageChanged)) as Update_ScheduledMessageChanged;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ScheduledMessageChanged create() => Update_ScheduledMessageChanged._();
  @$core.override
  Update_ScheduledMessageChanged createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ScheduledMessageChanged getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ScheduledMessageChanged>(create);
  static Update_ScheduledMessageChanged? _defaultInstance;

  @$pb.TagNumber(1)
  ScheduledMessage get message => $_getN(0);
  @$pb.TagNumber(1)
  set message(ScheduledMessage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => $_clearField(1);
  @$pb.TagNumber(1)
  ScheduledMessage ensureMessage() => $_ensure(0);
}

/// Мои отложенные scheduledIDs больше не ждут: отправлены (сообщение придёт
/// своим newMessage), удалены или не отправлены — сервер отказал в момент
/// отправки (чат удалён, собеседник ограничил, кто может ему писать).
class Update_ScheduledDeleted extends $pb.GeneratedMessage {
  factory Update_ScheduledDeleted({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? scheduledIDs,
    Update_ScheduledDeleted_Reason? reason,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledIDs != null) result.scheduledIDs.addAll(scheduledIDs);
    if (reason != null) result.reason = reason;
    return result;
  }

  Update_ScheduledDeleted._();

  factory Update_ScheduledDeleted.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Update_ScheduledDeleted.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update.ScheduledDeleted',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'scheduledIDs', $pb.PbFieldType.K6, protoName: 'scheduledIDs')
    ..aE<Update_ScheduledDeleted_Reason>(3, _omitFieldNames ? '' : 'reason', enumValues: Update_ScheduledDeleted_Reason.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ScheduledDeleted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Update_ScheduledDeleted copyWith(void Function(Update_ScheduledDeleted) updates) =>
      super.copyWith((message) => updates(message as Update_ScheduledDeleted)) as Update_ScheduledDeleted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Update_ScheduledDeleted create() => Update_ScheduledDeleted._();
  @$core.override
  Update_ScheduledDeleted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Update_ScheduledDeleted getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Update_ScheduledDeleted>(create);
  static Update_ScheduledDeleted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get scheduledIDs => $_getList(1);

  @$pb.TagNumber(3)
  Update_ScheduledDeleted_Reason get reason => $_getN(2);
  @$pb.TagNumber(3)
  set reason(Update_ScheduledDeleted_Reason value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

enum Update_Update {
  newMessage,
  editMessage,
  deleteMessages,
  readInbox,
  readOutbox,
  readContents,
  dialogSettings,
  dialogDeleted,
  pinnedMessages,
  messageReactions,
  readReactions,
  folders,
  scheduledMessage,
  scheduledDeleted,
  notSet
}

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
    Update_PinnedMessages? pinnedMessages,
    Update_MessageReactionsChanged? messageReactions,
    Update_ReadReactions? readReactions,
    ChatFolders? folders,
    Update_ScheduledMessageChanged? scheduledMessage,
    Update_ScheduledDeleted? scheduledDeleted,
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
    if (pinnedMessages != null) result.pinnedMessages = pinnedMessages;
    if (messageReactions != null) result.messageReactions = messageReactions;
    if (readReactions != null) result.readReactions = readReactions;
    if (folders != null) result.folders = folders;
    if (scheduledMessage != null) result.scheduledMessage = scheduledMessage;
    if (scheduledDeleted != null) result.scheduledDeleted = scheduledDeleted;
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
    11: Update_Update.pinnedMessages,
    12: Update_Update.messageReactions,
    13: Update_Update.readReactions,
    14: Update_Update.folders,
    15: Update_Update.scheduledMessage,
    16: Update_Update.scheduledDeleted,
    0: Update_Update.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Update',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16])
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
    ..aOM<Update_PinnedMessages>(11, _omitFieldNames ? '' : 'pinnedMessages',
        protoName: 'pinnedMessages', subBuilder: Update_PinnedMessages.create)
    ..aOM<Update_MessageReactionsChanged>(12, _omitFieldNames ? '' : 'messageReactions',
        protoName: 'messageReactions', subBuilder: Update_MessageReactionsChanged.create)
    ..aOM<Update_ReadReactions>(13, _omitFieldNames ? '' : 'readReactions',
        protoName: 'readReactions', subBuilder: Update_ReadReactions.create)
    ..aOM<ChatFolders>(14, _omitFieldNames ? '' : 'folders', subBuilder: ChatFolders.create)
    ..aOM<Update_ScheduledMessageChanged>(15, _omitFieldNames ? '' : 'scheduledMessage',
        protoName: 'scheduledMessage', subBuilder: Update_ScheduledMessageChanged.create)
    ..aOM<Update_ScheduledDeleted>(16, _omitFieldNames ? '' : 'scheduledDeleted',
        protoName: 'scheduledDeleted', subBuilder: Update_ScheduledDeleted.create)
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
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  Update_Update whichUpdate() => _Update_UpdateByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
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

  @$pb.TagNumber(11)
  Update_PinnedMessages get pinnedMessages => $_getN(10);
  @$pb.TagNumber(11)
  set pinnedMessages(Update_PinnedMessages value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPinnedMessages() => $_has(10);
  @$pb.TagNumber(11)
  void clearPinnedMessages() => $_clearField(11);
  @$pb.TagNumber(11)
  Update_PinnedMessages ensurePinnedMessages() => $_ensure(10);

  @$pb.TagNumber(12)
  Update_MessageReactionsChanged get messageReactions => $_getN(11);
  @$pb.TagNumber(12)
  set messageReactions(Update_MessageReactionsChanged value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasMessageReactions() => $_has(11);
  @$pb.TagNumber(12)
  void clearMessageReactions() => $_clearField(12);
  @$pb.TagNumber(12)
  Update_MessageReactionsChanged ensureMessageReactions() => $_ensure(11);

  @$pb.TagNumber(13)
  Update_ReadReactions get readReactions => $_getN(12);
  @$pb.TagNumber(13)
  set readReactions(Update_ReadReactions value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasReadReactions() => $_has(12);
  @$pb.TagNumber(13)
  void clearReadReactions() => $_clearField(13);
  @$pb.TagNumber(13)
  Update_ReadReactions ensureReadReactions() => $_ensure(12);

  /// Мои папки изменились (на этом или другом устройстве) — снимок целиком,
  /// всегда текущий.
  @$pb.TagNumber(14)
  ChatFolders get folders => $_getN(13);
  @$pb.TagNumber(14)
  set folders(ChatFolders value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasFolders() => $_has(13);
  @$pb.TagNumber(14)
  void clearFolders() => $_clearField(14);
  @$pb.TagNumber(14)
  ChatFolders ensureFolders() => $_ensure(13);

  @$pb.TagNumber(15)
  Update_ScheduledMessageChanged get scheduledMessage => $_getN(14);
  @$pb.TagNumber(15)
  set scheduledMessage(Update_ScheduledMessageChanged value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasScheduledMessage() => $_has(14);
  @$pb.TagNumber(15)
  void clearScheduledMessage() => $_clearField(15);
  @$pb.TagNumber(15)
  Update_ScheduledMessageChanged ensureScheduledMessage() => $_ensure(14);

  @$pb.TagNumber(16)
  Update_ScheduledDeleted get scheduledDeleted => $_getN(15);
  @$pb.TagNumber(16)
  set scheduledDeleted(Update_ScheduledDeleted value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasScheduledDeleted() => $_has(15);
  @$pb.TagNumber(16)
  void clearScheduledDeleted() => $_clearField(16);
  @$pb.TagNumber(16)
  Update_ScheduledDeleted ensureScheduledDeleted() => $_ensure(15);
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

/// Могу ли я писать в чат (в личном — приватность собеседника «кто может мне
/// писать»). Окно чата спрашивает при открытии, чтобы заранее показать
/// плашку вместо поля ввода. Отправку всё равно проверяет сервер.
class Chats_CanWrite extends $pb.GeneratedMessage {
  factory Chats_CanWrite({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Chats_CanWrite._();

  factory Chats_CanWrite.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CanWrite.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CanWrite',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CanWrite clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CanWrite copyWith(void Function(Chats_CanWrite) updates) =>
      super.copyWith((message) => updates(message as Chats_CanWrite)) as Chats_CanWrite;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CanWrite create() => Chats_CanWrite._();
  @$core.override
  Chats_CanWrite createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CanWrite getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CanWrite>(create);
  static Chats_CanWrite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Chats_CanWriteResult extends $pb.GeneratedMessage {
  factory Chats_CanWriteResult({
    $core.bool? allowed,
  }) {
    final result = create();
    if (allowed != null) result.allowed = allowed;
    return result;
  }

  Chats_CanWriteResult._();

  factory Chats_CanWriteResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_CanWriteResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.CanWriteResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allowed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CanWriteResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_CanWriteResult copyWith(void Function(Chats_CanWriteResult) updates) =>
      super.copyWith((message) => updates(message as Chats_CanWriteResult)) as Chats_CanWriteResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_CanWriteResult create() => Chats_CanWriteResult._();
  @$core.override
  Chats_CanWriteResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_CanWriteResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_CanWriteResult>(create);
  static Chats_CanWriteResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowed => $_getBF(0);
  @$pb.TagNumber(1)
  set allowed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowed() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowed() => $_clearField(1);
}

/// Сохранить черновик (как saveDraft в Telegram; пусто — удалить). Уходит на
/// все мои устройства обновлением dialogSettings (Dialog.draft); отправка
/// сообщения в чат черновик удаляет. Тот же текст — без обновлений.
class Chats_SaveDraft extends $pb.GeneratedMessage {
  factory Chats_SaveDraft({
    $core.List<$core.int>? chatID,
    $core.String? text,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (text != null) result.text = text;
    return result;
  }

  Chats_SaveDraft._();

  factory Chats_SaveDraft.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SaveDraft.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SaveDraft',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveDraft clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveDraft copyWith(void Function(Chats_SaveDraft) updates) =>
      super.copyWith((message) => updates(message as Chats_SaveDraft)) as Chats_SaveDraft;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SaveDraft create() => Chats_SaveDraft._();
  @$core.override
  Chats_SaveDraft createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SaveDraft getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SaveDraft>(create);
  static Chats_SaveDraft? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);
}

class Chats_SaveDraftResult extends $pb.GeneratedMessage {
  factory Chats_SaveDraftResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_SaveDraftResult._();

  factory Chats_SaveDraftResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SaveDraftResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SaveDraftResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveDraftResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveDraftResult copyWith(void Function(Chats_SaveDraftResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SaveDraftResult)) as Chats_SaveDraftResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SaveDraftResult create() => Chats_SaveDraftResult._();
  @$core.override
  Chats_SaveDraftResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SaveDraftResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SaveDraftResult>(create);
  static Chats_SaveDraftResult? _defaultInstance;

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

/// Папки: снимок — при первом входе и перезагрузке диалогов; изменения
/// приходят обновлением folders на все мои устройства.
class Chats_GetFolders extends $pb.GeneratedMessage {
  factory Chats_GetFolders() => create();

  Chats_GetFolders._();

  factory Chats_GetFolders.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_GetFolders.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.GetFolders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetFolders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetFolders copyWith(void Function(Chats_GetFolders) updates) =>
      super.copyWith((message) => updates(message as Chats_GetFolders)) as Chats_GetFolders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_GetFolders create() => Chats_GetFolders._();
  @$core.override
  Chats_GetFolders createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_GetFolders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_GetFolders>(create);
  static Chats_GetFolders? _defaultInstance;
}

class Chats_GetFoldersResult extends $pb.GeneratedMessage {
  factory Chats_GetFoldersResult({
    ChatFolders? folders,
  }) {
    final result = create();
    if (folders != null) result.folders = folders;
    return result;
  }

  Chats_GetFoldersResult._();

  factory Chats_GetFoldersResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_GetFoldersResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.GetFoldersResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatFolders>(1, _omitFieldNames ? '' : 'folders', subBuilder: ChatFolders.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetFoldersResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_GetFoldersResult copyWith(void Function(Chats_GetFoldersResult) updates) =>
      super.copyWith((message) => updates(message as Chats_GetFoldersResult)) as Chats_GetFoldersResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_GetFoldersResult create() => Chats_GetFoldersResult._();
  @$core.override
  Chats_GetFoldersResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_GetFoldersResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_GetFoldersResult>(create);
  static Chats_GetFoldersResult? _defaultInstance;

  @$pb.TagNumber(1)
  ChatFolders get folders => $_getN(0);
  @$pb.TagNumber(1)
  set folders(ChatFolders value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFolders() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolders() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatFolders ensureFolders() => $_ensure(0);
}

/// Создать (id = 0, в конец; не больше 9) или изменить папку. Нет такой
/// (удалили на другом устройстве) — NOT_FOUND; лимит — FAILED_PRECONDITION
/// «foldersLimit». Без изменений — без обновлений.
class Chats_SaveFolder extends $pb.GeneratedMessage {
  factory Chats_SaveFolder({
    ChatFolder? folder,
  }) {
    final result = create();
    if (folder != null) result.folder = folder;
    return result;
  }

  Chats_SaveFolder._();

  factory Chats_SaveFolder.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SaveFolder.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SaveFolder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<ChatFolder>(1, _omitFieldNames ? '' : 'folder', subBuilder: ChatFolder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveFolder copyWith(void Function(Chats_SaveFolder) updates) =>
      super.copyWith((message) => updates(message as Chats_SaveFolder)) as Chats_SaveFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SaveFolder create() => Chats_SaveFolder._();
  @$core.override
  Chats_SaveFolder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SaveFolder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SaveFolder>(create);
  static Chats_SaveFolder? _defaultInstance;

  @$pb.TagNumber(1)
  ChatFolder get folder => $_getN(0);
  @$pb.TagNumber(1)
  set folder(ChatFolder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFolder() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolder() => $_clearField(1);
  @$pb.TagNumber(1)
  ChatFolder ensureFolder() => $_ensure(0);
}

class Chats_SaveFolderResult extends $pb.GeneratedMessage {
  factory Chats_SaveFolderResult({
    Updates? updates,
    $core.int? id,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    if (id != null) result.id = id;
    return result;
  }

  Chats_SaveFolderResult._();

  factory Chats_SaveFolderResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_SaveFolderResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.SaveFolderResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..aI(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveFolderResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_SaveFolderResult copyWith(void Function(Chats_SaveFolderResult) updates) =>
      super.copyWith((message) => updates(message as Chats_SaveFolderResult)) as Chats_SaveFolderResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_SaveFolderResult create() => Chats_SaveFolderResult._();
  @$core.override
  Chats_SaveFolderResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_SaveFolderResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_SaveFolderResult>(create);
  static Chats_SaveFolderResult? _defaultInstance;

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

  @$pb.TagNumber(2)
  $core.int get id => $_getIZ(1);
  @$pb.TagNumber(2)
  set id($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

/// Удалить папку (уже нет — ничего).
class Chats_DeleteFolder extends $pb.GeneratedMessage {
  factory Chats_DeleteFolder({
    $core.int? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  Chats_DeleteFolder._();

  factory Chats_DeleteFolder.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteFolder.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteFolder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteFolder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteFolder copyWith(void Function(Chats_DeleteFolder) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteFolder)) as Chats_DeleteFolder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteFolder create() => Chats_DeleteFolder._();
  @$core.override
  Chats_DeleteFolder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteFolder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteFolder>(create);
  static Chats_DeleteFolder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class Chats_DeleteFolderResult extends $pb.GeneratedMessage {
  factory Chats_DeleteFolderResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_DeleteFolderResult._();

  factory Chats_DeleteFolderResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_DeleteFolderResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.DeleteFolderResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteFolderResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_DeleteFolderResult copyWith(void Function(Chats_DeleteFolderResult) updates) =>
      super.copyWith((message) => updates(message as Chats_DeleteFolderResult)) as Chats_DeleteFolderResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_DeleteFolderResult create() => Chats_DeleteFolderResult._();
  @$core.override
  Chats_DeleteFolderResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_DeleteFolderResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_DeleteFolderResult>(create);
  static Chats_DeleteFolderResult? _defaultInstance;

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

/// Новый порядок папок: ids — по порядку; не названные — в конец.
class Chats_ReorderFolders extends $pb.GeneratedMessage {
  factory Chats_ReorderFolders({
    $core.Iterable<$core.int>? ids,
  }) {
    final result = create();
    if (ids != null) result.ids.addAll(ids);
    return result;
  }

  Chats_ReorderFolders._();

  factory Chats_ReorderFolders.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReorderFolders.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReorderFolders',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..p<$core.int>(1, _omitFieldNames ? '' : 'ids', $pb.PbFieldType.K3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReorderFolders clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReorderFolders copyWith(void Function(Chats_ReorderFolders) updates) =>
      super.copyWith((message) => updates(message as Chats_ReorderFolders)) as Chats_ReorderFolders;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReorderFolders create() => Chats_ReorderFolders._();
  @$core.override
  Chats_ReorderFolders createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReorderFolders getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReorderFolders>(create);
  static Chats_ReorderFolders? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.int> get ids => $_getList(0);
}

class Chats_ReorderFoldersResult extends $pb.GeneratedMessage {
  factory Chats_ReorderFoldersResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Chats_ReorderFoldersResult._();

  factory Chats_ReorderFoldersResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ReorderFoldersResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ReorderFoldersResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReorderFoldersResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ReorderFoldersResult copyWith(void Function(Chats_ReorderFoldersResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ReorderFoldersResult)) as Chats_ReorderFoldersResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ReorderFoldersResult create() => Chats_ReorderFoldersResult._();
  @$core.override
  Chats_ReorderFoldersResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ReorderFoldersResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ReorderFoldersResult>(create);
  static Chats_ReorderFoldersResult? _defaultInstance;

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

/// Пользователь по имени (ссылка iperon.net/<username>, @username): его
/// личный чат со мной — существующий или новый (как openPrivate); своё имя
/// — «Избранное». Нет такого — NOT_FOUND. Свой лимит частоты (перебор
/// имён), новый чат — ещё и лимит openPrivate.
class Chats_ResolveUsername extends $pb.GeneratedMessage {
  factory Chats_ResolveUsername({
    $core.String? username,
  }) {
    final result = create();
    if (username != null) result.username = username;
    return result;
  }

  Chats_ResolveUsername._();

  factory Chats_ResolveUsername.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ResolveUsername.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ResolveUsername',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveUsername clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveUsername copyWith(void Function(Chats_ResolveUsername) updates) =>
      super.copyWith((message) => updates(message as Chats_ResolveUsername)) as Chats_ResolveUsername;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ResolveUsername create() => Chats_ResolveUsername._();
  @$core.override
  Chats_ResolveUsername createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ResolveUsername getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ResolveUsername>(create);
  static Chats_ResolveUsername? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);
}

class Chats_ResolveUsernameResult extends $pb.GeneratedMessage {
  factory Chats_ResolveUsernameResult({
    Dialog? dialog,
  }) {
    final result = create();
    if (dialog != null) result.dialog = dialog;
    return result;
  }

  Chats_ResolveUsernameResult._();

  factory Chats_ResolveUsernameResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chats_ResolveUsernameResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.ResolveUsernameResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Dialog>(1, _omitFieldNames ? '' : 'dialog', subBuilder: Dialog.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveUsernameResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chats_ResolveUsernameResult copyWith(void Function(Chats_ResolveUsernameResult) updates) =>
      super.copyWith((message) => updates(message as Chats_ResolveUsernameResult)) as Chats_ResolveUsernameResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chats_ResolveUsernameResult create() => Chats_ResolveUsernameResult._();
  @$core.override
  Chats_ResolveUsernameResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chats_ResolveUsernameResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chats_ResolveUsernameResult>(create);
  static Chats_ResolveUsernameResult? _defaultInstance;

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

enum Chats_Request_Request {
  list,
  openPrivate,
  readHistory,
  setDialog,
  deleteDialog,
  readDate,
  canWrite,
  saveDraft,
  getFolders,
  saveFolder,
  deleteFolder,
  reorderFolders,
  resolveUsername,
  notSet
}

class Chats_Request extends $pb.GeneratedMessage {
  factory Chats_Request({
    Chats_List? list,
    Chats_OpenPrivate? openPrivate,
    Chats_ReadHistory? readHistory,
    Chats_SetDialog? setDialog,
    Chats_DeleteDialog? deleteDialog,
    Chats_ReadDate? readDate,
    Chats_CanWrite? canWrite,
    Chats_SaveDraft? saveDraft,
    Chats_GetFolders? getFolders,
    Chats_SaveFolder? saveFolder,
    Chats_DeleteFolder? deleteFolder,
    Chats_ReorderFolders? reorderFolders,
    Chats_ResolveUsername? resolveUsername,
  }) {
    final result = create();
    if (list != null) result.list = list;
    if (openPrivate != null) result.openPrivate = openPrivate;
    if (readHistory != null) result.readHistory = readHistory;
    if (setDialog != null) result.setDialog = setDialog;
    if (deleteDialog != null) result.deleteDialog = deleteDialog;
    if (readDate != null) result.readDate = readDate;
    if (canWrite != null) result.canWrite = canWrite;
    if (saveDraft != null) result.saveDraft = saveDraft;
    if (getFolders != null) result.getFolders = getFolders;
    if (saveFolder != null) result.saveFolder = saveFolder;
    if (deleteFolder != null) result.deleteFolder = deleteFolder;
    if (reorderFolders != null) result.reorderFolders = reorderFolders;
    if (resolveUsername != null) result.resolveUsername = resolveUsername;
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
    7: Chats_Request_Request.canWrite,
    8: Chats_Request_Request.saveDraft,
    9: Chats_Request_Request.getFolders,
    10: Chats_Request_Request.saveFolder,
    11: Chats_Request_Request.deleteFolder,
    12: Chats_Request_Request.reorderFolders,
    13: Chats_Request_Request.resolveUsername,
    0: Chats_Request_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13])
    ..aOM<Chats_List>(1, _omitFieldNames ? '' : 'list', subBuilder: Chats_List.create)
    ..aOM<Chats_OpenPrivate>(2, _omitFieldNames ? '' : 'openPrivate', protoName: 'openPrivate', subBuilder: Chats_OpenPrivate.create)
    ..aOM<Chats_ReadHistory>(3, _omitFieldNames ? '' : 'readHistory', protoName: 'readHistory', subBuilder: Chats_ReadHistory.create)
    ..aOM<Chats_SetDialog>(4, _omitFieldNames ? '' : 'setDialog', protoName: 'setDialog', subBuilder: Chats_SetDialog.create)
    ..aOM<Chats_DeleteDialog>(5, _omitFieldNames ? '' : 'deleteDialog', protoName: 'deleteDialog', subBuilder: Chats_DeleteDialog.create)
    ..aOM<Chats_ReadDate>(6, _omitFieldNames ? '' : 'readDate', protoName: 'readDate', subBuilder: Chats_ReadDate.create)
    ..aOM<Chats_CanWrite>(7, _omitFieldNames ? '' : 'canWrite', protoName: 'canWrite', subBuilder: Chats_CanWrite.create)
    ..aOM<Chats_SaveDraft>(8, _omitFieldNames ? '' : 'saveDraft', protoName: 'saveDraft', subBuilder: Chats_SaveDraft.create)
    ..aOM<Chats_GetFolders>(9, _omitFieldNames ? '' : 'getFolders', protoName: 'getFolders', subBuilder: Chats_GetFolders.create)
    ..aOM<Chats_SaveFolder>(10, _omitFieldNames ? '' : 'saveFolder', protoName: 'saveFolder', subBuilder: Chats_SaveFolder.create)
    ..aOM<Chats_DeleteFolder>(11, _omitFieldNames ? '' : 'deleteFolder', protoName: 'deleteFolder', subBuilder: Chats_DeleteFolder.create)
    ..aOM<Chats_ReorderFolders>(12, _omitFieldNames ? '' : 'reorderFolders',
        protoName: 'reorderFolders', subBuilder: Chats_ReorderFolders.create)
    ..aOM<Chats_ResolveUsername>(13, _omitFieldNames ? '' : 'resolveUsername',
        protoName: 'resolveUsername', subBuilder: Chats_ResolveUsername.create)
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
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  Chats_Request_Request whichRequest() => _Chats_Request_RequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
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

  @$pb.TagNumber(7)
  Chats_CanWrite get canWrite => $_getN(6);
  @$pb.TagNumber(7)
  set canWrite(Chats_CanWrite value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCanWrite() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanWrite() => $_clearField(7);
  @$pb.TagNumber(7)
  Chats_CanWrite ensureCanWrite() => $_ensure(6);

  @$pb.TagNumber(8)
  Chats_SaveDraft get saveDraft => $_getN(7);
  @$pb.TagNumber(8)
  set saveDraft(Chats_SaveDraft value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSaveDraft() => $_has(7);
  @$pb.TagNumber(8)
  void clearSaveDraft() => $_clearField(8);
  @$pb.TagNumber(8)
  Chats_SaveDraft ensureSaveDraft() => $_ensure(7);

  @$pb.TagNumber(9)
  Chats_GetFolders get getFolders => $_getN(8);
  @$pb.TagNumber(9)
  set getFolders(Chats_GetFolders value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasGetFolders() => $_has(8);
  @$pb.TagNumber(9)
  void clearGetFolders() => $_clearField(9);
  @$pb.TagNumber(9)
  Chats_GetFolders ensureGetFolders() => $_ensure(8);

  @$pb.TagNumber(10)
  Chats_SaveFolder get saveFolder => $_getN(9);
  @$pb.TagNumber(10)
  set saveFolder(Chats_SaveFolder value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSaveFolder() => $_has(9);
  @$pb.TagNumber(10)
  void clearSaveFolder() => $_clearField(10);
  @$pb.TagNumber(10)
  Chats_SaveFolder ensureSaveFolder() => $_ensure(9);

  @$pb.TagNumber(11)
  Chats_DeleteFolder get deleteFolder => $_getN(10);
  @$pb.TagNumber(11)
  set deleteFolder(Chats_DeleteFolder value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDeleteFolder() => $_has(10);
  @$pb.TagNumber(11)
  void clearDeleteFolder() => $_clearField(11);
  @$pb.TagNumber(11)
  Chats_DeleteFolder ensureDeleteFolder() => $_ensure(10);

  @$pb.TagNumber(12)
  Chats_ReorderFolders get reorderFolders => $_getN(11);
  @$pb.TagNumber(12)
  set reorderFolders(Chats_ReorderFolders value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReorderFolders() => $_has(11);
  @$pb.TagNumber(12)
  void clearReorderFolders() => $_clearField(12);
  @$pb.TagNumber(12)
  Chats_ReorderFolders ensureReorderFolders() => $_ensure(11);

  @$pb.TagNumber(13)
  Chats_ResolveUsername get resolveUsername => $_getN(12);
  @$pb.TagNumber(13)
  set resolveUsername(Chats_ResolveUsername value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasResolveUsername() => $_has(12);
  @$pb.TagNumber(13)
  void clearResolveUsername() => $_clearField(13);
  @$pb.TagNumber(13)
  Chats_ResolveUsername ensureResolveUsername() => $_ensure(12);
}

enum Chats_Response_Response {
  list,
  openPrivate,
  readHistory,
  setDialog,
  deleteDialog,
  readDate,
  canWrite,
  saveDraft,
  getFolders,
  saveFolder,
  deleteFolder,
  reorderFolders,
  resolveUsername,
  notSet
}

class Chats_Response extends $pb.GeneratedMessage {
  factory Chats_Response({
    Chats_ListResult? list,
    Chats_OpenPrivateResult? openPrivate,
    Chats_ReadHistoryResult? readHistory,
    Chats_SetDialogResult? setDialog,
    Chats_DeleteDialogResult? deleteDialog,
    Chats_ReadDateResult? readDate,
    Chats_CanWriteResult? canWrite,
    Chats_SaveDraftResult? saveDraft,
    Chats_GetFoldersResult? getFolders,
    Chats_SaveFolderResult? saveFolder,
    Chats_DeleteFolderResult? deleteFolder,
    Chats_ReorderFoldersResult? reorderFolders,
    Chats_ResolveUsernameResult? resolveUsername,
  }) {
    final result = create();
    if (list != null) result.list = list;
    if (openPrivate != null) result.openPrivate = openPrivate;
    if (readHistory != null) result.readHistory = readHistory;
    if (setDialog != null) result.setDialog = setDialog;
    if (deleteDialog != null) result.deleteDialog = deleteDialog;
    if (readDate != null) result.readDate = readDate;
    if (canWrite != null) result.canWrite = canWrite;
    if (saveDraft != null) result.saveDraft = saveDraft;
    if (getFolders != null) result.getFolders = getFolders;
    if (saveFolder != null) result.saveFolder = saveFolder;
    if (deleteFolder != null) result.deleteFolder = deleteFolder;
    if (reorderFolders != null) result.reorderFolders = reorderFolders;
    if (resolveUsername != null) result.resolveUsername = resolveUsername;
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
    7: Chats_Response_Response.canWrite,
    8: Chats_Response_Response.saveDraft,
    9: Chats_Response_Response.getFolders,
    10: Chats_Response_Response.saveFolder,
    11: Chats_Response_Response.deleteFolder,
    12: Chats_Response_Response.reorderFolders,
    13: Chats_Response_Response.resolveUsername,
    0: Chats_Response_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Chats.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13])
    ..aOM<Chats_ListResult>(1, _omitFieldNames ? '' : 'list', subBuilder: Chats_ListResult.create)
    ..aOM<Chats_OpenPrivateResult>(2, _omitFieldNames ? '' : 'openPrivate',
        protoName: 'openPrivate', subBuilder: Chats_OpenPrivateResult.create)
    ..aOM<Chats_ReadHistoryResult>(3, _omitFieldNames ? '' : 'readHistory',
        protoName: 'readHistory', subBuilder: Chats_ReadHistoryResult.create)
    ..aOM<Chats_SetDialogResult>(4, _omitFieldNames ? '' : 'setDialog', protoName: 'setDialog', subBuilder: Chats_SetDialogResult.create)
    ..aOM<Chats_DeleteDialogResult>(5, _omitFieldNames ? '' : 'deleteDialog',
        protoName: 'deleteDialog', subBuilder: Chats_DeleteDialogResult.create)
    ..aOM<Chats_ReadDateResult>(6, _omitFieldNames ? '' : 'readDate', protoName: 'readDate', subBuilder: Chats_ReadDateResult.create)
    ..aOM<Chats_CanWriteResult>(7, _omitFieldNames ? '' : 'canWrite', protoName: 'canWrite', subBuilder: Chats_CanWriteResult.create)
    ..aOM<Chats_SaveDraftResult>(8, _omitFieldNames ? '' : 'saveDraft', protoName: 'saveDraft', subBuilder: Chats_SaveDraftResult.create)
    ..aOM<Chats_GetFoldersResult>(9, _omitFieldNames ? '' : 'getFolders',
        protoName: 'getFolders', subBuilder: Chats_GetFoldersResult.create)
    ..aOM<Chats_SaveFolderResult>(10, _omitFieldNames ? '' : 'saveFolder',
        protoName: 'saveFolder', subBuilder: Chats_SaveFolderResult.create)
    ..aOM<Chats_DeleteFolderResult>(11, _omitFieldNames ? '' : 'deleteFolder',
        protoName: 'deleteFolder', subBuilder: Chats_DeleteFolderResult.create)
    ..aOM<Chats_ReorderFoldersResult>(12, _omitFieldNames ? '' : 'reorderFolders',
        protoName: 'reorderFolders', subBuilder: Chats_ReorderFoldersResult.create)
    ..aOM<Chats_ResolveUsernameResult>(13, _omitFieldNames ? '' : 'resolveUsername',
        protoName: 'resolveUsername', subBuilder: Chats_ResolveUsernameResult.create)
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
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  Chats_Response_Response whichResponse() => _Chats_Response_ResponseByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
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

  @$pb.TagNumber(7)
  Chats_CanWriteResult get canWrite => $_getN(6);
  @$pb.TagNumber(7)
  set canWrite(Chats_CanWriteResult value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCanWrite() => $_has(6);
  @$pb.TagNumber(7)
  void clearCanWrite() => $_clearField(7);
  @$pb.TagNumber(7)
  Chats_CanWriteResult ensureCanWrite() => $_ensure(6);

  @$pb.TagNumber(8)
  Chats_SaveDraftResult get saveDraft => $_getN(7);
  @$pb.TagNumber(8)
  set saveDraft(Chats_SaveDraftResult value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSaveDraft() => $_has(7);
  @$pb.TagNumber(8)
  void clearSaveDraft() => $_clearField(8);
  @$pb.TagNumber(8)
  Chats_SaveDraftResult ensureSaveDraft() => $_ensure(7);

  @$pb.TagNumber(9)
  Chats_GetFoldersResult get getFolders => $_getN(8);
  @$pb.TagNumber(9)
  set getFolders(Chats_GetFoldersResult value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasGetFolders() => $_has(8);
  @$pb.TagNumber(9)
  void clearGetFolders() => $_clearField(9);
  @$pb.TagNumber(9)
  Chats_GetFoldersResult ensureGetFolders() => $_ensure(8);

  @$pb.TagNumber(10)
  Chats_SaveFolderResult get saveFolder => $_getN(9);
  @$pb.TagNumber(10)
  set saveFolder(Chats_SaveFolderResult value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSaveFolder() => $_has(9);
  @$pb.TagNumber(10)
  void clearSaveFolder() => $_clearField(10);
  @$pb.TagNumber(10)
  Chats_SaveFolderResult ensureSaveFolder() => $_ensure(9);

  @$pb.TagNumber(11)
  Chats_DeleteFolderResult get deleteFolder => $_getN(10);
  @$pb.TagNumber(11)
  set deleteFolder(Chats_DeleteFolderResult value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasDeleteFolder() => $_has(10);
  @$pb.TagNumber(11)
  void clearDeleteFolder() => $_clearField(11);
  @$pb.TagNumber(11)
  Chats_DeleteFolderResult ensureDeleteFolder() => $_ensure(10);

  @$pb.TagNumber(12)
  Chats_ReorderFoldersResult get reorderFolders => $_getN(11);
  @$pb.TagNumber(12)
  set reorderFolders(Chats_ReorderFoldersResult value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReorderFolders() => $_has(11);
  @$pb.TagNumber(12)
  void clearReorderFolders() => $_clearField(12);
  @$pb.TagNumber(12)
  Chats_ReorderFoldersResult ensureReorderFolders() => $_ensure(11);

  @$pb.TagNumber(13)
  Chats_ResolveUsernameResult get resolveUsername => $_getN(12);
  @$pb.TagNumber(13)
  set resolveUsername(Chats_ResolveUsernameResult value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasResolveUsername() => $_has(12);
  @$pb.TagNumber(13)
  void clearResolveUsername() => $_clearField(13);
  @$pb.TagNumber(13)
  Chats_ResolveUsernameResult ensureResolveUsername() => $_ensure(12);
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
    Messages_ForwardFrom? forwardFrom,
    $fixnum.Int64? scheduleDate,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (peerUserID != null) result.peerUserID = peerUserID;
    if (randomID != null) result.randomID = randomID;
    if (content != null) result.content = content;
    if (silent != null) result.silent = silent;
    if (forwardFrom != null) result.forwardFrom = forwardFrom;
    if (scheduleDate != null) result.scheduleDate = scheduleDate;
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
    ..aOM<Messages_ForwardFrom>(6, _omitFieldNames ? '' : 'forwardFrom', protoName: 'forwardFrom', subBuilder: Messages_ForwardFrom.create)
    ..aInt64(7, _omitFieldNames ? '' : 'scheduleDate', protoName: 'scheduleDate')
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

  /// Пересылка (как forwardMessages в Telegram): содержимое сервер берёт из
  /// исходного сообщения (без ответа, с заголовком forward; пересланное
  /// остаётся «от» автора оригинала) — content клиент не заполняет. Доступ —
  /// через исходное сообщение, а не владение файлами вложений.
  @$pb.TagNumber(6)
  Messages_ForwardFrom get forwardFrom => $_getN(5);
  @$pb.TagNumber(6)
  set forwardFrom(Messages_ForwardFrom value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasForwardFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearForwardFrom() => $_clearField(6);
  @$pb.TagNumber(6)
  Messages_ForwardFrom ensureForwardFrom() => $_ensure(5);

  /// Отложить до этого времени (unix millis; 0 — отправить сейчас): в ответе
  /// scheduled вместо message. Уже прошедшее (ждало в outbox без сети) —
  /// уйдёт в ближайшие секунды. Не дальше года; до 100 на чат
  /// (FAILED_PRECONDITION «scheduledLimit»); пересылку отложить нельзя.
  @$pb.TagNumber(7)
  $fixnum.Int64 get scheduleDate => $_getI64(6);
  @$pb.TagNumber(7)
  set scheduleDate($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasScheduleDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearScheduleDate() => $_clearField(7);
}

/// Исходное сообщение пересылки — в чате, где я участник и оно мне видно.
class Messages_ForwardFrom extends $pb.GeneratedMessage {
  factory Messages_ForwardFrom({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    return result;
  }

  Messages_ForwardFrom._();

  factory Messages_ForwardFrom.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ForwardFrom.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ForwardFrom',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ForwardFrom clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ForwardFrom copyWith(void Function(Messages_ForwardFrom) updates) =>
      super.copyWith((message) => updates(message as Messages_ForwardFrom)) as Messages_ForwardFrom;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ForwardFrom create() => Messages_ForwardFrom._();
  @$core.override
  Messages_ForwardFrom createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ForwardFrom getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ForwardFrom>(create);
  static Messages_ForwardFrom? _defaultInstance;

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

class Messages_SendResult extends $pb.GeneratedMessage {
  factory Messages_SendResult({
    ChatMessage? message,
    Updates? updates,
    ScheduledMessage? scheduled,
  }) {
    final result = create();
    if (message != null) result.message = message;
    if (updates != null) result.updates = updates;
    if (scheduled != null) result.scheduled = scheduled;
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
    ..aOM<ScheduledMessage>(3, _omitFieldNames ? '' : 'scheduled', subBuilder: ScheduledMessage.create)
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

  @$pb.TagNumber(3)
  ScheduledMessage get scheduled => $_getN(2);
  @$pb.TagNumber(3)
  set scheduled(ScheduledMessage value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScheduled() => $_has(2);
  @$pb.TagNumber(3)
  void clearScheduled() => $_clearField(3);
  @$pb.TagNumber(3)
  ScheduledMessage ensureScheduled() => $_ensure(2);
}

/// Мои отложенные в чате — по времени отправки.
class Messages_Scheduled extends $pb.GeneratedMessage {
  factory Messages_Scheduled({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Messages_Scheduled._();

  factory Messages_Scheduled.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Scheduled.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Scheduled',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Scheduled clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Scheduled copyWith(void Function(Messages_Scheduled) updates) =>
      super.copyWith((message) => updates(message as Messages_Scheduled)) as Messages_Scheduled;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Scheduled create() => Messages_Scheduled._();
  @$core.override
  Messages_Scheduled createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Scheduled getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Scheduled>(create);
  static Messages_Scheduled? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Messages_ScheduledResult extends $pb.GeneratedMessage {
  factory Messages_ScheduledResult({
    $core.Iterable<ScheduledMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  Messages_ScheduledResult._();

  factory Messages_ScheduledResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ScheduledResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ScheduledResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ScheduledMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ScheduledMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ScheduledResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ScheduledResult copyWith(void Function(Messages_ScheduledResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ScheduledResult)) as Messages_ScheduledResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ScheduledResult create() => Messages_ScheduledResult._();
  @$core.override
  Messages_ScheduledResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ScheduledResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ScheduledResult>(create);
  static Messages_ScheduledResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ScheduledMessage> get messages => $_getList(0);
}

/// Отправить отложенные сейчас (уже ушедшие — пропускаются).
class Messages_SendScheduledNow extends $pb.GeneratedMessage {
  factory Messages_SendScheduledNow({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? scheduledIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledIDs != null) result.scheduledIDs.addAll(scheduledIDs);
    return result;
  }

  Messages_SendScheduledNow._();

  factory Messages_SendScheduledNow.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SendScheduledNow.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SendScheduledNow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'scheduledIDs', $pb.PbFieldType.K6, protoName: 'scheduledIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendScheduledNow clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendScheduledNow copyWith(void Function(Messages_SendScheduledNow) updates) =>
      super.copyWith((message) => updates(message as Messages_SendScheduledNow)) as Messages_SendScheduledNow;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SendScheduledNow create() => Messages_SendScheduledNow._();
  @$core.override
  Messages_SendScheduledNow createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SendScheduledNow getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SendScheduledNow>(create);
  static Messages_SendScheduledNow? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get scheduledIDs => $_getList(1);
}

class Messages_SendScheduledNowResult extends $pb.GeneratedMessage {
  factory Messages_SendScheduledNowResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_SendScheduledNowResult._();

  factory Messages_SendScheduledNowResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SendScheduledNowResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SendScheduledNowResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendScheduledNowResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SendScheduledNowResult copyWith(void Function(Messages_SendScheduledNowResult) updates) =>
      super.copyWith((message) => updates(message as Messages_SendScheduledNowResult)) as Messages_SendScheduledNowResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SendScheduledNowResult create() => Messages_SendScheduledNowResult._();
  @$core.override
  Messages_SendScheduledNowResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SendScheduledNowResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SendScheduledNowResult>(create);
  static Messages_SendScheduledNowResult? _defaultInstance;

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

/// Перенести отложенное (уже ушедшее — NOT_FOUND).
class Messages_Reschedule extends $pb.GeneratedMessage {
  factory Messages_Reschedule({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? scheduledID,
    $fixnum.Int64? date,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledID != null) result.scheduledID = scheduledID;
    if (date != null) result.date = date;
    return result;
  }

  Messages_Reschedule._();

  factory Messages_Reschedule.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Reschedule.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Reschedule',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'scheduledID', protoName: 'scheduledID')
    ..aInt64(3, _omitFieldNames ? '' : 'date')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Reschedule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Reschedule copyWith(void Function(Messages_Reschedule) updates) =>
      super.copyWith((message) => updates(message as Messages_Reschedule)) as Messages_Reschedule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Reschedule create() => Messages_Reschedule._();
  @$core.override
  Messages_Reschedule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Reschedule getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Reschedule>(create);
  static Messages_Reschedule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get scheduledID => $_getI64(1);
  @$pb.TagNumber(2)
  set scheduledID($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScheduledID() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduledID() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get date => $_getI64(2);
  @$pb.TagNumber(3)
  set date($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => $_clearField(3);
}

class Messages_RescheduleResult extends $pb.GeneratedMessage {
  factory Messages_RescheduleResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_RescheduleResult._();

  factory Messages_RescheduleResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_RescheduleResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.RescheduleResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_RescheduleResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_RescheduleResult copyWith(void Function(Messages_RescheduleResult) updates) =>
      super.copyWith((message) => updates(message as Messages_RescheduleResult)) as Messages_RescheduleResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_RescheduleResult create() => Messages_RescheduleResult._();
  @$core.override
  Messages_RescheduleResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_RescheduleResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_RescheduleResult>(create);
  static Messages_RescheduleResult? _defaultInstance;

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

/// Удалить отложенные.
class Messages_DeleteScheduled extends $pb.GeneratedMessage {
  factory Messages_DeleteScheduled({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? scheduledIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (scheduledIDs != null) result.scheduledIDs.addAll(scheduledIDs);
    return result;
  }

  Messages_DeleteScheduled._();

  factory Messages_DeleteScheduled.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_DeleteScheduled.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.DeleteScheduled',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'scheduledIDs', $pb.PbFieldType.K6, protoName: 'scheduledIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteScheduled clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteScheduled copyWith(void Function(Messages_DeleteScheduled) updates) =>
      super.copyWith((message) => updates(message as Messages_DeleteScheduled)) as Messages_DeleteScheduled;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_DeleteScheduled create() => Messages_DeleteScheduled._();
  @$core.override
  Messages_DeleteScheduled createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_DeleteScheduled getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_DeleteScheduled>(create);
  static Messages_DeleteScheduled? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$fixnum.Int64> get scheduledIDs => $_getList(1);
}

class Messages_DeleteScheduledResult extends $pb.GeneratedMessage {
  factory Messages_DeleteScheduledResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_DeleteScheduledResult._();

  factory Messages_DeleteScheduledResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_DeleteScheduledResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.DeleteScheduledResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteScheduledResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_DeleteScheduledResult copyWith(void Function(Messages_DeleteScheduledResult) updates) =>
      super.copyWith((message) => updates(message as Messages_DeleteScheduledResult)) as Messages_DeleteScheduledResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_DeleteScheduledResult create() => Messages_DeleteScheduledResult._();
  @$core.override
  Messages_DeleteScheduledResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_DeleteScheduledResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_DeleteScheduledResult>(create);
  static Messages_DeleteScheduledResult? _defaultInstance;

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

/// Закрепить / открепить. forEveryone — закрепить и у собеседника (в ленте
/// появляется служебное MessagePin); собеседник ограничил, кто может ему
/// писать, — закрепится только у себя. Открепление с forEveryone — у обоих,
/// без — только у себя (служебного нет). Служебные сообщения не закрепляются.
class Messages_Pin extends $pb.GeneratedMessage {
  factory Messages_Pin({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.bool? pinned,
    $core.bool? forEveryone,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (pinned != null) result.pinned = pinned;
    if (forEveryone != null) result.forEveryone = forEveryone;
    return result;
  }

  Messages_Pin._();

  factory Messages_Pin.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Pin.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Pin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..aOB(3, _omitFieldNames ? '' : 'pinned')
    ..aOB(4, _omitFieldNames ? '' : 'forEveryone', protoName: 'forEveryone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Pin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Pin copyWith(void Function(Messages_Pin) updates) =>
      super.copyWith((message) => updates(message as Messages_Pin)) as Messages_Pin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Pin create() => Messages_Pin._();
  @$core.override
  Messages_Pin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Pin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Pin>(create);
  static Messages_Pin? _defaultInstance;

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
  $core.bool get pinned => $_getBF(2);
  @$pb.TagNumber(3)
  set pinned($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPinned() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinned() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get forEveryone => $_getBF(3);
  @$pb.TagNumber(4)
  set forEveryone($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasForEveryone() => $_has(3);
  @$pb.TagNumber(4)
  void clearForEveryone() => $_clearField(4);
}

class Messages_PinResult extends $pb.GeneratedMessage {
  factory Messages_PinResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_PinResult._();

  factory Messages_PinResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_PinResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.PinResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PinResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PinResult copyWith(void Function(Messages_PinResult) updates) =>
      super.copyWith((message) => updates(message as Messages_PinResult)) as Messages_PinResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_PinResult create() => Messages_PinResult._();
  @$core.override
  Messages_PinResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_PinResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_PinResult>(create);
  static Messages_PinResult? _defaultInstance;

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

/// Открепить все мои закреплённые в чате: forEveryone — и у собеседника,
/// иначе только у себя.
class Messages_UnpinAll extends $pb.GeneratedMessage {
  factory Messages_UnpinAll({
    $core.List<$core.int>? chatID,
    $core.bool? forEveryone,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (forEveryone != null) result.forEveryone = forEveryone;
    return result;
  }

  Messages_UnpinAll._();

  factory Messages_UnpinAll.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnpinAll.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnpinAll',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aOB(2, _omitFieldNames ? '' : 'forEveryone', protoName: 'forEveryone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnpinAll clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnpinAll copyWith(void Function(Messages_UnpinAll) updates) =>
      super.copyWith((message) => updates(message as Messages_UnpinAll)) as Messages_UnpinAll;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnpinAll create() => Messages_UnpinAll._();
  @$core.override
  Messages_UnpinAll createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnpinAll getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnpinAll>(create);
  static Messages_UnpinAll? _defaultInstance;

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

class Messages_UnpinAllResult extends $pb.GeneratedMessage {
  factory Messages_UnpinAllResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_UnpinAllResult._();

  factory Messages_UnpinAllResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnpinAllResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnpinAllResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnpinAllResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnpinAllResult copyWith(void Function(Messages_UnpinAllResult) updates) =>
      super.copyWith((message) => updates(message as Messages_UnpinAllResult)) as Messages_UnpinAllResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnpinAllResult create() => Messages_UnpinAllResult._();
  @$core.override
  Messages_UnpinAllResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnpinAllResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnpinAllResult>(create);
  static Messages_UnpinAllResult? _defaultInstance;

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

/// Мои закреплённые сообщения чата — по убыванию messageID (не больше 100).
/// Окно чата спрашивает при открытии: закреплённые могут быть старше
/// скачанной истории.
class Messages_Pinned extends $pb.GeneratedMessage {
  factory Messages_Pinned({
    $core.List<$core.int>? chatID,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    return result;
  }

  Messages_Pinned._();

  factory Messages_Pinned.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_Pinned.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Pinned',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Pinned clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_Pinned copyWith(void Function(Messages_Pinned) updates) =>
      super.copyWith((message) => updates(message as Messages_Pinned)) as Messages_Pinned;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_Pinned create() => Messages_Pinned._();
  @$core.override
  Messages_Pinned createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_Pinned getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_Pinned>(create);
  static Messages_Pinned? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);
}

class Messages_PinnedResult extends $pb.GeneratedMessage {
  factory Messages_PinnedResult({
    $core.Iterable<ChatMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  Messages_PinnedResult._();

  factory Messages_PinnedResult.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_PinnedResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.PinnedResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PinnedResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_PinnedResult copyWith(void Function(Messages_PinnedResult) updates) =>
      super.copyWith((message) => updates(message as Messages_PinnedResult)) as Messages_PinnedResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_PinnedResult create() => Messages_PinnedResult._();
  @$core.override
  Messages_PinnedResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_PinnedResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_PinnedResult>(create);
  static Messages_PinnedResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessage> get messages => $_getList(0);
}

/// Мои реакции на сообщение — весь набор целиком (как sendReaction в
/// Telegram): пусто — снять все. Порядок — порядок постановки; не больше
/// трёх разных, только из разрешённых в чате (личный чат — фиксированный
/// набор). Новые нельзя, если собеседник ограничил, кто может ему писать
/// (PERMISSION_DENIED «privacyRestricted»); снять свои можно всегда.
/// Служебные сообщения реакций не принимают.
class Messages_SetReactions extends $pb.GeneratedMessage {
  factory Messages_SetReactions({
    $core.List<$core.int>? chatID,
    $fixnum.Int64? messageID,
    $core.Iterable<$core.String>? emojis,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageID != null) result.messageID = messageID;
    if (emojis != null) result.emojis.addAll(emojis);
    return result;
  }

  Messages_SetReactions._();

  factory Messages_SetReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SetReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SetReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aInt64(2, _omitFieldNames ? '' : 'messageID', protoName: 'messageID')
    ..pPS(3, _omitFieldNames ? '' : 'emojis')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SetReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SetReactions copyWith(void Function(Messages_SetReactions) updates) =>
      super.copyWith((message) => updates(message as Messages_SetReactions)) as Messages_SetReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SetReactions create() => Messages_SetReactions._();
  @$core.override
  Messages_SetReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SetReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SetReactions>(create);
  static Messages_SetReactions? _defaultInstance;

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
  $pb.PbList<$core.String> get emojis => $_getList(2);
}

class Messages_SetReactionsResult extends $pb.GeneratedMessage {
  factory Messages_SetReactionsResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_SetReactionsResult._();

  factory Messages_SetReactionsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_SetReactionsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.SetReactionsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SetReactionsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_SetReactionsResult copyWith(void Function(Messages_SetReactionsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_SetReactionsResult)) as Messages_SetReactionsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_SetReactionsResult create() => Messages_SetReactionsResult._();
  @$core.override
  Messages_SetReactionsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_SetReactionsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_SetReactionsResult>(create);
  static Messages_SetReactionsResult? _defaultInstance;

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

/// Реакции на мои сообщения просмотрены (как readReactions в Telegram):
/// messageIDs — показанные на экране, пусто — все в чате.
class Messages_ReadReactions extends $pb.GeneratedMessage {
  factory Messages_ReadReactions({
    $core.List<$core.int>? chatID,
    $core.Iterable<$fixnum.Int64>? messageIDs,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (messageIDs != null) result.messageIDs.addAll(messageIDs);
    return result;
  }

  Messages_ReadReactions._();

  factory Messages_ReadReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..p<$fixnum.Int64>(2, _omitFieldNames ? '' : 'messageIDs', $pb.PbFieldType.K6, protoName: 'messageIDs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadReactions copyWith(void Function(Messages_ReadReactions) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadReactions)) as Messages_ReadReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadReactions create() => Messages_ReadReactions._();
  @$core.override
  Messages_ReadReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadReactions>(create);
  static Messages_ReadReactions? _defaultInstance;

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

class Messages_ReadReactionsResult extends $pb.GeneratedMessage {
  factory Messages_ReadReactionsResult({
    Updates? updates,
  }) {
    final result = create();
    if (updates != null) result.updates = updates;
    return result;
  }

  Messages_ReadReactionsResult._();

  factory Messages_ReadReactionsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_ReadReactionsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.ReadReactionsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aOM<Updates>(1, _omitFieldNames ? '' : 'updates', subBuilder: Updates.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadReactionsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_ReadReactionsResult copyWith(void Function(Messages_ReadReactionsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_ReadReactionsResult)) as Messages_ReadReactionsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_ReadReactionsResult create() => Messages_ReadReactionsResult._();
  @$core.override
  Messages_ReadReactionsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_ReadReactionsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_ReadReactionsResult>(create);
  static Messages_ReadReactionsResult? _defaultInstance;

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

/// Мои сообщения с непрочитанными реакциями, от старых к новым (как
/// getUnreadReactions в Telegram) — куда вести кнопку ❤️ в окне чата.
class Messages_UnreadReactions extends $pb.GeneratedMessage {
  factory Messages_UnreadReactions({
    $core.List<$core.int>? chatID,
    $core.int? limit,
  }) {
    final result = create();
    if (chatID != null) result.chatID = chatID;
    if (limit != null) result.limit = limit;
    return result;
  }

  Messages_UnreadReactions._();

  factory Messages_UnreadReactions.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnreadReactions.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnreadReactions',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chatID', $pb.PbFieldType.OY, protoName: 'chatID')
    ..aI(2, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadReactions clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadReactions copyWith(void Function(Messages_UnreadReactions) updates) =>
      super.copyWith((message) => updates(message as Messages_UnreadReactions)) as Messages_UnreadReactions;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnreadReactions create() => Messages_UnreadReactions._();
  @$core.override
  Messages_UnreadReactions createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnreadReactions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnreadReactions>(create);
  static Messages_UnreadReactions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chatID => $_getN(0);
  @$pb.TagNumber(1)
  set chatID($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChatID() => $_has(0);
  @$pb.TagNumber(1)
  void clearChatID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class Messages_UnreadReactionsResult extends $pb.GeneratedMessage {
  factory Messages_UnreadReactionsResult({
    $core.Iterable<ChatMessage>? messages,
  }) {
    final result = create();
    if (messages != null) result.messages.addAll(messages);
    return result;
  }

  Messages_UnreadReactionsResult._();

  factory Messages_UnreadReactionsResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Messages_UnreadReactionsResult.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.UnreadReactionsResult',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..pPM<ChatMessage>(1, _omitFieldNames ? '' : 'messages', subBuilder: ChatMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadReactionsResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Messages_UnreadReactionsResult copyWith(void Function(Messages_UnreadReactionsResult) updates) =>
      super.copyWith((message) => updates(message as Messages_UnreadReactionsResult)) as Messages_UnreadReactionsResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Messages_UnreadReactionsResult create() => Messages_UnreadReactionsResult._();
  @$core.override
  Messages_UnreadReactionsResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Messages_UnreadReactionsResult getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Messages_UnreadReactionsResult>(create);
  static Messages_UnreadReactionsResult? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ChatMessage> get messages => $_getList(0);
}

enum Messages_Request_Request {
  history,
  send,
  edit,
  delete,
  readContents,
  pin,
  unpinAll,
  pinned,
  setReactions,
  readReactions,
  unreadReactions,
  scheduled,
  sendScheduledNow,
  reschedule,
  deleteScheduled,
  notSet
}

class Messages_Request extends $pb.GeneratedMessage {
  factory Messages_Request({
    Messages_History? history,
    Messages_Send? send,
    Messages_Edit? edit,
    Messages_Delete? delete,
    Messages_ReadContents? readContents,
    Messages_Pin? pin,
    Messages_UnpinAll? unpinAll,
    Messages_Pinned? pinned,
    Messages_SetReactions? setReactions,
    Messages_ReadReactions? readReactions,
    Messages_UnreadReactions? unreadReactions,
    Messages_Scheduled? scheduled,
    Messages_SendScheduledNow? sendScheduledNow,
    Messages_Reschedule? reschedule,
    Messages_DeleteScheduled? deleteScheduled,
  }) {
    final result = create();
    if (history != null) result.history = history;
    if (send != null) result.send = send;
    if (edit != null) result.edit = edit;
    if (delete != null) result.delete = delete;
    if (readContents != null) result.readContents = readContents;
    if (pin != null) result.pin = pin;
    if (unpinAll != null) result.unpinAll = unpinAll;
    if (pinned != null) result.pinned = pinned;
    if (setReactions != null) result.setReactions = setReactions;
    if (readReactions != null) result.readReactions = readReactions;
    if (unreadReactions != null) result.unreadReactions = unreadReactions;
    if (scheduled != null) result.scheduled = scheduled;
    if (sendScheduledNow != null) result.sendScheduledNow = sendScheduledNow;
    if (reschedule != null) result.reschedule = reschedule;
    if (deleteScheduled != null) result.deleteScheduled = deleteScheduled;
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
    6: Messages_Request_Request.pin,
    7: Messages_Request_Request.unpinAll,
    8: Messages_Request_Request.pinned,
    9: Messages_Request_Request.setReactions,
    10: Messages_Request_Request.readReactions,
    11: Messages_Request_Request.unreadReactions,
    12: Messages_Request_Request.scheduled,
    13: Messages_Request_Request.sendScheduledNow,
    14: Messages_Request_Request.reschedule,
    15: Messages_Request_Request.deleteScheduled,
    0: Messages_Request_Request.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
    ..aOM<Messages_History>(1, _omitFieldNames ? '' : 'history', subBuilder: Messages_History.create)
    ..aOM<Messages_Send>(2, _omitFieldNames ? '' : 'send', subBuilder: Messages_Send.create)
    ..aOM<Messages_Edit>(3, _omitFieldNames ? '' : 'edit', subBuilder: Messages_Edit.create)
    ..aOM<Messages_Delete>(4, _omitFieldNames ? '' : 'delete', subBuilder: Messages_Delete.create)
    ..aOM<Messages_ReadContents>(5, _omitFieldNames ? '' : 'readContents',
        protoName: 'readContents', subBuilder: Messages_ReadContents.create)
    ..aOM<Messages_Pin>(6, _omitFieldNames ? '' : 'pin', subBuilder: Messages_Pin.create)
    ..aOM<Messages_UnpinAll>(7, _omitFieldNames ? '' : 'unpinAll', protoName: 'unpinAll', subBuilder: Messages_UnpinAll.create)
    ..aOM<Messages_Pinned>(8, _omitFieldNames ? '' : 'pinned', subBuilder: Messages_Pinned.create)
    ..aOM<Messages_SetReactions>(9, _omitFieldNames ? '' : 'setReactions',
        protoName: 'setReactions', subBuilder: Messages_SetReactions.create)
    ..aOM<Messages_ReadReactions>(10, _omitFieldNames ? '' : 'readReactions',
        protoName: 'readReactions', subBuilder: Messages_ReadReactions.create)
    ..aOM<Messages_UnreadReactions>(11, _omitFieldNames ? '' : 'unreadReactions',
        protoName: 'unreadReactions', subBuilder: Messages_UnreadReactions.create)
    ..aOM<Messages_Scheduled>(12, _omitFieldNames ? '' : 'scheduled', subBuilder: Messages_Scheduled.create)
    ..aOM<Messages_SendScheduledNow>(13, _omitFieldNames ? '' : 'sendScheduledNow',
        protoName: 'sendScheduledNow', subBuilder: Messages_SendScheduledNow.create)
    ..aOM<Messages_Reschedule>(14, _omitFieldNames ? '' : 'reschedule', subBuilder: Messages_Reschedule.create)
    ..aOM<Messages_DeleteScheduled>(15, _omitFieldNames ? '' : 'deleteScheduled',
        protoName: 'deleteScheduled', subBuilder: Messages_DeleteScheduled.create)
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
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  Messages_Request_Request whichRequest() => _Messages_Request_RequestByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
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

  @$pb.TagNumber(6)
  Messages_Pin get pin => $_getN(5);
  @$pb.TagNumber(6)
  set pin(Messages_Pin value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPin() => $_has(5);
  @$pb.TagNumber(6)
  void clearPin() => $_clearField(6);
  @$pb.TagNumber(6)
  Messages_Pin ensurePin() => $_ensure(5);

  @$pb.TagNumber(7)
  Messages_UnpinAll get unpinAll => $_getN(6);
  @$pb.TagNumber(7)
  set unpinAll(Messages_UnpinAll value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUnpinAll() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnpinAll() => $_clearField(7);
  @$pb.TagNumber(7)
  Messages_UnpinAll ensureUnpinAll() => $_ensure(6);

  @$pb.TagNumber(8)
  Messages_Pinned get pinned => $_getN(7);
  @$pb.TagNumber(8)
  set pinned(Messages_Pinned value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPinned() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinned() => $_clearField(8);
  @$pb.TagNumber(8)
  Messages_Pinned ensurePinned() => $_ensure(7);

  @$pb.TagNumber(9)
  Messages_SetReactions get setReactions => $_getN(8);
  @$pb.TagNumber(9)
  set setReactions(Messages_SetReactions value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSetReactions() => $_has(8);
  @$pb.TagNumber(9)
  void clearSetReactions() => $_clearField(9);
  @$pb.TagNumber(9)
  Messages_SetReactions ensureSetReactions() => $_ensure(8);

  @$pb.TagNumber(10)
  Messages_ReadReactions get readReactions => $_getN(9);
  @$pb.TagNumber(10)
  set readReactions(Messages_ReadReactions value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReadReactions() => $_has(9);
  @$pb.TagNumber(10)
  void clearReadReactions() => $_clearField(10);
  @$pb.TagNumber(10)
  Messages_ReadReactions ensureReadReactions() => $_ensure(9);

  @$pb.TagNumber(11)
  Messages_UnreadReactions get unreadReactions => $_getN(10);
  @$pb.TagNumber(11)
  set unreadReactions(Messages_UnreadReactions value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUnreadReactions() => $_has(10);
  @$pb.TagNumber(11)
  void clearUnreadReactions() => $_clearField(11);
  @$pb.TagNumber(11)
  Messages_UnreadReactions ensureUnreadReactions() => $_ensure(10);

  @$pb.TagNumber(12)
  Messages_Scheduled get scheduled => $_getN(11);
  @$pb.TagNumber(12)
  set scheduled(Messages_Scheduled value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasScheduled() => $_has(11);
  @$pb.TagNumber(12)
  void clearScheduled() => $_clearField(12);
  @$pb.TagNumber(12)
  Messages_Scheduled ensureScheduled() => $_ensure(11);

  @$pb.TagNumber(13)
  Messages_SendScheduledNow get sendScheduledNow => $_getN(12);
  @$pb.TagNumber(13)
  set sendScheduledNow(Messages_SendScheduledNow value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSendScheduledNow() => $_has(12);
  @$pb.TagNumber(13)
  void clearSendScheduledNow() => $_clearField(13);
  @$pb.TagNumber(13)
  Messages_SendScheduledNow ensureSendScheduledNow() => $_ensure(12);

  @$pb.TagNumber(14)
  Messages_Reschedule get reschedule => $_getN(13);
  @$pb.TagNumber(14)
  set reschedule(Messages_Reschedule value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReschedule() => $_has(13);
  @$pb.TagNumber(14)
  void clearReschedule() => $_clearField(14);
  @$pb.TagNumber(14)
  Messages_Reschedule ensureReschedule() => $_ensure(13);

  @$pb.TagNumber(15)
  Messages_DeleteScheduled get deleteScheduled => $_getN(14);
  @$pb.TagNumber(15)
  set deleteScheduled(Messages_DeleteScheduled value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasDeleteScheduled() => $_has(14);
  @$pb.TagNumber(15)
  void clearDeleteScheduled() => $_clearField(15);
  @$pb.TagNumber(15)
  Messages_DeleteScheduled ensureDeleteScheduled() => $_ensure(14);
}

enum Messages_Response_Response {
  history,
  send,
  edit,
  delete,
  readContents,
  pin,
  unpinAll,
  pinned,
  setReactions,
  readReactions,
  unreadReactions,
  scheduled,
  sendScheduledNow,
  reschedule,
  deleteScheduled,
  notSet
}

class Messages_Response extends $pb.GeneratedMessage {
  factory Messages_Response({
    Messages_HistoryResult? history,
    Messages_SendResult? send,
    Messages_EditResult? edit,
    Messages_DeleteResult? delete,
    Messages_ReadContentsResult? readContents,
    Messages_PinResult? pin,
    Messages_UnpinAllResult? unpinAll,
    Messages_PinnedResult? pinned,
    Messages_SetReactionsResult? setReactions,
    Messages_ReadReactionsResult? readReactions,
    Messages_UnreadReactionsResult? unreadReactions,
    Messages_ScheduledResult? scheduled,
    Messages_SendScheduledNowResult? sendScheduledNow,
    Messages_RescheduleResult? reschedule,
    Messages_DeleteScheduledResult? deleteScheduled,
  }) {
    final result = create();
    if (history != null) result.history = history;
    if (send != null) result.send = send;
    if (edit != null) result.edit = edit;
    if (delete != null) result.delete = delete;
    if (readContents != null) result.readContents = readContents;
    if (pin != null) result.pin = pin;
    if (unpinAll != null) result.unpinAll = unpinAll;
    if (pinned != null) result.pinned = pinned;
    if (setReactions != null) result.setReactions = setReactions;
    if (readReactions != null) result.readReactions = readReactions;
    if (unreadReactions != null) result.unreadReactions = unreadReactions;
    if (scheduled != null) result.scheduled = scheduled;
    if (sendScheduledNow != null) result.sendScheduledNow = sendScheduledNow;
    if (reschedule != null) result.reschedule = reschedule;
    if (deleteScheduled != null) result.deleteScheduled = deleteScheduled;
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
    6: Messages_Response_Response.pin,
    7: Messages_Response_Response.unpinAll,
    8: Messages_Response_Response.pinned,
    9: Messages_Response_Response.setReactions,
    10: Messages_Response_Response.readReactions,
    11: Messages_Response_Response.unreadReactions,
    12: Messages_Response_Response.scheduled,
    13: Messages_Response_Response.sendScheduledNow,
    14: Messages_Response_Response.reschedule,
    15: Messages_Response_Response.deleteScheduled,
    0: Messages_Response_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Messages.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])
    ..aOM<Messages_HistoryResult>(1, _omitFieldNames ? '' : 'history', subBuilder: Messages_HistoryResult.create)
    ..aOM<Messages_SendResult>(2, _omitFieldNames ? '' : 'send', subBuilder: Messages_SendResult.create)
    ..aOM<Messages_EditResult>(3, _omitFieldNames ? '' : 'edit', subBuilder: Messages_EditResult.create)
    ..aOM<Messages_DeleteResult>(4, _omitFieldNames ? '' : 'delete', subBuilder: Messages_DeleteResult.create)
    ..aOM<Messages_ReadContentsResult>(5, _omitFieldNames ? '' : 'readContents',
        protoName: 'readContents', subBuilder: Messages_ReadContentsResult.create)
    ..aOM<Messages_PinResult>(6, _omitFieldNames ? '' : 'pin', subBuilder: Messages_PinResult.create)
    ..aOM<Messages_UnpinAllResult>(7, _omitFieldNames ? '' : 'unpinAll', protoName: 'unpinAll', subBuilder: Messages_UnpinAllResult.create)
    ..aOM<Messages_PinnedResult>(8, _omitFieldNames ? '' : 'pinned', subBuilder: Messages_PinnedResult.create)
    ..aOM<Messages_SetReactionsResult>(9, _omitFieldNames ? '' : 'setReactions',
        protoName: 'setReactions', subBuilder: Messages_SetReactionsResult.create)
    ..aOM<Messages_ReadReactionsResult>(10, _omitFieldNames ? '' : 'readReactions',
        protoName: 'readReactions', subBuilder: Messages_ReadReactionsResult.create)
    ..aOM<Messages_UnreadReactionsResult>(11, _omitFieldNames ? '' : 'unreadReactions',
        protoName: 'unreadReactions', subBuilder: Messages_UnreadReactionsResult.create)
    ..aOM<Messages_ScheduledResult>(12, _omitFieldNames ? '' : 'scheduled', subBuilder: Messages_ScheduledResult.create)
    ..aOM<Messages_SendScheduledNowResult>(13, _omitFieldNames ? '' : 'sendScheduledNow',
        protoName: 'sendScheduledNow', subBuilder: Messages_SendScheduledNowResult.create)
    ..aOM<Messages_RescheduleResult>(14, _omitFieldNames ? '' : 'reschedule', subBuilder: Messages_RescheduleResult.create)
    ..aOM<Messages_DeleteScheduledResult>(15, _omitFieldNames ? '' : 'deleteScheduled',
        protoName: 'deleteScheduled', subBuilder: Messages_DeleteScheduledResult.create)
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
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  Messages_Response_Response whichResponse() => _Messages_Response_ResponseByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
  @$pb.TagNumber(6)
  @$pb.TagNumber(7)
  @$pb.TagNumber(8)
  @$pb.TagNumber(9)
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
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

  @$pb.TagNumber(6)
  Messages_PinResult get pin => $_getN(5);
  @$pb.TagNumber(6)
  set pin(Messages_PinResult value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPin() => $_has(5);
  @$pb.TagNumber(6)
  void clearPin() => $_clearField(6);
  @$pb.TagNumber(6)
  Messages_PinResult ensurePin() => $_ensure(5);

  @$pb.TagNumber(7)
  Messages_UnpinAllResult get unpinAll => $_getN(6);
  @$pb.TagNumber(7)
  set unpinAll(Messages_UnpinAllResult value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUnpinAll() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnpinAll() => $_clearField(7);
  @$pb.TagNumber(7)
  Messages_UnpinAllResult ensureUnpinAll() => $_ensure(6);

  @$pb.TagNumber(8)
  Messages_PinnedResult get pinned => $_getN(7);
  @$pb.TagNumber(8)
  set pinned(Messages_PinnedResult value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPinned() => $_has(7);
  @$pb.TagNumber(8)
  void clearPinned() => $_clearField(8);
  @$pb.TagNumber(8)
  Messages_PinnedResult ensurePinned() => $_ensure(7);

  @$pb.TagNumber(9)
  Messages_SetReactionsResult get setReactions => $_getN(8);
  @$pb.TagNumber(9)
  set setReactions(Messages_SetReactionsResult value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSetReactions() => $_has(8);
  @$pb.TagNumber(9)
  void clearSetReactions() => $_clearField(9);
  @$pb.TagNumber(9)
  Messages_SetReactionsResult ensureSetReactions() => $_ensure(8);

  @$pb.TagNumber(10)
  Messages_ReadReactionsResult get readReactions => $_getN(9);
  @$pb.TagNumber(10)
  set readReactions(Messages_ReadReactionsResult value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReadReactions() => $_has(9);
  @$pb.TagNumber(10)
  void clearReadReactions() => $_clearField(10);
  @$pb.TagNumber(10)
  Messages_ReadReactionsResult ensureReadReactions() => $_ensure(9);

  @$pb.TagNumber(11)
  Messages_UnreadReactionsResult get unreadReactions => $_getN(10);
  @$pb.TagNumber(11)
  set unreadReactions(Messages_UnreadReactionsResult value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUnreadReactions() => $_has(10);
  @$pb.TagNumber(11)
  void clearUnreadReactions() => $_clearField(11);
  @$pb.TagNumber(11)
  Messages_UnreadReactionsResult ensureUnreadReactions() => $_ensure(10);

  @$pb.TagNumber(12)
  Messages_ScheduledResult get scheduled => $_getN(11);
  @$pb.TagNumber(12)
  set scheduled(Messages_ScheduledResult value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasScheduled() => $_has(11);
  @$pb.TagNumber(12)
  void clearScheduled() => $_clearField(12);
  @$pb.TagNumber(12)
  Messages_ScheduledResult ensureScheduled() => $_ensure(11);

  @$pb.TagNumber(13)
  Messages_SendScheduledNowResult get sendScheduledNow => $_getN(12);
  @$pb.TagNumber(13)
  set sendScheduledNow(Messages_SendScheduledNowResult value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSendScheduledNow() => $_has(12);
  @$pb.TagNumber(13)
  void clearSendScheduledNow() => $_clearField(13);
  @$pb.TagNumber(13)
  Messages_SendScheduledNowResult ensureSendScheduledNow() => $_ensure(12);

  @$pb.TagNumber(14)
  Messages_RescheduleResult get reschedule => $_getN(13);
  @$pb.TagNumber(14)
  set reschedule(Messages_RescheduleResult value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReschedule() => $_has(13);
  @$pb.TagNumber(14)
  void clearReschedule() => $_clearField(14);
  @$pb.TagNumber(14)
  Messages_RescheduleResult ensureReschedule() => $_ensure(13);

  @$pb.TagNumber(15)
  Messages_DeleteScheduledResult get deleteScheduled => $_getN(14);
  @$pb.TagNumber(15)
  set deleteScheduled(Messages_DeleteScheduledResult value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasDeleteScheduled() => $_has(14);
  @$pb.TagNumber(15)
  void clearDeleteScheduled() => $_clearField(15);
  @$pb.TagNumber(15)
  Messages_DeleteScheduledResult ensureDeleteScheduled() => $_ensure(14);
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
