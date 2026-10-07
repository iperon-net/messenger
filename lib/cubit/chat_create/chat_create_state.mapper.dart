// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_create_state.dart';

class ChatUsernameStatusMapper extends EnumMapper<ChatUsernameStatus> {
  ChatUsernameStatusMapper._();

  static ChatUsernameStatusMapper? _instance;
  static ChatUsernameStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatUsernameStatusMapper._());
    }
    return _instance!;
  }

  static ChatUsernameStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ChatUsernameStatus decode(dynamic value) {
    switch (value) {
      case r'empty':
        return ChatUsernameStatus.empty;
      case r'invalid':
        return ChatUsernameStatus.invalid;
      case r'checking':
        return ChatUsernameStatus.checking;
      case r'available':
        return ChatUsernameStatus.available;
      case r'taken':
        return ChatUsernameStatus.taken;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ChatUsernameStatus self) {
    switch (self) {
      case ChatUsernameStatus.empty:
        return r'empty';
      case ChatUsernameStatus.invalid:
        return r'invalid';
      case ChatUsernameStatus.checking:
        return r'checking';
      case ChatUsernameStatus.available:
        return r'available';
      case ChatUsernameStatus.taken:
        return r'taken';
    }
  }
}

extension ChatUsernameStatusMapperExtension on ChatUsernameStatus {
  String toValue() {
    ChatUsernameStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ChatUsernameStatus>(this) as String;
  }
}

class ChatCreateStateMapper extends ClassMapperBase<ChatCreateState> {
  ChatCreateStateMapper._();

