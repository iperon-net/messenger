import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/channel_rights.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/push_payload_v1.pb.dart';
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/push.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/screens/chats/chat_common.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Комментарии к постам канала (подэтап 4.3, docs/plans/chats-channels.md):
// ветка — скрытый чат (type = THREAD), её сведения и pts — в chatGroups,
// связь с постом — в chatThreads; комментарии поста — `MessageComments` BLOB,
// мой readMaxID в нём не уменьшается общим журналом; ветка не попадает в
// список, счётчики и баннеры.
void main() {
  final me = List<int>.filled(12, 1);
  final other = List<int>.filled(12, 3);
  final channelChat = List<int>.filled(12, 7);
  final threadChat = List<int>.filled(12, 9);

  setUpAll(() async {
    await AppLocale.ru.build();
    LocaleSettings.setLocaleSync(AppLocale.ru);
  });

  pb.ChatMessage post(int id, {pb.MessageComments? comments}) => pb.ChatMessage(
    chatID: channelChat,
    messageID: Int64(id),
    date: Int64(id * 1000),
    content: pb.MessageContent(text: 'пост $id'),
    comments: comments,
  );

  pb.MessageComments comments({int count = 0, int readMaxID = 0, int maxID = 0, int closeDate = 0, List<List<int>> users = const []}) =>
      pb.MessageComments(
        count: count,
        readMaxID: Int64(readMaxID),
        maxID: Int64(maxID),
        closeDate: Int64(closeDate),
        threadChatID: threadChat,
        recentUserIDs: users,
      );

  pb.ChatInfo threadInfo({int pts = 1, int closeDate = 0}) => pb.ChatInfo(
    chatID: threadChat,
    type: pb.ChatType.CHAT_TYPE_THREAD,
    parentChatID: channelChat,
    postID: Int64(5),
    commentsCloseDate: Int64(closeDate),
    pts: Int64(pts),
  );

  group('маппинг', () {
    models.Message map(pb.ChatMessage m, {bool channel = true}) =>
        messageFromPb(m, chatID: idHex(channelChat), myUserID: me, readOutboxMaxID: 0, isSelf: false, channel: channel);

    test('комментарии поста: число, комментаторы (userID), срок, ветка', () {
      final users = [List<int>.filled(12, 4), List<int>.filled(12, 5), List<int>.filled(12, 6), List<int>.filled(12, 8)];
      final m = map(post(5, comments: comments(count: 12, closeDate: 9000, users: users)));
      expect(m.commentsCount, 12);
      expect(m.commenters, [for (final u in users.take(3)) idHex(u)]);
      expect(m.commentsCloseDate, DateTime.fromMillisecondsSinceEpoch(9000));
      expect(m.commentsThreadID, idHex(threadChat));
      expect(m.commentsClosed(DateTime.fromMillisecondsSinceEpoch(10000)), isTrue);

      // Не канал — комментариев нет.
      final plain = map(post(5, comments: comments(count: 12)), channel: false);
      expect((plain.commentsCount, plain.commentsThreadID), (0, ''));
      expect(plain.commenters, isEmpty);
      // Бессрочно — срока нет.
      expect(map(post(6, comments: comments(count: 1))).commentsCloseDate, isNull);
    });

    test('непрочитанное в ветке — только если её уже читали', () {
      expect(map(post(5, comments: comments(count: 3, maxID: 3))).commentsUnread, isFalse);
      expect(map(post(5, comments: comments(count: 3, readMaxID: 2, maxID: 3))).commentsUnread, isTrue);
      expect(map(post(5, comments: comments(count: 3, readMaxID: 3, maxID: 3))).commentsUnread, isFalse);
    });

    test('слияние: мой readMaxID не уменьшается, остальное — свежее', () {
      final stored = comments(count: 2, readMaxID: 7, maxID: 7);
      final merged = mergeComments(stored, comments(count: 4, maxID: 9, closeDate: 100));
      expect((merged.count, merged.readMaxID.toInt(), merged.maxID.toInt(), merged.closeDate.toInt()), (4, 7, 9, 100));
      expect(mergeComments(stored, comments(count: 4, readMaxID: 9)).readMaxID.toInt(), 9);
      expect(mergeComments(null, comments(count: 1)).count, 1);
    });

    test('ChatInfo канала: кто может комментировать', () {
      expect(commentsWhoFromPb(pb.ChatCommentsWho.CHAT_COMMENTS_WHO_SUBSCRIBERS), models.ChatCommentsWho.subscribers);
      expect(commentsWhoFromPb(pb.ChatCommentsWho.CHAT_COMMENTS_WHO_ALL), models.ChatCommentsWho.all);
      for (final who in models.ChatCommentsWho.values) {
        expect(commentsWhoFromPb(commentsWhoToPb(who)), who);
      }
    });

    test('ветка → скрытый чат с настройками канала', () {
      final channel = pb.ChatInfo(
        chatID: channelChat,
        type: pb.ChatType.CHAT_TYPE_CHANNEL,
        title: 'Новости',
        membersCount: 1000,
        slowMode: 30,
        newcomerMediaDelay: 3600,
      );
      final chat = threadChatFromPb(threadInfo(closeDate: 5000), channel: channel, unreadCount: 2);
      expect(chat.id, idHex(threadChat));
      expect((chat.isThread, chat.threadOf, chat.threadPostID), (true, idHex(channelChat), '5'));
      expect((chat.title, chat.slowMode, chat.newcomerMediaDelay, chat.membersCount), ('Новости', 30, 3600, 1000));
      expect(chat.commentsCloseDate, DateTime.fromMillisecondsSinceEpoch(5000));
      expect(chat.unreadCount, 2);
      // Писать может любой; в списке не видна.
      expect(chat.myRole, models.ChatRole.writer);
      expect(chat.hiddenInList, isTrue);
      // Админов канала медленный режим не касается.
      expect(threadChatFromPb(threadInfo(), channel: channel, channelAdmin: true).slowMode, 0);
    });

    test('пост шапкой ветки — не сообщение ветки', () {
      final id = threadPostMessageID(5);
      expect(id, startsWith(threadPostPrefix));
      expect(serverMessageID(id), isNull);
    });
  });

  group('права в ветке и меню поста', () {
    final channel = models.Chat(
      id: idHex(channelChat),
      type: models.ChatType.channel,
      title: 'Новости',
      commentsEnabled: true,
      myRole: models.ChatRole.admin,
      myRights: const models.ChatAdminRights(deleteMessages: true, banUsers: true),
    );
    const author = models.ChatMember(id: 'aa', name: 'Анна', role: models.ChatRole.reader);

    test('удалить чужой комментарий и заблокировать автора — по правам админа канала', () {
      expect(channelCan(channel, const [], ChannelAction.deleteOthers), isTrue);
      expect(channelCan(channel, const [], ChannelAction.ban, target: author), isTrue);
      final poster = channel.copyWith(myRights: const models.ChatAdminRights(postMessages: true));
      expect(channelCan(poster, const [], ChannelAction.deleteOthers), isFalse);
      expect(channelCan(poster, const [], ChannelAction.ban, target: author), isFalse);
      final reader = channel.copyWith(myRole: models.ChatRole.reader, myRights: const models.ChatAdminRights());
      expect(channelCan(reader, const [], ChannelAction.ban, target: author), isFalse);
    });

    test('«Закрыть комментарии» — с правом править посты', () {
      final message = models.Message(id: '5', chatID: channel.id, date: DateTime(2026));
      expect(canToggleComments(channel, message), isFalse);
      expect(canToggleComments(channel.copyWith(myRights: const models.ChatAdminRights(editMessages: true)), message), isTrue);
      expect(canToggleComments(channel.copyWith(myRole: models.ChatRole.owner, myRights: const models.ChatAdminRights()), message), isTrue);
      expect(
        canToggleComments(channel.copyWith(commentsEnabled: false, myRights: const models.ChatAdminRights(editMessages: true)), message),
        isFalse,
      );
    });
  });

  group('ошибки', () {
    test('отказы комментариев — понятные тексты', () {
      expect(chatsFailedText(t, 'commentsDisabled'), t.chatAction.commentsDisabled);
      expect(chatsFailedText(t, 'commentsClosed'), t.chatAction.commentsClosed);
      expect(chatsFailedText(t, 'commentsSubscribersOnly'), t.chatAction.commentsSubscribersOnly);
      expect(chatsFailedText(t, 'commentsTooNew:3600'), startsWith('Вы недавно подписались на канал'));
      expect(chatsFailedText(t, 'somethingElse'), t.chatAction.failed);
    });

    test('«commentsTooNew:N» — сколько ждать', () {
      expect(commentsTooNewSeconds('commentsTooNew:90'), 90);
      expect(commentsTooNewSeconds('commentsTooNew:x'), isNull);
      expect(commentsTooNewSeconds('commentsClosed'), isNull);
      expect(commentsErrors, containsAll(['commentsDisabled', 'commentsClosed', 'commentsSubscribersOnly']));
    });
  });

  test('тап по пушу комментария — в ветку по каналу и посту', () {
    final channel = idHex(channelChat);
    final thread = idHex(threadChat);
    expect(
      PushManager.routeForKind(PushPayload_Kind.MESSAGE, chatID: thread, parentChatID: channel, postID: '5'),
      '/chats/comments/$channel/5',
    );
    // Без поста — как обычное сообщение.
    expect(PushManager.routeForKind(PushPayload_Kind.MESSAGE, chatID: thread, parentChatID: channel, postID: '0'), '/chats/chat/$thread');
    expect(PushManager.routeForKind(PushPayload_Kind.MESSAGE, chatID: thread), '/chats/chat/$thread');
  });

  group('кэш и ChatsSync', () {
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('channel_comments');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await _createSchema(db);
      store = ChatsRepository(logger: Logger(), db: db);
      await getIt.reset();
      getIt.registerSingleton<Logger>(Logger());
      getIt.registerSingleton<Repositories>(_FakeRepositories(store));
      getIt.registerSingleton<Auth>(_FakeAuth(models.Session(userID: me)));
      ChatsSync.instance.setChannels(true, initial: true);
    });

    tearDown(() async {
      ChatsSync.instance.setChannels(false, initial: true);
      await getIt.reset();
      await db.close();
      await dir.delete(recursive: true);
    });

    pb.Dialog channelDialog() => pb.Dialog(
      chatID: channelChat,
      type: pb.ChatType.CHAT_TYPE_CHANNEL,
      role: pb.ChatRole.CHAT_ROLE_READER,
      chat: pb.ChatInfo(chatID: channelChat, type: pb.ChatType.CHAT_TYPE_CHANNEL, title: 'Новости', commentsEnabled: true, pts: Int64(1)),
    );

    Future<void> apply(List<pb.Update> updates) => ChatsSync.instance.applyUpdates(pb.Updates(updates: updates));

    pb.ChatMessage comment(int id, {List<int>? from}) => pb.ChatMessage(
      chatID: threadChat,
      messageID: Int64(id),
      fromUserID: from ?? other,
      date: Int64(10000 + id),
      content: pb.MessageContent(text: 'комментарий $id'),
    );

    test('комментарии поста хранятся; правка без них и журнал канала не сбрасывают мой readMaxID', () async {
      await store.upsertMessage(
        userID: me,
        message: post(5, comments: comments(count: 2, readMaxID: 4, maxID: 4)),
      );
      // Правка поста из журнала — без комментариев.
      await store.upsertMessage(userID: me, message: post(5)..editDate = Int64(9), shared: true);
      var cached = await store.message(userID: me, chatID: channelChat, messageID: 5);
      expect((cached?.comments.count, cached?.comments.readMaxID.toInt()), (2, 4));
      // Общее обновление поста с комментариями (readMaxID 0).
      await store.upsertMessage(
        userID: me,
        message: post(5, comments: comments(count: 3, maxID: 6)),
        shared: true,
      );
      cached = await store.message(userID: me, chatID: channelChat, messageID: 5);
      expect((cached?.comments.count, cached?.comments.readMaxID.toInt(), cached?.comments.maxID.toInt()), (3, 4, 6));
    });

    test('Update.postComments (журнал канала) обновляет пост и срок открытой ветки', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      await store.setPts(userID: me, pts: 10);
      await store.upsertMessage(
        userID: me,
        message: post(5, comments: comments(count: 1, readMaxID: 3, maxID: 3)),
      );
      await store.saveThread(userID: me, info: threadInfo(), readInboxMaxID: 3);
      await apply([
        pb.Update(
          chatPts: Int64(2),
          chatID: channelChat,
          postComments: pb.Update_PostCommentsChanged(
            chatID: channelChat,
            postID: Int64(5),
            comments: comments(count: 4, maxID: 8, closeDate: 7777, users: [other]),
          ),
        ),
      ]);
      final cached = await store.message(userID: me, chatID: channelChat, messageID: 5);
      expect((cached?.comments.count, cached?.comments.readMaxID.toInt(), cached?.comments.maxID.toInt()), (4, 3, 8));
      expect(cached?.comments.recentUserIDs.single, other);
      expect((await store.group(userID: me, chatID: threadChat))?.info.commentsCloseDate.toInt(), 7777);
      expect((await store.group(userID: me, chatID: channelChat))?.pts, 2);
      // Поста нет в кэше — ничего не заводим.
      await store.setPostComments(userID: me, chatID: channelChat, postID: 99, comments: comments(count: 1));
      expect(await store.message(userID: me, chatID: channelChat, messageID: 99), isNull);
    });

    test('ветка: chatThreads, диалог THREAD и сведения; повторное открытие не трогает историю', () async {
      await store.saveThread(userID: me, info: threadInfo(pts: 4), readInboxMaxID: 2);
      expect(await store.thread(userID: me, chatID: channelChat, postID: 5), threadChat);
      final link = await store.threadPost(userID: me, threadChatID: threadChat);
      expect(link?.chatID, channelChat);
      expect(link?.postID, 5);
      final dialog = await store.dialog(userID: me, chatID: threadChat);
      expect((dialog?.type, dialog?.readInboxMaxID), (pb.ChatType.CHAT_TYPE_THREAD.value, 2));
      final group = await store.group(userID: me, chatID: threadChat);
      expect((group?.info.type, group?.pts), (pb.ChatType.CHAT_TYPE_THREAD, 4));

      await store.upsertMessage(userID: me, message: comment(3));
      await store.setTopMessage(userID: me, chatID: threadChat, message: comment(3));
      await store.setGroupPts(userID: me, chatID: threadChat, pts: 9);
      // Снова открыли (OpenComments): сведения новые, pts и последнее — свои.
      await store.saveThread(userID: me, info: threadInfo(pts: 1, closeDate: 50), readInboxMaxID: 1);
      expect((await store.dialog(userID: me, chatID: threadChat))?.topMessageID, 3);
      expect((await store.dialog(userID: me, chatID: threadChat))?.readInboxMaxID, 2);
      expect((await store.group(userID: me, chatID: threadChat))?.pts, 9);
      expect((await store.group(userID: me, chatID: threadChat))?.info.commentsCloseDate.toInt(), 50);
    });

    test('прочтение ветки: readInboxMaxID, непрочитанные по кэшу и readMaxID у поста', () async {
      await store.upsertMessage(
        userID: me,
        message: post(5, comments: comments(count: 3, readMaxID: 1, maxID: 3)),
      );
      await store.saveThread(userID: me, info: threadInfo(), readInboxMaxID: 1);
      await store.upsertMessage(userID: me, message: comment(2));
      await store.upsertMessage(
        userID: me,
        message: comment(3, from: me),
      );
      await store.upsertMessage(userID: me, message: comment(4));
      expect(await store.countIncomingAfter(userID: me, chatID: threadChat, afterID: 1), 2);

      await store.setThreadRead(userID: me, threadChatID: threadChat, maxID: 2);
      var dialog = await store.dialog(userID: me, chatID: threadChat);
      expect((dialog?.readInboxMaxID, dialog?.unreadCount), (2, 1));
      expect((await store.postComments(userID: me, chatID: channelChat, postID: 5))?.readMaxID.toInt(), 2);

      // ReadInbox из журнала (другое устройство) — так же.
      await store.setPts(userID: me, pts: 10);
      await apply([
        pb.Update(
          pts: Int64(11),
          readInbox: pb.Update_ReadInbox(chatID: threadChat, maxID: Int64(4)),
        ),
      ]);
      dialog = await store.dialog(userID: me, chatID: threadChat);
      expect((dialog?.readInboxMaxID, dialog?.unreadCount), (4, 0));
      final read = await store.postComments(userID: me, chatID: channelChat, postID: 5);
      expect(read?.readMaxID.toInt(), 4);
      expect(commentsUnreadOf(read!), isFalse);
      // Назад не идёт.
      await store.setThreadRead(userID: me, threadChatID: threadChat, maxID: 3);
      expect((await store.dialog(userID: me, chatID: threadChat))?.readInboxMaxID, 4);
    });

    test('ветка не в списке: полный список её не стирает, в счётчик и баннеры не идёт', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      await store.saveThread(userID: me, info: threadInfo(), readInboxMaxID: 0);
      await store.replaceDialogs(userID: me, dialogs: [channelDialog()]);
      expect(await store.dialog(userID: me, chatID: threadChat), isNotNull);
      expect(ChatsSync.instance.showsChatType(pb.ChatType.CHAT_TYPE_THREAD.value), isFalse);

      // Новый комментарий вживую (журнал ветки, Watch) — без баннера.
      getIt.registerSingleton<API>(_FakeApi());
      await store.setPts(userID: me, pts: 10);
      final incoming = <ChatsIncoming>[];
      final sub = ChatsSync.instance.incoming.listen(incoming.add);
      await ChatsSync.instance.applyLive(
        pb.Updates(
          updates: [
            pb.Update(
              chatPts: Int64(2),
              chatID: threadChat,
              newMessage: pb.Update_NewMessage(message: comment(1)),
            ),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(incoming, isEmpty);
      expect(await store.message(userID: me, chatID: threadChat, messageID: 1), isNotNull);
      expect((await store.group(userID: me, chatID: threadChat))?.pts, 2);
    });

    test('канал удалён — и его ветки', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      await store.saveThread(userID: me, info: threadInfo(), readInboxMaxID: 0);
      await store.upsertMessage(userID: me, message: comment(1));
      await store.deleteDialog(userID: me, chatID: channelChat);
      expect(await store.dialog(userID: me, chatID: threadChat), isNull);
      expect(await store.thread(userID: me, chatID: channelChat, postID: 5), isNull);
      expect(await store.message(userID: me, chatID: threadChat, messageID: 1), isNull);
    });

    test('Watch: подписка держится, пока открыто хоть одно окно', () {
      final sync = ChatsSync.instance;
      final chat = Uint8List.fromList(threadChat);
      sync.watch(chat);
      sync.watch(chat);
      expect(sync.watched, {idHex(threadChat)});
      sync.unwatch(chat);
      expect(sync.watched, {idHex(threadChat)});
      sync.unwatch(chat);
      expect(sync.watched, isEmpty);
      sync.unwatch(chat);
      expect(sync.watched, isEmpty);
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

class _FakeApi implements API {
  @override
  Stream<Uint8List> on(MessageType type) => const Stream.empty();

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

/// Таблицы чатов, которых касаются тесты (как в миграциях, до 45).
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
      authorSignature TEXT NOT NULL DEFAULT '', postOut INTEGER NOT NULL DEFAULT 0, views INTEGER NOT NULL DEFAULT 0,
      viewed INTEGER NOT NULL DEFAULT 0, comments BLOB NULL,
      PRIMARY KEY (userID, chatID, messageID)
    );
  ''');
  await db.execute(ChatsRepository.mentionsSchema);
  await db.execute(ChatsRepository.threadsSchema);
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
