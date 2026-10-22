import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_remote_data_source.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/screens/chats/chat_common.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Публичный канал без подписки (подэтап 4.4, docs/plans/chats-channels.md):
// кэш — как у канала (диалог + chatGroups) с ролью NONE и browsedAt; в списке,
// счётчиках и баннерах его нет; подписка делает его обычным диалогом; кэш
// чистится (последние [ChatsSync.browsedKeep], не старше
// [ChatsSync.browsedMaxAge]).
void main() {
  final me = List<int>.filled(12, 1);
  final channelChat = List<int>.filled(12, 7);

  setUpAll(() async {
    await AppLocale.ru.build();
    LocaleSettings.setLocaleSync(AppLocale.ru);
  });

  pb.ChatInfo channelInfo({List<int>? chatID, int pts = 0}) => pb.ChatInfo(
    chatID: chatID ?? channelChat,
    type: pb.ChatType.CHAT_TYPE_CHANNEL,
    title: 'Новости',
    username: 'news_channel',
    joinMode: pb.ChatJoinMode.CHAT_JOIN_OPEN,
    membersCount: 1000,
    pts: Int64(pts),
  );

  pb.ChatMessage post(int id) => pb.ChatMessage(
    chatID: channelChat,
    messageID: Int64(id),
    date: Int64(id * 1000),
    content: pb.MessageContent(text: 'пост $id'),
  );

  group('маппинг и ошибки', () {
    test('«Переслано из канала»: публичное имя канала', () {
      final forward = forwardFromPb(
        pb.MessageForward(fromChatID: channelChat, fromMessageID: Int64(42), fromName: 'Новости', fromUsername: 'news_channel'),
        myUserID: me,
      );
      expect((forward.fromChannel, forward.chatID, forward.messageID, forward.username), (true, idHex(channelChat), '42', 'news_channel'));
      // Частный канал — имени нет.
      expect(forwardFromPb(pb.MessageForward(fromChatID: channelChat), myUserID: me).username, '');
      // Пересланное от человека — не канал.
      expect(forwardFromPb(pb.MessageForward(fromUserID: List<int>.filled(12, 3)), myUserID: me).username, '');
    });

    test('«subscribeRequired» — понятный текст', () {
      const error = ChatsRequestException(subscribeRequiredError, StatusCode.failedPrecondition);
      expect(error.isSubscribeRequired, isTrue);
      expect(const ChatsRequestException('reactionsLimit', StatusCode.invalidArgument).isSubscribeRequired, isFalse);
      expect(chatsFailedText(t, 'subscribeRequired'), t.chatAction.subscribeRequired);
      expect(t.chatAction.subscribeRequired, contains('Подпишитесь'));
    });

    test('канал без подписки — не в списке; реакции ему не предлагаются', () {
      const chat = models.Chat(
        id: 'c',
        type: models.ChatType.channel,
        title: 'Новости',
        isMember: false,
        browsing: true,
        myRole: models.ChatRole.reader,
      );
      expect(chat.hiddenInList, isTrue);
      expect(chat.canPost, isFalse);
      expect(chat.copyWith(isMember: true, browsing: false).hiddenInList, isFalse);
    });
  });

  group('кэш и ChatsSync', () {
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('channel_browse');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await _createSchema(db);
      store = ChatsRepository(logger: Logger(), db: db);
      await getIt.reset();
      getIt.registerSingleton<Logger>(Logger());
      getIt.registerSingleton<Repositories>(_FakeRepositories(store));
      getIt.registerSingleton<Auth>(_FakeAuth(models.Session(userID: me)));
      getIt.registerSingleton<API>(_FakeApi());
      ChatsSync.instance.setChannels(true, initial: true);
    });

    tearDown(() async {
      for (final id in ChatsSync.instance.watched) {
        ChatsSync.instance.unwatch(idBytes(id), send: false);
      }
      ChatsSync.instance.setChannels(false, initial: true);
      await getIt.reset();
      await db.close();
      await dir.delete(recursive: true);
    });

    Future<void> apply(List<pb.Update> updates, {bool live = false}) =>
        live ? ChatsSync.instance.applyLive(pb.Updates(updates: updates)) : ChatsSync.instance.applyUpdates(pb.Updates(updates: updates));

    test('открыли без подписки: кэш с ролью NONE, pts — 0, повторное открытие не трогает pts', () async {
      expect(await ChatsSync.instance.saveBrowsedChannel(channelInfo(pts: 50)), isTrue);
      final dialog = await store.dialog(userID: me, chatID: channelChat);
      expect(dialog?.type, pb.ChatType.CHAT_TYPE_CHANNEL.value);
      var group = await store.group(userID: me, chatID: channelChat);
      expect((group?.role, group?.pts, group?.browsing), (pb.ChatRole.CHAT_ROLE_NONE, 0, true));
      expect(group!.browsedAt, greaterThan(0));

      // Watch сказал текущий pts, пришли посты.
      await store.setGroupPts(userID: me, chatID: channelChat, pts: 9);
      expect(await ChatsSync.instance.saveBrowsedChannel(channelInfo(pts: 0)..title = 'Новости 2'), isTrue);
      group = await store.group(userID: me, chatID: channelChat);
      expect((group?.pts, group?.info.title, group?.browsing), (9, 'Новости 2', true));
    });

    test('не попадает в список диалогов и счётчики; новые посты — без баннера и непрочитанных', () async {
      await ChatsSync.instance.saveBrowsedChannel(channelInfo());
      await store.setGroupPts(userID: me, chatID: channelChat, pts: 1);
      await store.setPts(userID: me, pts: 10);
      final incoming = <ChatsIncoming>[];
      final sub = ChatsSync.instance.incoming.listen(incoming.add);
      await apply([
        pb.Update(
          chatPts: Int64(2),
          chatID: channelChat,
          newMessage: pb.Update_NewMessage(message: post(1)),
        ),
      ], live: true);
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(incoming, isEmpty);
      expect(await store.message(userID: me, chatID: channelChat, messageID: 1), isNotNull);
      final dialog = await store.dialog(userID: me, chatID: channelChat);
      expect((dialog?.topMessageID, dialog?.unreadCount), (1, 0));
      expect((await store.group(userID: me, chatID: channelChat))?.pts, 2);

      // Даже с «непрочитанным» в строке диалога — в бейдж не идёт.
      await store.updateDialog(userID: me, chatID: channelChat, fields: {'unreadCount': 5});
      expect((await ChatsSync.instance.countUnread()).total, 0);

      final chat = await ChatsRemoteDataSource.instance.loadChat(idHex(channelChat));
      expect(chat, isNotNull);
      expect((chat!.isMember, chat.browsing, chat.hiddenInList, chat.unreadCount), (false, true, true, 0));
      expect(chat.myRole, models.ChatRole.reader);
      expect(chat.lastMessage?.text, 'пост 1');

      // Полный список диалогов с сервера (канала в нём нет) кэш не стирает.
      await store.replaceDialogs(userID: me, dialogs: const []);
      expect(await store.dialog(userID: me, chatID: channelChat), isNotNull);
    });

    test('подписка превращает его в обычный диалог', () async {
      await ChatsSync.instance.saveBrowsedChannel(channelInfo());
      await store.setGroupPts(userID: me, chatID: channelChat, pts: 4);
      await store.upsertMessage(userID: me, message: post(3));
      // Ответ JoinChat — диалог со сведениями и ролью подписчика.
      await ChatsSync.instance.saveDialog(
        pb.Dialog(
          chatID: channelChat,
          type: pb.ChatType.CHAT_TYPE_CHANNEL,
          role: pb.ChatRole.CHAT_ROLE_READER,
          topMessage: post(3),
          readInboxMaxID: Int64(3),
          joinedAt: Int64(1000),
          chat: channelInfo(pts: 4),
        ),
      );
      final group = await store.group(userID: me, chatID: channelChat);
      expect((group?.role, group?.browsing, group?.pts), (pb.ChatRole.CHAT_ROLE_READER, false, 4));
      // История осталась.
      expect(await store.message(userID: me, chatID: channelChat, messageID: 3), isNotNull);
      final chat = await ChatsRemoteDataSource.instance.loadChat(idHex(channelChat));
      expect((chat?.isMember, chat?.browsing, chat?.hiddenInList), (true, false, false));
      expect(await store.browsed(userID: me), isEmpty);
      // Теперь — в счётчике, как любой канал.
      await store.updateDialog(userID: me, chatID: channelChat, fields: {'unreadCount': 2});
      final unread = await ChatsSync.instance.countUnread();
      expect((unread.total, unread.byChat[idHex(channelChat)]), (1, 2));
      // Чистка его больше не трогает.
      await ChatsSync.instance.pruneBrowsed(now: DateTime.now().add(const Duration(days: 365)));
      expect(await store.dialog(userID: me, chatID: channelChat), isNotNull);
      // Подписанный не «открывается без подписки» заново.
      expect(await ChatsSync.instance.saveBrowsedChannel(channelInfo()), isFalse);
      expect((await store.group(userID: me, chatID: channelChat))?.role, pb.ChatRole.CHAT_ROLE_READER);
    });

    test('подписка: ответ без сведений — роль из диалога', () async {
      await ChatsSync.instance.saveBrowsedChannel(channelInfo());
      await ChatsSync.instance.saveDialog(
        pb.Dialog(chatID: channelChat, type: pb.ChatType.CHAT_TYPE_CHANNEL, role: pb.ChatRole.CHAT_ROLE_READER),
      );
      final group = await store.group(userID: me, chatID: channelChat);
      expect((group?.role, group?.browsing), (pb.ChatRole.CHAT_ROLE_READER, false));
    });

    test('чистка кэша: не старше 7 дней и не больше 10 последних; открытые — всегда', () async {
      final now = DateTime(2026, 10, 22).millisecondsSinceEpoch;
      const day = Duration(days: 1);
      List<int> channel(int n) => [...List<int>.filled(11, 50), n];
      // 12 каналов, открытых в разные дни (0 — сегодня … 11 — 11 дней назад).
      for (var n = 0; n < 12; n++) {
        await store.saveBrowsedChannel(
          userID: me,
          info: channelInfo(chatID: channel(n)),
          at: now - n * day.inMilliseconds,
        );
        await store.upsertMessage(userID: me, message: post(1)..chatID = channel(n));
      }
      // Подписанный канал чистка не трогает.
      await store.upsertDialog(
        userID: me,
        dialog: pb.Dialog(
          chatID: channelChat,
          type: pb.ChatType.CHAT_TYPE_CHANNEL,
          role: pb.ChatRole.CHAT_ROLE_READER,
          chat: channelInfo(pts: 1),
        ),
      );

      final deleted = await store.pruneBrowsed(
        userID: me,
        now: now,
        maxAge: ChatsSync.browsedMaxAge,
        maxCount: ChatsSync.browsedKeep,
        // Окно 9-го (9 дней назад) открыто сейчас.
        keep: {idHex(channel(9))},
      );
      // Остаются 0..7 (не старше 7 дней) и открытый 9-й; 8, 10, 11 — удалены.
      expect({for (final id in deleted) id.last}, {8, 10, 11});
      expect({for (final b in await store.browsed(userID: me)) b.chatID.last}, {0, 1, 2, 3, 4, 5, 6, 7, 9});
      for (final n in [8, 10, 11]) {
        expect(await store.dialog(userID: me, chatID: channel(n)), isNull);
        expect(await store.group(userID: me, chatID: channel(n)), isNull);
        expect(await store.message(userID: me, chatID: channel(n), messageID: 1), isNull);
      }
      expect(await store.dialog(userID: me, chatID: channelChat), isNotNull);

      // Лимит числа: из свежих остаются 10 последних открытых.
      for (var n = 20; n < 25; n++) {
        await store.saveBrowsedChannel(
          userID: me,
          info: channelInfo(chatID: channel(n)),
          at: now + n,
        );
      }
      await store.pruneBrowsed(userID: me, now: now, maxAge: ChatsSync.browsedMaxAge, maxCount: ChatsSync.browsedKeep);
      expect({for (final b in await store.browsed(userID: me)) b.chatID.last}, {20, 21, 22, 23, 24, 0, 1, 2, 3, 4});
    });

    test('ChatsSync.pruneBrowsed: открытый сейчас (Watch) не удаляется', () async {
      await ChatsSync.instance.saveBrowsedChannel(channelInfo());
      final chat = Uint8List.fromList(channelChat);
      ChatsSync.instance.watch(chat);
      await ChatsSync.instance.pruneBrowsed(now: DateTime.now().add(const Duration(days: 30)));
      expect(await store.dialog(userID: me, chatID: channelChat), isNotNull);
      ChatsSync.instance.unwatch(chat, send: false);
      expect(ChatsSync.instance.watched, isEmpty);
      await ChatsSync.instance.pruneBrowsed(now: DateTime.now().add(const Duration(days: 30)));
      expect(await store.dialog(userID: me, chatID: channelChat), isNull);
    });
  });
}

class _FakeRepositories implements Repositories {
  @override
  final ChatsRepository chats;

  @override
  final HiddenProfiles hiddenProfiles = _FakeHiddenProfiles();

  @override
  final SecretChatsRepository secretChats = _FakeSecretChats();

  _FakeRepositories(this.chats);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeHiddenProfiles implements HiddenProfiles {
  @override
  Future<Map<String, String>> hashByHex() async => const {};

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSecretChats implements SecretChatsRepository {
  @override
  Future<List<SecretChatRecord>> chats({required List<int> sessionID}) async => const [];

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

/// Таблицы чатов, которых касаются тесты (как в миграциях, до 46).
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
      slowModeUntil INTEGER NOT NULL DEFAULT 0, joinedAt INTEGER NOT NULL DEFAULT 0, browsedAt INTEGER NOT NULL DEFAULT 0,
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
  // «Ответы» (4.6) — их состояние читает подсчёт непрочитанных.
  await db.execute(ChatsRepository.repliesSchema);
  await db.execute(ChatsRepository.repliesStateSchema);
  await db.execute(ChatsRepository.repliesChatsSchema);
}
