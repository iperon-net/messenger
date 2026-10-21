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

/// Тип чата. Личные и группы (срез 3, docs/plans/chats-groups.md); каналы /
/// сообщества — следующие срезы.
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

/// Роль участника группы (docs/plans/chats-groups.md). Владелец — создатель:
/// не снимается, удаляет группу, передаёт владение. READER только читает,
/// WRITER пишет, ADMIN — права ChatAdminRights (подэтап 3.2).
class ChatRole extends $pb.ProtobufEnum {
  static const ChatRole CHAT_ROLE_NONE = ChatRole._(0, _omitEnumNames ? '' : 'CHAT_ROLE_NONE');
  static const ChatRole CHAT_ROLE_READER = ChatRole._(1, _omitEnumNames ? '' : 'CHAT_ROLE_READER');
  static const ChatRole CHAT_ROLE_WRITER = ChatRole._(2, _omitEnumNames ? '' : 'CHAT_ROLE_WRITER');
  static const ChatRole CHAT_ROLE_ADMIN = ChatRole._(3, _omitEnumNames ? '' : 'CHAT_ROLE_ADMIN');
  static const ChatRole CHAT_ROLE_OWNER = ChatRole._(4, _omitEnumNames ? '' : 'CHAT_ROLE_OWNER');

  static const $core.List<ChatRole> values = <ChatRole>[
    CHAT_ROLE_NONE,
    CHAT_ROLE_READER,
    CHAT_ROLE_WRITER,
    CHAT_ROLE_ADMIN,
    CHAT_ROLE_OWNER,
  ];

  static final $core.List<ChatRole?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ChatRole? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatRole._(super.value, super.name);
}

/// Как вступают в группу (подэтап 3.3, «Приватность групп»): OPEN — публичная,
/// по username любой вступает сразу (единственный режим с username); LINK —
/// частная, по ссылкам-приглашениям (у ссылки может быть одобрение заявок);
/// REQUEST — по ссылке, но всегда через заявку, которую одобряет админ с
/// inviteUsers; ADMINS — только админы с inviteUsers добавляют сами или
/// приглашают ссылками (ссылка — способ админа пригласить; основная тоже
/// есть), участники добавлять не могут.
class ChatJoinMode extends $pb.ProtobufEnum {
  static const ChatJoinMode CHAT_JOIN_LINK = ChatJoinMode._(0, _omitEnumNames ? '' : 'CHAT_JOIN_LINK');
  static const ChatJoinMode CHAT_JOIN_OPEN = ChatJoinMode._(1, _omitEnumNames ? '' : 'CHAT_JOIN_OPEN');
  static const ChatJoinMode CHAT_JOIN_REQUEST = ChatJoinMode._(2, _omitEnumNames ? '' : 'CHAT_JOIN_REQUEST');
  static const ChatJoinMode CHAT_JOIN_ADMINS = ChatJoinMode._(3, _omitEnumNames ? '' : 'CHAT_JOIN_ADMINS');

  static const $core.List<ChatJoinMode> values = <ChatJoinMode>[
    CHAT_JOIN_LINK,
    CHAT_JOIN_OPEN,
    CHAT_JOIN_REQUEST,
    CHAT_JOIN_ADMINS,
  ];

  static final $core.List<ChatJoinMode?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ChatJoinMode? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatJoinMode._(super.value, super.name);
}

/// Какие реакции можно ставить в группе (подэтап 3.4): все из общего набора
/// (allChatReactions клиента = chatAllReactions сервера, общий
/// all_chat_reactions.json), только выбранные (ChatInfo.reactions) или никаких.
/// Смена режима не трогает уже поставленные.
class ChatReactionsMode extends $pb.ProtobufEnum {
  static const ChatReactionsMode CHAT_REACTIONS_ALL = ChatReactionsMode._(0, _omitEnumNames ? '' : 'CHAT_REACTIONS_ALL');
  static const ChatReactionsMode CHAT_REACTIONS_SOME = ChatReactionsMode._(1, _omitEnumNames ? '' : 'CHAT_REACTIONS_SOME');
  static const ChatReactionsMode CHAT_REACTIONS_NONE = ChatReactionsMode._(2, _omitEnumNames ? '' : 'CHAT_REACTIONS_NONE');

