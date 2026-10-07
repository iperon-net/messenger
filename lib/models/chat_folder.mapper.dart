// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_folder.dart';

class ChatFolderMapper extends ClassMapperBase<ChatFolder> {
  ChatFolderMapper._();

  static ChatFolderMapper? _instance;
  static ChatFolderMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatFolderMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatFolder';

  static String _$id(ChatFolder v) => v.id;
  static const Field<ChatFolder, String> _f$id = Field('id', _$id);
  static String _$title(ChatFolder v) => v.title;
  static const Field<ChatFolder, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
    def: '',
  );
  static bool _$isAll(ChatFolder v) => v.isAll;
  static const Field<ChatFolder, bool> _f$isAll = Field(
    'isAll',
    _$isAll,
    opt: true,
    def: false,
  );
  static bool _$includeContacts(ChatFolder v) => v.includeContacts;
  static const Field<ChatFolder, bool> _f$includeContacts = Field(
    'includeContacts',
    _$includeContacts,
    opt: true,
    def: false,
  );
  static bool _$includeNonContacts(ChatFolder v) => v.includeNonContacts;
  static const Field<ChatFolder, bool> _f$includeNonContacts = Field(
    'includeNonContacts',
    _$includeNonContacts,
    opt: true,
    def: false,
  );
  static bool _$includeGroups(ChatFolder v) => v.includeGroups;
  static const Field<ChatFolder, bool> _f$includeGroups = Field(
    'includeGroups',
    _$includeGroups,
    opt: true,
    def: false,
  );
  static bool _$includeChannels(ChatFolder v) => v.includeChannels;
  static const Field<ChatFolder, bool> _f$includeChannels = Field(
    'includeChannels',
    _$includeChannels,
    opt: true,
    def: false,
  );
  static bool _$includeCommunities(ChatFolder v) => v.includeCommunities;
  static const Field<ChatFolder, bool> _f$includeCommunities = Field(
    'includeCommunities',
    _$includeCommunities,
    opt: true,
    def: false,
  );
  static List<String> _$includeChatIDs(ChatFolder v) => v.includeChatIDs;
  static const Field<ChatFolder, List<String>> _f$includeChatIDs = Field(
    'includeChatIDs',
    _$includeChatIDs,
    opt: true,
    def: const [],
  );
  static List<String> _$excludeChatIDs(ChatFolder v) => v.excludeChatIDs;
  static const Field<ChatFolder, List<String>> _f$excludeChatIDs = Field(
    'excludeChatIDs',
    _$excludeChatIDs,
    opt: true,
    def: const [],
  );
  static bool _$excludeMuted(ChatFolder v) => v.excludeMuted;
  static const Field<ChatFolder, bool> _f$excludeMuted = Field(
    'excludeMuted',
    _$excludeMuted,
    opt: true,
    def: false,
  );
  static bool _$excludeRead(ChatFolder v) => v.excludeRead;
  static const Field<ChatFolder, bool> _f$excludeRead = Field(
    'excludeRead',
    _$excludeRead,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ChatFolder> fields = const {
    #id: _f$id,
    #title: _f$title,
    #isAll: _f$isAll,
    #includeContacts: _f$includeContacts,
    #includeNonContacts: _f$includeNonContacts,
    #includeGroups: _f$includeGroups,
    #includeChannels: _f$includeChannels,
    #includeCommunities: _f$includeCommunities,
    #includeChatIDs: _f$includeChatIDs,
    #excludeChatIDs: _f$excludeChatIDs,
    #excludeMuted: _f$excludeMuted,
    #excludeRead: _f$excludeRead,
  };

  static ChatFolder _instantiate(DecodingData data) {
    return ChatFolder(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      isAll: data.dec(_f$isAll),
      includeContacts: data.dec(_f$includeContacts),
      includeNonContacts: data.dec(_f$includeNonContacts),
      includeGroups: data.dec(_f$includeGroups),
      includeChannels: data.dec(_f$includeChannels),
      includeCommunities: data.dec(_f$includeCommunities),
      includeChatIDs: data.dec(_f$includeChatIDs),
      excludeChatIDs: data.dec(_f$excludeChatIDs),
      excludeMuted: data.dec(_f$excludeMuted),
      excludeRead: data.dec(_f$excludeRead),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatFolder fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatFolder>(map);
  }

  static ChatFolder fromJson(String json) {
    return ensureInitialized().decodeJson<ChatFolder>(json);
  }
}

mixin ChatFolderMappable {
  String toJson() {
    return ChatFolderMapper.ensureInitialized().encodeJson<ChatFolder>(
      this as ChatFolder,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatFolderMapper.ensureInitialized().encodeMap<ChatFolder>(
      this as ChatFolder,
    );
  }

  ChatFolderCopyWith<ChatFolder, ChatFolder, ChatFolder> get copyWith =>
      _ChatFolderCopyWithImpl<ChatFolder, ChatFolder>(
        this as ChatFolder,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatFolderMapper.ensureInitialized().stringifyValue(
      this as ChatFolder,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatFolderMapper.ensureInitialized().equalsValue(
      this as ChatFolder,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatFolderMapper.ensureInitialized().hashValue(this as ChatFolder);
  }
}

extension ChatFolderValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatFolder, $Out> {
  ChatFolderCopyWith<$R, ChatFolder, $Out> get $asChatFolder =>
      $base.as((v, t, t2) => _ChatFolderCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatFolderCopyWith<$R, $In extends ChatFolder, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get includeChatIDs;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get excludeChatIDs;
  $R call({
    String? id,
    String? title,
    bool? isAll,
    bool? includeContacts,
    bool? includeNonContacts,
    bool? includeGroups,
    bool? includeChannels,
    bool? includeCommunities,
    List<String>? includeChatIDs,
    List<String>? excludeChatIDs,
    bool? excludeMuted,
    bool? excludeRead,
  });
  ChatFolderCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatFolderCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatFolder, $Out>
    implements ChatFolderCopyWith<$R, ChatFolder, $Out> {
  _ChatFolderCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatFolder> $mapper =
      ChatFolderMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get includeChatIDs => ListCopyWith(
    $value.includeChatIDs,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(includeChatIDs: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get excludeChatIDs => ListCopyWith(
    $value.excludeChatIDs,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(excludeChatIDs: v),
  );
  @override
  $R call({
    String? id,
    String? title,
    bool? isAll,
    bool? includeContacts,
    bool? includeNonContacts,
    bool? includeGroups,
    bool? includeChannels,
    bool? includeCommunities,
    List<String>? includeChatIDs,
    List<String>? excludeChatIDs,
    bool? excludeMuted,
    bool? excludeRead,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (isAll != null) #isAll: isAll,
      if (includeContacts != null) #includeContacts: includeContacts,
      if (includeNonContacts != null) #includeNonContacts: includeNonContacts,
      if (includeGroups != null) #includeGroups: includeGroups,
      if (includeChannels != null) #includeChannels: includeChannels,
      if (includeCommunities != null) #includeCommunities: includeCommunities,
      if (includeChatIDs != null) #includeChatIDs: includeChatIDs,
      if (excludeChatIDs != null) #excludeChatIDs: excludeChatIDs,
      if (excludeMuted != null) #excludeMuted: excludeMuted,
      if (excludeRead != null) #excludeRead: excludeRead,
    }),
  );
  @override
  ChatFolder $make(CopyWithData data) => ChatFolder(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    isAll: data.get(#isAll, or: $value.isAll),
    includeContacts: data.get(#includeContacts, or: $value.includeContacts),
    includeNonContacts: data.get(
      #includeNonContacts,
      or: $value.includeNonContacts,
    ),
    includeGroups: data.get(#includeGroups, or: $value.includeGroups),
    includeChannels: data.get(#includeChannels, or: $value.includeChannels),
    includeCommunities: data.get(
      #includeCommunities,
      or: $value.includeCommunities,
    ),
    includeChatIDs: data.get(#includeChatIDs, or: $value.includeChatIDs),
    excludeChatIDs: data.get(#excludeChatIDs, or: $value.excludeChatIDs),
    excludeMuted: data.get(#excludeMuted, or: $value.excludeMuted),
    excludeRead: data.get(#excludeRead, or: $value.excludeRead),
  );

  @override
  ChatFolderCopyWith<$R2, ChatFolder, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatFolderCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

