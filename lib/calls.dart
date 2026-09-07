import 'dart:async';

import 'package:flutter/foundation.dart';
// MessageType из webrtc_interface (тип сообщений data-channel) конфликтует с
// protobuf-овским MessageType конверта — data-каналы здесь не используем, прячем.
import 'package:flutter_webrtc/flutter_webrtc.dart' hide MessageType;

import 'api.dart';
import 'auth.dart';
import 'di.dart';
import 'logger.dart';
import 'protobuf.dart';

/// Стадия звонка 1-на-1.
///
/// - [idle] — активного звонка нет;
/// - [outgoing] — мы позвонили, ждём, пока абонент примет (offer отправлен);
/// - [incoming] — нам звонят, ждём решения пользователя (пришёл offer);
/// - [connecting] — обе стороны согласились, идёт установка ICE-соединения;
/// - [active] — соединение установлено, медиа течёт;
/// - [ended] — звонок завершён/отклонён/сорвался (терминальное состояние).
enum CallStatus { idle, outgoing, incoming, connecting, active, ended }

/// Причина завершения звонка — для текста на экране «завершено».
enum CallEndReason { none, hangup, rejected, failed, busy }

/// Неизменяемый снимок текущего звонка. [Calls] публикует его в [Calls.snapshots]
/// на каждое изменение; [CallCubit] переводит снимок в состояние экрана.
@immutable
class CallSnapshot {
  final CallStatus status;
  final String callId;

  /// userID собеседника (12 байт ObjectID). Для исходящего — кому звоним, для
  /// входящего — кто звонит (сервер проставил `fromUserID`).
  final List<int> remoteUserID;

  /// true — видеозвонок, false — только аудио.
  final bool video;

  final bool micMuted;
  final bool cameraOff;
  final bool speakerOn;
  final CallEndReason endReason;

  /// Диагностическая строка-хлебные-крошки (этапы сигналинга/ICE/медиа).
  /// Фаза 1: показываем прямо на экране звонка для отладки на реальных
  /// устройствах без выгрузки логов. Уберём вместе с временным диалером.
  final String debug;

  const CallSnapshot({
    this.status = CallStatus.idle,
    this.callId = '',
    this.remoteUserID = const [],
    this.video = false,
    this.micMuted = false,
    this.cameraOff = false,
    this.speakerOn = false,
    this.endReason = CallEndReason.none,
    this.debug = '',
  });

  CallSnapshot copyWith({
    CallStatus? status,
    String? callId,
    List<int>? remoteUserID,
    bool? video,
    bool? micMuted,
    bool? cameraOff,
    bool? speakerOn,
    CallEndReason? endReason,
    String? debug,
  }) {
    return CallSnapshot(
      status: status ?? this.status,
      callId: callId ?? this.callId,
      remoteUserID: remoteUserID ?? this.remoteUserID,
      video: video ?? this.video,
      micMuted: micMuted ?? this.micMuted,
      cameraOff: cameraOff ?? this.cameraOff,
      speakerOn: speakerOn ?? this.speakerOn,
      endReason: endReason ?? this.endReason,
      debug: debug ?? this.debug,
    );
  }
}

/// Сервис WebRTC-звонков 1-на-1. Единая точка сигналинга: слушает все входящие
/// `CALL_*` из [API], владеет единственным [RTCPeerConnection] и рендерерами,
/// сводит перфект-негошиэйшн (роль polite/impolite по сравнению userID) и
/// публикует снимок звонка в [snapshots].
///
/// Регистрируется в `get_it` (см. `di.dart`, `dependsOn: [API, Auth]`) и живёт
/// всё приложение — чтобы входящий ловился на любом экране. UI (экран звонка)
/// подписывается через [CallCubit], навигацию на входящий делает слушатель в
/// shell (см. `CallGate`). Медиа (SRTP) идёт p2p мимо сервера; сервер — только
/// реле offer/answer/ICE.
///
/// Фаза 1: только STUN (публичный), TURN добавит фаза 2. Только foreground —
/// стрим [API] открыт лишь на переднем плане; фон/пуш — фаза 4.
class Calls {
  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();

