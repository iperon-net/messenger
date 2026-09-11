import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

import 'api.dart';
import 'auth.dart';
import 'di.dart';
import 'logger.dart';
import 'protobuf.dart';

/// Стадия звонка 1-на-1.
///
/// - [idle] — активного звонка нет;
/// - [outgoing] — мы позвонили, вошли в комнату LiveKit, ждём, пока абонент
///   подключится (отправлен `CALL_RING`);
/// - [incoming] — нам звонят, ждём решения пользователя (пришёл `CALL_RING`);
/// - [connecting] — мы согласились и подключаемся к комнате LiveKit;
/// - [active] — собеседник в комнате, медиа течёт через SFU;
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

  /// Монотонный счётчик смены медиадорожек (local/remote video track). Дорожки
  /// LiveKit живут в сервисе [Calls] (не в снимке — они не immutable), а UI
  /// читает их геттерами; бамп этого счётчика меняет снимок и заставляет UI
  /// перечитать дорожки, даже когда прочие поля не изменились.
  final int mediaEpoch;

  /// Диагностическая строка-хлебные-крошки (этапы подключения к комнате).
  /// Показываем прямо на экране звонка для отладки на реальных устройствах без
  /// выгрузки логов. Уберём вместе с временным диалером.
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
    this.mediaEpoch = 0,
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
    int? mediaEpoch,
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
      mediaEpoch: mediaEpoch ?? this.mediaEpoch,
      debug: debug ?? this.debug,
    );
  }
}

/// Сервис звонков 1-на-1 поверх **LiveKit SFU**. Сигналинг (SDP/ICE) целиком на
/// стороне LiveKit — этот сервис лишь:
///  - запрашивает у сервера токен доступа в комнату (`CALL_TOKEN`) и подключает
///    [Room] (room = `callId`);
///  - шлёт лёгкий `CALL_RING` для побудки адресата (сервер релеит в стрим и
///    дёргает call-пуш) и `CALL_HANGUP`/`CALL_REJECT` для отмены/отклонения;
///  - маппит события комнаты (`ParticipantConnected`, `TrackSubscribed`,
///    `Disconnected`) в единый [CallSnapshot] для UI.
///
/// Регистрируется в `get_it` (см. `di.dart`, `dependsOn: [API, Auth]`) и живёт
/// всё приложение — чтобы входящий ловился на любом экране. UI подписывается
/// через [CallCubit], навигацию на входящий делает [CallGate]. Публичный API
/// (`startCall/accept/reject/hangup/…` + [snapshots]) неизменен — под ним
/// раньше был ручной WebRTC, теперь LiveKit.
///
/// Только foreground: стрим [API] (по нему приходит `CALL_RING`) открыт лишь на
/// переднем плане; побудку из фона/убитого приложения обеспечивает push
/// (`lib/call_push.dart`), не тронутый переездом.
class Calls {
  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();

  Room? _room;
  EventsListener<RoomEvent>? _roomListener;

  // Активные видеодорожки для рендера (аудио LiveKit проигрывает сам). Живут
  // здесь, а не в снимке (VideoTrack не immutable); UI читает их геттерами и
  // перечитывает по бампу CallSnapshot.mediaEpoch.
  VideoTrack? _localVideoTrack;
  VideoTrack? _remoteVideoTrack;

  // Позиция фронтальной/тыловой камеры для switchCamera.
  CameraPosition _cameraPosition = CameraPosition.front;

  CallSnapshot _snapshot = const CallSnapshot();
  final _snapshotController = StreamController<CallSnapshot>.broadcast();

  // Накапливаемая строка-диагностика текущего звонка (хлебные крошки этапов).
  String _diag = '';

  final List<StreamSubscription<Uint8List>> _signalSubs = [];

  // callId звонка, который пользователь уже принял в нативном экране (CallKit/
  // ConnectionService) из push — но CALL_RING по стриму мог ещё не прийти
  // (клиент только проснулся). Когда ring этого звонка дойдёт до [_onRing],
  // принимаем автоматически. См. lib/call_push.dart.
  String? _pushAcceptedCallId;

  /// Текущий снимок без подписки (стартовое значение для UI).
  CallSnapshot get snapshot => _snapshot;

  /// Изменения снимка звонка (широковещательный поток).
  Stream<CallSnapshot> get snapshots => _snapshotController.stream;

  /// Локальная видеодорожка (картинка-в-картинке). null для аудиозвонка/до
  /// публикации/при выключенной камере.
  VideoTrack? get localVideoTrack => _localVideoTrack;

