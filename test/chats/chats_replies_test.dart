import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_replies.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/cubit/chat/chat_cubit.dart' show isForwardTarget;
import 'package:messenger/di.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/utils.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Подэтап 4.6 (docs/plans/chats-channels.md): пересылка в канал и «Ответы»
// (как Replies в Telegram) — ответы на мои комментарии и упоминания меня в
// ветках; журнал пользователя `Update.replies`, строка «Ответы» в списке,
// 1 чат в общем счётчике.
void main() {
  final me = List<int>.filled(12, 1);
  final anna = List<int>.filled(12, 3);
  final channelChat = List<int>.filled(12, 7);
  final threadChat = List<int>.filled(12, 9);

  setUpAll(() async {
    await AppLocale.ru.build();
    LocaleSettings.setLocaleSync(AppLocale.ru);
  });

  group('пересылка: куда можно', () {
    models.Chat channel({models.ChatRole role = models.ChatRole.admin, models.ChatAdminRights? rights, bool browsing = false}) =>
        models.Chat(
          id: 'c',
          type: models.ChatType.channel,
          title: 'Новости',
          myRole: role,
          myRights: rights,
          isMember: !browsing,
          browsing: browsing,
        );

    test('канал — только с правом публиковать', () {
      expect(isForwardTarget(channel(role: models.ChatRole.owner, rights: const models.ChatAdminRights())), isTrue);
      expect(isForwardTarget(channel(rights: const models.ChatAdminRights(postMessages: true))), isTrue);
      expect(isForwardTarget(channel(rights: const models.ChatAdminRights(editMessages: true, deleteMessages: true))), isFalse);
      expect(isForwardTarget(channel(role: models.ChatRole.reader, rights: const models.ChatAdminRights())), isFalse);
      // Демо: права админа неизвестны — как поле ввода.
      expect(isForwardTarget(channel()), isTrue);
      // Без подписки — нет (даже публичный, даже если когда-то был админом).
      expect(isForwardTarget(channel(role: models.ChatRole.owner, browsing: true)), isFalse);
    });

    test('ветки, «Ответы», «Iperon», «Чтение» в группе, сообщество, скрытый профиль — нет', () {
      const thread = models.Chat(id: 't', type: models.ChatType.group, title: '', threadOf: 'c', threadPostID: '5');
      const replies = models.Chat(id: models.repliesChatID, type: models.ChatType.private, title: '');
      const system = models.Chat(id: 's', type: models.ChatType.private, title: '', peerUserID: models.systemUserID);
      const reader = models.Chat(id: 'g', type: models.ChatType.group, title: '', myRole: models.ChatRole.reader);
      const writer = models.Chat(id: 'g2', type: models.ChatType.group, title: '');
      const community = models.Chat(id: 'm', type: models.ChatType.community, title: '');
      const private = models.Chat(id: 'p', type: models.ChatType.private, title: '', peerUserID: 'aa');
      const saved = models.Chat(id: 'self', type: models.ChatType.private, title: '', isSelf: true);
      for (final chat in [thread, replies, system, reader, community]) {
        expect(isForwardTarget(chat), isFalse, reason: chat.id);
      }
      expect(isForwardTarget(writer), isTrue);
      expect(isForwardTarget(private), isTrue);
      expect(isForwardTarget(saved), isTrue);
      expect(isForwardTarget(private, hidden: {'aa': 'hash'}), isFalse);
    });

    test('опрос — в группы и каналы, не в личные', () {
      const writer = models.Chat(id: 'g', type: models.ChatType.group, title: '');
      const private = models.Chat(id: 'p', type: models.ChatType.private, title: '', peerUserID: 'aa');
      const saved = models.Chat(id: 'self', type: models.ChatType.private, title: '', isSelf: true);
      expect(isForwardTarget(writer, polls: true), isTrue);
      expect(isForwardTarget(channel(rights: const models.ChatAdminRights(postMessages: true)), polls: true), isTrue);
      expect(isForwardTarget(private, polls: true), isFalse);
      expect(isForwardTarget(saved, polls: true), isFalse);
    });

    test('пересылка в канал в outbox — пост: автор скрыт, «Переслано из» — от источника', () {
      // Как queuedMessage в ChatsRemoteDataSource: пост канала — без автора, мой.
      final source = List<int>.filled(12, 4);
      final queued = pb.ChatMessage(
        chatID: channelChat,
        postOut: true,
        date: Int64(1000),
        content: pb.MessageContent(
          text: 'новость',
          forward: pb.MessageForward(fromChatID: source, fromMessageID: Int64(12), fromName: 'Другой канал', fromSignature: 'Анна'),
        ),
      );
      final message = messageFromPb(queued, chatID: idHex(channelChat), myUserID: me, readOutboxMaxID: 0, isSelf: false, channel: true);
      expect(message.outgoing, isTrue);
      expect(message.senderName, isEmpty);
      expect(message.authorSignature, isEmpty);
      expect((message.forward?.chatID, message.forward?.messageID, message.forward?.signature), (idHex(source), '12', 'Анна'));
      // Из личного — «Переслано от» человека.
      final fromUser = messageFromPb(
        queued.deepCopy()..content.forward = pb.MessageForward(fromUserID: anna, fromName: 'Анна'),
        chatID: idHex(channelChat),
        myUserID: me,
        readOutboxMaxID: 0,
        isSelf: false,
        channel: true,
      );
      expect((fromUser.senderName, fromUser.forward?.userID), ('', idHex(anna)));
    });
  });

  test('«Ответы» — только во «Всех чатах»', () {
    const replies = models.Chat(id: models.repliesChatID, type: models.ChatType.private, title: 'Ответы', unreadCount: 1);
    const all = models.ChatFolder(id: '0', title: '', isAll: true);
    const personal = models.ChatFolder(id: '1', title: 'Личные', includeContacts: true, includeNonContacts: true);
    expect(replies.isReplies, isTrue);
    expect(all.matches(replies), isTrue);
    expect(personal.matches(replies), isFalse);
  });

  group('кэш и ChatsSync', () {
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;
    late _FakeApi api;
    late _FakeRepositories repositories;
    late _FakeUtils utils;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('chats_replies');
      db = SqliteDatabase(path: '${dir.path}/test.db');
      await _createSchema(db);
      store = ChatsRepository(logger: Logger(), db: db);
      await getIt.reset();
      getIt.registerSingleton<Logger>(Logger());
      getIt.registerSingleton<Repositories>(repositories = _FakeRepositories(store, db));
      getIt.registerSingleton<Auth>(_FakeAuth(models.Session(userID: me)));
      getIt.registerSingleton<API>(api = _FakeApi());
      getIt.registerSingleton<Utils>(utils = _FakeUtils());
      ChatsReplies.names = (ids) async => {for (final id in ids) idHex(id): 'Анна'};
      ChatsReplies.cachedFile = (_) async => '';
      ChatsSync.instance.setChannels(true, initial: true);
      await store.setPts(userID: me, pts: 10);
    });

    tearDown(() async {
      ChatsSync.instance.setChannels(false, initial: true);
      await getIt.reset();
      await db.close();
      await dir.delete(recursive: true);
    });

    pb.ThreadReply reply(int replyID, int messageID, {bool mention = false, String text = 'ответ', bool read = false}) => pb.ThreadReply(
      replyID: Int64(replyID),
      read: read,
      channelID: channelChat,
      postID: Int64(5),
      mention: mention,
      message: pb.ChatMessage(
        chatID: threadChat,
        messageID: Int64(messageID),
        fromUserID: anna,
        date: Int64(100000 + messageID),
        content: pb.MessageContent(text: text),
      ),
    );

    pb.Update update(int pts, pb.Update_RepliesChanged changed) => pb.Update(pts: Int64(pts), replies: changed);

    Future<void> apply(List<pb.Update> updates) => ChatsSync.instance.applyUpdates(pb.Updates(updates: updates));

    test('Update.replies: новый ответ, прочтение, удаление', () async {
      await apply([
        update(11, pb.Update_RepliesChanged(reply: reply(1, 3), unreadCount: 1)),
        update(12, pb.Update_RepliesChanged(reply: reply(2, 4, mention: true), unreadCount: 2)),
      ]);
      var cached = await store.replies(userID: me);
      expect([for (final r in cached) r.replyID.toInt()], [2, 1]);
      expect(cached.first.mention, isTrue);
      expect(cached.first.message.messageID.toInt(), 4);
      var state = await store.repliesState(userID: me);
      expect((state?.unreadCount, state?.readMaxID), (2, 0));
      // Обновления журнала пришли раньше первой страницы — она всё равно нужна.
      expect(state?.loaded, isFalse);
      expect(await store.getPts(userID: me), 12);

      // Прочитали (другое устройство / ReadReplies).
      await apply([update(13, pb.Update_RepliesChanged(readMaxID: Int64(1), unreadCount: 1))]);
      state = await store.repliesState(userID: me);
      expect((state?.unreadCount, state?.readMaxID), (1, 1));
      // readMaxID назад не идёт.
      await apply([update(14, pb.Update_RepliesChanged(readMaxID: Int64(0), unreadCount: 1))]);
      expect((await store.repliesState(userID: me))?.readMaxID, 1);

      // Комментарий удалили в ветке — пропал из «Ответов».
      await apply([
        update(15, pb.Update_RepliesChanged(deletedIDs: [Int64(2)], unreadCount: 0)),
      ]);
      cached = await store.replies(userID: me);
      expect([for (final r in cached) r.replyID.toInt()], [1]);
      expect((await store.repliesState(userID: me))?.unreadCount, 0);

      // Повтор по pts — пропуск.
      await apply([update(15, pb.Update_RepliesChanged(reply: reply(9, 9), unreadCount: 5))]);
      expect(await store.replies(userID: me), hasLength(1));
    });

    test('правка комментария в ветке — и в «Ответах»', () async {
      await store.saveThread(
        userID: me,
        info: pb.ChatInfo(
          chatID: threadChat,
          type: pb.ChatType.CHAT_TYPE_THREAD,
          parentChatID: channelChat,
          postID: Int64(5),
          pts: Int64(1),
        ),
        readInboxMaxID: 0,
      );
      await store.upsertReply(userID: me, reply: reply(1, 3));
      final edited = reply(1, 3, text: 'исправленный').message..editDate = Int64(5);
      await apply([
        pb.Update(
          chatPts: Int64(2),
          chatID: threadChat,
          editMessage: pb.Update_EditMessage(message: edited),
        ),
      ]);
      expect((await store.replies(userID: me)).single.message.content.text, 'исправленный');
    });

    test('вживую — событие для баннера только о непрочитанном', () async {
      final events = <int>[];
      final sub = ChatsSync.instance.repliesIncoming.listen((r) => events.add(r.replyID.toInt()));
      await store.setRepliesState(userID: me, readMaxID: 1, loaded: true);
      await ChatsSync.instance.applyLive(
        pb.Updates(
          updates: [
            update(11, pb.Update_RepliesChanged(reply: reply(1, 3), unreadCount: 0)),
            update(12, pb.Update_RepliesChanged(reply: reply(2, 4), unreadCount: 1)),
          ],
        ),
      );
      // Догон / ответ на запрос — без баннера.
      await apply([update(13, pb.Update_RepliesChanged(reply: reply(3, 5), unreadCount: 2))]);
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(events, [2]);
    });

    test('строка «Ответы» появляется с первым ответом и пропадает без них', () async {
      final replies = ChatsReplies.instance;
      expect(await replies.loadChat(), isNull);

      await apply([
        update(11, pb.Update_RepliesChanged(reply: reply(1, 3, text: 'первый'), unreadCount: 1)),
        update(12, pb.Update_RepliesChanged(reply: reply(2, 4, text: 'второй'), unreadCount: 2)),
      ]);
      var chat = await replies.loadChat();
      expect(chat, isNotNull);
      expect((chat!.id, chat.isReplies, chat.title, chat.unreadCount), (models.repliesChatID, true, 'Ответы', 2));
      // Последний ответ — «Имя: текст».
      expect((chat.lastMessage?.text, chat.lastMessage?.senderName), ('второй', 'Анна'));
      expect(chat.sortDate, DateTime.fromMillisecondsSinceEpoch(100004));
      expect(chat.hiddenInList, isFalse);

      // Без флага «Каналы» — нет.
      ChatsSync.instance.setChannels(false, initial: true);
      expect(await replies.loadChat(), isNull);
      ChatsSync.instance.setChannels(true, initial: true);

      // Прочитали — строка остаётся, без цифры.
      await apply([update(13, pb.Update_RepliesChanged(readMaxID: Int64(2), unreadCount: 0))]);
      chat = await replies.loadChat();
      expect((chat?.unreadCount, chat?.hasUnread), (0, false));

      // Все удалены — строки нет.
      await apply([
        update(14, pb.Update_RepliesChanged(deletedIDs: [Int64(1), Int64(2)], unreadCount: 0)),
      ]);
      expect(await replies.loadChat(), isNull);
    });

    test('страницы Messages.Replies: первая, старше, прочтение; без сети — уйдёт позже', () async {
      final channelInfo = pb.ChatInfo(chatID: channelChat, type: pb.ChatType.CHAT_TYPE_CHANNEL, title: 'Новости');
      api.respond = (request) {
        if (request.hasReplies()) {
          final offset = request.replies.offsetID.toInt();
          return pb.Messages_Response(
            replies: offset == 0
                ? pb.Messages_RepliesResult(
                    replies: [reply(3, 5), reply(2, 4)],
                    chats: [channelInfo],
                    nextOffsetID: Int64(2),
                    unreadCount: 2,
                    readMaxID: Int64(1),
                  )
                : pb.Messages_RepliesResult(replies: [reply(1, 3)], unreadCount: 2, readMaxID: Int64(1)),
          );
        }
        if (request.hasReadReplies()) {
          final maxID = request.readReplies.maxID;
          return pb.Messages_Response(
            readReplies: pb.Messages_ReadRepliesResult(
              updates: pb.Updates(updates: [update(11, pb.Update_RepliesChanged(readMaxID: maxID, unreadCount: 0))]),
            ),
          );
        }
        throw StateError('unexpected $request');
      };
      await ChatsSync.instance.refreshReplies();
      var state = await store.repliesState(userID: me);
      expect((state?.loaded, state?.unreadCount, state?.readMaxID, state?.nextOffsetID), (true, 2, 1, 2));
      expect((await store.repliesChats(userID: me))[idHex(channelChat)]?.title, 'Новости');
      expect(await ChatsSync.instance.loadOlderReplies(), isFalse);
      expect([for (final r in await store.replies(userID: me)) r.replyID.toInt()], [3, 2, 1]);
      expect((await store.repliesState(userID: me))?.nextOffsetID, 0);
      expect(await ChatsSync.instance.loadOlderReplies(), isFalse, reason: 'дальше нет — без запроса');

      // Без сети прочтение ждёт подключения, счётчик честно остаётся.
      utils.online = false;
      await ChatsSync.instance.readReplies(3);
      expect((await store.repliesState(userID: me))?.unreadCount, 2);
      expect(api.requests.where((r) => r.hasReadReplies()), isEmpty);
      utils.online = true;
      await ChatsSync.instance.flushRepliesRead();
      state = await store.repliesState(userID: me);
      expect((state?.readMaxID, state?.unreadCount), (3, 0));
      expect(api.requests.where((r) => r.hasReadReplies()).single.readReplies.maxID.toInt(), 3);
      // Уже прочитано — повторно не шлём.
      await ChatsSync.instance.readReplies(2);
      expect(api.requests.where((r) => r.hasReadReplies()), hasLength(1));
      // «Прочитать все» без сети — честное «нет сети».
      utils.online = false;
      await expectLater(ChatsSync.instance.readAllReplies(), throwsA(isA<ChatsOfflineException>()));
    });

    test('readIDs (прочтение ветки) отмечает read и снимает непрочитанное; readMaxID не меняется', () async {
      await store.setRepliesState(userID: me, readMaxID: 1, unreadCount: 2, loaded: true);
      await apply([
        update(11, pb.Update_RepliesChanged(reply: reply(2, 4), unreadCount: 2)),
        update(12, pb.Update_RepliesChanged(reply: reply(3, 5), unreadCount: 3)),
      ]);
      var items = await ChatsReplies.instance.loadReplies();
      expect([for (final r in items) r.unread], [true, true]);
      await apply([
        update(13, pb.Update_RepliesChanged(readIDs: [Int64(2)], unreadCount: 1)),
      ]);
      final state = await store.repliesState(userID: me);
      expect((state?.readMaxID, state?.unreadCount), (1, 1), reason: 'число — с сервера как есть');
      expect((await store.replies(userID: me)).last.read, isTrue);
      items = await ChatsReplies.instance.loadReplies();
      expect([for (final r in items) (r.replyID, r.unread)], [(2, false), (3, true)]);
      expect(await store.countRepliesAfter(userID: me, afterID: 1), 1);
    });

    test('read со страницы: и выше, и ниже readMaxID — прочитано; без read выше — нет', () async {
      await store.upsertReply(userID: me, reply: reply(1, 3, read: true)); // ниже readMaxID
      await store.upsertReply(userID: me, reply: reply(5, 7, read: true)); // выше, прочитан веткой
      await store.upsertReply(userID: me, reply: reply(6, 8)); // выше — непрочитан
      await store.upsertReply(userID: me, reply: reply(2, 4)); // ниже — прочитан readMaxID
      await store.setRepliesState(userID: me, readMaxID: 3, unreadCount: 1, loaded: true);
      final items = await ChatsReplies.instance.loadReplies();
      expect([for (final r in items) (r.replyID, r.unread)], [(1, false), (2, false), (5, false), (6, true)]);
      // Новый ответ, уже прочитанный веткой, — без баннера.
      final events = <int>[];
      final sub = ChatsSync.instance.repliesIncoming.listen((r) => events.add(r.replyID.toInt()));
      await ChatsSync.instance.applyLive(
        pb.Updates(updates: [update(11, pb.Update_RepliesChanged(reply: reply(7, 9, read: true), unreadCount: 1))]),
      );
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(events, isEmpty);
    });

    test('скрытый автор в ленте и в строке: без имени, аватара, текста и медиа', () async {
      repositories.hidden[idHex(anna)] = 'hash';
      final photo = reply(1, 3, text: 'секрет')
        ..message.content.media.add(pb.MessageMedia(kind: pb.MessageKind.MESSAGE_KIND_PHOTO, thumbhash: 'abc'));
      await store.upsertReply(userID: me, reply: photo);
      await store.setRepliesState(userID: me, unreadCount: 1, loaded: true);
      final item = (await ChatsReplies.instance.loadReplies()).single;
      expect((item.hidden, item.authorID, item.authorName, item.text, item.thumbhash), (true, '', '', 'Новое сообщение', ''));
      expect(item.kind, models.MessageKind.text);
      final chat = await ChatsReplies.instance.loadChat();
      expect((chat?.lastMessage?.senderName, chat?.lastMessage?.text), ('', 'Новое сообщение'));
      // Показали профиль — всё на месте.
      repositories.hidden.clear();
      final shown = (await ChatsReplies.instance.loadReplies()).single;
      expect((shown.hidden, shown.authorName, shown.text), (false, 'Анна', 'секрет'));
    });

    test('лента: от старых к новым, подпись канала, начало поста, непрочитанное', () async {
      await store.saveRepliesChats(
        userID: me,
        chats: [pb.ChatInfo(chatID: channelChat, type: pb.ChatType.CHAT_TYPE_CHANNEL, title: 'Новости')],
      );
      await store.upsertMessage(
        userID: me,
        message: pb.ChatMessage(
          chatID: channelChat,
          messageID: Int64(5),
          date: Int64(1),
          content: pb.MessageContent(text: 'Пост дня'),
        ),
      );
      await store.upsertReply(userID: me, reply: reply(1, 3));
      await store.upsertReply(userID: me, reply: reply(2, 4, mention: true));
      await store.setRepliesState(userID: me, readMaxID: 1, unreadCount: 1, loaded: true);
      final items = await ChatsReplies.instance.loadReplies();
      expect([for (final r in items) r.replyID], [1, 2]);
      expect([for (final r in items) r.unread], [false, true]);
      final last = items.last;
      expect((last.channelTitle, last.postText, last.authorName, last.mention), ('Новости', 'Пост дня', 'Анна', true));
      expect(last.route, '/chats/comments/${idHex(channelChat)}/5?message=4');
    });
  });
}

