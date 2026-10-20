// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chats_state.dart';

class ChatsStateMapper extends ClassMapperBase<ChatsState> {
  ChatsStateMapper._();

  static ChatsStateMapper? _instance;
  static ChatsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatsStateMapper._());
      models.ChatMapper.ensureInitialized();
      models.ChatFolderMapper.ensureInitialized();
      models.ChatMemberMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatsState';

  static Status _$status(ChatsState v) => v.status;
  static const Field<ChatsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static int _$offlineNotice(ChatsState v) => v.offlineNotice;
  static const Field<ChatsState, int> _f$offlineNotice = Field(
    'offlineNotice',
    _$offlineNotice,
    opt: true,
    def: 0,
  );
  static int _$pinnedLimitNotice(ChatsState v) => v.pinnedLimitNotice;
  static const Field<ChatsState, int> _f$pinnedLimitNotice = Field(
    'pinnedLimitNotice',
    _$pinnedLimitNotice,
    opt: true,
    def: 0,
  );
  static bool _$notificationsMissing(ChatsState v) => v.notificationsMissing;
  static const Field<ChatsState, bool> _f$notificationsMissing = Field(
    'notificationsMissing',
    _$notificationsMissing,
    opt: true,
    def: false,
  );
  static bool _$notificationsBannerDismissed(ChatsState v) =>
      v.notificationsBannerDismissed;
  static const Field<ChatsState, bool> _f$notificationsBannerDismissed = Field(
    'notificationsBannerDismissed',
    _$notificationsBannerDismissed,
    opt: true,
    def: false,
  );
  static bool _$demo(ChatsState v) => v.demo;
  static const Field<ChatsState, bool> _f$demo = Field(
    'demo',
    _$demo,
    opt: true,
    def: false,
  );
  static List<models.Chat> _$chats(ChatsState v) => v.chats;
  static const Field<ChatsState, List<models.Chat>> _f$chats = Field(
    'chats',
    _$chats,
    opt: true,
    def: const [],
  );
  static List<models.ChatFolder> _$folders(ChatsState v) => v.folders;
  static const Field<ChatsState, List<models.ChatFolder>> _f$folders = Field(
    'folders',
    _$folders,
    opt: true,
    def: const [],
  );
  static int _$folderIndex(ChatsState v) => v.folderIndex;
  static const Field<ChatsState, int> _f$folderIndex = Field(
    'folderIndex',
    _$folderIndex,
    opt: true,
    def: 0,
  );
  static String _$query(ChatsState v) => v.query;
  static const Field<ChatsState, String> _f$query = Field(
    'query',
    _$query,
    opt: true,
    def: '',
  );
  static UsersSearchStatus _$globalStatus(ChatsState v) => v.globalStatus;
  static const Field<ChatsState, UsersSearchStatus> _f$globalStatus = Field(
    'globalStatus',
    _$globalStatus,
    opt: true,
    def: UsersSearchStatus.idle,
  );
  static List<models.ChatMember> _$globalResults(ChatsState v) =>
      v.globalResults;
  static const Field<ChatsState, List<models.ChatMember>> _f$globalResults =
      Field('globalResults', _$globalResults, opt: true, def: const []);
  static List<models.Chat> _$globalChats(ChatsState v) => v.globalChats;
  static const Field<ChatsState, List<models.Chat>> _f$globalChats = Field(
    'globalChats',
    _$globalChats,
    opt: true,
    def: const [],
  );
  static Map<String, String> _$hiddenHashByHex(ChatsState v) =>
      v.hiddenHashByHex;
  static const Field<ChatsState, Map<String, String>> _f$hiddenHashByHex =
      Field('hiddenHashByHex', _$hiddenHashByHex, opt: true, def: const {});
  static Set<String> _$revealedHex(ChatsState v) => v.revealedHex;
  static const Field<ChatsState, Set<String>> _f$revealedHex = Field(
    'revealedHex',
    _$revealedHex,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<ChatsState> fields = const {
    #status: _f$status,
    #offlineNotice: _f$offlineNotice,
    #pinnedLimitNotice: _f$pinnedLimitNotice,
    #notificationsMissing: _f$notificationsMissing,
    #notificationsBannerDismissed: _f$notificationsBannerDismissed,
    #demo: _f$demo,
    #chats: _f$chats,
    #folders: _f$folders,
    #folderIndex: _f$folderIndex,
    #query: _f$query,
    #globalStatus: _f$globalStatus,
    #globalResults: _f$globalResults,
    #globalChats: _f$globalChats,
    #hiddenHashByHex: _f$hiddenHashByHex,
    #revealedHex: _f$revealedHex,
  };

  static ChatsState _instantiate(DecodingData data) {
    return ChatsState(
      status: data.dec(_f$status),
      offlineNotice: data.dec(_f$offlineNotice),
      pinnedLimitNotice: data.dec(_f$pinnedLimitNotice),
      notificationsMissing: data.dec(_f$notificationsMissing),
      notificationsBannerDismissed: data.dec(_f$notificationsBannerDismissed),
      demo: data.dec(_f$demo),
      chats: data.dec(_f$chats),
      folders: data.dec(_f$folders),
      folderIndex: data.dec(_f$folderIndex),
      query: data.dec(_f$query),
      globalStatus: data.dec(_f$globalStatus),
      globalResults: data.dec(_f$globalResults),
      globalChats: data.dec(_f$globalChats),
      hiddenHashByHex: data.dec(_f$hiddenHashByHex),
      revealedHex: data.dec(_f$revealedHex),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatsState>(map);
  }

  static ChatsState fromJson(String json) {
    return ensureInitialized().decodeJson<ChatsState>(json);
  }
}

mixin ChatsStateMappable {
  String toJson() {
    return ChatsStateMapper.ensureInitialized().encodeJson<ChatsState>(
      this as ChatsState,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatsStateMapper.ensureInitialized().encodeMap<ChatsState>(
      this as ChatsState,
    );
  }

  ChatsStateCopyWith<ChatsState, ChatsState, ChatsState> get copyWith =>
      _ChatsStateCopyWithImpl<ChatsState, ChatsState>(
        this as ChatsState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatsStateMapper.ensureInitialized().stringifyValue(
      this as ChatsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatsStateMapper.ensureInitialized().equalsValue(
      this as ChatsState,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatsStateMapper.ensureInitialized().hashValue(this as ChatsState);
  }
}

extension ChatsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatsState, $Out> {
  ChatsStateCopyWith<$R, ChatsState, $Out> get $asChatsState =>
      $base.as((v, t, t2) => _ChatsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatsStateCopyWith<$R, $In extends ChatsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    models.Chat,
    models.ChatCopyWith<$R, models.Chat, models.Chat>
  >
  get chats;
  ListCopyWith<
    $R,
    models.ChatFolder,
    models.ChatFolderCopyWith<$R, models.ChatFolder, models.ChatFolder>
  >
  get folders;
  ListCopyWith<
    $R,
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get globalResults;
  ListCopyWith<
    $R,
    models.Chat,
    models.ChatCopyWith<$R, models.Chat, models.Chat>
  >
  get globalChats;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get hiddenHashByHex;
  $R call({
    Status? status,
    int? offlineNotice,
    int? pinnedLimitNotice,
    bool? notificationsMissing,
    bool? notificationsBannerDismissed,
    bool? demo,
    List<models.Chat>? chats,
    List<models.ChatFolder>? folders,
    int? folderIndex,
    String? query,
    UsersSearchStatus? globalStatus,
    List<models.ChatMember>? globalResults,
    List<models.Chat>? globalChats,
    Map<String, String>? hiddenHashByHex,
    Set<String>? revealedHex,
  });
  ChatsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatsState, $Out>
    implements ChatsStateCopyWith<$R, ChatsState, $Out> {
  _ChatsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatsState> $mapper =
      ChatsStateMapper.ensureInitialized();
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
    models.ChatMember,
    models.ChatMemberCopyWith<$R, models.ChatMember, models.ChatMember>
  >
  get globalResults => ListCopyWith(
    $value.globalResults,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(globalResults: v),
  );
  @override
  ListCopyWith<
    $R,
    models.Chat,
    models.ChatCopyWith<$R, models.Chat, models.Chat>
  >
  get globalChats => ListCopyWith(
    $value.globalChats,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(globalChats: v),
  );
  @override
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get hiddenHashByHex => MapCopyWith(
    $value.hiddenHashByHex,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(hiddenHashByHex: v),
  );
  @override
  $R call({
    Status? status,
    int? offlineNotice,
    int? pinnedLimitNotice,
    bool? notificationsMissing,
    bool? notificationsBannerDismissed,
    bool? demo,
    List<models.Chat>? chats,
    List<models.ChatFolder>? folders,
    int? folderIndex,
    String? query,
    UsersSearchStatus? globalStatus,
    List<models.ChatMember>? globalResults,
    List<models.Chat>? globalChats,
    Map<String, String>? hiddenHashByHex,
    Set<String>? revealedHex,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (offlineNotice != null) #offlineNotice: offlineNotice,
      if (pinnedLimitNotice != null) #pinnedLimitNotice: pinnedLimitNotice,
      if (notificationsMissing != null)
        #notificationsMissing: notificationsMissing,
      if (notificationsBannerDismissed != null)
        #notificationsBannerDismissed: notificationsBannerDismissed,
      if (demo != null) #demo: demo,
      if (chats != null) #chats: chats,
      if (folders != null) #folders: folders,
      if (folderIndex != null) #folderIndex: folderIndex,
      if (query != null) #query: query,
      if (globalStatus != null) #globalStatus: globalStatus,
      if (globalResults != null) #globalResults: globalResults,
      if (globalChats != null) #globalChats: globalChats,
      if (hiddenHashByHex != null) #hiddenHashByHex: hiddenHashByHex,
      if (revealedHex != null) #revealedHex: revealedHex,
    }),
  );
  @override
  ChatsState $make(CopyWithData data) => ChatsState(
    status: data.get(#status, or: $value.status),
    offlineNotice: data.get(#offlineNotice, or: $value.offlineNotice),
    pinnedLimitNotice: data.get(
      #pinnedLimitNotice,
      or: $value.pinnedLimitNotice,
    ),
    notificationsMissing: data.get(
      #notificationsMissing,
      or: $value.notificationsMissing,
    ),
    notificationsBannerDismissed: data.get(
      #notificationsBannerDismissed,
      or: $value.notificationsBannerDismissed,
    ),
    demo: data.get(#demo, or: $value.demo),
    chats: data.get(#chats, or: $value.chats),
    folders: data.get(#folders, or: $value.folders),
    folderIndex: data.get(#folderIndex, or: $value.folderIndex),
    query: data.get(#query, or: $value.query),
    globalStatus: data.get(#globalStatus, or: $value.globalStatus),
    globalResults: data.get(#globalResults, or: $value.globalResults),
    globalChats: data.get(#globalChats, or: $value.globalChats),
    hiddenHashByHex: data.get(#hiddenHashByHex, or: $value.hiddenHashByHex),
    revealedHex: data.get(#revealedHex, or: $value.revealedHex),
  );

  @override
  ChatsStateCopyWith<$R2, ChatsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

