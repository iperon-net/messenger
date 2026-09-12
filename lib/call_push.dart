import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'auth.dart';
import 'calls.dart';
import 'di.dart';
import 'firebase_options.dart';
import 'logger.dart';
import 'push.dart';
import 'repositories.dart';
import 'utils.dart';

// Ключи полезной нагрузки call-пуша. Должны совпадать с сервером —
// internal/services/push.go (map data в SendCallPush).
const _kCallId = 'callId';
const _kFromUserID = 'fromUserID';
const _kVideo = 'video';
const _kAction = 'action';
// Имя звонящего для показа в системной звонилке (CallKit/ConnectionService).
// Сервер кладёт его из профиля звонящего (имя/фамилия, иначе телефон); см.
// internal/services/push.go. Пусто/нет ключа — показываем 'Iperon'.
const _kNameCaller = 'nameCaller';
const _kActionIncoming = 'incoming';
const _kActionCancel = 'cancel';

// Канал к MainActivity (Android): показ Flutter-экрана звонка поверх экрана
// блокировки. См. android/.../MainActivity.kt.
const _callWindowChannel = MethodChannel('net.iperon.messenger/call_window');

/// Обработчик FCM-сообщений в фоновом/выгруженном состоянии (Android). Работает в
/// отдельном isolate «с нуля», поэтому не трогает DI/`Calls` — только показывает
/// нативный экран входящего (CallKit/ConnectionService) или снимает его. Когда
/// пользователь примет звонок, приложение поднимется в foreground, откроется
/// стрим и `Calls` поймает ретранслируемый offer (см. [CallPush]).
///
/// Должен быть top-level и помечен `@pragma('vm:entry-point')`, иначе tree-shake
/// выкинет его из release-сборки.
@pragma('vm:entry-point')
Future<void> callPushBackgroundHandler(RemoteMessage message) async {
  // В фоновом isolate Firebase не инициализирован — поднимаем его перед работой
  // с плагинами (идемпотентно, повторный вызов безопасен).
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {
    // Уже инициализирован — игнорируем.
  }
  await _handleCallData(message.data);
}

/// Показывает нативный входящий по данным push либо снимает его (action=cancel).
Future<void> _handleCallData(Map<String, dynamic> data) async {
  final action = data[_kAction];
  final callId = (data[_kCallId] ?? '').toString();
  if (callId.isEmpty) return;

  if (action == _kActionCancel) {
    await FlutterCallkitIncoming.endCall(callId);
    return;
  }

  if (action == _kActionIncoming) {
    await FlutterCallkitIncoming.showCallkitIncoming(_incomingParams(data, callId));
  }
}

CallKitParams _incomingParams(Map<String, dynamic> data, String callId) {
  final isVideo = (data[_kVideo] ?? '').toString() == 'true';
  final fromUserID = (data[_kFromUserID] ?? '').toString();
  final nameCaller = (data[_kNameCaller] ?? '').toString();

  return CallKitParams(
    id: callId,
    // Имя звонящего из push (профиль/телефон); пусто — фолбэк на 'Iperon'.
    nameCaller: nameCaller.isNotEmpty ? nameCaller : 'Iperon',
    appName: 'Iperon',
    // handle = userID звонящего (hex): по нему система «Недавних» умеет
    // перезвонить (INStartCallIntent → CallPush._onEvent callback). Само имя
    // показывает nameCaller, handle в баннере не выводится (handleType generic).
    handle: fromUserID.isNotEmpty ? fromUserID : (isVideo ? 'Видеозвонок' : 'Аудиозвонок'),
    type: isVideo ? 1 : 0,
    // extra доедет до события accept/decline — оттуда берём собеседника и тип.
    extra: {_kFromUserID: fromUserID, _kVideo: isVideo},
    android: const AndroidParams(
      isCustomNotification: true,
      isShowFullLockedScreen: true,
      isImportant: true,
      incomingCallNotificationChannelName: 'Входящие звонки',
      missedCallNotificationChannelName: 'Пропущенные звонки',
    ),
    // ВНИМАНИЕ: на iOS этот путь (Dart-репорт входящего) НЕ используется —
    // cold-start-входящий репортит натив из VoIP-push (ios/Runner/AppDelegate.swift
    // `pushRegistry didReceiveIncomingPush`), а foreground показывает свой in-app
    // экран. Флаг `configureAudioSession` для CallKit-аудио задаётся ТАМ
    // (`data.configureAudioSession = true`), не здесь. Значение ниже влияет только
    // на платформы/пути, где showCallkitIncoming зовётся из Dart (Android).
    ios: const IOSParams(handleType: 'generic', supportsVideo: true, configureAudioSession: true),
  );
}

