// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'replies_state.dart';

class RepliesStateMapper extends ClassMapperBase<RepliesState> {
  RepliesStateMapper._();

  static RepliesStateMapper? _instance;
  static RepliesStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RepliesStateMapper._());
      models.ChatReplyMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RepliesState';

  static Status _$status(RepliesState v) => v.status;
  static const Field<RepliesState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static List<models.ChatReply> _$replies(RepliesState v) => v.replies;
  static const Field<RepliesState, List<models.ChatReply>> _f$replies = Field(
    'replies',
    _$replies,
    opt: true,
    def: const [],
  );
  static bool _$hasOlder(RepliesState v) => v.hasOlder;
  static const Field<RepliesState, bool> _f$hasOlder = Field(
    'hasOlder',
    _$hasOlder,
    opt: true,
    def: true,
  );
  static bool _$loadingOlder(RepliesState v) => v.loadingOlder;
  static const Field<RepliesState, bool> _f$loadingOlder = Field(
    'loadingOlder',
    _$loadingOlder,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<RepliesState> fields = const {
    #status: _f$status,
    #replies: _f$replies,
    #hasOlder: _f$hasOlder,
    #loadingOlder: _f$loadingOlder,
  };

  static RepliesState _instantiate(DecodingData data) {
    return RepliesState(
      status: data.dec(_f$status),
      replies: data.dec(_f$replies),
      hasOlder: data.dec(_f$hasOlder),
      loadingOlder: data.dec(_f$loadingOlder),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RepliesState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RepliesState>(map);
  }

  static RepliesState fromJson(String json) {
    return ensureInitialized().decodeJson<RepliesState>(json);
  }
}

mixin RepliesStateMappable {
  String toJson() {
    return RepliesStateMapper.ensureInitialized().encodeJson<RepliesState>(
      this as RepliesState,
    );
  }

  Map<String, dynamic> toMap() {
    return RepliesStateMapper.ensureInitialized().encodeMap<RepliesState>(
      this as RepliesState,
    );
  }

  RepliesStateCopyWith<RepliesState, RepliesState, RepliesState> get copyWith =>
      _RepliesStateCopyWithImpl<RepliesState, RepliesState>(
        this as RepliesState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RepliesStateMapper.ensureInitialized().stringifyValue(
      this as RepliesState,
    );
  }

  @override
  bool operator ==(Object other) {
    return RepliesStateMapper.ensureInitialized().equalsValue(
      this as RepliesState,
      other,
    );
  }

  @override
  int get hashCode {
    return RepliesStateMapper.ensureInitialized().hashValue(
      this as RepliesState,
    );
  }
}

extension RepliesStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RepliesState, $Out> {
  RepliesStateCopyWith<$R, RepliesState, $Out> get $asRepliesState =>
      $base.as((v, t, t2) => _RepliesStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RepliesStateCopyWith<$R, $In extends RepliesState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    models.ChatReply,
    models.ChatReplyCopyWith<$R, models.ChatReply, models.ChatReply>
  >
  get replies;
  $R call({
    Status? status,
    List<models.ChatReply>? replies,
    bool? hasOlder,
    bool? loadingOlder,
  });
  RepliesStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RepliesStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RepliesState, $Out>
    implements RepliesStateCopyWith<$R, RepliesState, $Out> {
  _RepliesStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RepliesState> $mapper =
      RepliesStateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    models.ChatReply,
    models.ChatReplyCopyWith<$R, models.ChatReply, models.ChatReply>
  >
  get replies => ListCopyWith(
    $value.replies,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(replies: v),
  );
  @override
  $R call({
    Status? status,
    List<models.ChatReply>? replies,
    bool? hasOlder,
    bool? loadingOlder,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (replies != null) #replies: replies,
      if (hasOlder != null) #hasOlder: hasOlder,
      if (loadingOlder != null) #loadingOlder: loadingOlder,
    }),
  );
  @override
  RepliesState $make(CopyWithData data) => RepliesState(
    status: data.get(#status, or: $value.status),
    replies: data.get(#replies, or: $value.replies),
    hasOlder: data.get(#hasOlder, or: $value.hasOlder),
    loadingOlder: data.get(#loadingOlder, or: $value.loadingOlder),
  );

  @override
  RepliesStateCopyWith<$R2, RepliesState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RepliesStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

