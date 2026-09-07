import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../calls.dart';
import '../../constants.dart';
import '../../di.dart';
import '../../logger.dart';

import 'call_state.dart';

/// Кубит экрана звонка. Тонкая обёртка над синглтоном [Calls]: подписывается на
/// [Calls.snapshots], переводит снимок в [CallState] и проксирует действия
/// пользователя (принять/отклонить/завершить, mute и т.д.). Рендереры берутся
/// прямо из сервиса — они переживают навигацию между экранами.
class CallCubit extends Cubit<CallState> {
  CallCubit() : super(const CallState());

  final logger = getIt.get<Logger>();
  final _calls = getIt.get<Calls>();

  StreamSubscription<CallSnapshot>? _sub;

  RTCVideoRenderer get localRenderer => _calls.localRenderer;
  RTCVideoRenderer get remoteRenderer => _calls.remoteRenderer;

  void initialization() {
    emit(_fromSnapshot(_calls.snapshot, Status.success));
    _sub = _calls.snapshots.listen((snapshot) => emit(_fromSnapshot(snapshot, Status.success)));
  }

  CallState _fromSnapshot(CallSnapshot s, Status status) => CallState(
    status: status,
    callStatus: s.status,
    callId: s.callId,
    remoteUserID: s.remoteUserID,
    video: s.video,
    micMuted: s.micMuted,
    cameraOff: s.cameraOff,
    speakerOn: s.speakerOn,
    endReason: s.endReason,
    debug: s.debug,
  );

  Future<void> accept() => _calls.accept();
  Future<void> reject() => _calls.reject();
  Future<void> hangup() => _calls.hangup();
  Future<void> toggleMic() => _calls.toggleMic();
  Future<void> toggleCamera() => _calls.toggleCamera();
  Future<void> toggleSpeaker() => _calls.toggleSpeaker();
  Future<void> switchCamera() => _calls.switchCamera();

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
