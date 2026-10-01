// Независимая (Dart, package:cryptography) проверка формата шифрования
// push-уведомлений против тест-векторов сервера: HKDF-SHA256 → AES-256-GCM, AAD
// = заголовок. Нативные расшифровщики (Swift NSE, Kotlin FCM-сервис) обязаны
// проходить те же векторы. См. protos/push_payload_v1.proto.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';

List<int> _hex(String value) => [for (var i = 0; i < value.length; i += 2) int.parse(value.substring(i, i + 2), radix: 16)];

void main() {
  final file = jsonDecode(File('test/fixtures/push_vectors.json').readAsStringSync()) as Map<String, dynamic>;
  final vectors = (file['vectors'] as List).cast<Map<String, dynamic>>();

  for (final (index, vector) in vectors.indexed) {
    test('push vector #$index decrypts', () async {
      final hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
      final key = await hkdf.deriveKey(
        secretKey: SecretKey(_hex(vector['sharedKey'] as String)),
        nonce: _hex(vector['sharedSalt'] as String),
        info: utf8.encode('iperon-push-v1'),
      );
      expect(await key.extractBytes(), _hex(vector['pushKey'] as String));

      final raw = base64.decode(vector['p'] as String);
      const headerSize = 1 + 8 + 12;
      final header = Uint8List.sublistView(raw, 0, headerSize);
      expect(header[0], 1);
      expect(header.sublist(1, 9), _hex(vector['session'] as String).sublist(0, 8));

      final body = raw.sublist(headerSize);
      final box = SecretBox(body.sublist(0, body.length - 16), nonce: header.sublist(9), mac: Mac(body.sublist(body.length - 16)));
      final plaintext = await AesGcm.with256bits().decrypt(box, secretKey: key, aad: header);

      expect(plaintext, _hex(vector['plaintext'] as String));
    });
  }
}