/// Параметры для регистрации ИСХОДЯЩЕГО звонка в CallKit (iOS). Нужно, чтобы
/// аудиосессией управляла единая call-система и прилетел provider(didActivate:).
/// [nameCaller] — имя абонента (резолвим локально из профиля, см.
/// [_resolveDisplayName]); попадает в системные «Недавние». [handle] — userID
/// абонента (hex) для перезвона из «Недавних».
CallKitParams _outgoingParams(CallSnapshot snapshot, String nameCaller, String handle) {
  return CallKitParams(
    id: snapshot.callId,
    nameCaller: nameCaller.isNotEmpty ? nameCaller : 'Iperon',
    appName: 'Iperon',
    handle: handle.isNotEmpty ? handle : (snapshot.video ? 'Видеозвонок' : 'Аудиозвонок'),
    type: snapshot.video ? 1 : 0,
    ios: const IOSParams(handleType: 'generic', supportsVideo: true, configureAudioSession: false),
  );
}

/// Мост между call-пушами / нативным экраном звонка (CallKit/ConnectionService)
/// и сервисом [Calls] в основном isolate. Регистрируется в `get_it` (см.
/// `di.dart`, `dependsOn: [Calls]`) и стартует один раз через [start].
///
/// - **foreground**: входящий приходит по открытому стриму — `Calls` сам покажет
///   in-app экран, push игнорируем (иначе двойной звонок).
/// - **фон/killed (Android)**: [callPushBackgroundHandler] показывает нативный
///   входящий; действия пользователя прилетают в [_onEvent] и переводятся в
///   `Calls.acceptFromPush`/`rejectFromPush`.
/// - **iOS**: аналогичные события даёт CallKit поверх VoIP-пуша (фаза 4, native).
class CallPush {
  final logger = getIt.get<Logger>();
  final calls = getIt.get<Calls>();
  final utils = getIt.get<Utils>();
  final pushManager = getIt.get<PushManager>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  StreamSubscription<CallEvent?>? _eventSub;
  StreamSubscription<CallSnapshot>? _callSub;

  // callId исходящего, уже отрепорченного в CallKit (iOS), чтобы не регистрировать
  // его повторно на каждый снимок со статусом outgoing.
  String? _reportedOutgoingCallId;

  // Последнее переданное в MainActivity значение флага «поверх локскрина»
  // (Android) — чтобы не дёргать канал на каждый снимок.
  bool? _overLockscreen;

  // callId, для которого мы уже обработали событие «принял». Плагин
  // flutter_callkit_incoming шлёт accept ДВАЖДЫ (действие
  // CallkitNotificationService + broadcast из TransparentActivity), и оба
  // прилетают в [_onEvent]. Без дедупа получаются два входа в комнату LiveKit с
  // одинаковой identity → сервер выбивает участника (DUPLICATE_IDENTITY),
  // соединение рушится и звук не идёт. Ставим синхронно, до любого await, чтобы
  // второй event гарантированно отсёкся. Сбрасываем по decline/ended.
  String? _acceptedCallId;

