part of 'syncer.dart';

class DeviceSessions {
  final Logger logger;
  final Utils utils;
  final Crypto crypto;
  final Repositories repositories;

  DeviceSessions({required this.logger, required this.utils, required this.crypto, required this.repositories});

  final StreamController<List<models.DeviceSession>> controllerDeviceSessions = StreamController<List<models.DeviceSession>>.broadcast();

  Future<void> getAllSessionRequest({required StreamController<SyncerMessageRequest>? controller, required int seq, required models.Session session}) async {
    if (controller == null) return;

    if (!session.isActive) {
      logger.warning("Syncer the subscriber has connected without an active session, seq=$seq");
      return;
    }

    final messageByte = await crypto.syncer.encode(
      session: session,
      message: message.DeviceSessionsRequest().writeToBuffer(),
      messageType: SyncerMessageType.deviceSessionsRequest,
      seq: seq,
    );

    controller.add(SyncerMessageRequest(message: messageByte));
  }

  Future<void> getAllSessionResponse({required List<int> msg, required Header header, required models.Session session}) async {
    final messageByte = await crypto.syncer.decode(
      session: session,
      message: Uint8List.fromList(msg),
      messageType: SyncerMessageType.deviceSessionsResponse,
    );

    final proto = message.DeviceSessionsResponse.fromBuffer(messageByte);

    final deviceSessions = <models.DeviceSession>[];

    for (final item in proto.deviceSessions) {

      final dateTime = DateTime.fromMicrosecondsSinceEpoch(
        item.updateAt.seconds.toInt() * 1000000 + item.updateAt.nanos ~/ 1000,
        isUtc: true,
      );

      deviceSessions.add(models.DeviceSession(
        deviceModel: item.deviceModel,
        os: item.os,
        osVersion: item.osVersion,
        appVersion: item.appVersion,
        appBuildNumber: item.appBuildNumber,
        locationRussian: item.locationRussian,
        locationEnglish: item.locationEnglish,
        updateAt: dateTime,
      ));

    }
    controllerDeviceSessions.add(deviceSessions);
  }

}
