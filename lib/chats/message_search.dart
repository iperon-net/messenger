import '../protobuf/protos/chats_v1.pb.dart' as pb;
import 'chats_data_source.dart';

/// Поиск по сообщениям чата (docs/plans/chats-groups.md, «Поиск по
/// сообщениям (слепой индекс)»): сразу — локально (SQLite FTS5, см.
/// миграцию 18; по началу слова, на устройстве текст расшифрован), и
/// параллельно — на сервере (`Messages.Search`, слепой индекс основ слов,
/// подэтап 3.6): он находит то, чего на устройстве нет. Ответы сливаются
/// [mergeSearchResults].

/// «ё» → «е»: `unicode61` снимает диакритику только у латиницы, а «ё» в
/// переписке пишут через раз — ищем одинаково (и в индексе, и в запросе).
String _foldYo(String s) => s.replaceAll('ё', 'е').replaceAll('Ё', 'Е');

/// Текст сообщения для индекса: сам текст и имена файлов вложений.
String messageSearchText(pb.MessageContent content) => _foldYo(
  [
    content.text,
    if (content.hasPoll()) ...[content.poll.question, ...content.poll.options],
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

/// Найденное на устройстве ([local]) и на сервере ([server]) — одним списком
/// без повторов, от новых к старым (по messageID). Без серверных — локальные
/// как есть (демо: id не числа).
List<String> mergeSearchResults(List<String> local, List<String> server) {
  if (server.isEmpty) return local;
  final seen = <String>{};
  final merged = [
    for (final id in [...local, ...server])
      if (seen.add(id)) id,
  ];
  merged.sort((a, b) => (int.tryParse(b) ?? 0).compareTo(int.tryParse(a) ?? 0));
  return merged;
}

/// Поиск на сервере по одному запросу (окно чата): собранные страницы,
/// продолжение и чем закончился последний запрос. Новый запрос — новая
/// сессия: ответ сервера на прежнюю выбрасывается (сравнение по identity).
class ServerSearchSession {
  /// Запрос как введён (в state окна он попадает только вместе с результатами).
  final String query;

  ServerSearchSession(this.query);

  /// Найденное сервером — по страницам, от новых к старым.
  List<String> get results => _results;
  List<String> _results = const [];

  /// Продолжение (`nextOffsetID`): null — дальше нет / ещё не спрашивали.
  String? get next => _next;
  String? _next;

  /// Чем закончился последний запрос (null — ещё не спрашивали).
  ServerSearchStatus? get status => _status;
  ServerSearchStatus? _status;

  /// Идущий запрос страницы — один за раз.
  Future<void>? inFlight;

  /// Есть что искать.
  bool get active => query.trim().isNotEmpty;

  /// Последний запрос не дошёл — нет сети: пометка «показаны только
  /// сообщения на устройстве», при подключении — повторить ([retryMore]).
  bool get offline => _status == ServerSearchStatus.offline;

  /// На сервере есть старше уже показанного.
  bool get hasMore => _next != null;

  /// Повтор после офлайна — продолжение (первая страница уже была).
  bool get retryMore => _next != null;

  /// Ответ на страницу ([more] — продолжение по [next]). Офлайн — собранное
  /// и продолжение остаются (повторим); QUERY_TOO_SHORT / не спрашиваем —
  /// дальше не идём, остаются локальные.
  void apply(ServerSearchPage page, {required bool more}) {
    _status = page.status;
    switch (page.status) {
      case ServerSearchStatus.ok:
        final seen = {..._results};
        _results = more ? [..._results, ...page.ids.where(seen.add)] : page.ids;
        _next = page.nextOffsetID;
      case ServerSearchStatus.offline:
        break;
      case ServerSearchStatus.tooShort:
      case ServerSearchStatus.skipped:
        _next = null;
    }
  }

  /// Слить с найденным на устройстве ([mergeSearchResults]).
  List<String> merge(List<String> local) => mergeSearchResults(local, _results);

  /// Перед [index] в [merged] (по направлению к старым) могут быть найденные
  /// сервером, но ещё не спрошенные: сервер смотрел только новее [next].
  /// Последнее найденное — тоже (вдруг на сервере есть старше).
  bool needsPage(List<String> merged, int index) {
    final next = int.tryParse(_next ?? '');
    if (next == null) return false;
    if (index >= merged.length) return true;
    final id = int.tryParse(merged[index]);
    return id != null && id < next;
  }
}
