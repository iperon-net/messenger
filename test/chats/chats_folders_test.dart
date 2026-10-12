import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Папки: снимок с сервера не перезаписывается более старым; маппинг — «Все
// чаты» первой, id папки — номер сервера, новая — 0.
void main() {
  final me = List<int>.filled(12, 1);
  final chat = List<int>.filled(12, 9);

  late Directory dir;
  late SqliteDatabase db;
  late ChatsRepository store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('folders');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    // Как после миграции 26 (без внешнего ключа на users).
    await db.execute('''
      CREATE TABLE chatFolders (
        userID BLOB PRIMARY KEY,
        folders BLOB NOT NULL,
        version INTEGER NOT NULL DEFAULT 0
      );
    ''');
    store = ChatsRepository(logger: Logger(), db: db);
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  pb.ChatFolders snapshot(int version, String title) => pb.ChatFolders(
    version: Int64(version),
    folders: [
      pb.ChatFolder(id: 2, title: title, includeChatIDs: [chat], excludeRead: true),
    ],
  );

  test('снимок папок и версии', () async {
    expect(await store.folders(userID: me), isNull);
    await store.setFolders(userID: me, folders: snapshot(2, 'Работа'));
    // Старый (ответ GetFolders пришёл после обновления) — не перезаписывает.
    await store.setFolders(userID: me, folders: snapshot(1, 'Старое'));
    expect((await store.folders(userID: me))!.folders.single.title, 'Работа');
    await store.setFolders(userID: me, folders: snapshot(3, 'Дела'));
    expect((await store.folders(userID: me))!.folders.single.title, 'Дела');
    // Все удалены — пустой снимок, но загружен.
    await store.setFolders(
      userID: me,
      folders: pb.ChatFolders(version: Int64(4)),
    );
    expect((await store.folders(userID: me))!.folders, isEmpty);
  });

  test('маппинг папок', () {
    final folders = foldersFromPb(snapshot(1, 'Работа'));
    expect(folders.first.isAll, isTrue);
    expect(folders[1].id, '2');
    expect(folders[1].includeChatIDs, ['090909090909090909090909']);
    expect(folders[1].excludeRead, isTrue);
    expect(foldersFromPb(null), hasLength(1));

    final back = folderToPb(folders[1].copyWith(excludeChatIDs: ['local:1']));
    expect(back.id, 2);
    expect(back.includeChatIDs.single, chat);
    expect(back.excludeChatIDs, isEmpty);
    expect(folderToPb(const models.ChatFolder(id: 'folder_123', title: 'x')).id, 0);
  });
}
