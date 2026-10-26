// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_storage_state.dart';

class StorageChatItemMapper extends ClassMapperBase<StorageChatItem> {
  StorageChatItemMapper._();

  static StorageChatItemMapper? _instance;
  static StorageChatItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StorageChatItemMapper._());
      ChatMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StorageChatItem';

  static Chat? _$chat(StorageChatItem v) => v.chat;
  static const Field<StorageChatItem, Chat> _f$chat = Field(
    'chat',
    _$chat,
    opt: true,
  );
  static List<String> _$chatIDs(StorageChatItem v) => v.chatIDs;
  static const Field<StorageChatItem, List<String>> _f$chatIDs = Field(
    'chatIDs',
    _$chatIDs,
    opt: true,
    def: const [],
  );
  static int _$bytes(StorageChatItem v) => v.bytes;
  static const Field<StorageChatItem, int> _f$bytes = Field(
    'bytes',
    _$bytes,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<StorageChatItem> fields = const {
    #chat: _f$chat,
    #chatIDs: _f$chatIDs,
    #bytes: _f$bytes,
  };

  static StorageChatItem _instantiate(DecodingData data) {
    return StorageChatItem(
      chat: data.dec(_f$chat),
      chatIDs: data.dec(_f$chatIDs),
      bytes: data.dec(_f$bytes),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StorageChatItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StorageChatItem>(map);
  }

  static StorageChatItem fromJson(String json) {
    return ensureInitialized().decodeJson<StorageChatItem>(json);
  }
}

mixin StorageChatItemMappable {
  String toJson() {
    return StorageChatItemMapper.ensureInitialized()
        .encodeJson<StorageChatItem>(this as StorageChatItem);
  }

  Map<String, dynamic> toMap() {
    return StorageChatItemMapper.ensureInitialized().encodeMap<StorageChatItem>(
      this as StorageChatItem,
    );
  }

  StorageChatItemCopyWith<StorageChatItem, StorageChatItem, StorageChatItem>
  get copyWith =>
      _StorageChatItemCopyWithImpl<StorageChatItem, StorageChatItem>(
        this as StorageChatItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StorageChatItemMapper.ensureInitialized().stringifyValue(
      this as StorageChatItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return StorageChatItemMapper.ensureInitialized().equalsValue(
      this as StorageChatItem,
      other,
    );
  }

  @override
  int get hashCode {
    return StorageChatItemMapper.ensureInitialized().hashValue(
      this as StorageChatItem,
    );
  }
}

extension StorageChatItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StorageChatItem, $Out> {
  StorageChatItemCopyWith<$R, StorageChatItem, $Out> get $asStorageChatItem =>
      $base.as((v, t, t2) => _StorageChatItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StorageChatItemCopyWith<$R, $In extends StorageChatItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ChatCopyWith<$R, Chat, Chat>? get chat;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get chatIDs;
  $R call({Chat? chat, List<String>? chatIDs, int? bytes});
  StorageChatItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _StorageChatItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StorageChatItem, $Out>
    implements StorageChatItemCopyWith<$R, StorageChatItem, $Out> {
  _StorageChatItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StorageChatItem> $mapper =
      StorageChatItemMapper.ensureInitialized();
  @override
  ChatCopyWith<$R, Chat, Chat>? get chat =>
      $value.chat?.copyWith.$chain((v) => call(chat: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get chatIDs =>
      ListCopyWith(
        $value.chatIDs,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(chatIDs: v),
      );
  @override
  $R call({Object? chat = $none, List<String>? chatIDs, int? bytes}) => $apply(
    FieldCopyWithData({
      if (chat != $none) #chat: chat,
      if (chatIDs != null) #chatIDs: chatIDs,
      if (bytes != null) #bytes: bytes,
    }),
  );
  @override
  StorageChatItem $make(CopyWithData data) => StorageChatItem(
    chat: data.get(#chat, or: $value.chat),
    chatIDs: data.get(#chatIDs, or: $value.chatIDs),
    bytes: data.get(#bytes, or: $value.bytes),
  );

  @override
  StorageChatItemCopyWith<$R2, StorageChatItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StorageChatItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SettingsStorageStateMapper extends ClassMapperBase<SettingsStorageState> {
  SettingsStorageStateMapper._();

  static SettingsStorageStateMapper? _instance;
  static SettingsStorageStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsStorageStateMapper._());
      StorageReportMapper.ensureInitialized();
      StorageChatItemMapper.ensureInitialized();
      StorageCategoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsStorageState';

  static Status _$status(SettingsStorageState v) => v.status;
  static const Field<SettingsStorageState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static StorageReport? _$report(SettingsStorageState v) => v.report;
  static const Field<SettingsStorageState, StorageReport> _f$report = Field(
    'report',
    _$report,
    opt: true,
  );
  static List<StorageChatItem> _$chats(SettingsStorageState v) => v.chats;
  static const Field<SettingsStorageState, List<StorageChatItem>> _f$chats =
      Field('chats', _$chats, opt: true, def: const []);
  static Set<StorageCategory> _$selected(SettingsStorageState v) => v.selected;
  static const Field<SettingsStorageState, Set<StorageCategory>> _f$selected =
      Field(
        'selected',
        _$selected,
        opt: true,
        def: const {...StorageCategory.values},
      );
  static int _$keepMediaDays(SettingsStorageState v) => v.keepMediaDays;
  static const Field<SettingsStorageState, int> _f$keepMediaDays = Field(
    'keepMediaDays',
    _$keepMediaDays,
    opt: true,
    def: 0,
  );
  static int _$maxCacheMB(SettingsStorageState v) => v.maxCacheMB;
  static const Field<SettingsStorageState, int> _f$maxCacheMB = Field(
    'maxCacheMB',
    _$maxCacheMB,
    opt: true,
    def: 0,
  );
  static bool _$clearing(SettingsStorageState v) => v.clearing;
  static const Field<SettingsStorageState, bool> _f$clearing = Field(
    'clearing',
    _$clearing,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<SettingsStorageState> fields = const {
    #status: _f$status,
    #report: _f$report,
    #chats: _f$chats,
    #selected: _f$selected,
    #keepMediaDays: _f$keepMediaDays,
    #maxCacheMB: _f$maxCacheMB,
    #clearing: _f$clearing,
  };

  static SettingsStorageState _instantiate(DecodingData data) {
    return SettingsStorageState(
      status: data.dec(_f$status),
      report: data.dec(_f$report),
      chats: data.dec(_f$chats),
      selected: data.dec(_f$selected),
      keepMediaDays: data.dec(_f$keepMediaDays),
      maxCacheMB: data.dec(_f$maxCacheMB),
      clearing: data.dec(_f$clearing),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsStorageState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsStorageState>(map);
  }

  static SettingsStorageState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsStorageState>(json);
  }
}

mixin SettingsStorageStateMappable {
  String toJson() {
    return SettingsStorageStateMapper.ensureInitialized()
        .encodeJson<SettingsStorageState>(this as SettingsStorageState);
  }

  Map<String, dynamic> toMap() {
    return SettingsStorageStateMapper.ensureInitialized()
        .encodeMap<SettingsStorageState>(this as SettingsStorageState);
  }

  SettingsStorageStateCopyWith<
    SettingsStorageState,
    SettingsStorageState,
    SettingsStorageState
  >
  get copyWith =>
      _SettingsStorageStateCopyWithImpl<
        SettingsStorageState,
        SettingsStorageState
      >(this as SettingsStorageState, $identity, $identity);
  @override
  String toString() {
    return SettingsStorageStateMapper.ensureInitialized().stringifyValue(
      this as SettingsStorageState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsStorageStateMapper.ensureInitialized().equalsValue(
      this as SettingsStorageState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsStorageStateMapper.ensureInitialized().hashValue(
      this as SettingsStorageState,
    );
  }
}

extension SettingsStorageStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsStorageState, $Out> {
  SettingsStorageStateCopyWith<$R, SettingsStorageState, $Out>
  get $asSettingsStorageState => $base.as(
    (v, t, t2) => _SettingsStorageStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsStorageStateCopyWith<
  $R,
  $In extends SettingsStorageState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  StorageReportCopyWith<$R, StorageReport, StorageReport>? get report;
  ListCopyWith<
    $R,
    StorageChatItem,
    StorageChatItemCopyWith<$R, StorageChatItem, StorageChatItem>
  >
  get chats;
  $R call({
    Status? status,
    StorageReport? report,
    List<StorageChatItem>? chats,
    Set<StorageCategory>? selected,
    int? keepMediaDays,
    int? maxCacheMB,
    bool? clearing,
  });
  SettingsStorageStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsStorageStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsStorageState, $Out>
    implements SettingsStorageStateCopyWith<$R, SettingsStorageState, $Out> {
  _SettingsStorageStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsStorageState> $mapper =
      SettingsStorageStateMapper.ensureInitialized();
  @override
  StorageReportCopyWith<$R, StorageReport, StorageReport>? get report =>
      $value.report?.copyWith.$chain((v) => call(report: v));
  @override
  ListCopyWith<
    $R,
    StorageChatItem,
    StorageChatItemCopyWith<$R, StorageChatItem, StorageChatItem>
  >
  get chats => ListCopyWith(
    $value.chats,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(chats: v),
  );
  @override
  $R call({
    Status? status,
    Object? report = $none,
    List<StorageChatItem>? chats,
    Set<StorageCategory>? selected,
    int? keepMediaDays,
    int? maxCacheMB,
    bool? clearing,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (report != $none) #report: report,
      if (chats != null) #chats: chats,
      if (selected != null) #selected: selected,
      if (keepMediaDays != null) #keepMediaDays: keepMediaDays,
      if (maxCacheMB != null) #maxCacheMB: maxCacheMB,
      if (clearing != null) #clearing: clearing,
    }),
  );
  @override
  SettingsStorageState $make(CopyWithData data) => SettingsStorageState(
    status: data.get(#status, or: $value.status),
    report: data.get(#report, or: $value.report),
    chats: data.get(#chats, or: $value.chats),
    selected: data.get(#selected, or: $value.selected),
    keepMediaDays: data.get(#keepMediaDays, or: $value.keepMediaDays),
    maxCacheMB: data.get(#maxCacheMB, or: $value.maxCacheMB),
    clearing: data.get(#clearing, or: $value.clearing),
  );

  @override
  SettingsStorageStateCopyWith<$R2, SettingsStorageState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsStorageStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

