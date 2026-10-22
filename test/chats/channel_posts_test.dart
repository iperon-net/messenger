import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Каналы (срез 4.1, docs/plans/chats-channels.md): пост без автора
// (fromUserID пуст) — мой по postOut, подпись — authorSignature, галочек
// «прочитано» нет; «мой пост» не сбрасывается общим обновлением журнала;
// свой пост, пришедший журналом раньше ответа Send, узнаётся по outbox; кэш
// каналов переживает выключенный флаг «Каналы».
void main() {
  final me = List<int>.filled(12, 1);
  final channelChat = List<int>.filled(12, 7);

  setUpAll(() async {
    await AppLocale.ru.build();
    LocaleSettings.setLocaleSync(AppLocale.ru);
  });

  pb.ChatMessage post(int id, {bool postOut = false, String signature = '', int randomID = 0}) => pb.ChatMessage(
    chatID: channelChat,
    messageID: Int64(id),
    date: Int64(id * 1000),
    content: pb.MessageContent(text: 'пост $id'),
    postOut: postOut,
    authorSignature: signature,
    randomID: Int64(randomID),
  );

  group('маппинг поста', () {
    test('чужой пост — входящий, без автора, с подписью', () {
      final m = messageFromPb(
        post(3, signature: 'Анна'),
        chatID: idHex(channelChat),
        myUserID: me,
        readOutboxMaxID: 0,
        isSelf: false,
        channel: true,
      );
      expect(m.outgoing, isFalse);
      expect((m.senderName, m.senderUserID), ('', ''));
      expect(m.authorSignature, 'Анна');
    });

    test('мой пост — исходящий по postOut, без ✓✓', () {
      final m = messageFromPb(
        post(4, postOut: true),
        chatID: idHex(channelChat),
        myUserID: me,
        readOutboxMaxID: 100,
        isSelf: false,
        channel: true,
      );
      expect(m.outgoing, isTrue);
      expect(m.status, models.MessageStatus.sent);
      final last = lastMessageFromPb(post(4, postOut: true), myUserID: me, readOutboxMaxID: 100, isSelf: false, channel: true);
      expect((last.outgoing, last.status), (true, models.MessageStatus.sent));
    });

    test('подпись не показывается вне канала', () {
      final m = messageFromPb(
        post(5, signature: 'Анна')..fromUserID = me,
        chatID: idHex(channelChat),
        myUserID: me,
        readOutboxMaxID: 0,
        isSelf: false,
      );
      expect(m.authorSignature, '');
      expect(m.outgoing, isTrue);
    });

    test('служебные канала — от имени канала', () {
      String text(pb.MessageChatAction_Kind kind) => chatActionText(
        t,
        pb.MessageChatAction(kind: kind, title: 'Новости'),
        outgoing: false,
        actor: '',
        channel: true,
      );
      expect(text(pb.MessageChatAction_Kind.CREATED), 'Канал «Новости» создан');
      expect(text(pb.MessageChatAction_Kind.TITLE_CHANGED), 'Название канала изменено на «Новости»');
      expect(text(pb.MessageChatAction_Kind.PHOTO_CHANGED), 'Фото канала изменено');
      expect(text(pb.MessageChatAction_Kind.PHOTO_REMOVED), 'Фото канала удалено');
    });
  });

  group('кэш и ChatsSync', () {
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('channel_posts');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await _createSchema(db);
      store = ChatsRepository(logger: Logger(), db: db);
      await getIt.reset();
      getIt.registerSingleton<Logger>(Logger());
      getIt.registerSingleton<Repositories>(_FakeRepositories(store));
      getIt.registerSingleton<Auth>(_FakeAuth(models.Session(userID: me)));
    });

    tearDown(() async {
      await getIt.reset();
      await db.close();
      await dir.delete(recursive: true);
    });

    pb.Dialog channelDialog({int pts = 1}) => pb.Dialog(
      chatID: channelChat,
      type: pb.ChatType.CHAT_TYPE_CHANNEL,
      role: pb.ChatRole.CHAT_ROLE_OWNER,
      chat: pb.ChatInfo(
        chatID: channelChat,
        type: pb.ChatType.CHAT_TYPE_CHANNEL,
        title: 'Новости',
        membersCount: 10,
        ownerUserID: me,
        signMessages: true,
        pts: Int64(pts),
      ),
    );

    pb.Update newPost(int chatPts, pb.ChatMessage message) => pb.Update(
      chatPts: Int64(chatPts),
      chatID: channelChat,
      newMessage: pb.Update_NewMessage(message: message),
    );

    test('сведения канала — в chatGroups, тип и подпись сохраняются', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      final row = await store.group(userID: me, chatID: channelChat);
      expect(row?.info.type, pb.ChatType.CHAT_TYPE_CHANNEL);
      expect(row?.info.signMessages, isTrue);
      expect((await store.dialog(userID: me, chatID: channelChat))?.type, pb.ChatType.CHAT_TYPE_CHANNEL.value);
    });

    test('«мой пост» и подпись не сбрасывает общее обновление журнала', () async {
      await store.upsertMessage(
        userID: me,
        message: post(2, postOut: true, signature: 'Я'),
      );
      await store.upsertMessage(
        userID: me,
        message: post(2, signature: 'Я'),
        shared: true,
      );
      final cached = await store.message(userID: me, chatID: channelChat, messageID: 2);
      expect(cached?.postOut, isTrue);
      expect(cached?.authorSignature, 'Я');
    });

    test('свой пост из журнала раньше ответа Send — по outbox: мой, без непрочитанного', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      await store.setPts(userID: me, pts: 10);
      await store.addOutbox(
        userID: me,
        randomID: 77,
        chatID: channelChat,
        content: pb.MessageContent(text: 'пост 2').writeToBuffer(),
      );
      await ChatsSync.instance.applyUpdates(pb.Updates(updates: [newPost(2, post(2, randomID: 77))]));
      final cached = await store.message(userID: me, chatID: channelChat, messageID: 2);
      expect(cached?.postOut, isTrue);
      expect(await store.outboxByRandomID(userID: me, randomID: 77), isNull);
      final dialog = await store.dialog(userID: me, chatID: channelChat);
      expect(dialog?.unreadCount, 0);
      expect(pb.ChatMessage.fromBuffer(dialog!.topMessage!).postOut, isTrue);

      // Чужой пост — непрочитанный.
      await ChatsSync.instance.applyUpdates(pb.Updates(updates: [newPost(3, post(3))]));
      expect((await store.dialog(userID: me, chatID: channelChat))?.unreadCount, 1);
      expect((await store.message(userID: me, chatID: channelChat, messageID: 3))?.postOut, isFalse);
    });

    test('правка своего поста из журнала остаётся моей', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      await store.setPts(userID: me, pts: 10);
      await store.upsertMessage(userID: me, message: post(2, postOut: true));
      await store.setTopMessage(userID: me, chatID: channelChat, message: post(2, postOut: true));
      await ChatsSync.instance.applyUpdates(
        pb.Updates(
          updates: [
            pb.Update(
              chatPts: Int64(2),
              chatID: channelChat,
              editMessage: pb.Update_EditMessage(message: post(2)..editDate = Int64(5000)),
            ),
          ],
        ),
      );
      final dialog = await store.dialog(userID: me, chatID: channelChat);
      expect(pb.ChatMessage.fromBuffer(dialog!.topMessage!).postOut, isTrue);
    });

    test('без флага «Каналы» полный список не стирает кэш каналов; флаги — по типам', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      await store.replaceDialogs(userID: me, dialogs: const [], keepTypes: {pb.ChatType.CHAT_TYPE_CHANNEL.value});
      expect(await store.group(userID: me, chatID: channelChat), isNotNull);
      await store.replaceDialogs(userID: me, dialogs: const [], keepTypes: {pb.ChatType.CHAT_TYPE_GROUP.value});
      expect(await store.dialog(userID: me, chatID: channelChat), isNull);

      final sync = ChatsSync.instance;
      sync.setGroups(true, initial: true);
      sync.setChannels(false, initial: true);
      expect(sync.showsChatType(pb.ChatType.CHAT_TYPE_PRIVATE.value), isTrue);
      expect(sync.showsChatType(pb.ChatType.CHAT_TYPE_GROUP.value), isTrue);
      expect(sync.showsChatType(pb.ChatType.CHAT_TYPE_CHANNEL.value), isFalse);
      sync.setGroups(false, initial: true);
      sync.setChannels(true, initial: true);
      expect(sync.showsChatType(pb.ChatType.CHAT_TYPE_GROUP.value), isFalse);
      expect(sync.showsChatType(pb.ChatType.CHAT_TYPE_CHANNEL.value), isTrue);
      sync.setChannels(false, initial: true);
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

/// Таблицы чатов, которых касаются тесты (как в миграциях, до 43).
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
    CREATE TABLE chatMessages (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, fromUserID BLOB NOT NULL, date INTEGER NOT NULL,
      editDate INTEGER NOT NULL DEFAULT 0, randomID INTEGER NOT NULL DEFAULT 0, mediaUnread INTEGER NOT NULL DEFAULT 0,
      silent INTEGER NOT NULL DEFAULT 0, content BLOB NOT NULL, searchText TEXT NOT NULL DEFAULT '', reactions BLOB NULL,
      reactionsUnread INTEGER NOT NULL DEFAULT 0, expireAt INTEGER NOT NULL DEFAULT 0, poll BLOB NULL, searchHit INTEGER NOT NULL DEFAULT 0,
      authorSignature TEXT NOT NULL DEFAULT '', postOut INTEGER NOT NULL DEFAULT 0,
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
  await db.execute('CREATE TABLE chatUpdatesState (userID BLOB PRIMARY KEY, pts INTEGER NOT NULL, date INTEGER NOT NULL DEFAULT 0);');
  await db.execute('''
    CREATE TABLE chatGroups (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, info BLOB NOT NULL, role INTEGER NOT NULL DEFAULT 0, pts INTEGER NOT NULL DEFAULT 0,
      rights BLOB, rank TEXT NOT NULL DEFAULT '', inviteCode TEXT NOT NULL DEFAULT '', pendingRequests INTEGER NOT NULL DEFAULT 0,
      slowModeUntil INTEGER NOT NULL DEFAULT 0, joinedAt INTEGER NOT NULL DEFAULT 0,
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
