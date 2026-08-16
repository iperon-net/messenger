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

const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
