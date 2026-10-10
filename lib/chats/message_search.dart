import '../protobuf/protos/chats_v1.pb.dart' as pb;

/// Локальный поиск по сообщениям (SQLite FTS5, см. миграцию 18). Сервер
/// искать не может — содержимое в Mongo зашифровано (см. «Решения» в
/// docs/plans/chats-groups-channels.md), поэтому история открытых чатов
/// докачивается целиком (`ChatsSync.backfill`) и ищется на устройстве.

/// «ё» → «е»: `unicode61` снимает диакритику только у латиницы, а «ё» в
/// переписке пишут через раз — ищем одинаково (и в индексе, и в запросе).
String _foldYo(String s) => s.replaceAll('ё', 'е').replaceAll('Ё', 'Е');

/// Текст сообщения для индекса: сам текст и имена файлов вложений.
String messageSearchText(pb.MessageContent content) => _foldYo(
  [
    content.text,
    for (final media in content.media)
      if (media.fileName.isNotEmpty) media.fileName,
  ].where((s) => s.trim().isNotEmpty).join('\n'),
);

/// Запрос пользователя → выражение FTS5 MATCH: каждое слово — по началу
/// (`"при"*` находит «привет»), все слова должны встретиться. Кавычки и
/// операторы FTS из ввода экранируются. `null` — искать нечего.
String? ftsMatchQuery(String query) {
  final words = _foldYo(
    query,
  ).split(RegExp(r'\s+')).map((w) => w.replaceAll('"', '').trim()).where((w) => w.isNotEmpty).toList(growable: false);
  if (words.isEmpty) return null;
  return words.map((w) => '"$w"*').join(' ');
}

/// Индекс поиска (миграция 18): FTS5 с внешним содержимым — сама таблица
/// `chatMessages` по rowid (колонка `searchText` = [messageSearchText]) — и
/// триггеры, держащие индекс в синхроне при любых вставках, правках и
/// удалениях (в т.ч. удалении диалога целиком). `unicode61` складывает
/// регистр и для кириллицы; «ё» сводится к «е» в Dart (`_foldYo`).
/// Не менять: это схема миграции 18 — новая схема идёт новой миграцией.
const chatMessagesFtsSchema = [
  """
  CREATE VIRTUAL TABLE chatMessagesFts USING fts5(
    searchText,
    content='chatMessages',
    content_rowid='rowid',
    tokenize='unicode61 remove_diacritics 2'
  );
  """,
  """
  CREATE TRIGGER chatMessagesFtsInsert AFTER INSERT ON chatMessages BEGIN
    INSERT INTO chatMessagesFts(rowid, searchText) VALUES (new.rowid, new.searchText);
  END;
  """,
  """
  CREATE TRIGGER chatMessagesFtsDelete AFTER DELETE ON chatMessages BEGIN
    INSERT INTO chatMessagesFts(chatMessagesFts, rowid, searchText) VALUES ('delete', old.rowid, old.searchText);
  END;
  """,
  """
  CREATE TRIGGER chatMessagesFtsUpdate AFTER UPDATE OF searchText ON chatMessages BEGIN
    INSERT INTO chatMessagesFts(chatMessagesFts, rowid, searchText) VALUES ('delete', old.rowid, old.searchText);
    INSERT INTO chatMessagesFts(rowid, searchText) VALUES (new.rowid, new.searchText);
  END;
  """,
];

/// Запрос поиска по чату (тот же, что в `ChatsRepository.searchMessages`).
const chatMessagesSearchSql = """
  SELECT m.messageID FROM chatMessagesFts f
  JOIN chatMessages m ON m.rowid = f.rowid
  WHERE chatMessagesFts MATCH ? AND m.userID = ? AND m.chatID = ?
  ORDER BY m.messageID DESC LIMIT ?;
  """;
