import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'api.dart';
import 'auth.dart';
import 'di.dart';
import 'logger.dart';
import 'protobuf.dart';
import 'repositories.dart';

/// Регистрирует push-токены устройства на сервере: побудка входящих звонков и
/// уведомления, когда персистентный gRPC-стрим закрыт (приложение в фоне/
/// выгружено). См. `docs/plans/push-notifications.md` (этап 1) и фазу 4 в
/// `docs/plans/melodic-beaming-elephant.md`.
///
/// Каналы (у каждого свой токен):
/// - **Android** — FCM data-message по FID (Firebase Installation ID, тип
///   `FCM_FID`, сервер шлёт через `Message.Fid`): [FirebaseMessaging.register]
///   на каждой синхронизации, FID — [FirebaseInstallations.getId], смена — по
///   [FirebaseMessaging.onRegistered]. Регистрационный токен `getToken` (тип
///   `FCM`) в firebase_messaging 17 deprecated; сервер держит его только для
///   старых клиентов.
/// - **iOS, звонки** — VoIP-токен PushKit; получаем в нативном коде и передаём
///   сюда ([registerVoipToken]).
/// - **iOS, уведомления** — обычный APNs-токен. На remote notifications
///   регистрирует плагин firebase_messaging (swizzling AppDelegate), токен
///   забираем через [FirebaseMessaging.getAPNSToken] ([_syncApnsToken]).
///
/// Оба APNs-токена привязаны к окружению: debug-сборка подписана
/// `RunnerDebug.entitlements` (`aps-environment=development`) и получает
/// sandbox-токен, Profile/Release — production. Окружение уходит на сервер
/// флагом `sandbox`, сервер по нему выбирает gateway.
///
/// Уведомления приходят зашифрованными (поле `p`, см.
/// `protos/push_payload_v1.proto`). Расшифровывает и показывает их натив без
/// Flutter-движка: на Android — FCM-сервис, на iOS — Notification Service
/// Extension. Поэтому ключ расшифровки (HKDF от sharedKey сессии), флаг
/// код-пароля и скрытые профили отдаём в натив ([_syncPushKey],
/// [setPasscodeEnabled], [_syncHiddenUsers]) по каналу
/// `net.iperon.messenger/push` (Android — хранилище на Keystore, iOS — общий с
/// NSE Keychain); тот же канал приносит тапы по уведомлениям ([onRoute]).
///
/// Регистрируется в `get_it` (см. `di.dart`, `dependsOn: [API, Auth]`) как
/// синглтон. Отправка идемпотентна: последний отправленный токен каждого канала
/// кэшируется, повтор того же токена на сервер не уходит.
class PushManager {
  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  // Ключи кэша последнего отправленного токена (дедуп по каналу). VoIP — `_v2`:
  // старые клиенты слали VoIP-токен без флага sandbox, новый ключ заставляет
  // один раз переотправить его уже с окружением.
  // FCM — `_fid`: после перехода с регистрационного токена на FID новый ключ
  // заставляет один раз отправить FID.
  static const _fcmCacheKey = 'push_token_fcm_fid_sent';
  static const _voipCacheKey = 'push_token_voip_sent_v2';
  static const _apnsCacheKey = 'push_token_apns_sent';

  /// Окружение APNs текущей сборки (см. описание класса).
  static const bool _apnsSandbox = kDebugMode;

  // APNs-токен может быть ещё не выдан к моменту старта (регистрация в APNs
  // асинхронная) — пробуем ещё несколько раз с паузой.
  static const _apnsRetryDelay = Duration(seconds: 3);
  static const _apnsRetryAttempts = 5;

  static const _channel = MethodChannel('net.iperon.messenger/push');

  // HKDF info ключа пушей — как на сервере (internal/crypto/push.go).
  static const _pushKeyInfo = 'iperon-push-v1';
  static const _pushKeyIdLength = 8;

  /// Канал `net.iperon.messenger/push` есть на обеих мобильных платформах.
  static bool get _hasNativePush => Platform.isAndroid || Platform.isIOS;

  StreamSubscription<String>? _fcmRefreshSub;
  StreamSubscription<void>? _hiddenSub;
  Timer? _apnsRetryTimer;
  bool _started = false;

  void Function(String route)? _routeHandler;
  String? _pendingRoute;

  /// Обработчик перехода по тапу на уведомление (ставит корень приложения —
  /// `goRouter.go`). Тап холодного старта, пришедший раньше обработчика,
  /// отдаётся сразу при установке.
  set onRoute(void Function(String route)? handler) {
    _routeHandler = handler;
    final pending = _pendingRoute;
    if (handler != null && pending != null) {
      _pendingRoute = null;
      handler(pending);
    }
  }

