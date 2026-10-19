import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);
  final chat = List<int>.filled(12, 9);

  pb.ChatMessage message(int id, List<int> from, {bool unread = false}) => pb.ChatMessage(
    chatID: chat,
    messageID: Int64(id),
    fromUserID: from,
    date: Int64(1000),
    content: pb.MessageContent(text: 'привет'),
    reactionsUnread: unread,
  );

  test('флаг непрочитанных реакций — только на нашем сообщении', () {
    Object? mapped(List<int> from) =>
        messageFromPb(message(1, from, unread: true), chatID: 'c', myUserID: me, readOutboxMaxID: 0, isSelf: false).reactionsUnread;
    expect(mapped(me), isTrue);
    expect(mapped(peer), isFalse);
  });

  // Запросы кэша — на настоящем SQLite (только нужные столбцы chatMessages).
  group('кэш', () {
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('reactions');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await db.execute('''
        CREATE TABLE chatMessages (
          userID BLOB NOT NULL,
          chatID BLOB NOT NULL,
          messageID INTEGER NOT NULL,
          fromUserID BLOB NOT NULL,
          reactions BLOB NULL,
          reactionsUnread INTEGER NOT NULL DEFAULT 0,
          expireAt INTEGER NOT NULL DEFAULT 0, poll BLOB NULL,
          PRIMARY KEY (userID, chatID, messageID)
        );
      ''');
      await db.execute(ChatsRepository.mentionsSchema);
      for (final (id, from) in [(1, me), (2, peer), (3, me)]) {
        await db.execute('INSERT INTO chatMessages (userID, chatID, messageID, fromUserID) VALUES (?, ?, ?, ?);', [me, chat, id, from]);
      }
      store = ChatsRepository(logger: Logger(), db: db);
    });

    tearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    test('ставится на наших, на чужом — нет; просмотр и подсчёт', () async {
      final reactions = pb.MessageReactions(
        reactions: [pb.MessageReaction(userID: peer, emoji: '❤️')],
      );
      for (final id in [1, 2, 3]) {
        await store.setReactions(userID: me, chatID: chat, messageID: id, reactions: reactions, unread: true);
      }
      expect(await store.unreadReactionIDs(userID: me, chatID: chat), [1, 3]);
      expect(await store.countUnreadReactions(userID: me, chatID: chat, messageIDs: [2, 3]), 1);

      await store.readReactions(userID: me, chatID: chat, messageIDs: [1]);
      expect(await store.unreadReactionIDs(userID: me, chatID: chat), [3]);

      // Реакции сняли — флаг тоже.
      await store.setReactions(userID: me, chatID: chat, messageID: 3, reactions: pb.MessageReactions());
      expect(await store.unreadReactionIDs(userID: me, chatID: chat), isEmpty);
    });
  });
}
