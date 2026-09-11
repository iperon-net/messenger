// Аудио-API LiveKit для интеграции с CallKit (AudioManager.setEngineAvailability
// / setAudioSessionManagementMode, AudioEngineAvailability, AudioSessionManagementMode)
// помечены @experimental в SDK 2.12, но это единственный поддерживаемый способ
// отдать владение AVAudioSession внешней call-системе (CallKit). Подавляем шум
// анализатора точечно для всего файла — иначе flutter analyze падает на warning.
// ignore_for_file: experimental_member_use
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' show WebRTC;
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

  // Запросы «вывести экран звонка на передний план» — например, тап по
  // ongoing-нотификации активного звонка в шторке (Android). Отдельно от
  // снимков: статус звонка при этом не меняется, а [CallGate] должен снова
  // открыть `/call`, если пользователь до этого свернул его. См. lib/call_push.dart.
  final _focusController = StreamController<void>.broadcast();

  // Накапливаемая строка-диагностика текущего звонка (хлебные крошки этапов).
  String _diag = '';

  final List<StreamSubscription<Uint8List>> _signalSubs = [];

  // callId звонка, который пользователь уже принял в нативном экране (CallKit/
  // ConnectionService) из push — но CALL_RING по стриму мог ещё не прийти
  // (клиент только проснулся). Когда ring этого звонка дойдёт до [_onRing],
  // принимаем автоматически. См. lib/call_push.dart.
  String? _pushAcceptedCallId;

  // callId, для которого мы уже начали приём/подключение к комнате. Выставляется
  // СИНХРОННО (до первого await) в начале accept()/startCall() и служит защитой
  // от повторного приёма одного и того же звонка: нативный плагин
  // (flutter_callkit_incoming) может прислать событие «принял» дважды, и без
  // этого гарда оба вызова успевают пройти проверки статуса до первого await и
  // войти в одну комнату LiveKit с одинаковой identity — второй участник
  // выбивает первого, комната рвётся и звонок падает (ended:failed). Сбрасывается
  // в [_teardown].
  String? _handlingCallId;

  // Идёт подключение к комнате LiveKit. Выставляется СИНХРОННО в начале
  // [_connectRoom] (до await за CALL_TOKEN) и вместе с проверкой `_room != null`
  // гарантирует единственный вход в комнату: двойной accept от нативного плагина
  // не создаёт второй Room с той же identity (иначе сервер выбивает участника —
  // DUPLICATE_IDENTITY — и звонок мгновенно рвётся). Сбрасывается в [_teardown].
  bool _connectingRoom = false;

  // Комната LiveKit дошла до состояния «подключено» (`room.connect` завершился
  // успехом). До этого момента фаза подключения принадлежит самому `connect()`:
  // на транзиентный `RoomDisconnected` во время неё НЕ реагируем teardown-ом.
  // Иначе disconnect от выбитого дубля (DUPLICATE_IDENTITY) при внутреннем
  // реконнекте SDK рвёт ещё живой второй connect (`CLIENT_REQUEST_LEAVE`), а
  // осиротевший `room.connect()` висит до 10-секундного ICE-таймаута — звонок
  // падает без звука. Реальный провал connect бросит исключение (его ловит
  // [accept]); успех — выставит этот флаг, и только тогда disconnect = конец
  // звонка. Сбрасывается в [_teardown].
  bool _roomConnected = false;

  // Идёт ли уже разбор текущего звонка. `_teardown` зовётся из многих мест
  // (кнопка отбоя, CALL_HANGUP/REJECT по стриму, события LiveKit
  // Participant/RoomDisconnected, ошибки connect), а сам `room.disconnect()`
  // внутри него ПОРОЖДАЕТ эти события — то есть повторный вход в `_teardown`,
  // пока первый ещё висит в `room.dispose()`. Два конкурентных прохода дают два
  // одновременных нативных `RTCPeerConnection.close()` → use-after-free на
  // ICE-потоке libwebrtc (EXC_BAD_ACCESS 0x28), см. livekit client-sdk-flutter
  // #1186. Флаг сериализует разбор: первый вызов делает работу, остальные —
  // no-op. Сбрасывается в самом конце `_teardown`.
  bool _tearingDown = false;

  /// Текущий снимок без подписки (стартовое значение для UI).
  CallSnapshot get snapshot => _snapshot;

  /// Изменения снимка звонка (широковещательный поток).
  Stream<CallSnapshot> get snapshots => _snapshotController.stream;

  /// Запросы вывести экран текущего звонка на передний план (тап по
  /// ongoing-нотификации). [CallGate] переоткрывает `/call`, если звонок активен.
  Stream<void> get focusRequests => _focusController.stream;

  /// Просит показать экран текущего звонка (если он активен). No-op, если звонка
  /// нет — [CallGate] сам проверит статус.
  void requestFocus() {
    if (!_focusController.isClosed) _focusController.add(null);
  }

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
    // Пишем крошки на уровне info (не debug): так та же цепочка, что видна на
    // экране звонка, попадает и в экран логов — по ней видно, на каком шаге
    // звонок умер (ring from push · token ok · room connected · …).
    logger.info('call: $_diag');
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
    _handlingCallId = callId;
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

    // Синхронный дедуп: повторный accept того же звонка (двойное событие от
    // нативного плагина) отбрасываем до любого await, чтобы не войти в комнату
    // LiveKit дважды. Выставляем ДО _emit/await.
    if (_handlingCallId == _snapshot.callId) {
      logger.warning('accept ignored: already handling ${_snapshot.callId}');
      return;
    }
    _handlingCallId = _snapshot.callId;

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
  /// ConnectionService) по push.
  ///
  /// Ключевой момент: сервер релеит `CALL_RING` только в **живой** стрим и не
  /// переигрывает его при переподключении (см. `relayCallSignal`). Клиент,
  /// разбуженный из фона/убитого push-ом, открывает стрим уже ПОСЛЕ того, как
  /// ring улетел «в никуда», — ждать его в [_onRing] бессмысленно, входящий так
  /// и не поднимется. Поэтому поднимаем входящий прямо из данных push
  /// ([callId]/[fromUserID]/[video]) и сразу подключаемся к комнате.
  ///
  /// [fromUserID] может быть пустым, если натив не донёс `extra` — тогда падаем
  /// на старую схему: запоминаем [callId] и примем в [_onRing], если ring всё же
  /// придёт (foreground-гонка, когда стрим был жив).
  Future<void> acceptFromPush(String callId, {required List<int> fromUserID, required bool video}) async {
    // Повторное событие «принял» того же звонка от нативного плагина —
    // отбрасываем синхронно, до любого await (см. [_handlingCallId]).
    if (_handlingCallId == callId) {
      logger.warning('acceptFromPush ignored: already handling $callId');
      return;
    }
    // Входящий уже поднят по стриму (ring обогнал) — просто принимаем.
    // `_handlingCallId` НЕ выставляем здесь: [accept] сам ставит его синхронно
    // (до первого await), а преждевременная пометка заставила бы [accept] выйти
    // по собственному дедуп-гарду, не подключившись (крошка застрянет на приёме).
    if (_snapshot.status == CallStatus.incoming && _snapshot.callId == callId) {
      await accept();
      return;
    }
    // Уже обрабатываем этот же звонок — не дублируем.
    if (_hasActiveCall && _snapshot.callId == callId) return;
    // Заняты другим звонком — не перебиваем.
    if (_hasActiveCall) return;

    if (fromUserID.isEmpty) {
      // Нет собеседника из push — подключиться к комнате нечем; ждём ring.
      _pushAcceptedCallId = callId;
      return;
    }

    // Поднимаем входящий из данных push и принимаем. `_handlingCallId` ставит
    // сам [accept] синхронно (до первого await) — повторный acceptFromPush после
    // этого отсечётся верхним гардом. Здесь его НЕ трогаем: иначе [accept] выйдет
    // по своему дедуп-гарду, не подключившись (крошка застрянет на приёме).
    _emit(CallSnapshot(status: CallStatus.incoming, callId: callId, remoteUserID: fromUserID, video: video, speakerOn: video));
    _dbg('ring from push', reset: true);
    await accept();
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
    // Единственный вход в комнату. Двойной accept от плагина приводит сюда дважды;
    // `_room` выставляется только ПОСЛЕ await за токеном, поэтому одной проверки
    // `_room != null` мало — оба вызова успели бы увидеть null. Синхронный
    // `_connectingRoom` (до первого await) закрывает это окно: второй вызов
    // выходит, не создавая второй Room (иначе DUPLICATE_IDENTITY и мгновенный
    // обрыв). Сбрасывается в [_teardown].
    if (_room != null || _connectingRoom) {
      logger.warning('_connectRoom skipped: already connecting/connected ($callId)');
      return;
    }
    _connectingRoom = true;

    // iOS: выставляем режим аудио LiveKit под путь ответа (CallKit vs foreground)
    // ДО любого await. На CallKit-пути это гейтит движок (externalCallSystem +
    // engineAvailability=none) раньше, чем CallKit успеет прислать `didActivate`
    // (его триггерит активация сессии плагином на ответе). Иначе флип движка в
    // `default` по didActivate мог бы прийти в окне ожидания токена и быть затёрт
    // последующим `none` — движок остался бы выключен, звонок без звука.
    await _configureIosAudioForCall();

    // Держим gRPC-стрим живым на всё время звонка: на iOS CallKit забирает
    // передний план (приходит paused/hidden), и без этого сигналинг звонка
    // дропался бы с `foreground=false`. Снимается в [_teardown].
    api.setCallActive(true);

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
    // С этого момента дубли отсекает `_room != null` — синхронный флаг больше не
    // нужен (снимаем, чтобы возможный ретрай/следующий звонок не заблокировался).
    _connectingRoom = false;
    _roomListener = room.createListener();
    _wireRoomEvents(_roomListener!);

    await room.connect(response.url, response.token);
    _roomConnected = true;
    _dbg('room connected');

    await _publishLocalMedia(video: video);

    // Начальный маршрут аудио. LiveKit (LKAudioSwitchManager) по умолчанию уходит
    // в громкую связь (в логах Telecom: `setCommunicationDevice type:speaker`),
    // а для аудиозвонка ожидается разговорный динамик (earpiece). Задаём явно по
    // `speakerOn` снимка (аудио → false/earpiece, видео → true/speaker). Только
    // Android: на iOS маршрутом владеет CallKit, туда не вмешиваемся.
    if (Platform.isAndroid) {
      try {
        await AudioManager.instance.setSpeakerOutputPreferred(_snapshot.speakerOn);
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }

    // Собеседник мог войти в комнату раньше нас (мы принимаем звонок) — тогда
    // события ParticipantConnected/TrackSubscribed уже прошли; переводим в
    // active по факту присутствия участника.
    if (room.remoteParticipants.isNotEmpty) {
      _adoptRemoteTracks();
      _markActive();
    }
  }

  /// Принудительно инициализирует нативный WebRTC (создаёт
  /// `RTCPeerConnectionFactory` + audio device module). В flutter_webrtc 1.6.0
  /// фабрика создаётся только в нативном `initialize:`, который с Dart-стороны
  /// дёргается лишь при первом реальном использовании WebRTC (коннект комнаты /
  /// getUserMedia). AudioManager ходит к `peerConnectionFactory.audioDeviceModule`
  /// и кидает «audio device module is unavailable», если его зовут раньше.
  /// `WebRTC.initialize` идемпотентен (хранит флаг `initialized`), повторные
  /// вызовы дёшевы. No-op вне iOS.
  Future<void> _ensureWebRtcInitialized() async {
    if (!Platform.isIOS) return;
    await WebRTC.initialize();
  }

  /// iOS: настраивает режим аудио LiveKit под ТЕКУЩИЙ звонок. Вызывается на
  /// каждый коннект (режим — глобальный синглтон AudioManager, поэтому его надо
  /// выставлять под каждый звонок, а не один раз).
  ///
  /// ВСЕГДА `automatic` — и на CallKit cold-start (VoIP-push), и на foreground:
  /// LiveKit единолично владеет AVAudioSession (ставит `PlayAndRecord`, сам её
  /// активирует и рулит движком по жизненному циклу комнаты, как на Android).
  /// Схему `externalCallSystem` (ждать активацию от CallKit `didActivate`)
  /// убрали: на нашем cold-start-ответе `didActivate` не приходит вовсе — см.
  /// подробности в теле метода и в [setAudioEngineActive].
  ///
  /// `WebRTC.initialize` — идемпотентная прогрузка нативной фабрики, нужна до
  /// обращения к AudioManager (см. [_ensureWebRtcInitialized]). No-op вне iOS.
  Future<void> _configureIosAudioForCall() async {
    if (!Platform.isIOS) return;
    try {
      await _ensureWebRtcInitialized();
      // ВСЕГДА `automatic` — и на CallKit cold-start, и на foreground. LiveKit
      // сам ставит `PlayAndRecord`, САМ активирует AVAudioSession и запускает
      // движок по жизненному циклу комнаты, не дожидаясь никого извне.
      //
      // Схема `externalCallSystem` (LiveKit ставит категорию, но НЕ активирует —
      // ждёт CallKit `provider(didActivate:)`) на нашем пути ответа не работает:
      // cold-start-ответ по VoIP-push НЕ проходит через `CXAnswerCallAction`
      // плагина, поэтому ни плагин, ни CallKit сессию не активируют, `didActivate`
      // не приходит вовсе (в in-app talker-логах строки `ToggleAudioSession event
      // received` нет), категория весь звонок остаётся `SoloAmbientSound` —
      // движок не заводится, тишина. Подтверждено на устройстве дважды.
      //
      // Двойного владения с CallKit нет: CallKit активирует ту же сессию, которую
      // LiveKit уже перевёл в `PlayAndRecord`, — активация проходит успешно.
      await AudioManager.instance.setAudioSessionManagementMode(AudioSessionManagementMode.automatic);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Обработчик CallKit-события ToggleAudioSession
  /// (`provider(didActivate:)`/`didDeactivate:`) из [CallPush]. Теперь **no-op**:
  /// аудио на всех путях управляется режимом `automatic`, где движком LiveKit
  /// рулит сам по жизненному циклу комнаты. Ручное дёрганье `setEngineAvailability`
  /// на неактивной сессии давало -3010 и не нужно — оставляем как явную заглушку,
  /// чтобы приходящее из плагина событие не приводило ни к чему.
  Future<void> setAudioEngineActive(bool active) async {
    if (!Platform.isIOS) return;
    logger.info('call: ToggleAudioSession event received (isActive=$active) — no-op (automatic mode)');
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
        // Нас отключило от SFU (сеть/сервер). Реагируем только после того, как
        // `room.connect` подтвердил подключение (`_roomConnected`). Во время
        // самой фазы подключения disconnect может прийти от выбитого дубля при
        // внутреннем реконнекте SDK — teardown тут прибил бы ещё живой connect
        // и дал бы ложный ICE-таймаут (см. [_roomConnected]).
        if (_hasActiveCall && _roomConnected) {
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
    // Повторный вход (в т.ч. из события LiveKit, которое породил наш же
    // `room.disconnect()` ниже) — выходим, чтобы не запустить второй
    // конкурентный `pc.close()` (см. [_tearingDown]).
    if (_tearingDown) return;
    _tearingDown = true;

    _pushAcceptedCallId = null;
    _handlingCallId = null;
    _connectingRoom = false;
    _roomConnected = false;
    // Звонок завершён — отпускаем удержание стрима (вернётся к foreground-гейту).
    api.setCallActive(false);

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

    // Комната разобрана и `_room == null` — повторный `pc.close()` уже
    // невозможен; снимаем флаг, чтобы следующий звонок мог завершиться.
    _tearingDown = false;
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

  // callId обязан быть валидным UUID: на iOS flutter_callkit_incoming кладёт его
  // прямо в CallKit как `CXProvider` UUID, и при невалидной строке молча НЕ
  // репортит входящий (`reportNewIncomingCall` не вызывается) — баннер входящего
  // звонка не показывается вовсе. Прежний `<micros>-[#hash]` этому не
  // удовлетворял. Заодно это имя комнаты LiveKit. Генерируем UUID v4 из
  // криптослучайных байт, без внешнего пакета (`uuid` — лишь транзитивная зависимость).
  String _generateCallId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // версия 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // вариант 10xx
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).toList();
    return '${hex.sublist(0, 4).join()}-${hex.sublist(4, 6).join()}-'
        '${hex.sublist(6, 8).join()}-${hex.sublist(8, 10).join()}-'
        '${hex.sublist(10, 16).join()}';
  }

  Future<void> dispose() async {
    for (final sub in _signalSubs) {
      await sub.cancel();
    }
    _signalSubs.clear();
    await _teardown(CallEndReason.none);
    await _snapshotController.close();
    await _focusController.close();
  }
}
