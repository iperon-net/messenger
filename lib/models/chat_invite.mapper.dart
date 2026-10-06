// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_invite.dart';

class ChatInviteLinkMapper extends ClassMapperBase<ChatInviteLink> {
  ChatInviteLinkMapper._();

  static ChatInviteLinkMapper? _instance;
  static ChatInviteLinkMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatInviteLinkMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatInviteLink';

  static String _$id(ChatInviteLink v) => v.id;
  static const Field<ChatInviteLink, String> _f$id = Field('id', _$id);
  static String _$link(ChatInviteLink v) => v.link;
  static const Field<ChatInviteLink, String> _f$link = Field('link', _$link);
  static String _$title(ChatInviteLink v) => v.title;
  static const Field<ChatInviteLink, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
    def: '',
  );
  static bool _$primary(ChatInviteLink v) => v.primary;
  static const Field<ChatInviteLink, bool> _f$primary = Field(
    'primary',
    _$primary,
    opt: true,
    def: false,
  );
  static bool _$revoked(ChatInviteLink v) => v.revoked;
  static const Field<ChatInviteLink, bool> _f$revoked = Field(
    'revoked',
    _$revoked,
    opt: true,
    def: false,
  );
  static DateTime? _$expireDate(ChatInviteLink v) => v.expireDate;
  static const Field<ChatInviteLink, DateTime> _f$expireDate = Field(
    'expireDate',
    _$expireDate,
    opt: true,
  );
  static int _$usageLimit(ChatInviteLink v) => v.usageLimit;
  static const Field<ChatInviteLink, int> _f$usageLimit = Field(
    'usageLimit',
    _$usageLimit,
    opt: true,
    def: 0,
  );
  static int _$usage(ChatInviteLink v) => v.usage;
  static const Field<ChatInviteLink, int> _f$usage = Field(
    'usage',
    _$usage,
    opt: true,
    def: 0,
  );
  static bool _$requestApproval(ChatInviteLink v) => v.requestApproval;
  static const Field<ChatInviteLink, bool> _f$requestApproval = Field(
    'requestApproval',
    _$requestApproval,
    opt: true,
    def: false,
  );
  static DateTime _$createdAt(ChatInviteLink v) => v.createdAt;
  static const Field<ChatInviteLink, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<ChatInviteLink> fields = const {
    #id: _f$id,
    #link: _f$link,
    #title: _f$title,
    #primary: _f$primary,
    #revoked: _f$revoked,
    #expireDate: _f$expireDate,
    #usageLimit: _f$usageLimit,
    #usage: _f$usage,
    #requestApproval: _f$requestApproval,
    #createdAt: _f$createdAt,
  };

  static ChatInviteLink _instantiate(DecodingData data) {
    return ChatInviteLink(
      id: data.dec(_f$id),
      link: data.dec(_f$link),
      title: data.dec(_f$title),
      primary: data.dec(_f$primary),
      revoked: data.dec(_f$revoked),
      expireDate: data.dec(_f$expireDate),
      usageLimit: data.dec(_f$usageLimit),
      usage: data.dec(_f$usage),
      requestApproval: data.dec(_f$requestApproval),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatInviteLink fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatInviteLink>(map);
  }

  static ChatInviteLink fromJson(String json) {
    return ensureInitialized().decodeJson<ChatInviteLink>(json);
  }
}

