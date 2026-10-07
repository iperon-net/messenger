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

/// Пункты меню форматирования выделенного текста в поле ввода.
enum ComposeFormat { bold, italic, strike, spoiler, code, link, quote, plain }

/// Поле ввода с выделением [start]..[end].
typedef ComposeEdit = ({String text, int start, int end});

const _formatMarkers = {
  ComposeFormat.bold: '**',
  ComposeFormat.italic: '__',
  ComposeFormat.strike: '~~',
  ComposeFormat.spoiler: '||',
  ComposeFormat.code: '`',
};

/// Применить [format] к выделению: обернуть markdown-ярлыками (повторно —
/// снять), для [ComposeFormat.link] — `[текст](url)`, для цитаты — `> ` в
/// начале строк, [ComposeFormat.plain] — убрать всю разметку. Поле хранит
/// ярлыки, в entities они превращаются при отправке ([parseMarkdownShortcuts]).
ComposeEdit applyComposeFormat(ComposeEdit value, ComposeFormat format, {String url = ''}) {
  final (:text, :start, :end) = value;
  if (start < 0 || end <= start || end > text.length) return value;
  final selected = text.substring(start, end);
  switch (format) {
    case ComposeFormat.link:
      if (url.isEmpty) return value;
      final link = '[$selected]($url)';
      return (text: text.replaceRange(start, end, link), start: start, end: start + link.length);
    case ComposeFormat.quote:
      return _toggleQuote(value);
    case ComposeFormat.plain:
      var edit = value;
      // Сначала снаружи (выделили текст без ярлыков), потом внутри.
      for (final marker in [..._formatMarkers.values, '```\n']) {
        edit = _unwrapAround(edit, marker) ?? edit;
      }
      final plain = parseMarkdownShortcuts(edit.text.substring(edit.start, edit.end)).$1;
      return (text: edit.text.replaceRange(edit.start, edit.end, plain), start: edit.start, end: edit.start + plain.length);
    case ComposeFormat.code when selected.contains('\n'):
      // Многострочный — блок кода; перевод строки после ``` — пустой язык.
      final unwrapped = _unwrapAround(value, '```\n', close: '```');
      if (unwrapped != null) return unwrapped;
      return _wrap(value, '```\n', '```');
    default:
      final marker = _formatMarkers[format]!;
      return _unwrapAround(value, marker) ?? _unwrapInside(value, marker) ?? _wrap(value, marker, marker);
  }
}

ComposeEdit _wrap(ComposeEdit value, String open, String close) {
  final (:text, :start, :end) = value;
  return (
    text: '${text.substring(0, start)}$open${text.substring(start, end)}$close${text.substring(end)}',
    start: start + open.length,
    end: end + open.length,
  );
}

/// `**[выделение]**` → `[выделение]`.
ComposeEdit? _unwrapAround(ComposeEdit value, String open, {String? close}) {
  close ??= open;
  final (:text, :start, :end) = value;
  if (start < open.length || end + close.length > text.length) return null;
  if (text.substring(start - open.length, start) != open || text.substring(end, end + close.length) != close) return null;
  return (
    text: text.replaceRange(end, end + close.length, '').replaceRange(start - open.length, start, ''),
    start: start - open.length,
    end: end - open.length,
  );
}

/// `[**выделение**]` → `[выделение]`.
ComposeEdit? _unwrapInside(ComposeEdit value, String marker) {
  final (:text, :start, :end) = value;
  final selected = text.substring(start, end);
  if (selected.length <= marker.length * 2 || !selected.startsWith(marker) || !selected.endsWith(marker)) return null;
  final inner = selected.substring(marker.length, selected.length - marker.length);
  return (text: text.replaceRange(start, end, inner), start: start, end: start + inner.length);
}

/// Цитата — на целые строки: все уже с `>` — снять, иначе добавить `> `.
ComposeEdit _toggleQuote(ComposeEdit value) {
  final (:text, :start, :end) = value;
  final from = text.lastIndexOf('\n', start - 1) + 1;
  final newline = text.indexOf('\n', end);
  final to = newline < 0 ? text.length : newline;
  final lines = text.substring(from, to).split('\n');
  final quoted = lines.every((l) => l.startsWith('>'));
  final block = [for (final l in lines) quoted ? l.substring(l.startsWith('> ') ? 2 : 1) : '> $l'].join('\n');
  return (text: text.replaceRange(from, to, block), start: from, end: from + block.length);
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
