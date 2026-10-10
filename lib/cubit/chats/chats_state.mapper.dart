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

  @override
  final MappableFields<ChatsState> fields = const {
    #status: _f$status,
    #offlineNotice: _f$offlineNotice,
    #notificationsMissing: _f$notificationsMissing,
    #notificationsBannerDismissed: _f$notificationsBannerDismissed,
    #demo: _f$demo,
    #chats: _f$chats,
    #folders: _f$folders,
    #folderIndex: _f$folderIndex,
    #query: _f$query,
  };

  static ChatsState _instantiate(DecodingData data) {
    return ChatsState(
      status: data.dec(_f$status),
      offlineNotice: data.dec(_f$offlineNotice),
      notificationsMissing: data.dec(_f$notificationsMissing),
      notificationsBannerDismissed: data.dec(_f$notificationsBannerDismissed),
      demo: data.dec(_f$demo),
      chats: data.dec(_f$chats),
      folders: data.dec(_f$folders),
      folderIndex: data.dec(_f$folderIndex),
      query: data.dec(_f$query),
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
  $R call({
    Status? status,
    int? offlineNotice,
    bool? notificationsMissing,
    bool? notificationsBannerDismissed,
    bool? demo,
    List<models.Chat>? chats,
    List<models.ChatFolder>? folders,
    int? folderIndex,
    String? query,
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
  $R call({
    Status? status,
    int? offlineNotice,
    bool? notificationsMissing,
    bool? notificationsBannerDismissed,
    bool? demo,
    List<models.Chat>? chats,
    List<models.ChatFolder>? folders,
    int? folderIndex,
    String? query,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (offlineNotice != null) #offlineNotice: offlineNotice,
      if (notificationsMissing != null)
        #notificationsMissing: notificationsMissing,
      if (notificationsBannerDismissed != null)
        #notificationsBannerDismissed: notificationsBannerDismissed,
      if (demo != null) #demo: demo,
      if (chats != null) #chats: chats,
      if (folders != null) #folders: folders,
      if (folderIndex != null) #folderIndex: folderIndex,
      if (query != null) #query: query,
    }),
  );
  @override
  ChatsState $make(CopyWithData data) => ChatsState(
    status: data.get(#status, or: $value.status),
    offlineNotice: data.get(#offlineNotice, or: $value.offlineNotice),
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
  );

  @override
  ChatsStateCopyWith<$R2, ChatsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

