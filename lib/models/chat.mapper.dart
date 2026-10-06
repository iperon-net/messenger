// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat.dart';

class ChatTypeMapper extends EnumMapper<ChatType> {
  ChatTypeMapper._();

  static ChatTypeMapper? _instance;
  static ChatTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatTypeMapper._());
    }
    return _instance!;
  }

  static ChatType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ChatType decode(dynamic value) {
    switch (value) {
      case r'private':
        return ChatType.private;
      case r'group':
        return ChatType.group;
      case r'channel':
        return ChatType.channel;
      case r'community':
        return ChatType.community;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ChatType self) {
    switch (self) {
      case ChatType.private:
        return r'private';
      case ChatType.group:
        return r'group';
      case ChatType.channel:
        return r'channel';
      case ChatType.community:
        return r'community';
    }
  }
}

extension ChatTypeMapperExtension on ChatType {
  String toValue() {
    ChatTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ChatType>(this) as String;
  }
}

class MessageStatusMapper extends EnumMapper<MessageStatus> {
  MessageStatusMapper._();

  static MessageStatusMapper? _instance;
  static MessageStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageStatusMapper._());
    }
    return _instance!;
  }

  static MessageStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MessageStatus decode(dynamic value) {
    switch (value) {
      case r'pending':
        return MessageStatus.pending;
      case r'sent':
        return MessageStatus.sent;
      case r'read':
        return MessageStatus.read;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MessageStatus self) {
    switch (self) {
      case MessageStatus.pending:
        return r'pending';
      case MessageStatus.sent:
        return r'sent';
      case MessageStatus.read:
        return r'read';
    }
  }
}

extension MessageStatusMapperExtension on MessageStatus {
  String toValue() {
    MessageStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MessageStatus>(this) as String;
  }
}

class MessageKindMapper extends EnumMapper<MessageKind> {
  MessageKindMapper._();

  static MessageKindMapper? _instance;
  static MessageKindMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageKindMapper._());
    }
    return _instance!;
  }

  static MessageKind fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MessageKind decode(dynamic value) {
    switch (value) {
      case r'text':
        return MessageKind.text;
      case r'photo':
        return MessageKind.photo;
      case r'video':
        return MessageKind.video;
      case r'file':
        return MessageKind.file;
      case r'voice':
        return MessageKind.voice;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MessageKind self) {
    switch (self) {
      case MessageKind.text:
        return r'text';
      case MessageKind.photo:
        return r'photo';
      case MessageKind.video:
        return r'video';
      case MessageKind.file:
        return r'file';
      case MessageKind.voice:
        return r'voice';
    }
  }
}

extension MessageKindMapperExtension on MessageKind {
  String toValue() {
    MessageKindMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MessageKind>(this) as String;
  }
}

class ChatReactionsModeMapper extends EnumMapper<ChatReactionsMode> {
  ChatReactionsModeMapper._();

  static ChatReactionsModeMapper? _instance;
  static ChatReactionsModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatReactionsModeMapper._());
    }
    return _instance!;
  }

  static ChatReactionsMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ChatReactionsMode decode(dynamic value) {
    switch (value) {
      case r'all':
        return ChatReactionsMode.all;
      case r'some':
        return ChatReactionsMode.some;
      case r'none':
        return ChatReactionsMode.none;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ChatReactionsMode self) {
    switch (self) {
      case ChatReactionsMode.all:
        return r'all';
      case ChatReactionsMode.some:
        return r'some';
      case ChatReactionsMode.none:
        return r'none';
    }
  }
}

extension ChatReactionsModeMapperExtension on ChatReactionsMode {
  String toValue() {
    ChatReactionsModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ChatReactionsMode>(this) as String;
  }
}

class ChatRoleMapper extends EnumMapper<ChatRole> {
  ChatRoleMapper._();

