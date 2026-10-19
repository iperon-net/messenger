import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/chats/group_rights.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Вступление в группы (подэтап 3.3): маппинг способов вступления, ссылок,
// заявок и предпросмотра; кэш ссылок и счётчик заявок в SQLite (миграция
// 37); обновление joinRequests в ChatsSync; права «приглашать».
void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);
  final groupChat = List<int>.filled(12, 9);

  group('маппинг', () {
    test('способ вступления — туда и обратно', () {
      for (final mode in models.ChatJoinMode.values) {
        expect(joinModeFromPb(joinModeToPb(mode)), mode);
      }
      // По умолчанию на сервере (0) — частная по ссылкам.
      expect(joinModeFromPb(pb.ChatJoinMode.CHAT_JOIN_LINK), models.ChatJoinMode.link);
      expect(joinModeToPb(models.ChatJoinMode.open), pb.ChatJoinMode.CHAT_JOIN_OPEN);
    });

    test('ссылка-приглашение: путь «+код», даты, счётчики', () {
      final link = inviteLinkFromPb(
        pb.ChatInviteLink(
          code: 'AbCdEf123456',
          title: 'Митап',
          primary: false,
          expireDate: Int64(2000),
          usageLimit: 10,
          usage: 3,
          requestApproval: true,
          createdAt: Int64(1000),
          pendingCount: 2,
        ),
      );
      expect(link.id, 'AbCdEf123456');
      expect(link.link, '+AbCdEf123456');
      expect(link.title, 'Митап');
      expect(link.expireDate, DateTime.fromMillisecondsSinceEpoch(2000));
      expect(link.createdAt, DateTime.fromMillisecondsSinceEpoch(1000));
      expect((link.usageLimit, link.usage, link.pendingCount, link.requestApproval), (10, 3, 2, true));
      // Бессрочная — без даты.
      expect(inviteLinkFromPb(pb.ChatInviteLink(code: 'x')).expireDate, isNull);
      expect(invitePath(''), '');
      expect(inviteCodeOf('+abc'), 'abc');
      expect(inviteCodeOf('abc'), 'abc');
    });

    test('порядок ссылок: основная, действующие, отозванные — новые выше', () {
      models.ChatInviteLink link(String id, int created, {bool primary = false, bool revoked = false}) => models.ChatInviteLink(
        id: id,
        link: '+$id',
        primary: primary,
        revoked: revoked,
        createdAt: DateTime.fromMillisecondsSinceEpoch(created),
      );
      final sorted = sortInviteLinks([
        link('old', 1),
        link('revoked', 5, revoked: true),
        link('main', 0, primary: true),
        link('new', 3),
        link('revokedOld', 2, revoked: true),
      ]);
      expect([for (final l in sorted) l.id], ['main', 'new', 'old', 'revoked', 'revokedOld']);
    });

    test('предпросмотр: нужна заявка — «Подать заявку», иначе по режиму', () {
      final open = pb.ChatPreview(chat: pb.ChatInfo(joinMode: pb.ChatJoinMode.CHAT_JOIN_OPEN));
      expect(previewJoinMode(open), models.ChatJoinMode.open);
      final approval = pb.ChatPreview(chat: pb.ChatInfo(joinMode: pb.ChatJoinMode.CHAT_JOIN_LINK), requestNeeded: true);
      expect(previewJoinMode(approval), models.ChatJoinMode.request);
      final link = pb.ChatPreview(chat: pb.ChatInfo(joinMode: pb.ChatJoinMode.CHAT_JOIN_LINK));
      expect(previewJoinMode(link), models.ChatJoinMode.link);
    });

    test('история предпросмотра — без повторов, по возрастанию', () {
      pb.ChatMessage m(int id) => pb.ChatMessage(messageID: Int64(id));
      final merged = mergePreviewHistory([m(1), m(2), m(3)], [m(3), m(4), m(5)]);
      expect([for (final x in merged) x.messageID.toInt()], [1, 2, 3, 4, 5]);
    });

    test('заявка: userID, дата, ссылка', () {
      final request = joinRequestFromPb(
        pb.ChatJoinRequest(userID: peer, date: Int64(5000), inviteCode: 'code', inviteTitle: 'Для подрядчиков'),
        name: 'Анна',
        about: 'Дизайнер',
      );
      expect(request.userID, idHex(peer));
      expect(request.name, 'Анна');
      expect(request.about, 'Дизайнер');
      expect(request.date, DateTime.fromMillisecondsSinceEpoch(5000));
      expect((request.linkID, request.linkTitle), ('code', 'Для подрядчиков'));
    });

    test('«Изменить»: только изменившееся вступление', () {
      final private = pb.ChatInfo(joinMode: pb.ChatJoinMode.CHAT_JOIN_LINK);
      // Ничего не поменяли.
      expect(editJoinChanges(private, joinMode: models.ChatJoinMode.link, username: '', historyHidden: false).isEmpty, isTrue);
      // Стала публичной — режим и имя (в нижнем регистре), «Скрыть историю»
      // у публичной не шлём.
      var changes = editJoinChanges(private, joinMode: models.ChatJoinMode.open, username: 'My_Group', historyHidden: true);
      expect(changes.joinMode, pb.ChatJoinMode.CHAT_JOIN_OPEN);
      expect(changes.username, 'my_group');
      expect(changes.historyHidden, isNull);
      // Публичная → по заявкам: имя не шлём (сервер освобождает сам).
      final public = pb.ChatInfo(joinMode: pb.ChatJoinMode.CHAT_JOIN_OPEN, username: 'my_group');
      changes = editJoinChanges(public, joinMode: models.ChatJoinMode.request, username: '', historyHidden: false);
      expect(changes.joinMode, pb.ChatJoinMode.CHAT_JOIN_REQUEST);
      expect(changes.username, isNull);
      expect(changes.historyHidden, isNull);
      // Сменили только имя публичной.
      changes = editJoinChanges(public, joinMode: models.ChatJoinMode.open, username: 'other_name', historyHidden: false);
      expect((changes.joinMode, changes.username), (null, 'other_name'));
      // Включили «Скрыть историю» у частной.
      changes = editJoinChanges(private, joinMode: models.ChatJoinMode.link, username: '', historyHidden: true);
      expect((changes.joinMode, changes.username, changes.historyHidden), (null, null, true));
    });
  });

  group('права', () {
    models.Chat chat(models.ChatRole role, {models.ChatAdminRights? rights, models.ChatJoinMode mode = models.ChatJoinMode.link}) =>
        models.Chat(id: 'g', type: models.ChatType.group, title: 'g', myRole: role, myRights: rights, joinMode: mode);

    test('ссылки и заявки — владелец и админ с правом приглашать', () {
      expect(canInviteUsers(chat(models.ChatRole.owner), const []), isTrue);
      expect(canInviteUsers(chat(models.ChatRole.admin, rights: const models.ChatAdminRights(inviteUsers: true)), const []), isTrue);
      expect(canInviteUsers(chat(models.ChatRole.admin, rights: const models.ChatAdminRights(changeInfo: true)), const []), isFalse);
      expect(canInviteUsers(chat(models.ChatRole.writer), const []), isFalse);
    });

    test('«Добавить участников»: в «Только админы» — с правом приглашать', () {
      expect(canAddGroupMembers(chat(models.ChatRole.writer), const []), isTrue);
      expect(canAddGroupMembers(chat(models.ChatRole.writer, mode: models.ChatJoinMode.admins), const []), isFalse);
      final inviter = chat(
        models.ChatRole.admin,
        rights: const models.ChatAdminRights(inviteUsers: true),
        mode: models.ChatJoinMode.admins,
      );
      expect(canAddGroupMembers(inviter, const []), isTrue);
      expect(canAddGroupMembers(chat(models.ChatRole.owner, mode: models.ChatJoinMode.admins), const []), isTrue);
    });
  });

  group('кэш', () {
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('chats_joining');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await _createSchema(db);
      store = ChatsRepository(logger: Logger(), db: db);
    });

    tearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    pb.Dialog groupDialog({String inviteCode = 'MainCode1234', int pending = 0}) => pb.Dialog(
      chatID: groupChat,
      type: pb.ChatType.CHAT_TYPE_GROUP,
      role: pb.ChatRole.CHAT_ROLE_OWNER,
      inviteCode: inviteCode,
      pendingRequests: pending,
      chat: pb.ChatInfo(
        chatID: groupChat,
        type: pb.ChatType.CHAT_TYPE_GROUP,
        title: 'Дача',
        joinMode: pb.ChatJoinMode.CHAT_JOIN_REQUEST,
        historyHidden: true,
        pts: Int64(1),
      ),
    );

    test('диалог группы: основная ссылка, заявки и режим — в кэше', () async {
      await store.upsertDialog(userID: me, dialog: groupDialog(pending: 4));
      var group = await store.group(userID: me, chatID: groupChat);
      expect(group?.inviteCode, 'MainCode1234');
      expect(group?.pendingRequests, 4);
      expect(group?.info.joinMode, pb.ChatJoinMode.CHAT_JOIN_REQUEST);
      expect(group?.info.historyHidden, isTrue);
      await store.setGroupPendingRequests(userID: me, chatID: groupChat, pending: 1);
      await store.setGroupInviteCode(userID: me, chatID: groupChat, code: 'NewCode12345');
      group = await store.group(userID: me, chatID: groupChat);
      expect((group?.inviteCode, group?.pendingRequests), ('NewCode12345', 1));
      // Сняли админа — ссылки и заявок больше не видно.
      await store.setGroupRole(userID: me, chatID: groupChat, role: pb.ChatRole.CHAT_ROLE_WRITER, rights: pb.ChatAdminRights(), rank: '');
      group = await store.group(userID: me, chatID: groupChat);
      expect((group?.inviteCode, group?.pendingRequests), ('', 0));
    });

    test('ссылки: полный список, правка, удаление отозванных, выход из группы', () async {
      await store.upsertDialog(userID: me, dialog: groupDialog());
      await store.replaceInviteLinks(
        userID: me,
        chatID: groupChat,
        links: [
          pb.ChatInviteLink(code: 'main', primary: true),
          pb.ChatInviteLink(code: 'extra', title: 'Митап'),
          pb.ChatInviteLink(code: 'gone', revoked: true),
        ],
      );
      expect((await store.inviteLinks(userID: me, chatID: groupChat)).length, 3);
      // Изменили / отозвали — заменяется по коду.
      await store.upsertInviteLink(
        userID: me,
        chatID: groupChat,
        link: pb.ChatInviteLink(code: 'extra', title: 'Митап', revoked: true),
      );
      var codes = {for (final l in await store.inviteLinks(userID: me, chatID: groupChat)) l.code: l.revoked};
      expect(codes, {'main': false, 'extra': true, 'gone': true});
      await store.deleteRevokedInviteLinks(userID: me, chatID: groupChat);
      codes = {for (final l in await store.inviteLinks(userID: me, chatID: groupChat)) l.code: l.revoked};
      expect(codes, {'main': false});
      // Новый полный список заменяет кэш.
      await store.replaceInviteLinks(
        userID: me,
        chatID: groupChat,
        links: [pb.ChatInviteLink(code: 'fresh', primary: true)],
      );
      expect([for (final l in await store.inviteLinks(userID: me, chatID: groupChat)) l.code], ['fresh']);
      await store.deleteDialog(userID: me, chatID: groupChat);
      expect(await store.inviteLinks(userID: me, chatID: groupChat), isEmpty);
    });

    test('ChatsSync: joinRequests — счётчик заявок и сигнал экрану', () async {
      await getIt.reset();
      getIt.registerSingleton<Logger>(Logger());
      getIt.registerSingleton<Repositories>(_FakeRepositories(store));
      getIt.registerSingleton<Auth>(_FakeAuth(models.Session(userID: me)));
      addTearDown(getIt.reset);

      await store.upsertDialog(userID: me, dialog: groupDialog());
      await store.setPts(userID: me, pts: 5);
      final changed = <String>[];
      final subscription = ChatsSync.instance.joinRequestsChanged.listen(changed.add);
      addTearDown(subscription.cancel);

      await ChatsSync.instance.applyUpdates(
        pb.Updates(
          updates: [
            pb.Update(
              pts: Int64(6),
              joinRequests: pb.Update_JoinRequestsChanged(chatID: groupChat, pendingCount: 3, recentUserIDs: [peer]),
            ),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect((await store.group(userID: me, chatID: groupChat))?.pendingRequests, 3);
      expect(await store.getPts(userID: me), 6);
      expect(changed, [idHex(groupChat)]);

      // Повтор (тот же pts) — не применяется второй раз.
      await store.setGroupPendingRequests(userID: me, chatID: groupChat, pending: 0);
      await ChatsSync.instance.applyUpdates(
        pb.Updates(
          updates: [
            pb.Update(
              pts: Int64(6),
              joinRequests: pb.Update_JoinRequestsChanged(chatID: groupChat, pendingCount: 3),
            ),
          ],
        ),
      );
      expect((await store.group(userID: me, chatID: groupChat))?.pendingRequests, 0);

      // dialogSettings админа — новая основная ссылка (заменили) и заявки.
      await ChatsSync.instance.applyUpdates(
        pb.Updates(
          updates: [
            pb.Update(
              pts: Int64(7),
              dialogSettings: pb.Update_DialogSettings(
                dialog: pb.Dialog(
                  chatID: groupChat,
                  type: pb.ChatType.CHAT_TYPE_GROUP,
                  role: pb.ChatRole.CHAT_ROLE_OWNER,
                  inviteCode: 'Replaced1234',
                  pendingRequests: 2,
                ),
              ),
            ),
          ],
        ),
      );
      final group = await store.group(userID: me, chatID: groupChat);
      expect((group?.inviteCode, group?.pendingRequests), ('Replaced1234', 2));
    });
  });
}