  static const $core.List<ChatReactionsMode> values = <ChatReactionsMode>[
    CHAT_REACTIONS_ALL,
    CHAT_REACTIONS_SOME,
    CHAT_REACTIONS_NONE,
  ];

  static final $core.List<ChatReactionsMode?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ChatReactionsMode? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChatReactionsMode._(super.value, super.name);
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

class MessageChatAction_Kind extends $pb.ProtobufEnum {
  static const MessageChatAction_Kind CREATED = MessageChatAction_Kind._(0, _omitEnumNames ? '' : 'CREATED');
  static const MessageChatAction_Kind ADDED = MessageChatAction_Kind._(1, _omitEnumNames ? '' : 'ADDED');
  static const MessageChatAction_Kind JOINED = MessageChatAction_Kind._(2, _omitEnumNames ? '' : 'JOINED');
  static const MessageChatAction_Kind LEFT = MessageChatAction_Kind._(3, _omitEnumNames ? '' : 'LEFT');
  static const MessageChatAction_Kind REMOVED = MessageChatAction_Kind._(4, _omitEnumNames ? '' : 'REMOVED');
  static const MessageChatAction_Kind TITLE_CHANGED = MessageChatAction_Kind._(5, _omitEnumNames ? '' : 'TITLE_CHANGED');
  static const MessageChatAction_Kind PHOTO_CHANGED = MessageChatAction_Kind._(6, _omitEnumNames ? '' : 'PHOTO_CHANGED');
  static const MessageChatAction_Kind PHOTO_REMOVED = MessageChatAction_Kind._(7, _omitEnumNames ? '' : 'PHOTO_REMOVED');
  static const MessageChatAction_Kind OWNER_CHANGED = MessageChatAction_Kind._(8, _omitEnumNames ? '' : 'OWNER_CHANGED');

  static const $core.List<MessageChatAction_Kind> values = <MessageChatAction_Kind>[
    CREATED,
    ADDED,
    JOINED,
    LEFT,
    REMOVED,
    TITLE_CHANGED,
    PHOTO_CHANGED,
    PHOTO_REMOVED,
    OWNER_CHANGED,
  ];

  static final $core.List<MessageChatAction_Kind?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 8);
  static MessageChatAction_Kind? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageChatAction_Kind._(super.value, super.name);
}

class MessageSystemNotice_Kind extends $pb.ProtobufEnum {
  static const MessageSystemNotice_Kind UNKNOWN = MessageSystemNotice_Kind._(0, _omitEnumNames ? '' : 'UNKNOWN');
  static const MessageSystemNotice_Kind NEW_LOGIN = MessageSystemNotice_Kind._(1, _omitEnumNames ? '' : 'NEW_LOGIN');
  static const MessageSystemNotice_Kind CLOUD_PASSWORD_SET = MessageSystemNotice_Kind._(2, _omitEnumNames ? '' : 'CLOUD_PASSWORD_SET');
  static const MessageSystemNotice_Kind CLOUD_PASSWORD_CHANGED =
      MessageSystemNotice_Kind._(3, _omitEnumNames ? '' : 'CLOUD_PASSWORD_CHANGED');
  static const MessageSystemNotice_Kind CLOUD_PASSWORD_DISABLED =
      MessageSystemNotice_Kind._(4, _omitEnumNames ? '' : 'CLOUD_PASSWORD_DISABLED');
  static const MessageSystemNotice_Kind CLOUD_PASSWORD_RESET = MessageSystemNotice_Kind._(5, _omitEnumNames ? '' : 'CLOUD_PASSWORD_RESET');
  static const MessageSystemNotice_Kind CLOUD_PASSWORD_WRONG = MessageSystemNotice_Kind._(6, _omitEnumNames ? '' : 'CLOUD_PASSWORD_WRONG');
  static const MessageSystemNotice_Kind RECOVERY_EMAIL_SET = MessageSystemNotice_Kind._(7, _omitEnumNames ? '' : 'RECOVERY_EMAIL_SET');
  static const MessageSystemNotice_Kind PASSKEY_ADDED = MessageSystemNotice_Kind._(8, _omitEnumNames ? '' : 'PASSKEY_ADDED');
  static const MessageSystemNotice_Kind PASSKEY_REMOVED = MessageSystemNotice_Kind._(9, _omitEnumNames ? '' : 'PASSKEY_REMOVED');

