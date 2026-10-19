import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Группы (срез 3.1): диалог группы несёт ChatInfo — сведения, моя роль и pts
// журнала ЧАТА в chatGroups; pts не откатывается назад (кроме tooLong),
// удаление диалога убирает группу и её участников, а без флага «Группы»
// полный список не стирает кэш групп.
void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);
  final privateChat = List<int>.filled(12, 8);
  final groupChat = List<int>.filled(12, 9);

  late Directory dir;
  late SqliteDatabase db;
  late ChatsRepository store;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('chats_groups');
    db = SqliteDatabase(path: '${dir.path}/test.db');
    await db.execute('''
      CREATE TABLE chatDialogs (
        userID BLOB NOT NULL, chatID BLOB NOT NULL, type INTEGER NOT NULL DEFAULT 0, peerUserID BLOB NULL,
        topMessageID INTEGER NOT NULL DEFAULT 0, topMessageDate INTEGER NOT NULL DEFAULT 0, topMessage BLOB NULL,
        readInboxMaxID INTEGER NOT NULL DEFAULT 0, readOutboxMaxID INTEGER NOT NULL DEFAULT 0, unreadCount INTEGER NOT NULL DEFAULT 0,
        unreadReactions INTEGER NOT NULL DEFAULT 0, pinned INTEGER NOT NULL DEFAULT 0, archived INTEGER NOT NULL DEFAULT 0,
        markedUnread INTEGER NOT NULL DEFAULT 0, mutedUntil INTEGER NOT NULL DEFAULT 0, draft TEXT NOT NULL DEFAULT '',
        draftPending INTEGER NOT NULL DEFAULT 0, createdAt INTEGER NOT NULL DEFAULT 0, ttlPeriod INTEGER NOT NULL DEFAULT 0,
        noForwards INTEGER NOT NULL DEFAULT 0, historyStaleBelow INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (userID, chatID)
      );
    ''');
    await db.execute('''
      CREATE TABLE chatMessages (
        userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, fromUserID BLOB NOT NULL, date INTEGER NOT NULL,
        editDate INTEGER NOT NULL DEFAULT 0, randomID INTEGER NOT NULL DEFAULT 0, mediaUnread INTEGER NOT NULL DEFAULT 0,
        silent INTEGER NOT NULL DEFAULT 0, content BLOB NOT NULL, searchText TEXT NOT NULL DEFAULT '', reactions BLOB NULL,
        reactionsUnread INTEGER NOT NULL DEFAULT 0, expireAt INTEGER NOT NULL DEFAULT 0,
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
      CREATE TABLE chatPinned (
        userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, message BLOB NOT NULL, shared INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (userID, chatID, messageID)
      );
    ''');
    await db.execute('''
      CREATE TABLE chatPendingReactions (
        userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, emojis TEXT NOT NULL, createdAt INTEGER NOT NULL,
        PRIMARY KEY (userID, chatID, messageID)
      );
    ''');
    // Как в миграциях 35 и 36.
    await db.execute('''
      CREATE TABLE chatGroups (
        userID BLOB NOT NULL, chatID BLOB NOT NULL, info BLOB NOT NULL, role INTEGER NOT NULL DEFAULT 0, pts INTEGER NOT NULL DEFAULT 0,
        rights BLOB, rank TEXT NOT NULL DEFAULT '',
        PRIMARY KEY (userID, chatID)
      );
    ''');
    await db.execute('''
      CREATE TABLE chatGroupMembers (
        userID BLOB NOT NULL, chatID BLOB NOT NULL, memberUserID BLOB NOT NULL, role INTEGER NOT NULL DEFAULT 0,
        joinedAt INTEGER NOT NULL DEFAULT 0, inviterUserID BLOB, rights BLOB, rank TEXT NOT NULL DEFAULT '', promotedByUserID BLOB,
        PRIMARY KEY (userID, chatID, memberUserID)
      );
    ''');
    store = ChatsRepository(logger: Logger(), db: db);
  });

  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  pb.Dialog groupDialog({int pts = 2, String title = 'Дача', int top = 2}) => pb.Dialog(
    chatID: groupChat,
    type: pb.ChatType.CHAT_TYPE_GROUP,
    role: pb.ChatRole.CHAT_ROLE_OWNER,
    chat: pb.ChatInfo(
      chatID: groupChat,
      type: pb.ChatType.CHAT_TYPE_GROUP,
      title: title,
      membersCount: 2,
      ownerUserID: me,
      pts: Int64(pts),
    ),
    topMessage: pb.ChatMessage(
      chatID: groupChat,
      messageID: Int64(top),
      fromUserID: me,
      date: Int64(top * 1000),
      content: pb.MessageContent(
        chatAction: pb.MessageChatAction(kind: pb.MessageChatAction_Kind.CREATED, title: title),
      ),
    ),
  );

  test('диалог группы — сведения, роль и pts журнала чата', () async {
    await store.upsertDialog(userID: me, dialog: groupDialog());
    final row = await store.dialog(userID: me, chatID: groupChat);
    expect(row?.type, pb.ChatType.CHAT_TYPE_GROUP.value);
    expect(row?.peerUserID, isNull);
    final group = await store.group(userID: me, chatID: groupChat);
    expect(group?.info.title, 'Дача');
    expect(group?.role, pb.ChatRole.CHAT_ROLE_OWNER);
    expect(group?.pts, 2);
  });

  test('pts группы не откатывается снимком, а tooLong — сбрасывает', () async {
    await store.upsertDialog(userID: me, dialog: groupDialog());
    await store.setGroupPts(userID: me, chatID: groupChat, pts: 10);
    // Старый снимок (полный список, dialogNew из догона) — pts остаётся.
    await store.upsertDialog(
      userID: me,
      dialog: groupDialog(pts: 4, title: 'Дом'),
    );
    var group = await store.group(userID: me, chatID: groupChat);
    expect(group?.pts, 10);
    expect(group?.info.title, 'Дом');
    // Журнал обрезан — pts как в снимке.
    final fresh = groupDialog(pts: 40);
    await store.upsertGroup(userID: me, dialog: fresh, resetPts: true);
    group = await store.group(userID: me, chatID: groupChat);
    expect(group?.pts, 40);
  });

  test('сведения и участники меняются, pts — нет', () async {
    await store.upsertDialog(userID: me, dialog: groupDialog());
    final info = (await store.group(userID: me, chatID: groupChat))!.info.deepCopy()
      ..title = 'Новое'
      ..pts = Int64(99);
    await store.setGroupInfo(userID: me, info: info);
    await store.upsertGroupMembers(
      userID: me,
      chatID: groupChat,
      members: [
        pb.ChatMember(userID: me, role: pb.ChatRole.CHAT_ROLE_OWNER, joinedAt: Int64(1)),
        pb.ChatMember(userID: peer, role: pb.ChatRole.CHAT_ROLE_WRITER, joinedAt: Int64(2), inviterUserID: me),
      ],
    );
    final group = await store.group(userID: me, chatID: groupChat);
    expect(group?.info.title, 'Новое');
    expect(group?.pts, 2);
    var members = await store.groupMembers(userID: me, chatID: groupChat);
    expect([for (final m in members) m.role], [pb.ChatRole.CHAT_ROLE_OWNER, pb.ChatRole.CHAT_ROLE_WRITER]);
    expect(members.last.inviterUserID, me);
    await store.removeGroupMembers(userID: me, chatID: groupChat, memberUserIDs: [peer]);
    members = await store.groupMembers(userID: me, chatID: groupChat);
    expect(members.length, 1);
  });

  test('вышел / группу удалили — диалог, история, группа и участники уходят', () async {
    await store.upsertDialog(userID: me, dialog: groupDialog());
    await store.upsertGroupMembers(
      userID: me,
      chatID: groupChat,
      members: [pb.ChatMember(userID: peer)],
    );
    await store.deleteDialog(userID: me, chatID: groupChat);
    expect(await store.dialog(userID: me, chatID: groupChat), isNull);
    expect(await store.group(userID: me, chatID: groupChat), isNull);
    expect(await store.groupMembers(userID: me, chatID: groupChat), isEmpty);
    expect(await store.countMessages(userID: me, chatID: groupChat), 0);
  });

  test('без флага «Группы» полный список не стирает кэш групп', () async {
    await store.upsertDialog(userID: me, dialog: groupDialog());
    final private = pb.Dialog(
      chatID: privateChat,
      peerUserID: peer,
      topMessage: pb.ChatMessage(
        chatID: privateChat,
        messageID: Int64(1),
        fromUserID: peer,
        content: pb.MessageContent(text: 'привет'),
      ),
    );
    await store.replaceDialogs(userID: me, dialogs: [private], keepGroups: true);
    expect(await store.group(userID: me, chatID: groupChat), isNotNull);
    expect(await store.dialog(userID: me, chatID: groupChat), isNotNull);
    // С флагом группа, которой нет в списке, удаляется.
    await store.replaceDialogs(userID: me, dialogs: [private]);
    expect(await store.dialog(userID: me, chatID: groupChat), isNull);
    expect(await store.group(userID: me, chatID: groupChat), isNull);
  });

  test('3.2: мои права и звание — из диалога, меняются dialogSettings', () async {
    final admin = groupDialog()
      ..role = pb.ChatRole.CHAT_ROLE_ADMIN
      ..rights = pb.ChatAdminRights(banUsers: true, pinMessages: true)
      ..rank = 'модератор';
    await store.upsertDialog(userID: me, dialog: admin);
    var group = await store.group(userID: me, chatID: groupChat);
    expect(group?.role, pb.ChatRole.CHAT_ROLE_ADMIN);
    expect(group?.rights.banUsers, isTrue);
    expect(group?.rights.changeInfo, isFalse);
    expect(group?.rank, 'модератор');
    // Сняли админа — роль по умолчанию, прав нет.
    await store.setGroupRole(userID: me, chatID: groupChat, role: pb.ChatRole.CHAT_ROLE_READER, rights: pb.ChatAdminRights(), rank: '');
    group = await store.group(userID: me, chatID: groupChat);
    expect(group?.role, pb.ChatRole.CHAT_ROLE_READER);
    expect(group?.rights.banUsers, isFalse);
    expect(group?.rank, '');
  });

  test('3.2: участник — права, звание; updated заменяет запись', () async {
    await store.upsertDialog(userID: me, dialog: groupDialog());
    await store.upsertGroupMembers(
      userID: me,
      chatID: groupChat,
      members: [pb.ChatMember(userID: peer, role: pb.ChatRole.CHAT_ROLE_WRITER, joinedAt: Int64(2))],
    );
    await store.upsertGroupMembers(
      userID: me,
      chatID: groupChat,
      members: [
        pb.ChatMember(
          userID: peer,
          role: pb.ChatRole.CHAT_ROLE_ADMIN,
          joinedAt: Int64(2),
          rights: pb.ChatAdminRights(deleteMessages: true),
          rank: 'редактор',
          promotedByUserID: me,
        ),
      ],
    );
    final members = await store.groupMembers(userID: me, chatID: groupChat);
    expect(members.single.role, pb.ChatRole.CHAT_ROLE_ADMIN);
    expect(members.single.rights.deleteMessages, isTrue);
    expect(members.single.rank, 'редактор');
  });
}
