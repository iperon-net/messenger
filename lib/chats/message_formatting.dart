import '../models.dart' as models;

/// Markdown-ярлыки поля ввода → плоский текст + entities (маркеры удаляются),
/// как в Telegram: `**жирный**`, `__курсив__`, `~~зачёркнутый~~`,
/// `||спойлер||`, `` `код` ``, ```` ```блок``` ````, `[текст](https://…)`,
/// строки `> цитата`. Внутри жирного/курсива/зачёркнутого/спойлера разметка
/// может вкладываться; код и блок кода — как есть.
/// См. docs/plans/chats-groups-channels.md, «Форматирование сообщений».
(String, List<models.MessageEntity>) parseMarkdownShortcuts(String input) {
  final (text, entities) = _parseInline(input);
  return _parseQuotes(text, entities);
}

final _inline = <(RegExp, models.MessageEntityType)>[
  (RegExp(r'```(?:[^\n`]*\n)?([\s\S]+?)```'), models.MessageEntityType.pre),
  (RegExp(r'`([^`\n]+)`'), models.MessageEntityType.code),
  (RegExp(r'\[([^\]\n]+)\]\((https?://[^)\s]+)\)'), models.MessageEntityType.textUrl),
  (RegExp(r'\*\*(.+?)\*\*', dotAll: true), models.MessageEntityType.bold),
  (RegExp(r'__(.+?)__', dotAll: true), models.MessageEntityType.italic),
  (RegExp(r'~~(.+?)~~', dotAll: true), models.MessageEntityType.strike),
  (RegExp(r'\|\|(.+?)\|\|', dotAll: true), models.MessageEntityType.spoiler),
];

const _verbatim = {models.MessageEntityType.pre, models.MessageEntityType.code};

(String, List<models.MessageEntity>) _parseInline(String input) {
  final out = StringBuffer();
  final entities = <models.MessageEntity>[];
  var i = 0;
  while (i < input.length) {
    // Самое раннее совпадение среди всех ярлыков (при равенстве — первый в списке).
    RegExpMatch? best;
    models.MessageEntityType? bestType;
    for (final (pattern, type) in _inline) {
      final match = pattern.allMatches(input, i).firstOrNull;
      if (match != null && (best == null || match.start < best.start)) {
        best = match;
        bestType = type;
      }
    }
    if (best == null || bestType == null) {
      out.write(input.substring(i));
      break;
    }
    out.write(input.substring(i, best.start));
    final start = out.length;
    final inner = best.group(1)!;
    if (_verbatim.contains(bestType)) {
      out.write(inner);
      entities.add(models.MessageEntity(type: bestType, offset: start, length: inner.length));
    } else {
      final (text, nested) = _parseInline(inner);
      out.write(text);
      entities.addAll(nested.map((e) => e.copyWith(offset: e.offset + start)));
      entities.add(
        models.MessageEntity(
          type: bestType,
          offset: start,
          length: text.length,
          url: bestType == models.MessageEntityType.textUrl ? best.group(2)! : '',
        ),
      );
    }
    i = best.end;
  }
  entities.sort((a, b) => a.offset != b.offset ? a.offset.compareTo(b.offset) : b.length.compareTo(a.length));
  return (out.toString(), entities);
}

/// Строки, начинающиеся с `>`, — цитата: маркер (с пробелом) удаляется,
/// подряд идущие строки — одна цитата.
(String, List<models.MessageEntity>) _parseQuotes(String text, List<models.MessageEntity> entities) {
  if (!text.contains('>')) return (text, entities);
  final out = StringBuffer();
  final removals = <(int, int)>[]; // (позиция в исходном тексте, сколько удалено)
  final quotes = <(int, int)>[]; // (начало, конец) в итоговом тексте
  int? quoteStart;
  var pos = 0;
  final lines = text.split('\n');
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (i > 0) out.write('\n');
    if (line.startsWith('>')) {
      final marker = line.startsWith('> ') ? 2 : 1;
      removals.add((pos, marker));
      quoteStart ??= out.length;
      out.write(line.substring(marker));
    } else {
      if (quoteStart != null) {
        // Цитата кончилась на предыдущей строке (без её перевода строки).
        quotes.add((quoteStart, out.length - 1));
        quoteStart = null;
      }
      out.write(line);
    }
    pos += line.length + 1;
  }
  if (quoteStart != null) quotes.add((quoteStart, out.length));

  var result = entities;
  for (final (at, count) in removals.reversed) {
    result = _shift(result, at, count);
  }
  result = [
    ...result,
    for (final (start, end) in quotes)
      if (end > start) models.MessageEntity(type: models.MessageEntityType.blockquote, offset: start, length: end - start),
  ]..sort((a, b) => a.offset != b.offset ? a.offset.compareTo(b.offset) : b.length.compareTo(a.length));
  return (out.toString(), result);
}

