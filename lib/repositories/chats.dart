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

  /// Группа: непрочитанных упоминаний меня (бейдж «@»).
  final int unreadMentions;
  final bool pinned;
  final bool archived;
  final bool markedUnread;
  final int mutedUntil;
  final String draft;
  final int createdAt;

  /// Автоудаление в чате (секунды; 0 — выключено).
  final int ttlPeriod;

  /// Защита содержимого: 0 — выключена, 1 — включил я, 2 — собеседник.
  final int noForwards;

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
    this.unreadMentions = 0,
    required this.pinned,
    required this.archived,
    required this.markedUnread,
    required this.mutedUntil,
    required this.draft,
    required this.createdAt,
    this.ttlPeriod = 0,
    this.noForwards = 0,
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
    unreadMentions: row['unreadMentions'] as int? ?? 0,
    pinned: (row['pinned'] as int) != 0,
    archived: (row['archived'] as int) != 0,
    markedUnread: (row['markedUnread'] as int) != 0,
    mutedUntil: row['mutedUntil'] as int,
    draft: row['draft'] as String,
    createdAt: row['createdAt'] as int,
    ttlPeriod: row['ttlPeriod'] as int? ?? 0,
    noForwards: row['noForwards'] as int? ?? 0,
  );
}

/// Строка `chatGroups` — группа или канал (срез 4, тип — `info.type`), где я
/// участник / подписчик (миграция 35): общие
/// сведения ([info] — `ChatInfo` с сервера), моя роль и pts журнала ЧАТА; с
/// миграции 36 — мои права админа и звание (`Dialog.rights / rank`).
class ChatGroupRow {
  final Uint8List chatID;
  final pb.ChatInfo info;
  final pb.ChatRole role;
  final int pts;
  final pb.ChatAdminRights rights;
  final String rank;

  /// Владельцу и админам с правом приглашать: код основной ссылки (без `+`)
  /// и сколько заявок ждёт; остальным — пусто / 0.
  final String inviteCode;
  final int pendingRequests;

  /// Медленный режим: когда мне можно следующее сообщение (unix millis; 0 —
  /// сейчас). Когда я вступил (0 — неизвестно) — для «новичков».
  final int slowModeUntil;
  final int joinedAt;

  ChatGroupRow({
    required this.chatID,
    required this.info,
    required this.role,
    required this.pts,
    pb.ChatAdminRights? rights,
    this.rank = '',
    this.inviteCode = '',
    this.pendingRequests = 0,
    this.slowModeUntil = 0,
    this.joinedAt = 0,
  }) : rights = rights ?? pb.ChatAdminRights();

  factory ChatGroupRow._fromRow(Map<String, dynamic> row) => ChatGroupRow(
    chatID: Uint8List.fromList(row['chatID'] as List<int>),
    info: pb.ChatInfo.fromBuffer(row['info'] as List<int>),
    role: pb.ChatRole.valueOf(row['role'] as int) ?? pb.ChatRole.CHAT_ROLE_WRITER,
    pts: row['pts'] as int,
    rights: row['rights'] == null ? null : pb.ChatAdminRights.fromBuffer(row['rights'] as List<int>),
    rank: row['rank'] as String? ?? '',
    inviteCode: row['inviteCode'] as String? ?? '',
    pendingRequests: row['pendingRequests'] as int? ?? 0,
    slowModeUntil: row['slowModeUntil'] as int? ?? 0,
    joinedAt: row['joinedAt'] as int? ?? 0,
  );
}

/// Строка `chatGroupMembers` — известный участник группы (пришёл в
/// `Chats.Members` или `Update.chatMembers`): роль, права админа и звание.
class ChatGroupMemberRow {
  final Uint8List userID;
  final pb.ChatRole role;
  final int joinedAt;
  final Uint8List? inviterUserID;
  final pb.ChatAdminRights rights;
  final String rank;

  ChatGroupMemberRow({
    required this.userID,
    required this.role,
    required this.joinedAt,
    this.inviterUserID,
    pb.ChatAdminRights? rights,
    this.rank = '',
  }) : rights = rights ?? pb.ChatAdminRights();

  /// Участник из ответа сервера (страница `Chats.Members`).
  factory ChatGroupMemberRow.fromPb(pb.ChatMember m) => ChatGroupMemberRow(
    userID: Uint8List.fromList(m.userID),
    role: m.role,
    joinedAt: m.joinedAt.toInt(),
    inviterUserID: m.inviterUserID.isEmpty ? null : Uint8List.fromList(m.inviterUserID),
    rights: m.hasRights() ? m.rights : null,
    rank: m.rank,
  );

