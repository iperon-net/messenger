part of 'repositories.dart';

/// Локальное состояние секретного чата (E2EE, чат = пара устройств). Номера —
/// часть схемы `secretChats.state`, не менять.
enum SecretChatLocalState {
  /// Я начал (A): запрос отправлен, ждём, какое устройство собеседника примет.
  waiting,

  /// Мне пришёл запрос (B): ключи сгенерированы и сохранены, Accept ещё не
  /// подтверждён сервером ([SecretChatRecord.request] — что переотправить).
  accepting,

  /// Я принял (B): ждём раскрытия ключа от A.
  accepted,

  /// Я раскрыл ключ (A): храповик готов, Commit ещё не подтверждён сервером.
  /// Писать уже можно — сообщения ждут в outbox за Commit.
  committing,

  /// Рукопожатие завершено.
  ready,

  /// Закрыт (мной, собеседником или сервером).
  discarded;

  /// Можно писать (сообщения уйдут, как только чат будет готов на сервере).
  bool get canSend => this == committing || this == ready;
}

/// Секретный чат этого устройства.
class SecretChatRecord {
  final Uint8List secretChatID;
  final Uint8List peerUserID;

  /// Я начал чат (A).
  final bool outgoing;
  final SecretChatLocalState state;

  /// Ожидающее рукопожатие (байты `SecretChatInitiatorPending` /
  /// `SecretChatResponderPending`), пока чат не готов.
  final Uint8List? pending;

  /// Запрос серверу, который надо (пере)отправить: `Accept` (accepting) или
  /// `Commit` (committing) в виде `SecretChats_Request`.
  final Uint8List? request;

  /// Состояние храповика (`SecretChatRatchetState.toBytes`).
  final Uint8List? ratchet;

  /// Отпечаток ключа (32 байта) и эмодзи для сверки; пусто — ещё нет.
  final Uint8List? fingerprint;
  final List<String> emoji;

  /// Причина закрытия (`SecretUpdate_Discarded_Reason`), -1 — закрыт мной.
  final int discardReason;
  final DateTime createdAt;
  final int unreadCount;

  /// Последнее сообщение (для списка чатов).
  final SecretMessageRecord? lastMessage;

  const SecretChatRecord({
    required this.secretChatID,
    required this.peerUserID,
    required this.outgoing,
    required this.state,
    this.pending,
    this.request,
    this.ratchet,
    this.fingerprint,
    this.emoji = const [],
    this.discardReason = -1,
    required this.createdAt,
    this.unreadCount = 0,
    this.lastMessage,
  });
}

/// Статус сообщения секретного чата. Исходящее: pending → sent → read.
/// Входящее: unread → read (прочитал я). Номера — часть схемы.
enum SecretMessageStatus { pending, sent, read, unread }

class SecretMessageRecord {
  final Uint8List secretChatID;
  final int randomID;
  final bool outgoing;
  final String text;
  final DateTime date;
  final SecretMessageStatus status;
  final int replyToRandomID;

  const SecretMessageRecord({
    required this.secretChatID,
    required this.randomID,
    required this.outgoing,
    required this.text,
    required this.date,
    required this.status,
    this.replyToRandomID = 0,
  });
}

/// Неотправленный конверт: сообщение или служебное действие (прочитано,
/// удалить). Конверт уже зашифрован (храповик продвинут), поэтому
/// переотправляется как есть — тем же randomID.
class SecretOutboxRecord {
  final Uint8List secretChatID;
  final int randomID;
  final Uint8List envelope;

  const SecretOutboxRecord({required this.secretChatID, required this.randomID, required this.envelope});
}

/// Секретные чаты (`secretChats`), их сообщения (`secretMessages`), outbox
/// конвертов (`secretOutbox`) и номер обработанного события очереди
/// устройства (`secretState.qts`). Всё — по `sessionID`: чат привязан к
/// устройству, после перелогина старые чаты не видны (сервер их закрывает).
class SecretChatsRepository {
  final Logger logger;
  final SqliteDatabase db;

  SecretChatsRepository({required this.logger, required this.db});

  static const chatsTable = 'secretChats';
  static const messagesTable = 'secretMessages';
  static const tables = [chatsTable, messagesTable];

