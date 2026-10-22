// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'chat_reply.dart';

class ChatReplyMapper extends ClassMapperBase<ChatReply> {
  ChatReplyMapper._();

  static ChatReplyMapper? _instance;
  static ChatReplyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChatReplyMapper._());
      MessageKindMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChatReply';

  static int _$replyID(ChatReply v) => v.replyID;
  static const Field<ChatReply, int> _f$replyID = Field('replyID', _$replyID);
  static String _$threadChatID(ChatReply v) => v.threadChatID;
  static const Field<ChatReply, String> _f$threadChatID = Field(
    'threadChatID',
    _$threadChatID,
  );
  static String _$channelID(ChatReply v) => v.channelID;
  static const Field<ChatReply, String> _f$channelID = Field(
    'channelID',
    _$channelID,
  );
  static String _$authorID(ChatReply v) => v.authorID;
  static const Field<ChatReply, String> _f$authorID = Field(
    'authorID',
    _$authorID,
  );
  static int _$messageID(ChatReply v) => v.messageID;
  static const Field<ChatReply, int> _f$messageID = Field(
    'messageID',
    _$messageID,
  );
  static int _$postID(ChatReply v) => v.postID;
  static const Field<ChatReply, int> _f$postID = Field('postID', _$postID);
  static DateTime _$date(ChatReply v) => v.date;
  static const Field<ChatReply, DateTime> _f$date = Field('date', _$date);
  static bool _$mention(ChatReply v) => v.mention;
  static const Field<ChatReply, bool> _f$mention = Field(
    'mention',
    _$mention,
    opt: true,
    def: false,
  );
  static String _$authorName(ChatReply v) => v.authorName;
  static const Field<ChatReply, String> _f$authorName = Field(
    'authorName',
    _$authorName,
    opt: true,
    def: '',
  );
  static String _$channelTitle(ChatReply v) => v.channelTitle;
  static const Field<ChatReply, String> _f$channelTitle = Field(
    'channelTitle',
    _$channelTitle,
    opt: true,
    def: '',
  );
  static String _$postText(ChatReply v) => v.postText;
  static const Field<ChatReply, String> _f$postText = Field(
    'postText',
    _$postText,
    opt: true,
    def: '',
  );
  static MessageKind _$kind(ChatReply v) => v.kind;
  static const Field<ChatReply, MessageKind> _f$kind = Field(
    'kind',
    _$kind,
    opt: true,
    def: MessageKind.text,
  );
  static String _$text(ChatReply v) => v.text;
  static const Field<ChatReply, String> _f$text = Field(
    'text',
    _$text,
    opt: true,
    def: '',
  );
  static String _$mediaPath(ChatReply v) => v.mediaPath;
  static const Field<ChatReply, String> _f$mediaPath = Field(
    'mediaPath',
    _$mediaPath,
    opt: true,
    def: '',
  );
  static String _$thumbhash(ChatReply v) => v.thumbhash;
  static const Field<ChatReply, String> _f$thumbhash = Field(
    'thumbhash',
    _$thumbhash,
    opt: true,
    def: '',
  );
  static bool _$unread(ChatReply v) => v.unread;
  static const Field<ChatReply, bool> _f$unread = Field(
    'unread',
    _$unread,
    opt: true,
    def: false,
  );
  static bool _$hidden(ChatReply v) => v.hidden;
  static const Field<ChatReply, bool> _f$hidden = Field(
    'hidden',
    _$hidden,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<ChatReply> fields = const {
    #replyID: _f$replyID,
    #threadChatID: _f$threadChatID,
    #channelID: _f$channelID,
    #authorID: _f$authorID,
    #messageID: _f$messageID,
    #postID: _f$postID,
    #date: _f$date,
    #mention: _f$mention,
    #authorName: _f$authorName,
    #channelTitle: _f$channelTitle,
    #postText: _f$postText,
    #kind: _f$kind,
    #text: _f$text,
    #mediaPath: _f$mediaPath,
    #thumbhash: _f$thumbhash,
    #unread: _f$unread,
    #hidden: _f$hidden,
  };

  static ChatReply _instantiate(DecodingData data) {
    return ChatReply(
      replyID: data.dec(_f$replyID),
      threadChatID: data.dec(_f$threadChatID),
      channelID: data.dec(_f$channelID),
      authorID: data.dec(_f$authorID),
      messageID: data.dec(_f$messageID),
      postID: data.dec(_f$postID),
      date: data.dec(_f$date),
      mention: data.dec(_f$mention),
      authorName: data.dec(_f$authorName),
      channelTitle: data.dec(_f$channelTitle),
      postText: data.dec(_f$postText),
      kind: data.dec(_f$kind),
      text: data.dec(_f$text),
      mediaPath: data.dec(_f$mediaPath),
      thumbhash: data.dec(_f$thumbhash),
      unread: data.dec(_f$unread),
      hidden: data.dec(_f$hidden),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChatReply fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChatReply>(map);
  }

  static ChatReply fromJson(String json) {
    return ensureInitialized().decodeJson<ChatReply>(json);
  }
}

mixin ChatReplyMappable {
  String toJson() {
    return ChatReplyMapper.ensureInitialized().encodeJson<ChatReply>(
      this as ChatReply,
    );
  }

  Map<String, dynamic> toMap() {
    return ChatReplyMapper.ensureInitialized().encodeMap<ChatReply>(
      this as ChatReply,
    );
  }

  ChatReplyCopyWith<ChatReply, ChatReply, ChatReply> get copyWith =>
      _ChatReplyCopyWithImpl<ChatReply, ChatReply>(
        this as ChatReply,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChatReplyMapper.ensureInitialized().stringifyValue(
      this as ChatReply,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChatReplyMapper.ensureInitialized().equalsValue(
      this as ChatReply,
      other,
    );
  }

  @override
  int get hashCode {
    return ChatReplyMapper.ensureInitialized().hashValue(this as ChatReply);
  }
}

extension ChatReplyValueCopy<$R, $Out> on ObjectCopyWith<$R, ChatReply, $Out> {
  ChatReplyCopyWith<$R, ChatReply, $Out> get $asChatReply =>
      $base.as((v, t, t2) => _ChatReplyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChatReplyCopyWith<$R, $In extends ChatReply, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? replyID,
    String? threadChatID,
    String? channelID,
    String? authorID,
    int? messageID,
    int? postID,
    DateTime? date,
    bool? mention,
    String? authorName,
    String? channelTitle,
    String? postText,
    MessageKind? kind,
    String? text,
    String? mediaPath,
    String? thumbhash,
    bool? unread,
    bool? hidden,
  });
  ChatReplyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChatReplyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChatReply, $Out>
    implements ChatReplyCopyWith<$R, ChatReply, $Out> {
  _ChatReplyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChatReply> $mapper =
      ChatReplyMapper.ensureInitialized();
  @override
  $R call({
    int? replyID,
    String? threadChatID,
    String? channelID,
    String? authorID,
    int? messageID,
    int? postID,
    DateTime? date,
    bool? mention,
    String? authorName,
    String? channelTitle,
    String? postText,
    MessageKind? kind,
    String? text,
    String? mediaPath,
    String? thumbhash,
    bool? unread,
    bool? hidden,
  }) => $apply(
    FieldCopyWithData({
      if (replyID != null) #replyID: replyID,
      if (threadChatID != null) #threadChatID: threadChatID,
      if (channelID != null) #channelID: channelID,
      if (authorID != null) #authorID: authorID,
      if (messageID != null) #messageID: messageID,
      if (postID != null) #postID: postID,
      if (date != null) #date: date,
      if (mention != null) #mention: mention,
      if (authorName != null) #authorName: authorName,
      if (channelTitle != null) #channelTitle: channelTitle,
      if (postText != null) #postText: postText,
      if (kind != null) #kind: kind,
      if (text != null) #text: text,
      if (mediaPath != null) #mediaPath: mediaPath,
      if (thumbhash != null) #thumbhash: thumbhash,
      if (unread != null) #unread: unread,
      if (hidden != null) #hidden: hidden,
    }),
  );
  @override
  ChatReply $make(CopyWithData data) => ChatReply(
    replyID: data.get(#replyID, or: $value.replyID),
    threadChatID: data.get(#threadChatID, or: $value.threadChatID),
    channelID: data.get(#channelID, or: $value.channelID),
    authorID: data.get(#authorID, or: $value.authorID),
    messageID: data.get(#messageID, or: $value.messageID),
    postID: data.get(#postID, or: $value.postID),
    date: data.get(#date, or: $value.date),
    mention: data.get(#mention, or: $value.mention),
    authorName: data.get(#authorName, or: $value.authorName),
    channelTitle: data.get(#channelTitle, or: $value.channelTitle),
    postText: data.get(#postText, or: $value.postText),
    kind: data.get(#kind, or: $value.kind),
    text: data.get(#text, or: $value.text),
    mediaPath: data.get(#mediaPath, or: $value.mediaPath),
    thumbhash: data.get(#thumbhash, or: $value.thumbhash),
    unread: data.get(#unread, or: $value.unread),
    hidden: data.get(#hidden, or: $value.hidden),
  );

  @override
  ChatReplyCopyWith<$R2, ChatReply, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChatReplyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