  factory ChatGroupMemberRow._fromRow(Map<String, dynamic> row) => ChatGroupMemberRow(
    userID: Uint8List.fromList(row['memberUserID'] as List<int>),
    role: pb.ChatRole.valueOf(row['role'] as int) ?? pb.ChatRole.CHAT_ROLE_WRITER,
    joinedAt: row['joinedAt'] as int,
    inviterUserID: row['inviterUserID'] == null ? null : Uint8List.fromList(row['inviterUserID'] as List<int>),
    rights: row['rights'] == null ? null : pb.ChatAdminRights.fromBuffer(row['rights'] as List<int>),
    rank: row['rank'] as String? ?? '',
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

  /// Отложенное (unix millis; 0 — обычное): уйдёт на сервер отложенным, в
  /// ленте его нет — оно на экране «Отложенные».
  final int scheduleDate;

  bool get isScheduled => scheduleDate > 0;

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
    this.scheduleDate = 0,
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
    scheduleDate: row['scheduleDate'] as int? ?? 0,
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

  /// Удалённые сообщения отдают cdnID своих вложений — кандидаты на удаление
  /// файлов с устройства (`ChatsMediaCleanup`, ставит `ChatsSync`).
  static void Function(Iterable<List<int>> cdnIDs)? onMediaReleased;

  /// cdnID вложений (файл и обложка) сообщений, выбранных [where].
  Future<void> _releaseMedia(String table, String column, String where, List<Object?> args, {bool chatMessage = false}) async {
    final hook = onMediaReleased;
    if (hook == null) return;
    final ids = <List<int>>[];
    for (final row in await ctx.getAll('SELECT $column AS c FROM $table WHERE $where AND $column IS NOT NULL;', args)) {
      try {
        final blob = row['c'] as List<int>;
        final content = chatMessage ? pb.ChatMessage.fromBuffer(blob).content : pb.MessageContent.fromBuffer(blob);
        for (final media in content.media) {
          if (media.cdnID.isNotEmpty) ids.add(media.cdnID);
          if (media.thumbCdnID.isNotEmpty) ids.add(media.thumbCdnID);
        }
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
    if (ids.isNotEmpty) hook(ids);
  }

  /// Таблицы — для подписки на изменения (`db.onChange`).
  static const dialogsTable = 'chatDialogs';
  static const messagesTable = 'chatMessages';
  static const outboxTable = 'chatOutbox';
  static const pinnedTable = 'chatPinned';
  static const pendingReactionsTable = 'chatPendingReactions';
  static const foldersTable = 'chatFolders';
  static const scheduledTable = 'chatScheduled';
  static const groupsTable = 'chatGroups';
  static const groupMembersTable = 'chatGroupMembers';
  static const inviteLinksTable = 'chatInviteLinks';
  static const mentionsTable = 'chatMentions';

  /// Мои непрочитанные упоминания в группах (миграция 38).
  static const mentionsSchema = '''
    CREATE TABLE chatMentions (
      userID BLOB NOT NULL,
      chatID BLOB NOT NULL,
      messageID INTEGER NOT NULL,
      PRIMARY KEY (userID, chatID, messageID)
    );
  ''';

  static const _dialogColumns =
      'chatID, type, peerUserID, topMessageID, topMessageDate, topMessage, readInboxMaxID, readOutboxMaxID, unreadCount, '
      'unreadReactions, unreadMentions, pinned, archived, markedUnread, mutedUntil, draft, createdAt, ttlPeriod, noForwards';

  /// Dialog.noForwards / noForwardsMine → столбец noForwards.
  static int noForwardsColumn(pb.Dialog dialog) => !dialog.noForwards ? 0 : (dialog.noForwardsMine ? 1 : 2);

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

  // --- папки ---

  /// Снимок папок с сервера; `null` — ещё не загружали.
  Future<pb.ChatFolders?> folders({required List<int> userID}) async {
    final row = await ctx.getOptional('SELECT folders FROM chatFolders WHERE userID = ?;', [userID]);
    return row == null ? null : pb.ChatFolders.fromBuffer(row['folders'] as List<int>);
  }

  /// Записать снимок, если он не старше сохранённого (ответ GetFolders и
  /// обновление folders могут прийти в любом порядке).
  Future<void> setFolders({required List<int> userID, required pb.ChatFolders folders}) async {
    await ctx.execute(
      '''
      INSERT INTO chatFolders (userID, folders, version) VALUES (?, ?, ?)
      ON CONFLICT(userID) DO UPDATE SET folders = excluded.folders, version = excluded.version
      WHERE excluded.version >= chatFolders.version;
      ''',
      [userID, folders.writeToBuffer(), folders.version.toInt()],
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
        readOutboxMaxID, unreadCount, unreadReactions, unreadMentions, pinned, archived, markedUnread, mutedUntil, createdAt, draft, ttlPeriod,
        noForwards)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(userID, chatID) DO UPDATE SET
        -- Свой неотправленный черновик серверный не перезаписывает.
        draft = CASE WHEN chatDialogs.draftPending = 1 THEN chatDialogs.draft ELSE excluded.draft END,
        type = excluded.type,
        peerUserID = excluded.peerUserID,
        topMessageID = excluded.topMessageID,
        topMessageDate = excluded.topMessageDate,
        topMessage = excluded.topMessage,
        readInboxMaxID = excluded.readInboxMaxID,
        readOutboxMaxID = excluded.readOutboxMaxID,
        unreadCount = excluded.unreadCount,
        unreadReactions = excluded.unreadReactions,
        unreadMentions = excluded.unreadMentions,
        pinned = excluded.pinned,
        archived = excluded.archived,
        markedUnread = excluded.markedUnread,
        mutedUntil = excluded.mutedUntil,
        createdAt = excluded.createdAt,
        ttlPeriod = excluded.ttlPeriod,
        noForwards = excluded.noForwards;
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
        dialog.unreadMentionsCount,
        dialog.pinned ? 1 : 0,
        dialog.archived ? 1 : 0,
        dialog.markedUnread ? 1 : 0,
        dialog.mutedUntil.toInt(),
        dialog.createdAt.toInt(),
        dialog.draft,
        dialog.ttlPeriod,
        noForwardsColumn(dialog),
      ],
    );
    if (top != null) await upsertMessage(userID: userID, message: top);
    // Группа: сведения, моя роль и pts журнала чата (догон — от него).
    if (dialog.hasChat()) await upsertGroup(userID: userID, dialog: dialog);
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

  /// Мой черновик (с этого устройства): сразу локально и в очередь на сервер
  /// (`draftPending`). `false` — не изменился.
  Future<bool> setDraft({required List<int> userID, required List<int> chatID, required String draft}) async {
    final result = await ctx.execute(
      'UPDATE chatDialogs SET draft = ?, draftPending = 1 WHERE userID = ? AND chatID = ? AND draft != ? RETURNING chatID;',
      [draft, userID, chatID, draft],
    );
    return result.isNotEmpty;
  }

  /// Черновик с сервера (другое устройство / отправка сообщения) — если свой
  /// не ждёт отправки.
  Future<void> setServerDraft({required List<int> userID, required List<int> chatID, required String draft}) async {
    await ctx.execute('UPDATE chatDialogs SET draft = ? WHERE userID = ? AND chatID = ? AND draftPending = 0;', [draft, userID, chatID]);
  }

  /// Черновики, ещё не отправленные на сервер.
  Future<List<({Uint8List chatID, String draft})>> pendingDrafts({required List<int> userID}) async {
    final rows = await ctx.getAll('SELECT chatID, draft FROM chatDialogs WHERE userID = ? AND draftPending = 1;', [userID]);
    return [for (final row in rows) (chatID: Uint8List.fromList(row['chatID'] as List<int>), draft: row['draft'] as String)];
  }

  /// Сервер принял черновик [draft] — снять очередь (если его не успели
  /// поменять снова).
  Future<void> draftSent({required List<int> userID, required List<int> chatID, required String draft}) async {
    await ctx.execute('UPDATE chatDialogs SET draftPending = 0 WHERE userID = ? AND chatID = ? AND draft = ?;', [userID, chatID, draft]);
  }

  /// Диалог удалён у меня — вместе с историей и неотправленным.
  Future<void> deleteDialog({required List<int> userID, required List<int> chatID}) async {
    await _releaseMedia('chatMessages', 'content', 'userID = ? AND chatID = ?', [userID, chatID]);
    await _releaseMedia('chatPinned', 'message', 'userID = ? AND chatID = ?', [userID, chatID], chatMessage: true);
    await _releaseMedia('chatDialogs', 'topMessage', 'userID = ? AND chatID = ?', [userID, chatID], chatMessage: true);
    await ctx.execute('DELETE FROM chatMessages WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatOutbox WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatPinned WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatPendingReactions WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatDialogs WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatGroups WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatGroupMembers WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatInviteLinks WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await ctx.execute('DELETE FROM chatMentions WHERE userID = ? AND chatID = ?;', [userID, chatID]);
  }

  /// Полный список с сервера заменяет локальный: исчезнувшие диалоги удаляются
  /// (с историей), остальные перезаписываются (черновики остаются). Пустые
  /// локальные (открыли личный чат, ещё ничего не написали) остаются: сервер
  /// не показывает такой чат в списке до первого сообщения.
  /// [staleHistory] — журнал слишком отстал (`tooLong`): кэш истории мог
  /// разойтись с сервером — не стираем, а помечаем несверенным
  /// ([markHistoryStale]), сверится страницами ([applyHistoryPage]).
  /// [keepTypes] — типы чатов (`pb.ChatType`), чей флаг («Группы» /
  /// «Каналы») выключен: сервер их не отдаёт, но их кэш не стираем (включат
  /// снова — всё на месте).
  Future<void> replaceDialogs({
    required List<int> userID,
    required List<pb.Dialog> dialogs,
    bool staleHistory = false,
    Set<int> keepTypes = const {},
  }) async {
    // До записи диалогов: их последние сообщения (новее кэша) — уже сверены.
    if (staleHistory) await markHistoryStale(userID: userID);
    final keep = {for (final d in dialogs) _hex(d.chatID)};
    for (final row in await this.dialogs(userID: userID)) {
      if (keep.contains(_hex(row.chatID)) || (row.topMessageID == 0 && row.type == 0)) continue;
      if (keepTypes.contains(row.type)) continue;
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

  /// Сообщение с сервера — в кэш. [shared] — из общего журнала группы
  /// (`Update.chatPts > 0`): там реакции без моего порядка, итоги опроса без
  /// моего выбора и `mentionUnread` всегда false — мои сохранённые значения
  /// остаются ([mergeSharedReactions], [mergePollResults]). Упоминание
  /// только добавляется (снимают Update.mentions / сверка истории).
  ///
  /// [searchHit] — сообщение из ответа поиска на сервере ([applySearchHits]):
  /// новое кладётся скрытым из ленты, у уже лежащего флаг не меняется. Любая
  /// другая запись (история, журнал) флаг снимает.
  Future<void> upsertMessage({
    required List<int> userID,
    required pb.ChatMessage message,
    bool shared = false,
    bool searchHit = false,
  }) async {
    var reactions = message.hasReactions() ? message.reactions : null;
    var poll = message.hasPoll() ? message.poll : null;
    if (shared && (reactions != null || poll != null)) {
      final stored = await ctx.getOptional('SELECT reactions, poll FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID = ?;', [
        userID,
        message.chatID,
        message.messageID.toInt(),
      ]);
      if (reactions != null) {
        final blob = stored?['reactions'] as List<int>?;
        reactions = mergeSharedReactions(blob == null ? null : pb.MessageReactions.fromBuffer(blob), reactions, myUserID: userID);
      }
      if (poll != null) {
        final blob = stored?['poll'] as List<int>?;
        poll = mergePollResults(blob == null ? null : pb.PollResults.fromBuffer(blob), poll, shared: true);
      }
    }
    await ctx.execute(
      '''
      INSERT INTO chatMessages (userID, chatID, messageID, fromUserID, date, editDate, randomID, mediaUnread, silent, content, searchText, reactions,
        reactionsUnread, expireAt, poll, searchHit, authorSignature, postOut)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
        reactionsUnread = excluded.reactionsUnread,
        expireAt = excluded.expireAt,
        poll = COALESCE(excluded.poll, chatMessages.poll),
        searchHit = MIN(chatMessages.searchHit, excluded.searchHit),
        authorSignature = excluded.authorSignature,
        -- «Мой пост» канала приходит только в ответах мне (Send, история);
        -- общее обновление журнала его не несёт — не сбрасываем.
        postOut = MAX(chatMessages.postOut, excluded.postOut);
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
        _reactionsBlob(reactions),
        _reactionsUnread(userID, message) ? 1 : 0,
        messageExpireAt(message),
        poll?.writeToBuffer(),
        searchHit ? 1 : 0,
        message.authorSignature,
        message.postOut ? 1 : 0,
      ],
    );
    if (message.mentionUnread) await addMentions(userID: userID, chatID: message.chatID, messageIDs: [message.messageID.toInt()]);
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
    await ctx.execute(
      'UPDATE callLogs SET direction = ?, video = ?, missed = ?, durationSeconds = ?, createdAt = ? WHERE ownerID = ? AND callID = ?;',
      [...values, userID, call.callID],
    );
    await ctx.execute(
      '''
      INSERT INTO callLogs (direction, video, missed, durationSeconds, createdAt, callID, ownerID, userID, displayName)
      SELECT ?, ?, ?, ?, ?, ?, ?, ?, '' WHERE NOT EXISTS (SELECT 1 FROM callLogs WHERE ownerID = ? AND callID = ?);
      ''',
      [...values, call.callID, userID, peer, userID, call.callID],
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
      'SELECT * FROM (SELECT * FROM chatMessages WHERE userID = ? AND chatID = ? AND searchHit = 0 ORDER BY messageID DESC LIMIT ?) ORDER BY messageID ASC;',
      [userID, chatID, limit],
    );
    return rows.map(_messageFromRow).toList(growable: false);
  }

  /// Сколько сообщений чата в кэше.
  Future<int> countMessages({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.get('SELECT COUNT(*) AS n FROM chatMessages WHERE userID = ? AND chatID = ? AND searchHit = 0;', [
      userID,
      chatID,
    ]);
    return row['n'] as int;
  }

  /// Самый старый messageID в кэше (0 — кэш пуст).
  Future<int> oldestMessageID({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.get('SELECT MIN(messageID) AS id FROM chatMessages WHERE userID = ? AND chatID = ? AND searchHit = 0;', [
      userID,
      chatID,
    ]);
    return (row['id'] as int?) ?? 0;
  }

  /// Самый новый messageID в кэше (0 — кэш пуст).
  Future<int> newestMessageID({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.get('SELECT MAX(messageID) AS id FROM chatMessages WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    return (row['id'] as int?) ?? 0;
  }

  /// Весь кэш истории — несверенный (журнал на сервере обрезан, `tooLong`):
  /// у каждого чата с историей граница — выше самого нового в кэше.
  Future<void> markHistoryStale({required List<int> userID}) async {
    await ctx.execute(
      '''
      UPDATE chatDialogs SET historyStaleBelow = (
        SELECT MAX(m.messageID) + 1 FROM chatMessages m WHERE m.userID = chatDialogs.userID AND m.chatID = chatDialogs.chatID
      )
      WHERE userID = ? AND EXISTS (
        SELECT 1 FROM chatMessages m WHERE m.userID = chatDialogs.userID AND m.chatID = chatDialogs.chatID
      );
      ''',
      [userID],
    );
  }

  /// Кэш истории одного чата — несверенный (журнал группы обрезан,
  /// `GetChatDifference.tooLong`).
  Future<void> markChatHistoryStale({required List<int> userID, required List<int> chatID}) async {
    await ctx.execute(
      '''
      UPDATE chatDialogs SET historyStaleBelow = (
        SELECT MAX(m.messageID) + 1 FROM chatMessages m WHERE m.userID = chatDialogs.userID AND m.chatID = chatDialogs.chatID
      )
      WHERE userID = ? AND chatID = ? AND EXISTS (
        SELECT 1 FROM chatMessages m WHERE m.userID = chatDialogs.userID AND m.chatID = chatDialogs.chatID
      );
      ''',
      [userID, chatID],
    );
  }

  /// Граница несверенной истории чата: сообщения с messageID ниже неё не
  /// сверены с сервером (0 — всё сверено).
  Future<int> historyStaleBelow({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.getOptional('SELECT historyStaleBelow FROM chatDialogs WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    return (row?['historyStaleBelow'] as int?) ?? 0;
  }

  /// Страница истории с сервера (по убыванию messageID) — в кэш со сверкой.
  /// [offsetID] — граница запроса (сообщения ниже неё; 0 — самые новые),
  /// [hasMore] — на сервере есть старше страницы.
  ///
  /// Страница покрывает диапазон: от её самого старого (старше нет — от
  /// начала) до [offsetID] − 1 (у самой новой — до её самого нового). Чего в
  /// этом диапазоне нет в ответе — на сервере удалено (или скрыто от меня),
  /// удаляется и из кэша; остальное перезаписывается (правки, реакции).
  /// Граница несверенной истории сдвигается вниз до начала страницы; самая
  /// новая страница, не дотянувшаяся до кэша (дыра после долгого офлайна),
  /// старое не стирает, а делает несверенным. Возвращает новую границу (0 —
  /// всё сверено).
  Future<int> applyHistoryPage({
    required List<int> userID,
    required List<int> chatID,
    required List<pb.ChatMessage> messages,
    required int offsetID,
    required bool hasMore,
  }) async {
    final stale = await historyStaleBelow(userID: userID, chatID: chatID);
    final cachedNewest = await newestMessageID(userID: userID, chatID: chatID);
    final ids = {for (final m in messages) m.messageID.toInt()};
    // По убыванию: первое — самое новое, последнее — самое старое.
    final from = !hasMore ? 1 : (messages.isEmpty ? null : messages.last.messageID.toInt());
    // Пустая самая новая страница, старше нет — у меня в чате ничего не
    // видно: сверяем несверенное (свежее, пришедшее после ответа, не трогаем).
    final to = offsetID > 0
        ? offsetID - 1
        : messages.isNotEmpty
        ? messages.first.messageID.toInt()
        : (!hasMore && stale > 0 ? stale - 1 : null);
    if (from != null && to != null && from <= to) {
      final rows = await ctx.getAll('SELECT messageID FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID BETWEEN ? AND ?;', [
        userID,
        chatID,
        from,
        to,
      ]);
      final gone = [
        for (final row in rows)
          if (!ids.contains(row['messageID'] as int)) row['messageID'] as int,
      ];
      await deleteMessages(userID: userID, chatID: chatID, messageIDs: gone);
    }
    for (final message in messages) {
      await upsertMessage(userID: userID, message: message);
    }
    // История — глазами меня: упоминание, которого в ней уже нет, прочитано.
    await removeMentions(
      userID: userID,
      chatID: chatID,
      messageIDs: [
        for (final m in messages)
          if (!m.mentionUnread) m.messageID.toInt(),
      ],
    );

    var next = stale;
    if (!hasMore) {
      next = 0;
    } else if (from != null) {
      final gap = offsetID == 0 && stale == 0 && cachedNewest > 0 && from > cachedNewest + 1;
      if (stale > 0 || gap) next = from;
    }
    if (next <= 1) next = 0;
    if (next != stale) {
      await updateDialog(userID: userID, chatID: chatID, fields: {'historyStaleBelow': next});
    }
    return next;
  }

  /// Найденное поиском на сервере (`Messages.Search`, от новых к старым) — в
  /// кэш, не ломая непрерывность истории. Ответ поиска — не страница истории:
  /// между найденными — дыры, поэтому ничего не удаляется и граница
  /// `historyStaleBelow` не сдвигается вниз.
  ///
  /// - уже лежащее в кэше — обновляется (правка, реакции), флаг не меняется;
  /// - старше сверенной непрерывной части (ниже `historyStaleBelow`, а если
  ///   её нет — ниже самого старого в ленте) — кладётся с флагом `searchHit`:
  ///   его находит локальный поиск, но в ленте его нет, пока до него не
  ///   дойдут страницы истории ([applyHistoryPage] перезапишет его обычным или
  ///   удалит). Сверенная часть была непрерывной до самого старого — теперь
  ///   ниже него несверенное: граница встаёт на самое старое;
  /// - в сверенной части, но не в кэше (новее кэша — придёт журналом) —
  ///   не кладётся.
  ///
  /// Кэш чата пуст — всё найденное кладётся флагом, граница — выше самого
  /// нового из найденного. Возвращает, сколько добавлено.
  Future<int> applySearchHits({required List<int> userID, required List<int> chatID, required List<pb.ChatMessage> messages}) async {
    if (messages.isEmpty) return 0;
    final stale = await historyStaleBelow(userID: userID, chatID: chatID);
    final oldest = await oldestMessageID(userID: userID, chatID: chatID);
    // Нижняя граница сверенной непрерывной части (0 — кэш пуст).
    final floor = stale > 0 ? stale : oldest;
    var added = 0;
    var newest = 0;
    for (final message in messages) {
      final id = message.messageID.toInt();
      final cached = await ctx.getOptional('SELECT 1 FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID = ?;', [
        userID,
        chatID,
        id,
      ]);
      if (cached == null && floor > 0 && id >= floor) continue;
      await upsertMessage(userID: userID, message: message, searchHit: true);
      if (cached == null) {
        added++;
        if (id > newest) newest = id;
      }
    }
    if (added > 0 && stale == 0) {
      await updateDialog(userID: userID, chatID: chatID, fields: {'historyStaleBelow': floor > 0 ? floor : newest + 1});
    }
    return added;
  }

  /// Нижняя граница сверенной непрерывной части ленты: `historyStaleBelow`, а
  /// без неё — самое старое в ленте (0 — кэш пуст).
  Future<int> historyFloor({required List<int> userID, required List<int> chatID}) async {
    final stale = await historyStaleBelow(userID: userID, chatID: chatID);
    return stale > 0 ? stale : oldestMessageID(userID: userID, chatID: chatID);
  }

  /// Сообщения [from]..[to] от старых к новым — вместе со скрытыми из ленты
  /// (`searchHit`): лента окна «вокруг сообщения» (см. `HistoryWindow`).
  Future<List<pb.ChatMessage>> messagesBetween({
    required List<int> userID,
    required List<int> chatID,
    required int from,
    required int to,
  }) async {
    final rows = await ctx.getAll(
      'SELECT * FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID BETWEEN ? AND ? ORDER BY messageID ASC;',
      [userID, chatID, from, to],
    );
    return rows.map(_messageFromRow).toList(growable: false);
  }

  /// Страница окна «вокруг сообщения», оторванного от сверенной части ленты:
  /// непрерывный кусок истории [from]..[to] с сервера ([messages] — по
  /// убыванию). Кладётся как найденное поиском ([applySearchHits]: ниже
  /// сверенной части — скрытым из ленты, граница вниз не сдвигается), а
  /// найденные раньше в этом диапазоне, которых в ответе нет, — удалены на
  /// сервере (или скрыты от меня) и удаляются.
  Future<void> applyWindowPage({
    required List<int> userID,
    required List<int> chatID,
    required List<pb.ChatMessage> messages,
    required int from,
    required int to,
  }) async {
    final ids = {for (final m in messages) m.messageID.toInt()};
    final rows = await ctx.getAll(
      'SELECT messageID FROM chatMessages WHERE userID = ? AND chatID = ? AND searchHit = 1 AND messageID BETWEEN ? AND ?;',
      [userID, chatID, from, to],
    );
    await deleteMessages(
      userID: userID,
      chatID: chatID,
      messageIDs: [
        for (final row in rows)
          if (!ids.contains(row['messageID'] as int)) row['messageID'] as int,
      ],
    );
    await applySearchHits(userID: userID, chatID: chatID, messages: messages);
  }

  /// Окно «вокруг сообщения» дошло до сверенной части ленты (или до самого
  /// нового, [reachesTop]): весь его непрерывный кусок ([messages] — по
  /// убыванию, от начала окна до сверенной части) ложится обычной страницей
  /// истории ([applyHistoryPage]) — найденное становится лентой, граница
  /// несверенного — на начало окна. [hasOlder] — на сервере есть старше окна.
  /// Возвращает новую границу (0 — всё сверено).
  Future<int> joinWindow({
    required List<int> userID,
    required List<int> chatID,
    required List<pb.ChatMessage> messages,
    required bool hasOlder,
    required bool reachesTop,
  }) async {
    final floor = await historyFloor(userID: userID, chatID: chatID);
    if (reachesTop || floor == 0) {
      return applyHistoryPage(userID: userID, chatID: chatID, messages: messages, offsetID: 0, hasMore: hasOlder);
    }
    return applyHistoryPage(
      userID: userID,
      chatID: chatID,
      messages: [
        for (final m in messages)
          if (m.messageID.toInt() < floor) m,
      ],
      offsetID: floor,
      hasMore: hasOlder,
    );
  }

  /// Сообщение лежит в кэше и видно в ленте (не только найдено поиском).
  Future<bool> inHistory({required List<int> userID, required List<int> chatID, required int messageID}) async {
    final row = await ctx.getOptional('SELECT 1 FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID = ? AND searchHit = 0;', [
      userID,
      chatID,
      messageID,
    ]);
    return row != null;
  }

  /// Поиск по истории чата в кэше (FTS5): messageID найденных, от новых к
  /// старым. [match] — выражение из `ftsMatchQuery`.
  Future<List<int>> searchMessages({required List<int> userID, required List<int> chatID, required String match, int limit = 1000}) async {
    final rows = await ctx.getAll(chatMessagesSearchSql, [match, userID, chatID, limit]);
    return [for (final row in rows) row['messageID'] as int];
  }

  /// Сколько сообщений чата в кэше не старше [messageID] (окно, чтобы его показать).
  Future<int> countMessagesFrom({required List<int> userID, required List<int> chatID, required int messageID}) async {
    final row = await ctx.get(
      'SELECT COUNT(*) AS n FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID >= ? AND searchHit = 0;',
      [userID, chatID, messageID],
    );
    return row['n'] as int;
  }

  /// Самое новое сообщение из кэша (новое «последнее» после удаления).
  Future<pb.ChatMessage?> latestMessage({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.getOptional(
      'SELECT * FROM chatMessages WHERE userID = ? AND chatID = ? AND searchHit = 0 ORDER BY messageID DESC LIMIT 1;',
      [userID, chatID],
    );
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
    await _releaseMedia('chatMessages', 'content', 'userID = ? AND chatID = ? AND messageID IN ($placeholders)', [
      userID,
      chatID,
      ...messageIDs,
    ]);
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
    await ctx.execute('DELETE FROM chatMentions WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders);', [
      userID,
      chatID,
      ...messageIDs,
    ]);
    return unread?['n'] as int? ?? 0;
  }

  // --- реакции ---

  static Uint8List? _reactionsBlob(pb.MessageReactions? reactions) =>
      reactions == null || (reactions.reactions.isEmpty && reactions.counts.isEmpty) ? null : reactions.writeToBuffer();

  /// Флаг сервера значим только для автора: на чужом сообщении — игнорируем.
  static bool _reactionsUnread(List<int> userID, pb.ChatMessage message) =>
      message.reactionsUnread && _sameBytes(message.fromUserID, userID);

  /// Реакции на сообщение изменились (Update.messageReactions). Нет в кэше —
  /// ничего: подтянутся с историей. [unread] — на моём сообщении есть
  /// непросмотренные реакции (на чужом не ставится).
  ///
  /// [unread] `null` — флаг не трогать (общий журнал группы: он значим только
  /// в обновлении автору, журнал пользователя).
  Future<void> setReactions({
    required List<int> userID,
    required List<int> chatID,
    required int messageID,
    required pb.MessageReactions reactions,
    bool? unread = false,
  }) async {
    if (unread == null) {
      await ctx.execute('UPDATE chatMessages SET reactions = ? WHERE userID = ? AND chatID = ? AND messageID = ?;', [
        _reactionsBlob(reactions),
        userID,
        chatID,
        messageID,
      ]);
      return;
    }
    await ctx.execute(
      'UPDATE chatMessages SET reactions = ?, reactionsUnread = (? AND fromUserID = ?) WHERE userID = ? AND chatID = ? AND messageID = ?;',
      [_reactionsBlob(reactions), unread ? 1 : 0, userID, userID, chatID, messageID],
    );
  }

  /// Сохранённые реакции сообщения (`null` — нет сообщения в кэше или реакций).
  Future<pb.MessageReactions?> messageReactions({required List<int> userID, required List<int> chatID, required int messageID}) async {
    final row = await ctx.getOptional('SELECT reactions FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID = ?;', [
      userID,
      chatID,
      messageID,
    ]);
    final blob = row?['reactions'] as List<int>?;
    return blob == null ? null : pb.MessageReactions.fromBuffer(blob);
  }

  // --- упоминания ---

  /// Непрочитанные упоминания меня в [messageIDs] (Update.mentions unread,
  /// сообщение из History / Get с `mentionUnread`).
  Future<void> addMentions({required List<int> userID, required List<int> chatID, required List<int> messageIDs}) async {
    for (final id in messageIDs) {
      await ctx.execute('INSERT OR IGNORE INTO chatMentions (userID, chatID, messageID) VALUES (?, ?, ?);', [userID, chatID, id]);
    }
  }

  /// Упоминания прочитаны / сообщения удалены; [messageIDs] `null` — все в
  /// чате.
  Future<void> removeMentions({required List<int> userID, required List<int> chatID, List<int>? messageIDs}) async {
    if (messageIDs == null) {
      await ctx.execute('DELETE FROM chatMentions WHERE userID = ? AND chatID = ?;', [userID, chatID]);
      return;
    }
    if (messageIDs.isEmpty) return;
    final placeholders = List.filled(messageIDs.length, '?').join(',');
    await ctx.execute('DELETE FROM chatMentions WHERE userID = ? AND chatID = ? AND messageID IN ($placeholders);', [
      userID,
      chatID,
      ...messageIDs,
    ]);
  }

  /// Непрочитанные упоминания чата в кэше — от старых к новым.
  Future<List<int>> unreadMentionIDs({required List<int> userID, required List<int> chatID}) async {
    final rows = await ctx.getAll('SELECT messageID FROM chatMentions WHERE userID = ? AND chatID = ? ORDER BY messageID ASC;', [
      userID,
      chatID,
    ]);
    return [for (final row in rows) row['messageID'] as int];
  }

  // --- опросы ---

  /// Итоги опроса глазами меня (`null` — нет сообщения в кэше или итогов).
  Future<pb.PollResults?> pollResults({required List<int> userID, required List<int> chatID, required int messageID}) async {
    final row = await ctx.getOptional('SELECT poll FROM chatMessages WHERE userID = ? AND chatID = ? AND messageID = ?;', [
      userID,
      chatID,
      messageID,
    ]);
    final blob = row?['poll'] as List<int>?;
    return blob == null ? null : pb.PollResults.fromBuffer(blob);
  }

  /// Новые итоги опроса (уже сведённые с сохранёнными). Нет в кэше — ничего:
  /// подтянутся с историей.
  Future<void> setPollResults({
    required List<int> userID,
    required List<int> chatID,
    required int messageID,
    required pb.PollResults results,
  }) async {
    await ctx.execute('UPDATE chatMessages SET poll = ? WHERE userID = ? AND chatID = ? AND messageID = ?;', [
      results.writeToBuffer(),
      userID,
      chatID,
      messageID,
    ]);
    // Закреплённый опрос — с теми же итогами.
    final pinned = await ctx.getOptional('SELECT message FROM chatPinned WHERE userID = ? AND chatID = ? AND messageID = ?;', [
      userID,
      chatID,
      messageID,
    ]);
    if (pinned != null) {
      final message = pb.ChatMessage.fromBuffer(pinned['message'] as List<int>)..poll = results;
      await ctx.execute('UPDATE chatPinned SET message = ? WHERE userID = ? AND chatID = ? AND messageID = ?;', [
        message.writeToBuffer(),
        userID,
        chatID,
        messageID,
      ]);
    }
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

  /// Какие из моих закреплённых в чате закреплены у всех участников (личный:
  /// у обоих); остальные — только у меня.
  Future<Set<int>> sharedPinnedIDs({required List<int> userID, required List<int> chatID}) async {
    final rows = await ctx.getAll('SELECT messageID FROM chatPinned WHERE userID = ? AND chatID = ? AND shared != 0;', [userID, chatID]);
    return {for (final row in rows) row['messageID'] as int};
  }

  /// Список с сервера (Messages.Pinned) заменяет локальный; [sharedIDs] —
  /// закреплённые у всех.
  Future<void> replacePinned({
    required List<int> userID,
    required List<int> chatID,
    required List<pb.ChatMessage> messages,
    required Set<int> sharedIDs,
  }) async {
    await ctx.execute('DELETE FROM chatPinned WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    for (final message in messages) {
      final id = message.messageID.toInt();
      await ctx.execute('INSERT OR REPLACE INTO chatPinned (userID, chatID, messageID, message, shared) VALUES (?, ?, ?, ?, ?);', [
        userID,
        chatID,
        id,
        message.writeToBuffer(),
        sharedIDs.contains(id) ? 1 : 0,
      ]);
    }
  }

  /// Закрепили / открепили [messageIDs] (Update.pinnedMessages; [shared] — у
  /// всех участников, может прийти и для уже закреплённых). Закреплённые
  /// берём из кэша истории; возвращает тех, кого нет ни там, ни в
  /// закреплённых (содержимое — с сервера, Messages.Pinned).
  Future<List<int>> setPinned({
    required List<int> userID,
    required List<int> chatID,
    required List<int> messageIDs,
    required bool pinned,
    required bool shared,
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
        if (known == null) {
          missing.add(id);
        } else {
          await ctx.execute('UPDATE chatPinned SET shared = ? WHERE userID = ? AND chatID = ? AND messageID = ?;', [
            shared ? 1 : 0,
            userID,
            chatID,
            id,
          ]);
        }
        continue;
      }
      await ctx.execute('INSERT OR REPLACE INTO chatPinned (userID, chatID, messageID, message, shared) VALUES (?, ?, ?, ?, ?);', [
        userID,
        chatID,
        id,
        cached.writeToBuffer(),
        shared ? 1 : 0,
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
    ttlPeriod: _ttlFromRow(row),
    poll: row['poll'] == null ? null : pb.PollResults.fromBuffer(row['poll'] as List<int>),
    authorSignature: row['authorSignature'] as String? ?? '',
    postOut: (row['postOut'] as int? ?? 0) != 0,
  );

  static int _ttlFromRow(Map<String, dynamic> row) {
    final expireAt = row['expireAt'] as int? ?? 0;
    return expireAt > 0 ? (expireAt - (row['date'] as int)) ~/ 1000 : 0;
  }

  /// Когда сообщение удалить у себя (автоудаление; unix millis, 0 — никогда).
  static int messageExpireAt(pb.ChatMessage message) => message.ttlPeriod > 0 ? message.date.toInt() + message.ttlPeriod * 1000 : 0;

  // --- автоудаление ---

  /// Сообщения с истёкшим автоудалением (в истории и закреплённых) по чатам:
  /// hex(chatID) → (chatID, номера).
  Future<Map<String, ({Uint8List chatID, List<int> messageIDs})>> expiredMessages({required List<int> userID, required int now}) async {
    final result = <String, ({Uint8List chatID, List<int> messageIDs})>{};
    void add(List<int> chatID, int messageID) {
      final entry = result.putIfAbsent(_hex(chatID), () => (chatID: Uint8List.fromList(chatID), messageIDs: <int>[]));
      if (!entry.messageIDs.contains(messageID)) entry.messageIDs.add(messageID);
    }

    final rows = await ctx.getAll('SELECT chatID, messageID FROM chatMessages WHERE userID = ? AND expireAt > 0 AND expireAt <= ?;', [
      userID,
      now,
    ]);
    for (final row in rows) {
      add(row['chatID'] as List<int>, row['messageID'] as int);
    }
    // Закреплённые старше скачанной истории — только в chatPinned.
    for (final row in await ctx.getAll('SELECT chatID, messageID, message FROM chatPinned WHERE userID = ?;', [userID])) {
      final message = pb.ChatMessage.fromBuffer(row['message'] as List<int>);
      final expireAt = messageExpireAt(message);
      if (expireAt > 0 && expireAt <= now) add(row['chatID'] as List<int>, row['messageID'] as int);
    }
    return result;
  }

  // --- группы ---

  static const _groupColumns = 'chatID, info, role, pts, rights, rank, inviteCode, pendingRequests, slowModeUntil, joinedAt';

  Future<List<ChatGroupRow>> groups({required List<int> userID}) async {
    final rows = await ctx.getAll('SELECT $_groupColumns FROM chatGroups WHERE userID = ?;', [userID]);
    return rows.map(ChatGroupRow._fromRow).toList(growable: false);
  }

  Future<ChatGroupRow?> group({required List<int> userID, required List<int> chatID}) async {
    final row = await ctx.getOptional('SELECT $_groupColumns FROM chatGroups WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    return row == null ? null : ChatGroupRow._fromRow(row);
  }

  /// Сведения о группе с сервера (диалог группы — `Dialog.chat`, моя роль,
  /// права и звание; dialogNew). pts журнала чата не уменьшается: обновления,
  /// уже применённые после этого снимка, второй раз не применяем. [resetPts]
  /// — журнал обрезан (tooLong): pts — как в снимке.
  Future<void> upsertGroup({required List<int> userID, required pb.Dialog dialog, bool resetPts = false}) async {
    final info = dialog.chat;
    await ctx.execute(
      '''
      INSERT INTO chatGroups (userID, chatID, info, role, pts, rights, rank, inviteCode, pendingRequests, slowModeUntil, joinedAt)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(userID, chatID) DO UPDATE SET
        info = excluded.info,
        role = excluded.role,
        rights = excluded.rights,
        rank = excluded.rank,
        inviteCode = excluded.inviteCode,
        pendingRequests = excluded.pendingRequests,
        slowModeUntil = excluded.slowModeUntil,
        -- Дата вступления не пропадает, если в снимке её нет.
        joinedAt = CASE WHEN excluded.joinedAt > 0 THEN excluded.joinedAt ELSE chatGroups.joinedAt END,
        pts = ${resetPts ? 'excluded.pts' : 'MAX(chatGroups.pts, excluded.pts)'};
      ''',
      [
        userID,
        info.chatID,
        info.writeToBuffer(),
        dialog.role.value,
        info.pts.toInt(),
        _rightsColumn(dialog.rights),
        dialog.rank,
        dialog.inviteCode,
        dialog.pendingRequests,
        dialog.slowModeUntil.toInt(),
        dialog.joinedAt.toInt(),
      ],
    );
  }

  /// Медленный режим: когда можно следующее (ответ Send / отказ
  /// «slowModeWait»; unix millis, 0 — сейчас).
  Future<void> setGroupSlowModeUntil({required List<int> userID, required List<int> chatID, required int until}) async {
    await ctx.execute('UPDATE chatGroups SET slowModeUntil = ? WHERE userID = ? AND chatID = ?;', [until, userID, chatID]);
  }

  /// Моя роль / права / звание изменились (Update.dialogSettings группы);
  /// с ними — основная ссылка и число заявок (видны только с правом
  /// приглашать: сняли админа — пусто).
  Future<void> setGroupRole({
    required List<int> userID,
    required List<int> chatID,
    required pb.ChatRole role,
    required pb.ChatAdminRights rights,
    required String rank,
    String inviteCode = '',
    int pendingRequests = 0,
  }) async {
    await ctx.execute(
      'UPDATE chatGroups SET role = ?, rights = ?, rank = ?, inviteCode = ?, pendingRequests = ? WHERE userID = ? AND chatID = ?;',
      [role.value, _rightsColumn(rights), rank, inviteCode, pendingRequests, userID, chatID],
    );
  }

  /// Изменилось число ждущих заявок (Update.joinRequests).
  Future<void> setGroupPendingRequests({required List<int> userID, required List<int> chatID, required int pending}) async {
    await ctx.execute('UPDATE chatGroups SET pendingRequests = ? WHERE userID = ? AND chatID = ?;', [pending, userID, chatID]);
  }

  /// Основная ссылка заменена (RevokeInviteLink основной) — код новой.
  Future<void> setGroupInviteCode({required List<int> userID, required List<int> chatID, required String code}) async {
    await ctx.execute('UPDATE chatGroups SET inviteCode = ? WHERE userID = ? AND chatID = ?;', [code, userID, chatID]);
  }

  // --- ссылки-приглашения ---

  /// Кэш ссылок группы (последний ответ `InviteLinks` и правки после него).
  Future<List<pb.ChatInviteLink>> inviteLinks({required List<int> userID, required List<int> chatID}) async {
    final rows = await ctx.getAll('SELECT link FROM chatInviteLinks WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    return [for (final row in rows) pb.ChatInviteLink.fromBuffer(row['link'] as List<int>)];
  }

  /// Полный список с сервера заменяет кэш группы.
  Future<void> replaceInviteLinks({required List<int> userID, required List<int> chatID, required List<pb.ChatInviteLink> links}) async {
    await ctx.execute('DELETE FROM chatInviteLinks WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    for (final link in links) {
      await upsertInviteLink(userID: userID, chatID: chatID, link: link);
    }
  }

  /// Ссылка создана / изменена / отозвана (ответ сервера).
  Future<void> upsertInviteLink({required List<int> userID, required List<int> chatID, required pb.ChatInviteLink link}) async {
    await ctx.execute('INSERT OR REPLACE INTO chatInviteLinks (userID, chatID, code, link) VALUES (?, ?, ?, ?);', [
      userID,
      chatID,
      link.code,
      link.writeToBuffer(),
    ]);
  }

  /// Отозванные удалены (DeleteRevokedInviteLinks).
  Future<void> deleteRevokedInviteLinks({required List<int> userID, required List<int> chatID}) async {
    for (final link in await inviteLinks(userID: userID, chatID: chatID)) {
      if (!link.revoked) continue;
      await ctx.execute('DELETE FROM chatInviteLinks WHERE userID = ? AND chatID = ? AND code = ?;', [userID, chatID, link.code]);
    }
  }

  /// Права админа → колонка: без единого права — NULL.
  static Uint8List? _rightsColumn(pb.ChatAdminRights rights) {
    final bytes = rights.writeToBuffer();
    return bytes.isEmpty ? null : bytes;
  }

  /// Сведения изменились (Update.chatInfo) — pts журнала ведёт [setGroupPts].
  Future<void> setGroupInfo({required List<int> userID, required pb.ChatInfo info}) async {
    await ctx.execute('UPDATE chatGroups SET info = ? WHERE userID = ? AND chatID = ?;', [info.writeToBuffer(), userID, info.chatID]);
  }

  Future<void> setGroupPts({required List<int> userID, required List<int> chatID, required int pts}) async {
    await ctx.execute('UPDATE chatGroups SET pts = ? WHERE userID = ? AND chatID = ?;', [pts, userID, chatID]);
  }

  /// Известные участники группы — по дате вступления.
  Future<List<ChatGroupMemberRow>> groupMembers({required List<int> userID, required List<int> chatID}) async {
    final rows = await ctx.getAll('SELECT * FROM chatGroupMembers WHERE userID = ? AND chatID = ? ORDER BY joinedAt ASC;', [
      userID,
      chatID,
    ]);
    return rows.map(ChatGroupMemberRow._fromRow).toList(growable: false);
  }

  /// Участники из `Chats.Members` / `Update.chatMembers` — в кэш.
  Future<void> upsertGroupMembers({required List<int> userID, required List<int> chatID, required List<pb.ChatMember> members}) async {
    for (final m in members) {
      await ctx.execute(
        'INSERT OR REPLACE INTO chatGroupMembers (userID, chatID, memberUserID, role, joinedAt, inviterUserID, rights, rank, promotedByUserID) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);',
        [
          userID,
          chatID,
          m.userID,
          m.role.value,
          m.joinedAt.toInt(),
          m.inviterUserID.isEmpty ? null : m.inviterUserID,
          _rightsColumn(m.rights),
          m.rank,
          m.promotedByUserID.isEmpty ? null : m.promotedByUserID,
        ],
      );
    }
  }

  Future<void> removeGroupMembers({required List<int> userID, required List<int> chatID, required List<List<int>> memberUserIDs}) async {
    for (final member in memberUserIDs) {
      await ctx.execute('DELETE FROM chatGroupMembers WHERE userID = ? AND chatID = ? AND memberUserID = ?;', [userID, chatID, member]);
    }
  }

  /// Первая страница `Chats.Members` — полный снимок известных: заменяет кэш.
  Future<void> replaceGroupMembers({required List<int> userID, required List<int> chatID, required List<pb.ChatMember> members}) async {
    await ctx.execute('DELETE FROM chatGroupMembers WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    await upsertGroupMembers(userID: userID, chatID: chatID, members: members);
  }

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
    int scheduleDate = 0,
  }) async {
    await ctx.execute(
      'INSERT INTO chatOutbox (userID, randomID, chatID, peerUserID, content, silent, createdAt, media, forwardChatID, forwardMessageID, '
      'scheduleDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);',
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
        scheduleDate,
      ],
    );
  }

  /// Отложенное из outbox: перенести ([scheduleDate] > 0) или отправить сразу
  /// (0 — становится обычным неотправленным).
  Future<void> setOutboxScheduleDate({required List<int> userID, required int randomID, required int scheduleDate}) async {
    await ctx.execute('UPDATE chatOutbox SET scheduleDate = ?, failed = 0 WHERE userID = ? AND randomID = ?;', [
      scheduleDate,
      userID,
      randomID,
    ]);
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

  // --- отложенные ---

  /// Мои отложенные в чате, принятые сервером, — по времени отправки.
  Future<List<pb.ScheduledMessage>> scheduled({required List<int> userID, required List<int> chatID}) async {
    final rows = await ctx.getAll('SELECT message FROM chatScheduled WHERE userID = ? AND chatID = ? ORDER BY date ASC, scheduledID ASC;', [
      userID,
      chatID,
    ]);
    return [for (final row in rows) pb.ScheduledMessage.fromBuffer(row['message'] as List<int>)];
  }

  /// Создано или перенесено (с сервера); его неотправленная копия в outbox
  /// больше не нужна.
  Future<void> upsertScheduled({required List<int> userID, required pb.ScheduledMessage message}) async {
    await ctx.execute(
      '''
      INSERT INTO chatScheduled (userID, chatID, scheduledID, date, message) VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(userID, chatID, scheduledID) DO UPDATE SET date = excluded.date, message = excluded.message;
      ''',
      [userID, message.chatID, message.scheduledID.toInt(), message.date.toInt(), message.writeToBuffer()],
    );
    if (message.randomID != 0) await deleteOutbox(userID: userID, randomID: message.randomID.toInt());
  }

  Future<void> deleteScheduled({required List<int> userID, required List<int> chatID, required List<int> scheduledIDs}) async {
    if (scheduledIDs.isEmpty) return;
    final placeholders = List.filled(scheduledIDs.length, '?').join(', ');
    await ctx.execute('DELETE FROM chatScheduled WHERE userID = ? AND chatID = ? AND scheduledID IN ($placeholders);', [
      userID,
      chatID,
      ...scheduledIDs,
    ]);
  }

  /// Полный список чата с сервера заменяет локальный.
  Future<void> replaceScheduled({required List<int> userID, required List<int> chatID, required List<pb.ScheduledMessage> messages}) async {
    await ctx.execute('DELETE FROM chatScheduled WHERE userID = ? AND chatID = ?;', [userID, chatID]);
    for (final message in messages) {
      await upsertScheduled(userID: userID, message: message);
    }
  }
}
