import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Черновик между устройствами: свой — сразу локально и в очередь, серверный
// не перезаписывает неотправленный свой.
void main() {
  final me = List<int>.filled(12, 1);
  final chat = List<int>.filled(12, 9);

  late Directory dir;
  late SqliteDatabase db;
  late ChatsRepository store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('drafts');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    // Столбцы chatDialogs, которые пишет upsertDialog, — как после миграции 25.
    await db.execute('''
      CREATE TABLE chatDialogs (
        userID BLOB NOT NULL,
        chatID BLOB NOT NULL,
        type INTEGER NOT NULL DEFAULT 0,
        peerUserID BLOB NULL,
        topMessageID INTEGER NOT NULL DEFAULT 0,
        topMessageDate INTEGER NOT NULL DEFAULT 0,
        topMessage BLOB NULL,
        readInboxMaxID INTEGER NOT NULL DEFAULT 0,
        readOutboxMaxID INTEGER NOT NULL DEFAULT 0,
        unreadCount INTEGER NOT NULL DEFAULT 0,
        unreadReactions INTEGER NOT NULL DEFAULT 0,
        pinned INTEGER NOT NULL DEFAULT 0,
        archived INTEGER NOT NULL DEFAULT 0,
        markedUnread INTEGER NOT NULL DEFAULT 0,
        mutedUntil INTEGER NOT NULL DEFAULT 0,
        draft TEXT NOT NULL DEFAULT '',
        draftPending INTEGER NOT NULL DEFAULT 0,
        createdAt INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (userID, chatID)
      );
    ''');
    store = ChatsRepository(logger: Logger(), db: db);
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  Future<String> draft() async => (await db.get('SELECT draft FROM chatDialogs;'))['draft'] as String;

  test('серверный черновик и свой неотправленный', () async {
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, draft: 'с другого'),
    );
    expect(await draft(), 'с другого');
    expect(await store.pendingDrafts(userID: me), isEmpty);

    // Свой: тот же текст — ничего; новый — в очередь.
    expect(await store.setDraft(userID: me, chatID: chat, draft: 'с другого'), isFalse);
    expect(await store.setDraft(userID: me, chatID: chat, draft: 'мой'), isTrue);
    expect([for (final d in await store.pendingDrafts(userID: me)) d.draft], ['мой']);

    // Пока свой не на сервере — серверный не перезаписывает.
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, draft: 'старый'),
    );
    await store.setServerDraft(userID: me, chatID: chat, draft: 'старый');
    expect(await draft(), 'мой');

    // Сервер принял не тот текст (успели поменять) — очередь остаётся.
    await store.draftSent(userID: me, chatID: chat, draft: 'другой');
    expect(await store.pendingDrafts(userID: me), hasLength(1));

    await store.draftSent(userID: me, chatID: chat, draft: 'мой');
    expect(await store.pendingDrafts(userID: me), isEmpty);
    // Отправил сообщение с другого устройства — черновик очищен.
    await store.setServerDraft(userID: me, chatID: chat, draft: '');
    expect(await draft(), isEmpty);
  });
}
