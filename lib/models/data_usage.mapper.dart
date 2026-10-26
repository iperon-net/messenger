// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'data_usage.dart';

class StorageCategoryMapper extends EnumMapper<StorageCategory> {
  StorageCategoryMapper._();

  static StorageCategoryMapper? _instance;
  static StorageCategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StorageCategoryMapper._());
    }
    return _instance!;
  }

  static StorageCategory fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  StorageCategory decode(dynamic value) {
    switch (value) {
      case r'photos':
        return StorageCategory.photos;
      case r'videos':
        return StorageCategory.videos;
      case r'files':
        return StorageCategory.files;
      case r'audio':
        return StorageCategory.audio;
      case r'other':
        return StorageCategory.other;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(StorageCategory self) {
    switch (self) {
      case StorageCategory.photos:
        return r'photos';
      case StorageCategory.videos:
        return r'videos';
      case StorageCategory.files:
        return r'files';
      case StorageCategory.audio:
        return r'audio';
      case StorageCategory.other:
        return r'other';
    }
  }
}

extension StorageCategoryMapperExtension on StorageCategory {
  String toValue() {
    StorageCategoryMapper.ensureInitialized();
    return MapperContainer.globals.toValue<StorageCategory>(this) as String;
  }
}

class NetworkKindMapper extends EnumMapper<NetworkKind> {
  NetworkKindMapper._();

  static NetworkKindMapper? _instance;
  static NetworkKindMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NetworkKindMapper._());
    }
    return _instance!;
  }

  static NetworkKind fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  NetworkKind decode(dynamic value) {
    switch (value) {
      case r'mobile':
        return NetworkKind.mobile;
      case r'wifi':
        return NetworkKind.wifi;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(NetworkKind self) {
    switch (self) {
      case NetworkKind.mobile:
        return r'mobile';
      case NetworkKind.wifi:
        return r'wifi';
    }
  }
}

extension NetworkKindMapperExtension on NetworkKind {
  String toValue() {
    NetworkKindMapper.ensureInitialized();
    return MapperContainer.globals.toValue<NetworkKind>(this) as String;
  }
}

class TrafficCategoryMapper extends EnumMapper<TrafficCategory> {
  TrafficCategoryMapper._();

  static TrafficCategoryMapper? _instance;
  static TrafficCategoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TrafficCategoryMapper._());
    }
    return _instance!;
  }

  static TrafficCategory fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  TrafficCategory decode(dynamic value) {
    switch (value) {
      case r'messages':
        return TrafficCategory.messages;
      case r'photos':
        return TrafficCategory.photos;
      case r'videos':
        return TrafficCategory.videos;
      case r'files':
        return TrafficCategory.files;
      case r'audio':
        return TrafficCategory.audio;
      case r'calls':
        return TrafficCategory.calls;
      case r'other':
        return TrafficCategory.other;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(TrafficCategory self) {
    switch (self) {
      case TrafficCategory.messages:
        return r'messages';
      case TrafficCategory.photos:
        return r'photos';
      case TrafficCategory.videos:
        return r'videos';
      case TrafficCategory.files:
        return r'files';
      case TrafficCategory.audio:
        return r'audio';
      case TrafficCategory.calls:
        return r'calls';
      case TrafficCategory.other:
        return r'other';
    }
  }
}

extension TrafficCategoryMapperExtension on TrafficCategory {
  String toValue() {
    TrafficCategoryMapper.ensureInitialized();
    return MapperContainer.globals.toValue<TrafficCategory>(this) as String;
  }
}

class StorageChatUsageMapper extends ClassMapperBase<StorageChatUsage> {
  StorageChatUsageMapper._();

  static StorageChatUsageMapper? _instance;
  static StorageChatUsageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StorageChatUsageMapper._());
      StorageCategoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StorageChatUsage';

  static String _$chatID(StorageChatUsage v) => v.chatID;
  static const Field<StorageChatUsage, String> _f$chatID = Field(
    'chatID',
    _$chatID,
  );
  static Map<StorageCategory, int> _$byCategory(StorageChatUsage v) =>
      v.byCategory;
  static const Field<StorageChatUsage, Map<StorageCategory, int>>
  _f$byCategory = Field('byCategory', _$byCategory, opt: true, def: const {});

  @override
  final MappableFields<StorageChatUsage> fields = const {
    #chatID: _f$chatID,
    #byCategory: _f$byCategory,
  };

  static StorageChatUsage _instantiate(DecodingData data) {
    return StorageChatUsage(
      chatID: data.dec(_f$chatID),
      byCategory: data.dec(_f$byCategory),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StorageChatUsage fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StorageChatUsage>(map);
  }

  static StorageChatUsage fromJson(String json) {
    return ensureInitialized().decodeJson<StorageChatUsage>(json);
  }
}

mixin StorageChatUsageMappable {
  String toJson() {
    return StorageChatUsageMapper.ensureInitialized()
        .encodeJson<StorageChatUsage>(this as StorageChatUsage);
  }

  Map<String, dynamic> toMap() {
    return StorageChatUsageMapper.ensureInitialized()
        .encodeMap<StorageChatUsage>(this as StorageChatUsage);
  }

  StorageChatUsageCopyWith<StorageChatUsage, StorageChatUsage, StorageChatUsage>
  get copyWith =>
      _StorageChatUsageCopyWithImpl<StorageChatUsage, StorageChatUsage>(
        this as StorageChatUsage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StorageChatUsageMapper.ensureInitialized().stringifyValue(
      this as StorageChatUsage,
    );
  }

  @override
  bool operator ==(Object other) {
    return StorageChatUsageMapper.ensureInitialized().equalsValue(
      this as StorageChatUsage,
      other,
    );
  }

  @override
  int get hashCode {
    return StorageChatUsageMapper.ensureInitialized().hashValue(
      this as StorageChatUsage,
    );
  }
}

extension StorageChatUsageValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StorageChatUsage, $Out> {
  StorageChatUsageCopyWith<$R, StorageChatUsage, $Out>
  get $asStorageChatUsage =>
      $base.as((v, t, t2) => _StorageChatUsageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StorageChatUsageCopyWith<$R, $In extends StorageChatUsage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, StorageCategory, int, ObjectCopyWith<$R, int, int>>
  get byCategory;
  $R call({String? chatID, Map<StorageCategory, int>? byCategory});
  StorageChatUsageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _StorageChatUsageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StorageChatUsage, $Out>
    implements StorageChatUsageCopyWith<$R, StorageChatUsage, $Out> {
  _StorageChatUsageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StorageChatUsage> $mapper =
      StorageChatUsageMapper.ensureInitialized();
  @override
  MapCopyWith<$R, StorageCategory, int, ObjectCopyWith<$R, int, int>>
  get byCategory => MapCopyWith(
    $value.byCategory,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(byCategory: v),
  );
  @override
  $R call({String? chatID, Map<StorageCategory, int>? byCategory}) => $apply(
    FieldCopyWithData({
      if (chatID != null) #chatID: chatID,
      if (byCategory != null) #byCategory: byCategory,
    }),
  );
  @override
  StorageChatUsage $make(CopyWithData data) => StorageChatUsage(
    chatID: data.get(#chatID, or: $value.chatID),
    byCategory: data.get(#byCategory, or: $value.byCategory),
  );

  @override
  StorageChatUsageCopyWith<$R2, StorageChatUsage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StorageChatUsageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class StorageReportMapper extends ClassMapperBase<StorageReport> {
  StorageReportMapper._();

  static StorageReportMapper? _instance;
  static StorageReportMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StorageReportMapper._());
      StorageCategoryMapper.ensureInitialized();
      StorageChatUsageMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StorageReport';

  static Map<StorageCategory, int> _$byCategory(StorageReport v) =>
      v.byCategory;
  static const Field<StorageReport, Map<StorageCategory, int>> _f$byCategory =
      Field('byCategory', _$byCategory, opt: true, def: const {});
  static int _$protectedBytes(StorageReport v) => v.protectedBytes;
  static const Field<StorageReport, int> _f$protectedBytes = Field(
    'protectedBytes',
    _$protectedBytes,
    opt: true,
    def: 0,
  );
  static int _$database(StorageReport v) => v.database;
  static const Field<StorageReport, int> _f$database = Field(
    'database',
    _$database,
    opt: true,
    def: 0,
  );
  static int _$emoji(StorageReport v) => v.emoji;
  static const Field<StorageReport, int> _f$emoji = Field(
    'emoji',
    _$emoji,
    opt: true,
    def: 0,
  );
  static int _$temp(StorageReport v) => v.temp;
  static const Field<StorageReport, int> _f$temp = Field(
    'temp',
    _$temp,
    opt: true,
    def: 0,
  );
  static List<StorageChatUsage> _$chats(StorageReport v) => v.chats;
  static const Field<StorageReport, List<StorageChatUsage>> _f$chats = Field(
    'chats',
    _$chats,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<StorageReport> fields = const {
    #byCategory: _f$byCategory,
    #protectedBytes: _f$protectedBytes,
    #database: _f$database,
    #emoji: _f$emoji,
    #temp: _f$temp,
    #chats: _f$chats,
  };

  static StorageReport _instantiate(DecodingData data) {
    return StorageReport(
      byCategory: data.dec(_f$byCategory),
      protectedBytes: data.dec(_f$protectedBytes),
      database: data.dec(_f$database),
      emoji: data.dec(_f$emoji),
      temp: data.dec(_f$temp),
      chats: data.dec(_f$chats),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StorageReport fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StorageReport>(map);
  }

  static StorageReport fromJson(String json) {
    return ensureInitialized().decodeJson<StorageReport>(json);
  }
}

mixin StorageReportMappable {
  String toJson() {
    return StorageReportMapper.ensureInitialized().encodeJson<StorageReport>(
      this as StorageReport,
    );
  }

  Map<String, dynamic> toMap() {
    return StorageReportMapper.ensureInitialized().encodeMap<StorageReport>(
      this as StorageReport,
    );
  }

  StorageReportCopyWith<StorageReport, StorageReport, StorageReport>
  get copyWith => _StorageReportCopyWithImpl<StorageReport, StorageReport>(
    this as StorageReport,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return StorageReportMapper.ensureInitialized().stringifyValue(
      this as StorageReport,
    );
  }

  @override
  bool operator ==(Object other) {
    return StorageReportMapper.ensureInitialized().equalsValue(
      this as StorageReport,
      other,
    );
  }

  @override
  int get hashCode {
    return StorageReportMapper.ensureInitialized().hashValue(
      this as StorageReport,
    );
  }
}

extension StorageReportValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StorageReport, $Out> {
  StorageReportCopyWith<$R, StorageReport, $Out> get $asStorageReport =>
      $base.as((v, t, t2) => _StorageReportCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StorageReportCopyWith<$R, $In extends StorageReport, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, StorageCategory, int, ObjectCopyWith<$R, int, int>>
  get byCategory;
  ListCopyWith<
    $R,
    StorageChatUsage,
    StorageChatUsageCopyWith<$R, StorageChatUsage, StorageChatUsage>
  >
  get chats;
  $R call({
    Map<StorageCategory, int>? byCategory,
    int? protectedBytes,
    int? database,
    int? emoji,
    int? temp,
    List<StorageChatUsage>? chats,
  });
  StorageReportCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StorageReportCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StorageReport, $Out>
    implements StorageReportCopyWith<$R, StorageReport, $Out> {
  _StorageReportCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StorageReport> $mapper =
      StorageReportMapper.ensureInitialized();
  @override
  MapCopyWith<$R, StorageCategory, int, ObjectCopyWith<$R, int, int>>
  get byCategory => MapCopyWith(
    $value.byCategory,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(byCategory: v),
  );
  @override
  ListCopyWith<
    $R,
    StorageChatUsage,
    StorageChatUsageCopyWith<$R, StorageChatUsage, StorageChatUsage>
  >
  get chats => ListCopyWith(
    $value.chats,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(chats: v),
  );
  @override
  $R call({
    Map<StorageCategory, int>? byCategory,
    int? protectedBytes,
    int? database,
    int? emoji,
    int? temp,
    List<StorageChatUsage>? chats,
  }) => $apply(
    FieldCopyWithData({
      if (byCategory != null) #byCategory: byCategory,
      if (protectedBytes != null) #protectedBytes: protectedBytes,
      if (database != null) #database: database,
      if (emoji != null) #emoji: emoji,
      if (temp != null) #temp: temp,
      if (chats != null) #chats: chats,
    }),
  );
  @override
  StorageReport $make(CopyWithData data) => StorageReport(
    byCategory: data.get(#byCategory, or: $value.byCategory),
    protectedBytes: data.get(#protectedBytes, or: $value.protectedBytes),
    database: data.get(#database, or: $value.database),
    emoji: data.get(#emoji, or: $value.emoji),
    temp: data.get(#temp, or: $value.temp),
    chats: data.get(#chats, or: $value.chats),
  );

  @override
  StorageReportCopyWith<$R2, StorageReport, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StorageReportCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TrafficCounterMapper extends ClassMapperBase<TrafficCounter> {
  TrafficCounterMapper._();

  static TrafficCounterMapper? _instance;
  static TrafficCounterMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TrafficCounterMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TrafficCounter';

  static int _$sent(TrafficCounter v) => v.sent;
  static const Field<TrafficCounter, int> _f$sent = Field(
    'sent',
    _$sent,
    opt: true,
    def: 0,
  );
  static int _$received(TrafficCounter v) => v.received;
  static const Field<TrafficCounter, int> _f$received = Field(
    'received',
    _$received,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<TrafficCounter> fields = const {
    #sent: _f$sent,
    #received: _f$received,
  };

  static TrafficCounter _instantiate(DecodingData data) {
    return TrafficCounter(
      sent: data.dec(_f$sent),
      received: data.dec(_f$received),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TrafficCounter fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TrafficCounter>(map);
  }

  static TrafficCounter fromJson(String json) {
    return ensureInitialized().decodeJson<TrafficCounter>(json);
  }
}

mixin TrafficCounterMappable {
  String toJson() {
    return TrafficCounterMapper.ensureInitialized().encodeJson<TrafficCounter>(
      this as TrafficCounter,
    );
  }

  Map<String, dynamic> toMap() {
    return TrafficCounterMapper.ensureInitialized().encodeMap<TrafficCounter>(
      this as TrafficCounter,
    );
  }

  TrafficCounterCopyWith<TrafficCounter, TrafficCounter, TrafficCounter>
  get copyWith => _TrafficCounterCopyWithImpl<TrafficCounter, TrafficCounter>(
    this as TrafficCounter,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return TrafficCounterMapper.ensureInitialized().stringifyValue(
      this as TrafficCounter,
    );
  }

  @override
  bool operator ==(Object other) {
    return TrafficCounterMapper.ensureInitialized().equalsValue(
      this as TrafficCounter,
      other,
    );
  }

  @override
  int get hashCode {
    return TrafficCounterMapper.ensureInitialized().hashValue(
      this as TrafficCounter,
    );
  }
}

extension TrafficCounterValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TrafficCounter, $Out> {
  TrafficCounterCopyWith<$R, TrafficCounter, $Out> get $asTrafficCounter =>
      $base.as((v, t, t2) => _TrafficCounterCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TrafficCounterCopyWith<$R, $In extends TrafficCounter, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? sent, int? received});
  TrafficCounterCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TrafficCounterCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TrafficCounter, $Out>
    implements TrafficCounterCopyWith<$R, TrafficCounter, $Out> {
  _TrafficCounterCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TrafficCounter> $mapper =
      TrafficCounterMapper.ensureInitialized();
  @override
  $R call({int? sent, int? received}) => $apply(
    FieldCopyWithData({
      if (sent != null) #sent: sent,
      if (received != null) #received: received,
    }),
  );
  @override
  TrafficCounter $make(CopyWithData data) => TrafficCounter(
    sent: data.get(#sent, or: $value.sent),
    received: data.get(#received, or: $value.received),
  );

  @override
  TrafficCounterCopyWith<$R2, TrafficCounter, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TrafficCounterCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

