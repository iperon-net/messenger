import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/account_scope.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';
import 'package:sqlite_async/sqlite_async.dart';

import '../support/fake_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const desktopChannel = MethodChannel('net.iperon.messenger/desktop');

  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);
  final chat = List<int>.filled(12, 9);

  late Directory dir;
  late SqliteDatabase db;
  late ChatsRepository store;
  late FakeApi api;
  late FakeUtils utils;
  late AccountScope scope;
  var scopeID = 0;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('chats_sync_offline');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    await createSchema(db);
    store = ChatsRepository(logger: Logger(), db: db);
    api = FakeApi();
    utils = FakeUtils();
    scope = AccountScope('chats-sync-offline-${scopeID++}')..files = (data: dir, cache: dir);
    AccountScope.activate(scope);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(desktopChannel, (_) async => null);

    await getIt.reset();
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<API>(api);
    getIt.registerSingleton<Auth>(FakeAuth(models.Session(userID: me)));
    getIt.registerSingleton<Utils>(utils);
    getIt.registerSingleton<Repositories>(FakeRepositories(db, store));
  });

  tearDown(() async {
    await scope.dispose();
    AccountScope.activate(AccountScope(''));
    await api.dispose();
    await getIt.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(desktopChannel, null);
    await db.close();
    await dir.delete(recursive: true);
  });

  pb.ChatMessage message(int id, {int randomID = 0, String? text, List<int>? from}) => pb.ChatMessage(
    chatID: chat,
    messageID: Int64(id),
    fromUserID: from ?? peer,
    randomID: Int64(randomID),
    date: Int64(id * 1000),
    content: pb.MessageContent(text: text ?? 'message $id'),
  );

  test('offline сохраняет кэш и outbox, reconnect догоняет pts и отправляет сообщение', () async {
    await store.setPts(userID: me, pts: 5);
    await store.setFolders(userID: me, folders: pb.ChatFolders());
    await store.setRepliesState(userID: me, loaded: true);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: me, peerUserID: me),
    );
    await store.upsertMessage(
      userID: me,
      message: message(1, text: 'cached'),
    );
    await store.addOutbox(
      userID: me,
      randomID: 77,
      chatID: chat,
      content: pb.MessageContent(text: 'queued offline').writeToBuffer(),
      createdAt: 1000,
    );
    final sync = ChatsSync.instance..setEnabled(true);

    await sync.flushOutbox();

    expect(api.unaryCalls, isEmpty);
    expect(await store.outbox(userID: me), hasLength(1));
    expect((await store.dialog(userID: me, chatID: chat))?.peerUserID, peer);
    expect((await store.message(userID: me, chatID: chat, messageID: 1))?.content.text, 'cached');

    utils.network = true;
    api.enqueueUnaryResponse(MessageType.GET_DIFFERENCE, pb.GetDifference_Response(state: pb.UpdatesState(pts: Int64(5))).writeToBuffer());
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        send: pb.Messages_SendResult(
          message: message(2, randomID: 77, from: me, text: 'queued offline'),
        ),
      ).writeToBuffer(),
    );

    await sync.onConnected();

    expect(api.unaryCalls.map((call) => call.type), [MessageType.GET_DIFFERENCE, MessageType.MESSAGES]);
    final difference = pb.GetDifference_Request.fromBuffer(api.unaryCalls[0].payload);
    expect(difference.pts.toInt(), 5);
    final sent = pb.Messages_Request.fromBuffer(api.unaryCalls[1].payload).send;
    expect(sent.randomID.toInt(), 77);
    expect(sent.content.text, 'queued offline');
    expect(await store.outbox(userID: me), isEmpty);
    expect((await store.message(userID: me, chatID: chat, messageID: 2))?.content.text, 'queued offline');
  });

  test('live дедуплицирует pts, дыра догоняется, входящее и непрочитанные не теряются', () async {
    await store.setPts(userID: me, pts: 5);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    final events = <ChatsIncoming>[];
    final subscription = ChatsSync.instance.incoming.listen(events.add);
    addTearDown(subscription.cancel);
    pb.Update update(int pts, int id) => pb.Update(
      pts: Int64(pts),
      newMessage: pb.Update_NewMessage(message: message(id)),
    );

    await ChatsSync.instance.applyLive(pb.Updates(updates: [update(6, 2)]));
    await ChatsSync.instance.applyLive(pb.Updates(updates: [update(6, 2)]));

    expect(await store.getPts(userID: me), 6);
    expect((await store.dialog(userID: me, chatID: chat))?.unreadCount, 1);
    expect(await store.countMessages(userID: me, chatID: chat), 1);
    expect(events.single.messageID, 2);

    api.enqueueUnaryResponse(
      MessageType.GET_DIFFERENCE,
      pb.GetDifference_Response(
        updates: [update(7, 3), update(8, 4)],
        state: pb.UpdatesState(pts: Int64(8)),
      ).writeToBuffer(),
    );
    await ChatsSync.instance.applyLive(pb.Updates(updates: [update(8, 4)]));

    expect(api.unaryCalls.single.type, MessageType.GET_DIFFERENCE);
    expect(pb.GetDifference_Request.fromBuffer(api.unaryCalls.single.payload).pts.toInt(), 6);
    expect(await store.getPts(userID: me), 8);
    expect((await store.dialog(userID: me, chatID: chat))?.unreadCount, 3);
    expect([for (final row in await store.messages(userID: me, chatID: chat)) row.messageID.toInt()], [2, 3, 4]);
    expect(events.map((event) => event.messageID), [2], reason: 'догон после reconnect не показывает повторные баннеры');
  });
}

