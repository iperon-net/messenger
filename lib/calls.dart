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
/// Фаза 2: ICE-серверы (STUN + эфемерный TURN с HMAC-кредами) запрашиваем у
/// сервера перед каждым звонком (`CALL_ICE_SERVERS`), см. [_fetchIceServers].
/// Только foreground — стрим [API] открыт лишь на переднем плане; фон/пуш —
/// фаза 4.
class Calls {
  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();

  // Фаза 2: ICE-серверы (STUN + эфемерный TURN) запрашиваем у сервера перед
  // каждым звонком (CALL_ICE_SERVERS) — TURN-креды короткоживущие. Если запрос
  // не удался, падаем на публичный STUN: звонок в пределах доступного NAT ещё
  // поднимется, за symmetric NAT — нет.
  static const List<Map<String, dynamic>> _fallbackIceServers = [
    {
      'urls': ['stun:stun.l.google.com:19302'],
    },
  ];

  static Map<String, dynamic> _iceConfigFrom(List<Map<String, dynamic>> iceServers) => {
    'iceServers': iceServers,
    'sdpSemantics': 'unified-plan',
  };

  static const Map<String, dynamic> _offerAnswerConstraints = {'mandatory': {}, 'optional': []};

  // Ретрансмит исходящего offer. Сигналинг идёт через core NATS PublishToUser
  // (fire-and-forget, без гарантии доставки): если стрим адресата в этот момент
  // не подписан (типично на сотовой сети — переподключения/NAT-rebinding), offer
  // молча теряется. Поэтому повторяем CALL_OFFER, пока не придёт answer/reject
  // либо не выйдет таймаут. Relay идемпотентен, приёмник дедупит по callId.
  static const Duration _offerRetransmitInterval = Duration(milliseconds: 1500);
  static const Duration _offerRetransmitTimeout = Duration(seconds: 30);

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

  // Таймер повторной отправки исходящего offer (см. _offerRetransmitInterval).
  Timer? _offerRetransmitTimer;

  // callId звонка, который пользователь уже принял в нативном экране (CallKit/
  // ConnectionService) из push-уведомления — но offer по стриму мог ещё не
  // прийти (клиент только проснулся). Когда offer этого звонка дойдёт до
  // _onOffer, принимаем автоматически, не дожидаясь второго действия. См.
  // фазу 4, lib/call_push.dart.
  String? _pushAcceptedCallId;

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
      // Исходящий: локальное медиа нужно до createOffer, чтобы offer нёс m-line'ы
      // аудио/видео.
      await _acquireLocalMedia(video: video);

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
      _startOfferRetransmit(toUserID: toUserID, callId: callId, video: video, sdp: offer.sdp);
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
      // Локальное медиа захватываем только при принятии звонка (а не на приёме
      // offer) — иначе входящий не показать без выданного разрешения на
      // микрофон, и звонок молча падал бы. addTrack до createAnswer наполняет
      // answer m-line'ами.
      await _acquireLocalMedia(video: _snapshot.video);

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

  /// Принимает входящий звонок, инициированный из нативного экрана (CallKit/
  /// ConnectionService) по push. Если offer уже пришёл по стриму — принимаем
  /// сразу; иначе запоминаем [callId] и примем автоматически в [_onOffer], когда
  /// offer дойдёт (клиент только проснулся из push — см. lib/call_push.dart).
  Future<void> acceptFromPush(String callId) async {
    if (_snapshot.status == CallStatus.incoming && _snapshot.callId == callId) {
      await accept();
      return;
    }
    _pushAcceptedCallId = callId;
  }

  /// Отклоняет звонок из нативного экрана по push. Если offer уже поднят как
  /// входящий — обычный [reject]; иначе (offer ещё в пути) шлём CALL_REJECT
  /// напрямую по [fromUserID] из push, чтобы звонящий перестал ретранслировать
  /// offer и сразу увидел «отклонён».
  Future<void> rejectFromPush(String callId, List<int> fromUserID) async {
    _pushAcceptedCallId = null;
    if (_snapshot.status == CallStatus.incoming && _snapshot.callId == callId) {
      await reject();
      return;
    }
    await _sendSignal(MessageType.CALL_REJECT, toUserID: fromUserID, callId: callId, video: false);
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

    // Повторный offer того же звонка (A ретранслирует CALL_OFFER, пока не получит
    // answer). Сессию заново не переустанавливаем — это сломало бы уже
    // установленный remote description. Если мы уже приняли звонок
    // (connecting/active), значит наш answer до A не дошёл (его доставка тоже без
    // гарантии) — переотправляем текущий answer в ответ на дубликат.
    if (active && sameCall) {
      if (_snapshot.status != CallStatus.incoming) {
        final localDesc = await _pc?.getLocalDescription();
        if (localDesc != null && localDesc.type == 'answer') {
          await _sendSignal(
            MessageType.CALL_ANSWER,
            toUserID: from,
            callId: signal.callId,
            video: _snapshot.video,
            signal: Call_Signal(sdp: localDesc.sdp),
          );
        }
      }
      return;
    }

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

      // Пользователь уже принял звонок в нативном экране из push, пока offer
      // ехал по стриму — принимаем сразу, не дожидаясь второго действия.
      if (_pushAcceptedCallId == signal.callId) {
        _pushAcceptedCallId = null;
        await accept();
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      await _teardown(CallEndReason.failed);
    }
  }