  // Фаза 1: публичный STUN. Фаза 2 заменит на эфемерные ICE-серверы с сервера.
  static const Map<String, dynamic> _iceConfig = {
    'iceServers': [
      {
        'urls': ['stun:stun.l.google.com:19302'],
      },
    ],
    'sdpSemantics': 'unified-plan',
  };

  static const Map<String, dynamic> _offerAnswerConstraints = {'mandatory': {}, 'optional': []};

  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();

  RTCPeerConnection? _pc;
  MediaStream? _localStream;

  // Кандидаты, пришедшие до setRemoteDescription, применяем позже: addCandidate
  // до установки remote description бросает ошибку.
  final List<RTCIceCandidate> _pendingRemoteCandidates = [];
  bool _remoteDescriptionSet = false;

  // Разово отмечаем, что кандидаты пошли в каждую сторону (диагностика ICE).
  bool _sawLocalCand = false;
  bool _sawRemoteCand = false;

  // Перфект-негошиэйшн: вежливая сторона уступает при гонке (glare). Роль
  // детерминирована — вежлив тот, чей userID «меньше».
  bool _polite = false;

  CallSnapshot _snapshot = const CallSnapshot();
  final _snapshotController = StreamController<CallSnapshot>.broadcast();

  // Накапливаемая строка-диагностика текущего звонка (хлебные крошки этапов).
  String _diag = '';

  final List<StreamSubscription<Uint8List>> _signalSubs = [];
  bool _renderersReady = false;

  /// Текущий снимок без подписки (стартовое значение для UI).
  CallSnapshot get snapshot => _snapshot;

  /// Изменения снимка звонка (широковещательный поток).
  Stream<CallSnapshot> get snapshots => _snapshotController.stream;

  Calls() {
    _signalSubs.addAll([
      api.on(MessageType.CALL_OFFER).listen((p) => _handleSignal(MessageType.CALL_OFFER, p)),
      api.on(MessageType.CALL_ANSWER).listen((p) => _handleSignal(MessageType.CALL_ANSWER, p)),
      api.on(MessageType.CALL_ICE_CANDIDATE).listen((p) => _handleSignal(MessageType.CALL_ICE_CANDIDATE, p)),
      api.on(MessageType.CALL_HANGUP).listen((p) => _handleSignal(MessageType.CALL_HANGUP, p)),
      api.on(MessageType.CALL_REJECT).listen((p) => _handleSignal(MessageType.CALL_REJECT, p)),
    ]);
  }

  void _emit(CallSnapshot snapshot) {
    _snapshot = snapshot;
    if (!_snapshotController.isClosed) _snapshotController.add(snapshot);
  }

  /// Добавляет этап в диагностику и тут же переиздаёт снимок, чтобы строка
  /// обновилась на экране звонка. [reset] очищает крошки (начало нового звонка).
  void _dbg(String token, {bool reset = false}) {
    _diag = reset ? token : (_diag.isEmpty ? token : '$_diag · $token');
    logger.debug('call: $_diag');
    _emit(_snapshot.copyWith(debug: _diag));
  }

  Future<void> _ensureRenderers() async {
    if (_renderersReady) return;
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    _renderersReady = true;
  }

  // ---------------------------------------------------------------------------
  // Публичный API для UI
  // ---------------------------------------------------------------------------

  /// Инициирует исходящий звонок к [toUserID]. [video] — видеозвонок или только
  /// аудио. Создаёт peer connection, локальный поток и отправляет offer.
  Future<void> startCall({required List<int> toUserID, required bool video}) async {
    if (_snapshot.status != CallStatus.idle && _snapshot.status != CallStatus.ended) {
      logger.warning('startCall ignored: call already in progress (${_snapshot.status})');
      return;
    }

    final callId = _generateCallId();
    _polite = _isPolite(toUserID);

    _emit(CallSnapshot(status: CallStatus.outgoing, callId: callId, remoteUserID: toUserID, video: video, speakerOn: video));
    _dbg('outgoing ${video ? 'video' : 'audio'}', reset: true);

    try {
      await _ensureRenderers();
      await _createPeerConnection(remoteUserID: toUserID, video: video);

      final offer = await _pc!.createOffer(_offerAnswerConstraints);
      await _pc!.setLocalDescription(offer);

      await _sendSignal(
        MessageType.CALL_OFFER,
        toUserID: toUserID,
        callId: callId,
        video: video,
        signal: Call_Signal(sdp: offer.sdp),
      );
      _dbg('offer sent');
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      await _teardown(CallEndReason.failed);
    }
  }

