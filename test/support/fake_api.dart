import 'dart:async';
import 'dart:typed_data';

import 'package:messenger/api.dart';
import 'package:messenger/protobuf/protos/v1.pb.dart';

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

  @override
  Future<APICallStatus> call(Function() func, {bool retryTransient = false, dynamic session}) async {
    callCount++;
    if (_callResults.isNotEmpty) return _callResults.removeAt(0);
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
