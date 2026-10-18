// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'secret_chat_state.dart';

class SecretChatNoticeMapper extends EnumMapper<SecretChatNotice> {
  SecretChatNoticeMapper._();

  static SecretChatNoticeMapper? _instance;
  static SecretChatNoticeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SecretChatNoticeMapper._());
    }
    return _instance!;
  }

  static SecretChatNotice fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SecretChatNotice decode(dynamic value) {
    switch (value) {
      case r'none':
        return SecretChatNotice.none;
      case r'offline':
        return SecretChatNotice.offline;
      case r'notReady':
        return SecretChatNotice.notReady;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SecretChatNotice self) {
    switch (self) {
      case SecretChatNotice.none:
        return r'none';
      case SecretChatNotice.offline:
        return r'offline';
      case SecretChatNotice.notReady:
        return r'notReady';
    }
  }
}

extension SecretChatNoticeMapperExtension on SecretChatNotice {
  String toValue() {
    SecretChatNoticeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SecretChatNotice>(this) as String;
  }
}

class SecretChatStateMapper extends ClassMapperBase<SecretChatState> {
  SecretChatStateMapper._();

  static SecretChatStateMapper? _instance;
  static SecretChatStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SecretChatStateMapper._());
      models.SecretChatStatusMapper.ensureInitialized();
      models.MessageMapper.ensureInitialized();
      SecretChatNoticeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SecretChatState';

  static Status _$status(SecretChatState v) => v.status;
  static const Field<SecretChatState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static String _$chatID(SecretChatState v) => v.chatID;
  static const Field<SecretChatState, String> _f$chatID = Field(
    'chatID',
    _$chatID,
    opt: true,
    def: '',
  );
  static String _$title(SecretChatState v) => v.title;
  static const Field<SecretChatState, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
    def: '',
  );
  static String _$peerUserID(SecretChatState v) => v.peerUserID;
  static const Field<SecretChatState, String> _f$peerUserID = Field(
    'peerUserID',
    _$peerUserID,
    opt: true,
    def: '',
  );
  static models.SecretChatStatus _$secretStatus(SecretChatState v) =>
      v.secretStatus;
  static const Field<SecretChatState, models.SecretChatStatus> _f$secretStatus =
      Field(
        'secretStatus',
        _$secretStatus,
        opt: true,
        def: models.SecretChatStatus.waiting,
      );
  static bool _$outgoing(SecretChatState v) => v.outgoing;
  static const Field<SecretChatState, bool> _f$outgoing = Field(
    'outgoing',
    _$outgoing,
    opt: true,
    def: false,
  );
  static List<String> _$emoji(SecretChatState v) => v.emoji;
  static const Field<SecretChatState, List<String>> _f$emoji = Field(
    'emoji',
    _$emoji,
    opt: true,
    def: const [],
  );
  static String _$fingerprintHex(SecretChatState v) => v.fingerprintHex;
  static const Field<SecretChatState, String> _f$fingerprintHex = Field(
    'fingerprintHex',
    _$fingerprintHex,
    opt: true,
    def: '',
  );
  static List<models.Message> _$messages(SecretChatState v) => v.messages;
  static const Field<SecretChatState, List<models.Message>> _f$messages = Field(
    'messages',
    _$messages,
    opt: true,
    def: const [],
  );
  static SecretChatNotice _$notice(SecretChatState v) => v.notice;
  static const Field<SecretChatState, SecretChatNotice> _f$notice = Field(
    'notice',
    _$notice,
    opt: true,
    def: SecretChatNotice.none,
  );
  static int _$noticeCount(SecretChatState v) => v.noticeCount;
  static const Field<SecretChatState, int> _f$noticeCount = Field(
    'noticeCount',
    _$noticeCount,
    opt: true,
    def: 0,
  );
  static bool _$removed(SecretChatState v) => v.removed;
  static const Field<SecretChatState, bool> _f$removed = Field(
    'removed',
    _$removed,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<SecretChatState> fields = const {
    #status: _f$status,
    #chatID: _f$chatID,
    #title: _f$title,
    #peerUserID: _f$peerUserID,
    #secretStatus: _f$secretStatus,
    #outgoing: _f$outgoing,
    #emoji: _f$emoji,
    #fingerprintHex: _f$fingerprintHex,
    #messages: _f$messages,
    #notice: _f$notice,
    #noticeCount: _f$noticeCount,
    #removed: _f$removed,
  };

  static SecretChatState _instantiate(DecodingData data) {
    return SecretChatState(
      status: data.dec(_f$status),
      chatID: data.dec(_f$chatID),
      title: data.dec(_f$title),
      peerUserID: data.dec(_f$peerUserID),
      secretStatus: data.dec(_f$secretStatus),
      outgoing: data.dec(_f$outgoing),
      emoji: data.dec(_f$emoji),
      fingerprintHex: data.dec(_f$fingerprintHex),
      messages: data.dec(_f$messages),
      notice: data.dec(_f$notice),
      noticeCount: data.dec(_f$noticeCount),
      removed: data.dec(_f$removed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SecretChatState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SecretChatState>(map);
  }

  static SecretChatState fromJson(String json) {
    return ensureInitialized().decodeJson<SecretChatState>(json);
  }
}

mixin SecretChatStateMappable {
  String toJson() {
    return SecretChatStateMapper.ensureInitialized()
        .encodeJson<SecretChatState>(this as SecretChatState);
  }

  Map<String, dynamic> toMap() {
    return SecretChatStateMapper.ensureInitialized().encodeMap<SecretChatState>(
      this as SecretChatState,
    );
  }

  SecretChatStateCopyWith<SecretChatState, SecretChatState, SecretChatState>
  get copyWith =>
      _SecretChatStateCopyWithImpl<SecretChatState, SecretChatState>(
        this as SecretChatState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SecretChatStateMapper.ensureInitialized().stringifyValue(
      this as SecretChatState,
    );
  }

  @override
  bool operator ==(Object other) {
    return SecretChatStateMapper.ensureInitialized().equalsValue(
      this as SecretChatState,
      other,
    );
  }

  @override
  int get hashCode {
    return SecretChatStateMapper.ensureInitialized().hashValue(
      this as SecretChatState,
    );
  }
}

extension SecretChatStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SecretChatState, $Out> {
  SecretChatStateCopyWith<$R, SecretChatState, $Out> get $asSecretChatState =>
      $base.as((v, t, t2) => _SecretChatStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SecretChatStateCopyWith<$R, $In extends SecretChatState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get emoji;
  ListCopyWith<
    $R,
    models.Message,
    models.MessageCopyWith<$R, models.Message, models.Message>
  >
  get messages;
  $R call({
    Status? status,
    String? chatID,
    String? title,
    String? peerUserID,
    models.SecretChatStatus? secretStatus,
    bool? outgoing,
    List<String>? emoji,
    String? fingerprintHex,
    List<models.Message>? messages,
    SecretChatNotice? notice,
    int? noticeCount,
    bool? removed,
  });
  SecretChatStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SecretChatStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SecretChatState, $Out>
    implements SecretChatStateCopyWith<$R, SecretChatState, $Out> {
  _SecretChatStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SecretChatState> $mapper =
      SecretChatStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get emoji =>
      ListCopyWith(
        $value.emoji,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(emoji: v),
      );
  @override
  ListCopyWith<
    $R,
    models.Message,
    models.MessageCopyWith<$R, models.Message, models.Message>
  >
  get messages => ListCopyWith(
    $value.messages,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(messages: v),
  );
  @override
  $R call({
    Status? status,
    String? chatID,
    String? title,
    String? peerUserID,
    models.SecretChatStatus? secretStatus,
    bool? outgoing,
    List<String>? emoji,
    String? fingerprintHex,
    List<models.Message>? messages,
    SecretChatNotice? notice,
    int? noticeCount,
    bool? removed,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (chatID != null) #chatID: chatID,
      if (title != null) #title: title,
      if (peerUserID != null) #peerUserID: peerUserID,
      if (secretStatus != null) #secretStatus: secretStatus,
      if (outgoing != null) #outgoing: outgoing,
      if (emoji != null) #emoji: emoji,
      if (fingerprintHex != null) #fingerprintHex: fingerprintHex,
      if (messages != null) #messages: messages,
      if (notice != null) #notice: notice,
      if (noticeCount != null) #noticeCount: noticeCount,
      if (removed != null) #removed: removed,
    }),
  );
  @override
  SecretChatState $make(CopyWithData data) => SecretChatState(
    status: data.get(#status, or: $value.status),
    chatID: data.get(#chatID, or: $value.chatID),
    title: data.get(#title, or: $value.title),
    peerUserID: data.get(#peerUserID, or: $value.peerUserID),
    secretStatus: data.get(#secretStatus, or: $value.secretStatus),
    outgoing: data.get(#outgoing, or: $value.outgoing),
    emoji: data.get(#emoji, or: $value.emoji),
    fingerprintHex: data.get(#fingerprintHex, or: $value.fingerprintHex),
    messages: data.get(#messages, or: $value.messages),
    notice: data.get(#notice, or: $value.notice),
    noticeCount: data.get(#noticeCount, or: $value.noticeCount),
    removed: data.get(#removed, or: $value.removed),
  );

  @override
  SecretChatStateCopyWith<$R2, SecretChatState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SecretChatStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

