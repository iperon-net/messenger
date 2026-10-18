import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_sync.dart' show ChatsOfflineException;
import 'package:messenger/chats/secret/secret_chats_sync.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/secret_chats_v1.pb.dart' as sc;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Клиентская синхронизация секретных чатов против упрощённого сервера в
// памяти (та же логика, что ServiceSecretChats на Go): очереди устройств с
// qts, push по «стриму» доставляется явно (deliver), чтобы проверять и потерю.

String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

class _Chat {
  final List<int> id;
  final _Device initiator;
  final List<int> peerUserID;
  final List<_Device> requested;
  _Device? peer;
  sc.SecretChat_State state = sc.SecretChat_State.REQUESTED;

  _Chat(this.id, this.initiator, this.peerUserID, this.requested);
}

class _FakeServer {
  final devices = <_Device>[];
  final chats = <String, _Chat>{};
  final queues = <String, List<sc.SecretUpdate>>{};
  final qts = <String, int>{};
  final sentRandomIDs = <String>{};
  final pushes = <(_Device, sc.SecretUpdate)>[];
  var _nextID = 1;

  void _enqueue(_Device device, List<int> chatID, sc.SecretUpdate update) {
    final key = _hex(device.sessionID);
    final number = (qts[key] ?? 0) + 1;
    qts[key] = number;
    update
      ..qts = Int64(number)
      ..date = Int64(DateTime.now().millisecondsSinceEpoch)
      ..secretChatID = chatID;
    queues.putIfAbsent(key, () => []).add(update);
    pushes.add((device, update));
  }

  /// Доставить push'и (кроме [drop]), пока они порождают новые. Сначала
  /// дожидается фоновых отправок (flush) всех устройств.
  Future<void> deliver({bool Function(_Device device, sc.SecretUpdate update)? drop}) async {
    for (final device in devices) {
      await device.sync.flush();
    }
    while (pushes.isNotEmpty) {
      final batch = List.of(pushes);
      pushes.clear();
      for (final (device, update) in batch) {
        if (device.offline || (drop?.call(device, update) ?? false)) continue;
        await device.sync.handlePush(sc.SecretUpdates(updates: [update]).writeToBuffer());
      }
    }
  }

  Never _fail(String error) => throw SecretChatRequestException(error, 9);

