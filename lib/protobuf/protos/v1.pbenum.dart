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

class MessageType extends $pb.ProtobufEnum {
  static const MessageType HEALTHCHECK = MessageType._(0, _omitEnumNames ? '' : 'HEALTHCHECK');
  static const MessageType META_DATA_INFO = MessageType._(1, _omitEnumNames ? '' : 'META_DATA_INFO');
  static const MessageType AUTH_CALL_PASSWORD = MessageType._(2, _omitEnumNames ? '' : 'AUTH_CALL_PASSWORD');
  static const MessageType AUTH_CALL_PASSWORD_CONFIRMATION = MessageType._(3, _omitEnumNames ? '' : 'AUTH_CALL_PASSWORD_CONFIRMATION');
  static const MessageType AUTH_MODERATION_APPLICATION_STORE = MessageType._(4, _omitEnumNames ? '' : 'AUTH_MODERATION_APPLICATION_STORE');
  static const MessageType AUTH_MODERATION_APPLICATION_STORE_CONFIRMATION =
      MessageType._(5, _omitEnumNames ? '' : 'AUTH_MODERATION_APPLICATION_STORE_CONFIRMATION');
  static const MessageType DEVICE_SESSIONS = MessageType._(6, _omitEnumNames ? '' : 'DEVICE_SESSIONS');
  static const MessageType LOGOUT = MessageType._(7, _omitEnumNames ? '' : 'LOGOUT');
  static const MessageType SUBSCRIBE = MessageType._(8, _omitEnumNames ? '' : 'SUBSCRIBE');
  static const MessageType DEVICE_SESSIONS_TERMINATE = MessageType._(9, _omitEnumNames ? '' : 'DEVICE_SESSIONS_TERMINATE');
  static const MessageType AUTH_CONFIRMATION = MessageType._(10, _omitEnumNames ? '' : 'AUTH_CONFIRMATION');

  static const $core.List<MessageType> values = <MessageType>[
    HEALTHCHECK,
    META_DATA_INFO,
    AUTH_CALL_PASSWORD,
    AUTH_CALL_PASSWORD_CONFIRMATION,
    AUTH_MODERATION_APPLICATION_STORE,
    AUTH_MODERATION_APPLICATION_STORE_CONFIRMATION,
    DEVICE_SESSIONS,
    LOGOUT,
    SUBSCRIBE,
    DEVICE_SESSIONS_TERMINATE,
    AUTH_CONFIRMATION,
  ];

  static final $core.List<MessageType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 10);
  static MessageType? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageType._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