  Future<void> _onAnswer(Call_Signal signal, List<int> from) async {
    if (!_isCurrentPeer(signal.callId, from) || _pc == null) return;

    // Answer пришёл — исходящий offer больше повторять не нужно.
    _stopOfferRetransmit();

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

  /// Запрашивает у сервера ICE-серверы (STUN + эфемерный TURN) для звонка.
  /// При любой ошибке/пустом ответе возвращает публичный STUN-fallback, чтобы
  /// звонок всё равно попытался подняться.
  Future<List<Map<String, dynamic>>> _fetchIceServers() async {
    try {
      final (status, payload) = await api.unaryEncodedWithResponse(MessageType.CALL_ICE_SERVERS, IceServers_Request().writeToBuffer());

      if (status.status != APIStatus.success || payload == null) {
        logger.warning('call: ice servers request failed (${status.error}), falling back to STUN');
        return _fallbackIceServers;
      }

      final response = IceServers_Response.fromBuffer(payload);
      final servers = <Map<String, dynamic>>[];
      for (final server in response.servers) {
        if (server.urls.isEmpty) continue;
        final entry = <String, dynamic>{'urls': server.urls.toList()};
        if (server.username.isNotEmpty) entry['username'] = server.username;
        if (server.credential.isNotEmpty) entry['credential'] = server.credential;
        servers.add(entry);
      }

      if (servers.isEmpty) return _fallbackIceServers;
      _dbg('ice servers ${servers.length}');
      return servers;
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return _fallbackIceServers;
    }
  }

  Future<void> _createPeerConnection({required List<int> remoteUserID, required bool video}) async {
    final iceServers = await _fetchIceServers();
    final pc = await createPeerConnection(_iceConfigFrom(iceServers));
    _pc = pc;
    _sawLocalCand = false;
    _sawRemoteCand = false;

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

  /// Захватывает локальный медиапоток (микрофон + камера для видео) и добавляет
  /// его дорожки в peer connection. Вынесено из [_createPeerConnection]: у
  /// звонящего вызывается до createOffer, у принимающего — в [accept] (а не на
  /// приёме offer), чтобы входящий экран показывался без ожидания разрешения на
  /// микрофон. Идемпотентно: если поток уже захвачен, ничего не делает.
  Future<void> _acquireLocalMedia({required bool video}) async {
    if (_localStream != null || _pc == null) return;

    final stream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': video ? {'facingMode': 'user'} : false,
    });
    _localStream = stream;
    localRenderer.srcObject = stream;

    for (final track in stream.getTracks()) {
      await _pc!.addTrack(track, stream);
    }
  }

  Future<void> _teardown(CallEndReason reason) async {
    _stopOfferRetransmit();
    _pushAcceptedCallId = null;
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

  /// Запускает периодический повтор исходящего offer до прихода answer/reject
  /// или до таймаута. Останавливается сам, как только звонок перестаёт быть
  /// [CallStatus.outgoing] (пришёл answer → connecting, либо reject/сброс →
  /// ended). По таймауту завершает звонок как [CallEndReason.failed] — абонент
  /// недоступен (его стрим так и не принял offer).
  void _startOfferRetransmit({required List<int> toUserID, required String callId, required bool video, required String? sdp}) {
    _stopOfferRetransmit();
    final deadline = DateTime.now().add(_offerRetransmitTimeout);

    _offerRetransmitTimer = Timer.periodic(_offerRetransmitInterval, (timer) {
      if (_snapshot.status != CallStatus.outgoing || _snapshot.callId != callId) {
        _stopOfferRetransmit();
        return;
      }
      if (DateTime.now().isAfter(deadline)) {
        _stopOfferRetransmit();
        _teardown(CallEndReason.failed);
        return;
      }
      _dbg('offer resent');
      _sendSignal(
        MessageType.CALL_OFFER,
        toUserID: toUserID,
        callId: callId,
        video: video,
        signal: Call_Signal(sdp: sdp),
      );
    });
  }

  void _stopOfferRetransmit() {
    _offerRetransmitTimer?.cancel();
    _offerRetransmitTimer = null;
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
