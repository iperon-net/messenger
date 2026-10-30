import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/crypto.dart';

/// Interop клиентского OPAQUE с серверной реализацией (`internal/crypto.Opaque`
/// в iperon). Нужен собранный interop-сервер из серверного репозитория:
///
///   go build -o /tmp/opaque-interop ./cmd/opaque-interop   # в ~/GolandProjects/iperon
///   OPAQUE_INTEROP_SERVER=/tmp/opaque-interop flutter test test/crypto/opaque_interop_test.dart
///
/// Без переменной тест пропускается (в CI Go-тулчейна нет).
const _context = 'iperon-cloud-password-v1';
const _ksf = OpaqueKsf.argon2id(iterations: 1, memory: 1024, parallelism: 1);

String _hexStr(List<int> b) => b.map((e) => e.toRadixString(16).padLeft(2, '0')).join();

Uint8List _hex(String s) {
  final out = Uint8List(s.length ~/ 2);
  for (var i = 0; i < out.length; i++) {
    out[i] = int.parse(s.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return out;
}

class _Server {
  final Process _process;
  final _lines = Queue<String>();
  final _waiters = Queue<Completer<String>>();

  _Server(this._process) {
    _process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
      if (_waiters.isNotEmpty) {
        _waiters.removeFirst().complete(line);
      } else {
        _lines.add(line);
      }
    });
  }

  static Future<_Server> start(String path) async => _Server(await Process.start(path, const []));

  Future<String> send(String command) {
    _process.stdin.writeln(command);
    if (_lines.isNotEmpty) return Future.value(_lines.removeFirst());
    final waiter = Completer<String>();
    _waiters.add(waiter);
    return waiter.future;
  }

  void stop() => _process.kill();
}

OpaqueClient _client({String context = _context, OpaqueKsf ksf = _ksf}) =>
    OpaqueClient(context: Uint8List.fromList(utf8.encode(context)), ksf: ksf);

Future<Uint8List> _register(_Server server, String credID, String password) async {
  final client = _client();
  final (request, state) = client.registrationStart(utf8.encode(password));
  final response = await server.send('REG $credID ${_hexStr(request)}');
  final result = await client.registrationFinish(state, _hex(response));
  expect(await server.send('REC $credID ${_hexStr(result.record)}'), 'OK');
  return result.exportKey;
}

/// Вход: возвращает (ответ сервера на KE3, итог клиента) или бросает OpaqueException.
Future<(String, OpaqueLoginResult)> _login(_Server server, String credID, String password, {OpaqueClient? client}) async {
  client ??= _client();
  final (ke1, state) = client.loginStart(utf8.encode(password));
  final ke2 = await server.send('KE1 $credID ${_hexStr(ke1)}');
  final result = await client.loginFinish(state, _hex(ke2));
  return (await server.send('KE3 $credID ${_hexStr(result.ke3)}'), result);
}

Matcher _throws(OpaqueError error) => throwsA(isA<OpaqueException>().having((e) => e.error, 'error', error));

void main() {
  final path = Platform.environment['OPAQUE_INTEROP_SERVER'];
  final skip = path == null ? 'OPAQUE_INTEROP_SERVER не задан' : null;
  late _Server server;

  setUp(() async {
    if (path != null) server = await _Server.start(path);
  });
  tearDown(() {
    if (path != null) server.stop();
  });

  test('Dart registration + login against the server', () async {
    final exportKey = await _register(server, '01', 'correct horse');
    final (answer, result) = await _login(server, '01', 'correct horse');

    expect(answer, 'OK');
    expect(result.exportKey, exportKey);
  }, skip: skip);

  test('wrong password never reaches KE3', () async {
    await _register(server, '02', 'correct horse');
    await expectLater(_login(server, '02', 'wrong horse'), _throws(OpaqueError.wrongPassword));
  }, skip: skip);

  test('record is bound to its credential identifier', () async {
    final client = _client();
    final (request, state) = client.registrationStart(utf8.encode('correct horse'));
    final response = await server.send('REG 03 ${_hexStr(request)}');
    final result = await client.registrationFinish(state, _hex(response));
    // Та же запись под другим userID: OPRF-ключ другой — конверт не откроется.
    expect(await server.send('REC 04 ${_hexStr(result.record)}'), 'OK');
    await expectLater(_login(server, '04', 'correct horse'), _throws(OpaqueError.wrongPassword));
  }, skip: skip);

  test('context mismatch fails server authentication', () async {
    await _register(server, '05', 'correct horse');
    await expectLater(_login(server, '05', 'correct horse', client: _client(context: 'other')), _throws(OpaqueError.serverAuthentication));
  }, skip: skip);

  test('forged KE3 is rejected by the server', () async {
    await _register(server, '06', 'correct horse');
    final (ke1, _) = _client().loginStart(utf8.encode('correct horse'));
    await server.send('KE1 06 ${_hexStr(ke1)}');
    expect(await server.send('KE3 06 ${_hexStr(Uint8List(64))}'), 'FAIL');
  }, skip: skip);
}