  sc.SecretChats_Response handle(_Device device, sc.SecretChats_Request request) {
    switch (request.whichRequest()) {
      case sc.SecretChats_Request_Request.createChat:
        final peers = devices.where((d) => _hex(d.userID) == _hex(request.createChat.userID) && d.capable).toList();
        if (peers.isEmpty) _fail('secretChat.peerUnsupported');
        final id = List<int>.filled(12, 0)..[11] = _nextID++;
        final chat = _Chat(id, device, request.createChat.userID, peers);
        chats[_hex(id)] = chat;
        for (final peer in peers) {
          _enqueue(
            peer,
            id,
            sc.SecretUpdate(
              requested: sc.SecretUpdate_Requested(fromUserID: device.userID, commitment: request.createChat.commitment),
            ),
          );
        }
        return sc.SecretChats_Response(
          createChat: sc.SecretChats_CreateResult(chat: sc.SecretChat(secretChatID: id)),
        );

      case sc.SecretChats_Request_Request.accept:
        final chat = chats[_hex(request.accept.secretChatID)]!;
        if (chat.state != sc.SecretChat_State.REQUESTED && chat.peer != device) _fail('secretChat.badState');
        chat
          ..state = sc.SecretChat_State.ACCEPTED
          ..peer = device;
        _enqueue(
          chat.initiator,
          chat.id,
          sc.SecretUpdate(
            accepted: sc.SecretUpdate_Accepted(ephemeralKey: request.accept.ephemeralKey, kemPublicKey: request.accept.kemPublicKey),
          ),
        );
        for (final other in chat.requested.where((d) => d != device)) {
          _enqueue(
            other,
            chat.id,
            sc.SecretUpdate(discarded: sc.SecretUpdate_Discarded(reason: sc.SecretUpdate_Discarded_Reason.ACCEPTED_ELSEWHERE)),
          );
        }
        return sc.SecretChats_Response(accept: sc.SecretChats_AcceptResult());

      case sc.SecretChats_Request_Request.commit:
        final chat = chats[_hex(request.commit.secretChatID)]!;
        if (chat.state != sc.SecretChat_State.ACCEPTED && chat.state != sc.SecretChat_State.READY) _fail('secretChat.badState');
        chat.state = sc.SecretChat_State.READY;
        final commit = request.commit;
        _enqueue(
          chat.peer!,
          chat.id,
          sc.SecretUpdate(
            committed: sc.SecretUpdate_Committed(
              ephemeralKey: commit.ephemeralKey,
              nonce: commit.nonce,
              kemCiphertext: commit.kemCiphertext,
              ratchetKey: commit.ratchetKey,
            ),
          ),
        );
        return sc.SecretChats_Response(commit: sc.SecretChats_CommitResult());

      case sc.SecretChats_Request_Request.send:
        final chat = chats[_hex(request.send.secretChatID)]!;
        if (chat.state != sc.SecretChat_State.READY) _fail('secretChat.badState');
        if (sentRandomIDs.add('${_hex(device.sessionID)}:${request.send.randomID}')) {
          final recipient = chat.initiator == device ? chat.peer! : chat.initiator;
          _enqueue(
            recipient,
            chat.id,
            sc.SecretUpdate(
              newMessage: sc.SecretUpdate_NewMessage(randomID: request.send.randomID, envelope: request.send.envelope),
            ),
          );
        }
        return sc.SecretChats_Response(send: sc.SecretChats_SendResult(date: Int64(DateTime.now().millisecondsSinceEpoch)));

      case sc.SecretChats_Request_Request.discard:
        final chat = chats[_hex(request.discard.secretChatID)]!;
        if (chat.state == sc.SecretChat_State.DISCARDED) return sc.SecretChats_Response(discard: sc.SecretChats_DiscardResult());
        chat.state = sc.SecretChat_State.DISCARDED;
        final other = chat.initiator == device ? chat.peer! : chat.initiator;
        _enqueue(
          other,
          chat.id,
          sc.SecretUpdate(
            discarded: sc.SecretUpdate_Discarded(
              reason: sc.SecretUpdate_Discarded_Reason.BY_PEER,
              deleteHistory: request.discard.deleteHistory,
            ),
          ),
        );
        return sc.SecretChats_Response(discard: sc.SecretChats_DiscardResult());

      case sc.SecretChats_Request_Request.getUpdates:
        final after = request.getUpdates.afterQts.toInt();
        final queue = queues[_hex(device.sessionID)] ?? const [];
        return sc.SecretChats_Response(getUpdates: sc.SecretChats_GetUpdatesResult(updates: queue.where((u) => u.qts.toInt() > after)));

      case sc.SecretChats_Request_Request.ack:
        queues[_hex(device.sessionID)]?.removeWhere((u) => u.qts <= request.ack.maxQts);
        return sc.SecretChats_Response(ack: sc.SecretChats_AckResult());

      case sc.SecretChats_Request_Request.notSet:
        throw StateError('empty request');
    }
  }
}

class _Transport implements SecretChatsTransport {
  final _FakeServer server;
  late _Device device;

  _Transport(this.server);

  @override
  Future<sc.SecretChats_Response> request(sc.SecretChats_Request request) async {
    if (device.offline) throw const ChatsOfflineException();
    // Как по сети: сервер получает копию байт.
    return server.handle(device, sc.SecretChats_Request.fromBuffer(request.writeToBuffer()));
  }
}

class _Device {
  final List<int> userID;
  final List<int> sessionID;
  final bool capable;
  final SqliteDatabase db;
  late final SecretChatsRepository store;
  late final SecretChatsSync sync;
  bool offline = false;

