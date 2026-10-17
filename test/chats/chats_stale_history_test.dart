import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Долгий офлайн (`tooLong`): кэш истории не стирается, а становится
// несверенным; страницы с сервера сверяют его (удалённое удаляется, правки
// перезаписываются) и сдвигают границу вниз.
void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);
  final chat = List<int>.filled(12, 9);

  late Directory dir;
  late SqliteDatabase db;
  late ChatsRepository store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('stale_history');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    // Столбцы — как после миграции 28.
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
        ttlPeriod INTEGER NOT NULL DEFAULT 0,
        noForwards INTEGER NOT NULL DEFAULT 0,
        historyStaleBelow INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (userID, chatID)
      );
    ''');
    await db.execute('''
      CREATE TABLE chatMessages (
        userID BLOB NOT NULL,
        chatID BLOB NOT NULL,
        messageID INTEGER NOT NULL,
        fromUserID BLOB NOT NULL,
        date INTEGER NOT NULL,
        editDate INTEGER NOT NULL DEFAULT 0,
        randomID INTEGER NOT NULL DEFAULT 0,
        mediaUnread INTEGER NOT NULL DEFAULT 0,
        silent INTEGER NOT NULL DEFAULT 0,
        content BLOB NOT NULL,
        searchText TEXT NOT NULL DEFAULT '',
        reactions BLOB NULL,
        reactionsUnread INTEGER NOT NULL DEFAULT 0,
        expireAt INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (userID, chatID, messageID)
      );
    ''');
    await db.execute('''
      CREATE TABLE chatPinned (
        userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, message BLOB NOT NULL,
        PRIMARY KEY (userID, chatID, messageID)
      );
    ''');
    await db.execute('''
      CREATE TABLE chatPendingReactions (
        userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, emojis TEXT NOT NULL, createdAt INTEGER NOT NULL,
        PRIMARY KEY (userID, chatID, messageID)
      );
    ''');
    store = ChatsRepository(logger: Logger(), db: db);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  pb.ChatMessage message(int id, [String text = '']) => pb.ChatMessage(
    chatID: chat,
    messageID: Int64(id),
    fromUserID: peer,
    date: Int64(id * 1000),
    content: pb.MessageContent(text: text.isEmpty ? 'm$id' : text),
  );

  /// Страница истории с сервера — по убыванию, как отдаёт сервер.
  List<pb.ChatMessage> page(Iterable<int> ids) => [for (final id in ids.toList()..sort((a, b) => b - a)) message(id)];

  Future<List<int>> cached() async => [
    for (final row in await db.getAll('SELECT messageID FROM chatMessages ORDER BY messageID;')) row['messageID'] as int,
  ];

  Future<int> stale() => store.historyStaleBelow(userID: me, chatID: chat);

  test('после tooLong история остаётся и сверяется страницами', () async {
    for (var id = 1; id <= 10; id++) {
      await store.upsertMessage(userID: me, message: message(id));
    }

    // Журнал обрезан: перезагрузка диалогов не стирает историю, а помечает.
    await store.replaceDialogs(
      userID: me,
      dialogs: [pb.Dialog(chatID: chat, peerUserID: peer, topMessage: message(30))],
      staleHistory: true,
    );
    expect(await stale(), 11);
    expect(await cached(), [for (var id = 1; id <= 10; id++) id, 30]);

    // Открыли чат: самая новая страница 21..30 (22 удалено на сервере) не
    // дотянулась до кэша — старое остаётся несверенным ниже 21.
    var next = await store.applyHistoryPage(
      userID: me,
      chatID: chat,
      messages: page([21, 23, 24, 25, 26, 27, 28, 29, 30]),
      offsetID: 0,
      hasMore: true,
    );
    expect(next, 21);
    expect(await cached(), [for (var id = 1; id <= 10; id++) id, 21, 23, 24, 25, 26, 27, 28, 29, 30]);

    // Страница ниже границы: 11..20, а в кэше несверенные 7..10 — 8 удалили
    // на сервере, 9 правили.
    next = await store.applyHistoryPage(
      userID: me,
      chatID: chat,
      messages: [
        ...page([11, 12, 13, 14, 15, 16, 17, 18, 19, 20]),
        message(10),
        message(9, 'правка'),
        message(7),
      ],
      offsetID: 21,
      hasMore: true,
    );
    expect(next, 7);
    final ids = await cached();
    expect(ids.contains(8), isFalse);
    expect(ids.where((id) => id >= 7 && id <= 20), [7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]);
    final edited = await store.messages(userID: me, chatID: chat);
    expect(edited.firstWhere((m) => m.messageID.toInt() == 9).content.text, 'правка');

    // Последняя страница (старше нет): 1..6, из них 3 удалено — всё сверено.
    next = await store.applyHistoryPage(userID: me, chatID: chat, messages: page([1, 2, 4, 5, 6]), offsetID: 7, hasMore: false);
    expect(next, 0);
    expect(await stale(), 0);
    expect((await cached()).contains(3), isFalse);
  });

  test('без долгого офлайна граница не появляется', () async {
    for (var id = 1; id <= 5; id++) {
      await store.upsertMessage(userID: me, message: message(id));
    }
    // Свежая страница стыкуется с кэшем — сверено, граница не нужна.
    final next = await store.applyHistoryPage(userID: me, chatID: chat, messages: page([4, 5, 6]), offsetID: 0, hasMore: true);
    expect(next, 0);
    expect(await cached(), [1, 2, 3, 4, 5, 6]);
  });

  test('дыра без tooLong — старое не стирается, а несверено', () async {
    for (var id = 1; id <= 5; id++) {
      await store.upsertMessage(userID: me, message: message(id));
    }
    final next = await store.applyHistoryPage(userID: me, chatID: chat, messages: page([40, 41, 42]), offsetID: 0, hasMore: true);
    expect(next, 40);
    expect(await cached(), [1, 2, 3, 4, 5, 40, 41, 42]);
  });

  test('пустая история на сервере — несверенное удаляется', () async {
    for (var id = 1; id <= 3; id++) {
      await store.upsertMessage(userID: me, message: message(id));
    }
    await store.markHistoryStale(userID: me);
    final next = await store.applyHistoryPage(userID: me, chatID: chat, messages: const [], offsetID: 0, hasMore: false);
    expect(next, 0);
    expect(await cached(), isEmpty);
  });
}