mixin ChatInviteLinkMappable {
  String toJson() {
    return ChatInviteLinkMapper.ensureInitialized().encodeJson<ChatInviteLink>(
      this as ChatInviteLink,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatInviteLinkMapper.ensureInitialized().encodeMap<ChatInviteLink>(
      this as ChatInviteLink,
    );
  }

  ChatInviteLinkCopyWith<ChatInviteLink, ChatInviteLink, ChatInviteLink>
  get copyWith => _ChatInviteLinkCopyWithImpl<ChatInviteLink, ChatInviteLink>(
    this as ChatInviteLink,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ChatInviteLinkMapper.ensureInitialized().stringifyValue(
      this as ChatInviteLink,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatInviteLinkMapper.ensureInitialized().equalsValue(
      this as ChatInviteLink,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatInviteLinkMapper.ensureInitialized().hashValue(
      this as ChatInviteLink,
    );
  }
}

extension ChatInviteLinkValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatInviteLink, $Out> {
  ChatInviteLinkCopyWith<$R, ChatInviteLink, $Out> get $asChatInviteLink =>
      $base.as((v, t, t2) => _ChatInviteLinkCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatInviteLinkCopyWith<$R, $In extends ChatInviteLink, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? link,
    String? title,
    bool? primary,
    bool? revoked,
    DateTime? expireDate,
    int? usageLimit,
    int? usage,
    bool? requestApproval,
    DateTime? createdAt,
  });
  ChatInviteLinkCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatInviteLinkCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatInviteLink, $Out>
    implements ChatInviteLinkCopyWith<$R, ChatInviteLink, $Out> {
  _ChatInviteLinkCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatInviteLink> $mapper =
      ChatInviteLinkMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? link,
    String? title,
    bool? primary,
    bool? revoked,
    Object? expireDate = $none,
    int? usageLimit,
    int? usage,
    bool? requestApproval,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (link != null) #link: link,
      if (title != null) #title: title,
      if (primary != null) #primary: primary,
      if (revoked != null) #revoked: revoked,
      if (expireDate != $none) #expireDate: expireDate,
      if (usageLimit != null) #usageLimit: usageLimit,
      if (usage != null) #usage: usage,
      if (requestApproval != null) #requestApproval: requestApproval,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  ChatInviteLink $make(CopyWithData data) => ChatInviteLink(
    id: data.get(#id, or: $value.id),
    link: data.get(#link, or: $value.link),
    title: data.get(#title, or: $value.title),
    primary: data.get(#primary, or: $value.primary),
    revoked: data.get(#revoked, or: $value.revoked),
    expireDate: data.get(#expireDate, or: $value.expireDate),
    usageLimit: data.get(#usageLimit, or: $value.usageLimit),
    usage: data.get(#usage, or: $value.usage),
    requestApproval: data.get(#requestApproval, or: $value.requestApproval),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  ChatInviteLinkCopyWith<$R2, ChatInviteLink, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatInviteLinkCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChatJoinRequestMapper extends ClassMapperBase<ChatJoinRequest> {
  ChatJoinRequestMapper._();

  static ChatJoinRequestMapper? _instance;
  static ChatJoinRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatJoinRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChatJoinRequest';

  static String _$userID(ChatJoinRequest v) => v.userID;
  static const Field<ChatJoinRequest, String> _f$userID = Field(
    'userID',
    _$userID,
  );
  static String _$name(ChatJoinRequest v) => v.name;
  static const Field<ChatJoinRequest, String> _f$name = Field('name', _$name);
  static String _$about(ChatJoinRequest v) => v.about;
  static const Field<ChatJoinRequest, String> _f$about = Field(
    'about',
    _$about,
    opt: true,
    def: '',
  );
  static DateTime _$date(ChatJoinRequest v) => v.date;
  static const Field<ChatJoinRequest, DateTime> _f$date = Field('date', _$date);
  static String _$linkID(ChatJoinRequest v) => v.linkID;
  static const Field<ChatJoinRequest, String> _f$linkID = Field(
    'linkID',
    _$linkID,
    opt: true,
    def: '',
  );
  static String _$linkTitle(ChatJoinRequest v) => v.linkTitle;
  static const Field<ChatJoinRequest, String> _f$linkTitle = Field(
    'linkTitle',
    _$linkTitle,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<ChatJoinRequest> fields = const {
    #userID: _f$userID,
    #name: _f$name,
    #about: _f$about,
    #date: _f$date,
    #linkID: _f$linkID,
    #linkTitle: _f$linkTitle,
  };

  static ChatJoinRequest _instantiate(DecodingData data) {
    return ChatJoinRequest(
      userID: data.dec(_f$userID),
      name: data.dec(_f$name),
      about: data.dec(_f$about),
      date: data.dec(_f$date),
      linkID: data.dec(_f$linkID),
      linkTitle: data.dec(_f$linkTitle),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatJoinRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatJoinRequest>(map);
  }

  static ChatJoinRequest fromJson(String json) {
    return ensureInitialized().decodeJson<ChatJoinRequest>(json);
  }
}

mixin ChatJoinRequestMappable {
  String toJson() {
    return ChatJoinRequestMapper.ensureInitialized()
        .encodeJson<ChatJoinRequest>(this as ChatJoinRequest);
  }

  Map<String, dynamic> toMap() {
    return ChatJoinRequestMapper.ensureInitialized().encodeMap<ChatJoinRequest>(
      this as ChatJoinRequest,
    );
  }

  ChatJoinRequestCopyWith<ChatJoinRequest, ChatJoinRequest, ChatJoinRequest>
  get copyWith =>
      _ChatJoinRequestCopyWithImpl<ChatJoinRequest, ChatJoinRequest>(
        this as ChatJoinRequest,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatJoinRequestMapper.ensureInitialized().stringifyValue(
      this as ChatJoinRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatJoinRequestMapper.ensureInitialized().equalsValue(
      this as ChatJoinRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatJoinRequestMapper.ensureInitialized().hashValue(
      this as ChatJoinRequest,
    );
  }
}

extension ChatJoinRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChatJoinRequest, $Out> {
  ChatJoinRequestCopyWith<$R, ChatJoinRequest, $Out> get $asChatJoinRequest =>
      $base.as((v, t, t2) => _ChatJoinRequestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatJoinRequestCopyWith<$R, $In extends ChatJoinRequest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userID,
    String? name,
    String? about,
    DateTime? date,
    String? linkID,
    String? linkTitle,
  });
  ChatJoinRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ChatJoinRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatJoinRequest, $Out>
    implements ChatJoinRequestCopyWith<$R, ChatJoinRequest, $Out> {
  _ChatJoinRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatJoinRequest> $mapper =
      ChatJoinRequestMapper.ensureInitialized();
  @override
  $R call({
    String? userID,
    String? name,
    String? about,
    DateTime? date,
    String? linkID,
    String? linkTitle,
  }) => $apply(
    FieldCopyWithData({
      if (userID != null) #userID: userID,
      if (name != null) #name: name,
      if (about != null) #about: about,
      if (date != null) #date: date,
      if (linkID != null) #linkID: linkID,
      if (linkTitle != null) #linkTitle: linkTitle,
    }),
  );
  @override
  ChatJoinRequest $make(CopyWithData data) => ChatJoinRequest(
    userID: data.get(#userID, or: $value.userID),
    name: data.get(#name, or: $value.name),
    about: data.get(#about, or: $value.about),
    date: data.get(#date, or: $value.date),
    linkID: data.get(#linkID, or: $value.linkID),
    linkTitle: data.get(#linkTitle, or: $value.linkTitle),
  );

  @override
  ChatJoinRequestCopyWith<$R2, ChatJoinRequest, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatJoinRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