  /// Схема (миграция 32; тесты создают её же).
  static const schema = [
    '''
    CREATE TABLE secretChats (
      sessionID BLOB NOT NULL,
      secretChatID BLOB NOT NULL,
      peerUserID BLOB NOT NULL,
      outgoing INTEGER NOT NULL,
      state INTEGER NOT NULL,
      pending BLOB NULL,
      request BLOB NULL,
      ratchet BLOB NULL,
      fingerprint BLOB NULL,
      emoji TEXT NOT NULL DEFAULT '',
      discardReason INTEGER NOT NULL DEFAULT -1,
      unreadCount INTEGER NOT NULL DEFAULT 0,
      createdAt INTEGER NOT NULL,
      updatedAt INTEGER NOT NULL,
      PRIMARY KEY (sessionID, secretChatID)
    );
    ''',
    '''
    CREATE TABLE secretMessages (
      sessionID BLOB NOT NULL,
      secretChatID BLOB NOT NULL,
      randomID INTEGER NOT NULL,
      outgoing INTEGER NOT NULL,
      text TEXT NOT NULL,
      date INTEGER NOT NULL,
      status INTEGER NOT NULL,
      replyToRandomID INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (sessionID, secretChatID, randomID)
    );
    ''',
    'CREATE INDEX idx_secretMessages_date ON secretMessages(sessionID, secretChatID, date);',
    '''
    CREATE TABLE secretOutbox (
      sessionID BLOB NOT NULL,
      secretChatID BLOB NOT NULL,
      randomID INTEGER NOT NULL,
      envelope BLOB NOT NULL,
      createdAt INTEGER NOT NULL,
      PRIMARY KEY (sessionID, randomID)
    );
    ''',
    '''
    CREATE TABLE secretState (
      sessionID BLOB NOT NULL PRIMARY KEY,
      qts INTEGER NOT NULL DEFAULT 0
    );
    ''',
  ];

  static Uint8List _bytes(Object? value) => Uint8List.fromList(value as List<int>);
  static Uint8List? _bytesOrNull(Object? value) => value == null ? null : _bytes(value);

  static SecretMessageRecord _message(Map<String, Object?> row, {String prefix = ''}) => SecretMessageRecord(
    secretChatID: _bytes(row['${prefix}secretChatID']),
    randomID: row['${prefix}randomID'] as int,
    outgoing: row['${prefix}outgoing'] == 1,
    text: row['${prefix}text'] as String,
    date: DateTime.fromMillisecondsSinceEpoch(row['${prefix}date'] as int),
    status: SecretMessageStatus.values[row['${prefix}status'] as int],
    replyToRandomID: row['${prefix}replyToRandomID'] as int,
  );

  static SecretChatRecord _chat(Map<String, Object?> row) {
    final emoji = row['emoji'] as String;
    return SecretChatRecord(
      secretChatID: _bytes(row['secretChatID']),
      peerUserID: _bytes(row['peerUserID']),
      outgoing: row['outgoing'] == 1,
      state: SecretChatLocalState.values[row['state'] as int],
      pending: _bytesOrNull(row['pending']),
      request: _bytesOrNull(row['request']),
      ratchet: _bytesOrNull(row['ratchet']),
      fingerprint: _bytesOrNull(row['fingerprint']),
      emoji: emoji.isEmpty ? const [] : emoji.split(' '),
      discardReason: row['discardReason'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['createdAt'] as int),
      unreadCount: row['unreadCount'] as int,
      lastMessage: row['m_randomID'] == null ? null : _message(row, prefix: 'm_'),
    );
  }

  static const _chatSelect = '''
    SELECT c.*,
      m.secretChatID AS m_secretChatID, m.randomID AS m_randomID, m.outgoing AS m_outgoing, m.text AS m_text,
      m.date AS m_date, m.status AS m_status, m.replyToRandomID AS m_replyToRandomID
    FROM secretChats c
    LEFT JOIN secretMessages m ON m.rowid = (
      SELECT rowid FROM secretMessages
      WHERE sessionID = c.sessionID AND secretChatID = c.secretChatID
      ORDER BY date DESC, rowid DESC LIMIT 1
    )
  ''';

  /// Все секретные чаты устройства (с последним сообщением).
  Future<List<SecretChatRecord>> chats({required List<int> sessionID}) async {
    final rows = await db.getAll('$_chatSelect WHERE c.sessionID = ?;', [sessionID]);
    return [for (final row in rows) _chat(row)];
  }

