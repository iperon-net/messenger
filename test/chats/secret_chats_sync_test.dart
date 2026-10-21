import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_sync.dart' show ChatsOfflineException;
import 'package:messenger/chats/secret/secret_chats_sync.dart';
import 'package:messenger/crypto.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/secret_chats_v1.pb.dart' as sc;
import 'package:messenger/protobuf/protos/secret_payload_v1.pb.dart' as sp;
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

  /// Прикреплённые файлы: fileID (hex) → чат (hex); освобождённые.
  final attached = <String, String>{};
  final released = <String>{};

  /// randomID конвертов, отправленных с notify (push получателю).
  final notified = <int>{};

  /// Часы сервера и устройств (самоуничтожение, даты конвертов) — двигаются тестом.
  DateTime now = DateTime(2026, 10, 18, 12);
  final pushes = <(_Device, sc.SecretUpdate)>[];
  var _nextID = 1;

  void _enqueue(_Device device, List<int> chatID, sc.SecretUpdate update) {
    final key = _hex(device.sessionID);
    final number = (qts[key] ?? 0) + 1;
    qts[key] = number;
    update
      ..qts = Int64(number)
      ..date = Int64(now.millisecondsSinceEpoch)
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
        for (final file in request.send.fileIDs) {
          final owner = attached[_hex(file)];
          if (owner != null && owner != _hex(chat.id)) _fail('secretChat.fileForbidden');
          attached[_hex(file)] = _hex(chat.id);
        }
        if (request.send.notify) notified.add(request.send.randomID.toInt());
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
        return sc.SecretChats_Response(send: sc.SecretChats_SendResult(date: Int64(now.millisecondsSinceEpoch)));

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

      case sc.SecretChats_Request_Request.getFiles:
        return sc.SecretChats_Response(
          getFiles: sc.SecretChats_GetFilesResult(
            files: [
              for (final file in request.getFiles.fileIDs)
                if (attached[_hex(file)] == _hex(request.getFiles.secretChatID))
                  sc.SecretFile(fileID: file, url: 'https://cdn.test/${_hex(file)}'),
            ],
          ),
        );

      case sc.SecretChats_Request_Request.releaseFiles:
        released.addAll([for (final file in request.releaseFiles.fileIDs) _hex(file)]);
        return sc.SecretChats_Response(releaseFiles: sc.SecretChats_ReleaseFilesResult());

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

/// Загрузка «на CDN» в памяти: случайные fileID / ключ; [gate] — придержать
/// загрузку до команды.
class _Uploader implements SecretMediaUploader {
  late _Device device;
  Completer<void>? gate;
  final uploaded = <String, Uint8List>{};
  var _next = 1;

  @override
  Future<SecretUploadedFile> upload(
    File file, {
    required String contentType,
    void Function(int sent, int total)? onProgress,
    bool Function()? isCancelled,
  }) async {
    if (device.offline) throw const SocketException('offline');
    final pending = gate;
    if (pending != null) await pending.future;
    if (isCancelled?.call() ?? false) throw StateError('cancelled');
    final bytes = await file.readAsBytes();
    onProgress?.call(bytes.length, bytes.length);
    final id = Uint8List(12)
      ..[0] = 0xF1
      ..[1] = device.sessionID[1]
      ..[11] = _next++;
    uploaded[_hex(id)] = bytes;
    return SecretUploadedFile(
      fileID: id,
      key: Uint8List.fromList(List.filled(32, _next)),
      hkdfSalt: Uint8List.fromList(List.filled(32, 7)),
      sha256: Uint8List.fromList(List.filled(32, 9)),
    );
  }
}

class _Device {
  final List<int> userID;
  final List<int> sessionID;
  final bool capable;
  final SqliteDatabase db;
  late final SecretChatsRepository store;
  late final SecretChatsSync sync;
  final uploader = _Uploader();
  final Directory mediaDir;

  /// Файлы, убранные с устройства (скачанные вложения удалённых сообщений).
  final evicted = <String>[];
  bool offline = false;

  _Device(this.userID, this.sessionID, this.db, this.mediaDir, _FakeServer server, Logger logger, {this.capable = true}) {
    store = SecretChatsRepository(logger: logger, db: db);
    final transport = _Transport(server);
    sync = SecretChatsSync(
      store: () => store,
      crypto: () => SecretChatCrypto(logger: logger),
      transport: transport,
      sessionID: () => sessionID,
      userID: () => userID,
      hasNetwork: () async => !offline,
      uploader: uploader,
      mediaDir: () async => mediaDir,
      releaseLocal: (ids) => evicted.addAll([for (final id in ids) _hex(id)]),
      clock: () => server.now,
      clearNotifications: (_) {},
    );
    transport.device = this;
    uploader.device = this;
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
    for (final statement in [...SecretChatsRepository.schema, ...SecretChatsRepository.schemaMedia, ...SecretChatsRepository.schemaTimer]) {
      await db.execute(statement);
    }
    final media = await Directory('${dir.path}/media$counter').create();
    return _Device(
      userID ?? (List<int>.filled(12, 0)..[0] = counter),
      List<int>.filled(12, 0)..[1] = counter,
      db,
      media,
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

  /// Файл-«фото» во временном каталоге.
  Future<String> photo(String name, {int size = 1000}) async {
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(List.filled(size, 42));
    return file.path;
  }

  test('вложение: загрузка, конверт с ключом, получение', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    final thumb = await photo('thumb.jpg', size: 300);
    await a.sync.sendMedia(
      id,
      SecretMediaDraft(
        kind: SecretMessageKind.video,
        path: await photo('clip.mp4', size: 5000),
        mimeType: 'video/mp4',
        width: 640,
        height: 360,
        duration: 12,
        thumbhash: 'th',
        thumbPath: thumb,
      ),
      caption: 'смотри',
    );
    await server.deliver();

    final sent = (await a.messages(id)).single;
    expect(sent.status, SecretMessageStatus.sent);
    expect(sent.kind, SecretMessageKind.video);
    expect(sent.localPath, isEmpty, reason: 'копия файла после загрузки не нужна');
    expect(a.mediaDir.listSync(), isEmpty);
    final sentMedia = sp.SecretMedia.fromBuffer(sent.media!);
    expect(sentMedia.fileID, isNotEmpty);
    expect(server.attached[_hex(sentMedia.fileID)], _hex(id));

    final received = (await b.messages(id)).single;
    expect(received.kind, SecretMessageKind.video);
    expect(received.text, 'смотри');
    expect(received.status, SecretMessageStatus.unread);
    final media = sp.SecretMedia.fromBuffer(received.media!);
    expect(media.fileID, sentMedia.fileID);
    expect(media.key, sentMedia.key);
    expect(media.hkdfSalt, sentMedia.hkdfSalt);
    expect(media.sha256, sentMedia.sha256);
    expect(media.size.toInt(), 5000);
    expect(media.mimeType, 'video/mp4');
    expect([media.width, media.height, media.duration], [640, 360, 12]);
    expect(media.thumb, hasLength(300), reason: 'маленькая обложка — прямо в конверте');
    expect(media.thumbhash, 'th');
    expect(media.caption, 'смотри');

    // Ссылку получателю выдают только на файлы этого чата.
    final urls = await b.sync.fileUrls(id, [media.fileID, Uint8List(12)]);
    expect(urls.keys, [_hex(media.fileID)]);
  });

  test('вложение держит очередь чата: текст после фото приходит после него', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    a.uploader.gate = Completer<void>();
    await a.sync.sendMedia(id, SecretMediaDraft(kind: SecretMessageKind.photo, path: await photo('a.jpg'), mimeType: 'image/jpeg'));
    await a.sync.sendText(id, 'подпись следом');
    // Фото грузится — текст ждёт (deliver не дожидается flush: он висит на загрузке).
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    expect(await b.messages(id), isEmpty);

    a.uploader.gate!.complete();
    a.uploader.gate = null;
    await server.deliver();
    expect([for (final m in await b.messages(id)) m.kind], [SecretMessageKind.photo, SecretMessageKind.text]);
  });

  test('вложение без сети ждёт, при подключении уходит', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    a.offline = true;
    await a.sync.sendMedia(id, SecretMediaDraft(kind: SecretMessageKind.file, path: await photo('doc.pdf'), fileName: 'Договор.pdf'));
    await a.sync.flush();
    final pending = (await a.messages(id)).single;
    expect(pending.status, SecretMessageStatus.pending);
    expect(pending.localPath, isNotEmpty);
    expect(await a.store.uploads(sessionID: a.sessionID), hasLength(1));

    a.offline = false;
    await a.sync.onConnected();
    await server.deliver();
    expect(await a.store.uploads(sessionID: a.sessionID), isEmpty);
    final received = (await b.messages(id)).single;
    expect(received.kind, SecretMessageKind.file);
    expect(sp.SecretMedia.fromBuffer(received.media!).fileName, 'Договор.pdf');
  });

  test('файл пропал до загрузки — «не отправлено»', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    a.offline = true;
    await a.sync.sendMedia(id, SecretMediaDraft(kind: SecretMessageKind.photo, path: await photo('gone.jpg')));
    for (final file in a.mediaDir.listSync()) {
      file.deleteSync();
    }
    a.offline = false;
    await a.sync.onConnected();
    await server.deliver();
    expect((await a.messages(id)).single.status, SecretMessageStatus.failed);
    expect(await a.store.uploads(sessionID: a.sessionID), isEmpty);
    expect(await b.messages(id), isEmpty);
  });

  test('удаление вложения у обоих убирает файлы и освобождает их на сервере', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);
    await a.sync.sendMedia(id, SecretMediaDraft(kind: SecretMessageKind.photo, path: await photo('p.jpg')));
    await server.deliver();
    final fileID = _hex(sp.SecretMedia.fromBuffer((await b.messages(id)).single.media!).fileID);

    await b.sync.deleteMessages(id, [(await b.messages(id)).single.randomID]);
    await server.deliver();
    expect(await a.messages(id), isEmpty);
    expect(await b.messages(id), isEmpty);
    expect(a.evicted, [fileID]);
    expect(b.evicted, [fileID]);
    expect(server.released, {fileID});
  });

  test('удалили вложение, пока оно ждало загрузки — не уходит', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    a.offline = true;
    await a.sync.sendMedia(id, SecretMediaDraft(kind: SecretMessageKind.photo, path: await photo('x.jpg')));
    await a.sync.deleteMessages(id, [(await a.messages(id)).single.randomID]);
    expect(a.mediaDir.listSync(), isEmpty);
    expect(await a.store.uploads(sessionID: a.sessionID), isEmpty);
    a.offline = false;
    await a.sync.onConnected();
    await server.deliver();
    expect(await b.messages(id), isEmpty);
  });

  test('таймер самоуничтожения: у обоих, отсчёт с прочтения', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    await a.sync.setTtl(id, 5);
    await server.deliver();
    expect((await a.chat(id)).ttl, 5);
    expect((await b.chat(id)).ttl, 5);
    final serviceB = (await b.messages(id)).single;
    expect(serviceB.kind, SecretMessageKind.ttlChange);
    expect(serviceB.ttl, 5);
    expect((await b.chat(id)).unreadCount, 0, reason: 'служебное не непрочитанное');

    await a.sync.sendText(id, 'сгорит');
    await server.deliver();
    final inB = (await b.messages(id)).last;
    expect(inB.ttl, 5);
    expect(inB.expiresAt, isNull, reason: 'не прочитано — таймер не идёт');

    await b.sync.markRead(id);
    await server.deliver();
    final started = server.now;
    expect((await b.messages(id)).last.expiresAt, started.add(const Duration(seconds: 5)));
    expect((await a.messages(id)).last.expiresAt, started.add(const Duration(seconds: 5)));

    server.now = started.add(const Duration(seconds: 4));
    await a.sync.expireNow();
    expect(await a.messages(id), hasLength(2));

    server.now = started.add(const Duration(seconds: 6));
    await a.sync.expireNow();
    await b.sync.expireNow();
    expect([for (final m in await a.messages(id)) m.kind], [SecretMessageKind.ttlChange]);
    expect([for (final m in await b.messages(id)) m.kind], [SecretMessageKind.ttlChange]);

    // Отправитель проспал отметку о прочтении: отсчёт всё равно с прочтения —
    // проснулся после срока, сообщение удаляется сразу.
    await a.sync.sendText(id, 'проспал');
    await server.deliver();
    await b.sync.markRead(id);
    final readAt = server.now;
    await server.deliver(drop: (device, _) => device == a);
    server.now = readAt.add(const Duration(minutes: 1));
    await a.sync.onConnected();
    await a.sync.expireNow();
    expect([for (final m in await a.messages(id)) m.kind], [SecretMessageKind.ttlChange]);

    // Выключили — новые без таймера.
    await b.sync.setTtl(id, 0);
    await server.deliver();
    await a.sync.sendText(id, 'останется');
    await server.deliver();
    expect((await b.messages(id)).last.ttl, 0);
  });

  test('скриншот и push только о сообщениях', () async {
    final a = await device();
    final b = await device();
    final id = await handshake(a, b);

    await a.sync.sendText(id, 'текст');
    await server.deliver();
    final text = (await a.messages(id)).single.randomID;
    await b.sync.markRead(id);
    await a.sync.screenshotTaken(id);
    await server.deliver();

    final inB = await b.messages(id);
    expect(inB.last.kind, SecretMessageKind.screenshot);
    expect(inB.last.outgoing, isFalse);
    expect((await a.messages(id)).last.kind, SecretMessageKind.screenshot);
    expect(server.notified, {text, inB.last.randomID}, reason: '«прочитано» — без пуша');
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
