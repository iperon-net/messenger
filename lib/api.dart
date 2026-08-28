import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:messenger/protobuf/protos/device_info_update_v1.pb.dart';
import 'package:talker_grpc_logger/talker_grpc_logger.dart';

import 'auth.dart';
import 'models.dart' as models;
import 'utils.dart';
import 'crypto.dart';
import 'di.dart';
import 'logger.dart';
import 'repositories.dart';
import 'settings.dart';
import 'protobuf.dart';

enum APIStatus { success, error }

/// Состояние двунаправленного gRPC-стрима, наблюдаемое извне (UI/кубитами).
///
/// - [connecting] — стрим ещё не установлен или переподключается: `_open()`
///   вызван, но ни одного входящего сообщения от сервера пока не пришло, либо
///   запланировано переподключение;
/// - [updating] — стрим установлен и сейчас разбирается пачка входящих
///   сообщений (первичная синхронизация);
/// - [connected] — стрим установлен, входящие обработаны, обмен «в покое».
///
/// Паузу в фоне ([_pause]) наружу не отдаём: приложение не видно, показывать
/// статус незачем — при resume `_open()` снова выставит [connecting].
enum ApiConnectionStatus { connecting, updating, connected }

/// Входящее сообщение сервера с уже расшифрованной полезной нагрузкой.
/// Кубиты получают именно его и сразу вызывают `<Тип>_Response.fromBuffer(payload)`
/// — расшифровка сессионным ключом сделана централизованно в [API].
class IncomingMessage {
  final MessageType messageType;
  final Uint8List payload;

  const IncomingMessage({required this.messageType, required this.payload});
}

class APICallStatus {
  final APIStatus status;
  final String error;
  final int statusCode;
  final bool isGrpc;

  const APICallStatus({required this.status, this.error = "", this.isGrpc = false, required this.statusCode});

  @override
  String toString() {
    return "status=$status, error=$error, statusCode=$statusCode";
  }
}

class API {
  final logger = getIt.get<Logger>();
  final settings = getIt.get<Settings>();

  late IperonClient client;

  // Двунаправленный стрим (rpc Stream в v1.proto).
  //
  // `_outgoing` — очередь исходящих сообщений, которые уходят серверу;
  // `_incoming` — широковещательный поток входящих сообщений, на который
  // подписываются несколько слушателей (кубиты).
  //
  // Открыт ли стрим, решает координатор [_reconcile] по двум условиям:
  // пользователь авторизован ([_authorized], ставит `Auth`) и приложение на
  // переднем плане ([_appActive], ставит наблюдатель жизненного цикла). При
  // уходе в фон стрим мягко ставится на паузу ([_pause]) — рвётся только gRPC-
  // соединение, а broadcast `_incoming` остаётся живым, чтобы подписки кубитов
  // пережили паузу. Полное закрытие ([_close]) — только на разлогин/выход.
  StreamController<Message>? _outgoing;
  StreamController<IncomingMessage>? _incoming;
  StreamSubscription<Message>? _incomingSubscription;
  ResponseStream<Message>? _responseStream;

  Timer? _reconnectTimer;

  // Фиксированная пауза перед переподключением стрима.
  static const Duration _reconnectDelay = Duration(seconds: 3);

  // Троттлинг DEVICE_INFO_UPDATE: шлём не чаще раза в этот интервал на устройство,
  // чтобы не долбить БД сервера при каждом переподключении/resume из фона. Метка
  // последней отправки (мс эпохи) хранится в локальном кэше по этому ключу.
  static const Duration _deviceInfoUpdateInterval = Duration(hours: 3);
  static const String _deviceInfoUpdateCacheKey = 'device_info_update_sent_at';

  // Условия работы стрима и отложенная пауза.
  bool _authorized = false;
  bool _appActive = true;
  Timer? _pauseTimer;

  // Задержка перед паузой при уходе в фон: быстрый «свернул-развернул» не должен
  // пересобирать gRPC-соединение.
  static const Duration _backgroundGrace = Duration(seconds: 3);

  // Стрим должен работать, только когда пользователь авторизован и приложение
  // на переднем плане.
  bool get _shouldRun => _authorized && _appActive;