  Future<SecretChatRecord?> chat({required List<int> sessionID, required List<int> secretChatID}) =>
      _chatIn(db, sessionID: sessionID, secretChatID: secretChatID);

  static Future<SecretChatRecord?> _chatIn(SqliteReadContext ctx, {required List<int> sessionID, required List<int> secretChatID}) async {
    final row = await ctx.getOptional('$_chatSelect WHERE c.sessionID = ? AND c.secretChatID = ?;', [sessionID, secretChatID]);
    return row == null ? null : _chat(row);
  }

  /// Новый чат (A — после Create, B — после получения запроса). Уже есть —
  /// не трогаем (повтор события).
  Future<bool> insertChat({
    required List<int> sessionID,
    required List<int> secretChatID,
    required List<int> peerUserID,
    required bool outgoing,
    required SecretChatLocalState state,
    required Uint8List pending,
    Uint8List? request,
    required DateTime createdAt,
  }) async {
    return db.writeTransaction((tx) async {
      await tx.execute(
        '''
        INSERT OR IGNORE INTO secretChats (sessionID, secretChatID, peerUserID, outgoing, state, pending, request, createdAt, updatedAt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
        ''',
        [
          sessionID,
          secretChatID,
          peerUserID,
          outgoing ? 1 : 0,
          state.index,
          pending,
          request,
          createdAt.millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch,
        ],
      );
      return (await tx.get('SELECT changes() AS n;'))['n'] == 1;
    });
  }

  /// Рукопожатие продвинулось: новое состояние и что переотправить; [ratchet]
  /// / [fingerprint] — когда ключ уже выведен. [pending] = null стирает
  /// ожидающие ключи (больше не нужны).
  Future<void> setHandshake({
    required List<int> sessionID,
    required List<int> secretChatID,
    required SecretChatLocalState state,
    Uint8List? pending,
    Uint8List? request,
    Uint8List? ratchet,
    Uint8List? fingerprint,
    List<String> emoji = const [],
  }) async {
    await db.execute(
      '''
      UPDATE secretChats SET state = ?, pending = ?, request = ?,
        ratchet = COALESCE(?, ratchet), fingerprint = COALESCE(?, fingerprint),
        emoji = CASE WHEN ? = '' THEN emoji ELSE ? END, updatedAt = ?
      WHERE sessionID = ? AND secretChatID = ?;
      ''',
      [
        state.index,
        pending,
        request,
        ratchet,
        fingerprint,
        emoji.join(' '),
        emoji.join(' '),
        DateTime.now().millisecondsSinceEpoch,
        sessionID,
        secretChatID,
      ],
    );
  }

  /// Чат закрыт: ключи стираем (forward secrecy — прочитать перехваченное
  /// задним числом нечем). [deleteHistory] — и переписку.
  Future<void> discard({
    required List<int> sessionID,
    required List<int> secretChatID,
    required int reason,
    bool deleteHistory = false,
  }) async {
    await db.writeTransaction((tx) async {
      await tx.execute(
        '''
        UPDATE secretChats SET state = ?, pending = NULL, request = NULL, ratchet = NULL, discardReason = ?, updatedAt = ?
        WHERE sessionID = ? AND secretChatID = ?;
        ''',
        [SecretChatLocalState.discarded.index, reason, DateTime.now().millisecondsSinceEpoch, sessionID, secretChatID],
      );
      await tx.execute('DELETE FROM secretOutbox WHERE sessionID = ? AND secretChatID = ?;', [sessionID, secretChatID]);
      if (deleteHistory) {
        await tx.execute('DELETE FROM secretMessages WHERE sessionID = ? AND secretChatID = ?;', [sessionID, secretChatID]);
        await tx.execute('UPDATE secretChats SET unreadCount = 0 WHERE sessionID = ? AND secretChatID = ?;', [sessionID, secretChatID]);
      }
    });
  }

  /// Удалить чат с устройства совсем (вместе с перепиской).
  Future<void> delete({required List<int> sessionID, required List<int> secretChatID}) async {
    await db.writeTransaction((tx) async {
      for (final table in const ['secretMessages', 'secretOutbox', 'secretChats']) {
        await tx.execute('DELETE FROM $table WHERE sessionID = ? AND secretChatID = ?;', [sessionID, secretChatID]);
      }
    });
  }