  /// Принимает входящий звонок: создаёт answer и отправляет его звонящему.
  Future<void> accept() async {
    if (_snapshot.status != CallStatus.incoming || _pc == null) {
      logger.warning('accept ignored: no incoming call');
      return;
    }

    _emit(_snapshot.copyWith(status: CallStatus.connecting));
    _dbg('accepted');

    try {
      final answer = await _pc!.createAnswer(_offerAnswerConstraints);
      await _pc!.setLocalDescription(answer);

      await _sendSignal(
        MessageType.CALL_ANSWER,
        toUserID: _snapshot.remoteUserID,
        callId: _snapshot.callId,
        video: _snapshot.video,
        signal: Call_Signal(sdp: answer.sdp),
      );
      _dbg('answer sent');
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      await _teardown(CallEndReason.failed);
    }
  }

  /// Отклоняет входящий звонок (посылает CALL_REJECT).
  Future<void> reject() async {
    if (_snapshot.status != CallStatus.incoming) return;
    await _sendSignal(MessageType.CALL_REJECT, toUserID: _snapshot.remoteUserID, callId: _snapshot.callId, video: _snapshot.video);
    await _teardown(CallEndReason.rejected);
  }

  /// Завершает текущий звонок (посылает CALL_HANGUP собеседнику).
  Future<void> hangup() async {
    if (_snapshot.status == CallStatus.idle || _snapshot.status == CallStatus.ended) return;
    await _sendSignal(MessageType.CALL_HANGUP, toUserID: _snapshot.remoteUserID, callId: _snapshot.callId, video: _snapshot.video);
    await _teardown(CallEndReason.hangup);
  }

  /// Включает/выключает микрофон.
  Future<void> toggleMic() async {
    final track = _localStream?.getAudioTracks().firstOrNull;
    if (track == null) return;
    final muted = !_snapshot.micMuted;
    track.enabled = !muted;
    _emit(_snapshot.copyWith(micMuted: muted));
  }

  /// Включает/выключает камеру (для видеозвонка).
  Future<void> toggleCamera() async {
    final track = _localStream?.getVideoTracks().firstOrNull;
    if (track == null) return;
    final off = !_snapshot.cameraOff;
    track.enabled = !off;
    _emit(_snapshot.copyWith(cameraOff: off));
  }

  /// Переключает динамик/разговорный (громкая связь).
  Future<void> toggleSpeaker() async {
    final on = !_snapshot.speakerOn;
    await Helper.setSpeakerphoneOn(on);
    _emit(_snapshot.copyWith(speakerOn: on));
  }

  /// Переключает фронтальную/тыловую камеру.
  Future<void> switchCamera() async {
    final track = _localStream?.getVideoTracks().firstOrNull;
    if (track == null) return;
    await Helper.switchCamera(track);
  }

  // ---------------------------------------------------------------------------
  // Приём сигналов от сервера-реле
  // ---------------------------------------------------------------------------

  Future<void> _handleSignal(MessageType type, Uint8List payload) async {
    final Call_Signal signal;
    try {
      signal = Call_Signal.fromBuffer(payload);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return;
    }

    final from = signal.fromUserID;
    logger.debug('call: <- $type callId=${signal.callId} from=${from.length}b status=${_snapshot.status}');

    switch (type) {
      case MessageType.CALL_OFFER:
        await _onOffer(signal, from);
      case MessageType.CALL_ANSWER:
        await _onAnswer(signal, from);
      case MessageType.CALL_ICE_CANDIDATE:
        await _onRemoteCandidate(signal, from);
      case MessageType.CALL_HANGUP:
        if (_isCurrentPeer(signal.callId, from)) await _teardown(CallEndReason.hangup);
      case MessageType.CALL_REJECT:
        if (_isCurrentPeer(signal.callId, from)) await _teardown(CallEndReason.rejected);
      default:
        break;
    }
  }

