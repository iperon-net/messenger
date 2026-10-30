import '../models.dart' as models;

/// Markdown-ярлыки поля ввода → плоский текст + entities (маркеры удаляются),
/// как в Telegram: `**жирный**`, `__курсив__`, `~~зачёркнутый~~`,
/// `++подчёркнутый++`, `||спойлер||`, `` `код` ``, ```` ```блок``` ````,
/// `[текст](https://…)`, упоминание `[текст](mention:userID)`, строки
/// `> цитата` и `>> сворачиваемая цитата`. Внутри жирного/курсива/
/// подчёркнутого/зачёркнутого/спойлера разметка может вкладываться; код и
/// блок кода — как есть.
/// См. docs/plans/chats-groups-channels.md, «Форматирование сообщений».
(String, List<models.MessageEntity>) parseMarkdownShortcuts(String input) {
  final (text, entities) = _parseInline(input);
  return _parseQuotes(text, entities);
}

final _inline = <(RegExp, models.MessageEntityType)>[
  (RegExp(r'```(?:[^\n`]*\n)?([\s\S]+?)```'), models.MessageEntityType.pre),
  (RegExp(r'`([^`\n]+)`'), models.MessageEntityType.code),
  (RegExp(r'\[([^\]\n]+)\]\((https?://[^)\s]+)\)'), models.MessageEntityType.textUrl),
  (RegExp(r'\[([^\]\n]+)\]\(mention:([\w-]+)\)'), models.MessageEntityType.mentionName),
  (RegExp(r'\*\*(.+?)\*\*', dotAll: true), models.MessageEntityType.bold),
  (RegExp(r'__(.+?)__', dotAll: true), models.MessageEntityType.italic),
  (RegExp(r'\+\+(.+?)\+\+', dotAll: true), models.MessageEntityType.underline),
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
          userID: bestType == models.MessageEntityType.mentionName ? best.group(2)! : '',
        ),
      );
    }
    i = best.end;
  }
  entities.sort((a, b) => a.offset != b.offset ? a.offset.compareTo(b.offset) : b.length.compareTo(a.length));
  return (out.toString(), entities);
}

/// Строки, начинающиеся с `>`, — цитата, с `>>` — сворачиваемая цитата:
/// маркер (с пробелом) удаляется, подряд идущие строки одного вида — одна
/// цитата.
(String, List<models.MessageEntity>) _parseQuotes(String text, List<models.MessageEntity> entities) {
  if (!text.contains('>')) return (text, entities);
  final out = StringBuffer();
  final removals = <(int, int)>[]; // (позиция в исходном тексте, сколько удалено)
  final quotes = <(int, int, bool)>[]; // (начало, конец, сворачиваемая) в итоговом тексте
  int? quoteStart;
  var quoteExpandable = false;
  var pos = 0;
  final lines = text.split('\n');
  void close(int end) {
    if (quoteStart != null) quotes.add((quoteStart!, end, quoteExpandable));
    quoteStart = null;
  }

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (i > 0) out.write('\n');
    final kind = quoteKind(line);
    if (kind != null) {
      final expandable = kind == ComposeFormat.quoteExpandable;
      // Сменился вид цитаты — новая цитата (без перевода строки предыдущей).
      if (quoteStart != null && quoteExpandable != expandable) close(out.length - 1);
      final marker = quoteMarkerLength(line);
      removals.add((pos, marker));
      quoteStart ??= out.length;
      quoteExpandable = expandable;
      out.write(line.substring(marker));
    } else {
      // Цитата кончилась на предыдущей строке (без её перевода строки).
      close(out.length - 1);
      out.write(line);
    }
    pos += line.length + 1;
  }
  close(out.length);

  var result = entities;
  for (final (at, count) in removals.reversed) {
    result = _shift(result, at, count);
  }
  result = [
    ...result,
    for (final (start, end, expandable) in quotes)
      if (end > start)
        models.MessageEntity(type: models.MessageEntityType.blockquote, offset: start, length: end - start, expandable: expandable),
  ]..sort((a, b) => a.offset != b.offset ? a.offset.compareTo(b.offset) : b.length.compareTo(a.length));
  return (out.toString(), result);
}