  // Соединение считается открытым, пока жив исходящий контроллер.
  bool get _isRunning => _outgoing != null && !_outgoing!.isClosed;

  // Цепочка последовательной обработки входящих сообщений. Колбэк `.listen`
  // не умеет ждать `await`, поэтому каждое сообщение дообрабатывается в этой
  // цепочке: следующее не начнёт обрабатываться, пока не завершится предыдущее.
  // Это гарантирует порядок и корректную запись в БД.
  Future<void> _processingChain = Future.value();

  // Сколько входящих сообщений сейчас в очереди _processingChain. Пока счётчик
  // > 0 — идёт разбор пачки (статус updating); как только он опустеет — стрим
  // «в покое» (статус connected). См. _setConnectionStatus в _open/_dispatch.
  int _pendingIncoming = 0;

  /// Входящие сообщения сервера с уже расшифрованной нагрузкой. Широковещательный
  /// поток — можно слушать из нескольких мест. Подписка не запускает соединение
  /// сама по себе; открытием стрима управляет координатор [_reconcile].
  Stream<IncomingMessage> get incoming {
    _incoming ??= StreamController<IncomingMessage>.broadcast();
    return _incoming!.stream;
  }

  // Текущее состояние стрима и широковещательный поток его изменений. Стартовое
  // значение — connecting: пока стрим не установлен, мы «соединяемся».
  ApiConnectionStatus _connectionStatus = ApiConnectionStatus.connecting;
  StreamController<ApiConnectionStatus>? _connectionStatusController;

  /// Текущее состояние gRPC-стрима без подписки (для стартового значения в UI).
  ApiConnectionStatus get connectionStatus => _connectionStatus;

  /// Изменения состояния gRPC-стрима. Широковещательный поток — можно слушать из
  /// нескольких мест (например, из кубита статуса соединения). Значения приходят
  /// только при смене статуса; текущее берётся из [connectionStatus].
  Stream<ApiConnectionStatus> get connectionStatusStream {
    _connectionStatusController ??= StreamController<ApiConnectionStatus>.broadcast();
    return _connectionStatusController!.stream;
  }

  /// Единая точка смены состояния стрима: не эмитит дубликаты и защищена от
  /// уже закрытого контроллера.
  void _setConnectionStatus(ApiConnectionStatus status) {
    if (_connectionStatus == status) return;
    _connectionStatus = status;
    final controller = _connectionStatusController;
    if (controller != null && !controller.isClosed) {
      controller.add(status);
    }
  }

  /// Отдельный поток расшифрованных полезных нагрузок только заданного [type].
  /// Каждый кубит подписывается на свой тип, не видит чужих сообщений и не знает
  /// про шифрование. Поток широковещательный (наследует [incoming]) и переживает
  /// переподключения стрима.
  ///
  /// Пример в кубите:
  /// ```dart
  ///  class SessionsCubit extends Cubit<SessionsState> {
  ///     SessionsCubit() : super(SessionsState()) {
  ///       _sub = api.on(MessageType.SESSIONS).listen((payload) {
  ///         final response = Sessions_Response.fromBuffer(payload);
  ///         // обновить state ...
  ///       });
  ///     }
  ///
  ///     final api = getIt.get<API>();
  ///     late final StreamSubscription<Uint8List> _sub;
  ///
  ///     @override
  ///     Future<void> close() {
  ///       _sub.cancel();
  ///       return super.close();
  ///     }
  ///   }
  /// ```
  Stream<Uint8List> on(MessageType type) {
    return incoming.where((message) => message.messageType == type).map((message) => message.payload);
  }

  API() {
    logger.debug('API channel target: secure=${settings.apiSecure} ${settings.apiHost}:${settings.apiPort}');

    final clientChannel = ClientChannel(
      settings.apiHost,
      port: settings.apiPort,

      options: ChannelOptions(
        credentials: settings.apiSecure ? const ChannelCredentials.secure() : const ChannelCredentials.insecure(),
        connectionTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30), // The maximum allowed time to wait for a connection to be established
        userAgent: "Iperon/0.0.1",
        idleTimeout: const Duration(minutes: 5),
        backoffStrategy: (lastBackoff) {
          final base = lastBackoff == null ? const Duration(seconds: 1) : lastBackoff * 1.6;
          final capped = base > const Duration(seconds: 30) ? const Duration(seconds: 30) : base;
          return capped + Duration(milliseconds: Random().nextInt(1000));
        },
        keepAlive: const ClientKeepAliveOptions(
          pingInterval: Duration(seconds: 30),
          timeout: Duration(seconds: 5),
          permitWithoutCalls: true,
        ),
        codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
      ),
      channelShutdownHandler: () {
        logger.debug('channelShutdownHandler');
      },
    );

