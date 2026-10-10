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

  const ChatOutboxRow({
    required this.randomID,
    required this.chatID,
    required this.peerUserID,
    required this.content,
    required this.silent,
    required this.failed,
    required this.createdAt,
  });

  factory ChatOutboxRow._fromRow(Map<String, dynamic> row) => ChatOutboxRow(
    randomID: row['randomID'] as int,
    chatID: row['chatID'] == null ? null : Uint8List.fromList(row['chatID'] as List<int>),
    peerUserID: row['peerUserID'] == null ? null : Uint8List.fromList(row['peerUserID'] as List<int>),
    content: Uint8List.fromList(row['content'] as List<int>),
    silent: (row['silent'] as int) != 0,
    failed: (row['failed'] as int) != 0,
    createdAt: row['createdAt'] as int,
  );
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

  static const _dialogColumns =
      'chatID, type, peerUserID, topMessageID, topMessageDate, topMessage, readInboxMaxID, readOutboxMaxID, unreadCount, '
      'pinned, archived, markedUnread, mutedUntil, draft, createdAt';

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
        readOutboxMaxID, unreadCount, pinned, archived, markedUnread, mutedUntil, createdAt)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(userID, chatID) DO UPDATE SET
        type = excluded.type,
        peerUserID = excluded.peerUserID,
        topMessageID = excluded.topMessageID,
        topMessageDate = excluded.topMessageDate,
        topMessage = excluded.topMessage,
        readInboxMaxID = excluded.readInboxMaxID,
        readOutboxMaxID = excluded.readOutboxMaxID,
        unreadCount = excluded.unreadCount,
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
      INSERT INTO chatMessages (userID, chatID, messageID, fromUserID, date, editDate, randomID, mediaUnread, silent, content)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(userID, chatID, messageID) DO UPDATE SET
        fromUserID = excluded.fromUserID,
        date = excluded.date,
        editDate = excluded.editDate,
        randomID = excluded.randomID,
        mediaUnread = excluded.mediaUnread,
        silent = excluded.silent,
        content = excluded.content;
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
      ],
    );
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
    return unread?['n'] as int? ?? 0;
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
  );

  // --- outbox ---

  Future<void> addOutbox({
    required List<int> userID,
    required int randomID,
    List<int>? chatID,
    List<int>? peerUserID,
    required Uint8List content,
    bool silent = false,
  }) async {
    await ctx.execute(
      'INSERT INTO chatOutbox (userID, randomID, chatID, peerUserID, content, silent, createdAt) VALUES (?, ?, ?, ?, ?, ?, ?);',
      [userID, randomID, chatID, peerUserID, content, silent ? 1 : 0, DateTime.now().millisecondsSinceEpoch],
    );
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

  Future<void> deleteOutbox({required List<int> userID, required int randomID}) async {
    await ctx.execute('DELETE FROM chatOutbox WHERE userID = ? AND randomID = ?;', [userID, randomID]);
  }
}