class _FakeRepositories implements Repositories {
  @override
  final ChatsRepository chats;

  _FakeRepositories(this.chats);

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

/// Таблицы чатов, которых касаются тесты (как в миграциях, до 37).
Future<void> _createSchema(SqliteDatabase db) async {
  await db.execute('''
    CREATE TABLE chatDialogs (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, type INTEGER NOT NULL DEFAULT 0, peerUserID BLOB NULL,
      topMessageID INTEGER NOT NULL DEFAULT 0, topMessageDate INTEGER NOT NULL DEFAULT 0, topMessage BLOB NULL,
      readInboxMaxID INTEGER NOT NULL DEFAULT 0, readOutboxMaxID INTEGER NOT NULL DEFAULT 0, unreadCount INTEGER NOT NULL DEFAULT 0,
      unreadReactions INTEGER NOT NULL DEFAULT 0, unreadMentions INTEGER NOT NULL DEFAULT 0, pinned INTEGER NOT NULL DEFAULT 0, archived INTEGER NOT NULL DEFAULT 0,
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
      reactionsUnread INTEGER NOT NULL DEFAULT 0, expireAt INTEGER NOT NULL DEFAULT 0, poll BLOB NULL,
      PRIMARY KEY (userID, chatID, messageID)
    );
  ''');
  await db.execute(ChatsRepository.mentionsSchema);
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
  await db.execute('''
    CREATE TABLE chatUpdatesState (userID BLOB PRIMARY KEY, pts INTEGER NOT NULL, date INTEGER NOT NULL DEFAULT 0);
  ''');
  await db.execute('''
    CREATE TABLE chatGroups (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, info BLOB NOT NULL, role INTEGER NOT NULL DEFAULT 0, pts INTEGER NOT NULL DEFAULT 0,
      rights BLOB, rank TEXT NOT NULL DEFAULT '', inviteCode TEXT NOT NULL DEFAULT '', pendingRequests INTEGER NOT NULL DEFAULT 0, slowModeUntil INTEGER NOT NULL DEFAULT 0, joinedAt INTEGER NOT NULL DEFAULT 0,
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
  await db.execute('''
    CREATE TABLE chatInviteLinks (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, code TEXT NOT NULL, link BLOB NOT NULL,
      PRIMARY KEY (userID, chatID, code)
    );
  ''');
}
