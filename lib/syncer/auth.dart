part of 'syncer.dart';

class Auth {
  final Logger logger;
  final Utils utils;
  final Crypto crypto;
  final Repositories repositories;

  Auth({required this.logger, required this.utils, required this.crypto, required this.repositories});

  Future<void> auth(StreamController<SyncerMessageRequest> controller, int seq) async {
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

}
