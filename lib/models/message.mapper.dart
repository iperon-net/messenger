// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'message.dart';

class MessageEntityTypeMapper extends EnumMapper<MessageEntityType> {
  MessageEntityTypeMapper._();

  static MessageEntityTypeMapper? _instance;
  static MessageEntityTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageEntityTypeMapper._());
    }
    return _instance!;
  }

  static MessageEntityType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MessageEntityType decode(dynamic value) {
    switch (value) {
      case r'bold':
        return MessageEntityType.bold;
      case r'italic':
        return MessageEntityType.italic;
      case r'underline':
        return MessageEntityType.underline;
      case r'strike':
        return MessageEntityType.strike;
      case r'spoiler':
        return MessageEntityType.spoiler;
      case r'code':
        return MessageEntityType.code;
      case r'pre':
        return MessageEntityType.pre;
      case r'textUrl':
        return MessageEntityType.textUrl;
      case r'url':
        return MessageEntityType.url;
      case r'mention':
        return MessageEntityType.mention;
      case r'hashtag':
        return MessageEntityType.hashtag;
      case r'email':
        return MessageEntityType.email;
      case r'phone':
        return MessageEntityType.phone;
      case r'blockquote':
        return MessageEntityType.blockquote;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MessageEntityType self) {
    switch (self) {
      case MessageEntityType.bold:
        return r'bold';
      case MessageEntityType.italic:
        return r'italic';
      case MessageEntityType.underline:
        return r'underline';
      case MessageEntityType.strike:
        return r'strike';
      case MessageEntityType.spoiler:
        return r'spoiler';
      case MessageEntityType.code:
        return r'code';
      case MessageEntityType.pre:
        return r'pre';
      case MessageEntityType.textUrl:
        return r'textUrl';
      case MessageEntityType.url:
        return r'url';
      case MessageEntityType.mention:
        return r'mention';
      case MessageEntityType.hashtag:
        return r'hashtag';
      case MessageEntityType.email:
        return r'email';
      case MessageEntityType.phone:
        return r'phone';
      case MessageEntityType.blockquote:
        return r'blockquote';
    }
  }
}

extension MessageEntityTypeMapperExtension on MessageEntityType {
  String toValue() {
    MessageEntityTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MessageEntityType>(this) as String;
  }
}

class MessageEntityMapper extends ClassMapperBase<MessageEntity> {
  MessageEntityMapper._();

