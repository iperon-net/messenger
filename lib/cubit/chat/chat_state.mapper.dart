// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_state.dart';

class ChatStateMapper extends ClassMapperBase<ChatState> {
  ChatStateMapper._();

  static ChatStateMapper? _instance;
  static ChatStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatStateMapper._());
      models.ChatMapper.ensureInitialized();
      models.MessageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatState';

  static Status _$status(ChatState v) => v.status;
  static const Field<ChatState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static models.Chat? _$chat(ChatState v) => v.chat;
  static const Field<ChatState, models.Chat> _f$chat = Field(
    'chat',
    _$chat,
    opt: true,
  );
  static List<models.Message> _$messages(ChatState v) => v.messages;
  static const Field<ChatState, List<models.Message>> _f$messages = Field(
    'messages',
    _$messages,
    opt: true,
    def: const [],
  );
  static models.Message? _$reply(ChatState v) => v.reply;
  static const Field<ChatState, models.Message> _f$reply = Field(
    'reply',
    _$reply,
    opt: true,
  );
  static models.Message? _$editing(ChatState v) => v.editing;
  static const Field<ChatState, models.Message> _f$editing = Field(
    'editing',
    _$editing,
    opt: true,
  );
  static String? _$unreadFromID(ChatState v) => v.unreadFromID;
  static const Field<ChatState, String> _f$unreadFromID = Field(
    'unreadFromID',
    _$unreadFromID,
    opt: true,
  );
  static bool _$selecting(ChatState v) => v.selecting;
  static const Field<ChatState, bool> _f$selecting = Field(
    'selecting',
    _$selecting,
    opt: true,
    def: false,
  );
  static List<String> _$selectedIDs(ChatState v) => v.selectedIDs;
  static const Field<ChatState, List<String>> _f$selectedIDs = Field(
    'selectedIDs',
    _$selectedIDs,
    opt: true,
    def: const [],
  );
  static List<models.Message> _$forwarding(ChatState v) => v.forwarding;
  static const Field<ChatState, List<models.Message>> _f$forwarding = Field(
    'forwarding',
    _$forwarding,
    opt: true,
    def: const [],
  );
  static bool _$searching(ChatState v) => v.searching;
  static const Field<ChatState, bool> _f$searching = Field(
    'searching',
    _$searching,
    opt: true,
    def: false,
  );
  static String _$searchQuery(ChatState v) => v.searchQuery;
  static const Field<ChatState, String> _f$searchQuery = Field(
    'searchQuery',
    _$searchQuery,
    opt: true,
    def: '',
  );
  static List<String> _$searchResults(ChatState v) => v.searchResults;
  static const Field<ChatState, List<String>> _f$searchResults = Field(
    'searchResults',
    _$searchResults,
    opt: true,
    def: const [],
  );
  static int _$searchIndex(ChatState v) => v.searchIndex;
  static const Field<ChatState, int> _f$searchIndex = Field(
    'searchIndex',
    _$searchIndex,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<ChatState> fields = const {
    #status: _f$status,
    #chat: _f$chat,
    #messages: _f$messages,
    #reply: _f$reply,
    #editing: _f$editing,
    #unreadFromID: _f$unreadFromID,
    #selecting: _f$selecting,
    #selectedIDs: _f$selectedIDs,
    #forwarding: _f$forwarding,
    #searching: _f$searching,
    #searchQuery: _f$searchQuery,
    #searchResults: _f$searchResults,
    #searchIndex: _f$searchIndex,
  };

  static ChatState _instantiate(DecodingData data) {
    return ChatState(
      status: data.dec(_f$status),
      chat: data.dec(_f$chat),
      messages: data.dec(_f$messages),
      reply: data.dec(_f$reply),
      editing: data.dec(_f$editing),
      unreadFromID: data.dec(_f$unreadFromID),
      selecting: data.dec(_f$selecting),
      selectedIDs: data.dec(_f$selectedIDs),
      forwarding: data.dec(_f$forwarding),
      searching: data.dec(_f$searching),
      searchQuery: data.dec(_f$searchQuery),
      searchResults: data.dec(_f$searchResults),
      searchIndex: data.dec(_f$searchIndex),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatState>(map);
  }

  static ChatState fromJson(String json) {
    return ensureInitialized().decodeJson<ChatState>(json);
  }
}

mixin ChatStateMappable {
  String toJson() {
    return ChatStateMapper.ensureInitialized().encodeJson<ChatState>(
      this as ChatState,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatStateMapper.ensureInitialized().encodeMap<ChatState>(
      this as ChatState,
    );
  }

  ChatStateCopyWith<ChatState, ChatState, ChatState> get copyWith =>
      _ChatStateCopyWithImpl<ChatState, ChatState>(
        this as ChatState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatStateMapper.ensureInitialized().stringifyValue(
      this as ChatState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatStateMapper.ensureInitialized().equalsValue(
      this as ChatState,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatStateMapper.ensureInitialized().hashValue(this as ChatState);
  }
}

extension ChatStateValueCopy<$R, $Out> on ObjectCopyWith<$R, ChatState, $Out> {
  ChatStateCopyWith<$R, ChatState, $Out> get $asChatState =>
      $base.as((v, t, t2) => _ChatStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatStateCopyWith<$R, $In extends ChatState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  models.ChatCopyWith<$R, models.Chat, models.Chat>? get chat;
  ListCopyWith<
    $R,
    models.Message,
    models.MessageCopyWith<$R, models.Message, models.Message>
  >
  get messages;
  models.MessageCopyWith<$R, models.Message, models.Message>? get reply;
  models.MessageCopyWith<$R, models.Message, models.Message>? get editing;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get selectedIDs;
  ListCopyWith<
    $R,
    models.Message,
    models.MessageCopyWith<$R, models.Message, models.Message>
  >
  get forwarding;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get searchResults;
  $R call({
    Status? status,
    models.Chat? chat,
    List<models.Message>? messages,
    models.Message? reply,
    models.Message? editing,
    String? unreadFromID,
    bool? selecting,
    List<String>? selectedIDs,
    List<models.Message>? forwarding,
    bool? searching,
    String? searchQuery,
    List<String>? searchResults,
    int? searchIndex,
  });
  ChatStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatState, $Out>
    implements ChatStateCopyWith<$R, ChatState, $Out> {
  _ChatStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatState> $mapper =
      ChatStateMapper.ensureInitialized();
  @override
  models.ChatCopyWith<$R, models.Chat, models.Chat>? get chat =>
      $value.chat?.copyWith.$chain((v) => call(chat: v));
  @override
  ListCopyWith<
    $R,
    models.Message,
    models.MessageCopyWith<$R, models.Message, models.Message>
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  models.MessageCopyWith<$R, models.Message, models.Message>? get reply =>
      $value.reply?.copyWith.$chain((v) => call(reply: v));
  @override
  models.MessageCopyWith<$R, models.Message, models.Message>? get editing =>
      $value.editing?.copyWith.$chain((v) => call(editing: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get selectedIDs => ListCopyWith(
    $value.selectedIDs,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(selectedIDs: v),
  );
  @override
  ListCopyWith<
    $R,
    models.Message,
    models.MessageCopyWith<$R, models.Message, models.Message>
  >
  get forwarding => ListCopyWith(
    $value.forwarding,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(forwarding: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get searchResults => ListCopyWith(
    $value.searchResults,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(searchResults: v),
  );
  @override
  $R call({
    Status? status,
    Object? chat = $none,
    List<models.Message>? messages,
    Object? reply = $none,
    Object? editing = $none,
    Object? unreadFromID = $none,
    bool? selecting,
    List<String>? selectedIDs,
    List<models.Message>? forwarding,
    bool? searching,
    String? searchQuery,
    List<String>? searchResults,
    int? searchIndex,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (chat != $none) #chat: chat,
      if (messages != null) #messages: messages,
      if (reply != $none) #reply: reply,
      if (editing != $none) #editing: editing,
      if (unreadFromID != $none) #unreadFromID: unreadFromID,
      if (selecting != null) #selecting: selecting,
      if (selectedIDs != null) #selectedIDs: selectedIDs,
      if (forwarding != null) #forwarding: forwarding,
      if (searching != null) #searching: searching,
      if (searchQuery != null) #searchQuery: searchQuery,
      if (searchResults != null) #searchResults: searchResults,
      if (searchIndex != null) #searchIndex: searchIndex,
    }),
  );
  @override
  ChatState $make(CopyWithData data) => ChatState(
    status: data.get(#status, or: $value.status),
    chat: data.get(#chat, or: $value.chat),
    messages: data.get(#messages, or: $value.messages),
    reply: data.get(#reply, or: $value.reply),
    editing: data.get(#editing, or: $value.editing),
    unreadFromID: data.get(#unreadFromID, or: $value.unreadFromID),
    selecting: data.get(#selecting, or: $value.selecting),
    selectedIDs: data.get(#selectedIDs, or: $value.selectedIDs),
    forwarding: data.get(#forwarding, or: $value.forwarding),
    searching: data.get(#searching, or: $value.searching),
    searchQuery: data.get(#searchQuery, or: $value.searchQuery),
    searchResults: data.get(#searchResults, or: $value.searchResults),
    searchIndex: data.get(#searchIndex, or: $value.searchIndex),
  );

  @override
  ChatStateCopyWith<$R2, ChatState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

