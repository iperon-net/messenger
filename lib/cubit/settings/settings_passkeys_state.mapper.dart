// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'settings_passkeys_state.dart';

class PasskeyItemMapper extends ClassMapperBase<PasskeyItem> {
  PasskeyItemMapper._();

  static PasskeyItemMapper? _instance;
  static PasskeyItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PasskeyItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PasskeyItem';

  static List<int> _$credentialId(PasskeyItem v) => v.credentialId;
  static const Field<PasskeyItem, List<int>> _f$credentialId = Field(
    'credentialId',
    _$credentialId,
    opt: true,
    def: const [],
  );
  static String _$label(PasskeyItem v) => v.label;
  static const Field<PasskeyItem, String> _f$label = Field(
    'label',
    _$label,
    opt: true,
    def: "",
  );
  static List<int> _$aaguid(PasskeyItem v) => v.aaguid;
  static const Field<PasskeyItem, List<int>> _f$aaguid = Field(
    'aaguid',
    _$aaguid,
    opt: true,
    def: const [],
  );
  static int _$createdAt(PasskeyItem v) => v.createdAt;
  static const Field<PasskeyItem, int> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    opt: true,
    def: 0,
  );
  static int _$lastUsedAt(PasskeyItem v) => v.lastUsedAt;
  static const Field<PasskeyItem, int> _f$lastUsedAt = Field(
    'lastUsedAt',
    _$lastUsedAt,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<PasskeyItem> fields = const {
    #credentialId: _f$credentialId,
    #label: _f$label,
    #aaguid: _f$aaguid,
    #createdAt: _f$createdAt,
    #lastUsedAt: _f$lastUsedAt,
  };

  static PasskeyItem _instantiate(DecodingData data) {
    return PasskeyItem(
      credentialId: data.dec(_f$credentialId),
      label: data.dec(_f$label),
      aaguid: data.dec(_f$aaguid),
      createdAt: data.dec(_f$createdAt),
      lastUsedAt: data.dec(_f$lastUsedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PasskeyItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PasskeyItem>(map);
  }

  static PasskeyItem fromJson(String json) {
    return ensureInitialized().decodeJson<PasskeyItem>(json);
  }
}

mixin PasskeyItemMappable {
  String toJson() {
    return PasskeyItemMapper.ensureInitialized().encodeJson<PasskeyItem>(
      this as PasskeyItem,
    );
  }

  Map<String, dynamic> toMap() {
    return PasskeyItemMapper.ensureInitialized().encodeMap<PasskeyItem>(
      this as PasskeyItem,
    );
  }

  PasskeyItemCopyWith<PasskeyItem, PasskeyItem, PasskeyItem> get copyWith =>
      _PasskeyItemCopyWithImpl<PasskeyItem, PasskeyItem>(
        this as PasskeyItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PasskeyItemMapper.ensureInitialized().stringifyValue(
      this as PasskeyItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return PasskeyItemMapper.ensureInitialized().equalsValue(
      this as PasskeyItem,
      other,
    );
  }

  @override
  int get hashCode {
    return PasskeyItemMapper.ensureInitialized().hashValue(this as PasskeyItem);
  }
}

extension PasskeyItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PasskeyItem, $Out> {
  PasskeyItemCopyWith<$R, PasskeyItem, $Out> get $asPasskeyItem =>
      $base.as((v, t, t2) => _PasskeyItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PasskeyItemCopyWith<$R, $In extends PasskeyItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get credentialId;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get aaguid;
  $R call({
    List<int>? credentialId,
    String? label,
    List<int>? aaguid,
    int? createdAt,
    int? lastUsedAt,
  });
  PasskeyItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PasskeyItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PasskeyItem, $Out>
    implements PasskeyItemCopyWith<$R, PasskeyItem, $Out> {
  _PasskeyItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PasskeyItem> $mapper =
      PasskeyItemMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get credentialId =>
      ListCopyWith(
        $value.credentialId,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(credentialId: v),
      );
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get aaguid =>
      ListCopyWith(
        $value.aaguid,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(aaguid: v),
      );
  @override
  $R call({
    List<int>? credentialId,
    String? label,
    List<int>? aaguid,
    int? createdAt,
    int? lastUsedAt,
  }) => $apply(
    FieldCopyWithData({
      if (credentialId != null) #credentialId: credentialId,
      if (label != null) #label: label,
      if (aaguid != null) #aaguid: aaguid,
      if (createdAt != null) #createdAt: createdAt,
      if (lastUsedAt != null) #lastUsedAt: lastUsedAt,
    }),
  );
  @override
  PasskeyItem $make(CopyWithData data) => PasskeyItem(
    credentialId: data.get(#credentialId, or: $value.credentialId),
    label: data.get(#label, or: $value.label),
    aaguid: data.get(#aaguid, or: $value.aaguid),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    lastUsedAt: data.get(#lastUsedAt, or: $value.lastUsedAt),
  );

  @override
  PasskeyItemCopyWith<$R2, PasskeyItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PasskeyItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SettingsPasskeysStateMapper
    extends ClassMapperBase<SettingsPasskeysState> {
  SettingsPasskeysStateMapper._();

  static SettingsPasskeysStateMapper? _instance;
  static SettingsPasskeysStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SettingsPasskeysStateMapper._());
      PasskeyItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SettingsPasskeysState';

  static Status _$status(SettingsPasskeysState v) => v.status;
  static const Field<SettingsPasskeysState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static Status _$networkStatus(SettingsPasskeysState v) => v.networkStatus;
  static const Field<SettingsPasskeysState, Status> _f$networkStatus = Field(
    'networkStatus',
    _$networkStatus,
    opt: true,
    def: Status.success,
  );
  static bool _$loadError(SettingsPasskeysState v) => v.loadError;
  static const Field<SettingsPasskeysState, bool> _f$loadError = Field(
    'loadError',
    _$loadError,
    opt: true,
    def: false,
  );
  static List<PasskeyItem> _$items(SettingsPasskeysState v) => v.items;
  static const Field<SettingsPasskeysState, List<PasskeyItem>> _f$items = Field(
    'items',
    _$items,
    opt: true,
    def: const [],
  );
  static String _$error(SettingsPasskeysState v) => v.error;
  static const Field<SettingsPasskeysState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );

  @override
  final MappableFields<SettingsPasskeysState> fields = const {
    #status: _f$status,
    #networkStatus: _f$networkStatus,
    #loadError: _f$loadError,
    #items: _f$items,
    #error: _f$error,
  };

  static SettingsPasskeysState _instantiate(DecodingData data) {
    return SettingsPasskeysState(
      status: data.dec(_f$status),
      networkStatus: data.dec(_f$networkStatus),
      loadError: data.dec(_f$loadError),
      items: data.dec(_f$items),
      error: data.dec(_f$error),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SettingsPasskeysState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SettingsPasskeysState>(map);
  }

  static SettingsPasskeysState fromJson(String json) {
    return ensureInitialized().decodeJson<SettingsPasskeysState>(json);
  }
}

mixin SettingsPasskeysStateMappable {
  String toJson() {
    return SettingsPasskeysStateMapper.ensureInitialized()
        .encodeJson<SettingsPasskeysState>(this as SettingsPasskeysState);
  }

  Map<String, dynamic> toMap() {
    return SettingsPasskeysStateMapper.ensureInitialized()
        .encodeMap<SettingsPasskeysState>(this as SettingsPasskeysState);
  }

  SettingsPasskeysStateCopyWith<
    SettingsPasskeysState,
    SettingsPasskeysState,
    SettingsPasskeysState
  >
  get copyWith =>
      _SettingsPasskeysStateCopyWithImpl<
        SettingsPasskeysState,
        SettingsPasskeysState
      >(this as SettingsPasskeysState, $identity, $identity);
  @override
  String toString() {
    return SettingsPasskeysStateMapper.ensureInitialized().stringifyValue(
      this as SettingsPasskeysState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SettingsPasskeysStateMapper.ensureInitialized().equalsValue(
      this as SettingsPasskeysState,
      other,
    );
  }

  @override
  int get hashCode {
    return SettingsPasskeysStateMapper.ensureInitialized().hashValue(
      this as SettingsPasskeysState,
    );
  }
}

extension SettingsPasskeysStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SettingsPasskeysState, $Out> {
  SettingsPasskeysStateCopyWith<$R, SettingsPasskeysState, $Out>
  get $asSettingsPasskeysState => $base.as(
    (v, t, t2) => _SettingsPasskeysStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SettingsPasskeysStateCopyWith<
  $R,
  $In extends SettingsPasskeysState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    PasskeyItem,
    PasskeyItemCopyWith<$R, PasskeyItem, PasskeyItem>
  >
  get items;
  $R call({
    Status? status,
    Status? networkStatus,
    bool? loadError,
    List<PasskeyItem>? items,
    String? error,
  });
  SettingsPasskeysStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SettingsPasskeysStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SettingsPasskeysState, $Out>
    implements SettingsPasskeysStateCopyWith<$R, SettingsPasskeysState, $Out> {
  _SettingsPasskeysStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SettingsPasskeysState> $mapper =
      SettingsPasskeysStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    PasskeyItem,
    PasskeyItemCopyWith<$R, PasskeyItem, PasskeyItem>
  >
  get items => ListCopyWith(
    $value.items,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(items: v),
  );
  @override
  $R call({
    Status? status,
    Status? networkStatus,
    bool? loadError,
    List<PasskeyItem>? items,
    String? error,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (networkStatus != null) #networkStatus: networkStatus,
      if (loadError != null) #loadError: loadError,
      if (items != null) #items: items,
      if (error != null) #error: error,
    }),
  );
  @override
  SettingsPasskeysState $make(CopyWithData data) => SettingsPasskeysState(
    status: data.get(#status, or: $value.status),
    networkStatus: data.get(#networkStatus, or: $value.networkStatus),
    loadError: data.get(#loadError, or: $value.loadError),
    items: data.get(#items, or: $value.items),
    error: data.get(#error, or: $value.error),
  );

  @override
  SettingsPasskeysStateCopyWith<$R2, SettingsPasskeysState, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SettingsPasskeysStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

