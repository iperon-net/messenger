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

import 'package:protobuf/protobuf.dart' as $pb;

/// Тип чата. Пока только личные; группы/каналы/сообщества — следующие срезы.
class ChatType extends $pb.ProtobufEnum {
  static const ChatType CHAT_TYPE_PRIVATE = ChatType._(0, _omitEnumNames ? '' : 'CHAT_TYPE_PRIVATE');
  static const ChatType CHAT_TYPE_GROUP = ChatType._(1, _omitEnumNames ? '' : 'CHAT_TYPE_GROUP');
  static const ChatType CHAT_TYPE_CHANNEL = ChatType._(2, _omitEnumNames ? '' : 'CHAT_TYPE_CHANNEL');
  static const ChatType CHAT_TYPE_COMMUNITY = ChatType._(3, _omitEnumNames ? '' : 'CHAT_TYPE_COMMUNITY');

  static const $core.List<ChatType> values = <ChatType>[
    CHAT_TYPE_PRIVATE,
    CHAT_TYPE_GROUP,
    CHAT_TYPE_CHANNEL,
    CHAT_TYPE_COMMUNITY,
  ];

  static final $core.List<ChatType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ChatType? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatType._(super.value, super.name);
}

class MessageKind extends $pb.ProtobufEnum {
  static const MessageKind MESSAGE_KIND_TEXT = MessageKind._(0, _omitEnumNames ? '' : 'MESSAGE_KIND_TEXT');
  static const MessageKind MESSAGE_KIND_PHOTO = MessageKind._(1, _omitEnumNames ? '' : 'MESSAGE_KIND_PHOTO');
  static const MessageKind MESSAGE_KIND_VIDEO = MessageKind._(2, _omitEnumNames ? '' : 'MESSAGE_KIND_VIDEO');
  static const MessageKind MESSAGE_KIND_FILE = MessageKind._(3, _omitEnumNames ? '' : 'MESSAGE_KIND_FILE');
  static const MessageKind MESSAGE_KIND_VOICE = MessageKind._(4, _omitEnumNames ? '' : 'MESSAGE_KIND_VOICE');
  static const MessageKind MESSAGE_KIND_POLL = MessageKind._(5, _omitEnumNames ? '' : 'MESSAGE_KIND_POLL');

  static const $core.List<MessageKind> values = <MessageKind>[
    MESSAGE_KIND_TEXT,
    MESSAGE_KIND_PHOTO,
    MESSAGE_KIND_VIDEO,
    MESSAGE_KIND_FILE,
    MESSAGE_KIND_VOICE,
    MESSAGE_KIND_POLL,
  ];

  static final $core.List<MessageKind?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static MessageKind? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageKind._(super.value, super.name);
}

class MessageEntity_Type extends $pb.ProtobufEnum {
  static const MessageEntity_Type BOLD = MessageEntity_Type._(0, _omitEnumNames ? '' : 'BOLD');
  static const MessageEntity_Type ITALIC = MessageEntity_Type._(1, _omitEnumNames ? '' : 'ITALIC');
  static const MessageEntity_Type UNDERLINE = MessageEntity_Type._(2, _omitEnumNames ? '' : 'UNDERLINE');
  static const MessageEntity_Type STRIKE = MessageEntity_Type._(3, _omitEnumNames ? '' : 'STRIKE');
  static const MessageEntity_Type SPOILER = MessageEntity_Type._(4, _omitEnumNames ? '' : 'SPOILER');
  static const MessageEntity_Type CODE = MessageEntity_Type._(5, _omitEnumNames ? '' : 'CODE');
  static const MessageEntity_Type PRE = MessageEntity_Type._(6, _omitEnumNames ? '' : 'PRE');
  static const MessageEntity_Type TEXT_URL = MessageEntity_Type._(7, _omitEnumNames ? '' : 'TEXT_URL');
  static const MessageEntity_Type URL = MessageEntity_Type._(8, _omitEnumNames ? '' : 'URL');
  static const MessageEntity_Type MENTION = MessageEntity_Type._(9, _omitEnumNames ? '' : 'MENTION');
  static const MessageEntity_Type MENTION_NAME = MessageEntity_Type._(10, _omitEnumNames ? '' : 'MENTION_NAME');
  static const MessageEntity_Type HASHTAG = MessageEntity_Type._(11, _omitEnumNames ? '' : 'HASHTAG');
  static const MessageEntity_Type EMAIL = MessageEntity_Type._(12, _omitEnumNames ? '' : 'EMAIL');
  static const MessageEntity_Type PHONE = MessageEntity_Type._(13, _omitEnumNames ? '' : 'PHONE');
  static const MessageEntity_Type BLOCKQUOTE = MessageEntity_Type._(14, _omitEnumNames ? '' : 'BLOCKQUOTE');

