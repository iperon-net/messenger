part of 'repositories.dart';

/// Строка `chatDialogs` — мой диалог (см. миграцию 16).
class ChatDialogRow {
  final Uint8List chatID;
  final int type;
  final Uint8List? peerUserID;

  /// Последнее сообщение (сериализованный `ChatMessage`); `null` — чат пуст.
  final Uint8List? topMessage;
  final int topMessageID;
  final int topMessageDate;
  final int readInboxMaxID;
  final int readOutboxMaxID;
  final int unreadCount;

  /// Моих сообщений с непрочитанными реакциями (бейдж ❤️).
  final int unreadReactions;
  final bool pinned;
  final bool archived;
  final bool markedUnread;
  final int mutedUntil;
  final String draft;
  final int createdAt;

  const ChatDialogRow({
    required this.chatID,
    required this.type,
    required this.peerUserID,
    required this.topMessage,
    required this.topMessageID,
    required this.topMessageDate,
    required this.readInboxMaxID,
    required this.readOutboxMaxID,
    required this.unreadCount,
    this.unreadReactions = 0,
    required this.pinned,
    required this.archived,
    required this.markedUnread,
    required this.mutedUntil,
    required this.draft,
    required this.createdAt,
  });

  factory ChatDialogRow._fromRow(Map<String, dynamic> row) => ChatDialogRow(
    chatID: Uint8List.fromList(row['chatID'] as List<int>),
    type: row['type'] as int,
    peerUserID: row['peerUserID'] == null ? null : Uint8List.fromList(row['peerUserID'] as List<int>),
    topMessage: row['topMessage'] == null ? null : Uint8List.fromList(row['topMessage'] as List<int>),
    topMessageID: row['topMessageID'] as int,
    topMessageDate: row['topMessageDate'] as int,
    readInboxMaxID: row['readInboxMaxID'] as int,
    readOutboxMaxID: row['readOutboxMaxID'] as int,
    unreadCount: row['unreadCount'] as int,
    unreadReactions: row['unreadReactions'] as int? ?? 0,
    pinned: (row['pinned'] as int) != 0,
    archived: (row['archived'] as int) != 0,
    markedUnread: (row['markedUnread'] as int) != 0,
    mutedUntil: row['mutedUntil'] as int,
    draft: row['draft'] as String,
    createdAt: row['createdAt'] as int,
  );
}

/// Строка `chatOutbox` — сообщение, ещё не принятое сервером.
class ChatOutboxRow {
  final int randomID;
  final Uint8List? chatID;
  final Uint8List? peerUserID;

  /// Сериализованный `MessageContent`.
  final Uint8List content;
  final bool silent;
  final bool failed;
  final int createdAt;

  /// Локальные файлы вложений (JSON `OutboxMedia`, см. chats_media.dart);
  /// пусто — без вложений.
  final String media;

  /// Пересылка: исходное сообщение (чат + messageID на сервере); `null` /
  /// 0 — обычное сообщение.
  final Uint8List? forwardChatID;
  final int forwardMessageID;

  bool get isForward => forwardChatID != null && forwardMessageID > 0;

  const ChatOutboxRow({
    required this.randomID,
    required this.chatID,
    required this.peerUserID,
    required this.content,
    required this.silent,
    required this.failed,
    required this.createdAt,
    this.media = '',
    this.forwardChatID,
    this.forwardMessageID = 0,
  });

  factory ChatOutboxRow._fromRow(Map<String, dynamic> row) => ChatOutboxRow(
    randomID: row['randomID'] as int,
    chatID: row['chatID'] == null ? null : Uint8List.fromList(row['chatID'] as List<int>),
    peerUserID: row['peerUserID'] == null ? null : Uint8List.fromList(row['peerUserID'] as List<int>),
    content: Uint8List.fromList(row['content'] as List<int>),
    silent: (row['silent'] as int) != 0,
    failed: (row['failed'] as int) != 0,
    createdAt: row['createdAt'] as int,
    media: row['media'] as String? ?? '',
    forwardChatID: row['forwardChatID'] == null ? null : Uint8List.fromList(row['forwardChatID'] as List<int>),
    forwardMessageID: row['forwardMessageID'] as int? ?? 0,
  );
}

