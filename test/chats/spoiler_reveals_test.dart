import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Раскрытые спойлеры: по активному аккаунту, повтор не дублирует, без
// сессии ничего не пишется.
void main() {
  late Directory dir;
  late SqliteDatabase db;
  late SpoilerRevealsRepository store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('spoilers');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    await db.execute('CREATE TABLE sessions (userID BLOB NOT NULL, isActive INTEGER NOT NULL DEFAULT 0);');
    // Как после миграции 49.
    await db.execute('''
      CREATE TABLE spoilerReveals (
        ownerID BLOB NOT NULL,
        key TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        PRIMARY KEY (ownerID, key)
      );
    ''');
    store = SpoilerRevealsRepository(logger: Logger(), db: db);
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  test('без сессии — не пишется', () async {
    await store.add('c/1/0');
    expect(await store.all(), isEmpty);
  });

  test('свой набор у каждого аккаунта, повтор не дублирует', () async {
    await db.execute('INSERT INTO sessions (userID, isActive) VALUES (?, 1);', [List<int>.filled(12, 1)]);
    await store.add('c/1/0');
    await store.add('c/1/0');
    await store.add('c/2/text');
    expect(await store.all(), {'c/1/0', 'c/2/text'});

    await db.execute('UPDATE sessions SET isActive = 0;');
    await db.execute('INSERT INTO sessions (userID, isActive) VALUES (?, 1);', [List<int>.filled(12, 2)]);
    expect(await store.all(), isEmpty);
  });
}
