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

  /// Облачная адресная книга / серверный граф контактов (этап 1: гейт звонков).
  /// UPSERT/REMOVE пишут рёбра владельца, PRIVACY_SETTINGS(_UPDATE) — настройку
  /// «кто может звонить». См. contacts_v1.proto / privacy_v1.proto.
  static const MessageType CONTACTS_UPSERT = MessageType._(29, _omitEnumNames ? '' : 'CONTACTS_UPSERT');
  static const MessageType CONTACTS_REMOVE = MessageType._(30, _omitEnumNames ? '' : 'CONTACTS_REMOVE');
  static const MessageType PRIVACY_SETTINGS = MessageType._(31, _omitEnumNames ? '' : 'PRIVACY_SETTINGS');
  static const MessageType PRIVACY_SETTINGS_UPDATE = MessageType._(32, _omitEnumNames ? '' : 'PRIVACY_SETTINGS_UPDATE');

  /// Облачные контакты (синхронизация PII между устройствами): LIST — pull всего
  /// списка на bootstrap; UPDATED — push-дельта на устройства владельца. См.
  /// contacts_v1.proto (Contact / ContactsList / ContactsUpdated).
  static const MessageType CONTACTS_LIST = MessageType._(33, _omitEnumNames ? '' : 'CONTACTS_LIST');
  static const MessageType CONTACTS_UPDATED = MessageType._(34, _omitEnumNames ? '' : 'CONTACTS_UPDATED');

  /// Присутствие (online / last-seen) для списка контактов — pull batch по userID
  /// (см. presence_v1.proto). Видимость гейтится звонковой приватностью.
  static const MessageType PRESENCE = MessageType._(35, _omitEnumNames ? '' : 'PRESENCE');

  /// Полная замена allow-list «всегда разрешать» для звонков (см.
  /// privacy_v1.proto, PrivacyCallsAllowUpdate).
  static const MessageType PRIVACY_CALLS_ALLOW_UPDATE = MessageType._(36, _omitEnumNames ? '' : 'PRIVACY_CALLS_ALLOW_UPDATE');

  /// Полная замена deny-list «всегда запрещать» для звонков (см.
  /// privacy_v1.proto, PrivacyCallsDenyUpdate).
  static const MessageType PRIVACY_CALLS_DENY_UPDATE = MessageType._(37, _omitEnumNames ? '' : 'PRIVACY_CALLS_DENY_UPDATE');

  /// Приватность дня рождения (аудитория + allow/deny + «скрыть год»). См.
  /// privacy_v1.proto (PrivacyBirthday*Update / PrivacyHideBirthYearUpdate).
  static const MessageType PRIVACY_BIRTHDAY_UPDATE = MessageType._(38, _omitEnumNames ? '' : 'PRIVACY_BIRTHDAY_UPDATE');
  static const MessageType PRIVACY_BIRTHDAY_ALLOW_UPDATE = MessageType._(39, _omitEnumNames ? '' : 'PRIVACY_BIRTHDAY_ALLOW_UPDATE');
  static const MessageType PRIVACY_BIRTHDAY_DENY_UPDATE = MessageType._(40, _omitEnumNames ? '' : 'PRIVACY_BIRTHDAY_DENY_UPDATE');
  static const MessageType PRIVACY_HIDE_BIRTH_YEAR_UPDATE = MessageType._(41, _omitEnumNames ? '' : 'PRIVACY_HIDE_BIRTH_YEAR_UPDATE');

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
    CONTACTS_UPSERT,
    CONTACTS_REMOVE,
    PRIVACY_SETTINGS,
    PRIVACY_SETTINGS_UPDATE,
    CONTACTS_LIST,
    CONTACTS_UPDATED,
    PRESENCE,
    PRIVACY_CALLS_ALLOW_UPDATE,
    PRIVACY_CALLS_DENY_UPDATE,
    PRIVACY_BIRTHDAY_UPDATE,
    PRIVACY_BIRTHDAY_ALLOW_UPDATE,
    PRIVACY_BIRTHDAY_DENY_UPDATE,
    PRIVACY_HIDE_BIRTH_YEAR_UPDATE,
  ];

  static final $core.List<MessageType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 41);
  static MessageType? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageType._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
