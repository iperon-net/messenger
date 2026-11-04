import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/account_scope.dart';
import 'package:messenger/api.dart';
import 'package:messenger/auth.dart';
import 'package:messenger/chats/chats_data_source.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/chats_remote_data_source.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/cubit/chat/chat_cubit.dart';
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
    api = GatedFakeApi();
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

  test('параллельный flushOutbox отправляет старое и добавленное во время отправки по одному разу', () async {
    utils.network = true;
    final sync = ChatsSync.instance;
    final gated = api as GatedFakeApi;
    await store.addOutbox(
      userID: me,
      randomID: 11,
      chatID: chat,
      content: pb.MessageContent(text: 'first').writeToBuffer(),
      createdAt: 1000,
    );
    for (final (id, randomID, text) in [(1, 11, 'first'), (2, 12, 'second')]) {
      api.enqueueUnaryResponse(
        MessageType.MESSAGES,
        pb.Messages_Response(
          send: pb.Messages_SendResult(
            message: message(id, randomID: randomID, from: me, text: text),
          ),
        ).writeToBuffer(),
      );
    }

    final requestStarted = gated.gateNextMessage();
    final firstFlush = sync.flushOutbox();
    await requestStarted;
    await store.addOutbox(
      userID: me,
      randomID: 12,
      chatID: chat,
      content: pb.MessageContent(text: 'second').writeToBuffer(),
      createdAt: 2000,
    );
    final concurrentFlush = sync.flushOutbox();
    gated.releaseMessage();
    await Future.wait([firstFlush, concurrentFlush]);

    final sent = [
      for (final call in api.unaryCalls.where((call) => call.type == MessageType.MESSAGES))
        pb.Messages_Request.fromBuffer(call.payload).send,
    ];
    expect(sent.map((request) => request.randomID.toInt()), [11, 12]);
    expect(sent.map((request) => request.content.text), ['first', 'second']);
    expect(await store.outbox(userID: me), isEmpty);
    expect(await store.countMessages(userID: me, chatID: chat), 2);
    await Future<void>.delayed(const Duration(milliseconds: 20));
  });

  test('временная ошибка отправки сохраняет outbox и повторяет тот же randomID', () async {
    utils.network = true;
    final sync = ChatsSync.instance;
    await store.addOutbox(
      userID: me,
      randomID: 21,
      chatID: chat,
      content: pb.MessageContent(text: 'retry').writeToBuffer(),
      createdAt: 1000,
    );
    api.enqueueUnaryResult(
      MessageType.MESSAGES,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'unavailable'),
    );

    await sync.flushOutbox();

    expect((await store.outbox(userID: me)).single.failed, isFalse);
    expect(await store.countMessages(userID: me, chatID: chat), 0);

    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        send: pb.Messages_SendResult(
          message: message(1, randomID: 21, from: me, text: 'retry'),
        ),
      ).writeToBuffer(),
    );
    await sync.flushOutbox();

    expect(api.unaryCalls, hasLength(2));
    expect(api.unaryCalls.map((call) => pb.Messages_Request.fromBuffer(call.payload).send.randomID.toInt()), [21, 21]);
    expect(await store.outbox(userID: me), isEmpty);
    expect((await store.message(userID: me, chatID: chat, messageID: 1))?.content.text, 'retry');
  });

  test('сбой GET_DIFFERENCE сохраняет кэш и pts, reconnect повторяет догон', () async {
    utils.network = true;
    await store.setPts(userID: me, pts: 5);
    await store.setFolders(userID: me, folders: pb.ChatFolders());
    await store.setRepliesState(userID: me, loaded: true);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: me, peerUserID: me),
    );
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    await store.upsertMessage(
      userID: me,
      message: message(1, text: 'cached'),
    );
    final sync = ChatsSync.instance..setEnabled(true);
    api.enqueueUnaryResult(
      MessageType.GET_DIFFERENCE,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'unavailable'),
    );

    await sync.onConnected();

    expect(await store.getPts(userID: me), 5);
    expect((await store.message(userID: me, chatID: chat, messageID: 1))?.content.text, 'cached');
    expect(api.unaryCalls.single.type, MessageType.GET_DIFFERENCE);

    api.enqueueUnaryResponse(
      MessageType.GET_DIFFERENCE,
      pb.GetDifference_Response(
        updates: [
          pb.Update(
            pts: Int64(6),
            newMessage: pb.Update_NewMessage(message: message(2, text: 'caught up')),
          ),
        ],
        state: pb.UpdatesState(pts: Int64(6)),
      ).writeToBuffer(),
    );
    await sync.onConnected();

    expect(api.unaryCalls.map((call) => call.type), [MessageType.GET_DIFFERENCE, MessageType.GET_DIFFERENCE]);
    expect(pb.GetDifference_Request.fromBuffer(api.unaryCalls.last.payload).pts.toInt(), 5);
    expect(await store.getPts(userID: me), 6);
    expect((await store.message(userID: me, chatID: chat, messageID: 2))?.content.text, 'caught up');
  });

  test('новый экземпляр синхронизации восстанавливает pts и outbox из той же БД', () async {
    await store.setPts(userID: me, pts: 5);
    await store.setFolders(userID: me, folders: pb.ChatFolders());
    await store.setRepliesState(userID: me, loaded: true);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: me, peerUserID: me),
    );
    await store.addOutbox(
      userID: me,
      randomID: 31,
      chatID: chat,
      content: pb.MessageContent(text: 'after restart').writeToBuffer(),
      createdAt: 1000,
    );
    api.enqueueUnaryResponse(MessageType.GET_DIFFERENCE, pb.GetDifference_Response(state: pb.UpdatesState(pts: Int64(5))).writeToBuffer());
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        send: pb.Messages_SendResult(
          message: message(1, randomID: 31, from: me, text: 'after restart'),
        ),
      ).writeToBuffer(),
    );
    utils.network = true;

    await scope.dispose();
    scope = AccountScope('chats-sync-restarted')..files = (data: dir, cache: dir);
    AccountScope.activate(scope);
    final restarted = ChatsSync.instance..setEnabled(true);
    await restarted.onConnected();

    expect(pb.GetDifference_Request.fromBuffer(api.unaryCalls.first.payload).pts.toInt(), 5);
    expect(pb.Messages_Request.fromBuffer(api.unaryCalls.last.payload).send.randomID.toInt(), 31);
    expect(await store.outbox(userID: me), isEmpty);
    expect((await store.message(userID: me, chatID: chat, messageID: 1))?.content.text, 'after restart');
  });

  test('remote: изменение диалога требует сети и применяет обновление сервера', () async {
    final chatHex = idHex(chat);
    await store.setPts(userID: me, pts: 5);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    final source = ChatsRemoteDataSource.instance;

    await expectLater(source.setPinned(chatHex, true), throwsA(isA<ChatsOfflineException>()));
    expect(api.unaryCalls, isEmpty);
    expect((await store.dialog(userID: me, chatID: chat))?.pinned, isFalse);

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.CHATS,
      pb.Chats_Response(
        setDialog: pb.Chats_SetDialogResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                pts: Int64(6),
                dialogSettings: pb.Update_DialogSettings(
                  dialog: pb.Dialog(chatID: chat, peerUserID: peer, pinned: true),
                ),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await source.setPinned(chatHex, true);

    final request = pb.Chats_Request.fromBuffer(api.unaryCalls.single.payload);
    expect(request.setDialog.chatID, chat);
    expect(request.setDialog.pinned, isTrue);
    expect((await store.dialog(userID: me, chatID: chat))?.pinned, isTrue);
    expect(await store.getPts(userID: me), 6);
  });

  test('remote: прочтение шлёт верхний messageID, offline сохраняет непрочитанные', () async {
    final chatHex = idHex(chat);
    await store.setPts(userID: me, pts: 5);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer, unreadCount: 2, topMessage: message(8)),
    );
    final source = ChatsRemoteDataSource.instance;

    await source.setRead(chatHex, true);
    expect(api.unaryCalls, isEmpty);
    expect((await store.dialog(userID: me, chatID: chat))?.unreadCount, 2);

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.CHATS,
      pb.Chats_Response(
        readHistory: pb.Chats_ReadHistoryResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                pts: Int64(6),
                readInbox: pb.Update_ReadInbox(chatID: chat, maxID: Int64(8), unreadCount: 0),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await source.setRead(chatHex, true);

    final request = pb.Chats_Request.fromBuffer(api.unaryCalls.single.payload);
    expect(request.readHistory.maxID.toInt(), 8);
    expect((await store.dialog(userID: me, chatID: chat))?.unreadCount, 0);
  });

  test('remote: offline сообщение правится и удаляется в outbox без серверных вызовов', () async {
    final chatHex = idHex(chat);
    final source = ChatsRemoteDataSource.instance;

    await source.sendMessage(chatHex, text: 'draft');

    final queued = (await store.outbox(userID: me)).single;
    expect(pb.MessageContent.fromBuffer(queued.content).text, 'draft');
    final localID = localMessageID(queued.randomID);

    await source.editMessage(chatHex, localID, 'edited', const []);
    expect(pb.MessageContent.fromBuffer((await store.outbox(userID: me)).single.content).text, 'edited');

    await source.deleteMessage(chatHex, localID);
    expect(await store.outbox(userID: me), isEmpty);
    expect(api.unaryCalls, isEmpty);
  });

  test('remote: правка и удаление на сервере применяют updates атомарно', () async {
    final chatHex = idHex(chat);
    await store.setPts(userID: me, pts: 5);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer, topMessage: message(1)),
    );
    await store.upsertMessage(userID: me, message: message(1));
    final source = ChatsRemoteDataSource.instance;

    await expectLater(source.editMessage(chatHex, '1', 'offline', const []), throwsA(isA<ChatsOfflineException>()));
    expect((await store.message(userID: me, chatID: chat, messageID: 1))?.content.text, 'message 1');

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        edit: pb.Messages_EditResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                pts: Int64(6),
                editMessage: pb.Update_EditMessage(message: message(1, text: 'edited')),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await source.editMessage(chatHex, '1', 'edited', const []);
    expect(pb.Messages_Request.fromBuffer(api.unaryCalls.single.payload).edit.messageID.toInt(), 1);
    expect((await store.message(userID: me, chatID: chat, messageID: 1))?.content.text, 'edited');

    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        delete: pb.Messages_DeleteResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                pts: Int64(7),
                deleteMessages: pb.Update_DeleteMessages(chatID: chat, messageIDs: [Int64(1)]),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await source.deleteMessage(chatHex, '1');
    expect(await store.message(userID: me, chatID: chat, messageID: 1), isNull);
    expect(await store.getPts(userID: me), 7);
  });

  test('remote: пересылка и реакции ждут сеть, failed сообщение повторяется с тем же randomID', () async {
    final chatHex = idHex(chat);
    await store.upsertMessage(userID: me, message: message(1));
    final source = ChatsRemoteDataSource.instance;
    final original = models.Message(id: '1', chatID: chatHex, text: 'forwarded', date: DateTime(2026));

    await source.forwardMessages(chatHex, [original]);
    await source.setReactions(chatHex, '1', ['👍']);

    final forwarded = (await store.outbox(userID: me)).single;
    expect(forwarded.forwardMessageID, 1);
    expect(pb.MessageContent.fromBuffer(forwarded.content).text, 'message 1');
    expect((await store.pendingReactions(userID: me)).single.emojis, ['👍']);
    expect(api.unaryCalls, isEmpty);

    await store.markOutboxFailed(userID: me, randomID: forwarded.randomID);
    expect((await store.outbox(userID: me)).single.failed, isTrue);
    await source.retrySend(chatHex, localMessageID(forwarded.randomID));
    expect((await store.outbox(userID: me)).single.failed, isFalse);
    await Future<void>.delayed(const Duration(milliseconds: 10));
  });

  test('ChatCubit: offline удаление показывает уведомление и не вызывает API', () async {
    ChatsSync.instance.setEnabled(true);
    final cubit = ChatCubit()..initialization(chatID: idHex(chat), demo: false, markRead: false);
    addTearDown(cubit.close);
    final existing = models.Message(id: '1', chatID: idHex(chat), date: DateTime(2026), text: 'cached');

    expect(await cubit.delete(existing), isFalse);

    expect(cubit.state.offlineNotice, 1);
    expect(api.unaryCalls, isEmpty);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    ChatsSync.instance.setEnabled(false);
    await cubit.close();
  });

  test('ChatCubit: обрыв при правке возвращает новый текст в поле ввода', () async {
    ChatsSync.instance.setEnabled(true);
    final cubit = ChatCubit()..initialization(chatID: idHex(chat), demo: false, markRead: false);
    addTearDown(cubit.close);
    final existing = models.Message(id: '1', chatID: idHex(chat), date: DateTime(2026), text: 'old');
    cubit.startEdit(existing);
    utils.network = true;
    api.enqueueUnaryResult(
      MessageType.MESSAGES,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'unavailable'),
    );

    expect(await cubit.send('new text'), isTrue);

    expect(cubit.state.offlineNotice, 1);
    expect(cubit.state.editing?.text, 'new text');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    ChatsSync.instance.setEnabled(false);
    await cubit.close();
  });

  test('история: offline показывает кэш, страницы догружаются до начала без повторных запросов', () async {
    final sync = ChatsSync.instance;
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    await store.upsertMessage(
      userID: me,
      message: message(3, text: 'cached'),
    );

    await sync.loadHistory(idBytes(idHex(chat)));
    expect(api.unaryCalls, isEmpty);
    expect((await store.message(userID: me, chatID: chat, messageID: 3))?.content.text, 'cached');

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(history: pb.Messages_HistoryResult(messages: [message(2)], hasMore: true)).writeToBuffer(),
    );
    await sync.loadHistory(idBytes(idHex(chat)));
    expect(pb.Messages_Request.fromBuffer(api.unaryCalls.single.payload).history.offsetID.toInt(), 0);
    expect(await store.countMessages(userID: me, chatID: chat), 2);

    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(history: pb.Messages_HistoryResult(messages: [message(1)])).writeToBuffer(),
    );
    final older = await sync.historyPage(idBytes(idHex(chat)), offsetID: 2, limit: 100);
    await store.applyHistoryPage(userID: me, chatID: chat, messages: older.messages, offsetID: 2, hasMore: older.hasMore);

    expect(pb.Messages_Request.fromBuffer(api.unaryCalls.last.payload).history.offsetID.toInt(), 2);
    expect(older.hasMore, isFalse);
    expect(await store.oldestMessageID(userID: me, chatID: chat), 1);
    expect(api.unaryCalls, hasLength(2));
  });

  test('закрепление: ответ сервера обновляет кэш, offline кэш не меняется', () async {
    final chatHex = idHex(chat);
    await store.setPts(userID: me, pts: 5);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    await store.upsertMessage(userID: me, message: message(1));
    final source = ChatsRemoteDataSource.instance;

    await expectLater(source.setMessagePinned(chatHex, '1', true), throwsA(isA<ChatsOfflineException>()));
    expect(await store.pinned(userID: me, chatID: chat), isEmpty);

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        pin: pb.Messages_PinResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                pts: Int64(6),
                pinnedMessages: pb.Update_PinnedMessages(chatID: chat, messageIDs: [Int64(1)], pinned: true),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await source.setMessagePinned(chatHex, '1', true);

    expect(pb.Messages_Request.fromBuffer(api.unaryCalls.single.payload).pin.messageID.toInt(), 1);
    expect((await store.pinned(userID: me, chatID: chat)).single.messageID.toInt(), 1);
  });

  test('отложенное в outbox переносится и отправляется сейчас без сети', () async {
    final chatHex = idHex(chat);
    final source = ChatsRemoteDataSource.instance;
    final date = DateTime(2026, 1, 2);
    await source.sendMessage(chatHex, text: 'later', scheduleDate: date);
    final queued = (await store.outbox(userID: me)).single;
    expect(queued.scheduleDate, date.millisecondsSinceEpoch);

    final later = DateTime(2026, 1, 3);
    await source.rescheduleMessage(chatHex, localMessageID(queued.randomID), later);
    expect((await store.outbox(userID: me)).single.scheduleDate, later.millisecondsSinceEpoch);

    await source.sendScheduledNow(chatHex, localMessageID(queued.randomID));
    expect((await store.outbox(userID: me)).single.scheduleDate, 0);
    expect(api.unaryCalls, isEmpty);

    await source.deleteScheduled(chatHex, localMessageID(queued.randomID));
    expect(await store.outbox(userID: me), isEmpty);
  });

  test('принятое отложенное удаляется серверным updates', () async {
    final chatHex = idHex(chat);
    await store.setPts(userID: me, pts: 5);
    await store.upsertScheduled(
      userID: me,
      message: pb.ScheduledMessage(
        chatID: chat,
        scheduledID: Int64(44),
        date: Int64(1000),
        content: pb.MessageContent(text: 'later'),
      ),
    );
    final source = ChatsRemoteDataSource.instance;
    final id = scheduledMessageID(44);

    await expectLater(source.deleteScheduled(chatHex, id), throwsA(isA<ChatsOfflineException>()));
    expect(await store.scheduled(userID: me, chatID: chat), hasLength(1));

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        deleteScheduled: pb.Messages_DeleteScheduledResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                pts: Int64(6),
                scheduledDeleted: pb.Update_ScheduledDeleted(chatID: chat, scheduledIDs: [Int64(44)]),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await source.deleteScheduled(chatHex, id);

    expect(pb.Messages_Request.fromBuffer(api.unaryCalls.single.payload).deleteScheduled.scheduledIDs.single.toInt(), 44);
    expect(await store.scheduled(userID: me, chatID: chat), isEmpty);
  });

  test('реакции: временный сбой сохраняет набор, успех применяет updates и очищает очередь', () async {
    final chatHex = idHex(chat);
    await store.setPts(userID: me, pts: 5);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    await store.upsertMessage(userID: me, message: message(1));
    final source = ChatsRemoteDataSource.instance;
    final sync = ChatsSync.instance;
    await source.setReactions(chatHex, '1', ['👍']);
    utils.network = true;
    api.enqueueUnaryResult(
      MessageType.MESSAGES,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.unavailable, error: 'unavailable'),
    );

    await sync.flushReactions();
    expect((await store.pendingReactions(userID: me)).single.emojis, ['👍']);

    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        setReactions: pb.Messages_SetReactionsResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                pts: Int64(6),
                messageReactions: pb.Update_MessageReactionsChanged(
                  chatID: chat,
                  messageID: Int64(1),
                  reactions: pb.MessageReactions(
                    reactions: [pb.MessageReaction(emoji: '👍', userID: me, date: Int64(1))],
                  ),
                ),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await sync.flushReactions();

    expect(await store.pendingReactions(userID: me), isEmpty);
    expect((await store.messageReactions(userID: me, chatID: chat, messageID: 1))!.reactions.single.emoji, '👍');
  });

  test('реакции: постоянный отказ удаляет набор из очереди', () async {
    final chatHex = idHex(chat);
    final source = ChatsRemoteDataSource.instance;
    final sync = ChatsSync.instance;
    await source.setReactions(chatHex, '1', ['👍']);
    api.enqueueUnaryResult(
      MessageType.MESSAGES,
      const APICallStatus(status: APIStatus.error, statusCode: StatusCode.permissionDenied, error: 'privacyRestricted'),
    );
    utils.network = true;

    await sync.flushReactions();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(await store.pendingReactions(userID: me), isEmpty);
    expect(api.unaryCalls.single.type, MessageType.MESSAGES);
  });

  test('серверный поиск: offline повторяется, страницы используют nextOffsetID', () async {
    final chatHex = idHex(chat);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    final source = ChatsRemoteDataSource.instance;

    final offline = await source.searchMessagesOnServer(chatHex, 'needle');
    expect(offline.status, ServerSearchStatus.offline);
    expect(api.unaryCalls, isEmpty);

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        search: pb.Messages_SearchResult(
          messages: [
            message(3, text: 'needle'),
            message(2, text: 'needle'),
          ],
          nextOffsetID: Int64(2),
        ),
      ).writeToBuffer(),
    );
    final first = await source.searchMessagesOnServer(chatHex, ' needle ');
    expect(first.ids, ['3', '2']);
    expect(first.nextOffsetID, '2');
    expect(api.unaryCalls.single.type, MessageType.MESSAGES);

    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(
        search: pb.Messages_SearchResult(
          messages: [
            message(2, text: 'needle'),
            message(1, text: 'needle'),
          ],
        ),
      ).writeToBuffer(),
    );
    final second = await source.searchMessagesOnServer(chatHex, 'needle', offsetID: first.nextOffsetID);
    expect(second.ids, ['2', '1']);
    expect(second.nextOffsetID, isNull);
    final request = pb.Messages_Request.fromBuffer(api.unaryCalls.last.payload).search;
    expect(request.offsetID.toInt(), 2);
    expect(request.query, 'needle');
    expect(await store.message(userID: me, chatID: chat, messageID: 1), isNotNull);
  });

  test('серверный поиск: QUERY_TOO_SHORT не меняет кэш и не даёт продолжения', () async {
    final chatHex = idHex(chat);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    final source = ChatsRemoteDataSource.instance;
    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(search: pb.Messages_SearchResult(status: pb.Messages_SearchResult_Status.QUERY_TOO_SHORT)).writeToBuffer(),
    );

    final page = await source.searchMessagesOnServer(chatHex, 'и');

    expect(page.status, ServerSearchStatus.tooShort);
    expect(page.ids, isEmpty);
    expect(page.nextOffsetID, isNull);
    expect(await store.countMessages(userID: me, chatID: chat), 0);
  });

  test('навигация: aroundID открывает окно, страница новее возвращает к ленте', () async {
    final chatHex = idHex(chat);
    await store.upsertDialog(
      userID: me,
      dialog: pb.Dialog(chatID: chat, peerUserID: peer),
    );
    final source = ChatsRemoteDataSource.instance;

    await expectLater(source.revealMessage(chatHex, '1'), throwsA(isA<ChatsOfflineException>()));

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(history: pb.Messages_HistoryResult(messages: [message(1)], hasMore: false, hasNewer: true)).writeToBuffer(),
    );
    await source.revealMessage(chatHex, '1');

    expect(pb.Messages_Request.fromBuffer(api.unaryCalls.single.payload).history.aroundID.toInt(), 1);
    expect(source.historyDetached(chatHex), isTrue);

    api.enqueueUnaryResponse(
      MessageType.MESSAGES,
      pb.Messages_Response(history: pb.Messages_HistoryResult(messages: [message(2), message(1)])).writeToBuffer(),
    );
    expect(await source.loadNewerMessages(chatHex), isFalse);
    expect(source.historyDetached(chatHex), isFalse);
    expect(await store.message(userID: me, chatID: chat, messageID: 2), isNotNull);
  });

  test('группа: исключение участника применяет chatMembers, offline кэш сохраняется', () async {
    final chatHex = idHex(chat);
    final dialog = pb.Dialog(
      chatID: chat,
      type: pb.ChatType.CHAT_TYPE_GROUP,
      chat: pb.ChatInfo(chatID: chat, type: pb.ChatType.CHAT_TYPE_GROUP, title: 'Group'),
    );
    await store.setPts(userID: me, pts: 5);
    await store.upsertGroup(userID: me, dialog: dialog);
    await store.upsertGroupMembers(
      userID: me,
      chatID: chat,
      members: [pb.ChatMember(userID: peer)],
    );
    final source = ChatsRemoteDataSource.instance;

    await expectLater(source.removeMember(chatHex, idHex(peer)), throwsA(isA<ChatsOfflineException>()));
    expect(await store.groupMembers(userID: me, chatID: chat), hasLength(1));

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.CHATS,
      pb.Chats_Response(
        removeMember: pb.Chats_RemoveMemberResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                chatID: chat,
                chatPts: Int64(1),
                chatMembers: pb.Update_ChatMembersChanged(chatID: chat, removedUserIDs: [peer]),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await source.removeMember(chatHex, idHex(peer));

    expect(pb.Chats_Request.fromBuffer(api.unaryCalls.single.payload).removeMember.userID, peer);
    expect(await store.groupMembers(userID: me, chatID: chat), isEmpty);
  });

  test('группа: частично добавленные применяются, об ограниченных сообщает исключение', () async {
    final chatHex = idHex(chat);
    await store.setPts(userID: me, pts: 5);
    await store.upsertGroup(
      userID: me,
      dialog: pb.Dialog(
        chatID: chat,
        type: pb.ChatType.CHAT_TYPE_GROUP,
        chat: pb.ChatInfo(chatID: chat, type: pb.ChatType.CHAT_TYPE_GROUP),
      ),
    );
    final source = ChatsRemoteDataSource.instance;
    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.CHATS,
      pb.Chats_Response(
        addMembers: pb.Chats_AddMembersResult(
          restrictedUserIDs: [peer],
          updates: pb.Updates(
            updates: [
              pb.Update(
                chatID: chat,
                chatPts: Int64(1),
                chatMembers: pb.Update_ChatMembersChanged(
                  chatID: chat,
                  added: [pb.ChatMember(userID: me)],
                ),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );

    await expectLater(
      source.addMembers(chatHex, [idHex(me), idHex(peer)]),
      throwsA(isA<ChatsMembersRestrictedException>().having((error) => error.count, 'count', 1)),
    );

    expect((await store.groupMembers(userID: me, chatID: chat)).single.userID, me);
  });

  test('канал: настройки реакций ограничивают максимум и применяют chatInfo', () async {
    final chatHex = idHex(chat);
    final info = pb.ChatInfo(chatID: chat, type: pb.ChatType.CHAT_TYPE_CHANNEL);
    await store.setPts(userID: me, pts: 5);
    await store.upsertGroup(
      userID: me,
      dialog: pb.Dialog(chatID: chat, type: pb.ChatType.CHAT_TYPE_CHANNEL, chat: info),
    );
    final source = ChatsRemoteDataSource.instance;

    await expectLater(
      source.setChatReactions(chatHex, models.ChatReactionsMode.some, ['👍'], maxReactions: 99),
      throwsA(isA<ChatsOfflineException>()),
    );

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.CHATS,
      pb.Chats_Response(
        editChat: pb.Chats_EditChatResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                chatID: chat,
                chatPts: Int64(1),
                chatInfo: pb.Update_ChatInfoChanged(
                  chat: info.deepCopy()
                    ..reactionsMode = pb.ChatReactionsMode.CHAT_REACTIONS_SOME
                    ..reactions.add('👍')
                    ..maxReactions = 11,
                ),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    await source.setChatReactions(chatHex, models.ChatReactionsMode.some, ['👍'], maxReactions: 99);

    final settings = pb.Chats_Request.fromBuffer(api.unaryCalls.single.payload).editChat.reactions;
    expect(settings.maxReactions, 11);
    expect(settings.emojis, ['👍']);
    expect((await store.group(userID: me, chatID: chat))?.info.maxReactions, 11);
  });

  test('ссылки: создание с одобрением не имеет лимита, очистка удаляет отозванные', () async {
    final chatHex = idHex(chat);
    final source = ChatsRemoteDataSource.instance;

    await expectLater(source.createInviteLink(chatHex, requestApproval: true, usageLimit: 10), throwsA(isA<ChatsOfflineException>()));

    utils.network = true;
    api.enqueueUnaryResponse(
      MessageType.CHATS,
      pb.Chats_Response(
        createInviteLink: pb.Chats_CreateInviteLinkResult(link: pb.ChatInviteLink(code: 'invite', requestApproval: true)),
      ).writeToBuffer(),
    );
    await source.createInviteLink(chatHex, requestApproval: true, usageLimit: 10);

    expect(pb.Chats_Request.fromBuffer(api.unaryCalls.single.payload).createInviteLink.usageLimit, 0);
    expect((await store.inviteLinks(userID: me, chatID: chat)).single.code, 'invite');

    await store.upsertInviteLink(
      userID: me,
      chatID: chat,
      link: pb.ChatInviteLink(code: 'old', revoked: true),
    );
    await source.deleteRevokedLinks(chatHex);
    expect((await store.inviteLinks(userID: me, chatID: chat)).map((link) => link.code), ['invite']);
  });

  test('заявки: список обновляет счётчик, ответ запускает перечитывание', () async {
    final chatHex = idHex(chat);
    await store.setPts(userID: me, pts: 5);
    await store.upsertGroup(
      userID: me,
      dialog: pb.Dialog(
        chatID: chat,
        type: pb.ChatType.CHAT_TYPE_GROUP,
        chat: pb.ChatInfo(chatID: chat, type: pb.ChatType.CHAT_TYPE_GROUP),
      ),
    );
    final source = ChatsRemoteDataSource.instance;
    utils.network = true;
    api.enqueueUnaryResponse(MessageType.CHATS, pb.Chats_Response(joinRequests: pb.Chats_JoinRequestsResult(total: 2)).writeToBuffer());
    final emissions = <List<models.ChatJoinRequest>>[];
    final subscription = source.watchJoinRequests(chatHex).listen(emissions.add);
    addTearDown(subscription.cancel);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(emissions.single, isEmpty);
    expect((await store.group(userID: me, chatID: chat))?.pendingRequests, 2);

    api.enqueueUnaryResponse(
      MessageType.CHATS,
      pb.Chats_Response(
        answerJoinRequest: pb.Chats_AnswerJoinRequestResult(
          updates: pb.Updates(
            updates: [
              pb.Update(
                pts: Int64(6),
                joinRequests: pb.Update_JoinRequestsChanged(chatID: chat, pendingCount: 1),
              ),
            ],
          ),
        ),
      ).writeToBuffer(),
    );
    for (var index = 0; index < 2; index++) {
      api.enqueueUnaryResponse(MessageType.CHATS, pb.Chats_Response(joinRequests: pb.Chats_JoinRequestsResult(total: 1)).writeToBuffer());
    }
    await source.answerJoinRequest(chatHex, userID: idHex(peer), approve: true);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(emissions, hasLength(3), reason: 'updates и явное уведомление ответа запускают независимые перечитывания');
    expect((await store.group(userID: me, chatID: chat))?.pendingRequests, 1);
  });
}

final class GatedFakeApi extends FakeApi {
  final _messageReleases = <Completer<void>>[];

  Future<void> gateNextMessage() {
    final started = Completer<void>();
    _messageReleases.add(Completer<void>());
    unawaited(Future<void>.delayed(Duration.zero, started.complete));
    return started.future;
  }

  void releaseMessage() {
    for (final release in _messageReleases) {
      if (!release.isCompleted) release.complete();
    }
  }

  @override
  Future<(APICallStatus, Uint8List?)> unaryEncodedWithResponse(MessageType type, Uint8List payload) async {
    if (type == MessageType.MESSAGES && _messageReleases.isNotEmpty) {
      await _messageReleases.first.future;
    }
    return super.unaryEncodedWithResponse(type, payload);
  }
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
    CREATE TABLE chatGroupMembers (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, memberUserID BLOB NOT NULL, role INTEGER NOT NULL DEFAULT 0,
      joinedAt INTEGER NOT NULL DEFAULT 0, inviterUserID BLOB, rights BLOB, rank TEXT NOT NULL DEFAULT '', promotedByUserID BLOB,
      PRIMARY KEY (userID, chatID, memberUserID)
    );
  ''');
  await db.execute(
    'CREATE TABLE chatInviteLinks (userID BLOB NOT NULL, chatID BLOB NOT NULL, code TEXT NOT NULL, link BLOB NOT NULL, PRIMARY KEY (userID, chatID, code));',
  );
  await db.execute('''
    CREATE TABLE chatPendingReactions (
      userID BLOB NOT NULL, chatID BLOB NOT NULL, messageID INTEGER NOT NULL, emojis TEXT NOT NULL, createdAt INTEGER NOT NULL,
      PRIMARY KEY (userID, chatID, messageID)
    );
  ''');
  await db.execute(
    'CREATE TABLE chatScheduled (userID BLOB NOT NULL, chatID BLOB NOT NULL, scheduledID INTEGER NOT NULL, date INTEGER NOT NULL, message BLOB NOT NULL, PRIMARY KEY (userID, chatID, scheduledID));',
  );
  await db.execute('CREATE TABLE chatUpdatesState (userID BLOB PRIMARY KEY, pts INTEGER NOT NULL, date INTEGER NOT NULL DEFAULT 0);');
  await db.execute('CREATE TABLE chatFolders (userID BLOB PRIMARY KEY, folders BLOB NOT NULL, version INTEGER NOT NULL DEFAULT 0);');
  await db.execute(ChatsRepository.repliesStateSchema);
  await db.execute(ChatsRepository.mentionsSchema);
  await db.execute(ChatsRepository.threadsSchema);
}
