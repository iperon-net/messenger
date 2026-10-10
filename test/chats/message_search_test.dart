import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/message_search.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:sqlite_async/sqlite_async.dart';

void main() {
  group('ftsMatchQuery', () {
    test('каждое слово — по началу, все обязательны', () {
      expect(ftsMatchQuery('при'), '"при"*');
      expect(ftsMatchQuery('  встреча   завтра '), '"встреча"* "завтра"*');
    });

    test('кавычки из ввода не ломают запрос, пустое — null', () {
      expect(ftsMatchQuery('"OR" ab"c'), '"OR"* "abc"*');
      expect(ftsMatchQuery('   '), isNull);
      expect(ftsMatchQuery('""'), isNull);
    });
  });

  test('messageSearchText — текст и имена файлов', () {
    final content = pb.MessageContent(
      text: 'Отчёт',
      media: [
        pb.MessageMedia(fileName: 'report.pdf'),
        pb.MessageMedia(),
      ],
    );
    expect(messageSearchText(content), 'Отчет\nreport.pdf');
  });

  // Схема индекса и запрос — на настоящем SQLite (тот же, что в приложении).
  group('FTS5', () {
    late Directory dir;
    late SqliteDatabase db;
    final me = [1, 2, 3];
    final chat = [9, 9];

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('fts');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await db.execute('''
        CREATE TABLE chatMessages (
          userID BLOB NOT NULL,
          chatID BLOB NOT NULL,
          messageID INTEGER NOT NULL,
          searchText TEXT NOT NULL DEFAULT '',
          PRIMARY KEY (userID, chatID, messageID)
        );
      ''');
      for (final statement in chatMessagesFtsSchema) {
        await db.execute(statement);
      }
    });

    tearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    Future<void> put(int id, String text, {List<int>? chatID}) => db.execute(
      '''
      INSERT INTO chatMessages (userID, chatID, messageID, searchText) VALUES (?, ?, ?, ?)
      ON CONFLICT(userID, chatID, messageID) DO UPDATE SET searchText = excluded.searchText;
      ''',
      [me, chatID ?? chat, id, text],
    );

    Future<List<int>> search(String query) async {
      final rows = await db.getAll(chatMessagesSearchSql, [ftsMatchQuery(query), me, chat, 100]);
      return [for (final row in rows) row['messageID'] as int];
    }

    test('регистр, начало слова, ё/е, все слова; от новых к старым', () async {
      await put(1, 'Привет, как дела?');
      await put(2, 'Встреча ЗАВТРА в 10');
      await put(3, messageSearchText(pb.MessageContent(text: 'Ещё раз привет')));
      await put(4, 'привет из другого чата', chatID: [8]);

      expect(await search('привет'), [3, 1]);
      expect(await search('ПРИВ'), [3, 1]);
      expect(await search('завтра встр'), [2]);
      expect(await search('еще'), [3]);
      expect(await search('ещё'), [3]);
      expect(await search('дела завтра'), isEmpty);
    });

    test('правка и удаление обновляют индекс', () async {
      await put(1, 'старый текст');
      expect(await search('старый'), [1]);

      await put(1, 'новый текст');
      expect(await search('старый'), isEmpty);
      expect(await search('новый'), [1]);

      await db.execute('DELETE FROM chatMessages WHERE messageID = 1;');
      expect(await search('новый'), isEmpty);
    });
  });
}
