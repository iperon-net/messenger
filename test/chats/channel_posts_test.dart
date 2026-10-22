import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/auth.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/reactions.dart';
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

  group('4.2: просмотры, пересылка, лимит реакций', () {
    test('просмотры поста — только в канале и не у служебных', () {
      models.Message map(pb.ChatMessage m, {bool channel = true}) =>
          messageFromPb(m, chatID: idHex(channelChat), myUserID: me, readOutboxMaxID: 0, isSelf: false, channel: channel);
      expect(map(post(3)..views = 42).views, 42);
      expect(map(post(3)..views = 42, channel: false).views, 0);
      final service = post(4)
        ..views = 9
        ..content = pb.MessageContent(
          chatAction: pb.MessageChatAction(kind: pb.MessageChatAction_Kind.CREATED, title: 'Новости'),
        );
      expect(map(service).views, 0);
    });

    test('«Переслано из» канала: канал, пост, подпись', () {
      final f = forwardFromPb(
        pb.MessageForward(fromChatID: channelChat, fromMessageID: Int64(9), fromName: 'Новости', fromSignature: 'Анна'),
        myUserID: me,
      );
      expect(f.fromChannel, isTrue);
      expect((f.chatID, f.messageID, f.signature, f.hidden, f.self, f.userID), (idHex(channelChat), '9', 'Анна', false, false, ''));
      expect(f.title, 'Новости (Анна)');
      expect(
        forwardFromPb(
          pb.MessageForward(fromChatID: channelChat, fromName: 'Новости'),
          myUserID: me,
        ).title,
        'Новости',
      );

      // От человека — как раньше; без автора — «скрыт».
      final person = forwardFromPb(
        pb.MessageForward(fromUserID: List<int>.filled(12, 3), fromName: 'Анна'),
        myUserID: me,
      );
      expect((person.fromChannel, person.hidden), (false, false));
      expect(forwardFromPb(pb.MessageForward(fromName: 'Анна'), myUserID: me).hidden, isTrue);
    });

    test('«Максимум реакций под постом» из ChatInfo; у группы — без лимита', () {
      expect(maxReactionsOf(pb.ChatInfo(type: pb.ChatType.CHAT_TYPE_CHANNEL, maxReactions: 3)), 3);
      expect(maxReactionsOf(pb.ChatInfo(type: pb.ChatType.CHAT_TYPE_CHANNEL)), maxReactionsPerPost);
      expect(maxReactionsOf(pb.ChatInfo(type: pb.ChatType.CHAT_TYPE_CHANNEL, maxReactions: 50)), maxReactionsPerPost);
      expect(maxReactionsOf(pb.ChatInfo(type: pb.ChatType.CHAT_TYPE_GROUP, maxReactions: 3)), maxReactionsPerPost);

      // Лимит набран — только уже стоящие под постом.
      final chat = models.Chat(id: idHex(channelChat), type: models.ChatType.channel, title: 'Новости', maxReactions: 2);
      final full = models.Message(
        id: '1',
        chatID: chat.id,
        date: DateTime(2026),
        reactions: const [
          models.MessageReaction(emoji: '👍'),
          models.MessageReaction(emoji: '❤️'),
        ],
      );
      expect(availableReactions(chat, message: full).toSet(), {'👍', '❤️'});
      expect(
        availableReactions(
          chat,
          message: full.copyWith(reactions: const [models.MessageReaction(emoji: '👍')]),
        ),
        allChatReactions,
      );
    });

    test('отказ «reactionsLimit» распознаётся', () {
      expect(const ChatsRequestException('reactionsLimit', StatusCode.invalidArgument).isReactionsLimit, isTrue);
      expect(const ChatsRequestException('reactionsLimit', StatusCode.permissionDenied).isReactionsLimit, isFalse);
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

    Future<void> apply(List<pb.Update> updates) => ChatsSync.instance.applyUpdates(pb.Updates(updates: updates));

    test('просмотры: только растут, журнал (0) их не сбрасывает; пометка «учтён»', () async {
      await store.upsertMessage(userID: me, message: post(2)..views = 5);
      await store.upsertMessage(userID: me, message: post(2), shared: true);
      expect((await store.message(userID: me, chatID: channelChat, messageID: 2))?.views, 5);
      await store.setViews(userID: me, chatID: channelChat, views: {2: 8, 99: 1});
      expect((await store.message(userID: me, chatID: channelChat, messageID: 2))?.views, 8);
      await store.setViews(userID: me, chatID: channelChat, views: {2: 3});
      expect((await store.message(userID: me, chatID: channelChat, messageID: 2))?.views, 8);

      await store.upsertMessage(userID: me, message: post(3));
      expect(await store.viewedIDs(userID: me, chatID: channelChat, messageIDs: [2, 3]), isEmpty);
      await store.markViewed(userID: me, chatID: channelChat, messageIDs: [3]);
      expect(await store.viewedIDs(userID: me, chatID: channelChat, messageIDs: [2, 3]), {3});
      // Правка поста пометку не снимает.
      await store.upsertMessage(userID: me, message: post(3)..editDate = Int64(9), shared: true);
      expect(await store.viewedIDs(userID: me, chatID: channelChat, messageIDs: [3]), {3});
    });

    test('реакции: журнал канала без actor не трогает мои, мой набор — из журнала пользователя', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      await store.setPts(userID: me, pts: 10);
      await store.upsertMessage(
        userID: me,
        message: post(2)
          ..reactions = pb.MessageReactions(
            counts: [
              pb.ReactionCount(emoji: '👍', count: 3, chosenOrder: 1),
              pb.ReactionCount(emoji: '❤️', count: 1),
            ],
          ),
      );
      pb.Update shared(int chatPts, List<pb.ReactionCount> counts) => pb.Update(
        chatPts: Int64(chatPts),
        chatID: channelChat,
        messageReactions: pb.Update_MessageReactionsChanged(
          chatID: channelChat,
          messageID: Int64(2),
          reactions: pb.MessageReactions(counts: counts),
        ),
      );
      Future<Map<String, (int, int)>> chips() async {
        final r = await store.messageReactions(userID: me, chatID: channelChat, messageID: 2);
        return {for (final c in r!.counts) c.emoji: (c.count, c.chosenOrder)};
      }

      // Слитное обновление канала — числа новые, моя 👍 на месте.
      await apply([
        shared(2, [
          pb.ReactionCount(emoji: '👍', count: 5),
          pb.ReactionCount(emoji: '❤️', count: 2),
          pb.ReactionCount(emoji: '🔥', count: 1),
        ]),
      ]);
      expect(await chips(), {'👍': (5, 1), '❤️': (2, 0), '🔥': (1, 0)});

      // Мой набор (журнал пользователя, глазами меня): поставил 🔥.
      await apply([
        pb.Update(
          pts: Int64(11),
          messageReactions: pb.Update_MessageReactionsChanged(
            chatID: channelChat,
            messageID: Int64(2),
            reactions: pb.MessageReactions(
              counts: [
                pb.ReactionCount(emoji: '👍', count: 5, chosenOrder: 1),
                pb.ReactionCount(emoji: '❤️', count: 2),
                pb.ReactionCount(emoji: '🔥', count: 2, chosenOrder: 2),
              ],
            ),
          ),
        ),
      ]);
      expect(await chips(), {'👍': (5, 1), '❤️': (2, 0), '🔥': (2, 2)});

      // Снял все свои (журнал пользователя без chosenOrder) — моих не остаётся.
      await apply([
        pb.Update(
          pts: Int64(12),
          messageReactions: pb.Update_MessageReactionsChanged(
            chatID: channelChat,
            messageID: Int64(2),
            reactions: pb.MessageReactions(
              counts: [
                pb.ReactionCount(emoji: '👍', count: 4),
                pb.ReactionCount(emoji: '❤️', count: 2),
              ],
            ),
          ),
        ),
      ]);
      expect(await chips(), {'👍': (4, 0), '❤️': (2, 0)});

      // И слитное после этого — тоже без моих.
      await apply([
        shared(3, [pb.ReactionCount(emoji: '👍', count: 4), pb.ReactionCount(emoji: '❤️', count: 3)]),
      ]);
      expect(await chips(), {'👍': (4, 0), '❤️': (3, 0)});
    });

    test('опрос: журнал канала без actor не трогает мой выбор', () async {
      await store.upsertDialog(userID: me, dialog: channelDialog());
      await store.setPts(userID: me, pts: 10);
      await store.upsertMessage(
        userID: me,
        message: post(2)
          ..content = pb.MessageContent(
            poll: pb.MessagePoll(question: 'Да?', options: ['Да', 'Нет'], anonymous: true),
          )
          ..poll = pb.PollResults(votes: [1, 0], totalVoters: 1, chosen: [0], correctOption: -1),
      );
      pb.Update shared(int chatPts, pb.PollResults results) => pb.Update(
        chatPts: Int64(chatPts),
        chatID: channelChat,
        messagePoll: pb.Update_MessagePollChanged(chatID: channelChat, messageID: Int64(2), results: results),
      );
      await apply([
        shared(2, pb.PollResults(votes: [3, 4], totalVoters: 7, correctOption: -1)),
      ]);
      var results = await store.pollResults(userID: me, chatID: channelChat, messageID: 2);
      expect(results?.votes, [3, 4]);
      expect(results?.chosen, [0]);
      expect(results?.totalVoters, 7);

      // Мой выбор (журнал пользователя, без actor) — как есть: переголосовал.
      await apply([
        pb.Update(
          pts: Int64(11),
          messagePoll: pb.Update_MessagePollChanged(
            chatID: channelChat,
            messageID: Int64(2),
            results: pb.PollResults(votes: [2, 5], totalVoters: 7, chosen: [1], correctOption: -1),
          ),
        ),
      ]);
      results = await store.pollResults(userID: me, chatID: channelChat, messageID: 2);
      expect(results?.chosen, [1]);

      // Завершение (журнал канала) — итоги всем, мой выбор на месте.
      await apply([
        shared(3, pb.PollResults(votes: [2, 6], totalVoters: 8, closed: true, correctOption: -1)),
      ]);
      results = await store.pollResults(userID: me, chatID: channelChat, messageID: 2);
      expect(results?.chosen, [1]);
      expect((results?.closed, results?.totalVoters), (true, 8));
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

/// Таблицы чатов, которых касаются тесты (как в миграциях, до 44).
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
      authorSignature TEXT NOT NULL DEFAULT '', postOut INTEGER NOT NULL DEFAULT 0, views INTEGER NOT NULL DEFAULT 0, viewed INTEGER NOT NULL DEFAULT 0,
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