  /// Видеодорожка собеседника (на весь экран). null для аудиозвонка/пока трек
  /// не подписан.
  VideoTrack? get remoteVideoTrack => _remoteVideoTrack;

  Calls() {
    _signalSubs.addAll([
      api.on(MessageType.CALL_RING).listen((p) => _handleSignal(MessageType.CALL_RING, p)),
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

  bool get _hasActiveCall => _snapshot.status != CallStatus.idle && _snapshot.status != CallStatus.ended;

  // ---------------------------------------------------------------------------
  // Публичный API для UI
  // ---------------------------------------------------------------------------

  /// Инициирует исходящий звонок к [toUserID]. [video] — видеозвонок или только
  /// аудио. Входит в комнату LiveKit и будит абонента через `CALL_RING`.
  Future<void> startCall({required List<int> toUserID, required bool video}) async {
    if (_hasActiveCall) {
      logger.warning('startCall ignored: call already in progress (${_snapshot.status})');
      return;
    }

    final callId = _generateCallId();
    _emit(CallSnapshot(status: CallStatus.outgoing, callId: callId, remoteUserID: toUserID, video: video, speakerOn: video));
    _dbg('outgoing ${video ? 'video' : 'audio'}', reset: true);

    try {
      await _connectRoom(callId: callId, remoteUserID: toUserID, video: video);
      // Будим абонента: сервер релеит CALL_RING в его стрим и шлёт call-пуш.
      // Ответа «принял» нет — увидим подключение как ParticipantConnected.
      await _sendRing(MessageType.CALL_RING, toUserID: toUserID, callId: callId, video: video);
      _dbg('ring sent');
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      await _teardown(CallEndReason.failed);
    }
  }

  /// Принимает входящий звонок: подключается к той же комнате LiveKit. Отдельный
  /// сигнал «принял» не нужен — звонящий увидит нас как участника комнаты.
  Future<void> accept() async {
    if (_snapshot.status != CallStatus.incoming) {
      logger.warning('accept ignored: no incoming call');
      return;
    }

    _emit(_snapshot.copyWith(status: CallStatus.connecting));
    _dbg('accepted');

    try {
      await _connectRoom(callId: _snapshot.callId, remoteUserID: _snapshot.remoteUserID, video: _snapshot.video);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      await _teardown(CallEndReason.failed);
    }
  }

  /// Принимает входящий звонок, инициированный из нативного экрана (CallKit/
  /// ConnectionService) по push. Если `CALL_RING` уже пришёл по стриму —
  /// принимаем сразу; иначе запоминаем [callId] и примем в [_onRing], когда ring
  /// дойдёт (клиент только проснулся из push — см. lib/call_push.dart).
  Future<void> acceptFromPush(String callId) async {
    if (_snapshot.status == CallStatus.incoming && _snapshot.callId == callId) {
      await accept();
      return;
    }
    _pushAcceptedCallId = callId;
  }

  /// Отклоняет звонок из нативного экрана по push. Если входящий уже поднят —
  /// обычный [reject]; иначе (ring ещё в пути) шлём `CALL_REJECT` напрямую по
  /// [fromUserID] из push, чтобы звонящий сразу увидел «отклонён».
  Future<void> rejectFromPush(String callId, List<int> fromUserID) async {
    _pushAcceptedCallId = null;
    if (_snapshot.status == CallStatus.incoming && _snapshot.callId == callId) {
      await reject();
      return;
    }
    await _sendRing(MessageType.CALL_REJECT, toUserID: fromUserID, callId: callId, video: false);
  }

  /// Отклоняет входящий звонок (посылает `CALL_REJECT`).
  Future<void> reject() async {
    if (_snapshot.status != CallStatus.incoming) return;
    await _sendRing(MessageType.CALL_REJECT, toUserID: _snapshot.remoteUserID, callId: _snapshot.callId, video: _snapshot.video);
    await _teardown(CallEndReason.rejected);
  }

  /// Завершает текущий звонок (посылает `CALL_HANGUP` собеседнику).
  Future<void> hangup() async {
    if (!_hasActiveCall) return;
    await _sendRing(MessageType.CALL_HANGUP, toUserID: _snapshot.remoteUserID, callId: _snapshot.callId, video: _snapshot.video);
    await _teardown(CallEndReason.hangup);
  }

  /// Включает/выключает микрофон.
  Future<void> toggleMic() async {
    final participant = _room?.localParticipant;
    if (participant == null) return;
    final muted = !_snapshot.micMuted;
    await participant.setMicrophoneEnabled(!muted);
    _emit(_snapshot.copyWith(micMuted: muted));
  }

  /// Включает/выключает камеру (для видеозвонка).
  Future<void> toggleCamera() async {
    final participant = _room?.localParticipant;
    if (participant == null) return;
    final off = !_snapshot.cameraOff;
    final publication = await participant.setCameraEnabled(!off);
    _localVideoTrack = off ? null : (publication?.track as VideoTrack?);
    _emit(_snapshot.copyWith(cameraOff: off, mediaEpoch: _snapshot.mediaEpoch + 1));
  }

  /// Переключает динамик/разговорный (громкая связь).
  Future<void> toggleSpeaker() async {
    final on = !_snapshot.speakerOn;
    await AudioManager.instance.setSpeakerOutputPreferred(on);
    _emit(_snapshot.copyWith(speakerOn: on));
  }

  /// Переключает фронтальную/тыловую камеру.
  Future<void> switchCamera() async {
    final track = _localVideoTrack;
    if (track is! LocalVideoTrack) return;
    _cameraPosition = _cameraPosition.switched();
    await track.setCameraPosition(_cameraPosition);
  }

  // ---------------------------------------------------------------------------
  // Приём сигналов управления звонком от сервера-реле
  // ---------------------------------------------------------------------------

  Future<void> _handleSignal(MessageType type, Uint8List payload) async {
    final CallRing ring;
    try {
      ring = CallRing.fromBuffer(payload);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return;
    }

    final from = ring.fromUserID;
    logger.debug('call: <- $type callId=${ring.callId} from=${from.length}b status=${_snapshot.status}');

    switch (type) {
      case MessageType.CALL_RING:
        await _onRing(ring, from);
      case MessageType.CALL_HANGUP:
        if (_isCurrentPeer(ring.callId, from)) await _teardown(CallEndReason.hangup);
      case MessageType.CALL_REJECT:
        if (_isCurrentPeer(ring.callId, from)) await _teardown(CallEndReason.rejected);
      default:
        break;
    }
  }

  Future<void> _onRing(CallRing ring, List<int> from) async {
    // Повторный/дублирующий ring текущего звонка — уже обрабатываем, игнорируем.
    if (_hasActiveCall && _isCurrentPeer(ring.callId, from)) return;

    // Заняты другим звонком — отвечаем «занято», текущий не трогаем.
    if (_hasActiveCall) {
      await _sendRing(MessageType.CALL_REJECT, toUserID: from, callId: ring.callId, video: false);
      return;
    }

    _emit(CallSnapshot(status: CallStatus.incoming, callId: ring.callId, remoteUserID: from, video: ring.video, speakerOn: ring.video));
    _dbg('ring recv', reset: true);

    // Пользователь уже принял звонок в нативном экране из push, пока ring ехал
    // по стриму — принимаем сразу, не дожидаясь второго действия.
    if (_pushAcceptedCallId == ring.callId) {
      _pushAcceptedCallId = null;
      await accept();
    }
  }

  // ---------------------------------------------------------------------------
  // Комната LiveKit
  // ---------------------------------------------------------------------------

  /// Запрашивает у сервера токен (`CALL_TOKEN`), подключает [Room] к комнате
  /// `callId` и публикует локальное медиа. Бросает при ошибке — вызывающий
  /// сворачивает звонок как [CallEndReason.failed].
  Future<void> _connectRoom({required String callId, required List<int> remoteUserID, required bool video}) async {
    final request = CallToken_Request(callId: callId, toUserID: Uint8List.fromList(remoteUserID));
    final (status, payload) = await api.unaryEncodedWithResponse(MessageType.CALL_TOKEN, request.writeToBuffer());

    if (status.status != APIStatus.success || payload == null) {
      throw StateError('call token request failed: ${status.error}');
    }

    final response = CallToken_Response.fromBuffer(payload);
    if (response.url.isEmpty || response.token.isEmpty) {
      throw StateError('call token response empty');
    }
    _dbg('token ok');

    final room = Room();
    _room = room;
    _roomListener = room.createListener();
    _wireRoomEvents(_roomListener!);

    await room.connect(response.url, response.token);
    _dbg('room connected');

    await _publishLocalMedia(video: video);

    // Собеседник мог войти в комнату раньше нас (мы принимаем звонок) — тогда
    // события ParticipantConnected/TrackSubscribed уже прошли; переводим в
    // active по факту присутствия участника.
    if (room.remoteParticipants.isNotEmpty) {
      _adoptRemoteTracks();
      _markActive();
    }
  }

  Future<void> _publishLocalMedia({required bool video}) async {
    final participant = _room?.localParticipant;
    if (participant == null) return;

    _cameraPosition = CameraPosition.front;
    await participant.setMicrophoneEnabled(true);
    if (video) {
      final publication = await participant.setCameraEnabled(true);
      _localVideoTrack = publication?.track as VideoTrack?;
      _emit(_snapshot.copyWith(mediaEpoch: _snapshot.mediaEpoch + 1));
    }
    _dbg('published ${video ? 'audio+video' : 'audio'}');
  }

  void _wireRoomEvents(EventsListener<RoomEvent> listener) {
    listener
      ..on<ParticipantConnectedEvent>((event) {
        _dbg('peer joined');
        _markActive();
      })
      ..on<TrackSubscribedEvent>((event) {
        final track = event.track;
        if (track is VideoTrack) {
          _remoteVideoTrack = track;
          _dbg('remote video');
          _emit(_snapshot.copyWith(mediaEpoch: _snapshot.mediaEpoch + 1));
        }
        _markActive();
      })
      ..on<TrackUnsubscribedEvent>((event) {
        if (identical(event.track, _remoteVideoTrack)) {
          _remoteVideoTrack = null;
          _emit(_snapshot.copyWith(mediaEpoch: _snapshot.mediaEpoch + 1));
        }
      })
      ..on<ParticipantDisconnectedEvent>((event) {
        // Собеседник вышел из комнаты — для звонка 1-на-1 это конец разговора.
        _dbg('peer left');
        _teardown(CallEndReason.hangup);
      })
      ..on<RoomDisconnectedEvent>((event) {
        // Нас отключило от SFU (сеть/сервер). Если звонок ещё «жив» — сворачиваем.
        if (_hasActiveCall) {
          _dbg('room disconnected');
          _teardown(CallEndReason.failed);
        }
      });
  }

  // Забирает уже опубликованные видеодорожки присутствующих участников (когда мы
  // подключились после них — события подписки уже прошли).
  void _adoptRemoteTracks() {
    final room = _room;
    if (room == null) return;
    for (final participant in room.remoteParticipants.values) {
      for (final publication in participant.videoTrackPublications) {
        final track = publication.track;
        if (track is VideoTrack) {
          _remoteVideoTrack = track;
          _emit(_snapshot.copyWith(mediaEpoch: _snapshot.mediaEpoch + 1));
          return;
        }
      }
    }
  }

  // Переводит звонок в active, если он ещё жив и не завершён.
  void _markActive() {
    if (!_hasActiveCall) return;
    if (_snapshot.status == CallStatus.active) return;
    _emit(_snapshot.copyWith(status: CallStatus.active));
    _dbg('active');
  }

  Future<void> _teardown(CallEndReason reason) async {
    _pushAcceptedCallId = null;

    final remote = _snapshot.remoteUserID;
    final video = _snapshot.video;
    final callId = _snapshot.callId;

    _localVideoTrack = null;
    _remoteVideoTrack = null;

    await _roomListener?.dispose();
    _roomListener = null;

    final room = _room;
    _room = null;
    if (room != null) {
      try {
        await room.disconnect();
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
      await room.dispose();
    }

    _diag = _diag.isEmpty ? 'ended:${reason.name}' : '$_diag · ended:${reason.name}';
    _emit(CallSnapshot(status: CallStatus.ended, callId: callId, remoteUserID: remote, video: video, endReason: reason, debug: _diag));
  }

  // ---------------------------------------------------------------------------
  // Утилиты
  // ---------------------------------------------------------------------------

  Future<void> _sendRing(MessageType type, {required List<int> toUserID, required String callId, required bool video}) async {
    final ring = CallRing(callId: callId, toUserID: Uint8List.fromList(toUserID), video: video);
    // fromUserID проставит сервер из сессии — здесь не заполняем.
    try {
      await api.sendEncoded(type, ring.writeToBuffer());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  // Совпадает ли сигнал с текущим звонком: тот же callId и тот же собеседник.
  bool _isCurrentPeer(String callId, List<int> from) {
    return _snapshot.callId == callId && listEquals(_snapshot.remoteUserID, from);
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
    await _snapshotController.close();
  }
}