  static ChatRoleMapper? _instance;
  static ChatRoleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatRoleMapper._());
    }
    return _instance!;
  }

  static ChatRole fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ChatRole decode(dynamic value) {
    switch (value) {
      case r'reader':
        return ChatRole.reader;
      case r'writer':
        return ChatRole.writer;
      case r'admin':
        return ChatRole.admin;
      case r'owner':
        return ChatRole.owner;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ChatRole self) {
    switch (self) {
      case ChatRole.reader:
        return r'reader';
      case ChatRole.writer:
        return r'writer';
      case ChatRole.admin:
        return r'admin';
      case ChatRole.owner:
        return r'owner';
    }
  }
}

extension ChatRoleMapperExtension on ChatRole {
  String toValue() {
    ChatRoleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ChatRole>(this) as String;
  }
}

class ChatJoinModeMapper extends EnumMapper<ChatJoinMode> {
  ChatJoinModeMapper._();

  static ChatJoinModeMapper? _instance;
  static ChatJoinModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatJoinModeMapper._());
    }
    return _instance!;
  }

  static ChatJoinMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ChatJoinMode decode(dynamic value) {
    switch (value) {
      case r'open':
        return ChatJoinMode.open;
      case r'link':
        return ChatJoinMode.link;
      case r'request':
        return ChatJoinMode.request;
      case r'admins':
        return ChatJoinMode.admins;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ChatJoinMode self) {
    switch (self) {
      case ChatJoinMode.open:
        return r'open';
      case ChatJoinMode.link:
        return r'link';
      case ChatJoinMode.request:
        return r'request';
      case ChatJoinMode.admins:
        return r'admins';
    }
  }
}

extension ChatJoinModeMapperExtension on ChatJoinMode {
  String toValue() {
    ChatJoinModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ChatJoinMode>(this) as String;
  }
}

class ChatMemberMapper extends ClassMapperBase<ChatMember> {
  ChatMemberMapper._();

