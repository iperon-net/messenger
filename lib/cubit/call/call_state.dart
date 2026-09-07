import 'package:dart_mappable/dart_mappable.dart';

import '../../calls.dart';
import '../../constants.dart';

part 'call_state.mapper.dart';

/// Состояние экрана звонка. Зеркалит [CallSnapshot] из сервиса [Calls]
/// (см. [CallCubit]) в mappable-состояние по конвенции проекта.
@MappableClass()
class CallState with CallStateMappable {
  final Status status;
  final CallStatus callStatus;
  final String callId;
  final List<int> remoteUserID;
  final bool video;
  final bool micMuted;
  final bool cameraOff;
  final bool speakerOn;
  final CallEndReason endReason;
  final String debug;

  const CallState({
    this.status = Status.initialization,
    this.callStatus = CallStatus.idle,
    this.callId = '',
    this.remoteUserID = const [],
    this.video = false,
    this.micMuted = false,
    this.cameraOff = false,
    this.speakerOn = false,
    this.endReason = CallEndReason.none,
    this.debug = '',
  });
}