  static ChatCreateStateMapper? _instance;
  static ChatCreateStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatCreateStateMapper._());
      models.ChatTypeMapper.ensureInitialized();
      models.ChatMemberMapper.ensureInitialized();
      models.ChatJoinModeMapper.ensureInitialized();
      models.ChatRoleMapper.ensureInitialized();
      ChatUsernameStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatCreateState';

  static Status _$status(ChatCreateState v) => v.status;
  static const Field<ChatCreateState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static models.ChatType _$type(ChatCreateState v) => v.type;
  static const Field<ChatCreateState, models.ChatType> _f$type = Field(
    'type',
    _$type,
    opt: true,
    def: models.ChatType.private,
  );
  static String _$chatID(ChatCreateState v) => v.chatID;
  static const Field<ChatCreateState, String> _f$chatID = Field(
    'chatID',
    _$chatID,
    opt: true,
    def: '',
  );
  static String _$title(ChatCreateState v) => v.title;
  static const Field<ChatCreateState, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
    def: '',
  );
  static String _$about(ChatCreateState v) => v.about;
  static const Field<ChatCreateState, String> _f$about = Field(
    'about',
    _$about,
    opt: true,
    def: '',
  );
  static List<models.ChatMember> _$contacts(ChatCreateState v) => v.contacts;
  static const Field<ChatCreateState, List<models.ChatMember>> _f$contacts =
      Field('contacts', _$contacts, opt: true, def: const []);
  static String _$query(ChatCreateState v) => v.query;
  static const Field<ChatCreateState, String> _f$query = Field(
    'query',
    _$query,
    opt: true,
    def: '',
  );
  static List<models.ChatMember> _$selected(ChatCreateState v) => v.selected;
  static const Field<ChatCreateState, List<models.ChatMember>> _f$selected =
      Field('selected', _$selected, opt: true, def: const []);
  static String _$avatarPath(ChatCreateState v) => v.avatarPath;
  static const Field<ChatCreateState, String> _f$avatarPath = Field(
    'avatarPath',
    _$avatarPath,
    opt: true,
    def: '',
  );
  static models.ChatJoinMode _$joinMode(ChatCreateState v) => v.joinMode;
  static const Field<ChatCreateState, models.ChatJoinMode> _f$joinMode = Field(
    'joinMode',
    _$joinMode,
    opt: true,
    def: models.ChatJoinMode.link,
  );
  static String _$username(ChatCreateState v) => v.username;
  static const Field<ChatCreateState, String> _f$username = Field(
    'username',
    _$username,
    opt: true,
    def: '',
  );
  static String _$originalUsername(ChatCreateState v) => v.originalUsername;
  static const Field<ChatCreateState, String> _f$originalUsername = Field(
    'originalUsername',
    _$originalUsername,
    opt: true,
    def: '',
  );
  static models.ChatRole _$defaultRole(ChatCreateState v) => v.defaultRole;
  static const Field<ChatCreateState, models.ChatRole> _f$defaultRole = Field(
    'defaultRole',
    _$defaultRole,
    opt: true,
    def: models.ChatRole.reader,
  );
  static bool _$commentsEnabled(ChatCreateState v) => v.commentsEnabled;
  static const Field<ChatCreateState, bool> _f$commentsEnabled = Field(
    'commentsEnabled',
    _$commentsEnabled,
    opt: true,
    def: false,
  );
  static bool _$signMessages(ChatCreateState v) => v.signMessages;
  static const Field<ChatCreateState, bool> _f$signMessages = Field(
    'signMessages',
    _$signMessages,
    opt: true,
    def: false,
  );
  static ChatUsernameStatus _$usernameStatus(ChatCreateState v) =>
      v.usernameStatus;
  static const Field<ChatCreateState, ChatUsernameStatus> _f$usernameStatus =
      Field(
        'usernameStatus',
        _$usernameStatus,
        opt: true,
        def: ChatUsernameStatus.empty,
      );
  static String _$inviteLink(ChatCreateState v) => v.inviteLink;
  static const Field<ChatCreateState, String> _f$inviteLink = Field(
    'inviteLink',
    _$inviteLink,
    opt: true,
    def: '',
  );
  static bool _$creating(ChatCreateState v) => v.creating;
  static const Field<ChatCreateState, bool> _f$creating = Field(
    'creating',
    _$creating,
    opt: true,
    def: false,
  );
  static String _$openChatID(ChatCreateState v) => v.openChatID;
  static const Field<ChatCreateState, String> _f$openChatID = Field(
    'openChatID',
    _$openChatID,
    opt: true,
    def: '',
  );
  static bool _$saved(ChatCreateState v) => v.saved;
  static const Field<ChatCreateState, bool> _f$saved = Field(
    'saved',
    _$saved,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ChatCreateState> fields = const {
    #status: _f$status,
    #type: _f$type,
    #chatID: _f$chatID,
    #title: _f$title,
    #about: _f$about,
    #contacts: _f$contacts,
    #query: _f$query,
    #selected: _f$selected,
    #avatarPath: _f$avatarPath,
    #joinMode: _f$joinMode,
    #username: _f$username,
    #originalUsername: _f$originalUsername,
    #defaultRole: _f$defaultRole,
    #commentsEnabled: _f$commentsEnabled,
    #signMessages: _f$signMessages,
    #usernameStatus: _f$usernameStatus,
    #inviteLink: _f$inviteLink,
    #creating: _f$creating,
    #openChatID: _f$openChatID,
    #saved: _f$saved,
  };

  static ChatCreateState _instantiate(DecodingData data) {
    return ChatCreateState(
      status: data.dec(_f$status),
      type: data.dec(_f$type),
      chatID: data.dec(_f$chatID),
      title: data.dec(_f$title),
      about: data.dec(_f$about),
      contacts: data.dec(_f$contacts),
      query: data.dec(_f$query),
      selected: data.dec(_f$selected),
      avatarPath: data.dec(_f$avatarPath),
      joinMode: data.dec(_f$joinMode),
      username: data.dec(_f$username),
      originalUsername: data.dec(_f$originalUsername),
      defaultRole: data.dec(_f$defaultRole),
      commentsEnabled: data.dec(_f$commentsEnabled),
      signMessages: data.dec(_f$signMessages),
      usernameStatus: data.dec(_f$usernameStatus),
      inviteLink: data.dec(_f$inviteLink),
      creating: data.dec(_f$creating),
      openChatID: data.dec(_f$openChatID),
      saved: data.dec(_f$saved),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatCreateState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatCreateState>(map);
  }

  static ChatCreateState fromJson(String json) {
    return ensureInitialized().decodeJson<ChatCreateState>(json);
  }
}

mixin ChatCreateStateMappable {
  String toJson() {
    return ChatCreateStateMapper.ensureInitialized()
        .encodeJson<ChatCreateState>(this as ChatCreateState);
  }

  Map<String, dynamic> toMap() {
    return ChatCreateStateMapper.ensureInitialized().encodeMap<ChatCreateState>(
      this as ChatCreateState,
    );
  }

  ChatCreateStateCopyWith<ChatCreateState, ChatCreateState, ChatCreateState>
  get copyWith =>
      _ChatCreateStateCopyWithImpl<ChatCreateState, ChatCreateState>(
        this as ChatCreateState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatCreateStateMapper.ensureInitialized().stringifyValue(
      this as ChatCreateState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatCreateStateMapper.ensureInitialized().equalsValue(
      this as ChatCreateState,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatCreateStateMapper.ensureInitialized().hashValue(
      this as ChatCreateState,
    );
  }
}

extension ChatCreateStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatCreateState, $Out> {
  ChatCreateStateCopyWith<$R, ChatCreateState, $Out> get $asChatCreateState =>
      $base.as((v, t, t2) => _ChatCreateStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatCreateStateCopyWith<$R, $In extends ChatCreateState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get contacts;
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get selected;
  $R call({
    Status? status,
    models.ChatType? type,
    String? chatID,
    String? title,
    String? about,
    List<models.ChatMember>? contacts,
    String? query,
    List<models.ChatMember>? selected,
    String? avatarPath,
    models.ChatJoinMode? joinMode,
    String? username,
    String? originalUsername,
    models.ChatRole? defaultRole,
    bool? commentsEnabled,
    bool? signMessages,
    ChatUsernameStatus? usernameStatus,
    String? inviteLink,
    bool? creating,
    String? openChatID,
    bool? saved,
  });
  ChatCreateStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatCreateStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatCreateState, $Out>
    implements ChatCreateStateCopyWith<$R, ChatCreateState, $Out> {
  _ChatCreateStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatCreateState> $mapper =
      ChatCreateStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get contacts => ListCopyWith(
    $value.contacts,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(contacts: v),
  );
  @override
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get selected => ListCopyWith(
    $value.selected,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(selected: v),
  );
  @override
  $R call({
    Status? status,
    models.ChatType? type,
    String? chatID,
    String? title,
    String? about,
    List<models.ChatMember>? contacts,
    String? query,
    List<models.ChatMember>? selected,
    String? avatarPath,
    models.ChatJoinMode? joinMode,
    String? username,
    String? originalUsername,
    models.ChatRole? defaultRole,
    bool? commentsEnabled,
    bool? signMessages,
    ChatUsernameStatus? usernameStatus,
    String? inviteLink,
    bool? creating,
    String? openChatID,
    bool? saved,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (type != null) #type: type,
      if (chatID != null) #chatID: chatID,
      if (title != null) #title: title,
      if (about != null) #about: about,
      if (contacts != null) #contacts: contacts,
      if (query != null) #query: query,
      if (selected != null) #selected: selected,
      if (avatarPath != null) #avatarPath: avatarPath,
      if (joinMode != null) #joinMode: joinMode,
      if (username != null) #username: username,
      if (originalUsername != null) #originalUsername: originalUsername,
      if (defaultRole != null) #defaultRole: defaultRole,
      if (commentsEnabled != null) #commentsEnabled: commentsEnabled,
      if (signMessages != null) #signMessages: signMessages,
      if (usernameStatus != null) #usernameStatus: usernameStatus,
      if (inviteLink != null) #inviteLink: inviteLink,
      if (creating != null) #creating: creating,
      if (openChatID != null) #openChatID: openChatID,
      if (saved != null) #saved: saved,
    }),
  );
  @override
  ChatCreateState $make(CopyWithData data) => ChatCreateState(
    status: data.get(#status, or: $value.status),
    type: data.get(#type, or: $value.type),
    chatID: data.get(#chatID, or: $value.chatID),
    title: data.get(#title, or: $value.title),
    about: data.get(#about, or: $value.about),
    contacts: data.get(#contacts, or: $value.contacts),
    query: data.get(#query, or: $value.query),
    selected: data.get(#selected, or: $value.selected),
    avatarPath: data.get(#avatarPath, or: $value.avatarPath),
    joinMode: data.get(#joinMode, or: $value.joinMode),
    username: data.get(#username, or: $value.username),
    originalUsername: data.get(#originalUsername, or: $value.originalUsername),
    defaultRole: data.get(#defaultRole, or: $value.defaultRole),
    commentsEnabled: data.get(#commentsEnabled, or: $value.commentsEnabled),
    signMessages: data.get(#signMessages, or: $value.signMessages),
    usernameStatus: data.get(#usernameStatus, or: $value.usernameStatus),
    inviteLink: data.get(#inviteLink, or: $value.inviteLink),
    creating: data.get(#creating, or: $value.creating),
    openChatID: data.get(#openChatID, or: $value.openChatID),
    saved: data.get(#saved, or: $value.saved),
  );

  @override
  ChatCreateStateCopyWith<$R2, ChatCreateState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatCreateStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

