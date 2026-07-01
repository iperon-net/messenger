part of 'syncer.dart';

class DeviceSessions {
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

  DeviceSessions({
    required this.logger,
    required this.utils,
    required this.crypto,
    required this.repositories,
    required this.streams,
    required this.controller,
    required this.seq,
    required this.session,
  });

  Future<void> getAllSessionRequest() async {
    final controller = this.controller();
    if (controller == null) return;

    final seq = this.seq();
    final session = this.session();

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

  Future<void> getAllSessionResponse({required List<int> msg, required Header header}) async {
    final session = this.session();

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
        session: item.session,
        deviceModel: item.deviceModel,
        os: item.os,
        osVersion: item.osVersion,
        appVersion: item.appVersion,
        appBuildNumber: item.appBuildNumber,
        locationRussian: item.locationRussian,
        locationEnglish: item.locationEnglish,
        updateAt: dateTime,
        isCurrent: ListEquality().equals(session.session, item.session),
      ));
    }

    await repositories.deviceSessions.deleteAndCreate(session: session, deviceSessions: deviceSessions);
    streams.controllerDeviceSessions.add(deviceSessions);
  }

  Future<void> logoutSessionRequest() async {
    final controller = this.controller();
    if (controller == null) return;

    final seq = this.seq();
    final session = this.session();

    if (!session.isActive) {
      logger.warning("Syncer the subscriber has connected without an active session, seq=$seq");
      return;
    }

    // final messageByte = await crypto.syncer.encode(
    //   session: session,
    //   message: message.DeviceSessionsRequest().writeToBuffer(),
    //   messageType: SyncerMessageType.deviceSessionsRequest,
    //   seq: seq,
    // );
    //
    // controller.add(SyncerMessageRequest(message: messageByte));
  }

}
