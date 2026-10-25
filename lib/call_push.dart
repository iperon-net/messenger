import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'auth.dart';
import 'calls.dart';
import 'di.dart';
import 'firebase_options.dart';
import 'logger.dart';
import 'peer_names.dart';
import 'push.dart';
import 'repositories.dart';
import 'utils.dart';
import 'account_scope.dart';
import 'accounts.dart';

// Ключи полезной нагрузки call-пуша. Должны совпадать с сервером —
// internal/services/push.go (map data в SendCallPush).
const _kCallId = 'callId';
const _kFromUserID = 'fromUserID';
const _kVideo = 'video';
// Какому аккаунту звонят (accountID слота, натив — по ключу пуша) и его
// подпись, когда аккаунтов несколько.
const _kAccount = 'account';
const _kAccountName = 'accountName';
const _kAction = 'action';
// Имя звонящего для показа в системной звонилке (CallKit/ConnectionService).
// Сервер кладёт облачный контакт получателя (тогда nameFromContact=true), иначе
// имя из профиля, иначе телефон; см. internal/services/push.go. Пусто/нет
// ключа — показываем 'Iperon'. callerPhone (E.164) — для имени из адресной
// книги, когда оно не из облачного контакта.
const _kNameCaller = 'nameCaller';
const _kCallerPhone = 'callerPhone';
const _kNameFromContact = 'nameFromContact';
const _kActionIncoming = 'incoming';
const _kActionCancel = 'cancel';

// Через сколько мс баннер входящего сам снимается как пропущенный, если на него
// не ответили и звонящий не прислал отмену. Бэкстоп на висящий баннер параллельно
// Dart-таймеру в [Calls] (Calls._incomingTimeout) — но этот работает и на нативном
// пути (full-screen Activity плагина), когда Dart мог не успеть. Держим чуть больше
// каллер-таймаута (CALL_RING_TIMEOUT_SECONDS=45 + маржа), чтобы штатную отмену
// обычно успевал cancel-пуш. Константа (не из Settings): применяется и в
// FCM-фоне, где DI может быть ещё не готов.
const _kIncomingBannerTimeoutMs = 60000;

// Канал к MainActivity (Android): показ Flutter-экрана звонка поверх экрана
// блокировки. См. android/.../MainActivity.kt.
const _callWindowChannel = MethodChannel('net.iperon.messenger/call_window');

// Локаль для строк системной звонилки берём СИСТЕМНУЮ (Platform.localeName), а
// не in-app slang-локаль: часть этого кода (_incomingParams) исполняется в
// фоновом isolate без DI/БД, где slang не поднят, а нативный экран входящего
// Android и так локализуется по системной локали (values-ru/ вендоренного
// плагина). Так все строки звонилки — заголовок, каналы, кнопки, запрос
// разрешения — следуют одной локали в обоих isolate'ах.
bool get _isRu => Platform.localeName.toLowerCase().startsWith('ru');

// Подпись звонка (handle) в системной звонилке.
String _handleText(bool isVideo) => _isRu ? (isVideo ? 'Видеозвонок' : 'Аудиозвонок') : (isVideo ? 'Video call' : 'Voice call');

// Названия каналов уведомлений о звонках.
String get _incomingChannelName => _isRu ? 'Входящие звонки' : 'Incoming calls';
String get _missedChannelName => _isRu ? 'Пропущенные звонки' : 'Missed calls';

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
    await FlutterCallkitIncoming.showCallkitIncoming(_incomingParams(data, callId, await _addressBookName(data)));
  }
}

