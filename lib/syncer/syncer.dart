
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import 'package:messenger/crypto/crypto.dart';
import 'package:messenger/utils.dart';
import 'package:collection/collection.dart';

import '../api.dart';
import '../constants.dart';
import '../di.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../protobuf/messages.dart' as message;
import '../protobuf/protos/syncer_v1.pb.dart';
import '../repositories/repositories.dart';

part 'auth.dart';
part 'device_sessions.dart';

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

  // true — реконнект уже запланирован/выполняется; защита от повторного запуска,
  // когда завершение приходит сразу в несколько колбэков (onError + onDone + onCancel)
  bool _reconnecting = false;

  int seq = 1;

  late models.Session session;
  late DeviceSessions deviceSessions;
  late Auth auth;

  Syncer() {
    deviceSessions = DeviceSessions(logger: _logger, utils: _utils, crypto: _crypto, repositories: _repositories);
    auth = Auth(logger: _logger, utils: _utils, crypto: _crypto, repositories: _repositories);
    _logger.info("syncer initialization");
  }

  StreamController<SyncerMessageRequest>? getController() => _controller;

  Future<void> connect() async {
    _logger.debug("syncer connect() start (disposed=$_disposed, reconnecting=$_reconnecting)");
    _disposed = false;
    _reconnecting = false;

    // снести предыдущее соединение, если оно осталось, чтобы не плодить параллельные стримы
    await _teardown();
    _logger.debug("syncer connect() teardown done");

    session = await _repositories.sessions.getActive();
    _logger.debug("syncer connect() session loaded (isActive=${session.isActive})");

    late final StreamController<SyncerMessageRequest> controller;
    controller = StreamController<SyncerMessageRequest>(onListen: () => _onListen(), onCancel: () => _onCancel(controller));
    _controller = controller;

    // timeout: 0 — без дедлайна на стриме; соединение ресайклит сервер по MaxConnectionAge (30 мин)
    final response = _api.syncer.messages(controller.stream, options: await _api.callOptions(timeout: 0));

    _subscription = response.listen(
      (data) => _onData(data),
      onError: (err) => _onError(controller, err),
      onDone: () => _onDone(controller),
      cancelOnError: true,
    );
    _logger.debug("syncer connect() subscribed, stream is live");
  }

  // Send the auth request once the subscriber has connected
  Future<void> _onListen() async {
    _logger.debug("syncer _onListen fired (controller=${_controller != null}, session.isActive=${session.isActive})");
    final controller = _controller;
    if (controller == null) {
      _logger.warning("syncer _onListen: _controller == null, authRequest пропущен");
      return;
    }

    seq = generateRandomSeq();
    // _onListen вызывается fire-and-forget из onListen контроллера: без try/catch
    // исключение в authRequest (например, crypto.encode) проглотится, и auth не уйдёт
    try {
      await auth.authRequest(controller: controller, seq: seq, session: session);
      _logger.debug("syncer _onListen: authRequest завершён, seq=$seq");
    } catch (err, st) {
      _logger.error("syncer _onListen: authRequest бросил исключение: $err\n$st");
    }
  }

  // Cancel
  Future<void> _onCancel(StreamController<SyncerMessageRequest> controller) async {
    _logger.debug("syncer stream cancel");
    await _onTerminated(controller, "cancel");
  }

  // onDone — сервер закрыл стрим штатно (GOAWAY/OK при рестарте/ресайкле коннекта)
  Future<void> _onDone(StreamController<SyncerMessageRequest> controller) async {
    _logger.debug("syncer stream closed");
    await _onTerminated(controller, "done");
  }

  // onError — транспортная ошибка/обрыв (например, рестарт сервера → unavailable)
  Future<void> _onError(StreamController<SyncerMessageRequest> controller, dynamic err) async {
    final code = err is GrpcError ? err.code : null;
    final codeName = err is GrpcError ? err.codeName : "n/a";
    _logger.error("syncer onError: type=${err.runtimeType}, code=$code ($codeName), err=$err");

    // невалидная сессия — переподключение бессмысленно, оно зациклится
    if (err is GrpcError && err.code == StatusCode.unauthenticated) {
      _logger.error("syncer stream unauthenticated — reconnect пропущен (ранний return)");
      return;
    }
    _logger.error("syncer stream error: $err, рестарт коннекта");
    await _onTerminated(controller, "error");
  }

  // Единая точка обработки завершения соединения. Завершение прилетает в несколько
  // колбэков (onError/onDone/onCancel) — реагируем один раз и только на актуальный коннект.
  Future<void> _onTerminated(StreamController<SyncerMessageRequest> controller, String reason) async {
    // устаревшие колбэки от прошлых стримов игнорируем: _teardown() обнуляет _controller до close/cancel
    if (!identical(controller, _controller)) {
      _logger.debug("syncer terminated ($reason) — устаревший колбэк, игнор");
      return;
    }
    _logger.debug("syncer terminated ($reason), reconnect");
    await _reconnect();
  }

  // Переподключение после обрыва/таймаута. Намеренное закрытие (dispose) пропускаем.
  Future<void> _reconnect() async {
    if (_disposed || _reconnecting) {
      _logger.debug("syncer _reconnect skip (disposed=$_disposed, reconnecting=$_reconnecting)");
      return;
    }
    _reconnecting = true;

    await randomSleep(seconds: 5);

    // могли вызвать dispose() во время паузы — повторная проверка
    if (_disposed) {
      _logger.debug("syncer _reconnect aborted — disposed during pause");
      _reconnecting = false;
      return;
    }

    // connect() вызывается fire-and-forget из колбэков стрима; без catch брошенное
    // исключение стало бы unhandled async error и молча убило бы цикл reconnect
    try {
      await connect();
    } catch (err, st) {
      _logger.error("syncer _reconnect: connect() бросил исключение: $err\n$st");
      _reconnecting = false;
    }
  }

  Future<void> _onData(SyncerMessageResponse data) async {
    final header = await _crypto.syncer.headerParse(Uint8List.fromList(data.message));
    seq = header.seq;

    _logger.debug("messageType=${header.messageType}");

    if (header.messageType == SyncerMessageType.authResponse) {
      await auth.authResponse(msg: data.message, header: header, session: session);
    } else if (header.messageType == SyncerMessageType.logoutResponse) {
      await auth.logoutResponse(msg: data.message, header: header, session: session);
    } else if (header.messageType == SyncerMessageType.deviceSessionsResponse) {
      await deviceSessions.getAllSessionResponse(msg: data.message, header: header, session: session);
    }

    // if (){
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
    // НЕ await ни cancel, ни close: после рестарта сервера транспорт остаётся в
    // полуоткрытом состоянии, и отмена старой grpc-подписки/закрытие контроллера без
    // активного слушателя возвращают future, которые никогда не завершаются → await
    // навсегда вешал connect() и убивал reconnect. Чистим fire-and-forget; устаревшие
    // события старого стрима отсекаются обнулёнными ссылками и проверкой _controller.
    unawaited(subscription?.cancel());
    unawaited(controller?.close());
  }
}
