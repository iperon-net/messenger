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
    #endReason: _f$endReason,
    #debug: _f$debug,
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
      endReason: data.dec(_f$endReason),
      debug: data.dec(_f$debug),
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
    CallEndReason? endReason,
    String? debug,
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
    CallEndReason? endReason,
    String? debug,
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
      if (endReason != null) #endReason: endReason,
      if (debug != null) #debug: debug,
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
    endReason: data.get(#endReason, or: $value.endReason),
    debug: data.get(#debug, or: $value.debug),
  );

  @override
  CallStateCopyWith<$R2, CallState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CallStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