  _Device(this.userID, this.sessionID, this.db, _FakeServer server, Logger logger, {this.capable = true}) {
    store = SecretChatsRepository(logger: logger, db: db);
    final transport = _Transport(server);
    sync = SecretChatsSync(
      store: () => store,
      crypto: () => SecretChatCrypto(logger: logger),
      transport: transport,
      sessionID: () => sessionID,
      userID: () => userID,
      hasNetwork: () async => !offline,
    );
    transport.device = this;
    server.devices.add(this);
  }

  Future<SecretChatRecord> chat(List<int> id) async => (await store.chat(sessionID: sessionID, secretChatID: id))!;

  Future<List<SecretMessageRecord>> messages(List<int> id) => store.messages(sessionID: sessionID, secretChatID: id);
}

void main() {
  late Directory dir;
  late _FakeServer server;
  late Logger logger;
  final databases = <SqliteDatabase>[];
  var counter = 0;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('secret_chats');
    server = _FakeServer();
    logger = Logger();
  });

  tearDown(() async {
    for (final db in databases) {
      await db.close();
    }
    databases.clear();
    await dir.delete(recursive: true);
  });

  Future<_Device> device({List<int>? userID, bool capable = true}) async {
    counter++;
    final db = SqliteDatabase(path: '${dir.path}/device$counter.db');
    databases.add(db);
    for (final statement in SecretChatsRepository.schema) {
      await db.execute(statement);
    }
    return _Device(
      userID ?? (List<int>.filled(12, 0)..[0] = counter),
      List<int>.filled(12, 0)..[1] = counter,
      db,
      server,
      logger,
      capable: capable,
    );
  }

  /// A создаёт чат с b, рукопожатие доходит до конца.
  Future<Uint8List> handshake(_Device a, _Device b) async {
    final id = await a.sync.create(b.userID);
    await server.deliver();
    expect((await a.chat(id)).state, SecretChatLocalState.ready);
    expect((await b.chat(id)).state, SecretChatLocalState.ready);
    return id;
  }

  test('рукопожатие, переписка, прочтение', () async {
    final a = await device();
    final b = await device();

    final id = await a.sync.create(b.userID);
    expect((await a.chat(id)).state, SecretChatLocalState.waiting);
    await server.deliver();

    final chatA = await a.chat(id);
    final chatB = await b.chat(id);
    expect(chatA.state, SecretChatLocalState.ready);
    expect(chatB.state, SecretChatLocalState.ready);
    expect(chatA.outgoing, isTrue);
    expect(chatB.outgoing, isFalse);
    expect(chatB.peerUserID, a.userID);
    expect(chatA.emoji, hasLength(SecretChatCrypto.fingerprintEmojiCount));
    expect(chatA.emoji, chatB.emoji);
    expect(chatA.fingerprint, chatB.fingerprint);
    expect(chatA.pending, isNull);
    expect(chatB.pending, isNull);

    await a.sync.sendText(id, 'привет');
    await server.deliver();
    await b.sync.sendText(id, 'и тебе');
    await server.deliver();

    // Порядок у обоих — по времени сервера.
    expect([for (final m in await a.messages(id)) m.text], ['привет', 'и тебе']);
    final inB = await b.messages(id);
    expect([for (final m in inB) m.text], ['привет', 'и тебе']);
    expect(inB.first.status, SecretMessageStatus.unread);
    expect((await b.chat(id)).unreadCount, 1);
    expect((await a.messages(id)).first.status, SecretMessageStatus.sent);

    await b.sync.markRead(id);
    await server.deliver();
    expect((await b.chat(id)).unreadCount, 0);
    expect((await a.messages(id)).first.status, SecretMessageStatus.read);
  });

  test('без сети: сообщение ждёт в outbox, уходит при подключении', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    a.offline = true;
    await a.sync.sendText(id, 'офлайн');
    expect((await a.messages(id)).single.status, SecretMessageStatus.pending);
    expect(await a.store.outbox(sessionID: a.sessionID), hasLength(1));

    a.offline = false;
    await a.sync.onConnected();
    await server.deliver();
    expect((await a.messages(id)).single.status, SecretMessageStatus.sent);
    expect(await a.store.outbox(sessionID: a.sessionID), isEmpty);
    expect((await b.messages(id)).single.text, 'офлайн');
  });

  test('потерянный push — догон через GetUpdates', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    await a.sync.sendText(id, 'раз');
    await a.sync.sendText(id, 'два');
    await a.sync.sendText(id, 'три');
    var first = true;
    await server.deliver(
      drop: (device, update) {
        if (device != b || !update.hasNewMessage() || !first) return false;
        first = false;
        return true;
      },
    );
    // Второй push увидел дыру и догнал первый.
    expect([for (final m in await b.messages(id)) m.text], ['раз', 'два', 'три']);
  });

  test('собеседник офлайн при запросе: принимает при подключении', () async {
    final a = await device();
    final b = await device();
    b.offline = true;

    final id = await a.sync.create(b.userID);
    await server.deliver();
    expect((await a.chat(id)).state, SecretChatLocalState.waiting);

    // A пишет до готовности — нельзя (чат ещё не готов).
    await expectLater(a.sync.sendText(id, 'рано'), throwsA(isA<SecretChatException>()));

    b.offline = false;
    await b.sync.onConnected();
    await server.deliver();
    expect((await a.chat(id)).state, SecretChatLocalState.ready);
    expect((await b.chat(id)).state, SecretChatLocalState.ready);
  });

  test('два устройства собеседника: второе получает «принято на другом»', () async {
    final a = await device();
    final b1 = await device();
    final b2 = await device(userID: b1.userID);
    final old = await device(userID: b1.userID, capable: false);

    final id = await a.sync.create(b1.userID);
    // Оба устройства B получат запрос; первым принимает b1.
    await server.deliver();
    expect((await a.chat(id)).state, SecretChatLocalState.ready);
    final readyOn = [
      for (final d in [b1, b2]) (await d.store.chat(sessionID: d.sessionID, secretChatID: id))?.state,
    ];
    expect(readyOn.where((s) => s == SecretChatLocalState.ready), hasLength(1));
    expect(readyOn.where((s) => s == null), hasLength(1), reason: 'второе устройство удалило чужой чат');
    expect(await old.store.chats(sessionID: old.sessionID), isEmpty);
  });

  test('закрытие с удалением истории у обоих', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);
    await a.sync.sendText(id, 'секрет');
    await server.deliver();

    await a.sync.discard(id, deleteHistory: true);
    await server.deliver();
    final chatB = await b.chat(id);
    expect(chatB.state, SecretChatLocalState.discarded);
    expect(chatB.ratchet, isNull);
    expect(await b.messages(id), isEmpty);
    expect(await a.messages(id), isEmpty);
    await expectLater(b.sync.sendText(id, 'поздно'), throwsA(isA<SecretChatException>()));

    await b.sync.discard(id, removeLocal: true);
    expect(await b.store.chats(sessionID: b.sessionID), isEmpty);
  });

  test('удаление сообщения у обоих', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);
    await a.sync.sendText(id, 'оставить');
    await a.sync.sendText(id, 'удалить');
    await server.deliver();

    final toDelete = (await a.messages(id)).last.randomID;
    await a.sync.deleteMessages(id, [toDelete]);
    await server.deliver();
    expect([for (final m in await a.messages(id)) m.text], ['оставить']);
    expect([for (final m in await b.messages(id)) m.text], ['оставить']);
    expect((await b.chat(id)).unreadCount, 1);
  });

  test('у собеседника нет поддерживающих устройств', () async {
    final a = await device();
    final old = await device(capable: false);
    await expectLater(
      a.sync.create(old.userID),
      throwsA(isA<SecretChatRequestException>().having((e) => e.isPeerUnsupported, 'isPeerUnsupported', isTrue)),
    );
    expect(await a.store.chats(sessionID: a.sessionID), isEmpty);
  });
}
