// This is a generated file - do not edit.
//
// Generated from protos/v1.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart' as $1;

import 'v1.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'v1.pbenum.dart';

/// Messages
class Message extends $pb.GeneratedMessage {
  factory Message({
    MessageType? messageType,
    $core.List<$core.int>? message,
    $1.Timestamp? currentAt,
  }) {
    final result = create();
    if (messageType != null) result.messageType = messageType;
    if (message != null) result.message = message;
    if (currentAt != null) result.currentAt = currentAt;
    return result;
  }

  Message._();

  factory Message.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Message.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Message',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..aE<MessageType>(1, _omitFieldNames ? '' : 'messageType', protoName: 'messageType', enumValues: MessageType.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'message', $pb.PbFieldType.OY)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'currentAt', protoName: 'currentAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message)) as Message;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  @$core.override
  Message createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  @$pb.TagNumber(1)
  MessageType get messageType => $_getN(0);
  @$pb.TagNumber(1)
  set messageType(MessageType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMessageType() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get message => $_getN(1);
  @$pb.TagNumber(2)
  set message($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get currentAt => $_getN(2);
  @$pb.TagNumber(3)
  set currentAt($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrentAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrentAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureCurrentAt() => $_ensure(2);
}

class Upload_Init extends $pb.GeneratedMessage {
  factory Upload_Init({
    $core.String? sessionId,
    $fixnum.Int64? fileSize,
    $core.String? resumeUploadId,
  }) {
    final result = create();
    if (sessionId != null) result.sessionId = sessionId;
    if (fileSize != null) result.fileSize = fileSize;
    if (resumeUploadId != null) result.resumeUploadId = resumeUploadId;
    return result;
  }

  Upload_Init._();

  factory Upload_Init.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload_Init.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload.Init',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionId', protoName: 'sessionId')
    ..aInt64(2, _omitFieldNames ? '' : 'fileSize', protoName: 'fileSize')
    ..aOS(3, _omitFieldNames ? '' : 'resumeUploadId', protoName: 'resumeUploadId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Init clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Init copyWith(void Function(Upload_Init) updates) => super.copyWith((message) => updates(message as Upload_Init)) as Upload_Init;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload_Init create() => Upload_Init._();
  @$core.override
  Upload_Init createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload_Init getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload_Init>(create);
  static Upload_Init? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fileSize => $_getI64(1);
  @$pb.TagNumber(2)
  set fileSize($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resumeUploadId => $_getSZ(2);
  @$pb.TagNumber(3)
  set resumeUploadId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResumeUploadId() => $_has(2);
  @$pb.TagNumber(3)
  void clearResumeUploadId() => $_clearField(3);
}

class Upload_Chunk extends $pb.GeneratedMessage {
  factory Upload_Chunk({
    $core.List<$core.int>? data,
  }) {
    final result = create();
    if (data != null) result.data = data;
    return result;
  }

  Upload_Chunk._();

  factory Upload_Chunk.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload_Chunk.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload.Chunk',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Chunk clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Chunk copyWith(void Function(Upload_Chunk) updates) =>
      super.copyWith((message) => updates(message as Upload_Chunk)) as Upload_Chunk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload_Chunk create() => Upload_Chunk._();
  @$core.override
  Upload_Chunk createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload_Chunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload_Chunk>(create);
  static Upload_Chunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);
}

class Upload_Done extends $pb.GeneratedMessage {
  factory Upload_Done() => create();

  Upload_Done._();

  factory Upload_Done.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload_Done.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload.Done',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Done clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Done copyWith(void Function(Upload_Done) updates) => super.copyWith((message) => updates(message as Upload_Done)) as Upload_Done;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload_Done create() => Upload_Done._();
  @$core.override
  Upload_Done createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload_Done getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload_Done>(create);
  static Upload_Done? _defaultInstance;
}

class Upload_InitAck extends $pb.GeneratedMessage {
  factory Upload_InitAck({
    $core.String? uploadId,
    $fixnum.Int64? receivedBytes,
  }) {
    final result = create();
    if (uploadId != null) result.uploadId = uploadId;
    if (receivedBytes != null) result.receivedBytes = receivedBytes;
    return result;
  }

  Upload_InitAck._();

  factory Upload_InitAck.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload_InitAck.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload.InitAck',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadId', protoName: 'uploadId')
    ..aInt64(2, _omitFieldNames ? '' : 'receivedBytes', protoName: 'receivedBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_InitAck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_InitAck copyWith(void Function(Upload_InitAck) updates) =>
      super.copyWith((message) => updates(message as Upload_InitAck)) as Upload_InitAck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload_InitAck create() => Upload_InitAck._();
  @$core.override
  Upload_InitAck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload_InitAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload_InitAck>(create);
  static Upload_InitAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUploadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receivedBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set receivedBytes($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceivedBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceivedBytes() => $_clearField(2);
}

class Upload_ChunkAck extends $pb.GeneratedMessage {
  factory Upload_ChunkAck({
    $fixnum.Int64? receivedBytes,
  }) {
    final result = create();
    if (receivedBytes != null) result.receivedBytes = receivedBytes;
    return result;
  }

  Upload_ChunkAck._();

  factory Upload_ChunkAck.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload_ChunkAck.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload.ChunkAck',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'receivedBytes', protoName: 'receivedBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_ChunkAck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_ChunkAck copyWith(void Function(Upload_ChunkAck) updates) =>
      super.copyWith((message) => updates(message as Upload_ChunkAck)) as Upload_ChunkAck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload_ChunkAck create() => Upload_ChunkAck._();
  @$core.override
  Upload_ChunkAck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload_ChunkAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload_ChunkAck>(create);
  static Upload_ChunkAck? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get receivedBytes => $_getI64(0);
  @$pb.TagNumber(1)
  set receivedBytes($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceivedBytes() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceivedBytes() => $_clearField(1);
}

class Upload_CompleteAck extends $pb.GeneratedMessage {
  factory Upload_CompleteAck({
    $core.String? uploadId,
    $fixnum.Int64? receivedBytes,
  }) {
    final result = create();
    if (uploadId != null) result.uploadId = uploadId;
    if (receivedBytes != null) result.receivedBytes = receivedBytes;
    return result;
  }

  Upload_CompleteAck._();

  factory Upload_CompleteAck.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload_CompleteAck.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload.CompleteAck',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadId', protoName: 'uploadId')
    ..aInt64(2, _omitFieldNames ? '' : 'receivedBytes', protoName: 'receivedBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_CompleteAck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_CompleteAck copyWith(void Function(Upload_CompleteAck) updates) =>
      super.copyWith((message) => updates(message as Upload_CompleteAck)) as Upload_CompleteAck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload_CompleteAck create() => Upload_CompleteAck._();
  @$core.override
  Upload_CompleteAck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload_CompleteAck getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload_CompleteAck>(create);
  static Upload_CompleteAck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUploadId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get receivedBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set receivedBytes($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReceivedBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceivedBytes() => $_clearField(2);
}

enum Upload_Request_Payload { init, chunk, done, notSet }

class Upload_Request extends $pb.GeneratedMessage {
  factory Upload_Request({
    Upload_Init? init,
    Upload_Chunk? chunk,
    Upload_Done? done,
  }) {
    final result = create();
    if (init != null) result.init = init;
    if (chunk != null) result.chunk = chunk;
    if (done != null) result.done = done;
    return result;
  }

  Upload_Request._();

  factory Upload_Request.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload_Request.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Upload_Request_Payload> _Upload_Request_PayloadByTag = {
    1: Upload_Request_Payload.init,
    2: Upload_Request_Payload.chunk,
    3: Upload_Request_Payload.done,
    0: Upload_Request_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload.Request',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<Upload_Init>(1, _omitFieldNames ? '' : 'init', subBuilder: Upload_Init.create)
    ..aOM<Upload_Chunk>(2, _omitFieldNames ? '' : 'chunk', subBuilder: Upload_Chunk.create)
    ..aOM<Upload_Done>(3, _omitFieldNames ? '' : 'done', subBuilder: Upload_Done.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Request copyWith(void Function(Upload_Request) updates) =>
      super.copyWith((message) => updates(message as Upload_Request)) as Upload_Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload_Request create() => Upload_Request._();
  @$core.override
  Upload_Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload_Request getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload_Request>(create);
  static Upload_Request? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  Upload_Request_Payload whichPayload() => _Upload_Request_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Upload_Init get init => $_getN(0);
  @$pb.TagNumber(1)
  set init(Upload_Init value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInit() => $_has(0);
  @$pb.TagNumber(1)
  void clearInit() => $_clearField(1);
  @$pb.TagNumber(1)
  Upload_Init ensureInit() => $_ensure(0);

  @$pb.TagNumber(2)
  Upload_Chunk get chunk => $_getN(1);
  @$pb.TagNumber(2)
  set chunk(Upload_Chunk value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChunk() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunk() => $_clearField(2);
  @$pb.TagNumber(2)
  Upload_Chunk ensureChunk() => $_ensure(1);

  @$pb.TagNumber(3)
  Upload_Done get done => $_getN(2);
  @$pb.TagNumber(3)
  set done(Upload_Done value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDone() => $_has(2);
  @$pb.TagNumber(3)
  void clearDone() => $_clearField(3);
  @$pb.TagNumber(3)
  Upload_Done ensureDone() => $_ensure(2);
}

enum Upload_Response_Payload { initAck, chunkAck, completeAck, notSet }

class Upload_Response extends $pb.GeneratedMessage {
  factory Upload_Response({
    Upload_InitAck? initAck,
    Upload_ChunkAck? chunkAck,
    Upload_CompleteAck? completeAck,
  }) {
    final result = create();
    if (initAck != null) result.initAck = initAck;
    if (chunkAck != null) result.chunkAck = chunkAck;
    if (completeAck != null) result.completeAck = completeAck;
    return result;
  }

  Upload_Response._();

  factory Upload_Response.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload_Response.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Upload_Response_Payload> _Upload_Response_PayloadByTag = {
    1: Upload_Response_Payload.initAck,
    2: Upload_Response_Payload.chunkAck,
    3: Upload_Response_Payload.completeAck,
    0: Upload_Response_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload.Response',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<Upload_InitAck>(1, _omitFieldNames ? '' : 'initAck', protoName: 'initAck', subBuilder: Upload_InitAck.create)
    ..aOM<Upload_ChunkAck>(2, _omitFieldNames ? '' : 'chunkAck', protoName: 'chunkAck', subBuilder: Upload_ChunkAck.create)
    ..aOM<Upload_CompleteAck>(3, _omitFieldNames ? '' : 'completeAck', protoName: 'completeAck', subBuilder: Upload_CompleteAck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Response clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload_Response copyWith(void Function(Upload_Response) updates) =>
      super.copyWith((message) => updates(message as Upload_Response)) as Upload_Response;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload_Response create() => Upload_Response._();
  @$core.override
  Upload_Response createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload_Response getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload_Response>(create);
  static Upload_Response? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  Upload_Response_Payload whichPayload() => _Upload_Response_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  @$pb.TagNumber(3)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  Upload_InitAck get initAck => $_getN(0);
  @$pb.TagNumber(1)
  set initAck(Upload_InitAck value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInitAck() => $_has(0);
  @$pb.TagNumber(1)
  void clearInitAck() => $_clearField(1);
  @$pb.TagNumber(1)
  Upload_InitAck ensureInitAck() => $_ensure(0);

  @$pb.TagNumber(2)
  Upload_ChunkAck get chunkAck => $_getN(1);
  @$pb.TagNumber(2)
  set chunkAck(Upload_ChunkAck value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasChunkAck() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunkAck() => $_clearField(2);
  @$pb.TagNumber(2)
  Upload_ChunkAck ensureChunkAck() => $_ensure(1);

  @$pb.TagNumber(3)
  Upload_CompleteAck get completeAck => $_getN(2);
  @$pb.TagNumber(3)
  set completeAck(Upload_CompleteAck value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCompleteAck() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompleteAck() => $_clearField(3);
  @$pb.TagNumber(3)
  Upload_CompleteAck ensureCompleteAck() => $_ensure(2);
}

/// Upload (media files)
class Upload extends $pb.GeneratedMessage {
  factory Upload() => create();

  Upload._();

  factory Upload.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Upload.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Upload',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'v1'), createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Upload copyWith(void Function(Upload) updates) => super.copyWith((message) => updates(message as Upload)) as Upload;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Upload create() => Upload._();
  @$core.override
  Upload createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Upload getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Upload>(create);
  static Upload? _defaultInstance;
}

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
