
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

  StreamController<SyncerMessageRequest>? _controller;
  StreamSubscription<SyncerMessageResponse>? _subscription;

  // true — соединение закрыто намеренно (dispose), переподключаться не нужно
  bool _disposed = false;

  int seq = 1;

  late models.Session session;
  late Sessions sessions;
  late Auth auth;

  Syncer() {
    sessions = Sessions();
    auth = Auth(logger: _logger, utils: _utils, crypto: _crypto, repositories: _repositories);
    _logger.info("syncer initialization");
  }

  Future<void> connect() async {
    _disposed = false;

    // снести предыдущее соединение, если оно осталось, чтобы не плодить параллельные стримы
    await _teardown();

    session = await _repositories.sessions.getActive();

    late final StreamController<SyncerMessageRequest> controller;
    controller = StreamController<SyncerMessageRequest>(onListen: () => _onListen(), onCancel: () => _onCancel(controller));
    _controller = controller;

    final response = _api.syncer.messages(controller.stream, options: await _api.callOptions(timeout: 3600));

    _subscription = response.listen((data) => _onData(data), onError: (err) => _onError(err), onDone: () => _onDone(), cancelOnError: true);
  }

  // Send the auth request once the subscriber has connected
  Future<void> _onListen() async {
    final controller = _controller;
    if (controller == null) return;

    seq = generateRandomSeq();
    await auth.request(controller, seq);
  }

  // Cancel
  Future<void> _onCancel(StreamController<SyncerMessageRequest> controller) async {
    // переподключаемся только если оборвался активный коннект, а не закрытый
    // намеренно в _teardown()/dispose() (там _controller обнуляется до close)
    if (!identical(controller, _controller)) return;
    await _reconnect();
  }

  // Переподключение после обрыва/таймаута. Намеренное закрытие (dispose) пропускаем.
  Future<void> _reconnect() async {
    if (_disposed) return;

    await randomSleep(seconds: 5);

    // могли вызвать dispose() во время паузы — повторная проверка
    if (_disposed) return;

    await connect();
  }

  // onDone
  Future<void> _onDone() async {
    _logger.debug("syncer stream closed");
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

    if (header.messageType == SyncerMessageType.authResponse) {
      seq = header.seq;
      await auth.response(msg: data.message, header: header);
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
    final subscription = _subscription;
    if (subscription != null && !subscription.isPaused) subscription.pause();
  }

  void resume() {
    _logger.debug("Syncer resume");
    final subscription = _subscription;
    if (subscription != null && subscription.isPaused) subscription.resume();
  }

  void dispose() {
    _logger.debug("Syncer dispose");
    _disposed = true;
    _teardown();
  }

  // Закрыть текущее соединение, не меняя флаг _disposed.
  // Ссылки обнуляются до cancel/close, чтобы onCancel понял, что закрытие намеренное.
  Future<void> _teardown() async {
    final subscription = _subscription;
    final controller = _controller;
    _subscription = null;
    _controller = null;
    await subscription?.cancel();
    await controller?.close();
  }
}
