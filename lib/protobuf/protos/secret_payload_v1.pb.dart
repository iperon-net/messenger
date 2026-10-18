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

import 'secret_payload_v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'secret_payload_v1.pbenum.dart';

enum SecretPayload_Payload { text, read, delete, media, notSet }

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
    SecretMedia? media,
  }) {
    final result = create();
    if (layer != null) result.layer = layer;
    if (text != null) result.text = text;
    if (read != null) result.read = read;
    if (delete != null) result.delete = delete;
    if (media != null) result.media = media;
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
    5: SecretPayload_Payload.media,
    0: SecretPayload_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretPayload',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..aI(1, _omitFieldNames ? '' : 'layer')
    ..aOM<SecretText>(2, _omitFieldNames ? '' : 'text', subBuilder: SecretText.create)
    ..aOM<SecretRead>(3, _omitFieldNames ? '' : 'read', subBuilder: SecretRead.create)
    ..aOM<SecretDelete>(4, _omitFieldNames ? '' : 'delete', subBuilder: SecretDelete.create)
    ..aOM<SecretMedia>(5, _omitFieldNames ? '' : 'media', subBuilder: SecretMedia.create)
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
  @$pb.TagNumber(5)
  SecretPayload_Payload whichPayload() => _SecretPayload_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  @$pb.TagNumber(4)
  @$pb.TagNumber(5)
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

  @$pb.TagNumber(5)
  SecretMedia get media => $_getN(4);
  @$pb.TagNumber(5)
  set media(SecretMedia value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMedia() => $_has(4);
  @$pb.TagNumber(5)
  void clearMedia() => $_clearField(5);
  @$pb.TagNumber(5)
  SecretMedia ensureMedia() => $_ensure(4);
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

/// Фото / видео / файл (layer 2). Сам файл зашифрован ключом key (как вложения
/// обычных чатов, FileEncryptor) и загружен непрозрачно (UploadConfirm.opaque);
/// fileID уходит и открыто в SecretChats.Send.fileIDs — чтобы сервер выдал
/// получателю ссылку (SecretChats.GetFiles). Ключ, соль и хеш шифротекста —
/// только здесь. randomID — в SecretChats.Send.
class SecretMedia extends $pb.GeneratedMessage {
  factory SecretMedia({
    SecretMedia_Kind? kind,
    $core.List<$core.int>? fileID,
    $core.List<$core.int>? key,
    $core.List<$core.int>? hkdfSalt,
    $core.List<$core.int>? sha256,
    $fixnum.Int64? size,
    $core.String? mimeType,
    $core.String? fileName,
    $core.int? width,
    $core.int? height,
    $core.int? duration,
    $core.String? thumbhash,
    $core.List<$core.int>? thumb,
    $core.bool? spoiler,
    $core.List<$core.int>? waveform,
    $core.String? caption,
    $fixnum.Int64? replyToRandomID,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (fileID != null) result.fileID = fileID;
    if (key != null) result.key = key;
    if (hkdfSalt != null) result.hkdfSalt = hkdfSalt;
    if (sha256 != null) result.sha256 = sha256;
    if (size != null) result.size = size;
    if (mimeType != null) result.mimeType = mimeType;
    if (fileName != null) result.fileName = fileName;
    if (width != null) result.width = width;
    if (height != null) result.height = height;
    if (duration != null) result.duration = duration;
    if (thumbhash != null) result.thumbhash = thumbhash;
    if (thumb != null) result.thumb = thumb;
    if (spoiler != null) result.spoiler = spoiler;
    if (waveform != null) result.waveform = waveform;
    if (caption != null) result.caption = caption;
    if (replyToRandomID != null) result.replyToRandomID = replyToRandomID;
    return result;
  }

  SecretMedia._();

  factory SecretMedia.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SecretMedia.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecretMedia',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'iperon.v1'), createEmptyInstance: create)
    ..aE<SecretMedia_Kind>(1, _omitFieldNames ? '' : 'kind', enumValues: SecretMedia_Kind.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'fileID', $pb.PbFieldType.OY, protoName: 'fileID')
    ..a<$core.List<$core.int>>(3, _omitFieldNames ? '' : 'key', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(4, _omitFieldNames ? '' : 'hkdfSalt', $pb.PbFieldType.OY, protoName: 'hkdfSalt')
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'sha256', $pb.PbFieldType.OY)
    ..aInt64(6, _omitFieldNames ? '' : 'size')
    ..aOS(7, _omitFieldNames ? '' : 'mimeType', protoName: 'mimeType')
    ..aOS(8, _omitFieldNames ? '' : 'fileName', protoName: 'fileName')
    ..aI(9, _omitFieldNames ? '' : 'width')
    ..aI(10, _omitFieldNames ? '' : 'height')
    ..aI(11, _omitFieldNames ? '' : 'duration')
    ..aOS(12, _omitFieldNames ? '' : 'thumbhash')
    ..a<$core.List<$core.int>>(13, _omitFieldNames ? '' : 'thumb', $pb.PbFieldType.OY)
    ..aOB(14, _omitFieldNames ? '' : 'spoiler')
    ..a<$core.List<$core.int>>(15, _omitFieldNames ? '' : 'waveform', $pb.PbFieldType.OY)
    ..aOS(16, _omitFieldNames ? '' : 'caption')
    ..aInt64(17, _omitFieldNames ? '' : 'replyToRandomID', protoName: 'replyToRandomID')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretMedia clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SecretMedia copyWith(void Function(SecretMedia) updates) => super.copyWith((message) => updates(message as SecretMedia)) as SecretMedia;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecretMedia create() => SecretMedia._();
  @$core.override
  SecretMedia createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SecretMedia getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecretMedia>(create);
  static SecretMedia? _defaultInstance;

  @$pb.TagNumber(1)
  SecretMedia_Kind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(SecretMedia_Kind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get fileID => $_getN(1);
  @$pb.TagNumber(2)
  set fileID($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileID() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileID() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get key => $_getN(2);
  @$pb.TagNumber(3)
  set key($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get hkdfSalt => $_getN(3);
  @$pb.TagNumber(4)
  set hkdfSalt($core.List<$core.int> value) => $_setBytes(3, value);
  @$pb.TagNumber(4)
  $core.bool hasHkdfSalt() => $_has(3);
  @$pb.TagNumber(4)
  void clearHkdfSalt() => $_clearField(4);

  /// sha256 шифротекста — проверка после скачивания.
  @$pb.TagNumber(5)
  $core.List<$core.int> get sha256 => $_getN(4);
  @$pb.TagNumber(5)
  set sha256($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSha256() => $_has(4);
  @$pb.TagNumber(5)
  void clearSha256() => $_clearField(5);

  /// Размер исходного файла, байт.
  @$pb.TagNumber(6)
  $fixnum.Int64 get size => $_getI64(5);
  @$pb.TagNumber(6)
  set size($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get mimeType => $_getSZ(6);
  @$pb.TagNumber(7)
  set mimeType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMimeType() => $_has(6);
  @$pb.TagNumber(7)
  void clearMimeType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fileName => $_getSZ(7);
  @$pb.TagNumber(8)
  set fileName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFileName() => $_has(7);
  @$pb.TagNumber(8)
  void clearFileName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get width => $_getIZ(8);
  @$pb.TagNumber(9)
  set width($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasWidth() => $_has(8);
  @$pb.TagNumber(9)
  void clearWidth() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get height => $_getIZ(9);
  @$pb.TagNumber(10)
  set height($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHeight() => $_has(9);
  @$pb.TagNumber(10)
  void clearHeight() => $_clearField(10);

  /// Видео / голосовое — секунд.
  @$pb.TagNumber(11)
  $core.int get duration => $_getIZ(10);
  @$pb.TagNumber(11)
  set duration($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDuration() => $_has(10);
  @$pb.TagNumber(11)
  void clearDuration() => $_clearField(11);

  /// Размытое превью до скачивания (ThumbHash, base64).
  @$pb.TagNumber(12)
  $core.String get thumbhash => $_getSZ(11);
  @$pb.TagNumber(12)
  set thumbhash($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasThumbhash() => $_has(11);
  @$pb.TagNumber(12)
  void clearThumbhash() => $_clearField(12);

  /// Видео — маленький кадр-обложка (JPEG) прямо в конверте (без отдельного
  /// файла); пусто — только thumbhash.
  @$pb.TagNumber(13)
  $core.List<$core.int> get thumb => $_getN(12);
  @$pb.TagNumber(13)
  set thumb($core.List<$core.int> value) => $_setBytes(12, value);
  @$pb.TagNumber(13)
  $core.bool hasThumb() => $_has(12);
  @$pb.TagNumber(13)
  void clearThumb() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get spoiler => $_getBF(13);
  @$pb.TagNumber(14)
  set spoiler($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasSpoiler() => $_has(13);
  @$pb.TagNumber(14)
  void clearSpoiler() => $_clearField(14);

  /// Голосовое — уровни громкости (0..255).
  @$pb.TagNumber(15)
  $core.List<$core.int> get waveform => $_getN(14);
  @$pb.TagNumber(15)
  set waveform($core.List<$core.int> value) => $_setBytes(14, value);
  @$pb.TagNumber(15)
  $core.bool hasWaveform() => $_has(14);
  @$pb.TagNumber(15)
  void clearWaveform() => $_clearField(15);

  /// Подпись.
  @$pb.TagNumber(16)
  $core.String get caption => $_getSZ(15);
  @$pb.TagNumber(16)
  set caption($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCaption() => $_has(15);
  @$pb.TagNumber(16)
  void clearCaption() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get replyToRandomID => $_getI64(16);
  @$pb.TagNumber(17)
  set replyToRandomID($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasReplyToRandomID() => $_has(16);
  @$pb.TagNumber(17)
  void clearReplyToRandomID() => $_clearField(17);
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
