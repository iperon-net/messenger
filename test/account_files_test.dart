import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite_async/sqlite_async.dart';

// Перенос прежних общих файлов (iperon.db, outbox, кэш) в папку аккаунта.
void main() {
  late Directory root;
  late String support;
  late String cache;
  late AccountFiles files;
  final logger = Logger();

  setUp(() async {
    root = await Directory.systemTemp.createTemp('account_files');
    support = p.join(root.path, 'support');
    cache = p.join(root.path, 'cache');
    await Directory(support).create();
    await Directory(cache).create();
    files = AccountFiles(supportDir: support, cacheRoot: cache, accountID: 'a1');
  });

  tearDown(() => root.delete(recursive: true));

  Future<Map<String, String>> run() =>
      AccountFilesMigration.run(supportDir: support, cacheRoot: cache, databaseName: 'iperon.db', files: files, logger: logger);

  Future<void> write(String path, String content) async {
    await File(path).create(recursive: true);
    await File(path).writeAsString(content);
  }

  test('нечего переносить — ничего не делает', () async {
    expect(await run(), isEmpty);
    expect(await files.dataDir.exists(), isFalse);
  });

  test('база с журналом, outbox, секретные и кэш переезжают', () async {
    await write(p.join(support, 'iperon.db'), 'db');
    await write(p.join(support, 'iperon.db-wal'), 'wal');
    await write(p.join(support, 'chat_outbox', 'a.jpg'), 'out');
    await write(p.join(support, 'secret_media', 'b.bin'), 'sec');
    await write(p.join(cache, 'media', 'c.jpg'), 'media');

    final moved = await run();

    expect(await File(files.databasePath('iperon.db')).readAsString(), 'db');
    expect(await File('${files.databasePath('iperon.db')}-wal').readAsString(), 'wal');
    expect(await File(p.join(files.dataDir.path, 'chat_outbox', 'a.jpg')).readAsString(), 'out');
    expect(await File(p.join(files.dataDir.path, 'secret_media', 'b.bin')).readAsString(), 'sec');
    expect(await File(p.join(files.mediaDir.path, 'c.jpg')).readAsString(), 'media');
    for (final old in ['iperon.db', 'iperon.db-wal', 'chat_outbox', 'secret_media']) {
      expect(await FileSystemEntity.type(p.join(support, old)), FileSystemEntityType.notFound, reason: old);
    }
    expect(await Directory(p.join(cache, 'media')).exists(), isFalse);
    expect(moved.keys, containsAll([p.join(support, 'chat_outbox'), p.join(cache, 'media')]));
    expect(await File(p.join(support, 'accounts', '.migrating')).exists(), isFalse, reason: 'замок снят');
  });

  test('уже перенесённое не перезаписывается', () async {
    await write(files.databasePath('iperon.db'), 'new');
    await write(p.join(support, 'iperon.db'), 'old');
    await run();
    expect(await File(files.databasePath('iperon.db')).readAsString(), 'new');
    expect(await File(p.join(support, 'iperon.db')).exists(), isTrue, reason: 'старое не трогаем');
  });

  test('повторный запуск — без изменений', () async {
    await write(p.join(support, 'chat_outbox', 'a.jpg'), 'out');
    await run();
    expect(await run(), isEmpty);
    expect(await File(p.join(files.dataDir.path, 'chat_outbox', 'a.jpg')).exists(), isTrue);
  });

  test('чужой брошенный замок не мешает', () async {
    await write(p.join(support, 'chat_outbox', 'a.jpg'), 'out');
    final lock = File(p.join(support, 'accounts', '.migrating'));
    await lock.create(recursive: true);
    await lock.setLastModified(DateTime.now().subtract(const Duration(minutes: 5)));
    await run();
    expect(await File(p.join(files.dataDir.path, 'chat_outbox', 'a.jpg')).exists(), isTrue);
  });

  test('пути незаконченных загрузок переписываются', () async {
    final db = SqliteDatabase(path: p.join(root.path, 't.db'));
    await db.execute('CREATE TABLE uploads (localID TEXT PRIMARY KEY, filePath TEXT NOT NULL);');
    final from = p.join(support, 'chat_outbox');
    final to = p.join(files.dataDir.path, 'chat_outbox');
    await db.execute('INSERT INTO uploads VALUES (?, ?), (?, ?);', ['1', p.join(from, 'a.jpg'), '2', '/elsewhere/b.jpg']);
    await AccountFilesMigration.rewritePaths(db, {from: to});
    final rows = await db.getAll('SELECT localID, filePath FROM uploads ORDER BY localID;');
    expect(rows[0]['filePath'], p.join(to, 'a.jpg'));
    expect(rows[1]['filePath'], '/elsewhere/b.jpg');
    await db.close();
  });
}
