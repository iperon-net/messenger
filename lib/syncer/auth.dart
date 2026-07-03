part of 'syncer.dart';

class Auth {
  final Logger logger;
  final Utils utils;
  final Crypto crypto;
  final Repositories repositories;
  final Streams streams;

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
    final controller = this.controller();
    if (controller == null) return;

    final seq = this.seq();
    final session = this.session();

    final messageByte = await crypto.syncer.encode(
      session: session,
      message: message.LogoutRequest().writeToBuffer(),
      messageType: SyncerMessageType.logoutRequest,
      seq: seq,
    );

    controller.add(SyncerMessageRequest(message: messageByte));

    await repositories.sessions.logout();
    streams.controllerAuth.add(false);

    logger.info("Syncer logout user");
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
