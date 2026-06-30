part of 'syncer.dart';

class Auth {
  final Logger logger;
  final Utils utils;
  final Crypto crypto;
  final Repositories repositories;

  Auth({required this.logger, required this.utils, required this.crypto, required this.repositories});

  final StreamController<bool> controllerAuth = StreamController<bool>.broadcast();

  Future<void> authRequest({required StreamController<SyncerMessageRequest>? controller, required int seq, required models.Session session}) async {
    if (controller == null) return;

    if (!session.isActive) {
      logger.warning("Syncer the subscriber has connected without an active session, seq=$seq");
      controllerAuth.add(false);
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

  Future<void> authResponse({required List<int> msg, required Header header, required models.Session session}) async {
    if (session.session.toString() != header.session.toString()) {
      logger.warning("Syncer invalid session");
      controllerAuth.add(false);
      return;
    }

    final messageByte = await crypto.syncer.decode(
      session: session,
      message: Uint8List.fromList(msg),
      messageType: SyncerMessageType.authResponse,
    );

    final proto = message.AuthResponse.fromBuffer(messageByte);
    await repositories.users.setSalt(salt: proto.salt, session: session);

    final dateTime = DateTime.fromMicrosecondsSinceEpoch(
      proto.serverAt.seconds.toInt() * 1000000 + proto.serverAt.nanos ~/ 1000,
      isUtc: true,
    );

    logger.info("Syncer response received auth userID=${session.getUserIDObjectID().toString()}, serverAt=${dateTime.toIso8601String()}");
    controllerAuth.add(true);
  }

  Future<void> logoutRequest({required StreamController<SyncerMessageRequest>? controller, required int seq, required models.Session session}) async {
    if (controller == null) return;

    final messageByte = await crypto.syncer.encode(
      session: session,
      message: message.LogoutRequest(
        action: message.LogoutAction.current,
      ).writeToBuffer(),
      messageType: SyncerMessageType.logoutRequest,
      seq: seq,
    );

    controller.add(SyncerMessageRequest(message: messageByte));

    await repositories.sessions.logout();
    controllerAuth.add(false);

    logger.info("Syncer logout user");
  }

  Future<void> logoutResponse({required List<int> msg, required Header header, required models.Session session}) async {
    if (session.session.toString() != header.session.toString()) {
      logger.warning("Syncer invalid session");
      controllerAuth.add(false);
      return;
    }
  }

}