  /// Запуск на старте приложения (main.dart): подписки и первичная синхронизация
  /// токенов и ключа расшифровки. [passcodeEnabled] — включён ли код-пароль
  /// (уведомления тогда без имени и текста). Идемпотентно.
  Future<void> start({bool passcodeEnabled = false}) async {
    if (!_started) {
      _started = true;

      if (_hasNativePush) {
        _channel.setMethodCallHandler(_onNativeCall);
        unawaited(setPasscodeEnabled(passcodeEnabled));
        // Локально скрытые профили: их пуши натив показывает без имени и текста.
        _hiddenSub = repositories.hiddenProfiles.changes.listen((_) => unawaited(_syncHiddenUsers()));
        unawaited(_syncHiddenUsers());
        unawaited(_takeInitialTap());
      }

      // На свежей установке к старту сессии ещё нет — токены не уходят. После
      // логина в том же запуске досылаем их по смене состояния Auth.
      auth.addListener(_onAuthChanged);

      if (Platform.isIOS) {
        // Показ в foreground незашифрованных пушей (тестовый с экрана
        // «Разработчик»): их AppDelegate отдаёт firebase_messaging, а тот без
        // этих опций при открытом приложении не показывает ничего. Зашифрованные
        // решает сам AppDelegate (PushBridge.swift).
        try {
          await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        } catch (error, stackTrace) {
          logger.handle(error, stackTrace);
        }
      }
    }

    await Future.wait([syncTokens(), _syncPushKey()]);
  }

  /// Синхронизирует push-токены уведомлений текущей платформы: FCM на Android,
  /// APNs на iOS. Зовём на старте, после логина и на каждый resume (токен мог
  /// смениться, пока приложение было выгружено). VoIP-токен синхронизирует
  /// [CallPush] — он приходит событием плагина звонков.
  Future<void> syncTokens() async {
    if (Platform.isAndroid) {
      await _syncFcmToken();
    } else if (Platform.isIOS) {
      await _syncApnsToken();
    }
  }

  void _onAuthChanged() {
    unawaited(_syncPushKey());
    if (!auth.isAuthorized) return;
    unawaited(syncTokens());
  }

