// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'contacts_state.dart';

class ContactItemMapper extends ClassMapperBase<ContactItem> {
  ContactItemMapper._();

  static ContactItemMapper? _instance;
  static ContactItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ContactItemMapper._());
      MapperContainer.globals.useAll([Uint8ListMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'ContactItem';

  static String _$displayName(ContactItem v) => v.displayName;
  static const Field<ContactItem, String> _f$displayName = Field(
    'displayName',
    _$displayName,
  );
  static String _$phone(ContactItem v) => v.phone;
  static const Field<ContactItem, String> _f$phone = Field('phone', _$phone);
  static String _$phoneE164(ContactItem v) => v.phoneE164;
  static const Field<ContactItem, String> _f$phoneE164 = Field(
    'phoneE164',
    _$phoneE164,
  );
  static Uint8List? _$userID(ContactItem v) => v.userID;
  static const Field<ContactItem, Uint8List> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
  );
  static bool _$online(ContactItem v) => v.online;
  static const Field<ContactItem, bool> _f$online = Field(
    'online',
    _$online,
    opt: true,
    def: false,
  );
  static DateTime? _$lastSeen(ContactItem v) => v.lastSeen;
  static const Field<ContactItem, DateTime> _f$lastSeen = Field(
    'lastSeen',
    _$lastSeen,
    opt: true,
  );

  @override
  final MappableFields<ContactItem> fields = const {
    #displayName: _f$displayName,
    #phone: _f$phone,
    #phoneE164: _f$phoneE164,
    #userID: _f$userID,
    #online: _f$online,
    #lastSeen: _f$lastSeen,
  };

  static ContactItem _instantiate(DecodingData data) {
    return ContactItem(
      displayName: data.dec(_f$displayName),
      phone: data.dec(_f$phone),
      phoneE164: data.dec(_f$phoneE164),
      userID: data.dec(_f$userID),
      online: data.dec(_f$online),
      lastSeen: data.dec(_f$lastSeen),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ContactItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ContactItem>(map);
  }

  static ContactItem fromJson(String json) {
    return ensureInitialized().decodeJson<ContactItem>(json);
  }
}

mixin ContactItemMappable {
  String toJson() {
    return ContactItemMapper.ensureInitialized().encodeJson<ContactItem>(
      this as ContactItem,
    );
  }

  Map<String, dynamic> toMap() {
    return ContactItemMapper.ensureInitialized().encodeMap<ContactItem>(
      this as ContactItem,
    );
  }

  ContactItemCopyWith<ContactItem, ContactItem, ContactItem> get copyWith =>
      _ContactItemCopyWithImpl<ContactItem, ContactItem>(
        this as ContactItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ContactItemMapper.ensureInitialized().stringifyValue(
      this as ContactItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return ContactItemMapper.ensureInitialized().equalsValue(
      this as ContactItem,
      other,
    );
  }

  @override
  int get hashCode {
    return ContactItemMapper.ensureInitialized().hashValue(this as ContactItem);
  }
}

extension ContactItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ContactItem, $Out> {
  ContactItemCopyWith<$R, ContactItem, $Out> get $asContactItem =>
      $base.as((v, t, t2) => _ContactItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ContactItemCopyWith<$R, $In extends ContactItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? displayName,
    String? phone,
    String? phoneE164,
    Uint8List? userID,
    bool? online,
    DateTime? lastSeen,
  });
  ContactItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ContactItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ContactItem, $Out>
    implements ContactItemCopyWith<$R, ContactItem, $Out> {
  _ContactItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ContactItem> $mapper =
      ContactItemMapper.ensureInitialized();
  @override
  $R call({
    String? displayName,
    String? phone,
    String? phoneE164,
    Object? userID = $none,
    bool? online,
    Object? lastSeen = $none,
  }) => $apply(
    FieldCopyWithData({
      if (displayName != null) #displayName: displayName,
      if (phone != null) #phone: phone,
      if (phoneE164 != null) #phoneE164: phoneE164,
      if (userID != $none) #userID: userID,
      if (online != null) #online: online,
      if (lastSeen != $none) #lastSeen: lastSeen,
    }),
  );
  @override
  ContactItem $make(CopyWithData data) => ContactItem(
    displayName: data.get(#displayName, or: $value.displayName),
    phone: data.get(#phone, or: $value.phone),
    phoneE164: data.get(#phoneE164, or: $value.phoneE164),
    userID: data.get(#userID, or: $value.userID),
    online: data.get(#online, or: $value.online),
    lastSeen: data.get(#lastSeen, or: $value.lastSeen),
  );

  @override
  ContactItemCopyWith<$R2, ContactItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ContactItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ContactsStateMapper extends ClassMapperBase<ContactsState> {
  ContactsStateMapper._();

  static ContactsStateMapper? _instance;
  static ContactsStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ContactsStateMapper._());
      ContactItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ContactsState';

  static Status _$status(ContactsState v) => v.status;
  static const Field<ContactsState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$error(ContactsState v) => v.error;
  static const Field<ContactsState, String> _f$error = Field(
    'error',
    _$error,
    opt: true,
    def: "",
  );
  static bool _$permissionDenied(ContactsState v) => v.permissionDenied;
  static const Field<ContactsState, bool> _f$permissionDenied = Field(
    'permissionDenied',
    _$permissionDenied,
    opt: true,
    def: false,
  );
  static List<ContactItem> _$registered(ContactsState v) => v.registered;
  static const Field<ContactsState, List<ContactItem>> _f$registered = Field(
    'registered',
    _$registered,
    opt: true,
    def: const [],
  );
  static List<ContactItem> _$invitable(ContactsState v) => v.invitable;
  static const Field<ContactsState, List<ContactItem>> _f$invitable = Field(
    'invitable',
    _$invitable,
    opt: true,
    def: const [],
  );
  static List<ContactItem> _$cloud(ContactsState v) => v.cloud;
  static const Field<ContactsState, List<ContactItem>> _f$cloud = Field(
    'cloud',
    _$cloud,
    opt: true,
    def: const [],
  );
  static String _$query(ContactsState v) => v.query;
  static const Field<ContactsState, String> _f$query = Field(
    'query',
    _$query,
    opt: true,
    def: "",
  );
  static Map<String, String> _$hiddenHashByHex(ContactsState v) =>
      v.hiddenHashByHex;
  static const Field<ContactsState, Map<String, String>> _f$hiddenHashByHex =
      Field('hiddenHashByHex', _$hiddenHashByHex, opt: true, def: const {});
  static Set<String> _$revealedHex(ContactsState v) => v.revealedHex;
  static const Field<ContactsState, Set<String>> _f$revealedHex = Field(
    'revealedHex',
    _$revealedHex,
    opt: true,
    def: const {},
  );

  @override
  final MappableFields<ContactsState> fields = const {
    #status: _f$status,
    #error: _f$error,
    #permissionDenied: _f$permissionDenied,
    #registered: _f$registered,
    #invitable: _f$invitable,
    #cloud: _f$cloud,
    #query: _f$query,
    #hiddenHashByHex: _f$hiddenHashByHex,
    #revealedHex: _f$revealedHex,
  };

  static ContactsState _instantiate(DecodingData data) {
    return ContactsState(
      status: data.dec(_f$status),
      error: data.dec(_f$error),
      permissionDenied: data.dec(_f$permissionDenied),
      registered: data.dec(_f$registered),
      invitable: data.dec(_f$invitable),
      cloud: data.dec(_f$cloud),
      query: data.dec(_f$query),
      hiddenHashByHex: data.dec(_f$hiddenHashByHex),
      revealedHex: data.dec(_f$revealedHex),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ContactsState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ContactsState>(map);
  }

  static ContactsState fromJson(String json) {
    return ensureInitialized().decodeJson<ContactsState>(json);
  }
}

mixin ContactsStateMappable {
  String toJson() {
    return ContactsStateMapper.ensureInitialized().encodeJson<ContactsState>(
      this as ContactsState,
    );
  }

  Map<String, dynamic> toMap() {
    return ContactsStateMapper.ensureInitialized().encodeMap<ContactsState>(
      this as ContactsState,
    );
  }

  ContactsStateCopyWith<ContactsState, ContactsState, ContactsState>
  get copyWith => _ContactsStateCopyWithImpl<ContactsState, ContactsState>(
    this as ContactsState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ContactsStateMapper.ensureInitialized().stringifyValue(
      this as ContactsState,
    );
  }

  @override
  bool operator ==(Object other) {
    return ContactsStateMapper.ensureInitialized().equalsValue(
      this as ContactsState,
      other,
    );
  }

  @override
  int get hashCode {
    return ContactsStateMapper.ensureInitialized().hashValue(
      this as ContactsState,
    );
  }
}

extension ContactsStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ContactsState, $Out> {
  ContactsStateCopyWith<$R, ContactsState, $Out> get $asContactsState =>
      $base.as((v, t, t2) => _ContactsStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ContactsStateCopyWith<$R, $In extends ContactsState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ContactItem,
    ContactItemCopyWith<$R, ContactItem, ContactItem>
  >
  get registered;
  ListCopyWith<
    $R,
    ContactItem,
    ContactItemCopyWith<$R, ContactItem, ContactItem>
  >
  get invitable;
  ListCopyWith<
    $R,
    ContactItem,
    ContactItemCopyWith<$R, ContactItem, ContactItem>
  >
  get cloud;
  MapCopyWith<$R, String, String, ObjectCopyWith<$R, String, String>>
  get hiddenHashByHex;
  $R call({
    Status? status,
    String? error,
    bool? permissionDenied,
    List<ContactItem>? registered,
    List<ContactItem>? invitable,
    List<ContactItem>? cloud,
    String? query,
    Map<String, String>? hiddenHashByHex,
    Set<String>? revealedHex,
  });
  ContactsStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ContactsStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ContactsState, $Out>
    implements ContactsStateCopyWith<$R, ContactsState, $Out> {
  _ContactsStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ContactsState> $mapper =
      ContactsStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ContactItem,
    ContactItemCopyWith<$R, ContactItem, ContactItem>
  >
  get registered => ListCopyWith(
    $value.registered,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(registered: v),
  );
  @override
  ListCopyWith<
    $R,
    ContactItem,
    ContactItemCopyWith<$R, ContactItem, ContactItem>
  >
  get invitable => ListCopyWith(
    $value.invitable,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(invitable: v),
  );
  @override
  ListCopyWith<
    $R,
    ContactItem,
    ContactItemCopyWith<$R, ContactItem, ContactItem>
  >
  get cloud => ListCopyWith(
    $value.cloud,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(cloud: v),
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
    String? error,
    bool? permissionDenied,
    List<ContactItem>? registered,
    List<ContactItem>? invitable,
    List<ContactItem>? cloud,
    String? query,
    Map<String, String>? hiddenHashByHex,
    Set<String>? revealedHex,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (error != null) #error: error,
      if (permissionDenied != null) #permissionDenied: permissionDenied,
      if (registered != null) #registered: registered,
      if (invitable != null) #invitable: invitable,
      if (cloud != null) #cloud: cloud,
      if (query != null) #query: query,
      if (hiddenHashByHex != null) #hiddenHashByHex: hiddenHashByHex,
      if (revealedHex != null) #revealedHex: revealedHex,
    }),
  );
  @override
  ContactsState $make(CopyWithData data) => ContactsState(
    status: data.get(#status, or: $value.status),
    error: data.get(#error, or: $value.error),
    permissionDenied: data.get(#permissionDenied, or: $value.permissionDenied),
    registered: data.get(#registered, or: $value.registered),
    invitable: data.get(#invitable, or: $value.invitable),
    cloud: data.get(#cloud, or: $value.cloud),
    query: data.get(#query, or: $value.query),
    hiddenHashByHex: data.get(#hiddenHashByHex, or: $value.hiddenHashByHex),
    revealedHex: data.get(#revealedHex, or: $value.revealedHex),
  );

  @override
  ContactsStateCopyWith<$R2, ContactsState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ContactsStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

