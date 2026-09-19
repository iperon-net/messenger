// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'call_log.dart';

class CallDirectionMapper extends EnumMapper<CallDirection> {
  CallDirectionMapper._();

  static CallDirectionMapper? _instance;
  static CallDirectionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CallDirectionMapper._());
    }
    return _instance!;
  }

  static CallDirection fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  CallDirection decode(dynamic value) {
    switch (value) {
      case r'incoming':
        return CallDirection.incoming;
      case r'outgoing':
        return CallDirection.outgoing;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(CallDirection self) {
    switch (self) {
      case CallDirection.incoming:
        return r'incoming';
      case CallDirection.outgoing:
        return r'outgoing';
    }
  }
}

extension CallDirectionMapperExtension on CallDirection {
  String toValue() {
    CallDirectionMapper.ensureInitialized();
    return MapperContainer.globals.toValue<CallDirection>(this) as String;
  }
}

class CallLogMapper extends ClassMapperBase<CallLog> {
  CallLogMapper._();

  static CallLogMapper? _instance;
  static CallLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CallLogMapper._());
      MapperContainer.globals.useAll([
        Uint8ListMapper(),
        BoolMapper(),
        EpochDateTimeMapper(),
      ]);
      CallDirectionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CallLog';

  static int _$id(CallLog v) => v.id;
  static const Field<CallLog, int> _f$id = Field('id', _$id, opt: true, def: 0);
  static String _$callID(CallLog v) => v.callID;
  static const Field<CallLog, String> _f$callID = Field(
    'callID',
    _$callID,
    opt: true,
    def: '',
  );
  static Uint8List _$userID(CallLog v) => v.userID;
  static const Field<CallLog, Uint8List> _f$userID = Field('userID', _$userID);
  static String _$displayName(CallLog v) => v.displayName;
  static const Field<CallLog, String> _f$displayName = Field(
    'displayName',
    _$displayName,
    opt: true,
    def: '',
  );
  static CallDirection _$direction(CallLog v) => v.direction;
  static const Field<CallLog, CallDirection> _f$direction = Field(
    'direction',
    _$direction,
    opt: true,
    def: CallDirection.outgoing,
  );
  static bool _$video(CallLog v) => v.video;
  static const Field<CallLog, bool> _f$video = Field(
    'video',
    _$video,
    opt: true,
    def: false,
  );
  static bool _$missed(CallLog v) => v.missed;
  static const Field<CallLog, bool> _f$missed = Field(
    'missed',
    _$missed,
    opt: true,
    def: false,
  );
  static int _$durationSeconds(CallLog v) => v.durationSeconds;
  static const Field<CallLog, int> _f$durationSeconds = Field(
    'durationSeconds',
    _$durationSeconds,
    opt: true,
    def: 0,
  );
  static DateTime _$createdAt(CallLog v) => v.createdAt;
  static const Field<CallLog, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<CallLog> fields = const {
    #id: _f$id,
    #callID: _f$callID,
    #userID: _f$userID,
    #displayName: _f$displayName,
    #direction: _f$direction,
    #video: _f$video,
    #missed: _f$missed,
    #durationSeconds: _f$durationSeconds,
    #createdAt: _f$createdAt,
  };

  static CallLog _instantiate(DecodingData data) {
    return CallLog(
      id: data.dec(_f$id),
      callID: data.dec(_f$callID),
      userID: data.dec(_f$userID),
      displayName: data.dec(_f$displayName),
      direction: data.dec(_f$direction),
      video: data.dec(_f$video),
      missed: data.dec(_f$missed),
      durationSeconds: data.dec(_f$durationSeconds),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CallLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CallLog>(map);
  }

  static CallLog fromJson(String json) {
    return ensureInitialized().decodeJson<CallLog>(json);
  }
}

mixin CallLogMappable {
  String toJson() {
    return CallLogMapper.ensureInitialized().encodeJson<CallLog>(
      this as CallLog,
    );
  }

  Map<String, dynamic> toMap() {
    return CallLogMapper.ensureInitialized().encodeMap<CallLog>(
      this as CallLog,
    );
  }

  CallLogCopyWith<CallLog, CallLog, CallLog> get copyWith =>
      _CallLogCopyWithImpl<CallLog, CallLog>(
        this as CallLog,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CallLogMapper.ensureInitialized().stringifyValue(this as CallLog);
  }

  @override
  bool operator ==(Object other) {
    return CallLogMapper.ensureInitialized().equalsValue(
      this as CallLog,
      other,
    );
  }

  @override
  int get hashCode {
    return CallLogMapper.ensureInitialized().hashValue(this as CallLog);
  }
}

extension CallLogValueCopy<$R, $Out> on ObjectCopyWith<$R, CallLog, $Out> {
  CallLogCopyWith<$R, CallLog, $Out> get $asCallLog =>
      $base.as((v, t, t2) => _CallLogCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CallLogCopyWith<$R, $In extends CallLog, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? id,
    String? callID,
    Uint8List? userID,
    String? displayName,
    CallDirection? direction,
    bool? video,
    bool? missed,
    int? durationSeconds,
    DateTime? createdAt,
  });
  CallLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CallLogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CallLog, $Out>
    implements CallLogCopyWith<$R, CallLog, $Out> {
  _CallLogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CallLog> $mapper =
      CallLogMapper.ensureInitialized();
  @override
  $R call({
    int? id,
    String? callID,
    Uint8List? userID,
    String? displayName,
    CallDirection? direction,
    bool? video,
    bool? missed,
    int? durationSeconds,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (callID != null) #callID: callID,
      if (userID != null) #userID: userID,
      if (displayName != null) #displayName: displayName,
      if (direction != null) #direction: direction,
      if (video != null) #video: video,
      if (missed != null) #missed: missed,
      if (durationSeconds != null) #durationSeconds: durationSeconds,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  CallLog $make(CopyWithData data) => CallLog(
    id: data.get(#id, or: $value.id),
    callID: data.get(#callID, or: $value.callID),
    userID: data.get(#userID, or: $value.userID),
    displayName: data.get(#displayName, or: $value.displayName),
    direction: data.get(#direction, or: $value.direction),
    video: data.get(#video, or: $value.video),
    missed: data.get(#missed, or: $value.missed),
    durationSeconds: data.get(#durationSeconds, or: $value.durationSeconds),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  CallLogCopyWith<$R2, CallLog, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CallLogCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