  /// Инициализирует обработчики. Идемпотентно.
  void start() {
    if (Platform.isAndroid) {
      // Натив зовёт focusCall при тапе по ongoing-нотификации звонка — просим
      // CallGate снова открыть экран текущего звонка. Метод в обратную сторону
      // (allowOverLockscreen) обрабатывает MainActivity.
      _callWindowChannel.setMethodCallHandler((call) async {
        if (call.method == 'focusCall') calls.requestFocus();
        return null;
      });
    }

    // Android 13+: без разрешения на уведомления входящий звонок не показать.
    // Запрашиваем НЕ на старте (иначе диалог всплывает ещё на экране авторизации,
    // до логина), а только когда пользователь уже авторизован: сразу здесь, если
    // сессия уже есть при запуске, и в _onAuthChanged — после успешного логина.
    if (auth.isAuthorized) _requestNotificationPermission();

    // iOS: VoIP-токен уже мог быть выдан PushKit до подписки на события —
    // забираем его из плагина и регистрируем сразу. Дальнейшие смены токена
    // прилетят событием actionDidUpdateDevicePushTokenVoip (см. _onEvent).
    if (Platform.isIOS) {
      unawaited(_syncVoipToken());
    }

    FirebaseMessaging.onBackgroundMessage(callPushBackgroundHandler);

    // foreground: входящий уже придёт по стриму (Calls), нативный экран из push
    // не показываем — во избежание двойного звонка. Оставляем только cancel,
    // чтобы снять возможный подвисший нативный экран.
    FirebaseMessaging.onMessage.listen((message) {
      if (message.data[_kAction] == _kActionCancel) {
        final callId = (message.data[_kCallId] ?? '').toString();
        if (callId.isNotEmpty) unawaited(FlutterCallkitIncoming.endCall(callId));
      }
    });

    _eventSub ??= FlutterCallkitIncoming.onEvent.listen(_onEvent);

    // Холодный старт из killed-state (Android): пользователь принял звонок из
    // нативного экрана, MainActivity подняла приложение с нуля — но событие
    // ACTION_CALL_ACCEPT плагин эмитит в onEvent ДО того, как мы успели на него
    // подписаться (DI ещё грузился), а onEvent — broadcast-стрим и теряет
    // события без слушателя. Итог: acceptFromPush не вызывался, в комнату
    // LiveKit не входили. Плагин хранит принятый звонок в ACTIVE_CALLS
    // (isAccepted=true) — переигрываем accept по нему. Дедуп [_acceptedCallId]
    // (и [Calls._handlingCallId]) не даёт двойного входа, если живое событие всё
    // же придёт следом.
    if (Platform.isAndroid) unawaited(_resumeAcceptedCallFromColdStart());

    // Мост Calls → CallKit по снимкам:
    // - outgoing (iOS): регистрируем исходящий в CallKit, чтобы аудиосессией
    //   владела единая call-система. Иначе для исходящего не прилетит
    //   provider(didActivate:) → аудиодвижок LiveKit не включится → нет звука.
    // - ended/idle: снимаем нативный экран, если он ещё висит (например, приняли
    //   из push, но звонок сорвался).
    _callSub ??= calls.snapshots.listen((snapshot) {
      // Android: пока звонок активен, разрешаем экрану звонка показываться
      // поверх экрана блокировки (иначе ответ с локскрина требует разблокировки).
      // Снимаем флаг по завершении, чтобы весь мессенджер не оставался виден
      // поверх блокировки.
      _setOverLockscreen(switch (snapshot.status) {
        CallStatus.idle || CallStatus.ended => false,
        _ => true,
      });

      switch (snapshot.status) {
        case CallStatus.outgoing:
          if (Platform.isIOS && snapshot.callId.isNotEmpty && _reportedOutgoingCallId != snapshot.callId) {
            _reportedOutgoingCallId = snapshot.callId;
            unawaited(_reportOutgoing(snapshot));
          }
        case CallStatus.ended:
        case CallStatus.idle:
          _reportedOutgoingCallId = null;
          if (snapshot.callId.isNotEmpty) unawaited(FlutterCallkitIncoming.endCall(snapshot.callId));
        default:
          break;
      }
    });

    // Регистрация push-токенов на старте (main.dart / выше) гейтится на
    // авторизацию: на свежей установке в этот момент сессии ещё нет, поэтому
    // токен не уходит на сервер, и после логина в том же запуске повторно не
    // отправляется — сервер не может разбудить входящий, пока приложение не
    // перезапустят уже залогиненным. Реагируем на смену состояния Auth
    // (ChangeNotifier) и досылаем токен, как только пользователь авторизовался.
    // Идемпотентно: PushManager дедуплицирует уже отправленный токен.
    auth.addListener(_onAuthChanged);
  }

  /// При переходе в авторизованное состояние досылает push-токен текущего
  /// канала (FCM на Android, VoIP на iOS). Разлогин игнорируем.
  void _onAuthChanged() {
    if (!auth.isAuthorized) return;
    unawaited(_syncTokens());
    // Разрешение на уведомления просим здесь (после логина), а не на старте — см.
    // start(). Идемпотентно: система покажет диалог лишь при первом запросе.
    _requestNotificationPermission();
  }

