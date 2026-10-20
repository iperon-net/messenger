import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_data_source.dart';
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

  group('mergeSearchResults', () {
    test('без повторов, от новых к старым', () {
      expect(mergeSearchResults(['90', '40', '12'], ['95', '40', '30', '5']), ['95', '90', '40', '30', '12', '5']);
    });

    test('без серверных — локальные как есть (демо: id не числа)', () {
      expect(mergeSearchResults(['m3', 'm1'], const []), ['m3', 'm1']);
      expect(mergeSearchResults(const [], ['7', '3']), ['7', '3']);
    });
  });

  group('ServerSearchSession', () {
    test('страницы: слияние с локальными и «ещё раньше»', () {
      final session = ServerSearchSession('квартира');
      final local = ['120', '100', '20'];
      expect(session.merge(local), local);
      expect(session.needsPage(local, 1), isFalse);

      session.apply(const ServerSearchPage(ids: ['130', '100', '90'], nextOffsetID: '90'), more: false);
      expect(session.offline, isFalse);
      expect(session.hasMore, isTrue);
      final merged = session.merge(local);
      expect(merged, ['130', '120', '100', '90', '20']);
      // Между 90 и 20 сервер ещё не смотрел — перед переходом к 20 догружаем.
      expect(session.needsPage(merged, 3), isFalse);
      expect(session.needsPage(merged, 4), isTrue);

      session.apply(const ServerSearchPage(ids: ['90', '60']), more: true);
      expect(session.results, ['130', '100', '90', '60']);
      expect(session.hasMore, isFalse);
      expect(session.needsPage(session.merge(local), 5), isFalse);
      expect(session.merge(local), ['130', '120', '100', '90', '60', '20']);
    });

    test('нет сети — только локальные и пометка; сеть появилась — догружается', () {
      final session = ServerSearchSession('отчёт');
      session.apply(const ServerSearchPage.status(ServerSearchStatus.offline), more: false);
      expect(session.offline, isTrue);
      expect(session.hasMore, isFalse);
      expect(session.retryMore, isFalse);
      expect(session.merge(['5']), ['5']);

      session.apply(const ServerSearchPage(ids: ['9'], nextOffsetID: '9'), more: false);
      expect(session.offline, isFalse);
      expect(session.merge(['5']), ['9', '5']);

      // Обрыв на продолжении — собранное и курсор остаются для повтора.
      session.apply(const ServerSearchPage.status(ServerSearchStatus.offline), more: true);
      expect(session.offline, isTrue);
      expect(session.retryMore, isTrue);
      expect(session.next, '9');
      expect(session.results, ['9']);
    });

    test('QUERY_TOO_SHORT — локальные без ошибки и без продолжения', () {
      final session = ServerSearchSession('и в на');
      session.apply(const ServerSearchPage.status(ServerSearchStatus.tooShort), more: false);
      expect(session.offline, isFalse);
      expect(session.hasMore, isFalse);
      expect(session.needsPage(['3'], 1), isFalse);
      expect(session.merge(['3', '1']), ['3', '1']);
    });

    test('полная история / демо — сервер не спрашиваем', () {
      final session = ServerSearchSession('x');
      session.apply(const ServerSearchPage.status(ServerSearchStatus.skipped), more: false);
      expect(session.offline, isFalse);
      expect(session.hasMore, isFalse);
      expect(ServerSearchSession('  ').active, isFalse);
    });
  });
}
