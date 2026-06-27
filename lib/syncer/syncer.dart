
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:grpc/grpc.dart';
import 'package:messenger/crypto/crypto.dart';
import 'package:messenger/utils.dart';

import '../api.dart';
import '../constants.dart';
import '../di.dart';
import '../logger.dart';
import '../models/session.dart' as models;
import '../protobuf/messages.dart' as message;
import '../protobuf/protos/syncer_v1.pb.dart';
import '../repositories/repositories.dart';

part 'sessions.dart';
part 'auth.dart';

class Syncer {
  final _logger = getIt.get<Logger>();
  final _api = getIt.get<API>();
  final _repositories = getIt.get<Repositories>();
  final _crypto = getIt.get<Crypto>();
  final _utils = getIt.get<Utils>();
  final _random = Random();

  late StreamController<SyncerMessageRequest> _controller;
  late StreamSubscription<SyncerMessageResponse> _subscription;

  int seq = 1;
  bool isAuth = false;

  late models.Session session;
  late Sessions sessions;
  late Auth auth;

  Syncer() {
    sessions = Sessions();
    auth = Auth(logger: _logger, utils: _utils, crypto: _crypto, repositories: _repositories);
    _logger.info("syncer initialization");
  }

  Future<void> connect() async {
    session = await _repositories.sessions.getActive();

    _controller = StreamController<SyncerMessageRequest>(onListen: () => _onListen(), onCancel: () => _onCancel());

    final response = _api.syncer.messages(_controller.stream, options: await _api.callOptions(timeout: 3600));

    _subscription = response.listen((data) => _onData(data), onError: (err) => _onError(err), onDone: () => _onDone(), cancelOnError: true);
  }

  // Send the auth request once the subscriber has connected
  Future<void> _onListen() async {
    seq = generateRandomSeq();
    await auth.auth(_controller, seq);
  }

  // Cancel
  Future<void> _onCancel() async {
    await randomSleep(seconds: 5);
    await connect();
  }

  // onDone
  Future<void> _onDone() async {
    await randomSleep(seconds: 5);
    await connect();
    _logger.debug("syncer stream closed рестарт коннекта");
  }

  // onError
  Future<void> _onError(dynamic err) async {
    if (err is GrpcError) {
      if (err.code == StatusCode.unauthenticated) {
        return;
      }
    }
    _logger.error("syncer stream error: $err, рестарт коннекта");
  }

  Future<void> _onData(SyncerMessageResponse data) async {
    final header = await _crypto.syncer.headerParse(Uint8List.fromList(data.message));

    if (!isAuth && header.messageType == SyncerMessageType.authResponse) {
      final messageByte = await _crypto.syncer.decode(
        session: session,
        message: Uint8List.fromList(data.message),
        messageType: SyncerMessageType.authResponse,
      );

      // Set new seq
      seq = header.seq;

      final proto = message.AuthResponse.fromBuffer(messageByte);

      await _repositories.users.setSalt(salt: proto.salt, session: session);
      isAuth = true;
      return;
    } else if (!isAuth) {
      _logger.warning("syncer skip message, because authorization failed, seq=$seq");
      return;
    }

    // if (header.messageType == SyncerMessageType.sessionsResponse){
    //   seq = header.seq;
    //
    //   final messageByte = await _crypto.syncer.decode(
    //
    //   );
    //
    //   _logger.debug("Получено=${data.message}");
    // }

    _logger.debug("Получено=${data.message}");
  }

  // Send message
  Future<void> send({required Uint8List message, required SyncerMessageType messageType}) async {
    final messageByte = await _crypto.syncer.encode(
      session: session,
      message: message,
      messageType: messageType,
      seq: seq,
    );
    _controller.add(SyncerMessageRequest(message: messageByte));
  }

  // Generate random seq
  int generateRandomSeq() => _random.nextInt(512) * 2 + 1;

  // Random sleep
  Future<void> randomSleep({int seconds = 5}) async {
    final random = Random();
    int delaySeconds = random.nextInt(seconds) + 1;
    await Future.delayed(Duration(seconds: delaySeconds));
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
    _subscription.cancel();
    _controller.close();
  }
}