final class FakeUtils implements Utils {
  var network = false;

  @override
  Future<bool> hasNetwork() async => network;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeAuth implements Auth {
  @override
  final models.Session session;

  const FakeAuth(this.session);

  @override
  bool get isAuthorized => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeRepositories implements Repositories {
  @override
  final SqliteDatabase db;

  @override
  final ChatsRepository chats;

  @override
  late final HiddenProfiles hiddenProfiles = FakeHiddenProfiles();

  @override
  late final SecretChatsRepository secretChats = FakeSecretChats();

  FakeRepositories(this.db, this.chats);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeHiddenProfiles implements HiddenProfiles {
  @override
  Stream<void> get changes => const Stream.empty();

  @override
  Future<Map<String, String>> hashByHex() async => const {};

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class FakeSecretChats implements SecretChatsRepository {
  @override
  Future<List<SecretChatRecord>> chats({required List<int> sessionID}) async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> createSchema(SqliteDatabase db) async {
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
    CREATE TABLE chatMessages (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, fromUserID BLOB NOT NULL, date INTEGER NOT NULL,
      editDate INTEGER NOT NULL DEFAULT 0, randomID INTEGER NOT NULL DEFAULT 0, mediaUnread INTEGER NOT NULL DEFAULT 0,
      silent INTEGER NOT NULL DEFAULT 0, content BLOB NOT NULL, searchText TEXT NOT NULL DEFAULT '', reactions BLOB NULL,
      reactionsUnread INTEGER NOT NULL DEFAULT 0, expireAt INTEGER NOT NULL DEFAULT 0, poll BLOB NULL, searchHit INTEGER NOT NULL DEFAULT 0,
      authorSignature TEXT NOT NULL DEFAULT '', postOut INTEGER NOT NULL DEFAULT 0, views INTEGER NOT NULL DEFAULT 0,
      viewed INTEGER NOT NULL DEFAULT 0, comments BLOB NULL,
      PRIMARY KEY (userID, chatID, messageID)
    );
  ''');
  await db.execute('''
    CREATE TABLE chatPinned (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, message BLOB NOT NULL, shared INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (userID, chatID, messageID)
    );
  ''');
  await db.execute('''
    CREATE TABLE chatOutbox (
      userID BLOB NOT NULL, randomID INTEGER NOT NULL, chatID BLOB NULL, peerUserID BLOB NULL, content BLOB NOT NULL,
      silent INTEGER NOT NULL DEFAULT 0, failed INTEGER NOT NULL DEFAULT 0, createdAt INTEGER NOT NULL, media TEXT NOT NULL DEFAULT '',
      forwardChatID BLOB NULL, forwardMessageID INTEGER NOT NULL DEFAULT 0, scheduleDate INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (userID, randomID)
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
  await db.execute('''
    CREATE TABLE chatPendingReactions (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, emojis TEXT NOT NULL, createdAt INTEGER NOT NULL,
      PRIMARY KEY (userID, chatID, messageID)
    );
  ''');
  await db.execute('CREATE TABLE chatUpdatesState (userID BLOB PRIMARY KEY, pts INTEGER NOT NULL, date INTEGER NOT NULL DEFAULT 0);');
  await db.execute('CREATE TABLE chatFolders (userID BLOB PRIMARY KEY, folders BLOB NOT NULL, version INTEGER NOT NULL DEFAULT 0);');
  await db.execute(ChatsRepository.repliesStateSchema);
  await db.execute(ChatsRepository.mentionsSchema);
  await db.execute(ChatsRepository.threadsSchema);
}