  /// Входящий конверт расшифрован: новое состояние храповика вместе с его
  /// результатом — в одной транзакции (краш между ними — вечный рассинхрон).
  /// [apply] — что сделать с перепиской (вставить сообщение, отметить
  /// прочитанные, удалить) в той же транзакции.
  Future<void> applyIncoming({
    required List<int> sessionID,
    required List<int> secretChatID,
    required Uint8List ratchet,
    required Future<void> Function(SecretChatsTx tx) apply,
  }) async {
    await db.writeTransaction((tx) async {
      await tx.execute('UPDATE secretChats SET ratchet = ?, updatedAt = ? WHERE sessionID = ? AND secretChatID = ?;', [
        ratchet,
        DateTime.now().millisecondsSinceEpoch,
        sessionID,
        secretChatID,
      ]);
      await apply(SecretChatsTx._(tx, sessionID, secretChatID));
    });
  }

  /// Изменить переписку без храповика (например, отметить прочитанным в уже
  /// закрытом чате).
  Future<void> update({
    required List<int> sessionID,
    required List<int> secretChatID,
    required Future<void> Function(SecretChatsTx tx) apply,
  }) async {
    await db.writeTransaction((tx) => apply(SecretChatsTx._(tx, sessionID, secretChatID)));
  }

  /// Исходящий конверт зашифрован: состояние храповика + конверт в outbox (+
  /// само сообщение, если это не служебное действие) — в одной транзакции.
  Future<void> queueOutgoing({
    required List<int> sessionID,
    required List<int> secretChatID,
    required Uint8List ratchet,
    required int randomID,
    required Uint8List envelope,
    SecretMessageRecord? message,
    Future<void> Function(SecretChatsTx tx)? apply,
  }) async {
    await db.writeTransaction((tx) async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await tx.execute('UPDATE secretChats SET ratchet = ?, updatedAt = ? WHERE sessionID = ? AND secretChatID = ?;', [
        ratchet,
        now,
        sessionID,
        secretChatID,
      ]);
      await tx.execute('INSERT INTO secretOutbox (sessionID, secretChatID, randomID, envelope, createdAt) VALUES (?, ?, ?, ?, ?);', [
        sessionID,
        secretChatID,
        randomID,
        envelope,
        now,
      ]);
      final scoped = SecretChatsTx._(tx, sessionID, secretChatID);
      if (message != null) await scoped.insertMessage(message);
      if (apply != null) await apply(scoped);
    });
  }

  /// Неотправленные конверты по порядку постановки.
  Future<List<SecretOutboxRecord>> outbox({required List<int> sessionID}) async {
    final rows = await db.getAll(
      'SELECT secretChatID, randomID, envelope FROM secretOutbox WHERE sessionID = ? ORDER BY createdAt, rowid;',
      [sessionID],
    );
    return [
      for (final row in rows)
        SecretOutboxRecord(secretChatID: _bytes(row['secretChatID']), randomID: row['randomID'] as int, envelope: _bytes(row['envelope'])),
    ];
  }

  /// Конверт принят сервером: из outbox, исходящее сообщение — «отправлено»
  /// со временем сервера [date] (как у входящих — общий порядок у обоих).
  Future<void> outboxSent({required List<int> sessionID, required List<int> secretChatID, required int randomID, DateTime? date}) async {
    await db.writeTransaction((tx) async {
      await tx.execute('DELETE FROM secretOutbox WHERE sessionID = ? AND randomID = ?;', [sessionID, randomID]);
      await tx.execute(
        '''
        UPDATE secretMessages SET status = ?, date = COALESCE(?, date)
        WHERE sessionID = ? AND secretChatID = ? AND randomID = ? AND status = ?;
        ''',
        [
          SecretMessageStatus.sent.index,
          date?.millisecondsSinceEpoch,
          sessionID,
          secretChatID,
          randomID,
          SecretMessageStatus.pending.index,
        ],
      );
    });
  }

  /// Переписка чата по времени.
  Future<List<SecretMessageRecord>> messages({required List<int> sessionID, required List<int> secretChatID}) async {
    final rows = await db.getAll('SELECT * FROM secretMessages WHERE sessionID = ? AND secretChatID = ? ORDER BY date, rowid;', [
      sessionID,
      secretChatID,
    ]);
    return [for (final row in rows) _message(row)];
  }

  /// Непрочитанные мной входящие (randomID).
  Future<List<int>> unreadIncoming({required List<int> sessionID, required List<int> secretChatID}) async {
    final rows = await db.getAll(
      'SELECT randomID FROM secretMessages WHERE sessionID = ? AND secretChatID = ? AND outgoing = 0 AND status = ?;',
      [sessionID, secretChatID, SecretMessageStatus.unread.index],
    );
    return [for (final row in rows) row['randomID'] as int];
  }

  /// Номер последнего обработанного события очереди устройства.
  Future<int> qts({required List<int> sessionID}) async {
    final row = await db.getOptional('SELECT qts FROM secretState WHERE sessionID = ?;', [sessionID]);
    return row == null ? 0 : row['qts'] as int;
  }

  Future<void> setQts({required List<int> sessionID, required int qts}) async {
    await db.execute(
      'INSERT INTO secretState (sessionID, qts) VALUES (?, ?) ON CONFLICT(sessionID) DO UPDATE SET qts = MAX(qts, excluded.qts);',
      [sessionID, qts],
    );
  }
}