  static const $core.List<MessageEntity_Type> values = <MessageEntity_Type>[
    BOLD,
    ITALIC,
    UNDERLINE,
    STRIKE,
    SPOILER,
    CODE,
    PRE,
    TEXT_URL,
    URL,
    MENTION,
    MENTION_NAME,
    HASHTAG,
    EMAIL,
    PHONE,
    BLOCKQUOTE,
  ];

  static final $core.List<MessageEntity_Type?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 14);
  static MessageEntity_Type? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageEntity_Type._(super.value, super.name);
}

class MessageCall_Outcome extends $pb.ProtobufEnum {
  /// Разговор состоялся (duration — длительность).
  static const MessageCall_Outcome ENDED = MessageCall_Outcome._(0, _omitEnumNames ? '' : 'ENDED');

  /// Не ответили: звонящий отменил / не дождался ответа.
  static const MessageCall_Outcome MISSED = MessageCall_Outcome._(1, _omitEnumNames ? '' : 'MISSED');

  /// Вызываемый отклонил.
  static const MessageCall_Outcome DECLINED = MessageCall_Outcome._(2, _omitEnumNames ? '' : 'DECLINED');

  /// Вызываемый был занят другим звонком (и звонка не видел).
  static const MessageCall_Outcome BUSY = MessageCall_Outcome._(3, _omitEnumNames ? '' : 'BUSY');

  static const $core.List<MessageCall_Outcome> values = <MessageCall_Outcome>[
    ENDED,
    MISSED,
    DECLINED,
    BUSY,
  ];

  static final $core.List<MessageCall_Outcome?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static MessageCall_Outcome? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageCall_Outcome._(super.value, super.name);
}

class ChatTyping_Action extends $pb.ProtobufEnum {
  static const ChatTyping_Action CANCEL = ChatTyping_Action._(0, _omitEnumNames ? '' : 'CANCEL');
  static const ChatTyping_Action TYPING = ChatTyping_Action._(1, _omitEnumNames ? '' : 'TYPING');
  static const ChatTyping_Action RECORD_VOICE = ChatTyping_Action._(2, _omitEnumNames ? '' : 'RECORD_VOICE');
  static const ChatTyping_Action UPLOAD_PHOTO = ChatTyping_Action._(3, _omitEnumNames ? '' : 'UPLOAD_PHOTO');
  static const ChatTyping_Action UPLOAD_VIDEO = ChatTyping_Action._(4, _omitEnumNames ? '' : 'UPLOAD_VIDEO');
  static const ChatTyping_Action UPLOAD_FILE = ChatTyping_Action._(5, _omitEnumNames ? '' : 'UPLOAD_FILE');

  static const $core.List<ChatTyping_Action> values = <ChatTyping_Action>[
    CANCEL,
    TYPING,
    RECORD_VOICE,
    UPLOAD_PHOTO,
    UPLOAD_VIDEO,
    UPLOAD_FILE,
  ];

  static final $core.List<ChatTyping_Action?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ChatTyping_Action? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatTyping_Action._(super.value, super.name);
}

class Update_ScheduledDeleted_Reason extends $pb.ProtobufEnum {
  static const Update_ScheduledDeleted_Reason DELETED = Update_ScheduledDeleted_Reason._(0, _omitEnumNames ? '' : 'DELETED');
  static const Update_ScheduledDeleted_Reason SENT = Update_ScheduledDeleted_Reason._(1, _omitEnumNames ? '' : 'SENT');
  static const Update_ScheduledDeleted_Reason FAILED = Update_ScheduledDeleted_Reason._(2, _omitEnumNames ? '' : 'FAILED');

  static const $core.List<Update_ScheduledDeleted_Reason> values = <Update_ScheduledDeleted_Reason>[
    DELETED,
    SENT,
    FAILED,
  ];

  static final $core.List<Update_ScheduledDeleted_Reason?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Update_ScheduledDeleted_Reason? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Update_ScheduledDeleted_Reason._(super.value, super.name);
}

class Chats_ReadDateResult_Status extends $pb.ProtobufEnum {
  static const Chats_ReadDateResult_Status READ = Chats_ReadDateResult_Status._(0, _omitEnumNames ? '' : 'READ');
  static const Chats_ReadDateResult_Status NOT_READ = Chats_ReadDateResult_Status._(1, _omitEnumNames ? '' : 'NOT_READ');
  static const Chats_ReadDateResult_Status HIDDEN = Chats_ReadDateResult_Status._(2, _omitEnumNames ? '' : 'HIDDEN');
  static const Chats_ReadDateResult_Status UNAVAILABLE = Chats_ReadDateResult_Status._(3, _omitEnumNames ? '' : 'UNAVAILABLE');

  static const $core.List<Chats_ReadDateResult_Status> values = <Chats_ReadDateResult_Status>[
    READ,
    NOT_READ,
    HIDDEN,
    UNAVAILABLE,
  ];

  static final $core.List<Chats_ReadDateResult_Status?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Chats_ReadDateResult_Status? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Chats_ReadDateResult_Status._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
