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
      case r'mentionName':
        return MessageEntityType.mentionName;
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
      case MessageEntityType.mentionName:
        return r'mentionName';
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
  static String _$userID(MessageEntity v) => v.userID;
  static const Field<MessageEntity, String> _f$userID = Field(
    'userID',
    _$userID,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<MessageEntity> fields = const {
    #type: _f$type,
    #offset: _f$offset,
    #length: _f$length,
    #url: _f$url,
    #userID: _f$userID,
  };

  static MessageEntity _instantiate(DecodingData data) {
    return MessageEntity(
      type: data.dec(_f$type),
      offset: data.dec(_f$offset),
      length: data.dec(_f$length),
      url: data.dec(_f$url),
      userID: data.dec(_f$userID),
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
  $R call({
    MessageEntityType? type,
    int? offset,
    int? length,
    String? url,
    String? userID,
  });
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
  $R call({
    MessageEntityType? type,
    int? offset,
    int? length,
    String? url,
    String? userID,
  }) => $apply(
    FieldCopyWithData({
      if (type != null) #type: type,
      if (offset != null) #offset: offset,
      if (length != null) #length: length,
      if (url != null) #url: url,
      if (userID != null) #userID: userID,
    }),
  );
  @override
  MessageEntity $make(CopyWithData data) => MessageEntity(
    type: data.get(#type, or: $value.type),
    offset: data.get(#offset, or: $value.offset),
    length: data.get(#length, or: $value.length),
    url: data.get(#url, or: $value.url),
    userID: data.get(#userID, or: $value.userID),
  );

  @override
  MessageEntityCopyWith<$R2, MessageEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PollOptionMapper extends ClassMapperBase<PollOption> {
  PollOptionMapper._();

  static PollOptionMapper? _instance;
  static PollOptionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PollOptionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PollOption';

  static String _$text(PollOption v) => v.text;
  static const Field<PollOption, String> _f$text = Field('text', _$text);
  static int _$votes(PollOption v) => v.votes;
  static const Field<PollOption, int> _f$votes = Field(
    'votes',
    _$votes,
    opt: true,
    def: 0,
  );
  static bool _$chosen(PollOption v) => v.chosen;
  static const Field<PollOption, bool> _f$chosen = Field(
    'chosen',
    _$chosen,
    opt: true,
    def: false,
  );
  static bool _$correct(PollOption v) => v.correct;
  static const Field<PollOption, bool> _f$correct = Field(
    'correct',
    _$correct,
    opt: true,
    def: false,
  );
  static List<String> _$voters(PollOption v) => v.voters;
  static const Field<PollOption, List<String>> _f$voters = Field(
    'voters',
    _$voters,
    opt: true,
    def: const [],
  );

  @override
  final MappableFields<PollOption> fields = const {
    #text: _f$text,
    #votes: _f$votes,
    #chosen: _f$chosen,
    #correct: _f$correct,
    #voters: _f$voters,
  };

  static PollOption _instantiate(DecodingData data) {
    return PollOption(
      text: data.dec(_f$text),
      votes: data.dec(_f$votes),
      chosen: data.dec(_f$chosen),
      correct: data.dec(_f$correct),
      voters: data.dec(_f$voters),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PollOption fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PollOption>(map);
  }

  static PollOption fromJson(String json) {
    return ensureInitialized().decodeJson<PollOption>(json);
  }
}

mixin PollOptionMappable {
  String toJson() {
    return PollOptionMapper.ensureInitialized().encodeJson<PollOption>(
      this as PollOption,
    );
  }

  Map<String, dynamic> toMap() {
    return PollOptionMapper.ensureInitialized().encodeMap<PollOption>(
      this as PollOption,
    );
  }

  PollOptionCopyWith<PollOption, PollOption, PollOption> get copyWith =>
      _PollOptionCopyWithImpl<PollOption, PollOption>(
        this as PollOption,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PollOptionMapper.ensureInitialized().stringifyValue(
      this as PollOption,
    );
  }

  @override
  bool operator ==(Object other) {
    return PollOptionMapper.ensureInitialized().equalsValue(
      this as PollOption,
      other,
    );
  }

  @override
  int get hashCode {
    return PollOptionMapper.ensureInitialized().hashValue(this as PollOption);
  }
}

extension PollOptionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PollOption, $Out> {
  PollOptionCopyWith<$R, PollOption, $Out> get $asPollOption =>
      $base.as((v, t, t2) => _PollOptionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PollOptionCopyWith<$R, $In extends PollOption, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get voters;
  $R call({
    String? text,
    int? votes,
    bool? chosen,
    bool? correct,
    List<String>? voters,
  });
  PollOptionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PollOptionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PollOption, $Out>
    implements PollOptionCopyWith<$R, PollOption, $Out> {
  _PollOptionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PollOption> $mapper =
      PollOptionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get voters =>
      ListCopyWith(
        $value.voters,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(voters: v),
      );
  @override
  $R call({
    String? text,
    int? votes,
    bool? chosen,
    bool? correct,
    List<String>? voters,
  }) => $apply(
    FieldCopyWithData({
      if (text != null) #text: text,
      if (votes != null) #votes: votes,
      if (chosen != null) #chosen: chosen,
      if (correct != null) #correct: correct,
      if (voters != null) #voters: voters,
    }),
  );
  @override
  PollOption $make(CopyWithData data) => PollOption(
    text: data.get(#text, or: $value.text),
    votes: data.get(#votes, or: $value.votes),
    chosen: data.get(#chosen, or: $value.chosen),
    correct: data.get(#correct, or: $value.correct),
    voters: data.get(#voters, or: $value.voters),
  );

  @override
  PollOptionCopyWith<$R2, PollOption, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PollOptionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessagePollMapper extends ClassMapperBase<MessagePoll> {
  MessagePollMapper._();

  static MessagePollMapper? _instance;
  static MessagePollMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessagePollMapper._());
      PollOptionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessagePoll';

  static String _$question(MessagePoll v) => v.question;
  static const Field<MessagePoll, String> _f$question = Field(
    'question',
    _$question,
  );
  static List<PollOption> _$options(MessagePoll v) => v.options;
  static const Field<MessagePoll, List<PollOption>> _f$options = Field(
    'options',
    _$options,
  );
  static bool _$anonymous(MessagePoll v) => v.anonymous;
  static const Field<MessagePoll, bool> _f$anonymous = Field(
    'anonymous',
    _$anonymous,
    opt: true,
    def: true,
  );
  static bool _$multiple(MessagePoll v) => v.multiple;
  static const Field<MessagePoll, bool> _f$multiple = Field(
    'multiple',
    _$multiple,
    opt: true,
    def: false,
  );
  static bool _$quiz(MessagePoll v) => v.quiz;
  static const Field<MessagePoll, bool> _f$quiz = Field(
    'quiz',
    _$quiz,
    opt: true,
    def: false,
  );
  static String _$explanation(MessagePoll v) => v.explanation;
  static const Field<MessagePoll, String> _f$explanation = Field(
    'explanation',
    _$explanation,
    opt: true,
    def: '',
  );
  static bool _$closed(MessagePoll v) => v.closed;
  static const Field<MessagePoll, bool> _f$closed = Field(
    'closed',
    _$closed,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<MessagePoll> fields = const {
    #question: _f$question,
    #options: _f$options,
    #anonymous: _f$anonymous,
    #multiple: _f$multiple,
    #quiz: _f$quiz,
    #explanation: _f$explanation,
    #closed: _f$closed,
  };

  static MessagePoll _instantiate(DecodingData data) {
    return MessagePoll(
      question: data.dec(_f$question),
      options: data.dec(_f$options),
      anonymous: data.dec(_f$anonymous),
      multiple: data.dec(_f$multiple),
      quiz: data.dec(_f$quiz),
      explanation: data.dec(_f$explanation),
      closed: data.dec(_f$closed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessagePoll fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessagePoll>(map);
  }

  static MessagePoll fromJson(String json) {
    return ensureInitialized().decodeJson<MessagePoll>(json);
  }
}

mixin MessagePollMappable {
  String toJson() {
    return MessagePollMapper.ensureInitialized().encodeJson<MessagePoll>(
      this as MessagePoll,
    );
  }

  Map<String, dynamic> toMap() {
    return MessagePollMapper.ensureInitialized().encodeMap<MessagePoll>(
      this as MessagePoll,
    );
  }

  MessagePollCopyWith<MessagePoll, MessagePoll, MessagePoll> get copyWith =>
      _MessagePollCopyWithImpl<MessagePoll, MessagePoll>(
        this as MessagePoll,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessagePollMapper.ensureInitialized().stringifyValue(
      this as MessagePoll,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessagePollMapper.ensureInitialized().equalsValue(
      this as MessagePoll,
      other,
    );
  }

  @override
  int get hashCode {
    return MessagePollMapper.ensureInitialized().hashValue(this as MessagePoll);
  }
}

extension MessagePollValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessagePoll, $Out> {
  MessagePollCopyWith<$R, MessagePoll, $Out> get $asMessagePoll =>
      $base.as((v, t, t2) => _MessagePollCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessagePollCopyWith<$R, $In extends MessagePoll, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, PollOption, PollOptionCopyWith<$R, PollOption, PollOption>>
  get options;
  $R call({
    String? question,
    List<PollOption>? options,
    bool? anonymous,
    bool? multiple,
    bool? quiz,
    String? explanation,
    bool? closed,
  });
  MessagePollCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessagePollCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessagePoll, $Out>
    implements MessagePollCopyWith<$R, MessagePoll, $Out> {
  _MessagePollCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessagePoll> $mapper =
      MessagePollMapper.ensureInitialized();
  @override
  ListCopyWith<$R, PollOption, PollOptionCopyWith<$R, PollOption, PollOption>>
  get options => ListCopyWith(
    $value.options,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(options: v),
  );
  @override
  $R call({
    String? question,
    List<PollOption>? options,
    bool? anonymous,
    bool? multiple,
    bool? quiz,
    String? explanation,
    bool? closed,
  }) => $apply(
    FieldCopyWithData({
      if (question != null) #question: question,
      if (options != null) #options: options,
      if (anonymous != null) #anonymous: anonymous,
      if (multiple != null) #multiple: multiple,
      if (quiz != null) #quiz: quiz,
      if (explanation != null) #explanation: explanation,
      if (closed != null) #closed: closed,
    }),
  );
  @override
  MessagePoll $make(CopyWithData data) => MessagePoll(
    question: data.get(#question, or: $value.question),
    options: data.get(#options, or: $value.options),
    anonymous: data.get(#anonymous, or: $value.anonymous),
    multiple: data.get(#multiple, or: $value.multiple),
    quiz: data.get(#quiz, or: $value.quiz),
    explanation: data.get(#explanation, or: $value.explanation),
    closed: data.get(#closed, or: $value.closed),
  );

  @override
  MessagePollCopyWith<$R2, MessagePoll, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessagePollCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageReplyMapper extends ClassMapperBase<MessageReply> {
  MessageReplyMapper._();

  static MessageReplyMapper? _instance;
  static MessageReplyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageReplyMapper._());
      MessageKindMapper.ensureInitialized();
      MessageQuoteMapper.ensureInitialized();
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
  static MessageQuote? _$quote(MessageReply v) => v.quote;
  static const Field<MessageReply, MessageQuote> _f$quote = Field(
    'quote',
    _$quote,
    opt: true,
  );

  @override
  final MappableFields<MessageReply> fields = const {
    #messageID: _f$messageID,
    #senderName: _f$senderName,
    #text: _f$text,
    #kind: _f$kind,
    #quote: _f$quote,
  };

  static MessageReply _instantiate(DecodingData data) {
    return MessageReply(
      messageID: data.dec(_f$messageID),
      senderName: data.dec(_f$senderName),
      text: data.dec(_f$text),
      kind: data.dec(_f$kind),
      quote: data.dec(_f$quote),
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
  MessageQuoteCopyWith<$R, MessageQuote, MessageQuote>? get quote;
  $R call({
    String? messageID,
    String? senderName,
    String? text,
    MessageKind? kind,
    MessageQuote? quote,
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
  MessageQuoteCopyWith<$R, MessageQuote, MessageQuote>? get quote =>
      $value.quote?.copyWith.$chain((v) => call(quote: v));
  @override
  $R call({
    String? messageID,
    String? senderName,
    String? text,
    MessageKind? kind,
    Object? quote = $none,
  }) => $apply(
    FieldCopyWithData({
      if (messageID != null) #messageID: messageID,
      if (senderName != null) #senderName: senderName,
      if (text != null) #text: text,
      if (kind != null) #kind: kind,
      if (quote != $none) #quote: quote,
    }),
  );
  @override
  MessageReply $make(CopyWithData data) => MessageReply(
    messageID: data.get(#messageID, or: $value.messageID),
    senderName: data.get(#senderName, or: $value.senderName),
    text: data.get(#text, or: $value.text),
    kind: data.get(#kind, or: $value.kind),
    quote: data.get(#quote, or: $value.quote),
  );

  @override
  MessageReplyCopyWith<$R2, MessageReply, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageReplyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageQuoteMapper extends ClassMapperBase<MessageQuote> {
  MessageQuoteMapper._();

  static MessageQuoteMapper? _instance;
  static MessageQuoteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageQuoteMapper._());
      MessageEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MessageQuote';

  static String _$text(MessageQuote v) => v.text;
  static const Field<MessageQuote, String> _f$text = Field('text', _$text);
  static List<MessageEntity> _$entities(MessageQuote v) => v.entities;
  static const Field<MessageQuote, List<MessageEntity>> _f$entities = Field(
    'entities',
    _$entities,
    opt: true,
    def: const [],
  );
  static int _$offset(MessageQuote v) => v.offset;
  static const Field<MessageQuote, int> _f$offset = Field(
    'offset',
    _$offset,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<MessageQuote> fields = const {
    #text: _f$text,
    #entities: _f$entities,
    #offset: _f$offset,
  };

  static MessageQuote _instantiate(DecodingData data) {
    return MessageQuote(
      text: data.dec(_f$text),
      entities: data.dec(_f$entities),
      offset: data.dec(_f$offset),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageQuote fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageQuote>(map);
  }

  static MessageQuote fromJson(String json) {
    return ensureInitialized().decodeJson<MessageQuote>(json);
  }
}

mixin MessageQuoteMappable {
  String toJson() {
    return MessageQuoteMapper.ensureInitialized().encodeJson<MessageQuote>(
      this as MessageQuote,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageQuoteMapper.ensureInitialized().encodeMap<MessageQuote>(
      this as MessageQuote,
    );
  }

  MessageQuoteCopyWith<MessageQuote, MessageQuote, MessageQuote> get copyWith =>
      _MessageQuoteCopyWithImpl<MessageQuote, MessageQuote>(
        this as MessageQuote,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageQuoteMapper.ensureInitialized().stringifyValue(
      this as MessageQuote,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageQuoteMapper.ensureInitialized().equalsValue(
      this as MessageQuote,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageQuoteMapper.ensureInitialized().hashValue(
      this as MessageQuote,
    );
  }
}

extension MessageQuoteValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageQuote, $Out> {
  MessageQuoteCopyWith<$R, MessageQuote, $Out> get $asMessageQuote =>
      $base.as((v, t, t2) => _MessageQuoteCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageQuoteCopyWith<$R, $In extends MessageQuote, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    MessageEntity,
    MessageEntityCopyWith<$R, MessageEntity, MessageEntity>
  >
  get entities;
  $R call({String? text, List<MessageEntity>? entities, int? offset});
  MessageQuoteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MessageQuoteCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageQuote, $Out>
    implements MessageQuoteCopyWith<$R, MessageQuote, $Out> {
  _MessageQuoteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageQuote> $mapper =
      MessageQuoteMapper.ensureInitialized();
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
  $R call({String? text, List<MessageEntity>? entities, int? offset}) => $apply(
    FieldCopyWithData({
      if (text != null) #text: text,
      if (entities != null) #entities: entities,
      if (offset != null) #offset: offset,
    }),
  );
  @override
  MessageQuote $make(CopyWithData data) => MessageQuote(
    text: data.get(#text, or: $value.text),
    entities: data.get(#entities, or: $value.entities),
    offset: data.get(#offset, or: $value.offset),
  );

  @override
  MessageQuoteCopyWith<$R2, MessageQuote, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageQuoteCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageForwardMapper extends ClassMapperBase<MessageForward> {
  MessageForwardMapper._();

  static MessageForwardMapper? _instance;
  static MessageForwardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageForwardMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MessageForward';

  static String _$name(MessageForward v) => v.name;
  static const Field<MessageForward, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
    def: '',
  );
  static bool _$self(MessageForward v) => v.self;
  static const Field<MessageForward, bool> _f$self = Field(
    'self',
    _$self,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<MessageForward> fields = const {
    #name: _f$name,
    #self: _f$self,
  };

  static MessageForward _instantiate(DecodingData data) {
    return MessageForward(name: data.dec(_f$name), self: data.dec(_f$self));
  }

  @override
  final Function instantiate = _instantiate;

  static MessageForward fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageForward>(map);
  }

  static MessageForward fromJson(String json) {
    return ensureInitialized().decodeJson<MessageForward>(json);
  }
}

mixin MessageForwardMappable {
  String toJson() {
    return MessageForwardMapper.ensureInitialized().encodeJson<MessageForward>(
      this as MessageForward,
    );
  }

  Map<String, dynamic> toMap() {
    return MessageForwardMapper.ensureInitialized().encodeMap<MessageForward>(
      this as MessageForward,
    );
  }

  MessageForwardCopyWith<MessageForward, MessageForward, MessageForward>
  get copyWith => _MessageForwardCopyWithImpl<MessageForward, MessageForward>(
    this as MessageForward,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MessageForwardMapper.ensureInitialized().stringifyValue(
      this as MessageForward,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageForwardMapper.ensureInitialized().equalsValue(
      this as MessageForward,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageForwardMapper.ensureInitialized().hashValue(
      this as MessageForward,
    );
  }
}

extension MessageForwardValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageForward, $Out> {
  MessageForwardCopyWith<$R, MessageForward, $Out> get $asMessageForward =>
      $base.as((v, t, t2) => _MessageForwardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageForwardCopyWith<$R, $In extends MessageForward, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, bool? self});
  MessageForwardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageForwardCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageForward, $Out>
    implements MessageForwardCopyWith<$R, MessageForward, $Out> {
  _MessageForwardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageForward> $mapper =
      MessageForwardMapper.ensureInitialized();
  @override
  $R call({String? name, bool? self}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (self != null) #self: self,
    }),
  );
  @override
  MessageForward $make(CopyWithData data) => MessageForward(
    name: data.get(#name, or: $value.name),
    self: data.get(#self, or: $value.self),
  );

  @override
  MessageForwardCopyWith<$R2, MessageForward, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageForwardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageReactionMapper extends ClassMapperBase<MessageReaction> {
  MessageReactionMapper._();

  static MessageReactionMapper? _instance;
  static MessageReactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageReactionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MessageReaction';

  static String _$emoji(MessageReaction v) => v.emoji;
  static const Field<MessageReaction, String> _f$emoji = Field(
    'emoji',
    _$emoji,
  );
  static int _$count(MessageReaction v) => v.count;
  static const Field<MessageReaction, int> _f$count = Field(
    'count',
    _$count,
    opt: true,
    def: 1,
  );
  static bool _$chosen(MessageReaction v) => v.chosen;
  static const Field<MessageReaction, bool> _f$chosen = Field(
    'chosen',
    _$chosen,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<MessageReaction> fields = const {
    #emoji: _f$emoji,
    #count: _f$count,
    #chosen: _f$chosen,
  };

  static MessageReaction _instantiate(DecodingData data) {
    return MessageReaction(
      emoji: data.dec(_f$emoji),
      count: data.dec(_f$count),
      chosen: data.dec(_f$chosen),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageReaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageReaction>(map);
  }

  static MessageReaction fromJson(String json) {
    return ensureInitialized().decodeJson<MessageReaction>(json);
  }
}

mixin MessageReactionMappable {
  String toJson() {
    return MessageReactionMapper.ensureInitialized()
        .encodeJson<MessageReaction>(this as MessageReaction);
  }

  Map<String, dynamic> toMap() {
    return MessageReactionMapper.ensureInitialized().encodeMap<MessageReaction>(
      this as MessageReaction,
    );
  }

  MessageReactionCopyWith<MessageReaction, MessageReaction, MessageReaction>
  get copyWith =>
      _MessageReactionCopyWithImpl<MessageReaction, MessageReaction>(
        this as MessageReaction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageReactionMapper.ensureInitialized().stringifyValue(
      this as MessageReaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageReactionMapper.ensureInitialized().equalsValue(
      this as MessageReaction,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageReactionMapper.ensureInitialized().hashValue(
      this as MessageReaction,
    );
  }
}

extension MessageReactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageReaction, $Out> {
  MessageReactionCopyWith<$R, MessageReaction, $Out> get $asMessageReaction =>
      $base.as((v, t, t2) => _MessageReactionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MessageReactionCopyWith<$R, $In extends MessageReaction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? emoji, int? count, bool? chosen});
  MessageReactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageReactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageReaction, $Out>
    implements MessageReactionCopyWith<$R, MessageReaction, $Out> {
  _MessageReactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageReaction> $mapper =
      MessageReactionMapper.ensureInitialized();
  @override
  $R call({String? emoji, int? count, bool? chosen}) => $apply(
    FieldCopyWithData({
      if (emoji != null) #emoji: emoji,
      if (count != null) #count: count,
      if (chosen != null) #chosen: chosen,
    }),
  );
  @override
  MessageReaction $make(CopyWithData data) => MessageReaction(
    emoji: data.get(#emoji, or: $value.emoji),
    count: data.get(#count, or: $value.count),
    chosen: data.get(#chosen, or: $value.chosen),
  );

  @override
  MessageReactionCopyWith<$R2, MessageReaction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageReactionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class MessageLinkPreviewMapper extends ClassMapperBase<MessageLinkPreview> {
  MessageLinkPreviewMapper._();

  static MessageLinkPreviewMapper? _instance;
  static MessageLinkPreviewMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MessageLinkPreviewMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MessageLinkPreview';

  static String _$url(MessageLinkPreview v) => v.url;
  static const Field<MessageLinkPreview, String> _f$url = Field('url', _$url);
  static String _$siteName(MessageLinkPreview v) => v.siteName;
  static const Field<MessageLinkPreview, String> _f$siteName = Field(
    'siteName',
    _$siteName,
    opt: true,
    def: '',
  );
  static String _$title(MessageLinkPreview v) => v.title;
  static const Field<MessageLinkPreview, String> _f$title = Field(
    'title',
    _$title,
    opt: true,
    def: '',
  );
  static String _$description(MessageLinkPreview v) => v.description;
  static const Field<MessageLinkPreview, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
    def: '',
  );

  @override
  final MappableFields<MessageLinkPreview> fields = const {
    #url: _f$url,
    #siteName: _f$siteName,
    #title: _f$title,
    #description: _f$description,
  };

  static MessageLinkPreview _instantiate(DecodingData data) {
    return MessageLinkPreview(
      url: data.dec(_f$url),
      siteName: data.dec(_f$siteName),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MessageLinkPreview fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MessageLinkPreview>(map);
  }

  static MessageLinkPreview fromJson(String json) {
    return ensureInitialized().decodeJson<MessageLinkPreview>(json);
  }
}

mixin MessageLinkPreviewMappable {
  String toJson() {
    return MessageLinkPreviewMapper.ensureInitialized()
        .encodeJson<MessageLinkPreview>(this as MessageLinkPreview);
  }

  Map<String, dynamic> toMap() {
    return MessageLinkPreviewMapper.ensureInitialized()
        .encodeMap<MessageLinkPreview>(this as MessageLinkPreview);
  }

  MessageLinkPreviewCopyWith<
    MessageLinkPreview,
    MessageLinkPreview,
    MessageLinkPreview
  >
  get copyWith =>
      _MessageLinkPreviewCopyWithImpl<MessageLinkPreview, MessageLinkPreview>(
        this as MessageLinkPreview,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MessageLinkPreviewMapper.ensureInitialized().stringifyValue(
      this as MessageLinkPreview,
    );
  }

  @override
  bool operator ==(Object other) {
    return MessageLinkPreviewMapper.ensureInitialized().equalsValue(
      this as MessageLinkPreview,
      other,
    );
  }

  @override
  int get hashCode {
    return MessageLinkPreviewMapper.ensureInitialized().hashValue(
      this as MessageLinkPreview,
    );
  }
}

extension MessageLinkPreviewValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MessageLinkPreview, $Out> {
  MessageLinkPreviewCopyWith<$R, MessageLinkPreview, $Out>
  get $asMessageLinkPreview => $base.as(
    (v, t, t2) => _MessageLinkPreviewCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class MessageLinkPreviewCopyWith<
  $R,
  $In extends MessageLinkPreview,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? url, String? siteName, String? title, String? description});
  MessageLinkPreviewCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MessageLinkPreviewCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MessageLinkPreview, $Out>
    implements MessageLinkPreviewCopyWith<$R, MessageLinkPreview, $Out> {
  _MessageLinkPreviewCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MessageLinkPreview> $mapper =
      MessageLinkPreviewMapper.ensureInitialized();
  @override
  $R call({
    String? url,
    String? siteName,
    String? title,
    String? description,
  }) => $apply(
    FieldCopyWithData({
      if (url != null) #url: url,
      if (siteName != null) #siteName: siteName,
      if (title != null) #title: title,
      if (description != null) #description: description,
    }),
  );
  @override
  MessageLinkPreview $make(CopyWithData data) => MessageLinkPreview(
    url: data.get(#url, or: $value.url),
    siteName: data.get(#siteName, or: $value.siteName),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
  );

  @override
  MessageLinkPreviewCopyWith<$R2, MessageLinkPreview, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MessageLinkPreviewCopyWithImpl<$R2, $Out2>($value, $cast, t);
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
  static int _$width(MessageMedia v) => v.width;
  static const Field<MessageMedia, int> _f$width = Field(
    'width',
    _$width,
    opt: true,
    def: 0,
  );
  static int _$height(MessageMedia v) => v.height;
  static const Field<MessageMedia, int> _f$height = Field(
    'height',
    _$height,
    opt: true,
    def: 0,
  );
  static int _$size(MessageMedia v) => v.size;
  static const Field<MessageMedia, int> _f$size = Field(
    'size',
    _$size,
    opt: true,
    def: 0,
  );
  static String _$thumbPath(MessageMedia v) => v.thumbPath;
  static const Field<MessageMedia, String> _f$thumbPath = Field(
    'thumbPath',
    _$thumbPath,
    opt: true,
    def: '',
  );
  static String _$thumbhash(MessageMedia v) => v.thumbhash;
  static const Field<MessageMedia, String> _f$thumbhash = Field(
    'thumbhash',
    _$thumbhash,
    opt: true,
    def: '',
  );
  static bool _$spoiler(MessageMedia v) => v.spoiler;
  static const Field<MessageMedia, bool> _f$spoiler = Field(
    'spoiler',
    _$spoiler,
    opt: true,
    def: false,
  );
  static int _$duration(MessageMedia v) => v.duration;
  static const Field<MessageMedia, int> _f$duration = Field(
    'duration',
    _$duration,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<MessageMedia> fields = const {
    #kind: _f$kind,
    #localPath: _f$localPath,
    #width: _f$width,
    #height: _f$height,
    #size: _f$size,
    #thumbPath: _f$thumbPath,
    #thumbhash: _f$thumbhash,
    #spoiler: _f$spoiler,
    #duration: _f$duration,
  };

  static MessageMedia _instantiate(DecodingData data) {
    return MessageMedia(
      kind: data.dec(_f$kind),
      localPath: data.dec(_f$localPath),
      width: data.dec(_f$width),
      height: data.dec(_f$height),
      size: data.dec(_f$size),
      thumbPath: data.dec(_f$thumbPath),
      thumbhash: data.dec(_f$thumbhash),
      spoiler: data.dec(_f$spoiler),
      duration: data.dec(_f$duration),
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
  $R call({
    MessageKind? kind,
    String? localPath,
    int? width,
    int? height,
    int? size,
    String? thumbPath,
    String? thumbhash,
    bool? spoiler,
    int? duration,
  });
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
  $R call({
    MessageKind? kind,
    String? localPath,
    int? width,
    int? height,
    int? size,
    String? thumbPath,
    String? thumbhash,
    bool? spoiler,
    int? duration,
  }) => $apply(
    FieldCopyWithData({
      if (kind != null) #kind: kind,
      if (localPath != null) #localPath: localPath,
      if (width != null) #width: width,
      if (height != null) #height: height,
      if (size != null) #size: size,
      if (thumbPath != null) #thumbPath: thumbPath,
      if (thumbhash != null) #thumbhash: thumbhash,
      if (spoiler != null) #spoiler: spoiler,
      if (duration != null) #duration: duration,
    }),
  );
  @override
  MessageMedia $make(CopyWithData data) => MessageMedia(
    kind: data.get(#kind, or: $value.kind),
    localPath: data.get(#localPath, or: $value.localPath),
    width: data.get(#width, or: $value.width),
    height: data.get(#height, or: $value.height),
    size: data.get(#size, or: $value.size),
    thumbPath: data.get(#thumbPath, or: $value.thumbPath),
    thumbhash: data.get(#thumbhash, or: $value.thumbhash),
    spoiler: data.get(#spoiler, or: $value.spoiler),
    duration: data.get(#duration, or: $value.duration),
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
      MessageReactionMapper.ensureInitialized();
      MessageForwardMapper.ensureInitialized();
      MessageLinkPreviewMapper.ensureInitialized();
      MessagePollMapper.ensureInitialized();
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
  static List<int> _$waveform(Message v) => v.waveform;
  static const Field<Message, List<int>> _f$waveform = Field(
    'waveform',
    _$waveform,
    opt: true,
    def: const [],
  );
  static List<MessageMedia> _$media(Message v) => v.media;
  static const Field<Message, List<MessageMedia>> _f$media = Field(
    'media',
    _$media,
    opt: true,
    def: const [],
  );
  static int _$fileSize(Message v) => v.fileSize;
  static const Field<Message, int> _f$fileSize = Field(
    'fileSize',
    _$fileSize,
    opt: true,
    def: 0,
  );
  static int _$uploadedBytes(Message v) => v.uploadedBytes;
  static const Field<Message, int> _f$uploadedBytes = Field(
    'uploadedBytes',
    _$uploadedBytes,
    opt: true,
    def: 0,
  );
  static int _$uploadTotal(Message v) => v.uploadTotal;
  static const Field<Message, int> _f$uploadTotal = Field(
    'uploadTotal',
    _$uploadTotal,
    opt: true,
    def: 0,
  );
  static List<MessageReaction> _$reactions(Message v) => v.reactions;
  static const Field<Message, List<MessageReaction>> _f$reactions = Field(
    'reactions',
    _$reactions,
    opt: true,
    def: const [],
  );
  static MessageForward? _$forward(Message v) => v.forward;
  static const Field<Message, MessageForward> _f$forward = Field(
    'forward',
    _$forward,
    opt: true,
  );
  static bool _$pinned(Message v) => v.pinned;
  static const Field<Message, bool> _f$pinned = Field(
    'pinned',
    _$pinned,
    opt: true,
    def: false,
  );
  static String _$pinnedMessageID(Message v) => v.pinnedMessageID;
  static const Field<Message, String> _f$pinnedMessageID = Field(
    'pinnedMessageID',
    _$pinnedMessageID,
    opt: true,
    def: '',
  );
  static bool _$silent(Message v) => v.silent;
  static const Field<Message, bool> _f$silent = Field(
    'silent',
    _$silent,
    opt: true,
    def: false,
  );
  static DateTime? _$scheduledDate(Message v) => v.scheduledDate;
  static const Field<Message, DateTime> _f$scheduledDate = Field(
    'scheduledDate',
    _$scheduledDate,
    opt: true,
  );
  static MessageLinkPreview? _$linkPreview(Message v) => v.linkPreview;
  static const Field<Message, MessageLinkPreview> _f$linkPreview = Field(
    'linkPreview',
    _$linkPreview,
    opt: true,
  );
  static MessagePoll? _$poll(Message v) => v.poll;
  static const Field<Message, MessagePoll> _f$poll = Field(
    'poll',
    _$poll,
    opt: true,
  );
  static String _$authorSignature(Message v) => v.authorSignature;
  static const Field<Message, String> _f$authorSignature = Field(
    'authorSignature',
    _$authorSignature,
    opt: true,
    def: '',
  );
  static int _$views(Message v) => v.views;
  static const Field<Message, int> _f$views = Field(
    'views',
    _$views,
    opt: true,
    def: 0,
  );
  static int _$commentsCount(Message v) => v.commentsCount;
  static const Field<Message, int> _f$commentsCount = Field(
    'commentsCount',
    _$commentsCount,
    opt: true,
    def: 0,
  );
  static List<String> _$commenters(Message v) => v.commenters;
  static const Field<Message, List<String>> _f$commenters = Field(
    'commenters',
    _$commenters,
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
    #waveform: _f$waveform,
    #media: _f$media,
    #fileSize: _f$fileSize,
    #uploadedBytes: _f$uploadedBytes,
    #uploadTotal: _f$uploadTotal,
    #reactions: _f$reactions,
    #forward: _f$forward,
    #pinned: _f$pinned,
    #pinnedMessageID: _f$pinnedMessageID,
    #silent: _f$silent,
    #scheduledDate: _f$scheduledDate,
    #linkPreview: _f$linkPreview,
    #poll: _f$poll,
    #authorSignature: _f$authorSignature,
    #views: _f$views,
    #commentsCount: _f$commentsCount,
    #commenters: _f$commenters,
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
      waveform: data.dec(_f$waveform),
      media: data.dec(_f$media),
      fileSize: data.dec(_f$fileSize),
      uploadedBytes: data.dec(_f$uploadedBytes),
      uploadTotal: data.dec(_f$uploadTotal),
      reactions: data.dec(_f$reactions),
      forward: data.dec(_f$forward),
      pinned: data.dec(_f$pinned),
      pinnedMessageID: data.dec(_f$pinnedMessageID),
      silent: data.dec(_f$silent),
      scheduledDate: data.dec(_f$scheduledDate),
      linkPreview: data.dec(_f$linkPreview),
      poll: data.dec(_f$poll),
      authorSignature: data.dec(_f$authorSignature),
      views: data.dec(_f$views),
      commentsCount: data.dec(_f$commentsCount),
      commenters: data.dec(_f$commenters),
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
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get waveform;
  ListCopyWith<
    $R,
    MessageMedia,
    MessageMediaCopyWith<$R, MessageMedia, MessageMedia>
  >
  get media;
  ListCopyWith<
    $R,
    MessageReaction,
    MessageReactionCopyWith<$R, MessageReaction, MessageReaction>
  >
  get reactions;
  MessageForwardCopyWith<$R, MessageForward, MessageForward>? get forward;
  MessageLinkPreviewCopyWith<$R, MessageLinkPreview, MessageLinkPreview>?
  get linkPreview;
  MessagePollCopyWith<$R, MessagePoll, MessagePoll>? get poll;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get commenters;
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
    List<int>? waveform,
    List<MessageMedia>? media,
    int? fileSize,
    int? uploadedBytes,
    int? uploadTotal,
    List<MessageReaction>? reactions,
    MessageForward? forward,
    bool? pinned,
    String? pinnedMessageID,
    bool? silent,
    DateTime? scheduledDate,
    MessageLinkPreview? linkPreview,
    MessagePoll? poll,
    String? authorSignature,
    int? views,
    int? commentsCount,
    List<String>? commenters,
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
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get waveform =>
      ListCopyWith(
        $value.waveform,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(waveform: v),
      );
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
  ListCopyWith<
    $R,
    MessageReaction,
    MessageReactionCopyWith<$R, MessageReaction, MessageReaction>
  >
  get reactions => ListCopyWith(
    $value.reactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(reactions: v),
  );
  @override
  MessageForwardCopyWith<$R, MessageForward, MessageForward>? get forward =>
      $value.forward?.copyWith.$chain((v) => call(forward: v));
  @override
  MessageLinkPreviewCopyWith<$R, MessageLinkPreview, MessageLinkPreview>?
  get linkPreview =>
      $value.linkPreview?.copyWith.$chain((v) => call(linkPreview: v));
  @override
  MessagePollCopyWith<$R, MessagePoll, MessagePoll>? get poll =>
      $value.poll?.copyWith.$chain((v) => call(poll: v));
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get commenters =>
      ListCopyWith(
        $value.commenters,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(commenters: v),
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
    List<int>? waveform,
    List<MessageMedia>? media,
    int? fileSize,
    int? uploadedBytes,
    int? uploadTotal,
    List<MessageReaction>? reactions,
    Object? forward = $none,
    bool? pinned,
    String? pinnedMessageID,
    bool? silent,
    Object? scheduledDate = $none,
    Object? linkPreview = $none,
    Object? poll = $none,
    String? authorSignature,
    int? views,
    int? commentsCount,
    List<String>? commenters,
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
      if (waveform != null) #waveform: waveform,
      if (media != null) #media: media,
      if (fileSize != null) #fileSize: fileSize,
      if (uploadedBytes != null) #uploadedBytes: uploadedBytes,
      if (uploadTotal != null) #uploadTotal: uploadTotal,
      if (reactions != null) #reactions: reactions,
      if (forward != $none) #forward: forward,
      if (pinned != null) #pinned: pinned,
      if (pinnedMessageID != null) #pinnedMessageID: pinnedMessageID,
      if (silent != null) #silent: silent,
      if (scheduledDate != $none) #scheduledDate: scheduledDate,
      if (linkPreview != $none) #linkPreview: linkPreview,
      if (poll != $none) #poll: poll,
      if (authorSignature != null) #authorSignature: authorSignature,
      if (views != null) #views: views,
      if (commentsCount != null) #commentsCount: commentsCount,
      if (commenters != null) #commenters: commenters,
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
    waveform: data.get(#waveform, or: $value.waveform),
    media: data.get(#media, or: $value.media),
    fileSize: data.get(#fileSize, or: $value.fileSize),
    uploadedBytes: data.get(#uploadedBytes, or: $value.uploadedBytes),
    uploadTotal: data.get(#uploadTotal, or: $value.uploadTotal),
    reactions: data.get(#reactions, or: $value.reactions),
    forward: data.get(#forward, or: $value.forward),
    pinned: data.get(#pinned, or: $value.pinned),
    pinnedMessageID: data.get(#pinnedMessageID, or: $value.pinnedMessageID),
    silent: data.get(#silent, or: $value.silent),
    scheduledDate: data.get(#scheduledDate, or: $value.scheduledDate),
    linkPreview: data.get(#linkPreview, or: $value.linkPreview),
    poll: data.get(#poll, or: $value.poll),
    authorSignature: data.get(#authorSignature, or: $value.authorSignature),
    views: data.get(#views, or: $value.views),
    commentsCount: data.get(#commentsCount, or: $value.commentsCount),
    commenters: data.get(#commenters, or: $value.commenters),
  );

  @override
  MessageCopyWith<$R2, Message, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MessageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

