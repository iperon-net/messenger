import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'auth.dart';
import 'calls.dart';
import 'di.dart';
import 'firebase_options.dart';
import 'logger.dart';
import 'push.dart';
import 'utils.dart';

// Ключи полезной нагрузки call-пуша. Должны совпадать с сервером —
// internal/services/push.go (map data в SendCallPush).
const _kCallId = 'callId';
const _kFromUserID = 'fromUserID';
const _kVideo = 'video';
const _kAction = 'action';
const _kActionIncoming = 'incoming';
const _kActionCancel = 'cancel';

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

  return CallKitParams(
    id: callId,
    nameCaller: 'Iperon',
    appName: 'Iperon',
    handle: isVideo ? 'Видеозвонок' : 'Аудиозвонок',
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
    ios: const IOSParams(handleType: 'generic', supportsVideo: true),
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

  StreamSubscription<CallEvent?>? _eventSub;
  StreamSubscription<CallSnapshot>? _callSub;

  /// Инициализирует обработчики. Идемпотентно.
  void start() {
    // Android 13+: без разрешения на уведомления входящий звонок не показать.
    if (Platform.isAndroid) {
      unawaited(
        FlutterCallkitIncoming.requestNotificationPermission({
          'rationaleMessagePermission': 'Разрешение нужно, чтобы показывать входящие звонки.',
          'postNotificationMessageRequired': 'Разрешите уведомления в настройках, чтобы видеть входящие звонки.',
        }),
      );
    }

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

    // Когда звонок завершается в Calls — снимаем нативный экран, если он ещё
    // висит (например, приняли из push, но звонок сорвался).
    _callSub ??= calls.snapshots.listen((snapshot) {
      if (snapshot.status == CallStatus.ended || snapshot.status == CallStatus.idle) {
        if (snapshot.callId.isNotEmpty) unawaited(FlutterCallkitIncoming.endCall(snapshot.callId));
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
  }

  Future<void> _syncTokens() async {
    if (Platform.isAndroid) {
      await pushManager.syncFcmToken();
    } else if (Platform.isIOS) {
      await _syncVoipToken();
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
        if (callId.isNotEmpty) await calls.acceptFromPush(callId);
      case CallEventActionCallDecline(:final callKitParams):
        final callId = callKitParams.id;
        if (callId.isNotEmpty) {
          final fromUserIDHex = (callKitParams.extra?[_kFromUserID] ?? '').toString();
          final fromUserID = fromUserIDHex.isEmpty ? <int>[] : utils.hexToBytes(fromUserIDHex);
          await calls.rejectFromPush(callId, fromUserID);
        }
      case CallEventActionCallEnded():
        await calls.hangup();
      case CallEventActionDidUpdateDevicePushTokenVoip():
        // iOS выдал/сменил VoIP-токен PushKit — событие не несёт сам токен,
        // забираем актуальный из плагина и регистрируем на сервере.
        await _syncVoipToken();
      default:
        break;
    }
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
