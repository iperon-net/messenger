part of 'syncer.dart';

class Auth {
  final Logger logger;
  final Utils utils;
  final Crypto crypto;
  final Repositories repositories;

  Auth({required this.logger, required this.utils, required this.crypto, required this.repositories});

  Future<void> request(StreamController<SyncerMessageRequest> controller, int seq) async {
    final session = await repositories.sessions.getActive();

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

    controller.add(SyncerMessageRequest(message: messageByte));

    logger.info("Syncer the subscriber has connected userID=${session.getUserIDObjectID().toString()}, seq=$seq");
  }

  Future<bool> response({required List<int> msg, required Header header}) async {
    final session = await repositories.sessions.getActive();
    if (session.session.toString() != header.session.toString()) {
      logger.warning("Syncer invalid session");
      return false;
    };

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

    return true;
  }

}
