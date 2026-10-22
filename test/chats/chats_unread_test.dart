import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/chats/secret/secret_chats_list.dart' show secretChatListID;
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Общий счётчик непрочитанного (4.5, docs/plans/chats-channels.md): иконка iOS,
// вкладка «Чаты» и «‹ N» у «назад» считают **чаты**, а не сообщения — каждый
// видимый незаглушённый чат с непрочитанными входящими или ручной пометкой
// даёт 1 (как `badge:<user>` на сервере).
void main() {
  test('ChatsUnread: всего — число чатов, «назад» — без текущего', () {
    final unread = ChatsUnread(const {'a': 3, 'secret:b': 2, 'c': 1});
    expect(unread.total, 3);
    expect(unread.except('a'), 2);
    expect(unread.except('secret:b'), 2);
    expect(unread.except('нет такого'), 3);
    expect(unread.byChat['a'], 3, reason: 'по чату — по-прежнему сообщения');
    expect(unread, ChatsUnread(const {'c': 1, 'secret:b': 2, 'a': 3}));
    expect(ChatsUnread.empty.total, 0);
    expect(ChatsUnread.empty.except('a'), 0);
    // Нули не считаются.
    expect(ChatsUnread(const {'a': 0, 'b': 4}).total, 1);
    expect(ChatsUnread(const {'a': 0, 'b': 4}).except('a'), 1);
  });

  group('ChatsSync.countUnread', () {
    final me = List<int>.filled(12, 1);
    final session = List<int>.filled(12, 9);
    late Directory dir;
    late SqliteDatabase db;
    late _FakeRepositories repositories;

    List<int> id(int n) => List<int>.filled(12, n);

    Future<void> dialog(
      int n, {
      pb.ChatType type = pb.ChatType.CHAT_TYPE_PRIVATE,
      int? peer,
      int unread = 0,
      bool marked = false,
      int mutedUntil = 0,
      bool archived = false,
    }) => db.execute(
      'INSERT INTO chatDialogs (userID, chatID, type, peerUserID, unreadCount, markedUnread, mutedUntil, archived) VALUES (?, ?, ?, ?, ?, ?, ?, ?);',
      [me, id(n), type.value, peer == null ? null : id(peer), unread, marked ? 1 : 0, mutedUntil, archived ? 1 : 0],
    );

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('chats_unread');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await _createSchema(db);
      repositories = _FakeRepositories(ChatsRepository(logger: Logger(), db: db));
      await getIt.reset();
      getIt.registerSingleton<Logger>(Logger());
      getIt.registerSingleton<Utils>(_FakeUtils());
      getIt.registerSingleton<Repositories>(repositories);
      getIt.registerSingleton<Auth>(_FakeAuth(models.Session(userID: me, sessionID: session)));
      getIt.registerSingleton<API>(_FakeApi());
      ChatsSync.instance.setGroups(true, initial: true);
      ChatsSync.instance.setChannels(true, initial: true);
    });

    tearDown(() async {
      ChatsSync.instance.setGroups(false, initial: true);
      ChatsSync.instance.setChannels(false, initial: true);
      await getIt.reset();
      await db.close();
      await dir.delete(recursive: true);
    });

    test('несколько чатов с разным числом непрочитанных — число чатов', () async {
      await dialog(10, peer: 20, unread: 1);
      await dialog(11, peer: 21, unread: 7);
      await dialog(12, type: pb.ChatType.CHAT_TYPE_GROUP, unread: 120);
      await dialog(13, type: pb.ChatType.CHAT_TYPE_CHANNEL, unread: 3);
      await dialog(14, peer: 22); // прочитан
      final unread = await ChatsSync.instance.countUnread();
      expect(unread.total, 4);
      expect(unread.byChat, {idHex(id(10)): 1, idHex(id(11)): 7, idHex(id(12)): 120, idHex(id(13)): 3});
      // «Назад» в окне группы — без неё самой.
      expect(unread.except(idHex(id(12))), 3);
      // В окне прочитанного чата — все.
      expect(unread.except(idHex(id(14))), 4);
    });

    test('заглушённый, скрытый профиль, пометка, архив, ветка, канал без подписки, секретный', () async {
      final forever = mutedToPb(true, null);
      final until = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch;
      final expired = DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch;
      await dialog(10, peer: 20, unread: 5, mutedUntil: forever); // заглушён навсегда — нет
      await dialog(11, type: pb.ChatType.CHAT_TYPE_GROUP, unread: 5, mutedUntil: until); // заглушён на час — нет
      await dialog(12, peer: 22, unread: 2, mutedUntil: expired); // заглушка истекла — да
      await dialog(13, peer: 23, unread: 4); // скрытый профиль — нет
      await dialog(14, peer: 24, marked: true); // пометка «непрочитано» — да (1)
      await dialog(15, peer: 25, unread: 3, marked: true); // пометка + непрочитанные — тоже 1 чат
      await dialog(16, type: pb.ChatType.CHAT_TYPE_CHANNEL, unread: 9, archived: true); // архив — да
      await dialog(17, type: pb.ChatType.CHAT_TYPE_THREAD, unread: 6); // ветка комментариев — нет
      await dialog(18, type: pb.ChatType.CHAT_TYPE_CHANNEL, unread: 8); // канал без подписки — нет
      await db.execute('INSERT INTO chatGroups (userID, chatID, info, role, browsedAt) VALUES (?, ?, ?, 0, 1000);', [
        me,
        id(18),
        pb.ChatInfo(chatID: id(18), type: pb.ChatType.CHAT_TYPE_CHANNEL).writeToBuffer(),
      ]);
      repositories.hidden[idHex(id(23))] = 'hash';
      repositories.secret.addAll([
        _secret(30, peer: 40, unread: 11), // секретный — да (1)
        _secret(31, peer: 41), // прочитан — нет
        _secret(32, peer: 23, unread: 2), // со скрытым профилем — нет
      ]);

      final unread = await ChatsSync.instance.countUnread();
      expect(unread.byChat.keys.toSet(), {idHex(id(12)), idHex(id(14)), idHex(id(15)), idHex(id(16)), secretChatListID(id(30))});
      expect(unread.total, 5);
      expect(unread.byChat[idHex(id(14))], 1);
      expect(unread.except(secretChatListID(id(30))), 4);
    });

    test('группы и каналы без своего флага не считаются', () async {
      await dialog(10, peer: 20, unread: 1);
      await dialog(11, type: pb.ChatType.CHAT_TYPE_GROUP, unread: 2);
      await dialog(12, type: pb.ChatType.CHAT_TYPE_CHANNEL, unread: 3);
      ChatsSync.instance.setGroups(false, initial: true);
      ChatsSync.instance.setChannels(false, initial: true);
      expect((await ChatsSync.instance.countUnread()).total, 1);
    });
  });
}