  Future<void> _onOffer(Call_Signal signal, List<int> from) async {
    final active = _snapshot.status != CallStatus.idle && _snapshot.status != CallStatus.ended;
    final sameCall = _isCurrentPeer(signal.callId, from);
    final glare = active && !sameCall && _snapshot.status == CallStatus.outgoing && listEquals(_snapshot.remoteUserID, from);

    _polite = _isPolite(from);

    if (glare) {
      // Столкновение (оба позвонили одновременно тому же абоненту). По perfect
      // negotiation вежливая сторона уступает — сносит свой исходящий и
      // принимает чужой offer; невежливая игнорирует чужой и ждёт свой answer.
      if (!_polite) return;
      await _teardown(CallEndReason.none);
    } else if (active && !sameCall) {
      // Занят другим звонком — отвечаем «занято», текущий не трогаем.
      await _sendSignal(MessageType.CALL_REJECT, toUserID: from, callId: signal.callId, video: false);
      return;
    }

    final video = signal.callType == Call_Signal_CallType.VIDEO;

    try {
      await _ensureRenderers();
      if (_pc == null) {
        await _createPeerConnection(remoteUserID: from, video: video);
      }

      await _pc!.setRemoteDescription(RTCSessionDescription(signal.sdp, 'offer'));
      _remoteDescriptionSet = true;
      await _drainPendingCandidates();

      _emit(CallSnapshot(status: CallStatus.incoming, callId: signal.callId, remoteUserID: from, video: video, speakerOn: video));
      _dbg('offer recv', reset: true);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      await _teardown(CallEndReason.failed);
    }
  }

  Future<void> _onAnswer(Call_Signal signal, List<int> from) async {
    if (!_isCurrentPeer(signal.callId, from) || _pc == null) return;

    try {
      await _pc!.setRemoteDescription(RTCSessionDescription(signal.sdp, 'answer'));
      _remoteDescriptionSet = true;
      await _drainPendingCandidates();
      _emit(_snapshot.copyWith(status: CallStatus.connecting));
      _dbg('answer recv');
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      await _teardown(CallEndReason.failed);
    }
  }