  /// Отдаёт нативу ключ расшифровки пушей текущей сессии, а на разлогине —
  /// стирает (пуши старой сессии больше не расшифруются и не покажутся).
  /// Ключ = HKDF-SHA256(sharedKey, salt, "iperon-push-v1"), keyID — первые 8 байт
  /// сессии; формат — internal/crypto/push.go на сервере.
  Future<void> _syncPushKey() async {
    if (!_hasNativePush) return;

    try {
      final session = auth.session;
      if (!auth.isAuthorized || session.session.length < _pushKeyIdLength || session.sharedKey.isEmpty) {
        await _channel.invokeMethod<void>('clearPushKeys');
        // Разлогинились — непрочитанные старой сессии на иконке не нужны.
        await setBadge(0);
        return;
      }

      final key = await Hkdf(
        hmac: Hmac.sha256(),
        outputLength: 32,
      ).deriveKey(secretKey: SecretKey(session.sharedKey), nonce: session.salt, info: utf8.encode(_pushKeyInfo));
      await _channel.invokeMethod<void>('setPushKey', {
        'keyId': Uint8List.fromList(session.session.sublist(0, _pushKeyIdLength)),
        'key': Uint8List.fromList(await key.extractBytes()),
      });
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Включён ли код-пароль: натив тогда показывает уведомления без имени и
  /// текста. Зовётся на старте и при смене кода (CommonCubit.setPasscode).
  Future<void> setPasscodeEnabled(bool enabled) async {
    if (!_hasNativePush) return;
    try {
      await _channel.invokeMethod<void>('setPasscodeEnabled', enabled);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Отдаёт нативу hex(userID) локально скрытых профилей (см. HiddenProfiles):
  /// уведомления от них — без имени и текста, как при код-пароле. Зовётся на
  /// старте и при каждом скрытии/показе профиля.
  Future<void> _syncHiddenUsers() async {
    try {
      final hidden = await repositories.hiddenProfiles.hashByHex();
      await _channel.invokeMethod<void>('setHiddenUsers', hidden.keys.toList());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// iOS: приложение запущено системой в фоне (VoIP / тихий пуш) и пользователь
  /// его ещё не открыл — `UIApplication.applicationState == .background`.
  /// Жизненный цикл Flutter в таком запуске не приходит, поэтому спрашиваем
  /// натив. На прочих платформах и при ошибке — `false` (как раньше: стрим =
  /// передний план).
  static Future<bool> isLaunchedInBackground() async {
    if (!Platform.isIOS) return false;
    try {
      return await _channel.invokeMethod<bool>('isInBackground') ?? false;
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
      return false;
    }
  }

  /// Счётчик непрочитанных на иконке приложения (iOS; 0 — снять). Пока
  /// приложение открыто, его ведёт [ChatsSync] по локальному списку диалогов, в
  /// фоне — пуши (alert — `aps.badge`, тихий — `PushPayload.badge`). На Android
  /// число на иконке рисует лаунчер по уведомлениям.
  static Future<void> setBadge(int count) async {
    if (!Platform.isIOS) return;
    // info — в файловый лог: по нему видно, ставило ли приложение счётчик.
    getIt.get<Logger>().info('badge: set $count');
    try {
      await _channel.invokeMethod<void>('setBadge', count);
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  /// Снимает уже показанные уведомления чата [chatID]: прочитано или удалено
  /// здесь либо на другом устройстве (обновление из стрима / журнала). Устройства
  /// без живого стрима снимает тихий push `READ_HISTORY` / `MESSAGE_DELETED`.
  /// [maxID] — все сообщения до него включительно, [messageIDs] — только эти,
  /// [all] — все уведомления чата.
  static Future<void> clearChatNotifications(List<int> chatID, {int maxID = 0, List<int> messageIDs = const [], bool all = false}) async {
    if (!_hasNativePush) return;
    try {
      await _channel.invokeMethod<void>('clearChatNotifications', {
        'chatID': [for (final b in chatID) b.toRadixString(16).padLeft(2, '0')].join(),
        'maxID': maxID,
        'messageIDs': messageIDs,
        'all': all,
      });
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  Future<dynamic> _onNativeCall(MethodCall call) async {
    if (call.method == 'onNotificationTap') await _handleTap(call.arguments);
    return null;
  }

  /// Тап холодного старта, отложенный нативом до готовности Dart.
  Future<void> _takeInitialTap() async {
    try {
      final tap = await _channel.invokeMethod<Object?>('takeInitialTap');
      if (tap != null) await _handleTap(tap);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  Future<void> _handleTap(Object? arguments) async {
    final tap = arguments as Map?;
    final kind = PushPayload_Kind.valueOf((tap?['kind'] as int?) ?? 0);
    var route = routeForKind(kind, chatID: (tap?['chatID'] as String?) ?? '');
    // От скрытого профиля — не открываем его чат (он бы выдал собеседника),
    // только список: раскрыть его можно «/код-фразой» в поиске.
    if (route != null && route.startsWith('/chats/') && await _fromHiddenUser(tap)) route = '/chats';
    logger.info('push: notification tap kind=$kind route=$route');
    if (route == null) return;

    final handler = _routeHandler;
    if (handler != null) {
      handler(route);
    } else {
      _pendingRoute = route;
    }
  }

  Future<bool> _fromHiddenUser(Map? tap) async {
    final fromUserID = ((tap?['fromUserID'] as String?) ?? '').toLowerCase();
    if (fromUserID.isEmpty) return false;
    try {
      return (await repositories.hiddenProfiles.hashByHex()).containsKey(fromUserID);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      return true;
    }
  }

  /// Куда вести по тапу. null — просто открыть приложение. Сообщение и
  /// реакция — в чат [chatID] (hex, натив кладёт его из расшифрованного
  /// пуша); без него — в список чатов.
  @visibleForTesting
  static String? routeForKind(PushPayload_Kind? kind, {String chatID = ''}) => switch (kind) {
    PushPayload_Kind.CONTACT_JOINED => '/contacts',
    PushPayload_Kind.CALL_MISSED => '/calls',
    PushPayload_Kind.MESSAGE ||
    PushPayload_Kind.MESSAGE_REACTION => _chatIDPattern.hasMatch(chatID) ? '/chats/chat/${chatID.toLowerCase()}' : '/chats',
    // Секретный чат — своё окно (chatID — secretChatID).
    PushPayload_Kind.SECRET_MESSAGE => _chatIDPattern.hasMatch(chatID) ? '/chats/secret/${chatID.toLowerCase()}' : '/chats',
    _ => null,
  };

  /// chatID из пуша — ObjectID в hex.
  static final _chatIDPattern = RegExp(r'^[0-9a-fA-F]{24}$');

  /// Android: регистрация установки в FCM + её FID на сервер, подписка на
  /// смену FID. `register()` — на каждой синхронизации (как раньше `getToken`):
  /// FCM мог снять регистрацию, пока приложение было выгружено. FID берём из
  /// Installations, а не ждём `onRegistered`: событие может не прийти, если
  /// установка уже была зарегистрирована.
  Future<void> _syncFcmToken() async {
    try {
      _fcmRefreshSub ??= FirebaseMessaging.instance.onRegistered.listen((fid) => unawaited(_registerFid(fid)));
      await FirebaseMessaging.instance.register();
      await _registerFid(await FirebaseInstallations.instance.getId());
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  Future<void> _registerFid(String fid) async {
    if (fid.isEmpty) return;
    await _register(
      token: fid,
      type: RegisterPushToken_TokenType.FCM_FID,
      platform: RegisterPushToken_Platform.ANDROID,
      cacheKey: _fcmCacheKey,
    );
  }

  /// iOS: APNs-токен обычных уведомлений. Если APNs ещё не выдал токен —
  /// повторяем через [_apnsRetryDelay] (до [_apnsRetryAttempts] раз).
  Future<void> _syncApnsToken({int attempt = 0}) async {
    _apnsRetryTimer?.cancel();
    _apnsRetryTimer = null;

    try {
      final token = await FirebaseMessaging.instance.getAPNSToken();
      if (token == null || token.isEmpty) {
        if (attempt + 1 < _apnsRetryAttempts) {
          _apnsRetryTimer = Timer(_apnsRetryDelay, () => unawaited(_syncApnsToken(attempt: attempt + 1)));
        } else {
          logger.warning('push: apns token unavailable after $_apnsRetryAttempts attempts');
        }
        return;
      }

      await _register(
        token: token,
        type: RegisterPushToken_TokenType.APNS,
        platform: RegisterPushToken_Platform.IOS,
        cacheKey: _apnsCacheKey,
        sandbox: _apnsSandbox,
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Регистрирует iOS VoIP-токен (PushKit), полученный нативным кодом. Вызывается
  /// из [CallPush] при выдаче/смене VoIP-токена.
  Future<void> registerVoipToken(String token) async {
    if (token.isEmpty) return;
    await _register(
      token: token,
      type: RegisterPushToken_TokenType.APNS_VOIP,
      platform: RegisterPushToken_Platform.IOS,
      cacheKey: _voipCacheKey,
      sandbox: _apnsSandbox,
    );
  }

  /// Тестовый push на все устройства пользователя (экран «Разработчик»).
  /// Возвращает статус вызова и, при успехе, итог рассылки.
  /// [encrypted] — через серверный конвейер уведомлений (зашифрованный
  /// PushPayload, доставка асинхронная — ответ только `queued`).
  Future<(APICallStatus, PushTest_Response?)> sendTestPush({bool encrypted = false}) async {
    final (status, payload) = await api.unaryEncodedWithResponse(
      MessageType.PUSH_TEST,
      PushTest_Request(encrypted: encrypted).writeToBuffer(),
    );
    if (status.status != APIStatus.success || payload == null) return (status, null);
    return (status, PushTest_Response.fromBuffer(payload));
  }

  Future<void> _register({
    required String token,
    required RegisterPushToken_TokenType type,
    required RegisterPushToken_Platform platform,
    required String cacheKey,
    bool? sandbox,
  }) async {
    if (!auth.isAuthorized) {
      logger.debug('push: register skipped, not authorized');
      return;
    }

    final userID = Uint8List.fromList(auth.session.userID);

    // Дедуп привязан к паре (сессия + токен), а не к одному токену: токен
    // хранится на сервере per-session (по _id сессии), а один и тот же токен
    // устройства переживает перелогин. Если ключом дедупа был бы только токен,
    // после перелогина (новая сессия, тот же токен) отправку бы пропустили —
    // и НОВАЯ сессия осталась бы без токена, пуши бы молчали. Поэтому в маркер
    // подмешиваем sessionID: смена сессии заставит переотправить токен.
    final marker = '${_hex(auth.session.sessionID)}:$token';
    final lastSent = await repositories.cache.getString(userID: userID, key: cacheKey);
    if (lastSent == marker) {
      logger.debug('push: token unchanged ($cacheKey), skip');
      return;
    }

    final request = RegisterPushToken_Request(token: token, type: type, platform: platform, sandbox: sandbox);
    final status = await api.unaryEncoded(MessageType.REGISTER_PUSH_TOKEN, request.writeToBuffer());

    if (status.status == APIStatus.success) {
      await repositories.cache.setString(userID: userID, key: cacheKey, value: marker);
      logger.debug('push: token registered ($cacheKey)');
    } else {
      logger.warning('push: token register failed ($cacheKey): ${status.error}');
    }
  }

  static String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  Future<void> dispose() async {
    auth.removeListener(_onAuthChanged);
    _apnsRetryTimer?.cancel();
    _apnsRetryTimer = null;
    await _fcmRefreshSub?.cancel();
    _fcmRefreshSub = null;
    await _hiddenSub?.cancel();
    _hiddenSub = null;
  }
}