class _FakeRepositories implements Repositories {
  @override
  final ChatsRepository chats;

  @override
  final SqliteDatabase db;

  final hidden = <String, String>{};

  @override
  late final HiddenProfiles hiddenProfiles = _FakeHiddenProfiles(hidden);

  _FakeRepositories(this.chats, this.db);

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

class _FakeApi implements API {
  pb.Messages_Response Function(pb.Messages_Request request)? respond;
  final requests = <pb.Messages_Request>[];

  @override
  Future<(APICallStatus, Uint8List?)> unaryEncodedWithResponse(MessageType type, Uint8List payload) async {
    final request = pb.Messages_Request.fromBuffer(payload);
    requests.add(request);
    return (const APICallStatus(status: APIStatus.success, statusCode: 0), respond!(request).writeToBuffer());
  }

  @override
  Stream<Uint8List> on(MessageType type) => const Stream.empty();

  @override
  ApiConnectionStatus get connectionStatus => ApiConnectionStatus.connecting;

  @override
  Future<void> resubscribe() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUtils implements Utils {
  bool online = true;

  @override
  Future<bool> hasNetwork() async => online;

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

/// Таблицы, которых касаются тесты (как в миграциях, до 47).
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
  await db.execute(ChatsRepository.repliesSchema);
  await db.execute(ChatsRepository.repliesStateSchema);
  await db.execute(ChatsRepository.repliesChatsSchema);
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
  await db.execute('CREATE TABLE chatUpdatesState (userID BLOB PRIMARY KEY, pts INTEGER NOT NULL, date INTEGER NOT NULL DEFAULT 0);');
  await db.execute('''
    CREATE TABLE chatGroups (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, info BLOB NOT NULL, role INTEGER NOT NULL DEFAULT 0, pts INTEGER NOT NULL DEFAULT 0,
      rights BLOB, rank TEXT NOT NULL DEFAULT '', inviteCode TEXT NOT NULL DEFAULT '', pendingRequests INTEGER NOT NULL DEFAULT 0,
      slowModeUntil INTEGER NOT NULL DEFAULT 0, joinedAt INTEGER NOT NULL DEFAULT 0, browsedAt INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (userID, chatID)
    );
  ''');
}