  /// Android 13+: разрешение POST_NOTIFICATIONS нужно, чтобы показать входящий
  /// звонок (нотификацию). На iOS no-op (CallKit не требует разрешения на
  /// уведомления). Идемпотентно.
  void _requestNotificationPermission() {
    if (!Platform.isAndroid) return;
    unawaited(
      FlutterCallkitIncoming.requestNotificationPermission({
        'rationaleMessagePermission': 'Разрешение нужно, чтобы показывать входящие звонки.',
        'postNotificationMessageRequired': 'Разрешите уведомления в настройках, чтобы видеть входящие звонки.',
      }),
    );
  }

  Future<void> _syncTokens() async {
    if (Platform.isAndroid) {
      await pushManager.syncFcmToken();
    } else if (Platform.isIOS) {
      await _syncVoipToken();
    }
  }

  /// Регистрирует исходящий звонок в CallKit (iOS), предварительно разрешив имя
  /// абонента локально (профиль → телефон), чтобы в системной звонилке и
  /// «Недавних» стояло имя, а не 'Iperon'.
  Future<void> _reportOutgoing(CallSnapshot snapshot) async {
    final name = await _resolveDisplayName(snapshot.remoteUserID);
    final handle = utils.bytesToHex(Uint8List.fromList(snapshot.remoteUserID));
    // Пока имя резолвилось, звонок мог завершиться/смениться — не регистрируем
    // устаревший.
    if (_reportedOutgoingCallId != snapshot.callId) return;
    await FlutterCallkitIncoming.startCall(_outgoingParams(snapshot, name, handle));
  }

  /// Стартует исходящий по перезвону из системного списка «Недавние». [id] —
  /// userID абонента (hex, 24 символа), который мы кладём в handle звонка. Пустой
  /// / невалидный id игнорируем. Звоним аудио; видео пользователь включит на
  /// экране звонка.
  Future<void> _startCallbackCall(String id) async {
    if (id.length != 24 || !RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(id)) {
      logger.warning('call: callback with non-userID handle "$id" — ignored');
      return;
    }
    await calls.startCall(toUserID: utils.hexToBytes(id), video: false);
  }