/// Мой набор реакций на сообщение, ещё не принятый сервером.
class ChatPendingReactionsRow {
  final Uint8List chatID;
  final int messageID;
  final List<String> emojis;
  final int createdAt;

  const ChatPendingReactionsRow({required this.chatID, required this.messageID, required this.emojis, required this.createdAt});

  factory ChatPendingReactionsRow._fromRow(Map<String, dynamic> row) {
    final emojis = row['emojis'] as String;
    return ChatPendingReactionsRow(
      chatID: Uint8List.fromList(row['chatID'] as List<int>),
      messageID: row['messageID'] as int,
      emojis: emojis.isEmpty ? const [] : emojis.split('\n'),
      createdAt: row['createdAt'] as int,
    );
  }
}

/// Локальная копия чатов: диалоги, история, outbox и pts журнала обновлений
/// (таблицы миграции 16). Пишет её `ChatsSync` (ответы сервера и push
/// `UPDATES`), читает `ChatsRemoteDataSource` — список и история видны offline.
///
/// Работает поверх [ctx]: сама БД или транзакция ([transaction]) — обновление,
/// задевающее несколько таблиц (диалог + сообщения + pts), пишется атомарно.
class ChatsRepository {
  final Logger logger;
  final SqliteWriteContext ctx;

  ChatsRepository({required this.logger, required SqliteDatabase db}) : ctx = db;

  ChatsRepository._tx({required this.logger, required this.ctx});

  /// Таблицы — для подписки на изменения (`db.onChange`).
  static const dialogsTable = 'chatDialogs';
  static const messagesTable = 'chatMessages';
  static const outboxTable = 'chatOutbox';
  static const pinnedTable = 'chatPinned';
  static const pendingReactionsTable = 'chatPendingReactions';

  static const _dialogColumns =
      'chatID, type, peerUserID, topMessageID, topMessageDate, topMessage, readInboxMaxID, readOutboxMaxID, unreadCount, '
      'unreadReactions, pinned, archived, markedUnread, mutedUntil, draft, createdAt';

  /// Выполнить [action] в одной транзакции записи. Уже внутри транзакции —
  /// просто выполняет.
  Future<T> transaction<T>(Future<T> Function(ChatsRepository tx) action) {
    final context = ctx;
    if (context is SqliteConnection) {
      return context.writeTransaction((tx) => action(ChatsRepository._tx(logger: logger, ctx: tx)));
    }
    return action(this);
  }

  // --- pts ---

  /// Последний применённый pts; `null` — журнал ещё не загружен (первый вход):
  /// нужен полный список диалогов.
  Future<int?> getPts({required List<int> userID}) async {
    final row = await ctx.getOptional('SELECT pts FROM chatUpdatesState WHERE userID = ?;', [userID]);
    return row?['pts'] as int?;
  }

  Future<void> setPts({required List<int> userID, required int pts, int date = 0}) async {
    await ctx.execute(
      '''
      INSERT INTO chatUpdatesState (userID, pts, date) VALUES (?, ?, ?)
      ON CONFLICT(userID) DO UPDATE SET pts = excluded.pts, date = excluded.date;
      ''',
      [userID, pts, date],
    );
  }

  // --- диалоги ---

  Future<List<ChatDialogRow>> dialogs({required List<int> userID}) async {
    final rows = await ctx.getAll('SELECT $_dialogColumns FROM chatDialogs WHERE userID = ?;', [userID]);
    return rows.map(ChatDialogRow._fromRow).toList(growable: false);
  }