  Future<void> _onRemoteCandidate(Call_Signal signal, List<int> from) async {
    if (!_isCurrentPeer(signal.callId, from)) return;

    if (!_sawRemoteCand) {
      _sawRemoteCand = true;
      _dbg('cand<-');
    }

    final c = signal.candidate;
    final candidate = RTCIceCandidate(c.candidate, c.sdpMid, c.sdpMLineIndex);

    if (!_remoteDescriptionSet || _pc == null) {
      _pendingRemoteCandidates.add(candidate);
      return;
    }

    try {
      await _pc!.addCandidate(candidate);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  Future<void> _drainPendingCandidates() async {
    if (_pc == null) return;
    for (final candidate in _pendingRemoteCandidates) {
      try {
        await _pc!.addCandidate(candidate);
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
    _pendingRemoteCandidates.clear();
  }

  // ---------------------------------------------------------------------------
  // Peer connection
  // ---------------------------------------------------------------------------

  Future<void> _createPeerConnection({required List<int> remoteUserID, required bool video}) async {
    final pc = await createPeerConnection(_iceConfig);
    _pc = pc;
    _sawLocalCand = false;
    _sawRemoteCand = false;

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': video ? {'facingMode': 'user'} : false,
    });
    localRenderer.srcObject = _localStream;

    for (final track in _localStream!.getTracks()) {
      await pc.addTrack(track, _localStream!);
    }

    pc.onIceCandidate = (candidate) {
      if (!_sawLocalCand) {
        _sawLocalCand = true;
        _dbg('cand->');
      }
      // Trickle ICE: шлём кандидатов по мере сбора.
      _sendSignal(
        MessageType.CALL_ICE_CANDIDATE,
        toUserID: remoteUserID,
        callId: _snapshot.callId,
        video: video,
        signal: Call_Signal(
          candidate: Call_IceCandidate(candidate: candidate.candidate, sdpMid: candidate.sdpMid, sdpMLineIndex: candidate.sdpMLineIndex),
        ),
      );
    };

    pc.onTrack = (event) {
      _dbg('track ${event.track.kind}');
      if (event.streams.isNotEmpty) {
        remoteRenderer.srcObject = event.streams.first;
      }
    };

    // ICE-состояние — основной и самый надёжный признак «поднялось/сорвалось»:
    // агрегированный onConnectionState на iOS/Android во flutter_webrtc
    // срабатывает не всегда, поэтому в active/failed переводим именно отсюда.
    pc.onIceConnectionState = (state) {
      _dbg('ice ${state.name.replaceFirst('RTCIceConnectionState', '')}');
      switch (state) {
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
        case RTCIceConnectionState.RTCIceConnectionStateCompleted:
          if (_snapshot.status != CallStatus.ended && _snapshot.status != CallStatus.idle) {
            _emit(_snapshot.copyWith(status: CallStatus.active));
          }
        case RTCIceConnectionState.RTCIceConnectionStateFailed:
          _teardown(CallEndReason.failed);
        case RTCIceConnectionState.RTCIceConnectionStateClosed:
        case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
          // Временный разрыв ICE — не рвём сразу, даём переподключиться.
          break;
        default:
          break;
      }
    };

    pc.onIceGatheringState = (state) => logger.debug('call: ice gathering state $state');
    pc.onSignalingState = (state) => logger.debug('call: signaling state $state');

    pc.onConnectionState = (state) {
      logger.debug('call: peer connection state $state');
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          if (_snapshot.status != CallStatus.ended && _snapshot.status != CallStatus.idle) {
            _emit(_snapshot.copyWith(status: CallStatus.active));
          }
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          _teardown(CallEndReason.failed);
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          // Временный разрыв ICE — не рвём сразу, даём переподключиться.
          break;
        default:
          break;
      }
    };
  }

  Future<void> _teardown(CallEndReason reason) async {
    _remoteDescriptionSet = false;
    _pendingRemoteCandidates.clear();

    final remote = _snapshot.remoteUserID;
    final video = _snapshot.video;
    final callId = _snapshot.callId;

    final stream = _localStream;
    _localStream = null;
    if (stream != null) {
      for (final track in stream.getTracks()) {
        await track.stop();
      }
      await stream.dispose();
    }

    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;

    final pc = _pc;
    _pc = null;
    if (pc != null) {
      await pc.close();
    }

    _diag = _diag.isEmpty ? 'ended:${reason.name}' : '$_diag · ended:${reason.name}';
    _emit(CallSnapshot(status: CallStatus.ended, callId: callId, remoteUserID: remote, video: video, endReason: reason, debug: _diag));
  }

  // ---------------------------------------------------------------------------
  // Утилиты
  // ---------------------------------------------------------------------------

  Future<void> _sendSignal(
    MessageType type, {
    required List<int> toUserID,
    required String callId,
    required bool video,
    Call_Signal? signal,
  }) async {
    final message = signal ?? Call_Signal();
    message
      ..callId = callId
      ..toUserID = Uint8List.fromList(toUserID)
      ..callType = video ? Call_Signal_CallType.VIDEO : Call_Signal_CallType.AUDIO;
    // fromUserID проставит сервер из сессии — здесь не заполняем.

    try {
      await api.sendEncoded(type, message.writeToBuffer());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  // Совпадает ли сигнал с текущим звонком: тот же callId и тот же собеседник.
  bool _isCurrentPeer(String callId, List<int> from) {
    return _snapshot.callId == callId && listEquals(_snapshot.remoteUserID, from);
  }

  // Роль perfect negotiation: вежлив тот, чей userID лексикографически «меньше».
  bool _isPolite(List<int> remoteUserID) {
    final mine = auth.session.userID;
    final n = mine.length < remoteUserID.length ? mine.length : remoteUserID.length;
    for (var i = 0; i < n; i++) {
      if (mine[i] != remoteUserID[i]) return mine[i] < remoteUserID[i];
    }
    return mine.length < remoteUserID.length;
  }

  String _generateCallId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final rand = UniqueKey().toString();
    return '$now-$rand';
  }

  Future<void> dispose() async {
    for (final sub in _signalSubs) {
      await sub.cancel();
    }
    _signalSubs.clear();
    await _teardown(CallEndReason.none);
    await localRenderer.dispose();
    await remoteRenderer.dispose();
    await _snapshotController.close();
  }
}
