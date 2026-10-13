import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Отложенные: без сети ждут в outbox (scheduleDate), принятые сервером — в
// chatScheduled, и их копия из outbox уходит; удаление и полный список с
// сервера.
void main() {
  final me = List<int>.filled(12, 1);
  final chat = List<int>.filled(12, 9);

  late Directory dir;
  late SqliteDatabase db;
  late ChatsRepository store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('scheduled');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    // Как после миграций 24 и 27 (без внешних ключей на users).
    await db.execute('''
      CREATE TABLE chatOutbox (
        userID BLOB NOT NULL,
        randomID INTEGER NOT NULL,
        chatID BLOB NULL,
        peerUserID BLOB NULL,
        content BLOB NOT NULL,
        silent INTEGER NOT NULL DEFAULT 0,
        failed INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL,
        media TEXT NOT NULL DEFAULT '',
        forwardChatID BLOB NULL,
        forwardMessageID INTEGER NOT NULL DEFAULT 0,
        scheduleDate INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (userID, randomID)
      );
    ''');
    await db.execute('''
      CREATE TABLE chatScheduled (
        userID BLOB NOT NULL,
        chatID BLOB NOT NULL,
        scheduledID INTEGER NOT NULL,
        date INTEGER NOT NULL,
        message BLOB NOT NULL,
        PRIMARY KEY (userID, chatID, scheduledID)
      );
    ''');
    store = ChatsRepository(logger: Logger(), db: db);
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  pb.ScheduledMessage scheduled(int id, int date, {int randomID = 0}) => pb.ScheduledMessage(
    chatID: chat,
    scheduledID: Int64(id),
    date: Int64(date),
    content: pb.MessageContent(text: 'm$id'),
    randomID: Int64(randomID),
  );

  test('outbox → сервер, перенос, удаление', () async {
    await store.addOutbox(
      userID: me,
      randomID: 7,
      chatID: chat,
      content: pb.MessageContent(text: 'позже').writeToBuffer(),
      scheduleDate: 5000,
    );
    final queued = (await store.outbox(userID: me, chatID: chat)).single;
    expect(queued.isScheduled, isTrue);
    expect(queued.scheduleDate, 5000);

    // «Отправить сейчас» без сети — обычное неотправленное.
    await store.markOutboxFailed(userID: me, randomID: 7);
    await store.setOutboxScheduleDate(userID: me, randomID: 7, scheduleDate: 0);
    final now = (await store.outbox(userID: me, chatID: chat)).single;
    expect(now.isScheduled, isFalse);
    expect(now.failed, isFalse);

    // Принято сервером — копия из outbox уходит.
    await store.upsertScheduled(userID: me, message: scheduled(1, 9000, randomID: 7));
    expect(await store.outbox(userID: me, chatID: chat), isEmpty);
    await store.upsertScheduled(userID: me, message: scheduled(2, 3000));
    expect([for (final m in await store.scheduled(userID: me, chatID: chat)) m.scheduledID.toInt()], [2, 1]);

    // Перенос — та же строка.
    await store.upsertScheduled(userID: me, message: scheduled(2, 10000));
    expect([for (final m in await store.scheduled(userID: me, chatID: chat)) m.scheduledID.toInt()], [1, 2]);

    await store.deleteScheduled(userID: me, chatID: chat, scheduledIDs: [1]);
    expect((await store.scheduled(userID: me, chatID: chat)).single.scheduledID.toInt(), 2);

    await store.replaceScheduled(userID: me, chatID: chat, messages: [scheduled(3, 1)]);
    expect((await store.scheduled(userID: me, chatID: chat)).single.content.text, 'm3');
  });

  test('id отложенного', () {
    expect(scheduledIDOf(scheduledMessageID(42)), 42);
    expect(scheduledIDOf(localMessageID(42)), isNull);
    expect(scheduledIDOf('42'), isNull);
  });
}