  static ChatMemberMapper? _instance;
  static ChatMemberMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMemberMapper._());
      ChatRoleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatMember';

  static String _$id(ChatMember v) => v.id;
  static const Field<ChatMember, String> _f$id = Field('id', _$id);
  static String _$name(ChatMember v) => v.name;
  static const Field<ChatMember, String> _f$name = Field('name', _$name);
  static ChatRole _$role(ChatMember v) => v.role;
  static const Field<ChatMember, ChatRole> _f$role = Field(
    'role',
    _$role,
    opt: true,
    def: ChatRole.writer,
  );
  static bool _$online(ChatMember v) => v.online;
  static const Field<ChatMember, bool> _f$online = Field(
    'online',
    _$online,
    opt: true,
    def: false,
  );
  static DateTime? _$lastSeen(ChatMember v) => v.lastSeen;
  static const Field<ChatMember, DateTime> _f$lastSeen = Field(
    'lastSeen',
    _$lastSeen,
    opt: true,
  );
  static bool _$isSelf(ChatMember v) => v.isSelf;
  static const Field<ChatMember, bool> _f$isSelf = Field(
    'isSelf',
    _$isSelf,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ChatMember> fields = const {
    #id: _f$id,
    #name: _f$name,
    #role: _f$role,
    #online: _f$online,
    #lastSeen: _f$lastSeen,
    #isSelf: _f$isSelf,
  };

  static ChatMember _instantiate(DecodingData data) {
    return ChatMember(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      role: data.dec(_f$role),
      online: data.dec(_f$online),
      lastSeen: data.dec(_f$lastSeen),
      isSelf: data.dec(_f$isSelf),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatMember fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatMember>(map);
  }

  static ChatMember fromJson(String json) {
    return ensureInitialized().decodeJson<ChatMember>(json);
  }
}

mixin ChatMemberMappable {
  String toJson() {
    return ChatMemberMapper.ensureInitialized().encodeJson<ChatMember>(
      this as ChatMember,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatMemberMapper.ensureInitialized().encodeMap<ChatMember>(
      this as ChatMember,
    );
  }

  ChatMemberCopyWith<ChatMember, ChatMember, ChatMember> get copyWith =>
      _ChatMemberCopyWithImpl<ChatMember, ChatMember>(
        this as ChatMember,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatMemberMapper.ensureInitialized().stringifyValue(
      this as ChatMember,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatMemberMapper.ensureInitialized().equalsValue(
      this as ChatMember,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatMemberMapper.ensureInitialized().hashValue(this as ChatMember);
  }
}

extension ChatMemberValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatMember, $Out> {
  ChatMemberCopyWith<$R, ChatMember, $Out> get $asChatMember =>
      $base.as((v, t, t2) => _ChatMemberCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatMemberCopyWith<$R, $In extends ChatMember, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? name,
    ChatRole? role,
    bool? online,
    DateTime? lastSeen,
    bool? isSelf,
  });
  ChatMemberCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatMemberCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatMember, $Out>
    implements ChatMemberCopyWith<$R, ChatMember, $Out> {
  _ChatMemberCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatMember> $mapper =
      ChatMemberMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? name,
    ChatRole? role,
    bool? online,
    Object? lastSeen = $none,
    bool? isSelf,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (role != null) #role: role,
      if (online != null) #online: online,
      if (lastSeen != $none) #lastSeen: lastSeen,
      if (isSelf != null) #isSelf: isSelf,
    }),
  );
  @override
  ChatMember $make(CopyWithData data) => ChatMember(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    role: data.get(#role, or: $value.role),
    online: data.get(#online, or: $value.online),
    lastSeen: data.get(#lastSeen, or: $value.lastSeen),
    isSelf: data.get(#isSelf, or: $value.isSelf),
  );

  @override
  ChatMemberCopyWith<$R2, ChatMember, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatMemberCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatLastMessageMapper extends ClassMapperBase<ChatLastMessage> {
  ChatLastMessageMapper._();

  static ChatLastMessageMapper? _instance;
  static ChatLastMessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatLastMessageMapper._());
      MessageKindMapper.ensureInitialized();
      MessageStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatLastMessage';

  static MessageKind _$kind(ChatLastMessage v) => v.kind;
  static const Field<ChatLastMessage, MessageKind> _f$kind = Field(
    'kind',
    _$kind,
    opt: true,
    def: MessageKind.text,
  );
  static String _$text(ChatLastMessage v) => v.text;
  static const Field<ChatLastMessage, String> _f$text = Field(
    'text',
    _$text,
    opt: true,
    def: '',
  );
  static String _$senderName(ChatLastMessage v) => v.senderName;
  static const Field<ChatLastMessage, String> _f$senderName = Field(
    'senderName',
    _$senderName,
    opt: true,
    def: '',
  );
  static bool _$outgoing(ChatLastMessage v) => v.outgoing;
  static const Field<ChatLastMessage, bool> _f$outgoing = Field(
    'outgoing',
    _$outgoing,
    opt: true,
    def: false,
  );
  static MessageStatus _$status(ChatLastMessage v) => v.status;
  static const Field<ChatLastMessage, MessageStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: MessageStatus.sent,
  );
  static DateTime _$date(ChatLastMessage v) => v.date;
  static const Field<ChatLastMessage, DateTime> _f$date = Field('date', _$date);

  @override
  final MappableFields<ChatLastMessage> fields = const {
    #kind: _f$kind,
    #text: _f$text,
    #senderName: _f$senderName,
    #outgoing: _f$outgoing,
    #status: _f$status,
    #date: _f$date,
  };

  static ChatLastMessage _instantiate(DecodingData data) {
    return ChatLastMessage(
      kind: data.dec(_f$kind),
      text: data.dec(_f$text),
      senderName: data.dec(_f$senderName),
      outgoing: data.dec(_f$outgoing),
      status: data.dec(_f$status),
      date: data.dec(_f$date),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatLastMessage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatLastMessage>(map);
  }

  static ChatLastMessage fromJson(String json) {
    return ensureInitialized().decodeJson<ChatLastMessage>(json);
  }
}

mixin ChatLastMessageMappable {
  String toJson() {
    return ChatLastMessageMapper.ensureInitialized()
        .encodeJson<ChatLastMessage>(this as ChatLastMessage);
  }

  Map<String, dynamic> toMap() {
    return ChatLastMessageMapper.ensureInitialized().encodeMap<ChatLastMessage>(
      this as ChatLastMessage,
    );
  }

  ChatLastMessageCopyWith<ChatLastMessage, ChatLastMessage, ChatLastMessage>
  get copyWith =>
      _ChatLastMessageCopyWithImpl<ChatLastMessage, ChatLastMessage>(
        this as ChatLastMessage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatLastMessageMapper.ensureInitialized().stringifyValue(
      this as ChatLastMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatLastMessageMapper.ensureInitialized().equalsValue(
      this as ChatLastMessage,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatLastMessageMapper.ensureInitialized().hashValue(
      this as ChatLastMessage,
    );
  }
}

extension ChatLastMessageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatLastMessage, $Out> {
  ChatLastMessageCopyWith<$R, ChatLastMessage, $Out> get $asChatLastMessage =>
      $base.as((v, t, t2) => _ChatLastMessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatLastMessageCopyWith<$R, $In extends ChatLastMessage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    MessageKind? kind,
    String? text,
    String? senderName,
    bool? outgoing,
    MessageStatus? status,
    DateTime? date,
  });
  ChatLastMessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatLastMessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatLastMessage, $Out>
    implements ChatLastMessageCopyWith<$R, ChatLastMessage, $Out> {
  _ChatLastMessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatLastMessage> $mapper =
      ChatLastMessageMapper.ensureInitialized();
  @override
  $R call({
    MessageKind? kind,
    String? text,
    String? senderName,
    bool? outgoing,
    MessageStatus? status,
    DateTime? date,
  }) => $apply(
    FieldCopyWithData({
      if (kind != null) #kind: kind,
      if (text != null) #text: text,
      if (senderName != null) #senderName: senderName,
      if (outgoing != null) #outgoing: outgoing,
      if (status != null) #status: status,
      if (date != null) #date: date,
    }),
  );
  @override
  ChatLastMessage $make(CopyWithData data) => ChatLastMessage(
    kind: data.get(#kind, or: $value.kind),
    text: data.get(#text, or: $value.text),
    senderName: data.get(#senderName, or: $value.senderName),
    outgoing: data.get(#outgoing, or: $value.outgoing),
    status: data.get(#status, or: $value.status),
    date: data.get(#date, or: $value.date),
  );

  @override
  ChatLastMessageCopyWith<$R2, ChatLastMessage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatLastMessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatMapper extends ClassMapperBase<Chat> {
  ChatMapper._();

  static ChatMapper? _instance;
  static ChatMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatMapper._());
      ChatTypeMapper.ensureInitialized();
      ChatLastMessageMapper.ensureInitialized();
      ChatReactionsModeMapper.ensureInitialized();
      ChatJoinModeMapper.ensureInitialized();
      ChatRoleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Chat';

  static String _$id(Chat v) => v.id;
  static const Field<Chat, String> _f$id = Field('id', _$id);
  static ChatType _$type(Chat v) => v.type;
  static const Field<Chat, ChatType> _f$type = Field('type', _$type);
  static String _$title(Chat v) => v.title;
  static const Field<Chat, String> _f$title = Field('title', _$title);
  static bool _$isContact(Chat v) => v.isContact;
  static const Field<Chat, bool> _f$isContact = Field(
    'isContact',
    _$isContact,
    opt: true,
    def: false,
  );
  static bool _$isSelf(Chat v) => v.isSelf;
  static const Field<Chat, bool> _f$isSelf = Field(
    'isSelf',
    _$isSelf,
    opt: true,
    def: false,
  );
  static ChatLastMessage? _$lastMessage(Chat v) => v.lastMessage;
  static const Field<Chat, ChatLastMessage> _f$lastMessage = Field(
    'lastMessage',
    _$lastMessage,
    opt: true,
  );
  static int _$unreadCount(Chat v) => v.unreadCount;
  static const Field<Chat, int> _f$unreadCount = Field(
    'unreadCount',
    _$unreadCount,
    opt: true,
    def: 0,
  );
  static int _$unreadMentions(Chat v) => v.unreadMentions;
  static const Field<Chat, int> _f$unreadMentions = Field(
    'unreadMentions',
    _$unreadMentions,
    opt: true,
    def: 0,
  );
  static bool _$markedUnread(Chat v) => v.markedUnread;
  static const Field<Chat, bool> _f$markedUnread = Field(
    'markedUnread',
    _$markedUnread,
    opt: true,
    def: false,
  );
  static bool _$muted(Chat v) => v.muted;
  static const Field<Chat, bool> _f$muted = Field(
    'muted',
    _$muted,
    opt: true,
    def: false,
  );
  static bool _$pinned(Chat v) => v.pinned;
  static const Field<Chat, bool> _f$pinned = Field(
    'pinned',
    _$pinned,
    opt: true,
    def: false,
  );
  static bool _$archived(Chat v) => v.archived;
  static const Field<Chat, bool> _f$archived = Field(
    'archived',
    _$archived,
    opt: true,
    def: false,
  );
  static String _$draft(Chat v) => v.draft;
  static const Field<Chat, String> _f$draft = Field(
    'draft',
    _$draft,
    opt: true,
    def: '',
  );
  static String _$typing(Chat v) => v.typing;
  static const Field<Chat, String> _f$typing = Field(
    'typing',
    _$typing,
    opt: true,
    def: '',
  );
  static ChatReactionsMode _$reactionsMode(Chat v) => v.reactionsMode;
  static const Field<Chat, ChatReactionsMode> _f$reactionsMode = Field(
    'reactionsMode',
    _$reactionsMode,
    opt: true,
    def: ChatReactionsMode.all,
  );
  static List<String> _$reactions(Chat v) => v.reactions;
  static const Field<Chat, List<String>> _f$reactions = Field(
    'reactions',
    _$reactions,
    opt: true,
    def: const [],
  );
  static String _$about(Chat v) => v.about;
  static const Field<Chat, String> _f$about = Field(
    'about',
    _$about,
    opt: true,
    def: '',
  );
  static String _$username(Chat v) => v.username;
  static const Field<Chat, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
    def: '',
  );
  static String _$inviteLink(Chat v) => v.inviteLink;
  static const Field<Chat, String> _f$inviteLink = Field(
    'inviteLink',
    _$inviteLink,
    opt: true,
    def: '',
  );
  static String _$avatarPath(Chat v) => v.avatarPath;
  static const Field<Chat, String> _f$avatarPath = Field(
    'avatarPath',
    _$avatarPath,
    opt: true,
    def: '',
  );
  static ChatJoinMode _$joinMode(Chat v) => v.joinMode;
  static const Field<Chat, ChatJoinMode> _f$joinMode = Field(
    'joinMode',
    _$joinMode,
    opt: true,
    def: ChatJoinMode.link,
  );
  static ChatRole _$defaultRole(Chat v) => v.defaultRole;
  static const Field<Chat, ChatRole> _f$defaultRole = Field(
    'defaultRole',
    _$defaultRole,
    opt: true,
    def: ChatRole.reader,
  );
  static int _$membersCount(Chat v) => v.membersCount;
  static const Field<Chat, int> _f$membersCount = Field(
    'membersCount',
    _$membersCount,
    opt: true,
    def: 0,
  );
  static ChatRole _$myRole(Chat v) => v.myRole;
  static const Field<Chat, ChatRole> _f$myRole = Field(
    'myRole',
    _$myRole,
    opt: true,
    def: ChatRole.writer,
  );
  static bool _$online(Chat v) => v.online;
  static const Field<Chat, bool> _f$online = Field(
    'online',
    _$online,
    opt: true,
    def: false,
  );
  static DateTime? _$lastSeen(Chat v) => v.lastSeen;
  static const Field<Chat, DateTime> _f$lastSeen = Field(
    'lastSeen',
    _$lastSeen,
    opt: true,
  );
  static DateTime? _$createdAt(Chat v) => v.createdAt;
  static const Field<Chat, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    opt: true,
  );

  @override
  final MappableFields<Chat> fields = const {
    #id: _f$id,
    #type: _f$type,
    #title: _f$title,
    #isContact: _f$isContact,
    #isSelf: _f$isSelf,
    #lastMessage: _f$lastMessage,
    #unreadCount: _f$unreadCount,
    #unreadMentions: _f$unreadMentions,
    #markedUnread: _f$markedUnread,
    #muted: _f$muted,
    #pinned: _f$pinned,
    #archived: _f$archived,
    #draft: _f$draft,
    #typing: _f$typing,
    #reactionsMode: _f$reactionsMode,
    #reactions: _f$reactions,
    #about: _f$about,
    #username: _f$username,
    #inviteLink: _f$inviteLink,
    #avatarPath: _f$avatarPath,
    #joinMode: _f$joinMode,
    #defaultRole: _f$defaultRole,
    #membersCount: _f$membersCount,
    #myRole: _f$myRole,
    #online: _f$online,
    #lastSeen: _f$lastSeen,
    #createdAt: _f$createdAt,
  };

  static Chat _instantiate(DecodingData data) {
    return Chat(
      id: data.dec(_f$id),
      type: data.dec(_f$type),
      title: data.dec(_f$title),
      isContact: data.dec(_f$isContact),
      isSelf: data.dec(_f$isSelf),
      lastMessage: data.dec(_f$lastMessage),
      unreadCount: data.dec(_f$unreadCount),
      unreadMentions: data.dec(_f$unreadMentions),
      markedUnread: data.dec(_f$markedUnread),
      muted: data.dec(_f$muted),
      pinned: data.dec(_f$pinned),
      archived: data.dec(_f$archived),
      draft: data.dec(_f$draft),
      typing: data.dec(_f$typing),
      reactionsMode: data.dec(_f$reactionsMode),
      reactions: data.dec(_f$reactions),
      about: data.dec(_f$about),
      username: data.dec(_f$username),
      inviteLink: data.dec(_f$inviteLink),
      avatarPath: data.dec(_f$avatarPath),
      joinMode: data.dec(_f$joinMode),
      defaultRole: data.dec(_f$defaultRole),
      membersCount: data.dec(_f$membersCount),
      myRole: data.dec(_f$myRole),
      online: data.dec(_f$online),
      lastSeen: data.dec(_f$lastSeen),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Chat fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Chat>(map);
  }

  static Chat fromJson(String json) {
    return ensureInitialized().decodeJson<Chat>(json);
  }
}

mixin ChatMappable {
  String toJson() {
    return ChatMapper.ensureInitialized().encodeJson<Chat>(this as Chat);
  }

  Map<String, dynamic> toMap() {
    return ChatMapper.ensureInitialized().encodeMap<Chat>(this as Chat);
  }

  ChatCopyWith<Chat, Chat, Chat> get copyWith =>
      _ChatCopyWithImpl<Chat, Chat>(this as Chat, $identity, $identity);
  @override
  String toString() {
    return ChatMapper.ensureInitialized().stringifyValue(this as Chat);
  }

  @override
  bool operator ==(Object other) {
    return ChatMapper.ensureInitialized().equalsValue(this as Chat, other);
  }

  @override
  int get hashCode {
    return ChatMapper.ensureInitialized().hashValue(this as Chat);
  }
}

extension ChatValueCopy<$R, $Out> on ObjectCopyWith<$R, Chat, $Out> {
  ChatCopyWith<$R, Chat, $Out> get $asChat =>
      $base.as((v, t, t2) => _ChatCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatCopyWith<$R, $In extends Chat, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ChatLastMessageCopyWith<$R, ChatLastMessage, ChatLastMessage>?
  get lastMessage;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reactions;
  $R call({
    String? id,
    ChatType? type,
    String? title,
    bool? isContact,
    bool? isSelf,
    ChatLastMessage? lastMessage,
    int? unreadCount,
    int? unreadMentions,
    bool? markedUnread,
    bool? muted,
    bool? pinned,
    bool? archived,
    String? draft,
    String? typing,
    ChatReactionsMode? reactionsMode,
    List<String>? reactions,
    String? about,
    String? username,
    String? inviteLink,
    String? avatarPath,
    ChatJoinMode? joinMode,
    ChatRole? defaultRole,
    int? membersCount,
    ChatRole? myRole,
    bool? online,
    DateTime? lastSeen,
    DateTime? createdAt,
  });
  ChatCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Chat, $Out>
    implements ChatCopyWith<$R, Chat, $Out> {
  _ChatCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Chat> $mapper = ChatMapper.ensureInitialized();
  @override
  ChatLastMessageCopyWith<$R, ChatLastMessage, ChatLastMessage>?
  get lastMessage =>
      $value.lastMessage?.copyWith.$chain((v) => call(lastMessage: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get reactions =>
      ListCopyWith(
        $value.reactions,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(reactions: v),
      );
  @override
  $R call({
    String? id,
    ChatType? type,
    String? title,
    bool? isContact,
    bool? isSelf,
    Object? lastMessage = $none,
    int? unreadCount,
    int? unreadMentions,
    bool? markedUnread,
    bool? muted,
    bool? pinned,
    bool? archived,
    String? draft,
    String? typing,
    ChatReactionsMode? reactionsMode,
    List<String>? reactions,
    String? about,
    String? username,
    String? inviteLink,
    String? avatarPath,
    ChatJoinMode? joinMode,
    ChatRole? defaultRole,
    int? membersCount,
    ChatRole? myRole,
    bool? online,
    Object? lastSeen = $none,
    Object? createdAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (type != null) #type: type,
      if (title != null) #title: title,
      if (isContact != null) #isContact: isContact,
      if (isSelf != null) #isSelf: isSelf,
      if (lastMessage != $none) #lastMessage: lastMessage,
      if (unreadCount != null) #unreadCount: unreadCount,
      if (unreadMentions != null) #unreadMentions: unreadMentions,
      if (markedUnread != null) #markedUnread: markedUnread,
      if (muted != null) #muted: muted,
      if (pinned != null) #pinned: pinned,
      if (archived != null) #archived: archived,
      if (draft != null) #draft: draft,
      if (typing != null) #typing: typing,
      if (reactionsMode != null) #reactionsMode: reactionsMode,
      if (reactions != null) #reactions: reactions,
      if (about != null) #about: about,
      if (username != null) #username: username,
      if (inviteLink != null) #inviteLink: inviteLink,
      if (avatarPath != null) #avatarPath: avatarPath,
      if (joinMode != null) #joinMode: joinMode,
      if (defaultRole != null) #defaultRole: defaultRole,
      if (membersCount != null) #membersCount: membersCount,
      if (myRole != null) #myRole: myRole,
      if (online != null) #online: online,
      if (lastSeen != $none) #lastSeen: lastSeen,
      if (createdAt != $none) #createdAt: createdAt,
    }),
  );
  @override
  Chat $make(CopyWithData data) => Chat(
    id: data.get(#id, or: $value.id),
    type: data.get(#type, or: $value.type),
    title: data.get(#title, or: $value.title),
    isContact: data.get(#isContact, or: $value.isContact),
    isSelf: data.get(#isSelf, or: $value.isSelf),
    lastMessage: data.get(#lastMessage, or: $value.lastMessage),
    unreadCount: data.get(#unreadCount, or: $value.unreadCount),
    unreadMentions: data.get(#unreadMentions, or: $value.unreadMentions),
    markedUnread: data.get(#markedUnread, or: $value.markedUnread),
    muted: data.get(#muted, or: $value.muted),
    pinned: data.get(#pinned, or: $value.pinned),
    archived: data.get(#archived, or: $value.archived),
    draft: data.get(#draft, or: $value.draft),
    typing: data.get(#typing, or: $value.typing),
    reactionsMode: data.get(#reactionsMode, or: $value.reactionsMode),
    reactions: data.get(#reactions, or: $value.reactions),
    about: data.get(#about, or: $value.about),
    username: data.get(#username, or: $value.username),
    inviteLink: data.get(#inviteLink, or: $value.inviteLink),
    avatarPath: data.get(#avatarPath, or: $value.avatarPath),
    joinMode: data.get(#joinMode, or: $value.joinMode),
    defaultRole: data.get(#defaultRole, or: $value.defaultRole),
    membersCount: data.get(#membersCount, or: $value.membersCount),
    myRole: data.get(#myRole, or: $value.myRole),
    online: data.get(#online, or: $value.online),
    lastSeen: data.get(#lastSeen, or: $value.lastSeen),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  ChatCopyWith<$R2, Chat, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ChatCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