/// Имя звонящего из адресной книги устройства (Android; на iOS — натив в
/// AppDelegate): сервер знает облачный контакт и профиль, а книги у него нет.
/// Порядок как везде — облачный контакт (`nameFromContact`) главнее книги.
/// Без разрешения на контакты не спрашиваем (фон), поиск ограничен по времени:
/// звонилку нельзя задерживать.
Future<String> _addressBookName(Map<String, dynamic> data) async {
  final phone = (data[_kCallerPhone] ?? '').toString();
  if (!Platform.isAndroid || phone.isEmpty || data[_kNameFromContact] == 'true') return '';
  try {
    if (!await FlutterContacts.permissions.has(PermissionType.read)) return '';
    final found = await FlutterContacts.getAll(
      properties: {ContactProperty.name},
      filter: ContactFilter.phone(phone),
      limit: 1,
    ).timeout(const Duration(milliseconds: 800));
    return found.firstOrNull?.displayName?.trim() ?? '';
  } catch (_) {
    return '';
  }
}

CallKitParams _incomingParams(Map<String, dynamic> data, String callId, String bookName) {
  final isVideo = (data[_kVideo] ?? '').toString() == 'true';
  final fromUserID = (data[_kFromUserID] ?? '').toString();
  final nameCaller = bookName.isNotEmpty ? bookName : (data[_kNameCaller] ?? '').toString();
  final account = (data[_kAccount] ?? '').toString();
  final accountName = (data[_kAccountName] ?? '').toString();

  return CallKitParams(
    id: callId,
    // Имя звонящего из push (профиль/телефон); пусто — фолбэк на 'Iperon'.
    // Android: системный стиль звонка показывает своё «Входящий вызов» вместо
    // handle — подпись аккаунта (их несколько) ставим к имени.
    nameCaller: Platform.isAndroid && accountName.isNotEmpty
        ? '${nameCaller.isNotEmpty ? nameCaller : 'Iperon'} · $accountName'
        : (nameCaller.isNotEmpty ? nameCaller : 'Iperon'),
    appName: 'Iperon',
    handle: accountName.isEmpty ? _handleText(isVideo) : '${_handleText(isVideo)} · $accountName',
    type: isVideo ? 1 : 0,
    // Авто-снятие баннера как пропущенного, если не ответили (см. _kIncomingBannerTimeoutMs).
    duration: _kIncomingBannerTimeoutMs,
    // extra доедет до события accept/decline — оттуда берём собеседника, тип
    // и аккаунт, которому звонят.
    extra: {_kFromUserID: fromUserID, _kVideo: isVideo, _kAccount: account},
    // Пропущенный — серверный CALL_MISSED (MessagePushHandler): плагин рисует свой
    // только по таймауту баннера, а на отбой звонящего — нет. Свой не показываем.
    missedCallNotification: const NotificationParams(showNotification: false),
    android: AndroidParams(
      isCustomNotification: true,
      isShowFullLockedScreen: true,
      isImportant: true,
      incomingCallNotificationChannelName: _incomingChannelName,
      missedCallNotificationChannelName: _missedChannelName,
      // textAccept/textDecline НЕ задаём: пустые — и плагин берёт нативные
      // R.string.text_accept/text_decline, которые Android локализует по
      // системной локали (values/ = EN, values-ru/ = RU в вендоренном плагине).
    ),
    // ВНИМАНИЕ: на iOS этот путь (Dart-репорт входящего из FCM-фона) НЕ
    // используется — cold-start-входящий репортит натив из VoIP-push
    // (ios/Runner/AppDelegate.swift `pushRegistry didReceiveIncomingPush`), а
    // foreground-входящий поднимается через _incomingParamsFromSnapshot (см.
    // _onIncomingRing). Флаг `configureAudioSession` для CallKit-аудио задаётся ТАМ
    // (`data.configureAudioSession = true`), не здесь. Значение ниже влияет только
    // на платформы/пути, где showCallkitIncoming зовётся из Dart (Android).
    // includesCallsInRecents: false — не пишем звонки приложения в системный
    // журнал iOS «Недавние»/историю «Телефона».
    ios: const IOSParams(
      handleType: 'generic',
      supportsVideo: true,
      configureAudioSession: true,
      includesCallsInRecents: false,
      // «Удержать и ответить» на чужой звонок (см. ios/Runner/AppDelegate.swift).
      supportsHolding: true,
    ),
  );
}

