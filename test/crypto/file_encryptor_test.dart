import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/logger.dart';

/// Расшифровывает то, что зашифровал [FileEncryptor.encryptFile], тем же
/// набором примитивов, но независимо от продакшен-кода — так тест реально
/// проверяет формат, а не тавтологично сверяет encrypt/decrypt друг с другом.
Future<Uint8List> _decryptAll({
  required List<Uint8List> chunks,
  required List<int> fileKey,
  required List<int> hkdfSalt,
  required List<int> noncePrefix,
}) async {
  final algorithmAesGcm = AesGcm.with256bits();
  final algorithmHkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
  final chunkKey = await algorithmHkdf.deriveKey(secretKey: SecretKey(fileKey), nonce: hkdfSalt, info: 'iperon-media-file-v1'.codeUnits);

  final builder = BytesBuilder();
  for (var index = 0; index < chunks.length; index++) {
    final chunk = chunks[index];
    final isFinal = index == chunks.length - 1;

    var counter = index;
    if (isFinal) counter |= 0x80000000;
    final counterBytes = ByteData(4)..setUint32(0, counter, Endian.big);
    final nonce = [...noncePrefix, ...counterBytes.buffer.asUint8List()];

    final cipherText = chunk.sublist(0, chunk.length - 16);
    final mac = Mac(chunk.sublist(chunk.length - 16));

    final plain = await algorithmAesGcm.decrypt(
      SecretBox(cipherText, nonce: nonce, mac: mac),
      secretKey: chunkKey,
    );
    builder.add(plain);
  }
  return builder.toBytes();
}

void main() {
  late Logger logger;

  setUpAll(() {
    logger = Logger();
  });

  Future<File> writeTempFile(List<int> bytes) async {
    final file = File('${Directory.systemTemp.path}/file_encryptor_test_${randomBytesAsHexString(8)}.bin');
    await file.writeAsBytes(bytes);
    addTearDown(() => file.delete());
    return file;
  }

  group('FileEncryptor.encryptFile', () {
    test('round-trips a multi-chunk file', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final plaintext = List<int>.generate(16 * 5 + 7, (i) => i % 256);
      final file = await writeTempFile(plaintext);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();
      final noncePrefix = encryptor.generateNoncePrefix();

      final chunks = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix).toList();

      expect(chunks.length, encryptor.totalChunks(plaintext.length));

      final decrypted = await _decryptAll(chunks: chunks, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix);
      expect(decrypted, equals(plaintext));
    });

    test('handles an empty file as a single (empty) final chunk', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final file = await writeTempFile([]);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();
      final noncePrefix = encryptor.generateNoncePrefix();

      final chunks = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix).toList();

      expect(chunks.length, 1);
      expect(chunks.single.length, 16); // только AEAD-тег, plaintext пуст

      final decrypted = await _decryptAll(chunks: chunks, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix);
      expect(decrypted, isEmpty);
    });

    test('handles a file that is an exact multiple of the chunk size', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final plaintext = List<int>.generate(16 * 3, (i) => i % 256);
      final file = await writeTempFile(plaintext);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();
      final noncePrefix = encryptor.generateNoncePrefix();

      final chunks = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix).toList();

      expect(chunks.length, 3);

      final decrypted = await _decryptAll(chunks: chunks, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix);
      expect(decrypted, equals(plaintext));
    });

    test('is deterministic for the same key/salt/nonce prefix', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final plaintext = List<int>.generate(50, (i) => i % 256);
      final file = await writeTempFile(plaintext);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();
      final noncePrefix = encryptor.generateNoncePrefix();

      final first = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix).toList();
      final second = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix).toList();

      expect(first.length, second.length);
      for (var i = 0; i < first.length; i++) {
        expect(first[i], equals(second[i]));
      }
    });

    test('resumes from chunkIndexForReceivedBytes and matches a full encrypt', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final plaintext = List<int>.generate(16 * 5 + 7, (i) => i % 256);
      final file = await writeTempFile(plaintext);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();
      final noncePrefix = encryptor.generateNoncePrefix();

      final full = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix).toList();

      // Представим, что сервер уже подтвердил первые 2 чанка.
      final receivedBytes = full[0].length + full[1].length;
      final startIndex = encryptor.chunkIndexForReceivedBytes(plaintext.length, receivedBytes);
      expect(startIndex, 2);

      final resumed = await encryptor
          .encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt, noncePrefix: noncePrefix, startChunkIndex: startIndex)
          .toList();

      expect(resumed, equals(full.sublist(startIndex)));
    });
  });

  group('FileEncryptor.chunkIndexForReceivedBytes', () {
    test('returns totalChunks once everything is received', () {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      const fileLength = 16 * 3;
      final total = encryptor.totalChunks(fileLength);
      final fullyReceived = total * (16 + 16); // все чанки полного размера + тег

      expect(encryptor.chunkIndexForReceivedBytes(fileLength, fullyReceived), total);
    });

    test('lands correctly on the shorter final chunk', () {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      const fileLength = 16 * 2 + 5; // последний чанк короче остальных
      final total = encryptor.totalChunks(fileLength);
      expect(total, 3);

      final firstTwoChunksCipherSize = (16 + 16) * 2;
      expect(encryptor.chunkIndexForReceivedBytes(fileLength, firstTwoChunksCipherSize), 2);
    });
  });
}
