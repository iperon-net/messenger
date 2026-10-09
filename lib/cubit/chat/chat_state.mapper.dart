// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_state.dart';

class ChatCommentsBlockMapper extends EnumMapper<ChatCommentsBlock> {
  ChatCommentsBlockMapper._();

  static ChatCommentsBlockMapper? _instance;
  static ChatCommentsBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatCommentsBlockMapper._());
    }
    return _instance!;
  }

  static ChatCommentsBlock fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ChatCommentsBlock decode(dynamic value) {
    switch (value) {
      case r'none':
        return ChatCommentsBlock.none;
      case r'closed':
        return ChatCommentsBlock.closed;
      case r'subscribe':
        return ChatCommentsBlock.subscribe;
      case r'wait':
        return ChatCommentsBlock.wait;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ChatCommentsBlock self) {
    switch (self) {
      case ChatCommentsBlock.none:
        return r'none';
      case ChatCommentsBlock.closed:
        return r'closed';
      case ChatCommentsBlock.subscribe:
        return r'subscribe';
      case ChatCommentsBlock.wait:
        return r'wait';
    }
  }
}

extension ChatCommentsBlockMapperExtension on ChatCommentsBlock {
  String toValue() {
    ChatCommentsBlockMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ChatCommentsBlock>(this) as String;
  }
}

class ChatStateMapper extends ClassMapperBase<ChatState> {
  ChatStateMapper._();

