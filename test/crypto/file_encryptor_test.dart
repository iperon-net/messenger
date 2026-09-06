import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/logger.dart';

/// Независимо от продакшен-кода выводит nonce-префикс так же, как это должен
/// делать [FileEncryptor.deriveNoncePrefix] — чтобы тест проверял формат, а не
/// тавтологично сверялся с реализацией.
Future<List<int>> _deriveNoncePrefix({required List<int> fileKey, required List<int> hkdfSalt}) async {
  final algorithmHkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
  final key = await algorithmHkdf.deriveKey(secretKey: SecretKey(fileKey), nonce: hkdfSalt, info: 'iperon-media-nonce-v1'.codeUnits);
  return (await key.extractBytes()).sublist(0, 8);
}

/// Расшифровывает то, что зашифровал [FileEncryptor.encryptFile], тем же
/// набором примитивов, но независимо от продакшен-кода — так тест реально
/// проверяет формат, а не тавтологично сверяет encrypt/decrypt друг с другом.
Future<Uint8List> _decryptAll({required List<Uint8List> chunks, required List<int> fileKey, required List<int> hkdfSalt}) async {
  final algorithmAesGcm = AesGcm.with256bits();
  final algorithmHkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
  final chunkKey = await algorithmHkdf.deriveKey(secretKey: SecretKey(fileKey), nonce: hkdfSalt, info: 'iperon-media-file-v1'.codeUnits);
  final noncePrefix = await _deriveNoncePrefix(fileKey: fileKey, hkdfSalt: hkdfSalt);

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

      final chunks = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();

      expect(chunks.length, encryptor.totalChunks(plaintext.length));

      final decrypted = await _decryptAll(chunks: chunks, fileKey: fileKey, hkdfSalt: hkdfSalt);
      expect(decrypted, equals(plaintext));
    });

    test('handles an empty file as a single (empty) final chunk', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final file = await writeTempFile([]);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();

      final chunks = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();

      expect(chunks.length, 1);
      expect(chunks.single.length, 16); // только AEAD-тег, plaintext пуст

      final decrypted = await _decryptAll(chunks: chunks, fileKey: fileKey, hkdfSalt: hkdfSalt);
      expect(decrypted, isEmpty);
    });

    test('handles a file that is an exact multiple of the chunk size', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final plaintext = List<int>.generate(16 * 3, (i) => i % 256);
      final file = await writeTempFile(plaintext);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();

      final chunks = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();

      expect(chunks.length, 3);

      final decrypted = await _decryptAll(chunks: chunks, fileKey: fileKey, hkdfSalt: hkdfSalt);
      expect(decrypted, equals(plaintext));
    });

    test('is deterministic for the same key/salt', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final plaintext = List<int>.generate(50, (i) => i % 256);
      final file = await writeTempFile(plaintext);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();

      final first = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();
      final second = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();

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

      final full = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();

      // Представим, что сервер уже подтвердил первые 2 чанка.
      final receivedBytes = full[0].length + full[1].length;
      final startIndex = encryptor.chunkIndexForReceivedBytes(plaintext.length, receivedBytes);
      expect(startIndex, 2);

      final resumed = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt, startChunkIndex: startIndex).toList();

      expect(resumed, equals(full.sublist(startIndex)));
    });
  });

  group('FileEncryptor.deriveNoncePrefix', () {
    test('is 8 bytes, deterministic, and independent of chunkKey derivation', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();

      final a = await encryptor.deriveNoncePrefix(fileKey: fileKey, hkdfSalt: hkdfSalt);
      final b = await encryptor.deriveNoncePrefix(fileKey: fileKey, hkdfSalt: hkdfSalt);
      final independent = await _deriveNoncePrefix(fileKey: fileKey, hkdfSalt: hkdfSalt);

      expect(a.length, 8);
      expect(a, equals(b)); // детерминированность
      expect(a, equals(independent)); // тот же формат, что ждёт скачивающий
    });

    test('differs for a different file key', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final hkdfSalt = encryptor.generateHkdfSalt();

      final a = await encryptor.deriveNoncePrefix(fileKey: encryptor.generateFileKey(), hkdfSalt: hkdfSalt);
      final b = await encryptor.deriveNoncePrefix(fileKey: encryptor.generateFileKey(), hkdfSalt: hkdfSalt);

      expect(a, isNot(equals(b)));
    });
  });

  group('FileEncryptor.decryptFile', () {
    // Прогоняем полный цикл encrypt→decrypt через продакшен-код на файлах разного
    // размера, включая граничные: пустой, ровно один чанк, ровно N чанков, чанк с
    // хвостом.
    for (final fileLength in [0, 1, 16, 16 * 3, 16 * 3 + 5, 50]) {
      test('round-trips a $fileLength-byte file to disk', () async {
        final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
        final plaintext = List<int>.generate(fileLength, (i) => (i * 7) % 256);
        final source = await writeTempFile(plaintext);

        final fileKey = encryptor.generateFileKey();
        final hkdfSalt = encryptor.generateHkdfSalt();

        // Собираем ciphertext-файл (как его положил бы download на диск).
        final chunks = await encryptor.encryptFile(file: source, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();
        final cipher = await writeTempFile(chunks.expand((c) => c).toList());

        final out = File('${Directory.systemTemp.path}/file_encryptor_out_${randomBytesAsHexString(8)}.bin');
        addTearDown(() => out.delete());

        await encryptor.decryptFile(cipherFile: cipher, outFile: out, fileKey: fileKey, hkdfSalt: hkdfSalt);

        expect(await out.readAsBytes(), equals(plaintext), reason: 'fileLength=$fileLength');
      });
    }

    test('rejects a truncated ciphertext (last frame chopped off)', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final plaintext = List<int>.generate(16 * 3 + 5, (i) => i % 256);
      final source = await writeTempFile(plaintext);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();

      final chunks = await encryptor.encryptFile(file: source, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();
      // Отрезаем последний фрейм: то, что раньше было финальным чанком, теперь не
      // финальный — его nonce (без инвертированного бита) не сойдётся → SecretBoxAuthenticationError.
      final truncated = chunks.sublist(0, chunks.length - 1).expand((c) => c).toList();
      final cipher = await writeTempFile(truncated);

      final out = File('${Directory.systemTemp.path}/file_encryptor_out_${randomBytesAsHexString(8)}.bin');
      addTearDown(() => out.delete());

      await expectLater(
        encryptor.decryptFile(cipherFile: cipher, outFile: out, fileKey: fileKey, hkdfSalt: hkdfSalt),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    });

    test('rejects a wrong decryption key', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);
      final plaintext = List<int>.generate(40, (i) => i % 256);
      final source = await writeTempFile(plaintext);

      final fileKey = encryptor.generateFileKey();
      final hkdfSalt = encryptor.generateHkdfSalt();

      final chunks = await encryptor.encryptFile(file: source, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();
      final cipher = await writeTempFile(chunks.expand((c) => c).toList());

      final out = File('${Directory.systemTemp.path}/file_encryptor_out_${randomBytesAsHexString(8)}.bin');
      addTearDown(() => out.delete());

      await expectLater(
        encryptor.decryptFile(cipherFile: cipher, outFile: out, fileKey: encryptor.generateFileKey(), hkdfSalt: hkdfSalt),
        throwsA(isA<SecretBoxAuthenticationError>()),
      );
    });
  });

  group('FileEncryptor.totalCipherSize', () {
    test('matches the actual ciphertext length produced by encryptFile', () async {
      final encryptor = FileEncryptor(logger: logger, chunkSize: 16);

      for (final fileLength in [0, 16, 16 * 3, 16 * 3 + 5, 50]) {
        final plaintext = List<int>.generate(fileLength, (i) => i % 256);
        final file = await writeTempFile(plaintext);

        final fileKey = encryptor.generateFileKey();
        final hkdfSalt = encryptor.generateHkdfSalt();

        final chunks = await encryptor.encryptFile(file: file, fileKey: fileKey, hkdfSalt: hkdfSalt).toList();
        final actualCipherSize = chunks.fold<int>(0, (sum, chunk) => sum + chunk.length);

        expect(encryptor.totalCipherSize(fileLength), actualCipherSize, reason: 'fileLength=$fileLength');
      }
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
