// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'call_state.dart';

class CallStateMapper extends ClassMapperBase<CallState> {
  CallStateMapper._();

  static CallStateMapper? _instance;
  static CallStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CallStateMapper._());
      MapperContainer.globals.useAll([Uint8ListMapper()]);
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
  static bool _$screenSharing(CallState v) => v.screenSharing;
  static const Field<CallState, bool> _f$screenSharing = Field(
    'screenSharing',
    _$screenSharing,
    opt: true,
    def: false,
  );
  static bool _$remoteScreenSharing(CallState v) => v.remoteScreenSharing;
  static const Field<CallState, bool> _f$remoteScreenSharing = Field(
    'remoteScreenSharing',
    _$remoteScreenSharing,
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
    #screenSharing: _f$screenSharing,
    #remoteScreenSharing: _f$remoteScreenSharing,
    #endReason: _f$endReason,
    #debug: _f$debug,
    #connectedAt: _f$connectedAt,
    #quality: _f$quality,
    #mediaEpoch: _f$mediaEpoch,
    #displayName: _f$displayName,
    #boringAvatarHash: _f$boringAvatarHash,
    #avatarBytes: _f$avatarBytes,
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
      screenSharing: data.dec(_f$screenSharing),
      remoteScreenSharing: data.dec(_f$remoteScreenSharing),
      endReason: data.dec(_f$endReason),
      debug: data.dec(_f$debug),
      connectedAt: data.dec(_f$connectedAt),
      quality: data.dec(_f$quality),
      mediaEpoch: data.dec(_f$mediaEpoch),
      displayName: data.dec(_f$displayName),
      boringAvatarHash: data.dec(_f$boringAvatarHash),
      avatarBytes: data.dec(_f$avatarBytes),
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
    bool? screenSharing,
    bool? remoteScreenSharing,
    CallEndReason? endReason,
    String? debug,
    DateTime? connectedAt,
    CallQuality? quality,
    int? mediaEpoch,
    String? displayName,
    String? boringAvatarHash,
    Uint8List? avatarBytes,
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
    bool? screenSharing,
    bool? remoteScreenSharing,
    CallEndReason? endReason,
    String? debug,
    Object? connectedAt = $none,
    CallQuality? quality,
    int? mediaEpoch,
    String? displayName,
    String? boringAvatarHash,
    Object? avatarBytes = $none,
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
      if (screenSharing != null) #screenSharing: screenSharing,
      if (remoteScreenSharing != null)
        #remoteScreenSharing: remoteScreenSharing,
      if (endReason != null) #endReason: endReason,
      if (debug != null) #debug: debug,
      if (connectedAt != $none) #connectedAt: connectedAt,
      if (quality != null) #quality: quality,
      if (mediaEpoch != null) #mediaEpoch: mediaEpoch,
      if (displayName != null) #displayName: displayName,
      if (boringAvatarHash != null) #boringAvatarHash: boringAvatarHash,
      if (avatarBytes != $none) #avatarBytes: avatarBytes,
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
    screenSharing: data.get(#screenSharing, or: $value.screenSharing),
    remoteScreenSharing: data.get(
      #remoteScreenSharing,
      or: $value.remoteScreenSharing,
    ),
    endReason: data.get(#endReason, or: $value.endReason),
    debug: data.get(#debug, or: $value.debug),
    connectedAt: data.get(#connectedAt, or: $value.connectedAt),
    quality: data.get(#quality, or: $value.quality),
    mediaEpoch: data.get(#mediaEpoch, or: $value.mediaEpoch),
    displayName: data.get(#displayName, or: $value.displayName),
    boringAvatarHash: data.get(#boringAvatarHash, or: $value.boringAvatarHash),
    avatarBytes: data.get(#avatarBytes, or: $value.avatarBytes),
  );

  @override
  CallStateCopyWith<$R2, CallState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CallStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

