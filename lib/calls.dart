// Аудио-API LiveKit для интеграции с CallKit (AudioManager.setEngineAvailability
// / setAudioSessionManagementMode, AudioEngineAvailability, AudioSessionManagementMode)
// помечены @experimental в SDK 2.12, но это единственный поддерживаемый способ
// отдать владение AVAudioSession внешней call-системе (CallKit). Подавляем шум
// анализатора точечно для всего файла — иначе flutter analyze падает на warning.
// ignore_for_file: experimental_member_use
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' show WebRTC;
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:livekit_client/livekit_client.dart';

import 'api.dart';
import 'auth.dart';
import 'di.dart';
import 'logger.dart';
import 'models.dart' as models;
import 'protobuf.dart';
import 'repositories/repositories.dart';
import 'settings.dart';
import 'utils.dart';

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
enum CallEndReason { none, hangup, rejected, failed, busy, notAllowed, noConnection }

/// Качество соединения звонка для индикатора на экране. Агрегируем из LiveKit
/// [ConnectionQuality] собеседника (см. [Calls._mapQuality]); `unknown` — пока
/// LiveKit не прислал оценку (индикатор не показываем).
enum CallQuality { unknown, poor, good, excellent }

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

  /// Микрофон СОБЕСЕДНИКА выключен. Отражает mute-состояние удалённой
  /// аудиодорожки в комнате LiveKit (события `TrackMuted`/`TrackUnmuted`), а не
  /// наш [micMuted]. `false`, пока участника/дорожки нет.
  final bool remoteMicMuted;

  /// Камера СОБЕСЕДНИКА выключена (или ещё не опубликована). При выключении
  /// камеры LiveKit мьютит видеодорожку, но НЕ отписывает её — без этого флага у
  /// нас на экране застыл бы последний кадр. Когда `true`, UI показывает аватар
  /// вместо рендера. Актуально только для видеозвонка.
  final bool remoteVideoOff;

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

  /// Момент перехода звонка в [CallStatus.active] (соединение установлено) —
  /// точка отсчёта таймера разговора на экране. `null`, пока звонок не активен.
  final DateTime? connectedAt;

  /// Качество соединения собеседника (индикатор на экране). `unknown` — оценки
  /// ещё нет. См. [Calls._mapQuality].
  final CallQuality quality;

  const CallSnapshot({
    this.status = CallStatus.idle,
    this.callId = '',
    this.remoteUserID = const [],
    this.video = false,
    this.micMuted = false,
    this.cameraOff = false,
    this.speakerOn = false,
    this.remoteMicMuted = false,
    this.remoteVideoOff = true,
    this.endReason = CallEndReason.none,
    this.mediaEpoch = 0,
    this.debug = '',
    this.connectedAt,
    this.quality = CallQuality.unknown,
  });

  CallSnapshot copyWith({
    CallStatus? status,
    String? callId,
    List<int>? remoteUserID,
    bool? video,
    bool? micMuted,
    bool? cameraOff,
    bool? speakerOn,
    bool? remoteMicMuted,
    bool? remoteVideoOff,
    CallEndReason? endReason,
    int? mediaEpoch,
    String? debug,
    DateTime? connectedAt,
    CallQuality? quality,
  }) {
    return CallSnapshot(
      status: status ?? this.status,
      callId: callId ?? this.callId,
      remoteUserID: remoteUserID ?? this.remoteUserID,
      video: video ?? this.video,
      micMuted: micMuted ?? this.micMuted,
      cameraOff: cameraOff ?? this.cameraOff,
      speakerOn: speakerOn ?? this.speakerOn,
      remoteMicMuted: remoteMicMuted ?? this.remoteMicMuted,
      remoteVideoOff: remoteVideoOff ?? this.remoteVideoOff,
      endReason: endReason ?? this.endReason,
      mediaEpoch: mediaEpoch ?? this.mediaEpoch,
      debug: debug ?? this.debug,
      connectedAt: connectedAt ?? this.connectedAt,
      quality: quality ?? this.quality,
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
  final settings = getIt.get<Settings>();
  final utils = getIt.get<Utils>();

  // iOS-канал к AppDelegate для явной активации/деактивации AVAudioSession на
  // пути без CallKit (см. [_setIosAudioSessionActive]). Маршрут на динамик/
  // разговорный переключает LiveKit `AudioManager.setSpeakerOutputPreferred`
  // (см. [toggleSpeaker]), а не этот канал.
  static const _callAudioChannel = MethodChannel('net.iperon.messenger/call_audio');

  // Проигрыватель гудков (ringback) исходящего звонка: зациклённый тон
  // assets/audio/ringback.wav (425 Гц, 1с/4с — RU-стандарт) звучит, пока ждём
  // ответа абонента (статус outgoing), и глушится при подключении собеседника
  // ([_markActive]) или завершении ([_teardown]). Создаётся лениво в
  // [_startRingback]. Контекст сессии выставлен так, чтобы уживаться с активной
  // call-аудиосессией LiveKit/CallKit (mixWithOthers на iOS, без захвата
  // аудиофокуса на Android) и не глушить/не рвать её при play/stop.
  AudioPlayer? _ringback;

  static final AudioContext _ringbackAudioContext = AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playAndRecord,
      options: const {AVAudioSessionOptions.mixWithOthers, AVAudioSessionOptions.allowBluetooth},
    ),
    android: const AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: false,
      contentType: AndroidContentType.speech,
      usageType: AndroidUsageType.voiceCommunication,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  // Таймер отмены исходящего недозвона. Заводится на старте исходящего; если
  // абонент не подключился за [Settings.callRingTimeoutSeconds], сам вызывает
  // [hangup] → уходит `CALL_HANGUP`, и сервер снимает у абонента баннер входящего
  // cancel-пушем. Без этого недозвон, который звонящий бросил не нажав отбой,
  // оставляет у абонента висящий баннер. Снимается в [_markActive] (ответили) и
  // в [_teardown] (любое завершение). См. [_startRingTimeout]/[_cancelRingTimeout].
  Timer? _ringTimer;

  // Бэкстоп-таймер входящего (callee): если звонок так и не приняли за чуть
  // больше времени, чем каллер-таймаут ([_incomingTimeout]), локально сворачиваем
  // звонок — переход в `ended` дёргает [CallPush] `endCall` и гасит зависший
  // баннер. Нужен на случай, когда звонящего убили ДО срабатывания его таймера
  // (тогда `CALL_HANGUP`/cancel-пуш не придут). Маржа сверх каллер-таймаута —
  // чтобы штатную отмену обычно успевал сделать cancel-пуш, а этот таймер оставался
  // лишь страховкой. Снимается в [accept]/[reject]/[_teardown]. Работает только
  // пока Dart жив (foreground/фон); cold-start-баннер убитого приложения этим не
  // покрыт — там страхуют каллер-cancel и нативные таймауты (iOS 30с). См.
  // [_startIncomingTimeout]/[_cancelIncomingTimeout].
  Timer? _incomingTimer;

  // Сколько ждём ответа на входящий, прежде чем снять баннер как пропущенный.
  Duration get _incomingTimeout => Duration(seconds: settings.callRingTimeoutSeconds + 15);

  // Сторож соединения: после accept звонок висит в `connecting`, пока собеседник
  // не появится в комнате (ParticipantConnected → [_markActive] → active). У
  // `outgoing` от недозвона страхует [_ringTimer], у `incoming` — [_incomingTimer],
  // а у `connecting` своего таймаута нет: если собеседник так и не подключился, а
  // `CALL_HANGUP` не дошёл, teardown не позовёт никто и снимок навсегда застрянет
  // в `connecting` — `_hasActiveCall` останется true, и клиент будет
  // авто-отклонять (`_onRing` → «занято») все входящие до перезапуска приложения
  // («зомби-звонок»). Этот таймер — страховка от такого залипания. Снимается в
  // [_markActive]/[_teardown]. См. [_startConnectTimeout].
  Timer? _connectTimer;

  // Сколько раз пробуем начальный connect к комнате перед провалом звонка (см.
  // [_connectRoom]). Первый connect LiveKit не переигрывает сам, а на холодном
  // старте сеть ещё не готова — поэтому повторяем сами. Значение — из Remote
  // Config (`CALL_CONNECT_MAX_ATTEMPTS`), чтобы крутить без пересборки.
  int get _maxConnectAttempts => settings.callConnectMaxAttempts;

  // Таймауты подключения к комнате. `peerConnection` укорочен относительно
  // дефолтных 10 с SDK (из Remote Config `CALL_PEER_CONNECTION_TIMEOUT_SECONDS`),
  // чтобы мёртвая ICE-попытка отваливалась быстрее и повтор шёл живее; прочие —
  // как в [Timeouts.defaultTimeouts].
  Timeouts get _callTimeouts => Timeouts(
    connection: const Duration(seconds: 10),
    debounce: const Duration(milliseconds: 20),
    publish: const Duration(seconds: 10),
    subscribe: const Duration(seconds: 10),
    peerConnection: Duration(seconds: settings.callPeerConnectionTimeoutSeconds),
    iceRestart: const Duration(seconds: 10),
  );

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

  // Запросы «показать входящий через системную звонилку» (CallKit/
  // ConnectionService). Эмитятся ТОЛЬКО из foreground-приёма [_onRing] — когда
  // `CALL_RING` пришёл по живому стриму. Так входящий на переднем плане тоже
  // ведётся нативной call-системой (единый системный рингтон и UI, как из фона),
  // а не рисуется собственным экраном без звука. Слушает [CallPush], который
  // владеет зависимостью на flutter_callkit_incoming. См. lib/call_push.dart.
  final _incomingRingController = StreamController<CallSnapshot>.broadcast();

  // Направление текущего звонка для журнала недавних. Ставится на старте
  // исходящего ([startCall]) и на подъёме входящего ([_onRing]/[acceptFromPush]),
  // читается в [_teardown] при записи строки журнала и сбрасывается там же в null
  // — между звонками остаётся null, чтобы разбор без активного звонка (dispose)
  // не записал фантомную строку.
  models.CallDirection? _logDirection;

  // Уведомление «в журнал звонков добавлена запись» — [CallsCubit] по нему
  // перечитывает список. Эмитится из [_recordCallLog] после успешной вставки.
  final _callLoggedController = StreamController<void>.broadcast();

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

  // iOS: отвечаем ли на ТЕКУЩИЙ звонок через CallKit (cold-start по VoIP-push,
  // активацию AVAudioSession ведёт CallKit). На iOS звонок ВСЕГДА идёт в режиме
  // `externalCallSystem` (сессией владеет внешняя система), а этот флаг решает,
  // КТО активирует сессию: CallKit (true → гейт движка по `didActivate`) или мы
  // сами нативно (false → см. [_iosManualAudioSession]). Ставится в
  // [acceptFromPush] (true), сбрасывается в [_teardown] (false).
  bool _viaCallKit = false;

  // iOS: активировали ли мы AVAudioSession сами (исходящий/foreground без
  // CallKit). В этом режиме LiveKit держим в `externalCallSystem`, сессию
  // поднимаем нативно ДО `startCapture` (иначе гонка -4100 в `automatic` на
  // повторных звонках) и по завершении деактивируем нативно. Ставится в
  // [_configureIosAudioForCall], снимается в [_teardown].
  bool _iosManualAudioSession = false;

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

  /// Запросы показать входящий через системную звонилку (foreground-приём по
  /// стриму). [CallPush] на каждый вызывает `showCallkitIncoming`. См. [_onRing].
  Stream<CallSnapshot> get incomingRings => _incomingRingController.stream;

  /// Уведомления о добавлении записи в журнал звонков (после завершения звонка).
  /// Вкладка «Звонки» ([CallsCubit]) по нему перечитывает список.
  Stream<void> get callLogged => _callLoggedController.stream;

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

  // ВРЕМЕННАЯ ДИАГНОСТИКА двойного входа в комнату (DUPLICATE_IDENTITY).
  // Пишем на info с легко грепаемым префиксом CALLDIAG — виден и в logcat, и в
  // in-app-логе. По pid/isolate/room# разделяем: второй изолят vs дырявый гард
  // vs reconnect самого LiveKit-SDK. Счётчик входов в _connectRoom — глобальный
  // на изолят (у второго изолята свой отсчёт с 0). Убрать после локализации.
  static int _connectSeq = 0;
  void _diag2(String token) {
    logger.info(
      'CALLDIAG pid=$pid iso=${Isolate.current.debugName} inst=${identityHashCode(this)} room#=${identityHashCode(_room)} | $token',
    );
  }

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

    // Нет сети — не начинаем звонок и не открываем экран `/call`: иначе запрос
    // токена (`CALL_TOKEN`) висел бы в gRPC до таймаута (десятки секунд) без
    // обратной связи. Отдаём в UI причину noConnection терминальным снимком —
    // CallGate покажет алерт/плашку «нет интернета», не поднимая экран звонка.
    if (!await utils.hasNetwork()) {
      logger.info('startCall aborted: no network connection');
      final noNetCallId = _generateCallId();
      _emit(
        CallSnapshot(
          status: CallStatus.ended,
          callId: noNetCallId,
          remoteUserID: toUserID,
          video: video,
          endReason: CallEndReason.noConnection,
        ),
      );
      // Звонок даже не начался (нет сети) — [_teardown] не зовётся, поэтому строку
      // журнала пишем здесь напрямую: исходящий с нулевой длительностью, в UI —
      // «Отменённый».
      unawaited(
        _recordCallLog(
          callId: noNetCallId,
          remoteUserID: toUserID,
          video: video,
          direction: models.CallDirection.outgoing,
          missed: false,
          durationSeconds: 0,
        ),
      );
      _scheduleIdleReset(noNetCallId);
      return;
    }

    final callId = _generateCallId();
    _handlingCallId = callId;
    _logDirection = models.CallDirection.outgoing;
    _emit(CallSnapshot(status: CallStatus.outgoing, callId: callId, remoteUserID: toUserID, video: video, speakerOn: video));
    _dbg('outgoing ${video ? 'video' : 'audio'}', reset: true);

    try {
      await _connectRoom(callId: callId, remoteUserID: toUserID, video: video);
      // Будим абонента: сервер релеит CALL_RING в его стрим и шлёт call-пуш.
      // Ответа «принял» нет — увидим подключение как ParticipantConnected.
      //
      // Инициирующий RING шлём unary (не через стрим): только так до нас дойдёт
      // серверный гейт звонков — PermissionDenied, если абонент запретил звонки
      // не-контактам и мы не у него в книге. При отказе сворачиваем звонок как
      // notAllowed (абонент так и не зазвонит).
      final ringStatus = await _sendRingInitiating(toUserID: toUserID, callId: callId, video: video);
      if (ringStatus.statusCode == StatusCode.permissionDenied) {
        logger.info('startCall denied by gate: not allowed to call this user');
        await _teardown(CallEndReason.notAllowed);
        return;
      }
      _dbg('ring sent');
      // Абонент вызван — заводим гудки до его подключения. Аудиосессия к этому
      // моменту уже поднята в [_connectRoom] (на iOS — нативно), так что ringback
      // играет в разговорный динамик, как в телефоне. Гасится в [_markActive] по
      // подключению собеседника или в [_teardown] при завершении. Если абонент
      // успел подключиться раньше (уже active) — не заводим. Тем же условием
      // заводим таймер отмены недозвона — иначе брошенный звонок оставит у абонента
      // висящий баннер входящего.
      if (_snapshot.status == CallStatus.outgoing) {
        unawaited(_startRingback());
        _startRingTimeout(callId);
      }
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
    // Приняли — бэкстоп-таймер входящего больше не нужен.
    _cancelIncomingTimeout();

    _emit(_snapshot.copyWith(status: CallStatus.connecting));
    _dbg('accepted');
    // Страховка от залипания в `connecting`: если собеседник не войдёт в комнату
    // и отмена не придёт — свернём сами (см. [_connectTimer]).
    _startConnectTimeout(_snapshot.callId);

    try {
      await _connectRoom(callId: _snapshot.callId, remoteUserID: _snapshot.remoteUserID, video: _snapshot.video);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      // ДИАГНОСТИКА (наблюдение, поведение не меняем): фиксируем, был ли звонок
      // уже active в момент ошибки connect — это сигнатура «осиротевший дубль
      // (DUPLICATE_IDENTITY) кинул ICE-таймаут поверх живой комнаты». По итогам
      // локализации здесь появится точечное подавление teardown.
      _diag2('accept catch: teardown failed (wasActive=${_snapshot.status == CallStatus.active} roomConnected=$_roomConnected) err=$error');
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
    // Отвечаем через CallKit — активацией AVAudioSession владеет она, LiveKit
    // переводим в `externalCallSystem` с гейтом движка по `didActivate` (см.
    // [_viaCallKit]/[_configureIosAudioForCall]). Ставим до любого accept(): и
    // прямого ниже, и отложенного через [_onRing], когда ждём ring ради fromUserID.
    _viaCallKit = true;
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
    _logDirection = models.CallDirection.incoming;
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
  ///
  /// Маршрутом аудио звонка на ОБЕИХ платформах владеет LiveKit
  /// (`AudioManager.setSpeakerOutputPreferred`), а НЕ flutter_webrtc
  /// `Helper.setSpeakerphoneOn`: LiveKit безусловно отключает собственный
  /// audio-session-менеджмент flutter_webrtc (`audioSessionManagementEnabled`),
  /// поэтому нативный `enableSpeakerphone` в нём гейтится этим флагом и оказывается
  /// no-op (иконка `speakerOn` переключалась, а звук — нет). На iOS в режиме
  /// `externalCallSystem` `setSpeakerOutputPreferred` меняет только категорию/режим
  /// (`videoChat` = динамик / `voiceChat` = разговорный) + port override через
  /// движок и НЕ активирует сессию заново (`sessionActivationEnabled=false`), т.е.
  /// не рвёт внешнюю call-сессию (CallKit/наш `activateSession`).
  Future<void> toggleSpeaker() async {
    final on = !_snapshot.speakerOn;
    logger.info('call: toggleSpeaker -> $on (viaCallKit=$_viaCallKit, status=${_snapshot.status})');
    try {
      await AudioManager.instance.setSpeakerOutputPreferred(on);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
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

    _logDirection = models.CallDirection.incoming;
    _emit(CallSnapshot(status: CallStatus.incoming, callId: ring.callId, remoteUserID: from, video: ring.video, speakerOn: ring.video));
    _dbg('ring recv', reset: true);

    // Пользователь уже принял звонок в нативном экране из push, пока ring ехал
    // по стриму — принимаем сразу, не дожидаясь второго действия.
    if (_pushAcceptedCallId == ring.callId) {
      _pushAcceptedCallId = null;
      await accept();
      return;
    }

    // Бэкстоп на висящий баннер: если не ответят и звонящий не снимет звонок —
    // сами свернём через [_incomingTimeout] (см. [_startIncomingTimeout]).
    _startIncomingTimeout(ring.callId);

    // Foreground-приём: ring пришёл по живому стриму (в этом состоянии сервер не
    // слал call-пуш — гейт по онлайн-сессии). Просим [CallPush] показать входящий
    // через системную звонилку — так на переднем плане играет системный рингтон и
    // UI ведёт CallKit/ConnectionService, как из фона. Ответ/отбой прилетят
    // обратно тем же путём (onEvent → acceptFromPush/rejectFromPush), а отмену
    // звонящим (`CALL_HANGUP`/`CALL_REJECT`) снимет [_teardown] → endCall.
    if (!_incomingRingController.isClosed) _incomingRingController.add(_snapshot);
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
    final seq = ++_connectSeq;
    _diag2('_connectRoom ENTER seq=$seq callId=$callId _room=${_room != null} _connecting=$_connectingRoom _handling=$_handlingCallId');
    if (_room != null || _connectingRoom) {
      logger.warning('_connectRoom skipped: already connecting/connected ($callId)');
      _diag2('_connectRoom SKIP seq=$seq (guard hit)');
      return;
    }
    _connectingRoom = true;
    _diag2('_connectRoom PASS seq=$seq (guard passed, connecting)');

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

    // Подключаемся к комнате с ограниченным числом повторов. Встроенный
    // авто-реконнект LiveKit включается ТОЛЬКО после первого успешного connect;
    // провал самого первого connect (ICE/PeerConnection timeout) SDK не
    // переигрывает. На холодном старте (приём из VoIP-push) сеть/радио ещё
    // поднимаются и ICE-gathering не успевает за дефолтные 10 с — короткий повтор
    // с чистой комнатой обычно ловит уже прогретую сеть. `_connectingRoom` держим
    // взведённым на весь цикл (гард от повторного входа) и снимаем после успеха;
    // при полном провале его сбросит [_teardown].
    final maxAttempts = _maxConnectAttempts;
    final timeouts = _callTimeouts;
    var attempt = 0;
    while (true) {
      attempt++;
      final room = Room();
      _room = room;
      _diag2('Room CREATED seq=$seq attempt=$attempt room#=${identityHashCode(room)} url=${response.url}');
      _roomListener = room.createListener();
      _wireRoomEvents(_roomListener!);

      try {
        _diag2('room.connect CALL seq=$seq attempt=$attempt room#=${identityHashCode(room)}');
        await room.connect(response.url, response.token, connectOptions: ConnectOptions(timeouts: timeouts));
        _diag2('room.connect DONE seq=$seq attempt=$attempt room#=${identityHashCode(room)}');
        break;
      } on MediaConnectException catch (error, stackTrace) {
        logger.warning('room.connect attempt $attempt/$maxAttempts failed: $error');
        logger.handle(error, stackTrace);
        _dbg('ice timeout #$attempt');
        // Разбираем полуоткрытую комнату перед повтором: слушатель + сам Room.
        // `_roomConnected` ещё false — RoomDisconnected на этой фазе teardown не
        // запускает (см. [_wireRoomEvents]). Поля читаем актуальные: если во время
        // await сюда пришёл [_teardown] (отбой) — он уже обнулил `_room`/слушателя,
        // и мы их повторно не диспозим.
        await _roomListener?.dispose();
        _roomListener = null;
        final failed = _room;
        _room = null;
        _remoteVideoTrack = null;
        try {
          await failed?.dispose();
        } catch (disposeError, disposeStack) {
          logger.handle(disposeError, disposeStack);
        }
        // Исчерпали попытки или звонок уже свернули (отбой/hangup во время
        // подключения) — пробрасываем; вызывающий свернёт звонок как failed.
        if (attempt >= maxAttempts || !_hasActiveCall) rethrow;
        // Между попытками показываем «соединение» (на прошлой попытке могли
        // пометить active по ParticipantConnected) и сбрасываем состояние медиа
        // уже мёртвой комнаты.
        _emit(_snapshot.copyWith(status: CallStatus.connecting, remoteMicMuted: false, mediaEpoch: _snapshot.mediaEpoch + 1));
        await Future<void>.delayed(Duration(milliseconds: 400 * attempt));
      }
    }
    _connectingRoom = false;
    _roomConnected = true;
    _dbg('room connected');

    final room = _room!;
    await _publishLocalMedia(video: video);

    // Начальный маршрут аудио. Для аудиозвонка ожидается разговорный динамик
    // (earpiece), для видео — громкая связь (speaker), см. `speakerOn`. Маршрутом
    // на обеих платформах владеет LiveKit (`setSpeakerOutputPreferred`, см.
    // [toggleSpeaker]): на iOS в `externalCallSystem` он выставляет режим
    // (`videoChat`=динамик / `voiceChat`=разговорный) через движок, не активируя
    // сессию заново.
    try {
      await AudioManager.instance.setSpeakerOutputPreferred(_snapshot.speakerOn);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }

    // Собеседник мог войти в комнату раньше нас (мы принимаем звонок) — тогда
    // события ParticipantConnected/TrackSubscribed уже прошли; переводим в
    // active по факту присутствия участника.
    if (room.remoteParticipants.isNotEmpty) {
      _adoptRemoteTracks();
      _syncRemoteMic();
      _markActive();
    }
  }

  /// Принудительно инициализирует нативный WebRTC (создаёт
  /// `RTCPeerConnectionFactory` + audio device module). В flutter_webrtc фабрика
  /// создаётся только в нативном `initialize:`, который с Dart-стороны дёргается
  /// лишь при первом реальном использовании WebRTC (коннект комнаты / getUserMedia).
  /// AudioManager ходит к `peerConnectionFactory.audioDeviceModule` и кидает
  /// «audio device module is unavailable», если его зовут раньше — поэтому
  /// [_configureIosAudioForCall] и [setAudioEngineActive] дожидаются его первыми.
  ///
  /// `WebRTC.initialize` идемпотентен по флагу `initialized`, НО флаг выставляется
  /// только по завершении нативного `initialize:` (синхронный блокирующий вызов на
  /// главном потоке). Два конкурентных вызова (наш `_configureIosAudioForCall` +
  /// `setAudioEngineActive` по CallKit `didActivate`) успели бы оба увидеть флаг
  /// снятым. Мемоизируем сам Future: все конкурентные вызывающие ждут ОДИН нативный
  /// `initialize:`. No-op вне iOS.
  Future<void>? _webRtcInit;

  Future<void> _ensureWebRtcInitialized() {
    if (!Platform.isIOS) return Future<void>.value();
    return _webRtcInit ??= WebRTC.initialize();
  }

  /// iOS: настраивает режим аудио LiveKit под путь ответа на ТЕКУЩИЙ звонок.
  /// Вызывается на каждый коннект (режим — глобальный синглтон AudioManager,
  /// поэтому его надо выставлять под каждый звонок, а не один раз).
  ///
  ///  • [_viaCallKit] (cold-start по VoIP-push): `externalCallSystem` — LiveKit
  ///    ставит категорию `PlayAndRecord`, но НЕ активирует сессию сам; движок
  ///    держим выключенным (`AudioEngineAvailability.none`) и поднимаем в
  ///    [setAudioEngineActive] по событию CallKit `didActivate`. Активацией
  ///    владеет CallKit: нативный `AppDelegate` репортит входящий с
  ///    `configureAudioSession = true`, плагин на `CXAnswerCallAction` ставит
  ///    `PlayAndRecord`+`setActive(true)` → CallKit шлёт `provider(didActivate:)`
  ///    → `ACTION_CALL_TOGGLE_AUDIO_SESSION` → [setAudioEngineActive]. Так LiveKit
  ///    не активирует сессию сам — нет гонки `startCapture` на ещё не готовой
  ///    сессии (ошибка -4100), которая ловилась в `automatic` на cold-start.
  ///  • иначе (foreground-ответ по стриму / исходящий, без CallKit):
  ///    `automatic` — LiveKit сам ставит категорию, активирует сессию и рулит
  ///    движком по жизненному циклу комнаты (как на Android).
  ///
  /// `WebRTC.initialize` — идемпотентная прогрузка нативной фабрики, нужна до
  /// обращения к AudioManager (см. [_ensureWebRtcInitialized]). No-op вне iOS.
  Future<void> _configureIosAudioForCall() async {
    if (!Platform.isIOS) return;
    try {
      await _ensureWebRtcInitialized();
      // На iOS всегда отдаём AVAudioSession внешней call-системе — LiveKit сам её
      // НЕ активирует. Так избегаем гонки `startCapture` на ещё не активной сессии
      // в `automatic` (ошибка -4100), которая всплывает на повторных исходящих, и
      // не даём mute/unmute переконфигурировать сессию (рвал соединение).
      await AudioManager.instance.setAudioSessionManagementMode(AudioSessionManagementMode.externalCallSystem);
      if (_viaCallKit) {
        // Сессию активирует CallKit → гейтим движок до `didActivate`. Публикация
        // микрофона/подписка на удалённое аудио, сделанные пока движок выключен,
        // не теряются — LiveKit включит их, как только доступность разрешит.
        await AudioManager.instance.setEngineAvailability(AudioEngineAvailability.none);
      } else {
        // Нет CallKit (исходящий/foreground) → внешняя система активации — это мы.
        // Поднимаем сессию нативно ДО подключения/публикации, затем открываем
        // движок. Явная активация (вместо ленивой в automatic) убирает гонку -4100.
        await _setIosAudioSessionActive(true);
        _iosManualAudioSession = true;
        await AudioManager.instance.setEngineAvailability(AudioEngineAvailability.defaultAvailability);
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// iOS: активирует/деактивирует AVAudioSession нативно (см.
  /// ios/Runner/AppDelegate.swift) для звонка без CallKit. No-op вне iOS.
  Future<void> _setIosAudioSessionActive(bool active) async {
    if (!Platform.isIOS) return;
    await _callAudioChannel.invokeMethod<void>(active ? 'activateSession' : 'deactivateSession');
  }

  /// iOS: заполняет Now Playing (имя + аватар собеседника) через нативный
  /// MPNowPlayingInfoCenter, чтобы шапка системного пикера аудио-маршрутов
  /// (AVRoutePickerView) показывала имя вместо дефолтного «Нет аудио». Зовётся из
  /// [CallCubit] по мере разрешения имени/аватара. Очищается в [_teardown]
  /// ([_clearIosNowPlaying]). No-op вне iOS. См. ios/Runner/AppDelegate.swift.
  Future<void> setIosNowPlaying({required String title, String? subtitle, Uint8List? artwork}) async {
    if (!Platform.isIOS || title.isEmpty) return;
    try {
      await _callAudioChannel.invokeMethod<void>('setNowPlaying', {
        'title': title,
        if (subtitle != null && subtitle.isNotEmpty) 'subtitle': subtitle,
        'artwork': ?artwork,
      });
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// iOS: очищает Now Playing при завершении звонка — иначе метаданные (и имя в
  /// шапке пикера) висели бы между звонками. No-op вне iOS.
  Future<void> _clearIosNowPlaying() async {
    if (!Platform.isIOS) return;
    try {
      await _callAudioChannel.invokeMethod<void>('clearNowPlaying');
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Включает/выключает WebRTC-аудиодвижок LiveKit по событию CallKit
  /// ToggleAudioSession (`provider(didActivate:)`/`didDeactivate:`), которое
  /// прилетает из [CallPush]. Значимо только на CallKit-пути
  /// ([_viaCallKit] → `externalCallSystem`): там активацией сессии владеет
  /// CallKit, и движок LiveKit надо поднять ровно в окне между didActivate и
  /// didDeactivate. На пути без CallKit (исходящий/foreground) таких событий нет —
  /// сессию активируем сами, а доступность движка выставляем прямо в
  /// [_configureIosAudioForCall]; здесь вызов игнорируем (`!_viaCallKit`).
  Future<void> setAudioEngineActive(bool active) async {
    logger.info('call: ToggleAudioSession event received (isActive=$active)');
    if (!Platform.isIOS || !_viaCallKit) return;
    try {
      // CallKit `didActivate` на cold-start может обогнать создание фабрики в
      // `_connectRoom` → `_configureIosAudioForCall`. Обращаться к AudioManager
      // (он лезет в `peerConnectionFactory.audioDeviceModule`) до готовности
      // фабрики нельзя — это одна из веток гонки. Ждём тот же мемоизированный
      // init, что и путь коннекта.
      await _ensureWebRtcInitialized();
      await AudioManager.instance.setEngineAvailability(
        active ? AudioEngineAvailability.defaultAvailability : AudioEngineAvailability.none,
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
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
        // Подписались на аудиодорожку собеседника — считываем её начальное
        // mute-состояние. TrackMuted/Unmuted летят только ПОСЛЕ подписки (SDK
        // навешивает слушателя на трек в момент подписки), поэтому исходный мьют
        // ловим здесь, иначе индикатор не появится до первого переключения.
        _syncRemoteMic();
        _syncRemoteVideo();
        _markActive();
      })
      ..on<TrackUnsubscribedEvent>((event) {
        if (identical(event.track, _remoteVideoTrack)) {
          _remoteVideoTrack = null;
          _emit(_snapshot.copyWith(mediaEpoch: _snapshot.mediaEpoch + 1));
        }
        _syncRemoteVideo();
      })
      // Собеседник выключил/включил микрофон или камеру (или опубликовал дорожку
      // уже замьюченной) — отражаем состояние удалённых дорожек в снимке для
      // индикатора (аудио) и подмены рендера аватаром (видео). Свои (локальные)
      // события игнорируем — их ведут [toggleMic]/[toggleCamera].
      ..on<TrackMutedEvent>((event) {
        _syncRemoteMic();
        _syncRemoteVideo();
      })
      ..on<TrackUnmutedEvent>((event) {
        _syncRemoteMic();
        _syncRemoteVideo();
      })
      ..on<TrackPublishedEvent>((event) {
        _syncRemoteMic();
        _syncRemoteVideo();
      })
      ..on<TrackUnpublishedEvent>((event) => _syncRemoteVideo())
      ..on<ParticipantConnectionQualityUpdatedEvent>((event) {
        // Индикатор показывает качество собеседника — локального участника
        // игнорируем. Обновляем только для живого звонка.
        if (event.participant is LocalParticipant || !_hasActiveCall) return;
        final quality = _mapQuality(event.connectionQuality);
        if (quality == _snapshot.quality) return;
        _emit(_snapshot.copyWith(quality: quality));
      })
      ..on<ParticipantDisconnectedEvent>((event) {
        // Собеседник вышел из комнаты — для звонка 1-на-1 это конец разговора.
        _dbg('peer left');
        _teardown(CallEndReason.hangup);
      })
      ..on<RoomDisconnectedEvent>((event) {
        _diag2('RoomDisconnected reason=${event.reason} _roomConnected=$_roomConnected status=${_snapshot.status}');
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

  // Пересчитывает mute-состояние микрофона собеседника по текущим аудиодорожкам
  // удалённых участников и переиздаёт снимок, если оно изменилось. Считаем
  // микрофон выключенным, когда аудиодорожки ещё нет (участник не опубликовал) —
  // индикатор появится/исчезнет по факту публикации. Для звонка 1-на-1 берём
  // первого удалённого участника. Вызывается из событий комнаты и при late-join.
  void _syncRemoteMic() {
    final room = _room;
    if (room == null) return;
    final participant = room.remoteParticipants.values.firstOrNull;
    // `isMuted` читает метаданные публикации (обновляются с сервера всегда, даже
    // до подписки на дорожку) и трактует отсутствие аудио как «выключен».
    final muted = participant?.isMuted ?? true;
    logger.info('call: remote mic muted=$muted (participants=${room.remoteParticipants.length})');
    if (muted == _snapshot.remoteMicMuted) return;
    _emit(_snapshot.copyWith(remoteMicMuted: muted));
  }

  // Пересчитывает состояние камеры собеседника по его видеопубликации и
  // переиздаёт снимок, если оно изменилось. При выключении камеры LiveKit мьютит
  // дорожку (не отписывает), поэтому ориентируемся на `muted` публикации камеры;
  // нет публикации камеры — считаем выключенной. Без этого удалённый видел бы
  // застывший последний кадр (см. [CallSnapshot.remoteVideoOff]).
  void _syncRemoteVideo() {
    final room = _room;
    if (room == null) return;
    final participant = room.remoteParticipants.values.firstOrNull;
    var off = true;
    if (participant != null) {
      for (final publication in participant.videoTrackPublications) {
        if (publication.source == TrackSource.camera) {
          off = publication.muted;
          break;
        }
      }
    }
    if (off == _snapshot.remoteVideoOff) return;
    logger.info('call: remote video off=$off');
    _emit(_snapshot.copyWith(remoteVideoOff: off));
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

  // Запускает гудки исходящего (зациклённый ringback). Идемпотентно: повторный
  // вызов не создаёт второй проигрыватель. Ошибки проигрывания глушим — гудки
  // косметика, звонок из-за них падать не должен.
  Future<void> _startRingback() async {
    try {
      final player = _ringback ??= AudioPlayer();
      await player.setAudioContext(_ringbackAudioContext);
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(0.6);
      await player.play(AssetSource('audio/ringback.wav'));
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  // Глушит гудки. Проигрыватель не диспозим (переиспользуем на следующий звонок);
  // финальный dispose — в [dispose].
  Future<void> _stopRingback() async {
    final player = _ringback;
    if (player == null) return;
    try {
      await player.stop();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  // Заводит таймер отмены исходящего недозвона (см. [_ringTimer]). По истечении —
  // если абонент так и не подключился (звонок ещё в статусе outgoing именно с
  // этим callId) — вешаем трубку сами. `hangup` шлёт `CALL_HANGUP` (сервер снимет
  // баннер у абонента) и делает `_teardown`. Привязка к callId защищает от гонки:
  // если пока таймер тикал начался другой звонок, старый таймер его не тронет
  // (хотя [_cancelRingTimeout] в [_teardown] и так снимает предыдущий).
  void _startRingTimeout(String callId) {
    _cancelRingTimeout();
    _ringTimer = Timer(Duration(seconds: settings.callRingTimeoutSeconds), () {
      if (_snapshot.status == CallStatus.outgoing && _snapshot.callId == callId) {
        _dbg('ring timeout — cancelling unanswered call');
        unawaited(hangup());
      }
    });
  }

  void _cancelRingTimeout() {
    _ringTimer?.cancel();
    _ringTimer = null;
  }

  // Заводит бэкстоп-таймер входящего (см. [_incomingTimer]). По истечении — если
  // звонок всё ещё «звонит» (статус incoming именно с этим callId, т.е. не приняли
  // и не отменили) — локально сворачиваем: `ended` → [CallPush] снимет баннер.
  void _startIncomingTimeout(String callId) {
    _cancelIncomingTimeout();
    _incomingTimer = Timer(_incomingTimeout, () {
      if (_snapshot.status == CallStatus.incoming && _snapshot.callId == callId) {
        _dbg('incoming timeout — dismissing unanswered call');
        unawaited(_teardown(CallEndReason.none));
      }
    });
  }

  void _cancelIncomingTimeout() {
    _incomingTimer?.cancel();
    _incomingTimer = null;
  }

  // Заводит сторож перехода `connecting` → `active` (см. [_connectTimer]). По
  // истечении — если звонок всё ещё «соединяется» именно с этим callId (собеседник
  // не вошёл в комнату и отмена не пришла) — принудительно сворачиваем как failed,
  // возвращая машину звонков в idle.
  void _startConnectTimeout(String callId) {
    _cancelConnectTimeout();
    _connectTimer = Timer(_incomingTimeout, () {
      if (_hasActiveCall && _snapshot.status == CallStatus.connecting && _snapshot.callId == callId) {
        _dbg('connect timeout — peer never joined, tearing down');
        unawaited(_teardown(CallEndReason.failed));
      }
    });
  }

  void _cancelConnectTimeout() {
    _connectTimer?.cancel();
    _connectTimer = null;
  }

  // Переводит звонок в active, если он ещё жив и не завершён.
  void _markActive() {
    if (!_hasActiveCall) return;
    if (_snapshot.status == CallStatus.active) return;
    // Абонент ответил — гудки и таймеры дозвона/соединения больше не нужны.
    unawaited(_stopRingback());
    _cancelRingTimeout();
    _cancelConnectTimeout();
    // Ставим точку отсчёта таймера разговора ровно на переход в active.
    _emit(_snapshot.copyWith(status: CallStatus.active, connectedAt: DateTime.now()));
    _dbg('active');
  }

  /// Маппит LiveKit [ConnectionQuality] в [CallQuality] для индикатора.
  /// `lost` трактуем как `poor` (соединение есть, но плохое).
  static CallQuality _mapQuality(ConnectionQuality quality) {
    switch (quality) {
      case ConnectionQuality.excellent:
        return CallQuality.excellent;
      case ConnectionQuality.good:
        return CallQuality.good;
      case ConnectionQuality.poor:
      case ConnectionQuality.lost:
        return CallQuality.poor;
      case ConnectionQuality.unknown:
        return CallQuality.unknown;
    }
  }

  Future<void> _teardown(CallEndReason reason) async {
    // Повторный вход (в т.ч. из события LiveKit, которое породил наш же
    // `room.disconnect()` ниже) — выходим, чтобы не запустить второй
    // конкурентный `pc.close()` (см. [_tearingDown]).
    if (_tearingDown) return;
    _tearingDown = true;

    final remote = _snapshot.remoteUserID;
    final video = _snapshot.video;
    final callId = _snapshot.callId;
    // Данные для журнала звонков фиксируем ДО разбора: направление и момент
    // соединения (по нему считаем длительность и «отвечен ли звонок»).
    final direction = _logDirection;
    final connectedAt = _snapshot.connectedAt;

    // Разбор комнаты может бросить/зависнуть (гонка реконнекта SDK и `pc.close()`,
    // upstream livekit #1186). Что бы ни упало внутри — в `finally` мы ОБЯЗАНЫ
    // эмитнуть `ended`, назначить сброс в `idle` и снять `_tearingDown`. Иначе
    // снимок застревал бы в не-`idle` статусе, `_hasActiveCall` оставался бы
    // `true`, и клиент авто-отклонял бы (`_onRing` → «занято») все входящие до
    // перезапуска приложения — «зомби-звонок».
    try {
      // Гасим гудки исходящего (если играли) и снимаем таймеры дозвона/входящего —
      // звонок завершается/переходит дальше.
      unawaited(_stopRingback());
      _cancelRingTimeout();
      _cancelIncomingTimeout();
      _cancelConnectTimeout();

      _pushAcceptedCallId = null;
      _handlingCallId = null;
      _connectingRoom = false;
      _roomConnected = false;
      _viaCallKit = false;
      // Звонок завершён — отпускаем удержание стрима (вернётся к foreground-гейту).
      api.setCallActive(false);

      _localVideoTrack = null;
      _remoteVideoTrack = null;

      // Забираем комнату синхронно (до await), чтобы повторный вход видел null.
      final room = _room;
      _room = null;

      if (room != null) {
        // `disconnect()` — ПЕРВЫМ действием разбора, до диспоза слушателя и всего
        // прочего. Внутри `engine.disconnect()` сразу ставит `_isClosed = true`, а
        // авто-реконнект SDK стартует только при `!_isClosed` (engine.dart). Если
        // собеседник вышел, SFU может прислать LeaveRequest RECONNECT → движок лезет
        // пересоздавать ICE-транспорты параллельно нашему teardown → две гонки
        // `pc.close()` и падение на ICE-потоке (upstream livekit #1186). Ранний
        // `_isClosed` подавляет этот реконнект — окно гонки сужается до минимума.
        // Полностью баг лечится только в SDK (#1186), см. память проекта.
        try {
          await room.disconnect();
        } catch (error, stackTrace) {
          logger.handle(error, stackTrace);
        }
      }

      try {
        await _roomListener?.dispose();
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
      _roomListener = null;

      if (room != null) {
        try {
          await room.dispose();
        } catch (error, stackTrace) {
          logger.handle(error, stackTrace);
        }
      }

      // iOS без CallKit: сессию активировали мы — деактивируем нативно после того,
      // как движок остановлен (room disconnected/disposed). Иначе активная сессия
      // осталась бы висеть между звонками. На CallKit-пути деактивацией владеет
      // CallKit (`didDeactivate`), сами не трогаем.
      if (_iosManualAudioSession) {
        _iosManualAudioSession = false;
        try {
          await _setIosAudioSessionActive(false);
        } catch (error, stackTrace) {
          logger.handle(error, stackTrace);
        }
      }

      // iOS: снимаем Now Playing (имя/аватар в шапке пикера маршрутов) —
      // независимо от CallKit-пути, т.к. метаданные ставятся на экране звонка.
      await _clearIosNowPlaying();
    } finally {
      _diag = _diag.isEmpty ? 'ended:${reason.name}' : '$_diag · ended:${reason.name}';
      _emit(CallSnapshot(status: CallStatus.ended, callId: callId, remoteUserID: remote, video: video, endReason: reason, debug: _diag));

      // Пишем строку журнала звонков (сервер историю не хранит). Только для
      // реального звонка: направление известно (взведено в startCall/_onRing/
      // acceptFromPush) и есть собеседник. `_logDirection` сбрасываем, чтобы
      // повторный разбор без активного звонка (dispose) не записал фантом.
      if (direction != null && remote.isNotEmpty && callId.isNotEmpty) {
        final answered = connectedAt != null;
        final durationSeconds = answered ? DateTime.now().difference(connectedAt).inSeconds : 0;
        // Пропущенный — входящий, на который не ответили и который сами не
        // отклонили (отклонённый показываем как обычный входящий, не красным).
        final missed = direction == models.CallDirection.incoming && !answered && reason != CallEndReason.rejected;
        unawaited(
          _recordCallLog(
            callId: callId,
            remoteUserID: remote,
            video: video,
            direction: direction,
            missed: missed,
            durationSeconds: durationSeconds < 0 ? 0 : durationSeconds,
          ),
        );
      }
      _logDirection = null;

      // `ended` — переходное состояние (краткая обратная связь на нашем экране).
      // Сбрасываем его в idle через паузу, иначе снимок «завис» бы на «завершён»
      // до следующего звонка: когда звонок прошёл целиком на локскрине/в фоне
      // (CallKit), кадры не рендерятся и pop экрана в [CallGate] мог не отработать —
      // при возврате в приложение висел бы экран «Звонок завершён». Сброс отменяет
      // сам себя, если уже стартовал новый звонок (проверка по callId).
      _scheduleIdleReset(callId);

      // Комната разобрана — повторный `pc.close()` уже невозможен; снимаем флаг,
      // чтобы следующий звонок мог завершиться.
      _tearingDown = false;
    }
  }

  /// Пишет строку журнала звонков и уведомляет подписчиков ([callLogged]). Имя
  /// собеседника берём снимком из кэша профиля (может быть пусто — тогда UI
  /// покажет «Неизвестный»); аватар в списке подтягивается «вживую» по userID.
  /// Best-effort: ошибки логируем, но звонок из-за журнала падать не должен.
  Future<void> _recordCallLog({
    required String callId,
    required List<int> remoteUserID,
    required bool video,
    required models.CallDirection direction,
    required bool missed,
    required int durationSeconds,
  }) async {
    try {
      final repositories = getIt.get<Repositories>();
      var displayName = '';
      try {
        final profile = await repositories.profiles.getByUserID(userID: remoteUserID);
        final phone = utils.phoneNormalization(phoneNumber: profile.phoneNumber);
        displayName = utils.composeDisplayName(
          firstName: profile.fistName,
          lastName: profile.lastName,
          phoneNumber: phone.international,
          username: profile.username,
        );
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }

      await repositories.callLogs.insert(
        models.CallLog(
          callID: callId,
          userID: Uint8List.fromList(remoteUserID),
          displayName: displayName,
          direction: direction,
          video: video,
          missed: missed,
          durationSeconds: durationSeconds,
          createdAt: DateTime.now(),
        ),
      );

      if (!_callLoggedController.isClosed) _callLoggedController.add(null);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Сбрасывает снимок в [CallStatus.idle] через паузу после завершения звонка,
  /// если к тому моменту всё ещё показан тот же завершённый звонок ([callId]).
  void _scheduleIdleReset(String callId) {
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (_snapshotController.isClosed) return;
      if (_snapshot.status == CallStatus.ended && _snapshot.callId == callId) {
        _emit(const CallSnapshot());
      }
    });
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

  /// Инициирующий CALL_RING (unary) — возвращает статус вызова, чтобы поймать
  /// серверный гейт (PermissionDenied). В отличие от [_sendRing] (стрим,
  /// fire-and-forget для RING/HANGUP/REJECT), здесь важен ответ сервера.
  Future<APICallStatus> _sendRingInitiating({required List<int> toUserID, required String callId, required bool video}) async {
    final ring = CallRing(callId: callId, toUserID: Uint8List.fromList(toUserID), video: video);
    // fromUserID проставит сервер из сессии — здесь не заполняем.
    return api.unaryEncoded(MessageType.CALL_RING, ring.writeToBuffer());
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
    await _ringback?.dispose();
    _ringback = null;
    await _snapshotController.close();
    await _focusController.close();
    await _incomingRingController.close();
    await _callLoggedController.close();
  }
}
