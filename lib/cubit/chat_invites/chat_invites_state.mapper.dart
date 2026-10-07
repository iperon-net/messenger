// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_invites_state.dart';

class ChatInvitesStateMapper extends ClassMapperBase<ChatInvitesState> {
  ChatInvitesStateMapper._();

  static ChatInvitesStateMapper? _instance;
  static ChatInvitesStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatInvitesStateMapper._());
      models.ChatMapper.ensureInitialized();
      models.ChatInviteLinkMapper.ensureInitialized();
      models.ChatJoinRequestMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatInvitesState';

  static Status _$status(ChatInvitesState v) => v.status;
  static const Field<ChatInvitesState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static models.Chat? _$chat(ChatInvitesState v) => v.chat;
  static const Field<ChatInvitesState, models.Chat> _f$chat = Field(
    'chat',
    _$chat,
    opt: true,
  );
  static List<models.ChatInviteLink> _$links(ChatInvitesState v) => v.links;
  static const Field<ChatInvitesState, List<models.ChatInviteLink>> _f$links =
      Field('links', _$links, opt: true, def: const []);
  static List<models.ChatJoinRequest> _$requests(ChatInvitesState v) =>
      v.requests;
  static const Field<ChatInvitesState, List<models.ChatJoinRequest>>
  _f$requests = Field('requests', _$requests, opt: true, def: const []);

  @override
  final MappableFields<ChatInvitesState> fields = const {
    #status: _f$status,
    #chat: _f$chat,
    #links: _f$links,
    #requests: _f$requests,
  };

  static ChatInvitesState _instantiate(DecodingData data) {
    return ChatInvitesState(
      status: data.dec(_f$status),
      chat: data.dec(_f$chat),
      links: data.dec(_f$links),
      requests: data.dec(_f$requests),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatInvitesState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatInvitesState>(map);
  }

  static ChatInvitesState fromJson(String json) {
    return ensureInitialized().decodeJson<ChatInvitesState>(json);
  }
}

mixin ChatInvitesStateMappable {
  String toJson() {
    return ChatInvitesStateMapper.ensureInitialized()
        .encodeJson<ChatInvitesState>(this as ChatInvitesState);
  }

  Map<String, dynamic> toMap() {
    return ChatInvitesStateMapper.ensureInitialized()
        .encodeMap<ChatInvitesState>(this as ChatInvitesState);
  }

  ChatInvitesStateCopyWith<ChatInvitesState, ChatInvitesState, ChatInvitesState>
  get copyWith =>
      _ChatInvitesStateCopyWithImpl<ChatInvitesState, ChatInvitesState>(
        this as ChatInvitesState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatInvitesStateMapper.ensureInitialized().stringifyValue(
      this as ChatInvitesState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatInvitesStateMapper.ensureInitialized().equalsValue(
      this as ChatInvitesState,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatInvitesStateMapper.ensureInitialized().hashValue(
      this as ChatInvitesState,
    );
  }
}

extension ChatInvitesStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatInvitesState, $Out> {
  ChatInvitesStateCopyWith<$R, ChatInvitesState, $Out>
  get $asChatInvitesState =>
      $base.as((v, t, t2) => _ChatInvitesStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatInvitesStateCopyWith<$R, $In extends ChatInvitesState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  models.ChatCopyWith<$R, models.Chat, models.Chat>? get chat;
  ListCopyWith<
    $R,
    models.ChatInviteLink,
    models.ChatInviteLinkCopyWith<
      $R,
      models.ChatInviteLink,
      models.ChatInviteLink
    >
  >
  get links;
  ListCopyWith<
    $R,
    models.ChatJoinRequest,
    models.ChatJoinRequestCopyWith<
      $R,
      models.ChatJoinRequest,
      models.ChatJoinRequest
    >
  >
  get requests;
  $R call({
    Status? status,
    models.Chat? chat,
    List<models.ChatInviteLink>? links,
    List<models.ChatJoinRequest>? requests,
  });
  ChatInvitesStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatInvitesStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatInvitesState, $Out>
    implements ChatInvitesStateCopyWith<$R, ChatInvitesState, $Out> {
  _ChatInvitesStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatInvitesState> $mapper =
      ChatInvitesStateMapper.ensureInitialized();
  @override
  models.ChatCopyWith<$R, models.Chat, models.Chat>? get chat =>
      $value.chat?.copyWith.$chain((v) => call(chat: v));
  @override
  ListCopyWith<
    $R,
    models.ChatInviteLink,
    models.ChatInviteLinkCopyWith<
      $R,
      models.ChatInviteLink,
      models.ChatInviteLink
    >
  >
  get links => ListCopyWith(
    $value.links,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(links: v),
  );
  @override
  ListCopyWith<
    $R,
    models.ChatJoinRequest,
    models.ChatJoinRequestCopyWith<
      $R,
      models.ChatJoinRequest,
      models.ChatJoinRequest
    >
  >
  get requests => ListCopyWith(
    $value.requests,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(requests: v),
  );
  @override
  $R call({
    Status? status,
    Object? chat = $none,
    List<models.ChatInviteLink>? links,
    List<models.ChatJoinRequest>? requests,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (chat != $none) #chat: chat,
      if (links != null) #links: links,
      if (requests != null) #requests: requests,
    }),
  );
  @override
  ChatInvitesState $make(CopyWithData data) => ChatInvitesState(
    status: data.get(#status, or: $value.status),
    chat: data.get(#chat, or: $value.chat),
    links: data.get(#links, or: $value.links),
    requests: data.get(#requests, or: $value.requests),
  );

  @override
  ChatInvitesStateCopyWith<$R2, ChatInvitesState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatInvitesStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