/// Мост между call-пушами / нативным экраном звонка (CallKit/ConnectionService)
/// и сервисом [Calls] в основном isolate. Регистрируется в `get_it` (см.
/// `di.dart`, `dependsOn: [Calls]`) и стартует один раз через [start].
///
/// - **foreground**: входящий приходит по открытому стриму — `Calls` эмитит его
///   в [Calls.incomingRings], а [CallPush] показывает системную звонилку
///   (`showCallkitIncoming`) с системным рингтоном; call-пуш при этом не приходит
///   (серверный гейт по онлайн-сессии), так что двойного звонка нет.
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
  StreamSubscription<CallSnapshot>? _incomingRingSub;
  StreamSubscription<String>? _incomingDismissSub;

  // iOS-симулятор? CallKit в симуляторе сам завершает каждый входящий примерно
  // через секунду (CXEndCallAction от системы), и плагин отдаёт это как DECLINE.
  // Без гарда симулятор, залогиненный в аккаунт, отклонял бы звонящему каждый
  // входящий — даже принятый на соседнем реальном устройстве. Считаем один раз
  // (не через Utils.deviceInfo: тот в debug всегда сообщает физическое устройство).
  late final Future<bool> _isIosSimulator = Platform.isIOS
      ? DeviceInfoPlugin().iosInfo.then((info) => !info.isPhysicalDevice, onError: (_) => false)
      : Future.value(false);

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
    // Разрешение НЕ просим ни на старте, ни после логина (иначе диалог всплывал
    // бы на экране авторизации / сразу после входа, без контекста и с низким
    // opt-in). Запрашиваем в осознанный момент — на вкладке «Звонки» и при
    // инициации звонка (см. ensureCallPermissions).

    // iOS: VoIP-токен уже мог быть выдан PushKit до подписки на события —
    // забираем его из плагина и регистрируем сразу. Дальнейшие смены токена
    // прилетят событием actionDidUpdateDevicePushTokenVoip (см. _onEvent).
    if (Platform.isIOS) {
      unawaited(_syncVoipToken());
    }

    FirebaseMessaging.onBackgroundMessage(callPushBackgroundHandler);

    // foreground: входящий активному аккаунту приходит по стриму и поднимается
    // через системную звонилку из [Calls.incomingRings] (см. _onIncomingRing),
    // не из FCM. Из пуша здесь — cancel (снять возможный подвисший нативный
    // экран) и входящий неактивному аккаунту: стрима у него нет.
    FirebaseMessaging.onMessage.listen((message) {
      final action = message.data[_kAction];
      if (action == _kActionCancel) {
        final callId = (message.data[_kCallId] ?? '').toString();
        if (callId.isNotEmpty) unawaited(FlutterCallkitIncoming.endCall(callId));
      } else if (action == _kActionIncoming) {
        unawaited(_onIncomingPush(message.data));
      }
    });

    _eventSub ??= FlutterCallkitIncoming.onEvent.listen(_onEvent);

    // Foreground-входящий: `Calls` поймал `CALL_RING` по живому стриму и просит
    // показать его через системную звонилку (см. Calls.incomingRings). Так на
    // переднем плане играет системный рингтон и UI ведёт CallKit/
    // ConnectionService — единообразно с приёмом из фона. Ответ/отбой прилетят в
    // [_onEvent] тем же путём, что и из push.
    _incomingRingSub ??= calls.incomingRings.listen(_onIncomingRing);

    // Мультидевайс: звонок приняли/отменили на другом устройстве владельца, а у
    // нас баннер входящего мог быть поднят ФОНОВЫМ isolate'ом из FCM — тогда
    // снимок `Calls` в основном isolate ещё `idle` и мост по снимкам (_callSub)
    // его не снимет. `Calls` шлёт сюда callId — гасим нативный баннер напрямую.
    // Идемпотентно: endCall по неизвестному callId — no-op.
    _incomingDismissSub ??= calls.incomingDismiss.listen((callId) {
      if (callId.isNotEmpty) unawaited(FlutterCallkitIncoming.endCall(callId));
    });

    // Холодный старт из killed-state (обе платформы): пользователь принял звонок
    // из нативного экрана, а приложение поднялось с нуля (Android — MainActivity
    // из ConnectionService; iOS — Flutter-engine из VoIP-push). Событие
    // ACTION_CALL_ACCEPT плагин эмитит в onEvent ДО того, как мы успели на него
    // подписаться (DI/БД ещё грузились), а onEvent — broadcast-стрим и теряет
    // события без слушателя. Итог: acceptFromPush не вызывался, в комнату
    // LiveKit не входили (белый экран + нет медиа). Плагин хранит принятый звонок
    // в ACTIVE_CALLS (isAccepted=true) — переигрываем accept по нему. Дедуп
    // [_acceptedCallId] (и [Calls._handlingCallId]) не даёт двойного входа, если
    // живое событие всё же придёт следом. На iOS этот путь ещё и форсирует
    // аудиодвижок (см. [_resumeAcceptedCallFromColdStart]), т.к. CallKit
    // `didActivate` теряется той же гонкой.
    unawaited(_resumeAcceptedCallFromColdStart());

    // Мост Calls → CallKit по снимкам:
    // - ended/idle: снимаем нативный экран, если он ещё висит (например, приняли
    //   входящий из push/стрима, но звонок сорвался).
    //
    // Исходящий в CallKit НЕ регистрируем: на iOS это поднимало системную
    // звонилку поверх нашего экрана. Аудио исходящего едет режимом `automatic`
    // (LiveKit сам ставит категорию/активирует сессию, см.
    // Calls._configureIosAudioForCall) — CallKit для этого не нужен. Так исходящий
    // показывает только наш `CallView`, а системную звонилку видим лишь на
    // входящем (системный рингтон).
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
        case CallStatus.ended:
        case CallStatus.idle:
          if (snapshot.callId.isNotEmpty) unawaited(FlutterCallkitIncoming.endCall(snapshot.callId));
        default:
          break;
      }
    });

    // Регистрация VoIP-токена на старте (выше) гейтится на авторизацию: на
    // свежей установке в этот момент сессии ещё нет, поэтому токен не уходит на
    // сервер, и после логина в том же запуске повторно не отправляется — сервер
    // не может разбудить входящий, пока приложение не перезапустят уже
    // залогиненным. Реагируем на смену состояния Auth (ChangeNotifier) и
    // досылаем токен, как только пользователь авторизовался. Идемпотентно:
    // PushManager дедуплицирует уже отправленный токен. FCM/APNs-токены
    // уведомлений PushManager досылает сам (своя подписка на Auth).
    auth.addListener(_onAuthChanged);
  }

  /// При переходе в авторизованное состояние досылает VoIP-токен (iOS).
  /// Разлогин игнорируем.
  void _onAuthChanged() {
    if (!auth.isAuthorized || !Platform.isIOS) return;
    unawaited(_syncVoipToken());
  }

  /// Android 13+: разрешение POST_NOTIFICATIONS нужно, чтобы показать входящий
  /// звонок (нотификацию). На iOS no-op (CallKit не требует разрешения на
  /// уведомления). Идемпотентно: система покажет диалог лишь при первом запросе.
  /// Вызывается из [ensureCallPermissions] после нашего soft-ask.
  Future<void> requestNotificationPermission() async {
    if (!Platform.isAndroid) return;
    await FlutterCallkitIncoming.requestNotificationPermission({
      'rationaleMessagePermission': _isRu
          ? 'Разрешение нужно, чтобы показывать входящие звонки.'
          : 'Permission is required to show incoming calls.',
      'postNotificationMessageRequired': _isRu
          ? 'Разрешите уведомления в настройках, чтобы видеть входящие звонки.'
          : 'Please enable notifications in settings to receive incoming calls.',
    });
  }

  /// Показывает foreground-входящий через системную звонилку (см. [start] →
  /// [Calls.incomingRings]). Имя звонящего резолвим локально из кэша профилей (как
  /// для исходящего), extra донесёт собеседника/тип до accept/decline в [_onEvent].
  Future<void> _onIncomingRing(CallSnapshot snapshot) async {
    if (snapshot.callId.isEmpty) return;
    // iOS: входящий ведёт ТОЛЬКО системный CallKit, поднятый нативом из VoIP-push
    // (AppDelegate.didReceiveIncomingPush) — сервер шлёт call-push для incoming
    // всегда, даже на онлайн-сессию (push.go `ignoreOnline`). Свой экран на
    // входящем больше не открываем ([CallGate._isActive]), поэтому здесь на iOS
    // ничего не делаем: показ ещё одного CallKit-звонка из Dart дал бы ВТОРОЙ
    // баннер поверх нативного. Приём/отбой прилетают в [_onEvent] из CallKit.
    if (Platform.isIOS) return;
    final name = await _resolveDisplayName(snapshot.remoteUserID);
    // Пока имя читалось, звонок мог завершиться/смениться (звонящий
    // отменил, приняли из push) — не поднимаем устаревший входящий.
    if (calls.snapshot.status != CallStatus.incoming || calls.snapshot.callId != snapshot.callId) return;
    await FlutterCallkitIncoming.showCallkitIncoming(_incomingParamsFromSnapshot(snapshot, name));
  }

  /// [CallKitParams] для foreground-входящего из [CallSnapshot] (данные ring'а
  /// пришли по стриму, а не из push). Формат extra совпадает с [_incomingParams],
  /// чтобы [_onEvent] разбирал их единообразно.
  CallKitParams _incomingParamsFromSnapshot(CallSnapshot snapshot, String nameCaller) {
    final isVideo = snapshot.video;
    final fromUserIDHex = utils.bytesToHex(Uint8List.fromList(snapshot.remoteUserID));
    return CallKitParams(
      id: snapshot.callId,
      nameCaller: nameCaller.isNotEmpty ? nameCaller : 'Iperon',
      appName: 'Iperon',
      handle: _handleText(isVideo),
      type: isVideo ? 1 : 0,
      // Авто-снятие баннера как пропущенного, если не ответили (см. _kIncomingBannerTimeoutMs).
      duration: _kIncomingBannerTimeoutMs,
      extra: {_kFromUserID: fromUserIDHex, _kVideo: isVideo},
      // См. _incomingParams: пропущенный — серверный CALL_MISSED.
      missedCallNotification: const NotificationParams(showNotification: false),
      android: AndroidParams(
        isCustomNotification: true,
        isShowFullLockedScreen: true,
        isImportant: true,
        incomingCallNotificationChannelName: _incomingChannelName,
        missedCallNotificationChannelName: _missedChannelName,
        // См. коммент в _incomingParams: textAccept/textDecline не задаём —
        // локализация идёт через R.string (values/ + values-ru/) плагина.
      ),
      // configureAudioSession: true — на ответе плагин активирует AVAudioSession,
      // CXProvider шлёт didActivate → ACTION_CALL_TOGGLE_AUDIO_SESSION →
      // Calls.setAudioEngineActive (движок LiveKit в `externalCallSystem`). Тот же
      // механизм, что и на cold-start из VoIP-push.
      ios: const IOSParams(
        handleType: 'generic',
        supportsVideo: true,
        configureAudioSession: true,
        includesCallsInRecents: false,
        // «Удержать и ответить» на чужой звонок (см. ios/Runner/AppDelegate.swift).
        supportsHolding: true,
      ),
    );
  }

  /// Отображаемое имя абонента по [userID] из локального кэша профилей
  /// по общему правилу (контакт → профиль → @username → номер, см.
  /// [peerDisplayName]). Пусто, если ничего нет — тогда вызывающий покажет
  /// фолбэк 'Iperon'. Без сети: имя для системной звонилки должно резолвиться
  /// мгновенно.
  Future<String> _resolveDisplayName(List<int> userID) async {
    if (userID.isEmpty) return '';
    try {
      return await peerDisplayName(userID);
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
          final target = await _callsFor((callKitParams.extra?[_kAccount] ?? '').toString());
          await target.acceptFromPush(callId, fromUserID: fromUserID, video: video);
        }
      case CallEventActionCallIncoming(:final callKitParams):
        // Занятость по всем аккаунтам: пока идёт звонок, второй входящий (в т.ч.
        // неактивному аккаунту) — «занято».
        await _rejectBusyIncoming(callKitParams);
      case CallEventActionCallDecline(:final callKitParams):
        final callId = callKitParams.id;
        if (callId.isNotEmpty && await _isIosSimulator) {
          // См. [_isIosSimulator]: «отказ» здесь — авто-сброс CallKit симулятора,
          // а не пользователь. Звонящему ничего не шлём, только гасим своё.
          logger.info('call: decline from iOS simulator CallKit ignored ($callId)');
          if (_acceptedCallId == callId) _acceptedCallId = null;
          break;
        }
        if (callId.isNotEmpty) {
          if (_acceptedCallId == callId) _acceptedCallId = null;
          final fromUserIDHex = (callKitParams.extra?[_kFromUserID] ?? '').toString();
          final fromUserID = fromUserIDHex.isEmpty ? <int>[] : utils.hexToBytes(fromUserIDHex);
          final account = (callKitParams.extra?[_kAccount] ?? '').toString();
          if (await _isOtherAccount(account)) {
            // Звонят неактивному аккаунту — отказ от его имени, без переключения.
            await rejectCallAs(account, callId: callId, toUserID: fromUserID);
          } else {
            await calls.rejectFromPush(callId, fromUserID);
          }
        }
      case CallEventActionCallToggleAudioSession(:final isActive):
        // iOS CallKit активировал/деактивировал аудиосессию (provider
        // didActivate/didDeactivate) — синхронно открываем/закрываем
        // WebRTC-аудиодвижок LiveKit (см. Calls.setAudioEngineActive).
        logger.info('call: ToggleAudioSession event received (isActive=$isActive)');
        await calls.setAudioEngineActive(isActive);
      case CallEventActionCallEnded(:final callKitParams):
        // ENDED приходит и на программный endCall (снимок звонка уже ended/idle, баннер
        // сняли сами — форк плагина шлёт ENDED вместо DECLINE, см.
        // third_party/flutter_callkit_incoming). Вешаем трубку, только если событие
        // про текущий звонок: иначе запоздалый ENDED прошлого звонка оборвал бы новый.
        final callId = callKitParams.id;
        if (callId.isEmpty || callId == _acceptedCallId) _acceptedCallId = null;
        if (calls.snapshot.status == CallStatus.incoming && callId == calls.snapshot.callId) {
          // Не ответили: баннер снят отменой звонящего мимо этого isolate'а —
          // только свернуть снимок, без отбоя собеседнику.
          await calls.endIncomingFromNative(callId);
        } else if (callId.isEmpty || callId == calls.snapshot.callId) {
          await calls.hangup();
        }
      case CallEventActionCallToggleHold(:final id, :final isOnHold):
        // CallKit поставил наш звонок на удержание (ответили на чужой) или снял.
        // Звук гейтится по ToggleAudioSession выше; здесь лишь ускоряем сигнал
        // удержания собеседнику (см. Calls.onSystemHold).
        logger.info('call: CallKit hold=$isOnHold ($id)');
        if (id.isEmpty || id.toLowerCase() == calls.snapshot.callId.toLowerCase()) calls.onSystemHold();
      case CallEventActionDidUpdateDevicePushTokenVoip():
        // iOS выдал/сменил VoIP-токен PushKit — событие не несёт сам токен,
        // забираем актуальный из плагина и регистрируем на сервере.
        await _syncVoipToken();
      default:
        break;
    }
  }

  /// Входящий из пуша при открытом приложении (Android): показать, если он
  /// неактивному аккаунту; идёт звонок — сразу «занято», без баннера.
  Future<void> _onIncomingPush(Map<String, dynamic> data) async {
    final account = (data[_kAccount] ?? '').toString();
    if (!await _isOtherAccount(account)) return;
    final callId = (data[_kCallId] ?? '').toString();
    if (calls.hasActiveCall) {
      logger.info('call: busy — rejecting incoming $callId for account $account');
      final fromUserIDHex = (data[_kFromUserID] ?? '').toString();
      final fromUserID = fromUserIDHex.isEmpty ? <int>[] : utils.hexToBytes(fromUserIDHex);
      await rejectCallAs(account, callId: callId, toUserID: fromUserID, busy: true);
      return;
    }
    await _handleCallData(data);
  }

  /// Баннер входящего поднят мимо [Calls] (пуш: фоновый isolate Android, VoIP
  /// iOS), а у нас уже идёт звонок — снять его и ответить «занято» от того
  /// аккаунта, которому звонят (как авто-отклонение в `Calls._onRing`).
  Future<void> _rejectBusyIncoming(CallKitParams params) async {
    final callId = params.id;
    if (callId.isEmpty || !calls.hasActiveCall || callId == calls.snapshot.callId) return;
    final account = (params.extra?[_kAccount] ?? '').toString();
    logger.info('call: busy — rejecting incoming $callId (account ${account.isEmpty ? 'active' : account})');
    await FlutterCallkitIncoming.endCall(callId);
    final fromUserIDHex = (params.extra?[_kFromUserID] ?? '').toString();
    final fromUserID = fromUserIDHex.isEmpty ? <int>[] : utils.hexToBytes(fromUserIDHex);
    if (await _isOtherAccount(account)) {
      await rejectCallAs(account, callId: callId, toUserID: fromUserID, busy: true);
    } else {
      await calls.rejectBusy(callId, fromUserID);
    }
  }

  /// Входящий другому вошедшему аккаунту (не активному).
  Future<bool> _isOtherAccount(String account) async {
    if (account.isEmpty || account == AccountScope.current.accountID) return false;
    return (await signedInAccounts()).any((entry) => entry.accountID == account);
  }

  /// [Calls] аккаунта, которому звонят: другому — сначала переключиться на
  /// него (как в Telegram), разговор идёт уже в нём.
  Future<Calls> _callsFor(String account) async {
    if (!await _isOtherAccount(account)) return calls;
    try {
      await switchAccount(account);
      return getIt.get<Calls>();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return calls;
    }
  }

  /// Переигрывает accept, потерянный на холодном старте (см. [start]). Читает
  /// принятый звонок из ACTIVE_CALLS плагина (`isAccepted == true`) и поднимает
  /// его тем же путём, что и живое событие accept. Кроссплатформенно: на Android
  /// приложение поднимает MainActivity, на iOS — VoIP-push (Flutter-engine с нуля).
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
        final target = await _callsFor(extra is Map ? (extra[_kAccount] ?? '').toString() : '');
        await target.acceptFromPush(callId, fromUserID: fromUserID, video: video);

        // iOS cold-start: событие CallKit `didActivate`
        // (ACTION_CALL_TOGGLE_AUDIO_SESSION) прилетело в onEvent до нашей подписки
        // и потеряно той же гонкой, что и accept. Аудиосессией на этом пути владеет
        // CallKit — и она уже активна (звонок принят), — но движок LiveKit
        // гейтится по `didActivate` и без него остаётся выключен
        // (AudioEngineAvailability.none) → тишина. Форсируем активацию движка сами.
        // setAudioEngineActive идемпотентна и ждёт готовности WebRTC-фабрики (тот
        // же мемоизированный init, что и коннект), поэтому безопасна и если живой
        // `didActivate` всё же придёт следом. На Android no-op (там движком рулит
        // сам LiveKit в `automatic`).
        if (Platform.isIOS) await calls.setAudioEngineActive(true);
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
    await _incomingRingSub?.cancel();
    _incomingRingSub = null;
    await _incomingDismissSub?.cancel();
    _incomingDismissSub = null;
  }
}