  Future<ChatDialogRow?> dialog({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.getOptional('SELECT $_dialogColumns FROM chatDialogs WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    return row == null ? null : ChatDialogRow._fromRow(row);
  }

  /// Личный чат с [peerUserID] (у «Избранного» — я сам).
  Future<ChatDialogRow?> dialogByPeer({required List<int> userID, required List<int> peerUserID}) async {
    final row = await ctx.getOptional('SELECT $_dialogColumns FROM chatDialogs WHERE userID = ? AND peerUserID = ? AND type = 0 LIMIT 1;', [
      userID,
      peerUserID,
    ]);
    return row == null ? null : ChatDialogRow._fromRow(row);
  }

  /// Диалог с сервера: все серверные поля перезаписываются, локальный
  /// черновик остаётся. Последнее сообщение — ещё и в историю.
  Future<void> upsertDialog({required List<int> userID, required pb.Dialog dialog}) async {
    final top = dialog.hasTopMessage() ? dialog.topMessage : null;
    await ctx.execute(
      '''
      INSERT INTO chatDialogs (userID, chatID, type, peerUserID, topMessageID, topMessageDate, topMessage, readInboxMaxID,
        readOutboxMaxID, unreadCount, unreadReactions, pinned, archived, markedUnread, mutedUntil, createdAt)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(userID, chatID) DO UPDATE SET
        type = excluded.type,
        peerUserID = excluded.peerUserID,
        topMessageID = excluded.topMessageID,
        topMessageDate = excluded.topMessageDate,
        topMessage = excluded.topMessage,
        readInboxMaxID = excluded.readInboxMaxID,
        readOutboxMaxID = excluded.readOutboxMaxID,
        unreadCount = excluded.unreadCount,
        unreadReactions = excluded.unreadReactions,
        pinned = excluded.pinned,
        archived = excluded.archived,
        markedUnread = excluded.markedUnread,
        mutedUntil = excluded.mutedUntil,
        createdAt = excluded.createdAt;
      ''',
      [
        userID,
        dialog.chatID,
        dialog.type.value,
        dialog.peerUserID.isEmpty ? null : dialog.peerUserID,
        top?.messageID.toInt() ?? 0,
        top?.date.toInt() ?? 0,
        top?.writeToBuffer(),
        dialog.readInboxMaxID.toInt(),
        dialog.readOutboxMaxID.toInt(),
        dialog.unreadCount,
        dialog.unreadReactionsCount,
        dialog.pinned ? 1 : 0,
        dialog.archived ? 1 : 0,
        dialog.markedUnread ? 1 : 0,
        dialog.mutedUntil.toInt(),
        dialog.createdAt.toInt(),
      ],
    );
    if (top != null) await upsertMessage(userID: userID, message: top);
  }

  /// Пустой диалог, о котором сервер ещё не рассказал (сообщение пришло раньше
  /// диалога) — чтобы было куда положить счётчики; поля уточнит следующий
  /// полный список.
  Future<void> ensureDialog({required List<int> userID, required List<int> chatID, List<int>? peerUserID}) async {
    await ctx.execute('INSERT OR IGNORE INTO chatDialogs (userID, chatID, peerUserID, createdAt) VALUES (?, ?, ?, ?);', [
      userID,
      chatID,
      peerUserID,
      DateTime.now().millisecondsSinceEpoch,
    ]);
  }

  /// Точечное изменение полей диалога (имена колонок — из этого файла, не из
  /// внешних данных).
  Future<void> updateDialog({required List<int> userID, required List<int> chatID, required Map<String, Object?> fields}) async {
    if (fields.isEmpty) return;
    final sets = fields.keys.map((k) => '$k = ?').join(', ');
    await ctx.execute('UPDATE chatDialogs SET $sets WHERE userID = ? AND chatID = ?;', [...fields.values, userID, chatID]);
  }

  /// Последнее сообщение диалога.
  Future<void> setTopMessage({required List<int> userID, required List<int> chatID, required pb.ChatMessage? message}) async {
    await updateDialog(
      userID: userID,
      chatID: chatID,
      fields: {
        'topMessageID': message?.messageID.toInt() ?? 0,
        'topMessageDate': message?.date.toInt() ?? 0,
        'topMessage': message?.writeToBuffer(),
      },
    );
  }

  Future<void> setDraft({required List<int> userID, required List<int> chatID, required String draft}) async {
    await updateDialog(userID: userID, chatID: chatID, fields: {'draft': draft});
  }

  /// Диалог удалён у меня — вместе с историей и неотправленным.
  Future<void> deleteDialog({required List<int> userID, required List<int> chatID}) async {
    await ctx.execute('DELETE FROM chatMessages WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatOutbox WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatPinned WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatPendingReactions WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatDialogs WHERE userID = ? AND chatID = ?;', [userID, chatID]);
  }

  /// Полный список с сервера заменяет локальный: исчезнувшие диалоги удаляются
  /// (с историей), остальные перезаписываются (черновики остаются). Пустые
  /// локальные (открыли личный чат, ещё ничего не написали) остаются: сервер
  /// не показывает такой чат в списке до первого сообщения.
  /// [dropHistory] — журнал слишком отстал (`tooLong`): кэш истории мог
  /// разойтись с сервером, сбрасываем его целиком.
  Future<void> replaceDialogs({required List<int> userID, required List<pb.Dialog> dialogs, bool dropHistory = false}) async {
    if (dropHistory) await ctx.execute('DELETE FROM chatMessages WHERE userID = ?;', [userID]);
    final keep = {for (final d in dialogs) _hex(d.chatID)};
    for (final row in await this.dialogs(userID: userID)) {
      if (keep.contains(_hex(row.chatID)) || (row.topMessageID == 0 && row.type == 0)) continue;
      // Есть неотправленное — не теряем его вместе с диалогом.
      if ((await outbox(userID: userID, chatID: row.chatID)).any((r) => !r.failed)) {
        logger.warning('chats: dialog ${_hex(row.chatID)} missing on server, kept (outbox not empty)');
        continue;
      }
      logger.info('chats: dialog ${_hex(row.chatID)} missing on server, deleted locally (top=${row.topMessageID})');
      await deleteDialog(userID: userID, chatID: row.chatID);
    }
    for (final d in dialogs) {
      await upsertDialog(userID: userID, dialog: d);
    }
  }

  static String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  // --- сообщения ---

  Future<void> upsertMessage({required List<int> userID, required pb.ChatMessage message}) async {
    await ctx.execute(
      '''
      INSERT INTO chatMessages (userID, chatID, messageID, fromUserID, date, editDate, randomID, mediaUnread, silent, content, searchText, reactions,
        reactionsUnread)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(userID, chatID, messageID) DO UPDATE SET
        fromUserID = excluded.fromUserID,
        date = excluded.date,
        editDate = excluded.editDate,
        randomID = excluded.randomID,
        mediaUnread = excluded.mediaUnread,
        silent = excluded.silent,
        content = excluded.content,
        searchText = excluded.searchText,
        reactions = excluded.reactions,
        reactionsUnread = excluded.reactionsUnread;
      ''',
      [
        userID,
        message.chatID,
        message.messageID.toInt(),
        message.fromUserID,
        message.date.toInt(),
        message.editDate.toInt(),
        message.randomID.toInt(),
        message.mediaUnread ? 1 : 0,
        message.silent ? 1 : 0,
        message.content.writeToBuffer(),
        messageSearchText(message.content),
        _reactionsBlob(message.hasReactions() ? message.reactions : null),
        _reactionsUnread(userID, message) ? 1 : 0,
      ],
    );
    if (message.content.hasCall()) await _upsertCallLog(userID: userID, message: message);
    // Закреплённое правили — и в плашке новый текст.
    await ctx.execute('UPDATE chatPinned SET message = ? WHERE userID = ? AND chatID = ? AND messageID = ?;', [
      message.writeToBuffer(),
      userID,
      message.chatID,
      message.messageID.toInt(),
    ]);
  }

  /// Звонок из чата → журнал «Звонков» (`callLogs`): строку, записанную
  /// локально при завершении звонка (тот же callID), уточняем данными сервера,
  /// иначе добавляем (выгруженное приложение, другое устройство, новая
  /// установка). Удалённую во вкладке (hidden) не возвращаем. Собеседник
  /// исходящего — из диалога (неизвестен — пропускаем).
  Future<void> _upsertCallLog({required List<int> userID, required pb.ChatMessage message}) async {
    final call = message.content.call;
    if (call.callID.isEmpty) return;
    final outgoing = _sameBytes(message.fromUserID, userID);
    List<int>? peer = outgoing ? null : message.fromUserID;
    if (outgoing) {
      final row = await ctx.getOptional('SELECT peerUserID FROM chatDialogs WHERE userID = ? AND chatID = ?;', [userID, message.chatID]);
      peer = row?['peerUserID'] as List<int>?;
    }
    if (peer == null || peer.isEmpty) return;
    final unanswered = call.outcome == pb.MessageCall_Outcome.MISSED || call.outcome == pb.MessageCall_Outcome.BUSY;
    final values = [
      outgoing ? models.CallDirection.outgoing.name : models.CallDirection.incoming.name,
      call.video ? 1 : 0,
      !outgoing && unanswered ? 1 : 0,
      call.outcome == pb.MessageCall_Outcome.ENDED ? call.duration : 0,
      message.date.toInt(),
    ];
    await ctx.execute('UPDATE callLogs SET direction = ?, video = ?, missed = ?, durationSeconds = ?, createdAt = ? WHERE callID = ?;', [
      ...values,
      call.callID,
    ]);
    await ctx.execute(
      '''
      INSERT INTO callLogs (direction, video, missed, durationSeconds, createdAt, callID, userID, displayName)
      SELECT ?, ?, ?, ?, ?, ?, ?, '' WHERE NOT EXISTS (SELECT 1 FROM callLogs WHERE callID = ?);
      ''',
      [...values, call.callID, peer, call.callID],
    );
  }

  static bool _sameBytes(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<pb.ChatMessage?> message({required List<int> userID, required List<int> chatID, required int messageID}) async {
    final row = await ctx.getOptional('SELECT * FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID = ?;', [
      userID,
      chatID,
      messageID,
    ]);
    return row == null ? null : _messageFromRow(row);
  }

  /// История чата от старых к новым (последние [limit]).
  Future<List<pb.ChatMessage>> messages({required List<int> userID, required List<int> chatID, int limit = 1000}) async {
    final rows = await ctx.getAll(
      'SELECT * FROM (SELECT * FROM chatMessages WHERE userID = ? AND chatID = ? ORDER BY messageID DESC LIMIT ?) ORDER BY messageID ASC;',
      [userID, chatID, limit],
    );
    return rows.map(_messageFromRow).toList(growable: false);
  }

  /// Сколько сообщений чата в кэше.
  Future<int> countMessages({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.get('SELECT COUNT(*) AS n FROM chatMessages WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    return row['n'] as int;
  }

  /// Самый старый messageID в кэше (0 — кэш пуст).
  Future<int> oldestMessageID({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.get('SELECT MIN(messageID) AS id FROM chatMessages WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    return (row['id'] as int?) ?? 0;
  }

  /// Самый новый messageID в кэше (0 — кэш пуст).
  Future<int> newestMessageID({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.get('SELECT MAX(messageID) AS id FROM chatMessages WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    return (row['id'] as int?) ?? 0;
  }

  /// Удаляет из кэша сообщения старше [messageID] (не стыкуются с новыми).
  Future<void> deleteMessagesBelow({required List<int> userID, required List<int> chatID, required int messageID}) async {
    await ctx.execute('DELETE FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID < ?;', [userID, chatID, messageID]);
  }

  /// Поиск по истории чата в кэше (FTS5): messageID найденных, от новых к
  /// старым. [match] — выражение из `ftsMatchQuery`.
  Future<List<int>> searchMessages({required List<int> userID, required List<int> chatID, required String match, int limit = 1000}) async {
    final rows = await ctx.getAll(chatMessagesSearchSql, [match, userID, chatID, limit]);
    return [for (final row in rows) row['messageID'] as int];
  }

  /// Сколько сообщений чата в кэше не старше [messageID] (окно, чтобы его показать).
  Future<int> countMessagesFrom({required List<int> userID, required List<int> chatID, required int messageID}) async {
    final row = await ctx.get('SELECT COUNT(*) AS n FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID >= ?;', [
      userID,
      chatID,
      messageID,
    ]);
    return row['n'] as int;
  }

  /// Самое новое сообщение из кэша (новое «последнее» после удаления).
  Future<pb.ChatMessage?> latestMessage({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.getOptional('SELECT * FROM chatMessages WHERE userID = ? AND chatID = ? ORDER BY messageID DESC LIMIT 1;', [
      userID,
      chatID,
    ]);
    return row == null ? null : _messageFromRow(row);
  }

  /// Удаляет сообщения; возвращает, сколько из удалённых было входящими
  /// непрочитанными (после [readInboxMaxID], не от [userID]) — для счётчика.
  Future<int> deleteMessages({
    required List<int> userID,
    required List<int> chatID,
    required List<int> messageIDs,
    int readInboxMaxID = 0,
  }) async {
    if (messageIDs.isEmpty) return 0;
    final placeholders = List.filled(messageIDs.length, '?').join(',');
    final unread = await ctx.getOptional(
      'SELECT COUNT(*) AS n FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders) AND messageID > ? AND fromUserID != ?;',
      [userID, chatID, ...messageIDs, readInboxMaxID, userID],
    );
    await ctx.execute('DELETE FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders);', [
      userID,
      chatID,
      ...messageIDs,
    ]);
    await ctx.execute('DELETE FROM chatPinned WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders);', [
      userID,
      chatID,
      ...messageIDs,
    ]);
    await ctx.execute('DELETE FROM chatPendingReactions WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders);', [
      userID,
      chatID,
      ...messageIDs,
    ]);
    return unread?['n'] as int? ?? 0;
  }

  // --- реакции ---

  static Uint8List? _reactionsBlob(pb.MessageReactions? reactions) =>
      reactions == null || reactions.reactions.isEmpty ? null : reactions.writeToBuffer();

  /// Флаг сервера значим только для автора: на чужом сообщении — игнорируем.
  static bool _reactionsUnread(List<int> userID, pb.ChatMessage message) =>
      message.reactionsUnread && _sameBytes(message.fromUserID, userID);

  /// Реакции на сообщение изменились (Update.messageReactions). Нет в кэше —
  /// ничего: подтянутся с историей. [unread] — на моём сообщении есть
  /// непросмотренные реакции (на чужом не ставится).
  Future<void> setReactions({
    required List<int> userID,
    required List<int> chatID,
    required int messageID,
    required pb.MessageReactions reactions,
    bool unread = false,
  }) async {
    await ctx.execute(
      'UPDATE chatMessages SET reactions = ?, reactionsUnread = (? AND fromUserID = ?) WHERE userID = ? AND chatID = ? AND messageID = ?;',
      [_reactionsBlob(reactions), unread ? 1 : 0, userID, userID, chatID, messageID],
    );
  }

  /// Реакции на мои сообщения [messageIDs] просмотрены (Update.readReactions).
  Future<void> readReactions({required List<int> userID, required List<int> chatID, required List<int> messageIDs}) async {
    if (messageIDs.isEmpty) return;
    final placeholders = List.filled(messageIDs.length, '?').join(',');
    await ctx.execute('UPDATE chatMessages SET reactionsUnread = 0 WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders);', [
      userID,
      chatID,
      ...messageIDs,
    ]);
  }

  /// Мои сообщения чата с непрочитанными реакциями в кэше — от старых к новым.
  Future<List<int>> unreadReactionIDs({required List<int> userID, required List<int> chatID}) async {
    final rows = await ctx.getAll(
      'SELECT messageID FROM chatMessages WHERE userID = ? AND chatID = ? AND reactionsUnread = 1 ORDER BY messageID ASC;',
      [userID, chatID],
    );
    return [for (final row in rows) row['messageID'] as int];
  }

  /// Сколько из [messageIDs] — мои с непрочитанными реакциями (удаляются —
  /// счётчик диалога уменьшается).
  Future<int> countUnreadReactions({required List<int> userID, required List<int> chatID, required List<int> messageIDs}) async {
    if (messageIDs.isEmpty) return 0;
    final placeholders = List.filled(messageIDs.length, '?').join(',');
    final row = await ctx.get(
      'SELECT COUNT(*) AS n FROM chatMessages WHERE userID = ? AND chatID = ? AND reactionsUnread = 1 AND messageID IN ($placeholders);',
      [userID, chatID, ...messageIDs],
    );
    return row['n'] as int;
  }

  /// Мой набор реакций, ещё не принятый сервером, — заменяет прежний.
  Future<void> setPendingReactions({
    required List<int> userID,
    required List<int> chatID,
    required int messageID,
    required List<String> emojis,
  }) async {
    await ctx.execute(
      'INSERT OR REPLACE INTO chatPendingReactions (userID, chatID, messageID, emojis, createdAt) VALUES (?, ?, ?, ?, ?);',
      [userID, chatID, messageID, emojis.join('\n'), DateTime.now().microsecondsSinceEpoch],
    );
  }

  /// Неотправленные наборы реакций — по порядку; [chatID] — только этого чата.
  Future<List<ChatPendingReactionsRow>> pendingReactions({required List<int> userID, List<int>? chatID}) async {
    final rows = chatID == null
        ? await ctx.getAll('SELECT * FROM chatPendingReactions WHERE userID = ? ORDER BY createdAt ASC;', [userID])
        : await ctx.getAll('SELECT * FROM chatPendingReactions WHERE userID = ? AND chatID = ? ORDER BY createdAt ASC;', [userID, chatID]);
    return rows.map(ChatPendingReactionsRow._fromRow).toList(growable: false);
  }

  /// Убрать отправленный набор — только если с тех пор его не сменили
  /// ([createdAt] тот же), иначе уйдёт и новый.
  Future<void> deletePendingReactions({
    required List<int> userID,
    required List<int> chatID,
    required int messageID,
    required int createdAt,
  }) async {
    await ctx.execute('DELETE FROM chatPendingReactions WHERE userID = ? AND chatID = ? AND messageID = ? AND createdAt = ?;', [
      userID,
      chatID,
      messageID,
      createdAt,
    ]);
  }

  /// Голосовые прослушаны — снять mediaUnread.
  Future<void> readContents({required List<int> userID, required List<int> chatID, required List<int> messageIDs}) async {
    if (messageIDs.isEmpty) return;
    final placeholders = List.filled(messageIDs.length, '?').join(',');
    await ctx.execute('UPDATE chatMessages SET mediaUnread = 0 WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders);', [
      userID,
      chatID,
      ...messageIDs,
    ]);
  }

  // --- закреплённые ---

  /// Мои закреплённые сообщения чата — от новых к старым.
  Future<List<pb.ChatMessage>> pinned({required List<int> userID, required List<int> chatID}) async {
    final rows = await ctx.getAll('SELECT message FROM chatPinned WHERE userID = ? AND chatID = ? ORDER BY messageID DESC;', [
      userID,
      chatID,
    ]);
    return [for (final row in rows) pb.ChatMessage.fromBuffer(row['message'] as List<int>)];
  }

  /// Список с сервера (Messages.Pinned) заменяет локальный.
  Future<void> replacePinned({required List<int> userID, required List<int> chatID, required List<pb.ChatMessage> messages}) async {
    await ctx.execute('DELETE FROM chatPinned WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    for (final message in messages) {
      await ctx.execute('INSERT OR REPLACE INTO chatPinned (userID, chatID, messageID, message) VALUES (?, ?, ?, ?);', [
        userID,
        chatID,
        message.messageID.toInt(),
        message.writeToBuffer(),
      ]);
    }
  }

  /// Закрепили / открепили [messageIDs] (Update.pinnedMessages). Закреплённые
  /// берём из кэша истории; возвращает тех, кого там нет (содержимое — с
  /// сервера, Messages.Pinned).
  Future<List<int>> setPinned({
    required List<int> userID,
    required List<int> chatID,
    required List<int> messageIDs,
    required bool pinned,
  }) async {
    if (messageIDs.isEmpty) return const [];
    if (!pinned) {
      final placeholders = List.filled(messageIDs.length, '?').join(',');
      await ctx.execute('DELETE FROM chatPinned WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders);', [
        userID,
        chatID,
        ...messageIDs,
      ]);
      return const [];
    }
    final missing = <int>[];
    for (final id in messageIDs) {
      final cached = await message(userID: userID, chatID: chatID, messageID: id);
      if (cached == null) {
        final known = await ctx.getOptional('SELECT 1 FROM chatPinned WHERE userID = ? AND chatID = ? AND messageID = ?;', [
          userID,
          chatID,
          id,
        ]);
        if (known == null) missing.add(id);
        continue;
      }
      await ctx.execute('INSERT OR REPLACE INTO chatPinned (userID, chatID, messageID, message) VALUES (?, ?, ?, ?);', [
        userID,
        chatID,
        id,
        cached.writeToBuffer(),
      ]);
    }
    return missing;
  }

  pb.ChatMessage _messageFromRow(Map<String, dynamic> row) => pb.ChatMessage(
    chatID: row['chatID'] as List<int>,
    messageID: Int64(row['messageID'] as int),
    fromUserID: row['fromUserID'] as List<int>,
    date: Int64(row['date'] as int),
    editDate: Int64(row['editDate'] as int),
    randomID: Int64(row['randomID'] as int),
    mediaUnread: (row['mediaUnread'] as int) != 0,
    silent: (row['silent'] as int) != 0,
    content: pb.MessageContent.fromBuffer(row['content'] as List<int>),
    reactions: row['reactions'] == null ? null : pb.MessageReactions.fromBuffer(row['reactions'] as List<int>),
    reactionsUnread: (row['reactionsUnread'] as int? ?? 0) != 0,
  );

  // --- outbox ---

  Future<void> addOutbox({
    required List<int> userID,
    required int randomID,
    List<int>? chatID,
    List<int>? peerUserID,
    required Uint8List content,
    bool silent = false,
    String media = '',
    List<int>? forwardChatID,
    int forwardMessageID = 0,
    int? createdAt,
  }) async {
    await ctx.execute(
      'INSERT INTO chatOutbox (userID, randomID, chatID, peerUserID, content, silent, createdAt, media, forwardChatID, forwardMessageID) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);',
      [
        userID,
        randomID,
        chatID,
        peerUserID,
        content,
        silent ? 1 : 0,
        createdAt ?? DateTime.now().millisecondsSinceEpoch,
        media,
        forwardChatID,
        forwardMessageID,
      ],
    );
  }

  /// Файлы вложений всех неотправленных (всех пользователей) — чтобы не
  /// удалить нужное при чистке каталога outbox.
  Future<List<String>> outboxMediaAll() async {
    final rows = await ctx.getAll("SELECT media FROM chatOutbox WHERE media != '';");
    return [for (final row in rows) row['media'] as String];
  }

  /// Неотправленные — по порядку создания; [chatID] — только этого чата.
  Future<List<ChatOutboxRow>> outbox({required List<int> userID, List<int>? chatID}) async {
    final rows = chatID == null
        ? await ctx.getAll('SELECT * FROM chatOutbox WHERE userID = ? ORDER BY createdAt ASC, randomID ASC;', [userID])
        : await ctx.getAll('SELECT * FROM chatOutbox WHERE userID = ? AND chatID = ? ORDER BY createdAt ASC, randomID ASC;', [
            userID,
            chatID,
          ]);
    return rows.map(ChatOutboxRow._fromRow).toList(growable: false);
  }

  Future<ChatOutboxRow?> outboxByRandomID({required List<int> userID, required int randomID}) async {
    final row = await ctx.getOptional('SELECT * FROM chatOutbox WHERE userID = ? AND randomID = ?;', [userID, randomID]);
    return row == null ? null : ChatOutboxRow._fromRow(row);
  }

  Future<void> updateOutboxContent({required List<int> userID, required int randomID, required Uint8List content}) async {
    await ctx.execute('UPDATE chatOutbox SET content = ? WHERE userID = ? AND randomID = ?;', [content, userID, randomID]);
  }

  Future<void> markOutboxFailed({required List<int> userID, required int randomID}) async {
    await ctx.execute('UPDATE chatOutbox SET failed = 1 WHERE userID = ? AND randomID = ?;', [userID, randomID]);
  }

  Future<void> unmarkOutboxFailed({required List<int> userID, required int randomID}) async {
    await ctx.execute('UPDATE chatOutbox SET failed = 0 WHERE userID = ? AND randomID = ?;', [userID, randomID]);
  }

  Future<void> deleteOutbox({required List<int> userID, required int randomID}) async {
    await ctx.execute('DELETE FROM chatOutbox WHERE userID = ? AND randomID = ?;', [userID, randomID]);
  }
}
