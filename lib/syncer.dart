
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:messenger/protobuf/protos/messages/pub_sub_v1.pb.dart';

import 'api.dart';
import 'crypto.dart';
import 'di.dart';
import 'logger.dart';
import 'models/session.dart' as models;
import 'protobuf/protos/syncer_v1.pb.dart';
import 'repositories/repositories.dart';

class Syncer {
  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();
  final _repositories = getIt.get<Repositories>();
  final _crypto = getIt.get<Crypto>();

  late StreamController<SyncerMessageRequest> _controller;
  late StreamSubscription<SyncerMessageResponse> _subscription;

  Syncer() {
    _logger.info("syncer initialization");
  }

  Future<void> connect(BuildContext context) async {
    _logger.debug("syncer: connect");

    final session = await _repositories.sessions.getActive();
    _logger.debug("session=${session.session} userID=${session.userID}, sharedKey=${session.sharedKey}, sharedSalt=${session.sharedSalt}");

    _controller = StreamController<SyncerMessageRequest>(
      onListen: () async {

        final message = PubSubUser(user: true).writeToBuffer();
        final messageByte = await _crypto.syncer.encode(session: session, message: message);
        _controller.add(SyncerMessageRequest(message: messageByte));

        _logger.debug("Syncer Подписчик подключился");
      },
      onCancel: () {
        _logger.debug("Syncer Подписка отменена");
      },
    );

    final response = _api.syncer.messages(
      _controller.stream,
      options: await _api.callOptions(timeout: 3600),
    );

    _subscription = response.listen((SyncerMessageResponse data) {
        _logger.debug("Получено $data");
      },
      onError: (err) {
        _logger.error("syncer stream error: $err");
      },
      onDone: () {
        _logger.debug("syncer stream closed");
      },
      cancelOnError: true,
    );
  }

  Future<void> send(BuildContext context, {required models.Session session, required Uint8List message}) async {
    final messageByte = await _crypto.syncer.encode(session: session, message: message);
    _controller.add(SyncerMessageRequest(message: messageByte));
  }

  void pause() {
    _logger.debug("Syncer pause");
    if (!_subscription.isPaused) _subscription.pause();
  }

  void resume() {
    _logger.debug("Syncer resume");
    if (_subscription.isPaused) _subscription.resume();
  }

  void dispose() {
    _logger.debug("Syncer dispose");
    _controller.close();
  }
}