    client = IperonClient(clientChannel, interceptors: [TalkerGrpcLogger(talker: logger.talker)]);
  }

  Future<APICallStatus> call(Function() func) async {
    Logger logger = getIt.get<Logger>();

    try {
      await func();
    } on GrpcError catch (err) {
      logger.logCustom(GrpcErrorLog(err.toString()));

      if ([StatusCode.unauthenticated].contains(err.code)) {
        // Сервер отозвал сессию: удаляем активную сессию из БД и через
        // notifyListeners() уводим пользователя на /auth (см. Auth.logout).
        // Fire-and-forget: не гейтим ответ вызывающему коду на разлогине.
        unawaited(getIt.get<Auth>().logout());
        return APICallStatus(status: APIStatus.error, error: "grpcError.unauthenticated", isGrpc: true, statusCode: err.code);
      } else if ([StatusCode.unknown, StatusCode.unavailable].contains(err.code)) {
        return APICallStatus(status: APIStatus.error, error: "grpcError.errorConnectingServer", isGrpc: true, statusCode: err.code);
      } else if ([StatusCode.deadlineExceeded].contains(err.code)) {
        return APICallStatus(status: APIStatus.error, error: "grpcError.unableConnectServer", isGrpc: true, statusCode: err.code);
      } else if ([StatusCode.cancelled, StatusCode.invalidArgument].contains(err.code)) {
        return APICallStatus(status: APIStatus.error, error: err.message.toString(), statusCode: err.code);
      } else if ([StatusCode.internal].contains(err.code)) {
        return APICallStatus(status: APIStatus.error, error: "grpcError.internalServerError", isGrpc: true, statusCode: err.code);
      } else {
        return APICallStatus(status: APIStatus.error, error: err.message.toString(), statusCode: err.code);
      }
    }

    return const APICallStatus(status: APIStatus.success, statusCode: 0);
  }

  /// Сообщает, авторизован ли пользователь. Вызывается из `Auth` при старте,
  /// логине и logout. Стрим сам поднимется/закроется через [_reconcile].
  void setAuthorized(bool value) {
    if (_authorized == value) return;
    _authorized = value;
    _reconcile();
  }

  /// Сообщает, на переднем ли плане приложение. Вызывается наблюдателем
  /// жизненного цикла (`didChangeAppLifecycleState`).
  void setForeground(bool value) {
    if (_appActive == value) return;
    _appActive = value;
    _reconcile();
  }

  /// Полностью закрывает стрим (в т.ч. broadcast) при завершении приложения
  /// (`AppLifecycleState.detached`).
  Future<void> shutdown() async {
    _appActive = false;
    _authorized = false;
    await _close();
  }

  /// Единая точка решения: держать ли стрим открытым. Гейтит по [_shouldRun].
  /// - авторизован + на переднем плане → открыть ([_open]);
  /// - разлогинен → полностью закрыть ([_close]) сразу;
  /// - в фоне (но авторизован) → мягкая пауза ([_pause]) через грейс-период.
  void _reconcile() {
    if (_shouldRun) {
      _pauseTimer?.cancel();
      _pauseTimer = null;
      _open();
      return;
    }

    if (!_authorized) {
      _pauseTimer?.cancel();
      _pauseTimer = null;
      _close();
      return;
    }

    // Авторизован, но ушли в фон — пауза с задержкой, чтобы не пересобирать
    // соединение на быстрый «свернул-развернул».
    _pauseTimer ??= Timer(_backgroundGrace, () {
      _pauseTimer = null;
      if (!_shouldRun && _authorized) _pause();
    });
  }

  /// Открывает двунаправленный gRPC-стрим и начинает слушать входящие
  /// сообщения. Идемпотентен: при уже открытом стриме ничего не делает. При
  /// разрыве соединения переподключается с jittered exponential backoff, пока
  /// [_shouldRun] истинно.
  void _open() {
    if (_isRunning) {
      return;
    }

    _incoming ??= StreamController<IncomingMessage>.broadcast();
    _outgoing = StreamController<Message>();

    // Стрим (пере)открывается — до первого входящего мы «соединяемся».
    _setConnectionStatus(ApiConnectionStatus.connecting);

    try {
      _responseStream = client.stream(_outgoing!.stream);

      _incomingSubscription = _responseStream!.listen(
        (message) {
          // Пришло сообщение — стрим жив; пока пачка разбирается, статус
          // updating. Счётчик опустеет в _dispatch → вернём connected.
          _pendingIncoming++;
          _setConnectionStatus(ApiConnectionStatus.updating);

          // Всё обрабатываем строго по порядку в одной очереди: сначала
          // расшифровка (async), затем раздача слушателям и запись в БД.
          // Так сообщения не обрабатываются наперегонки и не перемешиваются.
          _processingChain = _processingChain
              .then((_) => _dispatch(message))
              .catchError((error, stackTrace) => logger.handle(error, stackTrace))
              .whenComplete(() {
                if (--_pendingIncoming <= 0) {
                  _pendingIncoming = 0;
                  _setConnectionStatus(ApiConnectionStatus.connected);
                }
              });
        },
        onError: (error, stackTrace) {
          logger.handle(error, stackTrace);

          // Сервер отозвал сессию прямо на стриме: не переподключаемся (это
          // бесполезно — сервер снова ответит UNAUTHENTICATED), а разлогиниваем.
          // logout() удалит активную сессию из БД и через notifyListeners()
          // уведёт пользователя на /auth; заодно setAuthorized(false) закроет стрим.
          if (error is GrpcError && error.code == StatusCode.unauthenticated) {
            unawaited(getIt.get<Auth>().logout());
            return;
          }

          _scheduleReconnect();
        },
        onDone: _scheduleReconnect,
        cancelOnError: true,
      );

      logger.debug('gRPC stream opened -> ${settings.apiHost}:${settings.apiPort}');

      // Сообщаем серверу, что стрим открыт (в т.ч. после каждого переподключения
      // и resume из фона). Fire-and-forget: не гейтим на этом остальной трафик —
      // прикладные запросы уходят независимо.
      _subscribe();
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
      _scheduleReconnect();
    }
  }

  /// Отправляет серверу [Subscribe] — сигнал, что стрим открыт и готов получать
  /// пуш-сообщения. Вызывается при каждом открытии стрима ([_open]). Шифрование
  /// асинхронно, поэтому сообщение кладём в тот `_outgoing`, что актуален уже
  /// после шифрования: если за это время стрим переподключился — подписываем
  /// новый (живой) стрим, а не роняем подписку. Fire-and-forget: ошибки в лог,
  /// открытие стрима не роняем; прикладные [send] работают независимо.
  void _subscribe() {
    unawaited(
      () async {
        // _open() вызывается ещё из Auth.initialization() (через setAuthorized),
        // когда Auth/Crypto ещё не зарегистрированы в get_it. Ждём готовности DI,
        // иначе getIt.get<Auth>() бросит «not ready yet» и подписка не уйдёт.
        await getIt.allReady();

        final crypto = getIt.get<Crypto>();
        final auth = getIt.get<Auth>();

        // Send subscribe
        final encodedSubscribe = await crypto.syncer.encode(session: auth.session, message: Subscribe_Request().writeToBuffer());

        final outgoing = _outgoing;
        if (outgoing == null || outgoing.isClosed) {
          logger.debug('subscribe skipped: no open stream after encode');
          return;
        }

        outgoing.add(Message(messageType: MessageType.SUBSCRIBE, message: encodedSubscribe));
        // «queued», а не «sent»: gRPC-стрим ленивый, сообщение уходит из буфера
        // _outgoing только когда соединение реально установится. Если коннект
        // упадёт — буфер выбросится, и subscribe переотправится на следующем _open.
        logger.debug('subscribe queued to stream');

        // DEVICE_INFO_UPDATE троттлится (см. _deviceInfoUpdateInterval): SUBSCRIBE
        // обязателен на каждое открытие стрима, а инфо об устройстве меняется
        // редко — незачем слать её при каждом переподключении/resume из фона.
        await _sendDeviceInfoUpdate(crypto: crypto, auth: auth);
      }().catchError((Object error, StackTrace stackTrace) {
        logger.handle(error, stackTrace);
      }),
    );
  }

  /// Ставит в очередь DEVICE_INFO_UPDATE, но не чаще раза в
  /// [_deviceInfoUpdateInterval] на устройство. Метка последней отправки лежит в
  /// локальном кэше (ключ [_deviceInfoUpdateCacheKey]) по userID активной сессии:
  /// при смене аккаунта у нового userID своя метка, апдейт уйдёт сразу. Проверка
  /// делается до шифрования, чтобы в окне троттлинга не тратить и crypto-работу.
  Future<void> _sendDeviceInfoUpdate({required Crypto crypto, required Auth auth}) async {
    final repositories = getIt.get<Repositories>();
    final userID = Uint8List.fromList(auth.session.userID);

    final now = DateTime.now().millisecondsSinceEpoch;
    final lastSent = await repositories.cache.getInt(userID: userID, key: _deviceInfoUpdateCacheKey);
    if (lastSent != null && now - lastSent < _deviceInfoUpdateInterval.inMilliseconds) {
      logger.debug('device info update skipped (throttled)');
      return;
    }

    final utils = getIt.get<Utils>();
    final packageInfo = await utils.packageInfo();
    final deviceInfo = await utils.deviceInfo();

    final encodedDeviceInfoUpdate = await crypto.syncer.encode(
      session: auth.session,
      message: DeviceInfoUpdate_Request(
        deviceModel: deviceInfo.deviceModel,
        os: deviceInfo.osCode,
        osVersion: deviceInfo.osVersion,
        appVersion: packageInfo.appVersion,
        appBuildNumber: packageInfo.appBuildNumber,
      ).writeToBuffer(),
    );

    final outgoing = _outgoing;
    if (outgoing == null || outgoing.isClosed) {
      logger.debug('device info update skipped: no open stream after encode');
      return;
    }

    outgoing.add(Message(messageType: MessageType.DEVICE_INFO_UPDATE, message: encodedDeviceInfoUpdate));
    // Метку ставим только после постановки в живой буфер: если стрим успел
    // закрыться (проверка выше), апдейт не ушёл — оставляем метку старой, чтобы
    // он гарантированно ушёл на следующем открытии стрима.
    await repositories.cache.setInt(userID: userID, key: _deviceInfoUpdateCacheKey, value: now);
    logger.debug('device info update queued to stream');
  }

  /// Расшифровывает сообщение, раздаёт его живым слушателям ([incoming]/[on])
  /// и передаёт в персистентную обработку. Вызывается строго последовательно
  /// через [_processingChain].
  Future<void> _dispatch(Message message) async {
    final crypto = getIt.get<Crypto>();
    final auth = getIt.get<Auth>();

    // Сессия могла быть удалена (logout / терминация текущей сессии), пока это
    // сообщение стояло в очереди _processingChain. Расшифровка пустым сессионным
    // ключом всё равно упадёт с MAC-ошибкой — просто отбрасываем сообщение.
    if (!auth.isAuthorized) {
      logger.debug('dispatch skipped: no active session');
      return;
    }

    // Весь трафик по стриму зашифрован сессионным ключом — расшифровываем
    // централизованно, чтобы кубиты не знали про crypto/auth.
    final decoded = await crypto.syncer.decode(session: auth.session, message: Uint8List.fromList(message.message));
    final payload = Uint8List.fromList(decoded);

    final incoming = IncomingMessage(messageType: message.messageType, payload: payload);

    // Живым слушателям (UI/кубитам).
    _incoming?.add(incoming);

    // Персистентность.
    await _handleMessage(incoming, auth.session);
  }

  /// Асинхронная запись входящего сообщения в БД. Вызывается строго
  /// последовательно (см. [_dispatch]/[_processingChain]), поэтому здесь можно
  /// спокойно `await` — следующее сообщение дождётся завершения текущего.
  /// [message.payload] уже расшифрован.
  ///
  /// Это единственное место, куда стоит добавлять персистентность входящих
  /// сообщений: `<Тип>_Response.fromBuffer(message.payload)` в зависимости от
  /// `message.messageType`.
  Future<void> _handleMessage(IncomingMessage message, models.Session session) async {
    final repositories = getIt.get<Repositories>();

    switch (message.messageType) {
      case MessageType.DEVICE_SESSIONS:
        final payload = DeviceSessions_Response.fromBuffer(message.payload);

        List<models.DeviceSessionsModel> deviceSessionsModel = [];
        for (final item in payload.results) {
          deviceSessionsModel.add(
            models.DeviceSessionsModel(
              sessionID: Uint8List.fromList(item.sessionID),
              updateAt: item.updateAt.toDateTime(),
              deviceModel: item.deviceModel,
              os: item.os,
              osVersion: item.osVersion,
              appVersion: item.appVersion,
              appBuildNumber: item.appBuildNumber,
              locationEnglish: item.locationEnglish,
              locationRussian: item.locationRussian,
            ),
          );
        }
        logger.debug(deviceSessionsModel);
        await repositories.deviceSessions.deleteAndCreate(deviceSessionsModel: deviceSessionsModel, userID: session.userID);

      case MessageType.MY_PROFILE:
        final payload = MyProfile_Response.fromBuffer(message.payload);

        await repositories.myProfile.update(
          userID: session.userID,
          fistName: payload.firstName,
          lastName: payload.lastName,
          birthDate: payload.hasBirthDate() ? payload.birthDate.toDateTime(toLocal: true) : null,
          aboutMe: payload.aboutMe,
        );

      case MessageType.LOGOUT:
        // Сервер принудительно отзывает сессии (например, разлогин с другого
        // устройства). Пустой список sessionID означает «разлогинить текущую
        // сессию»; иначе разлогиниваемся, только если текущая сессия есть
        // среди отозванных. Auth.logout() снесёт её из БД и через
        // notifyListeners() уведёт go_router на /auth. Разлогин чужих сессий
        // нас здесь не касается — их отобразит следующий DEVICE_SESSIONS.
        final payload = Logout_Request.fromBuffer(message.payload);
        final revoked = payload.sessionID.isEmpty || payload.sessionID.any((id) => listEquals(id, session.sessionID));
        if (revoked) {
          await getIt.get<Auth>().logout();
        }

      // TODO: добавить ветки под реальные серверные типы. Репозитории берутся
      // лениво — API не зависит от Repositories в графе DI, но к моменту прихода
      // сообщений по стриму они гарантированно готовы. Пример записи в БД:
      //
      // case MessageType.SOME_INCOMING_MESSAGE:
      //   final repositories = getIt.get<Repositories>();
      //   final payload = SomeMessage_Response.fromBuffer(message.payload);
      //   await repositories.messages.create(...);
      //   break;

      default:
        // Неизвестные/необрабатываемые типы просто логируем — они уже ушли
        // живым слушателям через broadcast `incoming`.
        logger.debug('unhandled stream message type: ${message.messageType}');
    }
  }

  /// Отправляет сообщение в стрим. Если стрим не должен работать (разлогин или
  /// фон) — сообщение отбрасывается с логом, а не поднимает соединение «из
  /// ниоткуда». Если работать должен, но соединение сейчас переустанавливается,
  /// поднимает его и ставит сообщение в очередь.
  void send(Message message) {
    if (!_shouldRun) {
      logger.warning('send() dropped: stream is not running (authorized=$_authorized, foreground=$_appActive)');
      return;
    }

    if (!_isRunning) {
      _open();
    }

    _outgoing?.add(message);
  }

  /// Шифрует [payload] сессионным ключом, упаковывает в [Message] с заданным
  /// [type] и отправляет в стрим. Симметрично приёму ([_dispatch]/[on]): кубиты
  /// работают с чистыми protobuf-байтами и не знают про crypto/auth.
  ///
  /// Пример в кубите:
  /// ```dart
  /// await api.sendEncoded(MessageType.SESSIONS, Sessions_Request().writeToBuffer());
  /// ```
  Future<void> sendEncoded(MessageType type, Uint8List payload) async {
    final crypto = getIt.get<Crypto>();
    final auth = getIt.get<Auth>();

    final encoded = await crypto.syncer.encode(session: auth.session, message: payload);

    send(Message(messageType: type, message: encoded));
  }

  /// Как [sendEncoded], но отправляет запрос unary-вызовом (`client.unary`), а не
  /// через persistent-стрим, и ждёт ответ. Ошибки gRPC не бросаются — маппятся в
  /// [APICallStatus] через [call].
  ///
  /// Нужно для операций, после которых стрим сразу закрывается (например,
  /// завершение текущей сессии при выходе): unary-вызов живёт в собственном
  /// request-контексте на канале и не зависит от жизни стрима, поэтому его
  /// серверная обработка не будет отменена закрытием стрима (иначе на сервере
  /// операция падает с "context canceled").
  Future<APICallStatus> unaryEncoded(MessageType type, Uint8List payload) async {
    final crypto = getIt.get<Crypto>();
    final auth = getIt.get<Auth>();

    final encoded = await crypto.syncer.encode(session: auth.session, message: payload);

    return call(() async {
      await client.unary(Message(messageType: type, message: encoded));
    });
  }

  /// Планирует переподключение стрима через фиксированные [_reconnectDelay].
  /// Ничего не делает, если стрим сейчас не должен работать (разлогин или фон).
  ///
  /// Упавший стрим рвётся сразу ([_teardownStream]), не дожидаясь таймера: пока
  /// ждём переподключение, `_isRunning` честно `false`, и [send]/[_subscribe] не
  /// копят сообщения в уже мёртвый `_outgoing` (иначе subscribe уходит в буфер
  /// закрытого канала и теряется).
  void _scheduleReconnect() {
    if (!_shouldRun) {
      return;
    }

    unawaited(_teardownStream());

    // Не плодим таймеры — одна запланированная попытка за раз.
    if (_reconnectTimer?.isActive ?? false) {
      return;
    }

    logger.debug('scheduling gRPC stream reconnect in ${_reconnectDelay.inMilliseconds}ms');

    _reconnectTimer = Timer(_reconnectDelay, () {
      _reconnectTimer = null;
      if (_shouldRun) {
        _open();
      }
    });
  }

  /// Останавливает подписку и закрывает исходящий контроллер, не трогая
  /// широковещательный [incoming] — чтобы слушатели пережили переподключение.
  /// `_outgoing` обнуляется синхронно (до `await`), чтобы `_isRunning` сразу
  /// стал ложным и [send]/[_subscribe] не писали в закрываемое соединение.
  Future<void> _teardownStream() async {
    // Стрим рвётся (разрыв/пауза/закрытие) — «в покое» больше не находимся:
    // сбрасываем счётчик разбора и возвращаем статус «соединяемся».
    _pendingIncoming = 0;
    _setConnectionStatus(ApiConnectionStatus.connecting);

    final subscription = _incomingSubscription;
    _incomingSubscription = null;
    _responseStream = null;

    final outgoing = _outgoing;
    _outgoing = null;

    await subscription?.cancel();
    if (outgoing != null && !outgoing.isClosed) {
      await outgoing.close();
    }
  }

  /// Мягкая пауза (уход в фон): рвёт только gRPC-соединение и отменяет
  /// переподключение, но оставляет broadcast [incoming] живым — чтобы подписки
  /// кубитов пережили паузу и продолжили получать сообщения после resume.
  Future<void> _pause() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    await _teardownStream();

    logger.debug('gRPC stream paused (background)');
  }

  /// Полное закрытие (logout/выход): сносит соединение вместе с broadcast
  /// [incoming] и отменяет всё запланированное.
  Future<void> _close() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _pauseTimer?.cancel();
    _pauseTimer = null;

    await _teardownStream();

    await _incoming?.close();
    _incoming = null;

    // API — долгоживущий синглтон: после разлогина/повторного входа стрим
    // откроется заново, поэтому контроллер статуса не просто закрываем, а
    // обнуляем — getter пересоздаст его лениво при следующей подписке.
    await _connectionStatusController?.close();
    _connectionStatusController = null;
    _connectionStatus = ApiConnectionStatus.connecting;

    logger.debug('gRPC stream closed');
  }
}