/// Удалили [count] символов с позиции [at] — сдвигаем entities.
List<models.MessageEntity> _shift(List<models.MessageEntity> entities, int at, int count) {
  return [
    for (final e in entities)
      if (e.offset >= at + count) e.copyWith(offset: e.offset - count) else if (e.end > at) e.copyWith(length: e.length - count) else e,
  ];
}

final _autoPatterns = <(RegExp, models.MessageEntityType)>[
  (RegExp(r'(?:https?://|www\.)[^\s<>"]+[^\s<>".,;:!?)\]]'), models.MessageEntityType.url),
  (RegExp(r'[\w.+-]+@[\w-]+\.[\w.-]+\w'), models.MessageEntityType.email),
  (RegExp(r'(?<![\w@])@[A-Za-z0-9_]{3,}'), models.MessageEntityType.mention),
  (RegExp(r'(?<![\w#])#[\p{L}0-9_]+', unicode: true), models.MessageEntityType.hashtag),
];

/// Ссылки, почта, @упоминания и #хэштеги, найденные в тексте при рендере
/// (их не нужно хранить — детектятся на клиенте). Внутри кода и явных ссылок
/// не ищем.
List<models.MessageEntity> detectAutoEntities(String text, List<models.MessageEntity> existing) {
  final blocked = existing.where(
    (e) => e.type == models.MessageEntityType.code || e.type == models.MessageEntityType.pre || e.type == models.MessageEntityType.textUrl,
  );
  final found = <models.MessageEntity>[];
  for (final (pattern, type) in _autoPatterns) {
    for (final match in pattern.allMatches(text)) {
      final overlaps =
          blocked.any((e) => match.start < e.end && match.end > e.offset) || found.any((e) => match.start < e.end && match.end > e.offset);
      if (!overlaps) found.add(models.MessageEntity(type: type, offset: match.start, length: match.end - match.start));
    }
  }
  return found;
}

/// Обратно в markdown-ярлыки — чтобы отредактировать отправленное сообщение в
/// том же поле ввода (см. [parseMarkdownShortcuts]). Авто-сущности (ссылки,
/// упоминания) в тексте и так видны — их не размечаем.
String toMarkdownShortcuts(String text, List<models.MessageEntity> entities) {
  const markers = {
    models.MessageEntityType.bold: ('**', '**'),
    models.MessageEntityType.italic: ('__', '__'),
    models.MessageEntityType.strike: ('~~', '~~'),
    models.MessageEntityType.spoiler: ('||', '||'),
    models.MessageEntityType.code: ('`', '`'),
    models.MessageEntityType.pre: ('```\n', '```'),
  };
  // Вставки по позициям: закрывающие раньше открывающих в той же точке.
  final opens = <int, List<String>>{};
  final closes = <int, List<String>>{};
  final quoteLines = <int>{};
  for (final e in entities) {
    if (e.type == models.MessageEntityType.blockquote) {
      quoteLines.add(e.offset);
      for (var i = e.offset; i < e.end; i++) {
        if (text[i] == '\n') quoteLines.add(i + 1);
      }
      continue;
    }
    final pair = e.type == models.MessageEntityType.textUrl ? ('[', '](${e.url})') : markers[e.type];
    if (pair == null) continue;
    opens.putIfAbsent(e.offset, () => []).add(pair.$1);
    closes.putIfAbsent(e.end, () => []).insert(0, pair.$2);
  }
  final out = StringBuffer();
  for (var i = 0; i <= text.length; i++) {
    out.writeAll(closes[i] ?? const []);
    if (quoteLines.contains(i)) out.write('> ');
    out.writeAll(opens[i] ?? const []);
    if (i < text.length) out.write(text[i]);
  }
  return out.toString();
}
