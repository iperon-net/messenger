import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

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
/// - **Android** — FCM data-message. Токен из [FirebaseMessaging.getToken],
///   переотправляется при `onTokenRefresh`.
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
  static const _fcmCacheKey = 'push_token_fcm_sent';
  static const _voipCacheKey = 'push_token_voip_sent_v2';
  static const _apnsCacheKey = 'push_token_apns_sent';

  /// Окружение APNs текущей сборки (см. описание класса).
  static const bool _apnsSandbox = kDebugMode;

  // APNs-токен может быть ещё не выдан к моменту старта (регистрация в APNs
  // асинхронная) — пробуем ещё несколько раз с паузой.
  static const _apnsRetryDelay = Duration(seconds: 3);
  static const _apnsRetryAttempts = 5;

  StreamSubscription<String>? _fcmRefreshSub;
  Timer? _apnsRetryTimer;
  bool _started = false;

  /// Запуск на старте приложения (main.dart): подписки и первичная синхронизация
  /// токенов. Идемпотентно.
  Future<void> start() async {
    if (!_started) {
      _started = true;

      // На свежей установке к старту сессии ещё нет — токены не уходят. После
      // логина в том же запуске досылаем их по смене состояния Auth.
      auth.addListener(_onAuthChanged);

      if (Platform.isIOS) {
        // Показ уведомлений в foreground. Делегат UNUserNotificationCenter держит
        // firebase_messaging; без этих опций alert-пуш при открытом приложении
        // не показывается вовсе (в т.ч. тестовый пуш с экрана «Разработчик»).
        try {
          await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        } catch (error, stackTrace) {
          logger.handle(error, stackTrace);
        }
      }
    }

    await syncTokens();
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
    if (!auth.isAuthorized) return;
    unawaited(syncTokens());
  }

  /// Android: FCM-токен + подписка на его обновление.
  Future<void> _syncFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await _register(
          token: token,
          type: RegisterPushToken_TokenType.FCM,
          platform: RegisterPushToken_Platform.ANDROID,
          cacheKey: _fcmCacheKey,
        );
      }

      _fcmRefreshSub ??= FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        unawaited(
          _register(
            token: token,
            type: RegisterPushToken_TokenType.FCM,
            platform: RegisterPushToken_Platform.ANDROID,
            cacheKey: _fcmCacheKey,
          ),
        );
      });
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
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
  Future<(APICallStatus, PushTest_Response?)> sendTestPush() async {
    final (status, payload) = await api.unaryEncodedWithResponse(MessageType.PUSH_TEST, PushTest_Request().writeToBuffer());
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
  }
}