  /// Отображаемое имя абонента по [userID] из локального кэша профилей
  /// (имя/фамилия → телефон → username). Пусто, если профиля в кэше ещё нет —
  /// тогда вызывающий покажет фолбэк 'Iperon'. Без сети: имя для системной
  /// звонилки должно резолвиться мгновенно.
  Future<String> _resolveDisplayName(List<int> userID) async {
    if (userID.isEmpty) return '';
    try {
      final profile = await repositories.profiles.getByUserID(userID: userID);
      final phone = utils.phoneNormalization(phoneNumber: profile.phoneNumber).international;
      return utils.composeDisplayName(
        firstName: profile.fistName,
        lastName: profile.lastName,
        phoneNumber: phone.isNotEmpty ? phone : profile.phoneNumber,
        username: profile.username,
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return '';
    }
  }

  Future<void> _onEvent(CallEvent? event) async {
    if (event == null) return;

    // v3: CallEvent — sealed class; данные звонка приходят в event.callKitParams
    // (id + extra), а не в бывшем event.body. VoIP-токен из события больше не
    // достать — при его обновлении перечитываем через getDevicePushTokenVoIP().
    switch (event) {
      case CallEventActionCallAccept(:final callKitParams):
        final callId = callKitParams.id;
        if (callId.isNotEmpty) {
          // Дедуп повторного accept того же звонка (плагин шлёт его дважды) —
          // синхронно, ДО любого await, иначе два входа в комнату LiveKit дают
          // DUPLICATE_IDENTITY и звонок падает без звука (см. [_acceptedCallId]).
          if (_acceptedCallId == callId) {
            logger.warning('accept event ignored: duplicate for $callId');
            break;
          }
          _acceptedCallId = callId;

          // extra донесли из показа входящего (см. _incomingParams / iOS
          // AppDelegate) — по ним поднимаем звонок, не дожидаясь CALL_RING по
          // стриму (сервер его не переигрывает после пробуждения из push).
          final fromUserIDHex = (callKitParams.extra?[_kFromUserID] ?? '').toString();
          final fromUserID = fromUserIDHex.isEmpty ? <int>[] : utils.hexToBytes(fromUserIDHex);
          final video = callKitParams.extra?[_kVideo] == true || (callKitParams.extra?[_kVideo] ?? '').toString() == 'true';
          await calls.acceptFromPush(callId, fromUserID: fromUserID, video: video);
        }
      case CallEventActionCallDecline(:final callKitParams):
        final callId = callKitParams.id;
        if (callId.isNotEmpty) {
          if (_acceptedCallId == callId) _acceptedCallId = null;
          final fromUserIDHex = (callKitParams.extra?[_kFromUserID] ?? '').toString();
          final fromUserID = fromUserIDHex.isEmpty ? <int>[] : utils.hexToBytes(fromUserIDHex);
          await calls.rejectFromPush(callId, fromUserID);
        }
      case CallEventActionCallToggleAudioSession(:final isActive):
        // iOS CallKit активировал/деактивировал аудиосессию (provider
        // didActivate/didDeactivate) — синхронно открываем/закрываем
        // WebRTC-аудиодвижок LiveKit (см. Calls.setAudioEngineActive).
        logger.info('call: ToggleAudioSession event received (isActive=$isActive)');
        await calls.setAudioEngineActive(isActive);
      case CallEventActionCallEnded():
        _acceptedCallId = null;
        await calls.hangup();
      case CallEventActionCallCallback(:final id):
        // Пользователь перезванивает из системного списка «Недавние» (iOS
        // INStartCallIntent → AppDelegate.continue userActivity →
        // sendCallbackEvent; Android — действие «Перезвонить» на пропущенном).
        // В [id] лежит userID абонента (hex) из handle прошлого звонка —
        // открываем нашу звонилку и звоним. Тип аудио (видео можно поднять уже
        // на экране звонка).
        await _startCallbackCall(id);
      case CallEventActionDidUpdateDevicePushTokenVoip():
        // iOS выдал/сменил VoIP-токен PushKit — событие не несёт сам токен,
        // забираем актуальный из плагина и регистрируем на сервере.
        await _syncVoipToken();
      default:
        break;
    }
  }

  /// Переигрывает accept, потерянный на холодном старте (см. [start]). Читает
  /// принятый звонок из ACTIVE_CALLS плагина (`isAccepted == true`) и поднимает
  /// его тем же путём, что и живое событие accept.
  Future<void> _resumeAcceptedCallFromColdStart() async {
    try {
      final active = await FlutterCallkitIncoming.activeCallsRaw();
      for (final data in active) {
        final accepted = data['isAccepted'] == true || (data['isAccepted'] ?? '').toString() == 'true';
        final callId = (data['id'] ?? '').toString();
        if (!accepted || callId.isEmpty) continue;

        // Тот же синхронный дедуп, что и в [_onEvent]: если живое событие всё же
        // придёт, оно отсечётся по [_acceptedCallId].
        if (_acceptedCallId == callId) continue;
        _acceptedCallId = callId;

        final extra = data['extra'];
        final fromUserIDHex = (extra is Map ? (extra[_kFromUserID] ?? '') : '').toString();
        final fromUserID = fromUserIDHex.isEmpty ? <int>[] : utils.hexToBytes(fromUserIDHex);
        final video = extra is Map && (extra[_kVideo] == true || (extra[_kVideo] ?? '').toString() == 'true');
        await calls.acceptFromPush(callId, fromUserID: fromUserID, video: video);
        return;
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Android: разрешает/запрещает показ экрана звонка поверх экрана блокировки.
  /// На iOS no-op (там локскрин ведёт CallKit).
  void _setOverLockscreen(bool allow) {
    if (!Platform.isAndroid || _overLockscreen == allow) return;
    _overLockscreen = allow;
    unawaited(() async {
      try {
        await _callWindowChannel.invokeMethod<void>('allowOverLockscreen', allow);
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }());
  }

  /// Забирает уже выданный VoIP-токен из плагина (iOS) и регистрирует его.
  Future<void> _syncVoipToken() async {
    try {
      final token = (await FlutterCallkitIncoming.getDevicePushTokenVoIP())?.toString() ?? '';
      if (token.isNotEmpty) await pushManager.registerVoipToken(token);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  Future<void> dispose() async {
    auth.removeListener(_onAuthChanged);
    await _eventSub?.cancel();
    _eventSub = null;
    await _callSub?.cancel();
    _callSub = null;
  }
}
