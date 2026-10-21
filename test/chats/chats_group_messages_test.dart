import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart' show StatusCode;
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/chats/newcomer.dart';
import 'package:messenger/chats/reactions.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;
import 'package:messenger/protobuf/protos/v1.pb.dart' show MessageType;
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// Сообщения в группе (подэтап 3.4): общие таблицы с сервером
// (all_chat_reactions.json, newcomer_link_cases.json — байт-в-байт в
// iperon/internal/services/testdata/), маппинг реакций группы (счётчики +
// кто изменил), опросов (скрытый верный ответ, свой выбор), медленный режим,
// кэш упоминаний / итогов опроса (миграция 38) и ветки ChatsSync.
void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);
  final groupChat = List<int>.filled(12, 9);

  group('общие таблицы', () {
    test('«Все реакции» группы — как на сервере', () {
      final shared = (jsonDecode(File('test/chats/fixtures/all_chat_reactions.json').readAsStringSync()) as List).cast<String>();
      expect(allChatReactions, shared);
    });

    test('«новички»: текст без ссылок — как на сервере', () {
      final cases = (jsonDecode(File('test/chats/fixtures/newcomer_link_cases.json').readAsStringSync()) as List)
          .cast<Map<String, dynamic>>();
      expect(cases, isNotEmpty);
      models.MessageEntityType type(String name) => switch (name) {
        'TEXT_URL' => models.MessageEntityType.textUrl,
        'URL' => models.MessageEntityType.url,
        _ => throw ArgumentError('неизвестный тип $name'),
      };
      for (final c in cases) {
        final entities = [
          for (final e in (c['entities'] as List? ?? const []).cast<Map<String, dynamic>>())
            models.MessageEntity(
              type: type(e['type'] as String),
              offset: e['offset'] as int,
              length: e['length'] as int,
              url: e['url'] as String? ?? '',
            ),
        ];
        expect(isLinkFree(c['text'] as String, entities), c['linkFree'], reason: c['text'] as String);
      }
    });
  });

  group('реакции группы', () {
    pb.ReactionCount count(String emoji, int n, [int order = 0]) => pb.ReactionCount(emoji: emoji, count: n, chosenOrder: order);

    test('счётчики → чипы: наши — по chosenOrder', () {
      final chips = reactionsFromPb(
        pb.MessageReactions(counts: [count('👍', 5), count('❤️', 3, 2), count('🔥', 1, 1), count('😮', 0)]),
        myUserID: me,
      );
      expect([for (final c in chips) (c.emoji, c.count, c.chosen)], [('👍', 5, false), ('❤️', 3, true), ('🔥', 1, true)]);
      final message = models.Message(id: '1', chatID: 'c', reactions: chips, date: DateTime(2026));
      expect(message.myReactions, ['🔥', '❤️']);
    });

    test('общее обновление: чужое — мои остаются, моё — мой набор из actorEmojis', () {
      final stored = pb.MessageReactions(counts: [count('👍', 2, 1), count('❤️', 1)]);
      // Пётр поставил ❤️ — мой 👍 остаётся моим.
      var merged = mergeSharedReactions(
        stored,
        pb.MessageReactions(counts: [count('👍', 2), count('❤️', 2)]),
        actorUserID: peer,
        actorEmojis: ['❤️'],
        myUserID: me,
      );
      expect([for (final c in merged.counts) (c.emoji, c.count, c.chosenOrder)], [('👍', 2, 1), ('❤️', 2, 0)]);
      // Я (с другого устройства) сменил набор на ❤️, 🔥.
      merged = mergeSharedReactions(
        merged,
        pb.MessageReactions(counts: [count('👍', 1), count('❤️', 3), count('🔥', 1)]),
        actorUserID: me,
        actorEmojis: ['❤️', '🔥'],
        myUserID: me,
      );
      expect([for (final c in merged.counts) (c.emoji, c.chosenOrder)], [('👍', 0), ('❤️', 1), ('🔥', 2)]);
      // Глазами меня (History / ответ SetReactions) — как есть.
      final personal = pb.MessageReactions(counts: [count('👍', 1, 1)]);
      expect(mergeSharedReactions(merged, personal, actorUserID: peer, myUserID: me), personal);
      // Все сняли — пусто.
      expect(mergeSharedReactions(merged, pb.MessageReactions(), actorUserID: me, myUserID: me).counts, isEmpty);
    });
  });

  group('опросы', () {
    final quiz = pb.MessagePoll(question: 'Столица?', options: ['Москва', 'Тверь'], quiz: true, correctOption: -1);

    test('верный ответ скрыт до голоса, после — виден', () {
      // Не голосовал: сервер верного не прислал (-1) — ни одного верного.
      var poll = pollFromPb(quiz, pb.PollResults(votes: [3, 1], totalVoters: 4, correctOption: -1));
      expect(poll.options.any((o) => o.correct), isFalse);
      expect(poll.explanation, '');
      expect(poll.totalVotes, 4);
      expect(poll.showResults, isFalse);
      // Итогов ещё нет (proto по умолчанию 0) — тоже ничего не раскрываем.
      expect(pollFromPb(quiz, null).options.any((o) => o.correct), isFalse);
      // Проголосовал — верный и пояснение.
      poll = pollFromPb(quiz, pb.PollResults(votes: [4, 1], chosen: [0], totalVoters: 5, correctOption: 0, explanation: 'Да'));
      expect([for (final o in poll.options) (o.chosen, o.correct)], [(true, true), (false, false)]);
      expect(poll.explanation, 'Да');
      // Завершён — видно всем.
      poll = pollFromPb(quiz, pb.PollResults(votes: [4, 1], closed: true, correctOption: 0));
      expect(poll.options.first.correct, isTrue);
      expect(poll.closed, isTrue);
    });

    test('к отправке: викторина — с верным, без мультивыбора', () {
      final out = pollToPb(
        const models.MessagePoll(
          question: ' Вопрос ',
          options: [
            models.PollOption(text: 'a'),
            models.PollOption(text: 'b', correct: true),
          ],
          multiple: true,
          quiz: true,
          explanation: 'потому что',
        ),
      );
      expect(out.options, ['a', 'b']);
      expect((out.question, out.quiz, out.multiple, out.correctOption, out.explanation), ('Вопрос', true, false, 1, 'потому что'));
      final message = messageFromPb(
        pb.ChatMessage(
          chatID: groupChat,
          messageID: Int64(1),
          fromUserID: peer,
          date: Int64(1),
          content: pb.MessageContent(poll: out),
        ),
        chatID: 'g',
        myUserID: me,
        readOutboxMaxID: 0,
        isSelf: false,
        nameOf: (_) => 'Пётр',
      );
      expect(message.kind, models.MessageKind.poll);
      expect(message.text, 'Вопрос');
      expect(message.poll?.options.length, 2);
    });

    test('общее обновление: мой выбор — только если голосовал я; открытый ответ не пропадает', () {
      final stored = pb.PollResults(votes: [1, 0], chosen: [0], totalVoters: 1, correctOption: 0, explanation: 'x');
      // Проголосовал другой: счётчики новые, мой выбор и ответ — прежние.
      var merged = mergePollResults(stored, pb.PollResults(votes: [1, 1], totalVoters: 2, correctOption: -1), shared: true);
      expect(merged.votes, [1, 1]);
      expect(merged.chosen, [0]);
      expect((merged.totalVoters, merged.correctOption), (2, 0));
      // Я переголосовал (actor = я).
      merged = mergePollResults(
        merged,
        pb.PollResults(votes: [0, 2], totalVoters: 2, correctOption: -1),
        shared: true,
        actorIsMe: true,
        actorOptions: [1],
      );
      expect(merged.chosen, [1]);
      // Журнал пользователя — глазами меня целиком (отменил голос).
      merged = mergePollResults(merged, pb.PollResults(votes: [0, 1], totalVoters: 1, correctOption: -1), shared: false);
      expect(merged.chosen, isEmpty);
      expect(merged.correctOption, -1);
    });
  });

  test('медленный режим и лимит частоты — разные отказы', () {
    expect(ChatsSlowModeException.parse(StatusCode.resourceExhausted, 'slowModeWait:25')?.seconds, 25);
    expect(ChatsSlowModeException.parse(StatusCode.resourceExhausted, 'floodWait:25'), isNull);
    expect(ChatsFloodException.parse(StatusCode.resourceExhausted, 'slowModeWait:25'), isNull);
    expect(ChatsSlowModeException.parse(StatusCode.permissionDenied, 'slowModeWait:25'), isNull);
    expect(ChatsSlowModeException.parse(StatusCode.resourceExhausted, 'slowModeWait:0')?.seconds, 1);
  });

  group('кэш и ChatsSync', () {
    late Directory dir;
    late SqliteDatabase db;
    late ChatsRepository store;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('chats_group_messages');
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

    pb.Dialog groupDialog({int mentions = 0, int slowModeUntil = 0, int joinedAt = 0, int pts = 1}) => pb.Dialog(
      chatID: groupChat,
      type: pb.ChatType.CHAT_TYPE_GROUP,
      role: pb.ChatRole.CHAT_ROLE_WRITER,
      unreadMentionsCount: mentions,
      slowModeUntil: Int64(slowModeUntil),
      joinedAt: Int64(joinedAt),
      chat: pb.ChatInfo(
        chatID: groupChat,
        type: pb.ChatType.CHAT_TYPE_GROUP,
        title: 'Дача',
        slowMode: 30,
        newcomerMediaDelay: 3600,
        membersHidden: true,
        reactionsMode: pb.ChatReactionsMode.CHAT_REACTIONS_SOME,
        reactions: ['👍', '🔥'],
        pts: Int64(pts),
      ),
    );

    pb.ChatMessage message(int id, {List<int>? from, pb.MessageContent? content, bool mention = false}) => pb.ChatMessage(
      chatID: groupChat,
      messageID: Int64(id),
      fromUserID: from ?? peer,
      date: Int64(id * 1000),
      content: content ?? pb.MessageContent(text: 'm$id'),
      mentionUnread: mention,
    );

    Future<void> apply(List<pb.Update> updates) => ChatsSync.instance.applyUpdates(pb.Updates(updates: updates));

    test('диалог: упоминания, медленный режим, дата вступления; настройки группы', () async {
      await store.upsertDialog(userID: me, dialog: groupDialog(mentions: 2, slowModeUntil: 5000, joinedAt: 7000));
      final row = await store.dialog(userID: me, chatID: groupChat);
      expect(row?.unreadMentions, 2);
      var group = await store.group(userID: me, chatID: groupChat);
      expect((group?.slowModeUntil, group?.joinedAt), (5000, 7000));
      expect(reactionsModeFromPb(group!.info.reactionsMode), models.ChatReactionsMode.some);
      expect((group.info.slowMode, group.info.newcomerMediaDelay, group.info.membersHidden), (30, 3600, true));
      // Снимок без даты вступления её не стирает; медленный режим — как пришёл.
      await store.upsertDialog(userID: me, dialog: groupDialog());
      group = await store.group(userID: me, chatID: groupChat);
      expect((group?.slowModeUntil, group?.joinedAt), (0, 7000));
      await store.setGroupSlowModeUntil(userID: me, chatID: groupChat, until: 9000);
      expect((await store.group(userID: me, chatID: groupChat))?.slowModeUntil, 9000);
      for (final mode in models.ChatReactionsMode.values) {
        expect(reactionsModeFromPb(reactionsModeToPb(mode)), mode);
      }
    });

    test('«Запретить копирование»: из диалога в кэш, chatInfo журнала чата включает и выключает', () async {
      await store.upsertDialog(userID: me, dialog: groupDialog(pts: 3)..chat.noForwards = true);
      expect((await store.group(userID: me, chatID: groupChat))?.info.noForwards, isTrue);
      await store.setPts(userID: me, pts: 10);
      pb.ChatInfo info(bool noForwards) => (groupDialog(pts: 4).chat.deepCopy()..noForwards = noForwards);
      await apply([
        pb.Update(
          chatPts: Int64(4),
          chatID: groupChat,
          chatInfo: pb.Update_ChatInfoChanged(chat: info(false)),
        ),
      ]);
      expect((await store.group(userID: me, chatID: groupChat))?.info.noForwards, isFalse);
      await apply([
        pb.Update(
          chatPts: Int64(5),
          chatID: groupChat,
          chatInfo: pb.Update_ChatInfoChanged(chat: info(true)),
        ),
      ]);
      final group = await store.group(userID: me, chatID: groupChat);
      expect(group?.info.noForwards, isTrue);
      expect(group?.pts, 5);
    });

    test('баннер в приложении: вживую — новые входящие и упоминания; ответ на запрос и свои — нет', () async {
      // Входящее снимает «печатает…» (ChatsTyping слушает стрим).
      getIt.registerSingleton<API>(_FakeApi());
      await store.upsertDialog(userID: me, dialog: groupDialog());
      await store.setPts(userID: me, pts: 10);
      final events = <ChatsIncoming>[];
      final subscription = ChatsSync.instance.incoming.listen(events.add);
      addTearDown(subscription.cancel);
      pb.Update newMessage(int chatPts, pb.ChatMessage message) => pb.Update(
        chatPts: Int64(chatPts),
        chatID: groupChat,
        newMessage: pb.Update_NewMessage(message: message),
      );
      pb.Update mention(int pts, int messageID) => pb.Update(
        pts: Int64(pts),
        mentions: pb.Update_MentionsChanged(chatID: groupChat, messageIDs: [Int64(messageID)], unread: true, unreadMentionsCount: 1),
      );

      // Ответ на запрос (не стрим) — без баннера.
      await apply([newMessage(2, message(1))]);
      // Своё с другого устройства — без баннера; чужое с упоминанием в той же пачке — с ним.
      await ChatsSync.instance.applyLive(
        pb.Updates(
          updates: [
            newMessage(3, message(2, from: me)),
            newMessage(4, message(3)),
            mention(11, 3),
          ],
        ),
      );
      // Упоминание отдельной пачкой — повтор с mentioned (пробивает «Без звука»).
      await ChatsSync.instance.applyLive(pb.Updates(updates: [newMessage(5, message(4))]));
      await ChatsSync.instance.applyLive(pb.Updates(updates: [mention(12, 4)]));
      // Служебное — не сообщение.
      await ChatsSync.instance.applyLive(
        pb.Updates(
          updates: [
            newMessage(
              6,
              message(
                5,
                content: pb.MessageContent(chatAction: pb.MessageChatAction(userIDs: [me])),
              ),
            ),
          ],
        ),
      );
      await Future<void>.delayed(Duration.zero);

      final hex = idHex(groupChat);
      expect([for (final e in events) (e.chatID, e.messageID, e.mentioned)], [(hex, 3, true), (hex, 4, false), (hex, 4, true)]);
      expect([for (final e in events) e.fromUserID], [idHex(peer), idHex(peer), '']);
    });

    test('упоминания: из истории, Update.mentions, сверка страницей, удаление', () async {
      await store.upsertDialog(userID: me, dialog: groupDialog());
      await store.setPts(userID: me, pts: 10);
      // Из истории глазами меня.
      await store.upsertMessage(userID: me, message: message(1, mention: true));
      // Общий журнал чата: mentionUnread всегда false — упоминание не снимает.
      await store.upsertMessage(userID: me, message: message(1), shared: true);
      expect(await store.unreadMentionIDs(userID: me, chatID: groupChat), [1]);

      // Update.mentions может прийти раньше самого сообщения.
      await apply([
        pb.Update(
          pts: Int64(11),
          mentions: pb.Update_MentionsChanged(chatID: groupChat, messageIDs: [Int64(5)], unread: true, unreadMentionsCount: 2),
        ),
      ]);
      expect(await store.unreadMentionIDs(userID: me, chatID: groupChat), [1, 5]);
      expect((await store.dialog(userID: me, chatID: groupChat))?.unreadMentions, 2);

      // Прочитали на другом устройстве.
      await apply([
        pb.Update(
          pts: Int64(12),
          mentions: pb.Update_MentionsChanged(chatID: groupChat, messageIDs: [Int64(1)], unreadMentionsCount: 1),
        ),
      ]);
      expect(await store.unreadMentionIDs(userID: me, chatID: groupChat), [5]);
      expect((await store.dialog(userID: me, chatID: groupChat))?.unreadMentions, 1);

      // Свежая страница истории: в ней 5 уже без упоминания — снимаем.
      await store.applyHistoryPage(userID: me, chatID: groupChat, messages: [message(5), message(1)], offsetID: 0, hasMore: false);
      expect(await store.unreadMentionIDs(userID: me, chatID: groupChat), isEmpty);

      // Удалили сообщение — упоминания нет.
      await store.addMentions(userID: me, chatID: groupChat, messageIDs: [1]);
      await store.deleteMessages(userID: me, chatID: groupChat, messageIDs: [1]);
      expect(await store.unreadMentionIDs(userID: me, chatID: groupChat), isEmpty);

      // ReadMentions всех (пустой список) — снять все.
      await store.addMentions(userID: me, chatID: groupChat, messageIDs: [5, 6]);
      await apply([
        pb.Update(
          pts: Int64(13),
          mentions: pb.Update_MentionsChanged(chatID: groupChat),
        ),
      ]);
      expect(await store.unreadMentionIDs(userID: me, chatID: groupChat), isEmpty);
      expect((await store.dialog(userID: me, chatID: groupChat))?.unreadMentions, 0);
    });

    test('реакции группы: журнал чата — мои сохраняются, счётчик ❤️ не трогается; автору — журнал пользователя', () async {
      await store.upsertDialog(userID: me, dialog: groupDialog(pts: 3));
      await store.setPts(userID: me, pts: 10);
      await store.updateDialog(userID: me, chatID: groupChat, fields: {'unreadReactions': 4});
      // Моё сообщение, я поставил 👍 (глазами меня).
      await store.upsertMessage(
        userID: me,
        message: message(1, from: me)..reactions = pb.MessageReactions(counts: [pb.ReactionCount(emoji: '👍', count: 1, chosenOrder: 1)]),
      );
      // Журнал чата: Пётр поставил 🔥.
      await apply([
        pb.Update(
          chatPts: Int64(4),
          chatID: groupChat,
          messageReactions: pb.Update_MessageReactionsChanged(
            chatID: groupChat,
            messageID: Int64(1),
            reactions: pb.MessageReactions(
              counts: [
                pb.ReactionCount(emoji: '👍', count: 1),
                pb.ReactionCount(emoji: '🔥', count: 1),
              ],
            ),
            actorUserID: peer,
            actorEmojis: ['🔥'],
          ),
        ),
      ]);
      var stored = await store.messageReactions(userID: me, chatID: groupChat, messageID: 1);
      expect([for (final c in stored!.counts) (c.emoji, c.chosenOrder)], [('👍', 1), ('🔥', 0)]);
      expect((await store.dialog(userID: me, chatID: groupChat))?.unreadReactions, 4);
      expect((await store.group(userID: me, chatID: groupChat))?.pts, 4);

      // То же автору в журнал пользователя — с непрочитанными.
      await apply([
        pb.Update(
          pts: Int64(11),
          messageReactions: pb.Update_MessageReactionsChanged(
            chatID: groupChat,
            messageID: Int64(1),
            reactions: pb.MessageReactions(
              counts: [
                pb.ReactionCount(emoji: '👍', count: 1),
                pb.ReactionCount(emoji: '🔥', count: 1),
              ],
            ),
            actorUserID: peer,
            actorEmojis: ['🔥'],
            unreadReactionsCount: 5,
            reactionsUnread: true,
          ),
        ),
      ]);
      stored = await store.messageReactions(userID: me, chatID: groupChat, messageID: 1);
      expect([for (final c in stored!.counts) (c.emoji, c.chosenOrder)], [('👍', 1), ('🔥', 0)]);
      expect((await store.dialog(userID: me, chatID: groupChat))?.unreadReactions, 5);
      expect(await store.unreadReactionIDs(userID: me, chatID: groupChat), [1]);
    });

    test('опрос: голос другого, мой голос, журнал пользователя, сообщение из журнала чата', () async {
      await store.upsertDialog(userID: me, dialog: groupDialog(pts: 3));
      await store.setPts(userID: me, pts: 10);
      final content = pb.MessageContent(
        poll: pb.MessagePoll(question: 'Когда?', options: ['пн', 'вт'], correctOption: -1),
      );
      await store.upsertMessage(
        userID: me,
        message: message(1, content: content)..poll = pb.PollResults(votes: [1, 0], chosen: [0], totalVoters: 1, correctOption: -1),
      );
      // Журнал чата: Пётр за «вт» — мой выбор остаётся.
      await apply([
        pb.Update(
          chatPts: Int64(4),
          chatID: groupChat,
          messagePoll: pb.Update_MessagePollChanged(
            chatID: groupChat,
            messageID: Int64(1),
            results: pb.PollResults(votes: [1, 1], totalVoters: 2, correctOption: -1),
            actorUserID: peer,
            actorOptions: [1],
          ),
        ),
      ]);
      var results = await store.pollResults(userID: me, chatID: groupChat, messageID: 1);
      expect(results?.votes, [1, 1]);
      expect(results?.chosen, [0]);
      expect(results?.totalVoters, 2);
      // Журнал чата: я переголосовал с другого устройства.
      await apply([
        pb.Update(
          chatPts: Int64(5),
          chatID: groupChat,
          messagePoll: pb.Update_MessagePollChanged(
            chatID: groupChat,
            messageID: Int64(1),
            results: pb.PollResults(votes: [0, 2], totalVoters: 2, correctOption: -1),
            actorUserID: me,
            actorOptions: [1],
          ),
        ),
      ]);
      results = await store.pollResults(userID: me, chatID: groupChat, messageID: 1);
      expect(results?.chosen, [1]);
      // Журнал пользователя (без actor) — глазами меня целиком: отменил.
      await apply([
        pb.Update(
          pts: Int64(11),
          messagePoll: pb.Update_MessagePollChanged(
            chatID: groupChat,
            messageID: Int64(1),
            results: pb.PollResults(votes: [0, 1], totalVoters: 1, correctOption: -1),
          ),
        ),
      ]);
      results = await store.pollResults(userID: me, chatID: groupChat, messageID: 1);
      expect(results?.chosen, isEmpty);
      expect(results?.totalVoters, 1);
      // Завершение (журнал чата, без actor): итоги и верный — всем, мой
      // выбор не трогаем.
      await store.setPollResults(
        userID: me,
        chatID: groupChat,
        messageID: 1,
        results: pb.PollResults(votes: [0, 1], chosen: [1], totalVoters: 1, correctOption: -1),
      );
      await apply([
        pb.Update(
          chatPts: Int64(6),
          chatID: groupChat,
          messagePoll: pb.Update_MessagePollChanged(
            chatID: groupChat,
            messageID: Int64(1),
            results: pb.PollResults(votes: [0, 1], totalVoters: 1, closed: true, correctOption: -1),
          ),
        ),
      ]);
      results = await store.pollResults(userID: me, chatID: groupChat, messageID: 1);
      expect(results?.closed, isTrue);
      expect(results?.chosen, [1]);
      // Сообщение заново из журнала чата (правка / повтор) — выбор и итоги не
      // теряются; без итогов в сообщении — остаются прежние.
      await store.upsertMessage(
        userID: me,
        message: message(1, content: content)..poll = pb.PollResults(votes: [0, 1], totalVoters: 1, closed: true, correctOption: -1),
        shared: true,
      );
      expect((await store.pollResults(userID: me, chatID: groupChat, messageID: 1))?.chosen, [1]);
      await store.upsertMessage(
        userID: me,
        message: message(1, content: content),
        shared: true,
      );
      final cached = await store.message(userID: me, chatID: groupChat, messageID: 1);
      expect(cached?.hasPoll(), isTrue);
      final poll = messageFromPb(cached!, chatID: 'g', myUserID: me, readOutboxMaxID: 0, isSelf: false, nameOf: (_) => '').poll;
      expect((poll?.closed, poll?.voted, poll?.options[1].chosen), (true, true, true));
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

/// Таблицы чатов, которых касаются тесты (как в миграциях, до 38).
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