/// Изменения переписки одного чата внутри транзакции [SecretChatsRepository].
class SecretChatsTx {
  final SqliteWriteContext _tx;
  final List<int> _sessionID;
  final List<int> _secretChatID;

  SecretChatsTx._(this._tx, this._sessionID, this._secretChatID);

  /// Новое сообщение (повтор randomID — игнор); входящее непрочитанное +1 к
  /// счётчику.
  Future<void> insertMessage(SecretMessageRecord message) async {
    await _tx.execute(
      '''
      INSERT OR IGNORE INTO secretMessages (sessionID, secretChatID, randomID, outgoing, text, date, status, replyToRandomID)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?);
      ''',
      [
        _sessionID,
        _secretChatID,
        message.randomID,
        message.outgoing ? 1 : 0,
        message.text,
        message.date.millisecondsSinceEpoch,
        message.status.index,
        message.replyToRandomID,
      ],
    );
    final inserted = (await _tx.get('SELECT changes() AS n;'))['n'] == 1;
    if (inserted && !message.outgoing && message.status == SecretMessageStatus.unread) {
      await _tx.execute('UPDATE secretChats SET unreadCount = unreadCount + 1 WHERE sessionID = ? AND secretChatID = ?;', [
        _sessionID,
        _secretChatID,
      ]);
    }
  }

  /// Собеседник прочитал мои сообщения.
  Future<void> markOutgoingRead(List<int> randomIDs) async {
    for (final randomID in randomIDs) {
      await _tx.execute(
        'UPDATE secretMessages SET status = ? WHERE sessionID = ? AND secretChatID = ? AND randomID = ? AND outgoing = 1;',
        [SecretMessageStatus.read.index, _sessionID, _secretChatID, randomID],
      );
    }
  }

  /// Я прочитал входящие: статус и счётчик непрочитанных.
  Future<void> markIncomingRead(List<int> randomIDs) async {
    for (final randomID in randomIDs) {
      await _tx.execute(
        'UPDATE secretMessages SET status = ? WHERE sessionID = ? AND secretChatID = ? AND randomID = ? AND outgoing = 0;',
        [SecretMessageStatus.read.index, _sessionID, _secretChatID, randomID],
      );
    }
    await _recountUnread();
  }

  /// Удалить сообщения (у обоих — по действию собеседника или моему).
  Future<void> deleteMessages(List<int> randomIDs) async {
    for (final randomID in randomIDs) {
      await _tx.execute('DELETE FROM secretMessages WHERE sessionID = ? AND secretChatID = ? AND randomID = ?;', [
        _sessionID,
        _secretChatID,
        randomID,
      ]);
    }
    await _recountUnread();
  }

  Future<void> _recountUnread() async {
    await _tx.execute(
      '''
      UPDATE secretChats SET unreadCount = (
        SELECT COUNT(*) FROM secretMessages
        WHERE sessionID = ? AND secretChatID = ? AND outgoing = 0 AND status = ?
      ) WHERE sessionID = ? AND secretChatID = ?;
      ''',
      [_sessionID, _secretChatID, SecretMessageStatus.unread.index, _sessionID, _secretChatID],
    );
  }
}