SecretChatRecord _secret(int n, {required int peer, int unread = 0}) => SecretChatRecord(
  secretChatID: Uint8List.fromList(List<int>.filled(12, n)),
  peerUserID: Uint8List.fromList(List<int>.filled(12, peer)),
  outgoing: true,
  state: SecretChatLocalState.ready,
  createdAt: DateTime(2026),
  unreadCount: unread,
);

class _FakeRepositories implements Repositories {
  @override
  final ChatsRepository chats;

  final hidden = <String, String>{};
  final secret = <SecretChatRecord>[];

  @override
  late final HiddenProfiles hiddenProfiles = _FakeHiddenProfiles(hidden);

  @override
  late final SecretChatsRepository secretChats = _FakeSecretChats(secret);

  _FakeRepositories(this.chats);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHiddenProfiles implements HiddenProfiles {
  final Map<String, String> hidden;

  _FakeHiddenProfiles(this.hidden);

  @override
  Future<Map<String, String>> hashByHex() async => hidden;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSecretChats implements SecretChatsRepository {
  final List<SecretChatRecord> records;

  _FakeSecretChats(this.records);

  @override
  Future<List<SecretChatRecord>> chats({required List<int> sessionID}) async => records;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUtils implements Utils {
  @override
  String bytesToHex(Uint8List bytes) => idHex(bytes);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeApi implements API {
  @override
  Stream<Uint8List> on(MessageType type) => const Stream.empty();

  @override
  ApiConnectionStatus get connectionStatus => ApiConnectionStatus.connecting;

  @override
  Future<void> resubscribe() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuth implements Auth {
  @override
  final models.Session session;

  _FakeAuth(this.session);

  @override
  bool get isAuthorized => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Таблицы, которые читает подсчёт (как в миграциях).
Future<void> _createSchema(SqliteDatabase db) async {
  await db.execute('''
    CREATE TABLE chatDialogs (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, type INTEGER NOT NULL DEFAULT 0, peerUserID BLOB NULL,
      topMessageID INTEGER NOT NULL DEFAULT 0, topMessageDate INTEGER NOT NULL DEFAULT 0, topMessage BLOB NULL,
      readInboxMaxID INTEGER NOT NULL DEFAULT 0, readOutboxMaxID INTEGER NOT NULL DEFAULT 0, unreadCount INTEGER NOT NULL DEFAULT 0,
      unreadReactions INTEGER NOT NULL DEFAULT 0, unreadMentions INTEGER NOT NULL DEFAULT 0, pinned INTEGER NOT NULL DEFAULT 0,
      archived INTEGER NOT NULL DEFAULT 0, markedUnread INTEGER NOT NULL DEFAULT 0, mutedUntil INTEGER NOT NULL DEFAULT 0,
      draft TEXT NOT NULL DEFAULT '', draftPending INTEGER NOT NULL DEFAULT 0, createdAt INTEGER NOT NULL DEFAULT 0,
      ttlPeriod INTEGER NOT NULL DEFAULT 0, noForwards INTEGER NOT NULL DEFAULT 0, historyStaleBelow INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (userID, chatID)
    );
  ''');
  await db.execute('''
    CREATE TABLE chatGroups (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, info BLOB NOT NULL, role INTEGER NOT NULL DEFAULT 0, pts INTEGER NOT NULL DEFAULT 0,
      rights BLOB, rank TEXT NOT NULL DEFAULT '', inviteCode TEXT NOT NULL DEFAULT '', pendingRequests INTEGER NOT NULL DEFAULT 0,
      slowModeUntil INTEGER NOT NULL DEFAULT 0, joinedAt INTEGER NOT NULL DEFAULT 0, browsedAt INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (userID, chatID)
    );
  ''');
}
