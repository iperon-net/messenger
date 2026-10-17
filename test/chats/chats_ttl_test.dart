import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/components/chats/message_bubble.dart' show chatTTLDay, chatTTLLabel, chatTTLServiceText;
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

void main() {
  final me = List<int>.filled(12, 1);
  final chat = List<int>.filled(12, 9);

  setUpAll(() async {
    await AppLocale.ru.build();
  });

  pb.ChatMessage message(int id, {int ttl = 0, int date = 1000}) => pb.ChatMessage(
    chatID: chat,
    messageID: Int64(id),
    fromUserID: me,
    date: Int64(date),
    content: pb.MessageContent(text: 'привет'),
    ttlPeriod: ttl,
  );

  test('срок словами: дни, недели, месяцы (31 день), год', () async {
    final t = await AppLocale.ru.build();
    expect(chatTTLLabel(t, 0), 'Выкл');
    expect(chatTTLLabel(t, chatTTLDay), '1 день');
    expect(chatTTLLabel(t, 2 * chatTTLDay), '2 дня');
    expect(chatTTLLabel(t, 7 * chatTTLDay), '1 неделя');
    expect(chatTTLLabel(t, 31 * chatTTLDay), '1 месяц');
    expect(chatTTLLabel(t, 155 * chatTTLDay), '5 месяцев');
    expect(chatTTLLabel(t, 365 * chatTTLDay), '1 год');
    expect(chatTTLServiceText(t, period: 7 * chatTTLDay, outgoing: true, name: ''), 'Вы включили автоудаление сообщений: 1 неделя');
    expect(chatTTLServiceText(t, period: 0, outgoing: false, name: 'Анна'), 'Анна выключил(а) автоудаление сообщений');
  });

  // Кэш — на настоящем SQLite (только нужные столбцы).
  group('кэш', () {
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('ttl');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await db.execute('''
        CREATE TABLE chatMessages (
          userID BLOB NOT NULL,
          chatID BLOB NOT NULL,
          messageID INTEGER NOT NULL,
          fromUserID BLOB NOT NULL,
          date INTEGER NOT NULL DEFAULT 0,
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
          userID BLOB NOT NULL,
          chatID BLOB NOT NULL,
          messageID INTEGER NOT NULL,
          message BLOB NOT NULL,
          shared INTEGER NOT NULL DEFAULT 1,
          PRIMARY KEY (userID, chatID, messageID)
        );
      ''');
      store = ChatsRepository(logger: Logger(), db: db);
    });

    tearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    test('таймер сохраняется, истёкшие — в истории и закреплённых', () async {
      await store.upsertMessage(userID: me, message: message(1));
      await store.upsertMessage(
        userID: me,
        message: message(2, ttl: chatTTLDay),
      );
      await store.upsertMessage(
        userID: me,
        message: message(3, ttl: 7 * chatTTLDay),
      );
      // Закреплённое старше истории — только в chatPinned.
      await store.replacePinned(
        userID: me,
        chatID: chat,
        messages: [message(4, ttl: chatTTLDay)],
        sharedIDs: const {},
      );

      expect((await store.message(userID: me, chatID: chat, messageID: 2))!.ttlPeriod, chatTTLDay);
      expect((await store.message(userID: me, chatID: chat, messageID: 1))!.ttlPeriod, 0);

      expect(await store.expiredMessages(userID: me, now: 1000 + chatTTLDay * 1000 - 1), isEmpty);
      final expired = await store.expiredMessages(userID: me, now: 1000 + chatTTLDay * 1000);
      expect(expired.values.single.messageIDs..sort(), [2, 4]);
    });
  });
}
