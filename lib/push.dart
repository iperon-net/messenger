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

/// Регистрирует push-токены устройства на сервере, чтобы будить входящий звонок,
/// когда персистентный gRPC-стрим закрыт (приложение в фоне/выгружено) — см.
/// фазу 4 в `docs/plans/melodic-beaming-elephant.md`.
///
/// Два раздельных канала (на iOS VoIP-токен PushKit ≠ FCM-токену):
/// - **Android** — FCM data-message. Токен берём из [FirebaseMessaging]
///   ([syncFcmToken]) и переотправляем при `onTokenRefresh`.
/// - **iOS** — VoIP-токен через PushKit получаем в нативном коде и передаём сюда
///   ([registerVoipToken]); отсюда он уходит на сервер тем же RPC.
///
/// Регистрируется в `get_it` (см. `di.dart`, `dependsOn: [API, Auth]`) как
/// синглтон. Отправка идемпотентна: последний отправленный токен каждого канала
/// кэшируется, повтор того же токена на сервер не уходит.
class PushManager {
  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  // Ключи кэша последнего отправленного токена (дедуп по каналу).
  static const _fcmCacheKey = 'push_token_fcm_sent';
  static const _voipCacheKey = 'push_token_voip_sent';

  StreamSubscription<String>? _fcmRefreshSub;

  /// Синхронизирует FCM-токен (Android). На iOS ничего не делает: там звонки
  /// будятся VoIP-токеном через [registerVoipToken], а не FCM. Идемпотентно —
  /// зовём при старте (после авторизации) и на каждый resume; переотправку при
  /// смене токена обеспечивает подписка на `onTokenRefresh`.
  Future<void> syncFcmToken() async {
    if (!Platform.isAndroid) return;

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

  /// Регистрирует iOS VoIP-токен (PushKit), полученный нативным кодом. Вызывается
  /// из платформенного канала при выдаче/смене VoIP-токена.
  Future<void> registerVoipToken(String token) async {
    if (token.isEmpty) return;
    await _register(
      token: token,
      type: RegisterPushToken_TokenType.APNS_VOIP,
      platform: RegisterPushToken_Platform.IOS,
      cacheKey: _voipCacheKey,
    );
  }

  Future<void> _register({
    required String token,
    required RegisterPushToken_TokenType type,
    required RegisterPushToken_Platform platform,
    required String cacheKey,
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

    final request = RegisterPushToken_Request(token: token, type: type, platform: platform);
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
    await _fcmRefreshSub?.cancel();
    _fcmRefreshSub = null;
  }
}
