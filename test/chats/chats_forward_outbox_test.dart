import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Пересылка в outbox: ссылка на исходное хранится рядом с превью, пачка
// уходит по порядку (createdAt строго растёт, randomID случаен).
void main() {
  final me = List<int>.filled(12, 1);
  final source = List<int>.filled(12, 8);
  final chat = List<int>.filled(12, 9);

  late Directory dir;
  late SqliteDatabase db;
  late ChatsRepository store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('forward');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    // Столбцы chatOutbox — как после миграции 24.
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
        PRIMARY KEY (userID, randomID)
      );
    ''');
    store = ChatsRepository(logger: Logger(), db: db);
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  test('пересылка — ссылка на исходное и порядок пачки', () async {
    final content = pb.MessageContent(
      text: 'привет',
      forward: pb.MessageForward(fromName: 'Анна'),
    ).writeToBuffer();
    // randomID нарочно убывают — порядок задаёт createdAt.
    for (final (i, randomID) in [(0, 30), (1, 20), (2, 10)]) {
      await store.addOutbox(
        userID: me,
        randomID: randomID,
        chatID: chat,
        content: content,
        forwardChatID: source,
        forwardMessageID: 100 + i,
        createdAt: 1000 + i,
      );
    }
    await store.addOutbox(
      userID: me,
      randomID: 5,
      chatID: chat,
      content: pb.MessageContent(text: 'x').writeToBuffer(),
      createdAt: 2000,
    );

    final rows = await store.outbox(userID: me, chatID: chat);
    expect([for (final r in rows) r.forwardMessageID], [100, 101, 102, 0]);
    expect(rows.first.isForward, isTrue);
    expect(rows.first.forwardChatID, source);
    expect(pb.MessageContent.fromBuffer(rows.first.content).forward.fromName, 'Анна');
    expect(rows.last.isForward, isFalse);
  });
}