  static const $core.List<MessageSystemNotice_Kind> values = <MessageSystemNotice_Kind>[
    UNKNOWN,
    NEW_LOGIN,
    CLOUD_PASSWORD_SET,
    CLOUD_PASSWORD_CHANGED,
    CLOUD_PASSWORD_DISABLED,
    CLOUD_PASSWORD_RESET,
    CLOUD_PASSWORD_WRONG,
    RECOVERY_EMAIL_SET,
    PASSKEY_ADDED,
    PASSKEY_REMOVED,
  ];

  static final $core.List<MessageSystemNotice_Kind?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 9);
  static MessageSystemNotice_Kind? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageSystemNotice_Kind._(super.value, super.name);
}

class MessageSystemNotice_LoginMethod extends $pb.ProtobufEnum {
  static const MessageSystemNotice_LoginMethod LOGIN_METHOD_UNKNOWN =
      MessageSystemNotice_LoginMethod._(0, _omitEnumNames ? '' : 'LOGIN_METHOD_UNKNOWN');
  static const MessageSystemNotice_LoginMethod CALL_PASSWORD = MessageSystemNotice_LoginMethod._(1, _omitEnumNames ? '' : 'CALL_PASSWORD');
  static const MessageSystemNotice_LoginMethod SMS = MessageSystemNotice_LoginMethod._(2, _omitEnumNames ? '' : 'SMS');
  static const MessageSystemNotice_LoginMethod PASSKEY = MessageSystemNotice_LoginMethod._(3, _omitEnumNames ? '' : 'PASSKEY');
  static const MessageSystemNotice_LoginMethod YANDEX = MessageSystemNotice_LoginMethod._(4, _omitEnumNames ? '' : 'YANDEX');

  static const $core.List<MessageSystemNotice_LoginMethod> values = <MessageSystemNotice_LoginMethod>[
    LOGIN_METHOD_UNKNOWN,
    CALL_PASSWORD,
    SMS,
    PASSKEY,
    YANDEX,
  ];

  static final $core.List<MessageSystemNotice_LoginMethod?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MessageSystemNotice_LoginMethod? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MessageSystemNotice_LoginMethod._(super.value, super.name);
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

class Messages_ReadParticipantsResult_Status extends $pb.ProtobufEnum {
  static const Messages_ReadParticipantsResult_Status READ = Messages_ReadParticipantsResult_Status._(0, _omitEnumNames ? '' : 'READ');
  static const Messages_ReadParticipantsResult_Status NOT_READ =
      Messages_ReadParticipantsResult_Status._(1, _omitEnumNames ? '' : 'NOT_READ');
  static const Messages_ReadParticipantsResult_Status UNAVAILABLE =
      Messages_ReadParticipantsResult_Status._(2, _omitEnumNames ? '' : 'UNAVAILABLE');

  static const $core.List<Messages_ReadParticipantsResult_Status> values = <Messages_ReadParticipantsResult_Status>[
    READ,
    NOT_READ,
    UNAVAILABLE,
  ];

  static final $core.List<Messages_ReadParticipantsResult_Status?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Messages_ReadParticipantsResult_Status? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Messages_ReadParticipantsResult_Status._(super.value, super.name);
}

class Messages_SearchResult_Status extends $pb.ProtobufEnum {
  static const Messages_SearchResult_Status OK = Messages_SearchResult_Status._(0, _omitEnumNames ? '' : 'OK');
  static const Messages_SearchResult_Status QUERY_TOO_SHORT = Messages_SearchResult_Status._(1, _omitEnumNames ? '' : 'QUERY_TOO_SHORT');

  static const $core.List<Messages_SearchResult_Status> values = <Messages_SearchResult_Status>[
    OK,
    QUERY_TOO_SHORT,
  ];

  static final $core.List<Messages_SearchResult_Status?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 1);
  static Messages_SearchResult_Status? valueOf($core.int value) => value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Messages_SearchResult_Status._(super.value, super.name);
}

const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