  static MessageEntityMapper? _instance;
  static MessageEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageEntityMapper._());
      MessageEntityTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageEntity';

  static MessageEntityType _$type(MessageEntity v) => v.type;
  static const Field<MessageEntity, MessageEntityType> _f$type = Field(
    'type',
    _$type,
  );
  static int _$offset(MessageEntity v) => v.offset;
  static const Field<MessageEntity, int> _f$offset = Field('offset', _$offset);
  static int _$length(MessageEntity v) => v.length;
  static const Field<MessageEntity, int> _f$length = Field('length', _$length);
  static String _$url(MessageEntity v) => v.url;
  static const Field<MessageEntity, String> _f$url = Field(
    'url',
    _$url,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<MessageEntity> fields = const {
    #type: _f$type,
    #offset: _f$offset,
    #length: _f$length,
    #url: _f$url,
  };

  static MessageEntity _instantiate(DecodingData data) {
    return MessageEntity(
      type: data.dec(_f$type),
      offset: data.dec(_f$offset),
      length: data.dec(_f$length),
      url: data.dec(_f$url),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageEntity>(map);
  }

  static MessageEntity fromJson(String json) {
    return ensureInitialized().decodeJson<MessageEntity>(json);
  }
}

mixin MessageEntityMappable {
  String toJson() {
    return MessageEntityMapper.ensureInitialized().encodeJson<MessageEntity>(
      this as MessageEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageEntityMapper.ensureInitialized().encodeMap<MessageEntity>(
      this as MessageEntity,
    );
  }

  MessageEntityCopyWith<MessageEntity, MessageEntity, MessageEntity>
  get copyWith => _MessageEntityCopyWithImpl<MessageEntity, MessageEntity>(
    this as MessageEntity,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MessageEntityMapper.ensureInitialized().stringifyValue(
      this as MessageEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageEntityMapper.ensureInitialized().equalsValue(
      this as MessageEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageEntityMapper.ensureInitialized().hashValue(
      this as MessageEntity,
    );
  }
}

extension MessageEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageEntity, $Out> {
  MessageEntityCopyWith<$R, MessageEntity, $Out> get $asMessageEntity =>
      $base.as((v, t, t2) => _MessageEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageEntityCopyWith<$R, $In extends MessageEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({MessageEntityType? type, int? offset, int? length, String? url});
  MessageEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageEntity, $Out>
    implements MessageEntityCopyWith<$R, MessageEntity, $Out> {
  _MessageEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageEntity> $mapper =
      MessageEntityMapper.ensureInitialized();
  @override
  $R call({MessageEntityType? type, int? offset, int? length, String? url}) =>
      $apply(
        FieldCopyWithData({
          if (type != null) #type: type,
          if (offset != null) #offset: offset,
          if (length != null) #length: length,
          if (url != null) #url: url,
        }),
      );
  @override
  MessageEntity $make(CopyWithData data) => MessageEntity(
    type: data.get(#type, or: $value.type),
    offset: data.get(#offset, or: $value.offset),
    length: data.get(#length, or: $value.length),
    url: data.get(#url, or: $value.url),
  );

  @override
  MessageEntityCopyWith<$R2, MessageEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageReplyMapper extends ClassMapperBase<MessageReply> {
  MessageReplyMapper._();

  static MessageReplyMapper? _instance;
  static MessageReplyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageReplyMapper._());
      MessageKindMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageReply';

  static String _$messageID(MessageReply v) => v.messageID;
  static const Field<MessageReply, String> _f$messageID = Field(
    'messageID',
    _$messageID,
  );
  static String _$senderName(MessageReply v) => v.senderName;
  static const Field<MessageReply, String> _f$senderName = Field(
    'senderName',
    _$senderName,
  );
  static String _$text(MessageReply v) => v.text;
  static const Field<MessageReply, String> _f$text = Field(
    'text',
    _$text,
    opt: true,
    def: '',
  );
  static MessageKind _$kind(MessageReply v) => v.kind;
  static const Field<MessageReply, MessageKind> _f$kind = Field(
    'kind',
    _$kind,
    opt: true,
    def: MessageKind.text,
  );

  @override
  final MappableFields<MessageReply> fields = const {
    #messageID: _f$messageID,
    #senderName: _f$senderName,
    #text: _f$text,
    #kind: _f$kind,
  };

  static MessageReply _instantiate(DecodingData data) {
    return MessageReply(
      messageID: data.dec(_f$messageID),
      senderName: data.dec(_f$senderName),
      text: data.dec(_f$text),
      kind: data.dec(_f$kind),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageReply fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageReply>(map);
  }

  static MessageReply fromJson(String json) {
    return ensureInitialized().decodeJson<MessageReply>(json);
  }
}

mixin MessageReplyMappable {
  String toJson() {
    return MessageReplyMapper.ensureInitialized().encodeJson<MessageReply>(
      this as MessageReply,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageReplyMapper.ensureInitialized().encodeMap<MessageReply>(
      this as MessageReply,
    );
  }

  MessageReplyCopyWith<MessageReply, MessageReply, MessageReply> get copyWith =>
      _MessageReplyCopyWithImpl<MessageReply, MessageReply>(
        this as MessageReply,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageReplyMapper.ensureInitialized().stringifyValue(
      this as MessageReply,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageReplyMapper.ensureInitialized().equalsValue(
      this as MessageReply,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageReplyMapper.ensureInitialized().hashValue(
      this as MessageReply,
    );
  }
}

extension MessageReplyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageReply, $Out> {
  MessageReplyCopyWith<$R, MessageReply, $Out> get $asMessageReply =>
      $base.as((v, t, t2) => _MessageReplyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageReplyCopyWith<$R, $In extends MessageReply, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? messageID,
    String? senderName,
    String? text,
    MessageKind? kind,
  });
  MessageReplyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageReplyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageReply, $Out>
    implements MessageReplyCopyWith<$R, MessageReply, $Out> {
  _MessageReplyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageReply> $mapper =
      MessageReplyMapper.ensureInitialized();
  @override
  $R call({
    String? messageID,
    String? senderName,
    String? text,
    MessageKind? kind,
  }) => $apply(
    FieldCopyWithData({
      if (messageID != null) #messageID: messageID,
      if (senderName != null) #senderName: senderName,
      if (text != null) #text: text,
      if (kind != null) #kind: kind,
    }),
  );
  @override
  MessageReply $make(CopyWithData data) => MessageReply(
    messageID: data.get(#messageID, or: $value.messageID),
    senderName: data.get(#senderName, or: $value.senderName),
    text: data.get(#text, or: $value.text),
    kind: data.get(#kind, or: $value.kind),
  );

  @override
  MessageReplyCopyWith<$R2, MessageReply, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageReplyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageMediaMapper extends ClassMapperBase<MessageMedia> {
  MessageMediaMapper._();

  static MessageMediaMapper? _instance;
  static MessageMediaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageMediaMapper._());
      MessageKindMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageMedia';

  static MessageKind _$kind(MessageMedia v) => v.kind;
  static const Field<MessageMedia, MessageKind> _f$kind = Field('kind', _$kind);
  static String _$localPath(MessageMedia v) => v.localPath;
  static const Field<MessageMedia, String> _f$localPath = Field(
    'localPath',
    _$localPath,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<MessageMedia> fields = const {
    #kind: _f$kind,
    #localPath: _f$localPath,
  };

  static MessageMedia _instantiate(DecodingData data) {
    return MessageMedia(
      kind: data.dec(_f$kind),
      localPath: data.dec(_f$localPath),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageMedia fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageMedia>(map);
  }

  static MessageMedia fromJson(String json) {
    return ensureInitialized().decodeJson<MessageMedia>(json);
  }
}

mixin MessageMediaMappable {
  String toJson() {
    return MessageMediaMapper.ensureInitialized().encodeJson<MessageMedia>(
      this as MessageMedia,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageMediaMapper.ensureInitialized().encodeMap<MessageMedia>(
      this as MessageMedia,
    );
  }

  MessageMediaCopyWith<MessageMedia, MessageMedia, MessageMedia> get copyWith =>
      _MessageMediaCopyWithImpl<MessageMedia, MessageMedia>(
        this as MessageMedia,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageMediaMapper.ensureInitialized().stringifyValue(
      this as MessageMedia,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageMediaMapper.ensureInitialized().equalsValue(
      this as MessageMedia,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageMediaMapper.ensureInitialized().hashValue(
      this as MessageMedia,
    );
  }
}

extension MessageMediaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageMedia, $Out> {
  MessageMediaCopyWith<$R, MessageMedia, $Out> get $asMessageMedia =>
      $base.as((v, t, t2) => _MessageMediaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageMediaCopyWith<$R, $In extends MessageMedia, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({MessageKind? kind, String? localPath});
  MessageMediaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageMediaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageMedia, $Out>
    implements MessageMediaCopyWith<$R, MessageMedia, $Out> {
  _MessageMediaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageMedia> $mapper =
      MessageMediaMapper.ensureInitialized();
  @override
  $R call({MessageKind? kind, String? localPath}) => $apply(
    FieldCopyWithData({
      if (kind != null) #kind: kind,
      if (localPath != null) #localPath: localPath,
    }),
  );
  @override
  MessageMedia $make(CopyWithData data) => MessageMedia(
    kind: data.get(#kind, or: $value.kind),
    localPath: data.get(#localPath, or: $value.localPath),
  );

  @override
  MessageMediaCopyWith<$R2, MessageMedia, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageMediaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageMapper extends ClassMapperBase<Message> {
  MessageMapper._();

  static MessageMapper? _instance;
  static MessageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageMapper._());
      MessageKindMapper.ensureInitialized();
      MessageEntityMapper.ensureInitialized();
      MessageStatusMapper.ensureInitialized();
      MessageReplyMapper.ensureInitialized();
      MessageMediaMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Message';

  static String _$id(Message v) => v.id;
  static const Field<Message, String> _f$id = Field('id', _$id);
  static String _$chatID(Message v) => v.chatID;
  static const Field<Message, String> _f$chatID = Field('chatID', _$chatID);
  static MessageKind _$kind(Message v) => v.kind;
  static const Field<Message, MessageKind> _f$kind = Field(
    'kind',
    _$kind,
    opt: true,
    def: MessageKind.text,
  );
  static String _$text(Message v) => v.text;
  static const Field<Message, String> _f$text = Field(
    'text',
    _$text,
    opt: true,
    def: '',
  );
  static List<MessageEntity> _$entities(Message v) => v.entities;
  static const Field<Message, List<MessageEntity>> _f$entities = Field(
    'entities',
    _$entities,
    opt: true,
    def: const [],
  );
  static bool _$outgoing(Message v) => v.outgoing;
  static const Field<Message, bool> _f$outgoing = Field(
    'outgoing',
    _$outgoing,
    opt: true,
    def: false,
  );
  static String _$senderName(Message v) => v.senderName;
  static const Field<Message, String> _f$senderName = Field(
    'senderName',
    _$senderName,
    opt: true,
    def: '',
  );
  static MessageStatus _$status(Message v) => v.status;
  static const Field<Message, MessageStatus> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: MessageStatus.sent,
  );
  static DateTime _$date(Message v) => v.date;
  static const Field<Message, DateTime> _f$date = Field('date', _$date);
  static bool _$edited(Message v) => v.edited;
  static const Field<Message, bool> _f$edited = Field(
    'edited',
    _$edited,
    opt: true,
    def: false,
  );
  static MessageReply? _$reply(Message v) => v.reply;
  static const Field<Message, MessageReply> _f$reply = Field(
    'reply',
    _$reply,
    opt: true,
  );
  static bool _$service(Message v) => v.service;
  static const Field<Message, bool> _f$service = Field(
    'service',
    _$service,
    opt: true,
    def: false,
  );
  static String _$fileName(Message v) => v.fileName;
  static const Field<Message, String> _f$fileName = Field(
    'fileName',
    _$fileName,
    opt: true,
    def: '',
  );
  static String _$localPath(Message v) => v.localPath;
  static const Field<Message, String> _f$localPath = Field(
    'localPath',
    _$localPath,
    opt: true,
    def: '',
  );
  static int _$duration(Message v) => v.duration;
  static const Field<Message, int> _f$duration = Field(
    'duration',
    _$duration,
    opt: true,
    def: 0,
  );
  static List<MessageMedia> _$media(Message v) => v.media;
  static const Field<Message, List<MessageMedia>> _f$media = Field(
    'media',
    _$media,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<Message> fields = const {
    #id: _f$id,
    #chatID: _f$chatID,
    #kind: _f$kind,
    #text: _f$text,
    #entities: _f$entities,
    #outgoing: _f$outgoing,
    #senderName: _f$senderName,
    #status: _f$status,
    #date: _f$date,
    #edited: _f$edited,
    #reply: _f$reply,
    #service: _f$service,
    #fileName: _f$fileName,
    #localPath: _f$localPath,
    #duration: _f$duration,
    #media: _f$media,
  };

  static Message _instantiate(DecodingData data) {
    return Message(
      id: data.dec(_f$id),
      chatID: data.dec(_f$chatID),
      kind: data.dec(_f$kind),
      text: data.dec(_f$text),
      entities: data.dec(_f$entities),
      outgoing: data.dec(_f$outgoing),
      senderName: data.dec(_f$senderName),
      status: data.dec(_f$status),
      date: data.dec(_f$date),
      edited: data.dec(_f$edited),
      reply: data.dec(_f$reply),
      service: data.dec(_f$service),
      fileName: data.dec(_f$fileName),
      localPath: data.dec(_f$localPath),
      duration: data.dec(_f$duration),
      media: data.dec(_f$media),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Message fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Message>(map);
  }

  static Message fromJson(String json) {
    return ensureInitialized().decodeJson<Message>(json);
  }
}

mixin MessageMappable {
  String toJson() {
    return MessageMapper.ensureInitialized().encodeJson<Message>(
      this as Message,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageMapper.ensureInitialized().encodeMap<Message>(
      this as Message,
    );
  }

  MessageCopyWith<Message, Message, Message> get copyWith =>
      _MessageCopyWithImpl<Message, Message>(
        this as Message,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageMapper.ensureInitialized().stringifyValue(this as Message);
  }

  @override
  bool operator ==(Object other) {
    return MessageMapper.ensureInitialized().equalsValue(
      this as Message,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageMapper.ensureInitialized().hashValue(this as Message);
  }
}

extension MessageValueCopy<$R, $Out> on ObjectCopyWith<$R, Message, $Out> {
  MessageCopyWith<$R, Message, $Out> get $asMessage =>
      $base.as((v, t, t2) => _MessageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageCopyWith<$R, $In extends Message, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    MessageEntity,
    MessageEntityCopyWith<$R, MessageEntity, MessageEntity>
  >
  get entities;
  MessageReplyCopyWith<$R, MessageReply, MessageReply>? get reply;
  ListCopyWith<
    $R,
    MessageMedia,
    MessageMediaCopyWith<$R, MessageMedia, MessageMedia>
  >
  get media;
  $R call({
    String? id,
    String? chatID,
    MessageKind? kind,
    String? text,
    List<MessageEntity>? entities,
    bool? outgoing,
    String? senderName,
    MessageStatus? status,
    DateTime? date,
    bool? edited,
    MessageReply? reply,
    bool? service,
    String? fileName,
    String? localPath,
    int? duration,
    List<MessageMedia>? media,
  });
  MessageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Message, $Out>
    implements MessageCopyWith<$R, Message, $Out> {
  _MessageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Message> $mapper =
      MessageMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    MessageEntity,
    MessageEntityCopyWith<$R, MessageEntity, MessageEntity>
  >
  get entities => ListCopyWith(
    $value.entities,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(entities: v),
  );
  @override
  MessageReplyCopyWith<$R, MessageReply, MessageReply>? get reply =>
      $value.reply?.copyWith.$chain((v) => call(reply: v));
  @override
  ListCopyWith<
    $R,
    MessageMedia,
    MessageMediaCopyWith<$R, MessageMedia, MessageMedia>
  >
  get media => ListCopyWith(
    $value.media,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(media: v),
  );
  @override
  $R call({
    String? id,
    String? chatID,
    MessageKind? kind,
    String? text,
    List<MessageEntity>? entities,
    bool? outgoing,
    String? senderName,
    MessageStatus? status,
    DateTime? date,
    bool? edited,
    Object? reply = $none,
    bool? service,
    String? fileName,
    String? localPath,
    int? duration,
    List<MessageMedia>? media,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (chatID != null) #chatID: chatID,
      if (kind != null) #kind: kind,
      if (text != null) #text: text,
      if (entities != null) #entities: entities,
      if (outgoing != null) #outgoing: outgoing,
      if (senderName != null) #senderName: senderName,
      if (status != null) #status: status,
      if (date != null) #date: date,
      if (edited != null) #edited: edited,
      if (reply != $none) #reply: reply,
      if (service != null) #service: service,
      if (fileName != null) #fileName: fileName,
      if (localPath != null) #localPath: localPath,
      if (duration != null) #duration: duration,
      if (media != null) #media: media,
    }),
  );
  @override
  Message $make(CopyWithData data) => Message(
    id: data.get(#id, or: $value.id),
    chatID: data.get(#chatID, or: $value.chatID),
    kind: data.get(#kind, or: $value.kind),
    text: data.get(#text, or: $value.text),
    entities: data.get(#entities, or: $value.entities),
    outgoing: data.get(#outgoing, or: $value.outgoing),
    senderName: data.get(#senderName, or: $value.senderName),
    status: data.get(#status, or: $value.status),
    date: data.get(#date, or: $value.date),
    edited: data.get(#edited, or: $value.edited),
    reply: data.get(#reply, or: $value.reply),
    service: data.get(#service, or: $value.service),
    fileName: data.get(#fileName, or: $value.fileName),
    localPath: data.get(#localPath, or: $value.localPath),
    duration: data.get(#duration, or: $value.duration),
    media: data.get(#media, or: $value.media),
  );

  @override
  MessageCopyWith<$R2, Message, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

