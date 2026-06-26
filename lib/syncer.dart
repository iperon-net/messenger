
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:grpc/grpc.dart';
import 'package:messenger/crypto/crypto.dart';
import 'package:messenger/utils.dart';

import 'api.dart';
import 'constants.dart';
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
  final _utils = getIt.get<Utils>();
  final _random = Random();

  late StreamController<SyncerMessageRequest> _controller;
  late StreamSubscription<SyncerMessageResponse> _subscription;

  int seq = 1;
  late models.Session session;

  Syncer() {
    _logger.info("syncer initialization");
  }

  Future<void> connect(BuildContext context) async {
    session = await _repositories.sessions.getActive();

    seq = generateRandomSeq();
    bool isAuth = false;

    final packageInfo = await _utils.packageInfo();
    final deviceInfo = await _utils.deviceInfo();

    _controller = StreamController<SyncerMessageRequest>(
      onListen: () async {
        final messageByte = await _crypto.syncer.encode(
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
        _controller.add(SyncerMessageRequest(message: messageByte));

        _logger.info("Syncer the subscriber has connected userID=${session.getUserIDObjectID().toString()}, seq=$seq");
      },
      onCancel: () async {
        await randomSleep(seconds: 5);
        if (context.mounted) await connect(context);
      },
    );

    //
    final response = _api.syncer.messages(_controller.stream, options: await _api.callOptions(timeout: 3600));

    _subscription = response.listen((SyncerMessageResponse data) async {
        final header = await _crypto.syncer.headerParse(Uint8List.fromList(data.message));

        final messageByte = await _crypto.syncer.decode(
            session: session,
            message: Uint8List.fromList(data.message),
          );

        if (!isAuth && header.messageType == SyncerMessageType.authResponse) {
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

        if (header.messageType == SyncerMessageType.sessionsResponse){
          _logger.debug("Получено=${data.message}");
        }

        _logger.debug("Получено=${data.message}");
      },
      onError: (err) {
        if (err is GrpcError) {
          if (err.code == StatusCode.unauthenticated) {
            context.go("/auth");
            return;
          }
        }

        _logger.error("syncer stream error: $err, рестарт коннекта");
      },
      onDone: () {
        _logger.debug("syncer stream closed рестарт коннекта");
      }, cancelOnError: true,
    );

  }

  Future<void> send(BuildContext context, {required Uint8List message, required SyncerMessageType messageType}) async {
    final messageByte = await _crypto.syncer.encode(
      session: session,
      message: message,
      messageType: messageType,
      seq: seq,
    );
    _controller.add(SyncerMessageRequest(message: messageByte));
  }


  int generateRandomSeq() => _random.nextInt(512) * 2 + 1;

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
