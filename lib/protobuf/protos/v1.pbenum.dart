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
  static const MessageType MY_PROFILE = MessageType._(11, _omitEnumNames ? '' : 'MY_PROFILE');
  static const MessageType MY_PROFILE_UPDATE = MessageType._(12, _omitEnumNames ? '' : 'MY_PROFILE_UPDATE');
  static const MessageType DEVICE_INFO_UPDATE = MessageType._(13, _omitEnumNames ? '' : 'DEVICE_INFO_UPDATE');
  static const MessageType MY_PROFILE_AVATAR_UPDATE = MessageType._(14, _omitEnumNames ? '' : 'MY_PROFILE_AVATAR_UPDATE');
  static const MessageType UPLOAD_CONFIRM = MessageType._(15, _omitEnumNames ? '' : 'UPLOAD_CONFIRM');
  static const MessageType CALL_HANGUP = MessageType._(19, _omitEnumNames ? '' : 'CALL_HANGUP');
  static const MessageType CALL_REJECT = MessageType._(20, _omitEnumNames ? '' : 'CALL_REJECT');
  static const MessageType MY_PROFILE_USERNAME_UPDATE = MessageType._(22, _omitEnumNames ? '' : 'MY_PROFILE_USERNAME_UPDATE');
  static const MessageType PROFILE = MessageType._(23, _omitEnumNames ? '' : 'PROFILE');
  static const MessageType CONTACTS_DISCOVERY_EVALUATE = MessageType._(24, _omitEnumNames ? '' : 'CONTACTS_DISCOVERY_EVALUATE');
  static const MessageType CONTACTS_DISCOVERY_MATCH = MessageType._(25, _omitEnumNames ? '' : 'CONTACTS_DISCOVERY_MATCH');
  static const MessageType REGISTER_PUSH_TOKEN = MessageType._(26, _omitEnumNames ? '' : 'REGISTER_PUSH_TOKEN');
  static const MessageType CALL_TOKEN = MessageType._(27, _omitEnumNames ? '' : 'CALL_TOKEN');
  static const MessageType CALL_RING = MessageType._(28, _omitEnumNames ? '' : 'CALL_RING');

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
    MY_PROFILE,
    MY_PROFILE_UPDATE,
    DEVICE_INFO_UPDATE,
    MY_PROFILE_AVATAR_UPDATE,
    UPLOAD_CONFIRM,
    CALL_HANGUP,
    CALL_REJECT,
    MY_PROFILE_USERNAME_UPDATE,
    PROFILE,
    CONTACTS_DISCOVERY_EVALUATE,
    CONTACTS_DISCOVERY_MATCH,
    REGISTER_PUSH_TOKEN,
    CALL_TOKEN,
    CALL_RING,
  ];

  static final $core.List<MessageType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 28);
  static MessageType? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageType._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
