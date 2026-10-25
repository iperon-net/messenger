import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'api.dart';
import 'auth.dart';
import 'cdn.dart';
import 'chats/chats_mapping.dart';
import 'chats/chats_remote_data_source.dart';
import 'chats/chats_sync.dart';
import 'di.dart';
import 'logger.dart';
import 'protobuf.dart';
import 'protobuf/protos/chats_v1.pb.dart' as pb;
import 'repositories.dart';
import 'utils.dart';
import 'account_scope.dart';
import 'accounts.dart';

/// Сборка расшифровывает call-пуши — уходит в `Subscribe.Request.capabilities`:
/// сервер шлёт таким сессиям входящий/отмену звонка зашифрованным `PushPayload`
/// (`CALL_INCOMING` / `CALL_CANCEL` в поле `p`), остальным — открытой data-map.
/// Расшифровывает натив: iOS `AppDelegate` (PushKit), Android `CallFcmService`.
const callPushEncryptedCapability = 'callPushEncrypted';

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
/// код-пароля, скрытые профили и скачанные аватары отдаём в натив
/// ([_syncPushKey], [setPasscodeEnabled], [_syncHiddenUsers], [_syncAvatars]) по каналу
/// `net.iperon.messenger/push` (Android — хранилище на Keystore, iOS — общий с
/// NSE Keychain); тот же канал приносит тапы по уведомлениям ([onRoute]) и
/// кнопки уведомлений Android «Ответить» / «Прочитано» ([_handleAction]).
///
/// Регистрируется в `get_it` (см. `di.dart`, `dependsOn: [API, Auth]`) как
/// синглтон. Отправка идемпотентна: последний отправленный токен каждого канала
/// кэшируется, повтор того же токена на сервер не уходит.
class PushManager {
  final logger = getIt.get<Logger>();
  final api = getIt.get<API>();
  final auth = getIt.get<Auth>();
  final repositories = getIt.get<Repositories>();

  /// Аккаунт этого экземпляра (слот `device.db`): им помечаются ключ пушей,
  /// скрытые профили и аватары у натива — пуш знает, чей он.
  final String _account = AccountScope.current.accountID;

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
  final _avatarSubs = <StreamSubscription<void>>[];
  Timer? _avatarsTimer;
  // Подпись последнего отданного нативу снимка аватаров — без изменений не шлём.
  String? _avatarsSent;
  static const _avatarsDebounce = Duration(seconds: 2);
  // hex(cdnID) → путь к расшифрованному файлу: снимок пересобирается на
  // каждое изменение `downloads` (и прогресс вложений), а файл по cdnID
  // неизменен — в кэш скачиваний за ним не ходим повторно.
  final _avatarPaths = <String, String>{};
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
        unawaited(_setActiveAccount());
        unawaited(setPasscodeEnabled(passcodeEnabled));
        // Локально скрытые профили: их пуши натив показывает без имени и текста.
        _hiddenSub = repositories.hiddenProfiles.changes.listen((_) {
          unawaited(_syncHiddenUsers());
          _scheduleAvatars();
        });
        unawaited(_syncHiddenUsers());
        // Аватары для уведомлений: сменился у собеседника, скачался файл,
        // изменились группы.
        _avatarSubs
          ..add(repositories.profiles.avatarChanges.listen((_) => _scheduleAvatars()))
          ..add(repositories.db.onChange(const [ChatsRepository.groupsTable, 'downloads']).listen((_) => _scheduleAvatars()));
        _scheduleAvatars();
        unawaited(_takeInitialTap());
        if (Platform.isAndroid) unawaited(_takePendingActions());
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

  /// Активный аккаунт — нативу: на переднем плане он не показывает уведомления
  /// только этого аккаунта (его события приходят по стриму), пуши остальных
  /// аккаунтов показывает как обычно.
  Future<void> _setActiveAccount() async {
    try {
      await _channel.invokeMethod<void>('setActiveAccount', {'account': _account});
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
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
    if (_hasNativePush) {
      // Скрытые профили свои у каждого аккаунта.
      unawaited(_syncHiddenUsers());
      _scheduleAvatars();
    }
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
        await forgetAccount(_account);
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
        'account': _account,
        'accountName': await _accountName(),
      });
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Подпись аккаунта в уведомлениях (когда их несколько): имя профиля,
  /// иначе номер.
  Future<String> _accountName() async {
    for (final slot in await getIt.get<DeviceRepositories>().accounts.all()) {
      if (slot.accountID == _account) return slot.name.isNotEmpty ? slot.name : '+${slot.phoneNumber}';
    }
    return '';
  }