  static ChatStateMapper? _instance;
  static ChatStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatStateMapper._());
      models.ChatMapper.ensureInitialized();
      models.MessageMapper.ensureInitialized();
      models.MessageQuoteMapper.ensureInitialized();
      models.ChatMemberMapper.ensureInitialized();
      ChatCommentsBlockMapper.ensureInitialized();
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
  static List<models.Chat> _$communityChats(ChatState v) => v.communityChats;
  static const Field<ChatState, List<models.Chat>> _f$communityChats = Field(
    'communityChats',
    _$communityChats,
    opt: true,
    def: const [],
  );
  static models.Chat? _$community(ChatState v) => v.community;
  static const Field<ChatState, models.Chat> _f$community = Field(
    'community',
    _$community,
    opt: true,
  );
  static models.Message? _$reply(ChatState v) => v.reply;
  static const Field<ChatState, models.Message> _f$reply = Field(
    'reply',
    _$reply,
    opt: true,
  );
  static models.MessageQuote? _$replyQuote(ChatState v) => v.replyQuote;
  static const Field<ChatState, models.MessageQuote> _f$replyQuote = Field(
    'replyQuote',
    _$replyQuote,
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
  static List<models.Message> _$scheduled(ChatState v) => v.scheduled;
  static const Field<ChatState, List<models.Message>> _f$scheduled = Field(
    'scheduled',
    _$scheduled,
    opt: true,
    def: const [],
  );
  static bool _$linkPreviewDisabled(ChatState v) => v.linkPreviewDisabled;
  static const Field<ChatState, bool> _f$linkPreviewDisabled = Field(
    'linkPreviewDisabled',
    _$linkPreviewDisabled,
    opt: true,
    def: false,
  );
  static List<models.ChatMember> _$members(ChatState v) => v.members;
  static const Field<ChatState, List<models.ChatMember>> _f$members = Field(
    'members',
    _$members,
    opt: true,
    def: const [],
  );
  static List<models.ChatMember> _$memberPage(ChatState v) => v.memberPage;
  static const Field<ChatState, List<models.ChatMember>> _f$memberPage = Field(
    'memberPage',
    _$memberPage,
    opt: true,
    def: const [],
  );
  static bool _$memberPageMore(ChatState v) => v.memberPageMore;
  static const Field<ChatState, bool> _f$memberPageMore = Field(
    'memberPageMore',
    _$memberPageMore,
    opt: true,
    def: false,
  );
  static bool _$memberPageLoading(ChatState v) => v.memberPageLoading;
  static const Field<ChatState, bool> _f$memberPageLoading = Field(
    'memberPageLoading',
    _$memberPageLoading,
    opt: true,
    def: false,
  );
  static int _$membersTotal(ChatState v) => v.membersTotal;
  static const Field<ChatState, int> _f$membersTotal = Field(
    'membersTotal',
    _$membersTotal,
    opt: true,
    def: 0,
  );
  static List<models.ChatMember> _$banned(ChatState v) => v.banned;
  static const Field<ChatState, List<models.ChatMember>> _f$banned = Field(
    'banned',
    _$banned,
    opt: true,
    def: const [],
  );
  static int _$slowModeLeft(ChatState v) => v.slowModeLeft;
  static const Field<ChatState, int> _f$slowModeLeft = Field(
    'slowModeLeft',
    _$slowModeLeft,
    opt: true,
    def: 0,
  );
  static List<String> _$commentsClosedIDs(ChatState v) => v.commentsClosedIDs;
  static const Field<ChatState, List<String>> _f$commentsClosedIDs = Field(
    'commentsClosedIDs',
    _$commentsClosedIDs,
    opt: true,
    def: const [],
  );
  static ChatCommentsBlock _$commentsBlock(ChatState v) => v.commentsBlock;
  static const Field<ChatState, ChatCommentsBlock> _f$commentsBlock = Field(
    'commentsBlock',
    _$commentsBlock,
    opt: true,
    def: ChatCommentsBlock.none,
  );
  static DateTime? _$commentsWaitUntil(ChatState v) => v.commentsWaitUntil;
  static const Field<ChatState, DateTime> _f$commentsWaitUntil = Field(
    'commentsWaitUntil',
    _$commentsWaitUntil,
    opt: true,
  );
  static bool _$newcomerRestricted(ChatState v) => v.newcomerRestricted;
  static const Field<ChatState, bool> _f$newcomerRestricted = Field(
    'newcomerRestricted',
    _$newcomerRestricted,
    opt: true,
    def: false,
  );
  static DateTime? _$newcomerUntil(ChatState v) => v.newcomerUntil;
  static const Field<ChatState, DateTime> _f$newcomerUntil = Field(
    'newcomerUntil',
    _$newcomerUntil,
    opt: true,
  );

  @override
  final MappableFields<ChatState> fields = const {
    #status: _f$status,
    #chat: _f$chat,
    #messages: _f$messages,
    #communityChats: _f$communityChats,
    #community: _f$community,
    #reply: _f$reply,
    #replyQuote: _f$replyQuote,
    #editing: _f$editing,
    #unreadFromID: _f$unreadFromID,
    #selecting: _f$selecting,
    #selectedIDs: _f$selectedIDs,
    #forwarding: _f$forwarding,
    #searching: _f$searching,
    #searchQuery: _f$searchQuery,
    #searchResults: _f$searchResults,
    #searchIndex: _f$searchIndex,
    #scheduled: _f$scheduled,
    #linkPreviewDisabled: _f$linkPreviewDisabled,
    #members: _f$members,
    #memberPage: _f$memberPage,
    #memberPageMore: _f$memberPageMore,
    #memberPageLoading: _f$memberPageLoading,
    #membersTotal: _f$membersTotal,
    #banned: _f$banned,
    #slowModeLeft: _f$slowModeLeft,
    #commentsClosedIDs: _f$commentsClosedIDs,
    #commentsBlock: _f$commentsBlock,
    #commentsWaitUntil: _f$commentsWaitUntil,
    #newcomerRestricted: _f$newcomerRestricted,
    #newcomerUntil: _f$newcomerUntil,
  };

  static ChatState _instantiate(DecodingData data) {
    return ChatState(
      status: data.dec(_f$status),
      chat: data.dec(_f$chat),
      messages: data.dec(_f$messages),
      communityChats: data.dec(_f$communityChats),
      community: data.dec(_f$community),
      reply: data.dec(_f$reply),
      replyQuote: data.dec(_f$replyQuote),
      editing: data.dec(_f$editing),
      unreadFromID: data.dec(_f$unreadFromID),
      selecting: data.dec(_f$selecting),
      selectedIDs: data.dec(_f$selectedIDs),
      forwarding: data.dec(_f$forwarding),
      searching: data.dec(_f$searching),
      searchQuery: data.dec(_f$searchQuery),
      searchResults: data.dec(_f$searchResults),
      searchIndex: data.dec(_f$searchIndex),
      scheduled: data.dec(_f$scheduled),
      linkPreviewDisabled: data.dec(_f$linkPreviewDisabled),
      members: data.dec(_f$members),
      memberPage: data.dec(_f$memberPage),
      memberPageMore: data.dec(_f$memberPageMore),
      memberPageLoading: data.dec(_f$memberPageLoading),
      membersTotal: data.dec(_f$membersTotal),
      banned: data.dec(_f$banned),
      slowModeLeft: data.dec(_f$slowModeLeft),
      commentsClosedIDs: data.dec(_f$commentsClosedIDs),
      commentsBlock: data.dec(_f$commentsBlock),
      commentsWaitUntil: data.dec(_f$commentsWaitUntil),
      newcomerRestricted: data.dec(_f$newcomerRestricted),
      newcomerUntil: data.dec(_f$newcomerUntil),
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
  ListCopyWith<
    $R,
    models.Chat,
    models.ChatCopyWith<$R, models.Chat, models.Chat>
  >
  get communityChats;
  models.ChatCopyWith<$R, models.Chat, models.Chat>? get community;
  models.MessageCopyWith<$R, models.Message, models.Message>? get reply;
  models.MessageQuoteCopyWith<$R, models.MessageQuote, models.MessageQuote>?
  get replyQuote;
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
  ListCopyWith<
    $R,
    models.Message,
    models.MessageCopyWith<$R, models.Message, models.Message>
  >
  get scheduled;
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get members;
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get memberPage;
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get banned;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get commentsClosedIDs;
  $R call({
    Status? status,
    models.Chat? chat,
    List<models.Message>? messages,
    List<models.Chat>? communityChats,
    models.Chat? community,
    models.Message? reply,
    models.MessageQuote? replyQuote,
    models.Message? editing,
    String? unreadFromID,
    bool? selecting,
    List<String>? selectedIDs,
    List<models.Message>? forwarding,
    bool? searching,
    String? searchQuery,
    List<String>? searchResults,
    int? searchIndex,
    List<models.Message>? scheduled,
    bool? linkPreviewDisabled,
    List<models.ChatMember>? members,
    List<models.ChatMember>? memberPage,
    bool? memberPageMore,
    bool? memberPageLoading,
    int? membersTotal,
    List<models.ChatMember>? banned,
    int? slowModeLeft,
    List<String>? commentsClosedIDs,
    ChatCommentsBlock? commentsBlock,
    DateTime? commentsWaitUntil,
    bool? newcomerRestricted,
    DateTime? newcomerUntil,
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
  ListCopyWith<
    $R,
    models.Chat,
    models.ChatCopyWith<$R, models.Chat, models.Chat>
  >
  get communityChats => ListCopyWith(
    $value.communityChats,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(communityChats: v),
  );
  @override
  models.ChatCopyWith<$R, models.Chat, models.Chat>? get community =>
      $value.community?.copyWith.$chain((v) => call(community: v));
  @override
  models.MessageCopyWith<$R, models.Message, models.Message>? get reply =>
      $value.reply?.copyWith.$chain((v) => call(reply: v));
  @override
  models.MessageQuoteCopyWith<$R, models.MessageQuote, models.MessageQuote>?
  get replyQuote =>
      $value.replyQuote?.copyWith.$chain((v) => call(replyQuote: v));
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
  ListCopyWith<
    $R,
    models.Message,
    models.MessageCopyWith<$R, models.Message, models.Message>
  >
  get scheduled => ListCopyWith(
    $value.scheduled,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(scheduled: v),
  );
  @override
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get members => ListCopyWith(
    $value.members,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(members: v),
  );
  @override
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get memberPage => ListCopyWith(
    $value.memberPage,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(memberPage: v),
  );
  @override
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get banned => ListCopyWith(
    $value.banned,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(banned: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get commentsClosedIDs => ListCopyWith(
    $value.commentsClosedIDs,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(commentsClosedIDs: v),
  );
  @override
  $R call({
    Status? status,
    Object? chat = $none,
    List<models.Message>? messages,
    List<models.Chat>? communityChats,
    Object? community = $none,
    Object? reply = $none,
    Object? replyQuote = $none,
    Object? editing = $none,
    Object? unreadFromID = $none,
    bool? selecting,
    List<String>? selectedIDs,
    List<models.Message>? forwarding,
    bool? searching,
    String? searchQuery,
    List<String>? searchResults,
    int? searchIndex,
    List<models.Message>? scheduled,
    bool? linkPreviewDisabled,
    List<models.ChatMember>? members,
    List<models.ChatMember>? memberPage,
    bool? memberPageMore,
    bool? memberPageLoading,
    int? membersTotal,
    List<models.ChatMember>? banned,
    int? slowModeLeft,
    List<String>? commentsClosedIDs,
    ChatCommentsBlock? commentsBlock,
    Object? commentsWaitUntil = $none,
    bool? newcomerRestricted,
    Object? newcomerUntil = $none,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (chat != $none) #chat: chat,
      if (messages != null) #messages: messages,
      if (communityChats != null) #communityChats: communityChats,
      if (community != $none) #community: community,
      if (reply != $none) #reply: reply,
      if (replyQuote != $none) #replyQuote: replyQuote,
      if (editing != $none) #editing: editing,
      if (unreadFromID != $none) #unreadFromID: unreadFromID,
      if (selecting != null) #selecting: selecting,
      if (selectedIDs != null) #selectedIDs: selectedIDs,
      if (forwarding != null) #forwarding: forwarding,
      if (searching != null) #searching: searching,
      if (searchQuery != null) #searchQuery: searchQuery,
      if (searchResults != null) #searchResults: searchResults,
      if (searchIndex != null) #searchIndex: searchIndex,
      if (scheduled != null) #scheduled: scheduled,
      if (linkPreviewDisabled != null)
        #linkPreviewDisabled: linkPreviewDisabled,
      if (members != null) #members: members,
      if (memberPage != null) #memberPage: memberPage,
      if (memberPageMore != null) #memberPageMore: memberPageMore,
      if (memberPageLoading != null) #memberPageLoading: memberPageLoading,
      if (membersTotal != null) #membersTotal: membersTotal,
      if (banned != null) #banned: banned,
      if (slowModeLeft != null) #slowModeLeft: slowModeLeft,
      if (commentsClosedIDs != null) #commentsClosedIDs: commentsClosedIDs,
      if (commentsBlock != null) #commentsBlock: commentsBlock,
      if (commentsWaitUntil != $none) #commentsWaitUntil: commentsWaitUntil,
      if (newcomerRestricted != null) #newcomerRestricted: newcomerRestricted,
      if (newcomerUntil != $none) #newcomerUntil: newcomerUntil,
    }),
  );
  @override
  ChatState $make(CopyWithData data) => ChatState(
    status: data.get(#status, or: $value.status),
    chat: data.get(#chat, or: $value.chat),
    messages: data.get(#messages, or: $value.messages),
    communityChats: data.get(#communityChats, or: $value.communityChats),
    community: data.get(#community, or: $value.community),
    reply: data.get(#reply, or: $value.reply),
    replyQuote: data.get(#replyQuote, or: $value.replyQuote),
    editing: data.get(#editing, or: $value.editing),
    unreadFromID: data.get(#unreadFromID, or: $value.unreadFromID),
    selecting: data.get(#selecting, or: $value.selecting),
    selectedIDs: data.get(#selectedIDs, or: $value.selectedIDs),
    forwarding: data.get(#forwarding, or: $value.forwarding),
    searching: data.get(#searching, or: $value.searching),
    searchQuery: data.get(#searchQuery, or: $value.searchQuery),
    searchResults: data.get(#searchResults, or: $value.searchResults),
    searchIndex: data.get(#searchIndex, or: $value.searchIndex),
    scheduled: data.get(#scheduled, or: $value.scheduled),
    linkPreviewDisabled: data.get(
      #linkPreviewDisabled,
      or: $value.linkPreviewDisabled,
    ),
    members: data.get(#members, or: $value.members),
    memberPage: data.get(#memberPage, or: $value.memberPage),
    memberPageMore: data.get(#memberPageMore, or: $value.memberPageMore),
    memberPageLoading: data.get(
      #memberPageLoading,
      or: $value.memberPageLoading,
    ),
    membersTotal: data.get(#membersTotal, or: $value.membersTotal),
    banned: data.get(#banned, or: $value.banned),
    slowModeLeft: data.get(#slowModeLeft, or: $value.slowModeLeft),
    commentsClosedIDs: data.get(
      #commentsClosedIDs,
      or: $value.commentsClosedIDs,
    ),
    commentsBlock: data.get(#commentsBlock, or: $value.commentsBlock),
    commentsWaitUntil: data.get(
      #commentsWaitUntil,
      or: $value.commentsWaitUntil,
    ),
    newcomerRestricted: data.get(
      #newcomerRestricted,
      or: $value.newcomerRestricted,
    ),
    newcomerUntil: data.get(#newcomerUntil, or: $value.newcomerUntil),
  );

  @override
  ChatStateCopyWith<$R2, ChatState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

