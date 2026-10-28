// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'call_state.dart';

class CallParticipantViewMapper extends ClassMapperBase<CallParticipantView> {
  CallParticipantViewMapper._();

  static CallParticipantViewMapper? _instance;
  static CallParticipantViewMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CallParticipantViewMapper._());
      MapperContainer.globals.useAll([Uint8ListMapper()]);
    }
    return _instance!;
  }

  @override
  final String id = 'CallParticipantView';

  static List<int> _$userID(CallParticipantView v) => v.userID;
  static const Field<CallParticipantView, List<int>> _f$userID = Field(
    'userID',
    _$userID,
  );
  static String _$name(CallParticipantView v) => v.name;
  static const Field<CallParticipantView, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
    def: '',
  );
  static Uint8List? _$avatarBytes(CallParticipantView v) => v.avatarBytes;
  static const Field<CallParticipantView, Uint8List> _f$avatarBytes = Field(
    'avatarBytes',
    _$avatarBytes,
    opt: true,
  );
  static bool _$joined(CallParticipantView v) => v.joined;
  static const Field<CallParticipantView, bool> _f$joined = Field(
    'joined',
    _$joined,
    opt: true,
    def: true,
  );
  static bool _$micMuted(CallParticipantView v) => v.micMuted;
  static const Field<CallParticipantView, bool> _f$micMuted = Field(
    'micMuted',
    _$micMuted,
    opt: true,
    def: false,
  );
  static bool _$videoOff(CallParticipantView v) => v.videoOff;
  static const Field<CallParticipantView, bool> _f$videoOff = Field(
    'videoOff',
    _$videoOff,
    opt: true,
    def: true,
  );
  static bool _$speaking(CallParticipantView v) => v.speaking;
  static const Field<CallParticipantView, bool> _f$speaking = Field(
    'speaking',
    _$speaking,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<CallParticipantView> fields = const {
    #userID: _f$userID,
    #name: _f$name,
    #avatarBytes: _f$avatarBytes,
    #joined: _f$joined,
    #micMuted: _f$micMuted,
    #videoOff: _f$videoOff,
    #speaking: _f$speaking,
  };

  static CallParticipantView _instantiate(DecodingData data) {
    return CallParticipantView(
      userID: data.dec(_f$userID),
      name: data.dec(_f$name),
      avatarBytes: data.dec(_f$avatarBytes),
      joined: data.dec(_f$joined),
      micMuted: data.dec(_f$micMuted),
      videoOff: data.dec(_f$videoOff),
      speaking: data.dec(_f$speaking),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CallParticipantView fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CallParticipantView>(map);
  }

  static CallParticipantView fromJson(String json) {
    return ensureInitialized().decodeJson<CallParticipantView>(json);
  }
}

mixin CallParticipantViewMappable {
  String toJson() {
    return CallParticipantViewMapper.ensureInitialized()
        .encodeJson<CallParticipantView>(this as CallParticipantView);
  }

  Map<String, dynamic> toMap() {
    return CallParticipantViewMapper.ensureInitialized()
        .encodeMap<CallParticipantView>(this as CallParticipantView);
  }

  CallParticipantViewCopyWith<
    CallParticipantView,
    CallParticipantView,
    CallParticipantView
  >
  get copyWith =>
      _CallParticipantViewCopyWithImpl<
        CallParticipantView,
        CallParticipantView
      >(this as CallParticipantView, $identity, $identity);
  @override
  String toString() {
    return CallParticipantViewMapper.ensureInitialized().stringifyValue(
      this as CallParticipantView,
    );
  }

  @override
  bool operator ==(Object other) {
    return CallParticipantViewMapper.ensureInitialized().equalsValue(
      this as CallParticipantView,
      other,
    );
  }

  @override
  int get hashCode {
    return CallParticipantViewMapper.ensureInitialized().hashValue(
      this as CallParticipantView,
    );
  }
}

extension CallParticipantViewValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CallParticipantView, $Out> {
  CallParticipantViewCopyWith<$R, CallParticipantView, $Out>
  get $asCallParticipantView => $base.as(
    (v, t, t2) => _CallParticipantViewCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CallParticipantViewCopyWith<
  $R,
  $In extends CallParticipantView,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID;
  $R call({
    List<int>? userID,
    String? name,
    Uint8List? avatarBytes,
    bool? joined,
    bool? micMuted,
    bool? videoOff,
    bool? speaking,
  });
  CallParticipantViewCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CallParticipantViewCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CallParticipantView, $Out>
    implements CallParticipantViewCopyWith<$R, CallParticipantView, $Out> {
  _CallParticipantViewCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CallParticipantView> $mapper =
      CallParticipantViewMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get userID =>
      ListCopyWith(
        $value.userID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(userID: v),
      );
  @override
  $R call({
    List<int>? userID,
    String? name,
    Object? avatarBytes = $none,
    bool? joined,
    bool? micMuted,
    bool? videoOff,
    bool? speaking,
  }) => $apply(
    FieldCopyWithData({
      if (userID != null) #userID: userID,
      if (name != null) #name: name,
      if (avatarBytes != $none) #avatarBytes: avatarBytes,
      if (joined != null) #joined: joined,
      if (micMuted != null) #micMuted: micMuted,
      if (videoOff != null) #videoOff: videoOff,
      if (speaking != null) #speaking: speaking,
    }),
  );
  @override
  CallParticipantView $make(CopyWithData data) => CallParticipantView(
    userID: data.get(#userID, or: $value.userID),
    name: data.get(#name, or: $value.name),
    avatarBytes: data.get(#avatarBytes, or: $value.avatarBytes),
    joined: data.get(#joined, or: $value.joined),
    micMuted: data.get(#micMuted, or: $value.micMuted),
    videoOff: data.get(#videoOff, or: $value.videoOff),
    speaking: data.get(#speaking, or: $value.speaking),
  );

  @override
  CallParticipantViewCopyWith<$R2, CallParticipantView, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CallParticipantViewCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CallStateMapper extends ClassMapperBase<CallState> {
  CallStateMapper._();

  static CallStateMapper? _instance;
  static CallStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CallStateMapper._());
      MapperContainer.globals.useAll([Uint8ListMapper()]);
      CallParticipantViewMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CallState';

  static Status _$status(CallState v) => v.status;
  static const Field<CallState, Status> _f$status = Field(
    'status',
    _$status,
    opt: true,
    def: Status.initialization,
  );
  static CallStatus _$callStatus(CallState v) => v.callStatus;
  static const Field<CallState, CallStatus> _f$callStatus = Field(
    'callStatus',
    _$callStatus,
    opt: true,
    def: CallStatus.idle,
  );
  static String _$callId(CallState v) => v.callId;
  static const Field<CallState, String> _f$callId = Field(
    'callId',
    _$callId,
    opt: true,
    def: '',
  );
  static List<int> _$remoteUserID(CallState v) => v.remoteUserID;
  static const Field<CallState, List<int>> _f$remoteUserID = Field(
    'remoteUserID',
    _$remoteUserID,
    opt: true,
    def: const [],
  );
  static bool _$video(CallState v) => v.video;
  static const Field<CallState, bool> _f$video = Field(
    'video',
    _$video,
    opt: true,
    def: false,
  );
  static bool _$micMuted(CallState v) => v.micMuted;
  static const Field<CallState, bool> _f$micMuted = Field(
    'micMuted',
    _$micMuted,
    opt: true,
    def: false,
  );
  static bool _$cameraOff(CallState v) => v.cameraOff;
  static const Field<CallState, bool> _f$cameraOff = Field(
    'cameraOff',
    _$cameraOff,
    opt: true,
    def: false,
  );
  static bool _$speakerOn(CallState v) => v.speakerOn;
  static const Field<CallState, bool> _f$speakerOn = Field(
    'speakerOn',
    _$speakerOn,
    opt: true,
    def: false,
  );
  static bool _$remoteMicMuted(CallState v) => v.remoteMicMuted;
  static const Field<CallState, bool> _f$remoteMicMuted = Field(
    'remoteMicMuted',
    _$remoteMicMuted,
    opt: true,
    def: false,
  );
  static bool _$remoteVideoOff(CallState v) => v.remoteVideoOff;
  static const Field<CallState, bool> _f$remoteVideoOff = Field(
    'remoteVideoOff',
    _$remoteVideoOff,
    opt: true,
    def: true,
  );
  static bool _$remoteOnHold(CallState v) => v.remoteOnHold;
  static const Field<CallState, bool> _f$remoteOnHold = Field(
    'remoteOnHold',
    _$remoteOnHold,
    opt: true,
    def: false,
  );
  static bool _$reconnecting(CallState v) => v.reconnecting;
  static const Field<CallState, bool> _f$reconnecting = Field(
    'reconnecting',
    _$reconnecting,
    opt: true,
    def: false,
  );
  static bool _$remoteReconnecting(CallState v) => v.remoteReconnecting;
  static const Field<CallState, bool> _f$remoteReconnecting = Field(
    'remoteReconnecting',
    _$remoteReconnecting,
    opt: true,
    def: false,
  );
  static CallEndReason _$endReason(CallState v) => v.endReason;
  static const Field<CallState, CallEndReason> _f$endReason = Field(
    'endReason',
    _$endReason,
    opt: true,
    def: CallEndReason.none,
  );
  static String _$debug(CallState v) => v.debug;
  static const Field<CallState, String> _f$debug = Field(
    'debug',
    _$debug,
    opt: true,
    def: '',
  );
  static DateTime? _$connectedAt(CallState v) => v.connectedAt;
  static const Field<CallState, DateTime> _f$connectedAt = Field(
    'connectedAt',
    _$connectedAt,
    opt: true,
  );
  static CallQuality _$quality(CallState v) => v.quality;
  static const Field<CallState, CallQuality> _f$quality = Field(
    'quality',
    _$quality,
    opt: true,
    def: CallQuality.unknown,
  );
  static int _$mediaEpoch(CallState v) => v.mediaEpoch;
  static const Field<CallState, int> _f$mediaEpoch = Field(
    'mediaEpoch',
    _$mediaEpoch,
    opt: true,
    def: 0,
  );
  static String _$displayName(CallState v) => v.displayName;
  static const Field<CallState, String> _f$displayName = Field(
    'displayName',
    _$displayName,
    opt: true,
    def: '',
  );
  static List<String> _$nameLines(CallState v) => v.nameLines;
  static const Field<CallState, List<String>> _f$nameLines = Field(
    'nameLines',
    _$nameLines,
    opt: true,
    def: const [],
  );
  static String _$boringAvatarHash(CallState v) => v.boringAvatarHash;
  static const Field<CallState, String> _f$boringAvatarHash = Field(
    'boringAvatarHash',
    _$boringAvatarHash,
    opt: true,
    def: '',
  );
  static Uint8List? _$avatarBytes(CallState v) => v.avatarBytes;
  static const Field<CallState, Uint8List> _f$avatarBytes = Field(
    'avatarBytes',
    _$avatarBytes,
    opt: true,
  );
  static CallEncryption _$encryption(CallState v) => v.encryption;
  static const Field<CallState, CallEncryption> _f$encryption = Field(
    'encryption',
    _$encryption,
    opt: true,
    def: CallEncryption.negotiating,
  );
  static List<String> _$sas(CallState v) => v.sas;
  static const Field<CallState, List<String>> _f$sas = Field(
    'sas',
    _$sas,
    opt: true,
    def: const [],
  );
  static List<CallParticipantView> _$participants(CallState v) =>
      v.participants;
  static const Field<CallState, List<CallParticipantView>> _f$participants =
      Field('participants', _$participants, opt: true, def: const []);
  static Uint8List? _$selfAvatarBytes(CallState v) => v.selfAvatarBytes;
  static const Field<CallState, Uint8List> _f$selfAvatarBytes = Field(
    'selfAvatarBytes',
    _$selfAvatarBytes,
    opt: true,
  );
  static List<int> _$focusUserID(CallState v) => v.focusUserID;
  static const Field<CallState, List<int>> _f$focusUserID = Field(
    'focusUserID',
    _$focusUserID,
    opt: true,
    def: const [],
  );
  static String _$inviteNoticeName(CallState v) => v.inviteNoticeName;
  static const Field<CallState, String> _f$inviteNoticeName = Field(
    'inviteNoticeName',
    _$inviteNoticeName,
    opt: true,
    def: '',
  );
  static String _$inviteNoticeOutcome(CallState v) => v.inviteNoticeOutcome;
  static const Field<CallState, String> _f$inviteNoticeOutcome = Field(
    'inviteNoticeOutcome',
    _$inviteNoticeOutcome,
    opt: true,
    def: '',
  );
  static int _$inviteNoticeSeq(CallState v) => v.inviteNoticeSeq;
  static const Field<CallState, int> _f$inviteNoticeSeq = Field(
    'inviteNoticeSeq',
    _$inviteNoticeSeq,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<CallState> fields = const {
    #status: _f$status,
    #callStatus: _f$callStatus,
    #callId: _f$callId,
    #remoteUserID: _f$remoteUserID,
    #video: _f$video,
    #micMuted: _f$micMuted,
    #cameraOff: _f$cameraOff,
    #speakerOn: _f$speakerOn,
    #remoteMicMuted: _f$remoteMicMuted,
    #remoteVideoOff: _f$remoteVideoOff,
    #remoteOnHold: _f$remoteOnHold,
    #reconnecting: _f$reconnecting,
    #remoteReconnecting: _f$remoteReconnecting,
    #endReason: _f$endReason,
    #debug: _f$debug,
    #connectedAt: _f$connectedAt,
    #quality: _f$quality,
    #mediaEpoch: _f$mediaEpoch,
    #displayName: _f$displayName,
    #nameLines: _f$nameLines,
    #boringAvatarHash: _f$boringAvatarHash,
    #avatarBytes: _f$avatarBytes,
    #encryption: _f$encryption,
    #sas: _f$sas,
    #participants: _f$participants,
    #selfAvatarBytes: _f$selfAvatarBytes,
    #focusUserID: _f$focusUserID,
    #inviteNoticeName: _f$inviteNoticeName,
    #inviteNoticeOutcome: _f$inviteNoticeOutcome,
    #inviteNoticeSeq: _f$inviteNoticeSeq,
  };

  static CallState _instantiate(DecodingData data) {
    return CallState(
      status: data.dec(_f$status),
      callStatus: data.dec(_f$callStatus),
      callId: data.dec(_f$callId),
      remoteUserID: data.dec(_f$remoteUserID),
      video: data.dec(_f$video),
      micMuted: data.dec(_f$micMuted),
      cameraOff: data.dec(_f$cameraOff),
      speakerOn: data.dec(_f$speakerOn),
      remoteMicMuted: data.dec(_f$remoteMicMuted),
      remoteVideoOff: data.dec(_f$remoteVideoOff),
      remoteOnHold: data.dec(_f$remoteOnHold),
      reconnecting: data.dec(_f$reconnecting),
      remoteReconnecting: data.dec(_f$remoteReconnecting),
      endReason: data.dec(_f$endReason),
      debug: data.dec(_f$debug),
      connectedAt: data.dec(_f$connectedAt),
      quality: data.dec(_f$quality),
      mediaEpoch: data.dec(_f$mediaEpoch),
      displayName: data.dec(_f$displayName),
      nameLines: data.dec(_f$nameLines),
      boringAvatarHash: data.dec(_f$boringAvatarHash),
      avatarBytes: data.dec(_f$avatarBytes),
      encryption: data.dec(_f$encryption),
      sas: data.dec(_f$sas),
      participants: data.dec(_f$participants),
      selfAvatarBytes: data.dec(_f$selfAvatarBytes),
      focusUserID: data.dec(_f$focusUserID),
      inviteNoticeName: data.dec(_f$inviteNoticeName),
      inviteNoticeOutcome: data.dec(_f$inviteNoticeOutcome),
      inviteNoticeSeq: data.dec(_f$inviteNoticeSeq),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CallState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CallState>(map);
  }

  static CallState fromJson(String json) {
    return ensureInitialized().decodeJson<CallState>(json);
  }
}

mixin CallStateMappable {
  String toJson() {
    return CallStateMapper.ensureInitialized().encodeJson<CallState>(
      this as CallState,
    );
  }

  Map<String, dynamic> toMap() {
    return CallStateMapper.ensureInitialized().encodeMap<CallState>(
      this as CallState,
    );
  }

  CallStateCopyWith<CallState, CallState, CallState> get copyWith =>
      _CallStateCopyWithImpl<CallState, CallState>(
        this as CallState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CallStateMapper.ensureInitialized().stringifyValue(
      this as CallState,
    );
  }

  @override
  bool operator ==(Object other) {
    return CallStateMapper.ensureInitialized().equalsValue(
      this as CallState,
      other,
    );
  }

  @override
  int get hashCode {
    return CallStateMapper.ensureInitialized().hashValue(this as CallState);
  }
}

extension CallStateValueCopy<$R, $Out> on ObjectCopyWith<$R, CallState, $Out> {
  CallStateCopyWith<$R, CallState, $Out> get $asCallState =>
      $base.as((v, t, t2) => _CallStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CallStateCopyWith<$R, $In extends CallState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get remoteUserID;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get nameLines;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get sas;
  ListCopyWith<
    $R,
    CallParticipantView,
    CallParticipantViewCopyWith<$R, CallParticipantView, CallParticipantView>
  >
  get participants;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get focusUserID;
  $R call({
    Status? status,
    CallStatus? callStatus,
    String? callId,
    List<int>? remoteUserID,
    bool? video,
    bool? micMuted,
    bool? cameraOff,
    bool? speakerOn,
    bool? remoteMicMuted,
    bool? remoteVideoOff,
    bool? remoteOnHold,
    bool? reconnecting,
    bool? remoteReconnecting,
    CallEndReason? endReason,
    String? debug,
    DateTime? connectedAt,
    CallQuality? quality,
    int? mediaEpoch,
    String? displayName,
    List<String>? nameLines,
    String? boringAvatarHash,
    Uint8List? avatarBytes,
    CallEncryption? encryption,
    List<String>? sas,
    List<CallParticipantView>? participants,
    Uint8List? selfAvatarBytes,
    List<int>? focusUserID,
    String? inviteNoticeName,
    String? inviteNoticeOutcome,
    int? inviteNoticeSeq,
  });
  CallStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CallStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CallState, $Out>
    implements CallStateCopyWith<$R, CallState, $Out> {
  _CallStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CallState> $mapper =
      CallStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get remoteUserID =>
      ListCopyWith(
        $value.remoteUserID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(remoteUserID: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get nameLines =>
      ListCopyWith(
        $value.nameLines,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(nameLines: v),
      );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get sas =>
      ListCopyWith(
        $value.sas,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(sas: v),
      );
  @override
  ListCopyWith<
    $R,
    CallParticipantView,
    CallParticipantViewCopyWith<$R, CallParticipantView, CallParticipantView>
  >
  get participants => ListCopyWith(
    $value.participants,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(participants: v),
  );
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get focusUserID =>
      ListCopyWith(
        $value.focusUserID,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(focusUserID: v),
      );
  @override
  $R call({
    Status? status,
    CallStatus? callStatus,
    String? callId,
    List<int>? remoteUserID,
    bool? video,
    bool? micMuted,
    bool? cameraOff,
    bool? speakerOn,
    bool? remoteMicMuted,
    bool? remoteVideoOff,
    bool? remoteOnHold,
    bool? reconnecting,
    bool? remoteReconnecting,
    CallEndReason? endReason,
    String? debug,
    Object? connectedAt = $none,
    CallQuality? quality,
    int? mediaEpoch,
    String? displayName,
    List<String>? nameLines,
    String? boringAvatarHash,
    Object? avatarBytes = $none,
    CallEncryption? encryption,
    List<String>? sas,
    List<CallParticipantView>? participants,
    Object? selfAvatarBytes = $none,
    List<int>? focusUserID,
    String? inviteNoticeName,
    String? inviteNoticeOutcome,
    int? inviteNoticeSeq,
  }) => $apply(
    FieldCopyWithData({
      if (status != null) #status: status,
      if (callStatus != null) #callStatus: callStatus,
      if (callId != null) #callId: callId,
      if (remoteUserID != null) #remoteUserID: remoteUserID,
      if (video != null) #video: video,
      if (micMuted != null) #micMuted: micMuted,
      if (cameraOff != null) #cameraOff: cameraOff,
      if (speakerOn != null) #speakerOn: speakerOn,
      if (remoteMicMuted != null) #remoteMicMuted: remoteMicMuted,
      if (remoteVideoOff != null) #remoteVideoOff: remoteVideoOff,
      if (remoteOnHold != null) #remoteOnHold: remoteOnHold,
      if (reconnecting != null) #reconnecting: reconnecting,
      if (remoteReconnecting != null) #remoteReconnecting: remoteReconnecting,
      if (endReason != null) #endReason: endReason,
      if (debug != null) #debug: debug,
      if (connectedAt != $none) #connectedAt: connectedAt,
      if (quality != null) #quality: quality,
      if (mediaEpoch != null) #mediaEpoch: mediaEpoch,
      if (displayName != null) #displayName: displayName,
      if (nameLines != null) #nameLines: nameLines,
      if (boringAvatarHash != null) #boringAvatarHash: boringAvatarHash,
      if (avatarBytes != $none) #avatarBytes: avatarBytes,
      if (encryption != null) #encryption: encryption,
      if (sas != null) #sas: sas,
      if (participants != null) #participants: participants,
      if (selfAvatarBytes != $none) #selfAvatarBytes: selfAvatarBytes,
      if (focusUserID != null) #focusUserID: focusUserID,
      if (inviteNoticeName != null) #inviteNoticeName: inviteNoticeName,
      if (inviteNoticeOutcome != null)
        #inviteNoticeOutcome: inviteNoticeOutcome,
      if (inviteNoticeSeq != null) #inviteNoticeSeq: inviteNoticeSeq,
    }),
  );
  @override
  CallState $make(CopyWithData data) => CallState(
    status: data.get(#status, or: $value.status),
    callStatus: data.get(#callStatus, or: $value.callStatus),
    callId: data.get(#callId, or: $value.callId),
    remoteUserID: data.get(#remoteUserID, or: $value.remoteUserID),
    video: data.get(#video, or: $value.video),
    micMuted: data.get(#micMuted, or: $value.micMuted),
    cameraOff: data.get(#cameraOff, or: $value.cameraOff),
    speakerOn: data.get(#speakerOn, or: $value.speakerOn),
    remoteMicMuted: data.get(#remoteMicMuted, or: $value.remoteMicMuted),
    remoteVideoOff: data.get(#remoteVideoOff, or: $value.remoteVideoOff),
    remoteOnHold: data.get(#remoteOnHold, or: $value.remoteOnHold),
    reconnecting: data.get(#reconnecting, or: $value.reconnecting),
    remoteReconnecting: data.get(
      #remoteReconnecting,
      or: $value.remoteReconnecting,
    ),
    endReason: data.get(#endReason, or: $value.endReason),
    debug: data.get(#debug, or: $value.debug),
    connectedAt: data.get(#connectedAt, or: $value.connectedAt),
    quality: data.get(#quality, or: $value.quality),
    mediaEpoch: data.get(#mediaEpoch, or: $value.mediaEpoch),
    displayName: data.get(#displayName, or: $value.displayName),
    nameLines: data.get(#nameLines, or: $value.nameLines),
    boringAvatarHash: data.get(#boringAvatarHash, or: $value.boringAvatarHash),
    avatarBytes: data.get(#avatarBytes, or: $value.avatarBytes),
    encryption: data.get(#encryption, or: $value.encryption),
    sas: data.get(#sas, or: $value.sas),
    participants: data.get(#participants, or: $value.participants),
    selfAvatarBytes: data.get(#selfAvatarBytes, or: $value.selfAvatarBytes),
    focusUserID: data.get(#focusUserID, or: $value.focusUserID),
    inviteNoticeName: data.get(#inviteNoticeName, or: $value.inviteNoticeName),
    inviteNoticeOutcome: data.get(
      #inviteNoticeOutcome,
      or: $value.inviteNoticeOutcome,
    ),
    inviteNoticeSeq: data.get(#inviteNoticeSeq, or: $value.inviteNoticeSeq),
  );

  @override
  CallStateCopyWith<$R2, CallState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CallStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