  /// Аккаунт [account] ушёл с устройства (выход): натив забывает его ключи,
  /// аватары, уведомления и шорткаты.
  static Future<void> forgetAccount(String account) async {
    if (!_hasNativePush || account.isEmpty) return;
    try {
      await _channel.invokeMethod<void>('removeAccount', {'account': account});
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  /// Включён ли код-пароль (и не разрешено ли «Имя и текст в уведомлениях»):
  /// натив тогда показывает уведомления без имени и текста. Зовётся на старте,
  /// при смене кода и тумблера (CommonCubit).
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
      await _channel.invokeMethod<void>('setHiddenUsers', {'account': _account, 'users': hidden.keys.toList()});
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  void _scheduleAvatars() {
    _avatarsTimer?.cancel();
    _avatarsTimer = Timer(_avatarsDebounce, () => unawaited(_syncAvatars()));
  }

  /// Отдаёт нативу уже скачанные аватары собеседников (`u<userID>`) и групп
  /// (`c<chatID>`): уведомление показывает их вместо иконки приложения, а она
  /// становится маленьким значком в углу (iOS — Communication Notifications,
  /// Android — беседы). Сам натив их скачать не может (файлы на CDN
  /// зашифрованы), поэтому только то, что уже есть в кэше. Снимок полный:
  /// натив копирует (уменьшив) новые и сменившиеся, удаляет пропавшие.
  /// Скрытые профили не отдаём, разлогинились — пустой снимок.
  Future<void> _syncAvatars() async {
    try {
      final avatars = <String, ({String id, String path})>{};
      if (auth.isAuthorized) {
        final cdn = getIt.get<CDNManager>();
        final hidden = await repositories.hiddenProfiles.hashByHex();
        Future<void> add(String key, List<int> cdnID) async {
          final id = _hex(cdnID);
          final path = _avatarPaths[id] ?? (await cdn.cachedFile(Uint8List.fromList(cdnID)))?.path;
          if (path == null) return;
          _avatarPaths[id] = path;
          avatars[key] = (id: id, path: path);
        }

        for (final row in await repositories.profiles.readyAvatars()) {
          final user = _hex(row.userID);
          if (!hidden.containsKey(user)) await add('u$user', row.cdnID);
        }
        for (final group in await repositories.chats.groups(userID: auth.session.userID)) {
          if (group.info.avatarCdnID.isNotEmpty) await add('c${_hex(group.chatID)}', group.info.avatarCdnID);
        }
      }

      final keys = avatars.keys.toList()..sort();
      final signature = [for (final key in keys) '$key=${avatars[key]!.id}'].join(',');
      if (signature == _avatarsSent) return;
      await _channel.invokeMethod<void>('syncAvatars', {
        'account': _account,
        'entries': [
          for (final key in keys) {'key': key, 'id': avatars[key]!.id, 'path': avatars[key]!.path},
        ],
      });
      _avatarsSent = signature;
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// iOS: приложение запущено системой в фоне (VoIP / тихий пуш) и пользователь
  /// его ещё не открыл — `UIApplication.applicationState == .background`.
  /// Жизненный цикл Flutter в таком запуске не приходит, поэтому спрашиваем
  /// натив. На прочих платформах и при ошибке — `false` (как раньше: стрим =
  /// передний план).
  ///
  /// Android: движок без видимой Activity — его подняла кнопка уведомления
  /// («Ответить» / «Прочитано»), пользователь приложение не открывал.
  static Future<bool> isLaunchedInBackground() async {
    if (!_hasNativePush) return false;
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
  ///
  /// [count] — непрочитанные активного аккаунта; на иконке натив показывает
  /// сумму с последними числами остальных аккаунтов (из их пушей). Android
  /// иконку не трогает (её рисует лаунчер) — только запоминает число для
  /// [accountBadges].
  static Future<void> setBadge(int count) async {
    if (!_hasNativePush) return;
    // info — в файловый лог: по нему видно, ставило ли приложение счётчик.
    getIt.get<Logger>().info('badge: set $count');
    try {
      await _channel.invokeMethod<void>('setBadge', {'account': AccountScope.current.accountID, 'count': count});
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  /// Последние непрочитанные каждого аккаунта (accountID → число): у
  /// неактивных — из их пушей (сервер считает так же, как [ChatsSync.unread]),
  /// у активного — из [setBadge]. Неизвестно — аккаунта нет в ответе.
  static Future<Map<String, int>> accountBadges() async {
    if (!_hasNativePush) return const {};
    try {
      final badges = await _channel.invokeMapMethod<String, int>('accountBadges');
      return badges ?? const {};
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
      return const {};
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
        'account': AccountScope.current.accountID,
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
    switch (call.method) {
      case 'onNotificationTap':
        await _handleTap(call.arguments);
      case 'onNotificationAction':
        // Не ждём: натив держит процесс до notificationActionDone, а ответ
        // канала ему не нужен.
        unawaited(_handleAction(call.arguments));
    }
    return null;
  }

  /// Кнопки уведомлений, нажатые до готовности Dart (холодный старт движка).
  Future<void> _takePendingActions() async {
    try {
      final actions = await _channel.invokeMethod<List<Object?>>('takePendingActions');
      for (final action in actions ?? const <Object?>[]) {
        await _handleAction(action);
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  // Сколько ждём, пока ответ из шторки уйдёт из outbox, прежде чем отпустить
  // процесс (натив держит его ~9 с). Не успели — сообщение в outbox и уйдёт
  // при следующем подключении.
  static const _replyFlushTimeout = Duration(seconds: 8);
  static const _replyFlushPoll = Duration(milliseconds: 300);

  /// Кнопка уведомления чата (Android, NotificationActionReceiver): `reply` —
  /// сообщение [text] в чат (через outbox, как из окна чата: без сети оно
  /// уйдёт при подключении) и «прочитано»; `read` — «прочитано» до `maxID`
  /// (последнее сообщение уведомления). Само уведомление натив уже обновил.
  /// В конце отпускает процесс (`notificationActionDone`).
  Future<void> _handleAction(Object? arguments) async {
    final action = arguments as Map? ?? const {};
    if (action['action'] == 'callDecline') return _declineCall(action);
    // Кнопка уведомления другого аккаунта — выполняет его PushManager (после
    // переключения на этот аккаунт).
    if (await _switchTo((action['account'] as String?) ?? '')) {
      return getIt.get<PushManager>()._handleAction(arguments);
    }
    final chatID = ((action['chatID'] as String?) ?? '').toLowerCase();
    final maxID = (action['maxID'] as num?)?.toInt() ?? 0;
    logger.info('push: notification action ${action['action']} chat=$chatID');
    try {
      if (!auth.isAuthorized || !_chatIDPattern.hasMatch(chatID)) return;
      switch (action['action']) {
        case 'reply':
          final text = ((action['text'] as String?) ?? '').trim();
          if (text.isEmpty) return;
          await ChatsRemoteDataSource.instance.sendMessage(chatID, text: text);
          await _readHistory(chatID, maxID);
          await _waitOutbox(chatID);
        case 'read':
          await _readHistory(chatID, maxID);
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    } finally {
      await _actionDone(action);
    }
  }

  /// «Отклонить» входящего, нажатое, пока приложение было выгружено (Android,
  /// `CallDeclineBridge`: событие плагина некому было слушать, натив поднял
  /// движок ради него). Отказ — unary от сессии аккаунта, которому звонили,
  /// без переключения; без сети звонящий дождётся таймаута.
  Future<void> _declineCall(Map action) async {
    final callId = (action['callId'] as String?) ?? '';
    final fromUserID = (action['fromUserID'] as String?) ?? '';
    final account = (action['account'] as String?) ?? '';
    logger.info('push: call decline from native callId=$callId');
    try {
      if (callId.isEmpty || fromUserID.isEmpty) return;
      final toUserID = getIt.get<Utils>().hexToBytes(fromUserID);
      if (account.isNotEmpty && account != AccountScope.current.accountID) {
        await rejectCallAs(account, callId: callId, toUserID: toUserID);
      } else if (auth.isAuthorized) {
        final ring = CallRing(callId: callId, toUserID: Uint8List.fromList(toUserID));
        await api.unaryEncoded(MessageType.CALL_REJECT, ring.writeToBuffer());
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    } finally {
      await _actionDone(action);
    }
  }

  /// Действие доделано: стрим не держим, если подняты без Activity (пауза
  /// через грейс, откроет пользователь — resumed вернёт его), и отпускаем
  /// процесс (`notificationActionDone`).
  Future<void> _actionDone(Map action) async {
    if (Platform.isAndroid && await isLaunchedInBackground()) api.setForeground(false);
    try {
      await _channel.invokeMethod<void>('notificationActionDone', action['id']);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// «Прочитано» до [maxID] — напрямую по id из уведомления: локальный кэш
  /// после пуша мог ещё не догнать чат. Без id — как при открытии чата. Без
  /// сети — молча (счётчик честно останется).
  Future<void> _readHistory(String chatID, int maxID) async {
    if (maxID <= 0) {
      await ChatsRemoteDataSource.instance.setRead(chatID, true);
      return;
    }
    final sync = ChatsSync.instance;
    if (!await sync.hasNetwork()) return;
    try {
      final response = await sync.chats(
        pb.Chats_Request(
          readHistory: pb.Chats_ReadHistory(chatID: idBytes(chatID), maxID: Int64(maxID)),
        ),
      );
      await sync.applyUpdates(response.readHistory.updates);
    } on ChatsOfflineException {
      // Прочитаем при следующем открытии чата.
    }
  }

  /// Ждёт, пока outbox чата не опустеет (или [_replyFlushTimeout]); без сети
  /// не ждёт — отправка всё равно отложится.
  Future<void> _waitOutbox(String chatID) async {
    final chat = idBytes(chatID);
    final deadline = DateTime.now().add(_replyFlushTimeout);
    while (DateTime.now().isBefore(deadline)) {
      if (!await getIt.get<Utils>().hasNetwork()) return;
      final rows = await repositories.chats.outbox(userID: ChatsSync.instance.me, chatID: chat);
      if (rows.every((row) => row.failed)) return;
      await Future<void>.delayed(_replyFlushPoll);
    }
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
    // Уведомление другого аккаунта — сначала переключиться на него (как в
    // Telegram), переход — уже его PushManager.
    if (await _switchTo((tap?['account'] as String?) ?? '')) {
      return getIt.get<PushManager>()._handleTap(arguments);
    }
    final kind = PushPayload_Kind.valueOf((tap?['kind'] as int?) ?? 0);
    var route = routeForKind(
      kind,
      chatID: (tap?['chatID'] as String?) ?? '',
      parentChatID: (tap?['parentChatID'] as String?) ?? '',
      postID: '${tap?['postID'] ?? ''}',
    );
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

  /// Переключиться на аккаунт [account] уведомления, если он не этот и на
  /// устройстве вошёл. true — переключились (продолжает новый PushManager).
  Future<bool> _switchTo(String account) async {
    if (account.isEmpty || account == _account) return false;
    final signedIn = await signedInAccounts();
    if (!signedIn.any((entry) => entry.accountID == account)) return false;
    try {
      await switchAccount(account);
      return true;
    } catch (error, stackTrace) {
      // Например, идёт звонок — остаёмся в текущем.
      logger.handle(error, stackTrace);
      return false;
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
  /// пуша); без него — в список чатов. Комментарий к посту канала (4.3,
  /// [parentChatID] — канал, [postID] — пост) — в его ветку (откроется и не
  /// бывавшая на устройстве).
  @visibleForTesting
  static String? routeForKind(PushPayload_Kind? kind, {String chatID = '', String parentChatID = '', String postID = ''}) => switch (kind) {
    PushPayload_Kind.CONTACT_JOINED => '/contacts',
    PushPayload_Kind.CALL_MISSED => '/calls',
    PushPayload_Kind.MESSAGE || PushPayload_Kind.MESSAGE_REACTION
        when _chatIDPattern.hasMatch(parentChatID) && (int.tryParse(postID) ?? 0) > 0 =>
      '/chats/comments/${parentChatID.toLowerCase()}/${int.parse(postID)}',
    PushPayload_Kind.MESSAGE ||
    PushPayload_Kind.MESSAGE_REACTION ||
    // Уведомление «Iperon» — его чат.
    PushPayload_Kind.SYSTEM_NOTICE => _chatIDPattern.hasMatch(chatID) ? '/chats/chat/${chatID.toLowerCase()}' : '/chats',
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
    _avatarsTimer?.cancel();
    _avatarsTimer = null;
    for (final sub in _avatarSubs) {
      await sub.cancel();
    }
    _avatarSubs.clear();
  }
}
