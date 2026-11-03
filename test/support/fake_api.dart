import 'dart:async';
import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import 'package:messenger/api.dart';
import 'package:messenger/protobuf/protos/v1.pbgrpc.dart';

final class FakeApiCall {
  final MessageType type;
  final Uint8List payload;

  const FakeApiCall(this.type, this.payload);
}

final class FakeApi implements API {
  final _incoming = StreamController<IncomingMessage>.broadcast();
  final _connectionStatus = StreamController<ApiConnectionStatus>.broadcast();
  final _unaryResults = <MessageType, List<APICallStatus>>{};
  final _callResults = <APICallStatus>[];
  final _client = FakeIperonClient();

  final unaryCalls = <FakeApiCall>[];
  final sentMessages = <FakeApiCall>[];
  var callCount = 0;

  @override
  ApiConnectionStatus connectionStatus = ApiConnectionStatus.connecting;

  @override
  Stream<ApiConnectionStatus> get connectionStatusStream => _connectionStatus.stream;

  void emitConnectionStatus(ApiConnectionStatus status) {
    connectionStatus = status;
    _connectionStatus.add(status);
  }

  void emitMessage(MessageType type, List<int> payload) {
    _incoming.add(IncomingMessage(messageType: type, payload: Uint8List.fromList(payload)));
  }

  @override
  Stream<Uint8List> on(MessageType type) {
    return _incoming.stream.where((message) => message.messageType == type).map((message) => message.payload);
  }

  void enqueueUnaryResult(MessageType type, APICallStatus status) {
    _unaryResults.putIfAbsent(type, () => []).add(status);
  }

  void enqueueCallResult(APICallStatus status) {
    _callResults.add(status);
  }

  void enqueueResponse(MessageType type, Message response) {
    _client.responses.putIfAbsent(type, () => []).add(response);
  }

  List<Message> get requests => _client.requests;

  @override
  IperonClient get client => _client;

  @override
  Future<APICallStatus> call(Function() func, {bool retryTransient = false, dynamic session}) async {
    callCount++;
    if (_callResults.isNotEmpty) return _callResults.removeAt(0);
    await func();
    return const APICallStatus(status: APIStatus.success, statusCode: 0);
  }

  @override
  Future<APICallStatus> unaryEncoded(MessageType type, Uint8List payload) async {
    unaryCalls.add(FakeApiCall(type, payload));
    final results = _unaryResults[type];
    if (results != null && results.isNotEmpty) return results.removeAt(0);
    return const APICallStatus(status: APIStatus.success, statusCode: 0);
  }

  @override
  Future<void> sendEncoded(MessageType type, Uint8List payload) async {
    sentMessages.add(FakeApiCall(type, payload));
  }

  Future<void> dispose() async {
    await _incoming.close();
    await _connectionStatus.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError('FakeApi: ${invocation.memberName} is not configured');
  }
}

final class FakeIperonClient implements IperonClient {
  final responses = <MessageType, List<Message>>{};
  final requests = <Message>[];

  @override
  ResponseFuture<Message> unary(Message request, {CallOptions? options}) {
    requests.add(request);
    final responsesForType = responses[request.messageType];
    if (responsesForType == null || responsesForType.isEmpty) {
      throw UnsupportedError('FakeApi: no response for ${request.messageType}');
    }
    return FakeResponseFuture(Future.value(responsesForType.removeAt(0)));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError('FakeIperonClient: ${invocation.memberName} is not configured');
  }
}

final class FakeResponseFuture implements ResponseFuture<Message> {
  final Future<Message> _future;

  const FakeResponseFuture(this._future);

  @override
  Stream<Message> asStream() => _future.asStream();

  @override
  Future<Message> catchError(Function onError, {bool Function(Object error)? test}) => _future.catchError(onError, test: test);

  @override
  Future<R> then<R>(FutureOr<R> Function(Message value) onValue, {Function? onError}) => _future.then(onValue, onError: onError);

  @override
  Future<Message> timeout(Duration timeLimit, {FutureOr<Message> Function()? onTimeout}) =>
      _future.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<Message> whenComplete(FutureOr<void> Function() action) => _future.whenComplete(action);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
