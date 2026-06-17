
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:messenger/crypto/crypto.dart';
import 'package:pqcrypto/pqcrypto.dart';

import 'api.dart';
import 'di.dart';
import 'logger.dart';
import 'models/session.dart' as models;
import 'protobuf/messages.dart' as message;
import 'protobuf/protos/syncer_v1.pb.dart';
import 'repositories/repositories.dart';

class Syncer {
  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();
  final _repositories = getIt.get<Repositories>();
  final _crypto = getIt.get<Crypto>();
  final _random = Random();
  // final _mlkem = MLKEM768();

  late StreamController<SyncerMessageRequest> _controller;
  late StreamSubscription<SyncerMessageResponse> _subscription;

  int seq = 1;

  Syncer() {
    _logger.info("syncer initialization");
  }

  Future<void> connect(BuildContext context) async {
    final session = await _repositories.sessions.getActive();

    seq = _random.nextInt(512) * 2 + 1;

    _controller = StreamController<SyncerMessageRequest>(
      onListen: () async {

        // final (publicKey, secretKey) = MlDsa.generateKeyPair(params);


        final messageByte = await _crypto.syncer.encode(
          session: session,
          message: message.AuthRequest(session: session.session).writeToBuffer(),
          messageType: MessageType.authRequest,
          seq: seq,
        );
        _controller.add(SyncerMessageRequest(message: messageByte));

        _logger.info("Syncer the subscriber has connected userID=${session.getUserIDObjectID().toString()}, seq=$seq");
      },
      onCancel: () {
        _logger.debug("Syncer Подписка отменена");
      },
    );

    ///
    final response = _api.syncer.messages(
      _controller.stream,
      options: await _api.callOptions(timeout: 3600),
    );

    _subscription = response.listen((SyncerMessageResponse data) async {
      final header = await _crypto.syncer.headerParse(Uint8List.fromList(data.message));
      final messageByte = await _crypto.syncer.decode(
        session: session,
        message: Uint8List.fromList(data.message),
      );

      // Set new seq
      seq = header.seq;

      final proto = message.AuthResponse.fromBuffer(messageByte);

      _logger.debug("serverAt=${proto.serverAt.seconds}, seq=$seq");

      _logger.debug("Получено=${data.message}");
    },
    onError: (err) {
      _logger.error("syncer stream error: $err, рестарт коннекта");
    },
    onDone: () {
      _logger.debug("syncer stream closed рестарт коннекта");
    }, cancelOnError: true,
    );

  }

  Future<void> send(BuildContext context, {required models.Session session, required Uint8List message}) async {
    // final messageByte = await _crypto.syncer.encode(session: session, message: message, messageType: MessageType.userInfoRequest, seq: 1);
    // _controller.add(SyncerMessageRequest(message: messageByte));
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
