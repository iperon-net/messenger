// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_folders_state.dart';

class ChatFoldersStateMapper extends ClassMapperBase<ChatFoldersState> {
  ChatFoldersStateMapper._();

  static ChatFoldersStateMapper? _instance;
  static ChatFoldersStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatFoldersStateMapper._());
      models.ChatFolderMapper.ensureInitialized();
      models.ChatMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatFoldersState';

  static Status _$status(ChatFoldersState v) => v.status;
  static const Field<ChatFoldersState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static List<models.ChatFolder> _$folders(ChatFoldersState v) => v.folders;
  static const Field<ChatFoldersState, List<models.ChatFolder>> _f$folders =
      Field('folders', _$folders, opt: true, def: const []);
  static List<models.Chat> _$chats(ChatFoldersState v) => v.chats;
  static const Field<ChatFoldersState, List<models.Chat>> _f$chats = Field(
    'chats',
    _$chats,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<ChatFoldersState> fields = const {
    #status: _f$status,
    #folders: _f$folders,
    #chats: _f$chats,
  };

  static ChatFoldersState _instantiate(DecodingData data) {
    return ChatFoldersState(
      status: data.dec(_f$status),
      folders: data.dec(_f$folders),
      chats: data.dec(_f$chats),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatFoldersState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatFoldersState>(map);
  }

  static ChatFoldersState fromJson(String json) {
    return ensureInitialized().decodeJson<ChatFoldersState>(json);
  }
}

mixin ChatFoldersStateMappable {
  String toJson() {
    return ChatFoldersStateMapper.ensureInitialized()
        .encodeJson<ChatFoldersState>(this as ChatFoldersState);
  }

  Map<String, dynamic> toMap() {
    return ChatFoldersStateMapper.ensureInitialized()
        .encodeMap<ChatFoldersState>(this as ChatFoldersState);
  }

  ChatFoldersStateCopyWith<ChatFoldersState, ChatFoldersState, ChatFoldersState>
  get copyWith =>
      _ChatFoldersStateCopyWithImpl<ChatFoldersState, ChatFoldersState>(
        this as ChatFoldersState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatFoldersStateMapper.ensureInitialized().stringifyValue(
      this as ChatFoldersState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatFoldersStateMapper.ensureInitialized().equalsValue(
      this as ChatFoldersState,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatFoldersStateMapper.ensureInitialized().hashValue(
      this as ChatFoldersState,
    );
  }
}

extension ChatFoldersStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatFoldersState, $Out> {
  ChatFoldersStateCopyWith<$R, ChatFoldersState, $Out>
  get $asChatFoldersState =>
      $base.as((v, t, t2) => _ChatFoldersStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatFoldersStateCopyWith<$R, $In extends ChatFoldersState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    models.ChatFolder,
    models.ChatFolderCopyWith<$R, models.ChatFolder, models.ChatFolder>
  >
  get folders;
  ListCopyWith<
    $R,
    models.Chat,
    models.ChatCopyWith<$R, models.Chat, models.Chat>
  >
  get chats;
  $R call({
    Status? status,
    List<models.ChatFolder>? folders,
    List<models.Chat>? chats,
  });
  ChatFoldersStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatFoldersStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatFoldersState, $Out>
    implements ChatFoldersStateCopyWith<$R, ChatFoldersState, $Out> {
  _ChatFoldersStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatFoldersState> $mapper =
      ChatFoldersStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    models.ChatFolder,
    models.ChatFolderCopyWith<$R, models.ChatFolder, models.ChatFolder>
  >
  get folders => ListCopyWith(
    $value.folders,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(folders: v),
  );
  @override
  ListCopyWith<
    $R,
    models.Chat,
    models.ChatCopyWith<$R, models.Chat, models.Chat>
  >
  get chats => ListCopyWith(
    $value.chats,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(chats: v),
  );
  @override
  $R call({
    Status? status,
    List<models.ChatFolder>? folders,
    List<models.Chat>? chats,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (folders != null) #folders: folders,
      if (chats != null) #chats: chats,
    }),
  );
  @override
  ChatFoldersState $make(CopyWithData data) => ChatFoldersState(
    status: data.get(#status, or: $value.status),
    folders: data.get(#folders, or: $value.folders),
    chats: data.get(#chats, or: $value.chats),
  );

  @override
  ChatFoldersStateCopyWith<$R2, ChatFoldersState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatFoldersStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