/// Вид цитаты строки поля ввода: `>> ` — сворачиваемая, `> ` — обычная,
/// `null` — не цитата.
ComposeFormat? quoteKind(String line) =>
    line.startsWith('>>') ? ComposeFormat.quoteExpandable : (line.startsWith('>') ? ComposeFormat.quote : null);

/// Длина маркера цитаты в начале строки (с пробелом после него).
int quoteMarkerLength(String line) {
  final arrows = line.startsWith('>>') ? 2 : (line.startsWith('>') ? 1 : 0);
  return arrows == 0 ? 0 : (line.startsWith(' ', arrows) ? arrows + 1 : arrows);
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

/// Первая ссылка сообщения — для превью ссылки: явная `[текст](url)` или
/// найденная в тексте (`www.…` → `https://www.…`); `null` — ссылок нет.
String? firstLinkUrl(String text, List<models.MessageEntity> entities) {
  final links = [
    for (final e in entities)
      if (e.type == models.MessageEntityType.textUrl && e.url.isNotEmpty) (e.offset, e.url),
    for (final e in detectAutoEntities(text, entities))
      if (e.type == models.MessageEntityType.url) (e.offset, text.substring(e.offset, e.end)),
  ]..sort((a, b) => a.$1.compareTo(b.$1));
  if (links.isEmpty) return null;
  final url = links.first.$2;
  return url.startsWith('www.') ? 'https://$url' : url;
}

/// Обратно в markdown-ярлыки — чтобы отредактировать отправленное сообщение в
/// том же поле ввода (см. [parseMarkdownShortcuts]). Авто-сущности (ссылки,
/// упоминания) в тексте и так видны — их не размечаем.
String toMarkdownShortcuts(String text, List<models.MessageEntity> entities) {
  const markers = {
    models.MessageEntityType.bold: ('**', '**'),
    models.MessageEntityType.italic: ('__', '__'),
    models.MessageEntityType.underline: ('++', '++'),
    models.MessageEntityType.strike: ('~~', '~~'),
    models.MessageEntityType.spoiler: ('||', '||'),
    models.MessageEntityType.code: ('`', '`'),
    models.MessageEntityType.pre: ('```\n', '```'),
  };
  // Вставки по позициям: закрывающие раньше открывающих в той же точке.
  final opens = <int, List<String>>{};
  final closes = <int, List<String>>{};
  final quoteLines = <int, String>{};
  for (final e in normalizeComposeEntities(text, entities)) {
    if (e.type == models.MessageEntityType.blockquote) {
      final marker = e.expandable ? '>> ' : '> ';
      quoteLines[e.offset] = marker;
      for (var i = e.offset; i < e.end; i++) {
        if (text[i] == '\n') quoteLines[i + 1] = marker;
      }
      continue;
    }
    final pair = switch (e.type) {
      models.MessageEntityType.textUrl => ('[', '](${e.url})'),
      models.MessageEntityType.mentionName when e.userID.isNotEmpty => ('[', '](mention:${e.userID})'),
      _ => markers[e.type],
    };
    if (pair == null) continue;
    opens.putIfAbsent(e.offset, () => []).add(pair.$1);
    closes.putIfAbsent(e.end, () => []).insert(0, pair.$2);
  }
  final out = StringBuffer();
  for (var i = 0; i <= text.length; i++) {
    out.writeAll(closes[i] ?? const []);
    if (quoteLines[i] case final marker?) out.write(marker);
    out.writeAll(opens[i] ?? const []);
    if (i < text.length) out.write(text[i]);
  }
  return out.toString();
}

/// Пункты меню форматирования выделенного текста в поле ввода.
enum ComposeFormat { bold, italic, underline, strike, spoiler, code, pre, link, mention, quote, quoteExpandable, plain }

/// Поле ввода: плоский текст, его разметка и выделение [start]..[end].
typedef ComposeEdit = ({String text, List<models.MessageEntity> entities, int start, int end});

/// Разметка, которую поле ввода хранит и показывает (как в Telegram — сразу
/// жирным, курсивом и т. д., без ярлыков); ссылки, @упоминания и хэштеги в
/// тексте и так видны — они авто ([detectAutoEntities]).
const composeEntityTypes = {
  models.MessageEntityType.bold,
  models.MessageEntityType.italic,
  models.MessageEntityType.underline,
  models.MessageEntityType.strike,
  models.MessageEntityType.spoiler,
  models.MessageEntityType.code,
  models.MessageEntityType.pre,
  models.MessageEntityType.textUrl,
  models.MessageEntityType.mentionName,
  models.MessageEntityType.blockquote,
};

const _inlineFormats = {
  ComposeFormat.bold: models.MessageEntityType.bold,
  ComposeFormat.italic: models.MessageEntityType.italic,
  ComposeFormat.underline: models.MessageEntityType.underline,
  ComposeFormat.strike: models.MessageEntityType.strike,
  ComposeFormat.spoiler: models.MessageEntityType.spoiler,
};

/// Ссылка и упоминание по имени.
const _links = {models.MessageEntityType.textUrl, models.MessageEntityType.mentionName};

/// Правка текста поля [oldText] → [newText] (каретка — [caret], `-1` —
/// неизвестна): сдвигает [entities]. Формат — только на том, что выделяли:
/// напечатанное внутри него — в нём же, а у краёв (сразу до или после) —
/// уже без него; заменённое выделение берёт формат его начала; удалённое
/// целиком — пропадает.
List<models.MessageEntity> shiftComposeEntities(String oldText, String newText, List<models.MessageEntity> entities, {int caret = -1}) {
  if (entities.isEmpty || oldText == newText) return entities;
  final (a, b, n) = _textDiff(oldText, newText, caret);
  final result = <models.MessageEntity>[];
  for (final e in entities) {
    final o = e.offset, end = e.end;
    final start = o < a || (o == a && b > a) ? o : (o >= b ? o - (b - a) + n : a + n);
    final int stop;
    if (end > b || (end == b && b > a)) {
      stop = end - (b - a) + n;
    } else if (end < a) {
      stop = end;
    } else if (end == a) {
      stop = a;
    } else {
      stop = a + n;
    }
    if (stop > start) result.add(e.copyWith(offset: start, length: stop - start));
  }
  return result;
}

/// Что поменялось: в старом тексте заменён кусок [a, b) на [n] новых символов.
/// Каретка уточняет место при повторах (`аа` → `ааа`).
(int, int, int) _textDiff(String oldText, String newText, int caret) {
  final delta = newText.length - oldText.length;
  var p = 0;
  final shortest = oldText.length < newText.length ? oldText.length : newText.length;
  while (p < shortest && oldText.codeUnitAt(p) == newText.codeUnitAt(p)) {
    p++;
  }
  if (caret >= 0) {
    // Вставка, кончающаяся у каретки, / удаление от каретки.
    final a = delta > 0 ? caret - delta : caret;
    if (delta != 0 && a >= 0 && a <= p) {
      final removed = delta < 0 ? -delta : 0;
      if (a + removed <= oldText.length && newText.substring(a + (delta > 0 ? delta : 0)) == oldText.substring(a + removed)) {
        return (a, a + removed, delta > 0 ? delta : 0);
      }
    }
  }
  var s = 0;
  while (s < shortest - p && oldText.codeUnitAt(oldText.length - 1 - s) == newText.codeUnitAt(newText.length - 1 - s)) {
    s++;
  }
  return (p, oldText.length - s, newText.length - s - p);
}

/// Какие форматы уже стоят на выделении — галочки в меню; повторный выбор
/// снимает только этот формат.
Set<ComposeFormat> activeComposeFormats(ComposeEdit value) {
  final (:text, :entities, :start, :end) = value;
  if (start < 0 || end <= start || end > text.length) return const {};
  final (from, to) = _lines(text, start, end);
  return {
    for (final MapEntry(key: format, value: type) in _inlineFormats.entries)
      if (_covered(entities, start, end, (e) => e.type == type)) format,
    if (_covered(entities, start, end, (e) => e.type == models.MessageEntityType.code)) ComposeFormat.code,
    if (_covered(entities, start, end, (e) => e.type == models.MessageEntityType.pre)) ComposeFormat.pre,
    if (entities.any((e) => e.type == models.MessageEntityType.textUrl && e.offset < end && start < e.end)) ComposeFormat.link,
    if (entities.any((e) => e.type == models.MessageEntityType.mentionName && e.offset < end && start < e.end)) ComposeFormat.mention,
    if (_covered(entities, from, to, (e) => e.type == models.MessageEntityType.blockquote && !e.expandable)) ComposeFormat.quote,
    if (_covered(entities, from, to, (e) => e.type == models.MessageEntityType.blockquote && e.expandable)) ComposeFormat.quoteExpandable,
  };
}

/// Применить [format] к выделению: поставить, а если он уже стоит
/// ([activeComposeFormats]) — снять только его; для [ComposeFormat.link] —
/// ссылка на [url], для [ComposeFormat.mention] — упоминание [userID],
/// цитаты — на целые строки, [ComposeFormat.plain] — убрать всю разметку.
/// Текст не меняется — только разметка (и выделение у цитат).
ComposeEdit applyComposeFormat(ComposeEdit value, ComposeFormat format, {String url = '', String userID = ''}) {
  final (:text, :entities, :start, :end) = value;
  if (start < 0 || end <= start || end > text.length) return value;
  final active = activeComposeFormats(value).contains(format);
  ComposeEdit result(List<models.MessageEntity> entities, [int? from, int? to]) =>
      (text: text, entities: _sorted(entities), start: from ?? start, end: to ?? end);
  final selected = text.substring(start, end);
  switch (format) {
    case ComposeFormat.link || ComposeFormat.mention:
      final type = format == ComposeFormat.link ? models.MessageEntityType.textUrl : models.MessageEntityType.mentionName;
      bool isLink(models.MessageEntity e) => _links.contains(e.type) && e.offset < end && start < e.end;
      if (active) {
        return result([
          for (final e in entities)
            if (!(e.type == type && isLink(e))) e,
        ]);
      }
      final address = format == ComposeFormat.link ? url : userID;
      // В ярлыке `[текст](адрес)` текст без `]` и переводов строки.
      if (address.isEmpty || selected.contains(RegExp(r'[\]\n]'))) return value;
      return result([
        for (final e in entities)
          if (!isLink(e)) e,
        models.MessageEntity(
          type: type,
          offset: start,
          length: end - start,
          url: type == models.MessageEntityType.textUrl ? address : '',
          userID: type == models.MessageEntityType.mentionName ? address : '',
        ),
      ]);
    case ComposeFormat.quote || ComposeFormat.quoteExpandable:
      final (from, to) = _lines(text, start, end);
      bool isQuote(models.MessageEntity e) => e.type == models.MessageEntityType.blockquote;
      final rest = _remove(entities, from, to, isQuote);
      if (active || to <= from) return result(rest, from, to);
      return result(
        [
          ...rest,
          models.MessageEntity(
            type: models.MessageEntityType.blockquote,
            offset: from,
            length: to - from,
            expandable: format == ComposeFormat.quoteExpandable,
          ),
        ],
        from,
        to,
      );
    case ComposeFormat.plain:
      return result(_remove(entities, start, end, (e) => true));
    case ComposeFormat.code when selected.contains('\n'):
      // Многострочный моноширинный — блок кода.
      return applyComposeFormat(value, ComposeFormat.pre);
    case ComposeFormat.code || ComposeFormat.pre:
      final type = format == ComposeFormat.code ? models.MessageEntityType.code : models.MessageEntityType.pre;
      if (active) return result(_remove(entities, start, end, (e) => e.type == type));
      // Код — как есть: другой разметки внутри нет.
      final rest = _remove(entities, start, end, (e) => e.type != models.MessageEntityType.blockquote);
      return result([...rest, models.MessageEntity(type: type, offset: start, length: end - start)]);
    default:
      final type = _inlineFormats[format]!;
      if (active) return result(_remove(entities, start, end, (e) => e.type == type));
      var next = _merge([...entities, models.MessageEntity(type: type, offset: start, length: end - start)], type);
      // Внутри кода разметки нет: код, захваченный не целиком, — без формата.
      for (final code in entities.where(_isCode)) {
        if (code.offset < end && start < code.end && (code.offset < start || code.end > end)) {
          next = _remove(next, code.offset, code.end, (e) => e.type == type);
        }
      }
      return result(next);
  }
}

bool _isCode(models.MessageEntity e) => e.type == models.MessageEntityType.code || e.type == models.MessageEntityType.pre;

/// Целые строки, которых касается выделение [start]..[end]: от начала первой
/// до конца последней (без перевода строки).
(int, int) _lines(String text, int start, int end) {
  final from = start == 0 ? 0 : text.lastIndexOf('\n', start - 1) + 1;
  final newline = text.indexOf('\n', end > start ? end - 1 : end);
  return (from, newline < 0 ? text.length : (newline < from ? from : newline));
}

/// [start]..[end] целиком под entities, подходящими под [test].
bool _covered(List<models.MessageEntity> entities, int start, int end, bool Function(models.MessageEntity) test) {
  final ranges = [
    for (final e in entities)
      if (test(e) && e.offset < end && start < e.end) e,
  ]..sort((a, b) => a.offset.compareTo(b.offset));
  var at = start;
  for (final e in ranges) {
    if (e.offset > at) return false;
    if (e.end > at) at = e.end;
    if (at >= end) return true;
  }
  return at >= end && ranges.isNotEmpty;
}

/// Убрать [start]..[end] из entities, подходящих под [test] (их края
/// остаются отдельными кусками).
List<models.MessageEntity> _remove(List<models.MessageEntity> entities, int start, int end, bool Function(models.MessageEntity) test) => [
  for (final e in entities)
    if (!test(e) || e.end <= start || e.offset >= end)
      e
    else ...[
      if (e.offset < start) e.copyWith(length: start - e.offset),
      if (e.end > end) e.copyWith(offset: end, length: e.end - end),
    ],
];

/// Пересекающиеся и соседние entities [type] — одной.
List<models.MessageEntity> _merge(List<models.MessageEntity> entities, models.MessageEntityType type) {
  final same = [
    for (final e in entities)
      if (e.type == type) e,
  ]..sort((a, b) => a.offset.compareTo(b.offset));
  final merged = <models.MessageEntity>[];
  for (final e in same) {
    final last = merged.lastOrNull;
    if (last != null && e.offset <= last.end) {
      if (e.end > last.end) merged[merged.length - 1] = last.copyWith(length: e.end - last.offset);
    } else {
      merged.add(e);
    }
  }
  return [
    for (final e in entities)
      if (e.type != type) e,
    ...merged,
  ];
}

/// Внешние раньше вложенных: по началу, длинные первыми, код — внутри всего.
List<models.MessageEntity> _sorted(List<models.MessageEntity> entities) => [...entities]
  ..sort((a, b) {
    if (a.offset != b.offset) return a.offset.compareTo(b.offset);
    if (a.length != b.length) return b.length.compareTo(a.length);
    return (_isCode(a) ? 1 : 0) - (_isCode(b) ? 1 : 0);
  });

/// Разметка поля ввода, которую можно записать ярлыками ([toMarkdownShortcuts])
/// и прочитать обратно без потерь: только [composeEntityTypes] в пределах
/// текста; цитаты — на целые строки; внутри кода другой разметки нет;
/// пересекающиеся — разрезаны, чтобы вкладывались; ссылки — без `]` и
/// переводов строки; код с переводом строки — блок кода.
List<models.MessageEntity> normalizeComposeEntities(String text, List<models.MessageEntity> entities) {
  var result = <models.MessageEntity>[];
  for (var e in entities) {
    if (!composeEntityTypes.contains(e.type)) continue;
    if (e.type == models.MessageEntityType.mentionName && e.userID.isEmpty) continue;
    final start = e.offset.clamp(0, text.length), end = e.end.clamp(0, text.length);
    e = e.copyWith(offset: start, length: end - start);
    if (e.type == models.MessageEntityType.blockquote) {
      final (from, to) = _lines(text, start, end);
      e = e.copyWith(offset: from, length: to - from);
      if (result.any((q) => q.type == models.MessageEntityType.blockquote && q.offset < e.end && e.offset < q.end)) continue;
    }
    if (_links.contains(e.type) && text.substring(e.offset, e.end).contains(RegExp(r'[\]\n]'))) continue;
    if (e.type == models.MessageEntityType.code && text.substring(e.offset, e.end).contains('\n')) {
      e = e.copyWith(type: models.MessageEntityType.pre);
    }
    if (e.length > 0) result.add(e);
  }
  for (final code in result.where(_isCode).toList()) {
    result = _remove(
      result,
      code.offset,
      code.end,
      (e) => e != code && e.type != models.MessageEntityType.blockquote && !(e.offset <= code.offset && e.end >= code.end && !_isCode(e)),
    );
  }
  // Пересечения (`**a __b** c__`) — режем позднего по краю раннего.
  for (var changed = true; changed;) {
    changed = false;
    result = _sorted(result);
    for (final x in result) {
      if (x.type == models.MessageEntityType.blockquote) continue;
      final y = result
          .where((y) => y.type != models.MessageEntityType.blockquote && x.offset < y.offset && y.offset < x.end && x.end < y.end)
          .firstOrNull;
      if (y == null) continue;
      result = [
        for (final e in result)
          if (identical(e, y)) ...[y.copyWith(length: x.end - y.offset), y.copyWith(offset: x.end, length: y.end - x.end)] else e,
      ];
      changed = true;
      break;
    }
  }
  return _sorted(result);
}

/// Упоминания по имени (без @username), выбранные в подсказке «@»: каждое имя
/// [mentions] в [text] (первое вхождение, не пересекающееся с другой
/// разметкой) получает entity `mentionName` с id человека.
List<models.MessageEntity> withMentionNames(String text, List<models.MessageEntity> entities, List<models.ChatMember> mentions) {
  final result = [...entities];
  for (final member in mentions) {
    if (member.name.isEmpty) continue;
    var from = 0;
    while (true) {
      final at = text.indexOf(member.name, from);
      if (at < 0) break;
      final end = at + member.name.length;
      final overlaps = result.any(
        (e) => e.offset < end && at < e.end && e.type != models.MessageEntityType.bold && e.type != models.MessageEntityType.italic,
      );
      if (!overlaps) {
        result.add(
          models.MessageEntity(type: models.MessageEntityType.mentionName, offset: at, length: member.name.length, userID: member.id),
        );
        break;
      }
      from = end;
    }
  }
  result.sort((a, b) => a.offset.compareTo(b.offset));
  return result;
}
