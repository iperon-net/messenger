part of 'syncer.dart';

class Auth {
  final Logger logger;
  final Utils utils;
  final Crypto crypto;
  final Repositories repositories;
  final Streams streams;
  final API api;

  // Геттеры актуальных значений: controller/seq/session в Syncer переприсваиваются при
  // каждом connect()/onData, поэтому храним не значение (оно устареет), а способ его получить.
  final StreamController<SyncerMessageRequest>? Function() controller;
  final int Function() seq;
  final models.Session Function() session;

  Auth({
    required this.logger,
    required this.utils,
    required this.crypto,
    required this.repositories,
    required this.streams,
    required this.api,
    required this.controller,
    required this.seq,
    required this.session,
  });

  Future<void> authRequest() async {
    final controller = this.controller();
    if (controller == null) return;

    final seq = this.seq();
    final session = this.session();

    if (!session.isActive) {
      logger.warning("Syncer the subscriber has connected without an active session, seq=$seq");
      streams.controllerAuth.add(false);
      return;
    }

    final packageInfo = await utils.packageInfo();
    final deviceInfo = await utils.deviceInfo();

    final messageByte = await crypto.syncer.encode(
      session: session,
      message: message.AuthRequest(
        session: session.session,
        osVersion: deviceInfo.osVersion,
        appVersion: packageInfo.appVersion,
        appBuildNumber: packageInfo.appBuildNumber,
      ).writeToBuffer(),
      messageType: SyncerMessageType.authRequest,
      seq: seq,
    );

    logger.debug("Syncer authRequest add (bytes=${messageByte.length}, isClosed=${controller.isClosed}, isPaused=${controller.isPaused}), seq=$seq");
    if (controller.isClosed) {
      logger.warning("Syncer authRequest: controller закрыт, add пропущен, seq=$seq");
      return;
    }
    controller.add(SyncerMessageRequest(message: messageByte));

    logger.info("Syncer the subscriber has connected userID=${session.getUserIDObjectID().toString()}, seq=$seq");
  }

  Future<void> authResponse({required List<int> msg, required Header header}) async {
    final session = this.session();

    if (!ListEquality().equals(session.session, header.session)) {
      logger.warning("Syncer invalid session");
      streams.controllerAuth.add(false);
      return;
    }

    final messageByte = await crypto.syncer.decode(
      session: session,
      message: Uint8List.fromList(msg),
      messageType: SyncerMessageType.authResponse,
    );

    final proto = message.AuthResponse.fromBuffer(messageByte);
    await repositories.users.setSalt(salt: proto.salt, session: session);

    final dateTime = proto.serverAt.toDateTime();
    logger.info("Syncer response received auth userID=${session.getUserIDObjectID().toString()}, serverAt=${dateTime.toIso8601String()}");
    streams.controllerAuth.add(true);
  }

  Future<void> logoutRequest() async {
    final seq = this.seq();
    final session = this.session();

    final messageByte = await crypto.syncer.encode(
      session: session,
      message: message.LogoutRequest().writeToBuffer(),
      messageType: SyncerMessageType.logoutRequest,
      seq: seq,
    );

    try {
      await api.syncer.message(
        SyncerMessageRequest(message: messageByte),
        options: await api.callOptions(),
      );
      await repositories.sessions.logout();
      logger.info("Syncer logout user");
    } catch (err) {
      // Нет сети: сохраняем уже закодированные байты — они не зависят от сессии
      // и переживут deleteAndCreate() при следующем логине
      logger.warning("Syncer logoutRequest нет сети, отложен для повторной доставки: $err");
      await repositories.sessions.logout();
      await repositories.pendingLogouts.add(encodedMessage: messageByte);
    }

    streams.controllerAuth.add(false);
  }

  Future<void> retryPendingLogouts() async {
    final pending = await repositories.pendingLogouts.getAll();
    if (pending.isEmpty) return;

    for (final entry in pending) {
      try {
        await api.syncer.message(
          SyncerMessageRequest(message: entry.encodedMessage),
          options: await api.callOptions(),
        );
        await repositories.pendingLogouts.delete(id: entry.id);
        logger.info("Syncer retryPendingLogout: logout доставлен серверу (id=${entry.id})");
      } on GrpcError catch (err) {
        if (err.code == StatusCode.unauthenticated) {
          // Сессия уже не существует на сервере — удаляем без доставки
          await repositories.pendingLogouts.delete(id: entry.id);
          logger.warning("Syncer retryPendingLogout: сессия устарела, удалён локально (id=${entry.id})");
        } else {
          logger.warning("Syncer retryPendingLogout: нет сети ($err)");
          break;
        }
      } catch (err) {
        logger.warning("Syncer retryPendingLogout: нет сети ($err)");
        break;
      }
    }
  }

  Future<void> logoutResponse({required List<int> msg, required Header header}) async {
    final session = this.session();

    // Сообщение адресовано конкретной сессии (NATS subject sessionID.<hex>) и шифруется
    // сервером нашей сессией, поэтому header.session всегда должен совпадать с активной.
    // Чужая сессия в заголовке — не наш logout, ничего не делаем.
    if (!ListEquality().equals(session.session, header.session)) {
      logger.warning("Syncer logoutResponse: сессия в заголовке не совпадает с активной — игнор");
      return;
    }

    // Сервер разлогинил это устройство (выход с другого устройства). Выходим сразу:
    // чистим локальную сессию и оповещаем UI (controllerAuth=false) — корневой слушатель
    // уводит на /auth. Не ждём закрытия стрима и провала переавторизации на реконнекте.
    logger.info("Syncer logoutResponse: устройство разлогинено сервером — сброс сессии и редирект на /auth");
    await repositories.sessions.logout();
    streams.controllerAuth.add(false);
  }

}
