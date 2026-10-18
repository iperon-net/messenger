import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/logger.dart';
import 'package:pqcrypto/pqcrypto.dart' show PqcKem;

Uint8List _text(String value) => Uint8List.fromList(utf8.encode(value));

/// Одна сторона секретного чата: держит текущее состояние, как это будет
/// делать репозиторий (новое состояние — только после успешной операции).
class _Peer {
  final SecretChatCrypto crypto;
  SecretChatRatchetState state;

  _Peer(this.crypto, this.state);

  Future<Uint8List> send(String text) async {
    final result = await crypto.encrypt(state: state, plaintext: _text(text));
    state = result.state;
    return result.envelope;
  }

  Future<String> receive(Uint8List envelope, {DateTime? now}) async {
    final result = await crypto.decrypt(state: state, envelope: envelope, now: now);
    state = result.state;
    return utf8.decode(result.plaintext);
  }
}

void main() {
  late SecretChatCrypto crypto;
  final chatId = Uint8List.fromList(List.generate(12, (i) => i + 1));

  setUp(() {
    crypto = SecretChatCrypto(logger: Logger());
  });

  Future<(_Peer, _Peer, SecretChatFingerprint, SecretChatFingerprint)> handshake({DateTime? now}) async {
    final (initiatorPending, request) = await crypto.request();
    final (responderPending, accept) = await crypto.accept(chatId: chatId, request: request);
    final (aliceSession, commit) = await crypto.complete(chatId: chatId, pending: initiatorPending, accept: accept, now: now);
    final bobSession = await crypto.finish(pending: responderPending, commit: commit, now: now);
    return (_Peer(crypto, aliceSession.state), _Peer(crypto, bobSession.state), aliceSession.fingerprint, bobSession.fingerprint);
  }

  group('handshake', () {
    test('обе стороны видят одинаковый отпечаток', () async {
      final (_, _, aliceFingerprint, bobFingerprint) = await handshake();
      expect(aliceFingerprint.bytes, bobFingerprint.bytes);
      expect(aliceFingerprint.emoji, bobFingerprint.emoji);
      expect(aliceFingerprint.emoji, hasLength(SecretChatCrypto.fingerprintEmojiCount));
      expect(aliceFingerprint.hex, hasLength(64));
    });

    test('разные рукопожатия — разные отпечатки', () async {
      final (_, _, first, _) = await handshake();
      final (_, _, second, _) = await handshake();
      expect(first.bytes, isNot(second.bytes));
    });

    test('подменённый ключ в раскрытии не проходит коммитмент', () async {
      final (initiatorPending, request) = await crypto.request();
      final (responderPending, accept) = await crypto.accept(chatId: chatId, request: request);
      final (_, commit) = await crypto.complete(chatId: chatId, pending: initiatorPending, accept: accept);

      final (mitmPending, _) = await crypto.request();
      final forged = SecretChatCommit(
        ephemeralKey: mitmPending.ephemeralPublic,
        nonce: commit.nonce,
        kemCiphertext: commit.kemCiphertext,
        ratchetKey: commit.ratchetKey,
      );
      await expectLater(() => crypto.finish(pending: responderPending, commit: forged), throwsA(isA<SecretChatException>()));
    });

    test('подменённый kemCt даёт разные ключи — сообщения не расшифровываются', () async {
      final (initiatorPending, request) = await crypto.request();
      final (responderPending, accept) = await crypto.accept(chatId: chatId, request: request);
      final (aliceSession, commit) = await crypto.complete(chatId: chatId, pending: initiatorPending, accept: accept);

      final (otherCiphertext, _) = PqcKem.kyber768.encapsulate(accept.kemPublicKey);
      final forged = SecretChatCommit(
        ephemeralKey: commit.ephemeralKey,
        nonce: commit.nonce,
        kemCiphertext: otherCiphertext,
        ratchetKey: commit.ratchetKey,
      );
      final bobSession = await crypto.finish(pending: responderPending, commit: forged);
      // Отпечаток совпадает (kemCt в него не входит) — но это не MITM: ключи разные.
      expect(bobSession.fingerprint.bytes, aliceSession.fingerprint.bytes);

      final alice = _Peer(crypto, aliceSession.state);
      final bob = _Peer(crypto, bobSession.state);
      final envelope = await alice.send('привет');
      await expectLater(() => bob.receive(envelope), throwsA(isA<SecretChatException>()));
    });

    test('ожидающие состояния переживают сериализацию', () async {
      final (initiatorPending, request) = await crypto.request();
      final (responderPending, accept) = await crypto.accept(chatId: chatId, request: request);
      final (aliceSession, commit) = await crypto.complete(
        chatId: chatId,
        pending: SecretChatInitiatorPending.fromBytes(initiatorPending.toBytes()),
        accept: accept,
      );
      final bobSession = await crypto.finish(pending: SecretChatResponderPending.fromBytes(responderPending.toBytes()), commit: commit);
      final alice = _Peer(crypto, aliceSession.state);
      final bob = _Peer(crypto, bobSession.state);
      expect(await bob.receive(await alice.send('ok')), 'ok');
    });
  });

  group('ratchet', () {
    test('B может писать первым сразу после рукопожатия', () async {
      final (alice, bob, _, _) = await handshake();
      expect(await alice.receive(await bob.send('я первый')), 'я первый');
      expect(await bob.receive(await alice.send('а я второй')), 'а я второй');
    });

    test('переписка в обе стороны пачками', () async {
      final (alice, bob, _, _) = await handshake();
      final random = Random(1);
      for (var round = 0; round < 20; round++) {
        final (from, to) = round.isEven ? (alice, bob) : (bob, alice);
        final count = 1 + random.nextInt(4);
        for (var i = 0; i < count; i++) {
          final text = 'r$round m$i';
          expect(await to.receive(await from.send(text)), text);
        }
      }
    });

    test('пустое и длинное сообщение', () async {
      final (alice, bob, _, _) = await handshake();
      expect(await bob.receive(await alice.send('')), '');
      final long = 'я' * 50000;
      expect(await bob.receive(await alice.send(long)), long);
    });

    test('порядок внутри цепочки не важен', () async {
      final (alice, bob, _, _) = await handshake();
      final first = await alice.send('1');
      final second = await alice.send('2');
      final third = await alice.send('3');
      expect(await bob.receive(third), '3');
      expect(await bob.receive(first), '1');
      expect(await bob.receive(second), '2');
    });

    test('опоздавшее сообщение из прошлой цепочки', () async {
      final (alice, bob, _, _) = await handshake();
      final early = await alice.send('a1');
      final late = await alice.send('a2 (опоздает)');
      expect(await bob.receive(early), 'a1');
      expect(await alice.receive(await bob.send('b1')), 'b1');
      // Новая цепочка A: в её заголовке pn=2 — B откладывает ключ a2.
      expect(await bob.receive(await alice.send('a3')), 'a3');
      expect(await bob.receive(late), 'a2 (опоздает)');
    });

    test('повтор доставки — Duplicate, состояние не портится', () async {
      final (alice, bob, _, _) = await handshake();
      final envelope = await alice.send('раз');
      expect(await bob.receive(envelope), 'раз');
      await expectLater(() => bob.receive(envelope), throwsA(isA<SecretChatDuplicateException>()));
      expect(await bob.receive(await alice.send('два')), 'два');
    });

    test('повтор отложенного сообщения после его расшифровки', () async {
      final (alice, bob, _, _) = await handshake();
      final first = await alice.send('1');
      final second = await alice.send('2');
      expect(await bob.receive(second), '2');
      expect(await bob.receive(first), '1');
      await expectLater(() => bob.receive(first), throwsA(isA<SecretChatDuplicateException>()));
    });

    test('подделка шифротекста или заголовка отвергается, состояние цело', () async {
      final (alice, bob, _, _) = await handshake();
      final envelope = await alice.send('секрет');

      final cipherFlip = Uint8List.fromList(envelope)..[envelope.length - 1] ^= 1;
      await expectLater(() => bob.receive(cipherFlip), throwsA(isA<SecretChatException>()));

      // Номер сообщения в заголовке (последний байт n): offset 3 + 1 + 32 + 4 + 3.
      final headerFlip = Uint8List.fromList(envelope)..[3 + 1 + 32 + 7] ^= 1;
      await expectLater(() => bob.receive(headerFlip), throwsA(isA<SecretChatException>()));

      await expectLater(() => bob.receive(Uint8List.fromList([9, 0, 0])), throwsA(isA<SecretChatException>()));
      expect(await bob.receive(envelope), 'секрет');
    });

    test('чужой чат не расшифровывает', () async {
      final (alice, _, _, _) = await handshake();
      final (_, eve, _, _) = await handshake();
      final foreign = await alice.send('не тебе');
      await expectLater(() => eve.receive(foreign), throwsA(isA<SecretChatException>()));
    });

    test('прыжок дальше maxSkip отвергается', () async {
      final (alice, bob, _, _) = await handshake();
      Uint8List? last;
      for (var i = 0; i <= SecretChatCrypto.maxSkip + 1; i++) {
        last = await alice.send('$i');
      }
      await expectLater(() => bob.receive(last!), throwsA(isA<SecretChatException>()));
    });

    test('длина скрыта паддингом', () async {
      final (alice, _, _, _) = await handshake();
      final short = await alice.send('a');
      final medium = await alice.send('б' * 100);
      expect(short.length, medium.length);
      final large = await alice.send('б' * 200);
      expect(large.length, greaterThan(short.length));
    });

    test('состояние переживает сериализацию посреди переписки', () async {
      final (alice, bob, _, _) = await handshake();
      final pending = await alice.send('отложено');
      expect(await bob.receive(await alice.send('сразу')), 'сразу');
      bob.state = SecretChatRatchetState.fromBytes(bob.state.toBytes());
      alice.state = SecretChatRatchetState.fromBytes(alice.state.toBytes());
      expect(await bob.receive(pending), 'отложено');
      expect(await alice.receive(await bob.send('ответ')), 'ответ');
      expect(await bob.receive(await alice.send('ещё')), 'ещё');
    });

    test('случайный порядок и потери не ломают чат', () async {
      final (alice, bob, _, _) = await handshake();
      final random = Random(42);
      for (var round = 0; round < 30; round++) {
        final (from, to) = round.isEven ? (alice, bob) : (bob, alice);
        final batch = <(String, Uint8List)>[];
        final count = 1 + random.nextInt(6);
        for (var i = 0; i < count; i++) {
          final text = 'r$round m$i';
          batch.add((text, await from.send(text)));
        }
        batch.shuffle(random);
        // Последнее в пачке по отправке доставляем всегда — иначе другая сторона
        // не увидит новую цепочку; остальные теряются с вероятностью 1/4.
        for (final (text, envelope) in batch) {
          final isLastSent = text == 'r$round m${count - 1}';
          if (!isLastSent && random.nextInt(4) == 0) continue;
          expect(await to.receive(envelope), text);
        }
      }
    });
  });

  group('постквантовый rekey', () {
    bool hasKemPublicKey(Uint8List envelope) => envelope[3] & 0x01 != 0;
    bool hasKemCiphertext(Uint8List envelope) => envelope[3] & 0x02 != 0;

    test('после 100 сообщений стороны подмешивают ML-KEM и продолжают переписку', () async {
      final (alice, bob, _, _) = await handshake();
      var sawPublicKey = false;
      var sawCiphertext = false;
      for (var round = 0; round < 80; round++) {
        final (from, to) = round.isEven ? (alice, bob) : (bob, alice);
        for (var i = 0; i < 2; i++) {
          final envelope = await from.send('r$round m$i');
          sawPublicKey |= hasKemPublicKey(envelope);
          sawCiphertext |= hasKemCiphertext(envelope);
          expect(await to.receive(envelope), 'r$round m$i');
        }
      }
      expect(sawPublicKey, isTrue);
      expect(sawCiphertext, isTrue);
      expect(alice.state.pqMessageCount, lessThan(SecretChatCrypto.pqRekeyMessages));
      expect(bob.state.pqMessageCount, lessThan(SecretChatCrypto.pqRekeyMessages));
    });

    test('rekey по времени (неделя) и с опозданием сообщений', () async {
      final start = DateTime(2026, 10, 1);
      final (alice, bob, _, _) = await handshake(now: start);
      final later = start.add(const Duration(days: 8));

      expect(await alice.receive(await bob.send('b1'), now: later), 'b1');
      // Новая цепочка A объявляет ML-KEM-ключ.
      final announce = await alice.send('a1');
      final announceLate = await alice.send('a2');
      expect(hasKemPublicKey(announce), isTrue);
      expect(await bob.receive(announce, now: later), 'a1');
      // Ответная цепочка B несёт инкапсуляцию.
      final reply = await bob.send('b2');
      expect(hasKemCiphertext(reply), isTrue);
      expect(await alice.receive(reply, now: later), 'b2');
      expect(alice.state.kemSecretKey, isNull);
      expect(await bob.receive(announceLate, now: later), 'a2');

      final next = await alice.send('a3');
      expect(hasKemPublicKey(next), isFalse);
      expect(await bob.receive(next, now: later), 'a3');
      expect(await alice.receive(await bob.send('b3'), now: later), 'b3');
    });
  });

  group('формат конверта', () {
    test('независимая расшифровка по спецификации', () async {
      final (alice, _, _, _) = await handshake();
      final before = alice.state;
      final envelope = await alice.send('формат');

      // KDF_CK: mk = HMAC-SHA256(ck, 0x01); ключ/nonce = HKDF(mk, salt = 0^32,
      // info = метка, 44) → AES-256 ‖ nonce 12.
      final hmac = Hmac.sha256();
      final messageKey = await hmac.calculateMac(const [0x01], secretKey: SecretKey(before.chainSend!));
      final keys = await Hkdf(
        hmac: hmac,
        outputLength: 44,
      ).deriveKey(secretKey: SecretKey(messageKey.bytes), nonce: Uint8List(32), info: utf8.encode('iperon-secret-msg-v1'));
      final keyBytes = await keys.extractBytes();

      expect(envelope[0], SecretChatCrypto.envelopeVersion);
      final headerLength = (envelope[1] << 8) | envelope[2];
      expect(headerLength, 1 + 32 + 8);
      final prefix = envelope.sublist(0, 3 + headerLength);
      expect(prefix.sublist(4, 36), before.dhSendPublic);
      final cipher = envelope.sublist(prefix.length);

      final plain = await AesGcm.with256bits().decrypt(
        SecretBox(cipher.sublist(0, cipher.length - 16), nonce: keyBytes.sublist(32), mac: Mac(cipher.sublist(cipher.length - 16))),
        secretKey: SecretKey(keyBytes.sublist(0, 32)),
        aad: [...before.associatedData, ...prefix],
      );
      expect(plain, hasLength(256));
      expect(utf8.decode(SecretChatPadding.unpad(Uint8List.fromList(plain))), 'формат');
    });
  });

  group('padding', () {
    test('бакеты и обратимость', () {
      expect(SecretChatPadding.bucketFor(0), 256);
      expect(SecretChatPadding.bucketFor(255), 256);
      expect(SecretChatPadding.bucketFor(256), 512);
      expect(SecretChatPadding.bucketFor(70000), 128 * 1024);
      final data = Uint8List.fromList([1, 0, 0x80, 0]);
      expect(SecretChatPadding.unpad(SecretChatPadding.pad(data)), data);
      expect(() => SecretChatPadding.unpad(Uint8List(16)), throwsA(isA<SecretChatException>()));
    });
  });
}
