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
  for (final e in entities) {
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

/// Поле ввода с выделением [start]..[end].
typedef ComposeEdit = ({String text, int start, int end});

const _formatMarkers = {
  ComposeFormat.bold: '**',
  ComposeFormat.italic: '__',
  ComposeFormat.underline: '++',
  ComposeFormat.strike: '~~',
  ComposeFormat.spoiler: '||',
  ComposeFormat.code: '`',
};

/// Применить [format] к выделению: обернуть markdown-ярлыками, а если формат
/// уже стоит ([activeComposeFormats]) — снять только его; для
/// [ComposeFormat.link] — `[текст](url)`, для [ComposeFormat.mention] —
/// `[текст](mention:userID)` ([userID]), для цитат — `> ` / `>> ` в начале
/// строк, [ComposeFormat.plain] — убрать всю разметку. Поле хранит ярлыки, в
/// entities они превращаются при отправке ([parseMarkdownShortcuts]).
ComposeEdit applyComposeFormat(ComposeEdit value, ComposeFormat format, {String url = '', String userID = ''}) {
  final (:text, :start, :end) = value;
  if (start < 0 || end <= start || end > text.length) return value;
  final selected = text.substring(start, end);
  switch (format) {
    case ComposeFormat.link || ComposeFormat.mention:
      final target = format == ComposeFormat.link ? _linkTarget : _mentionTarget;
      final unwrapped = _unwrapLink(value, target);
      if (unwrapped != null) return unwrapped;
      final address = format == ComposeFormat.link ? url : (userID.isEmpty ? '' : 'mention:$userID');
      if (address.isEmpty) return value;
      final link = '[$selected]($address)';
      return (text: text.replaceRange(start, end, link), start: start + 1, end: start + 1 + selected.length);
    case ComposeFormat.quote || ComposeFormat.quoteExpandable:
      return _toggleQuote(value, expandable: format == ComposeFormat.quoteExpandable);
    case ComposeFormat.plain:
      var edit = value;
      // Сначала снаружи (выделили текст без ярлыков), потом внутри.
      for (final marker in [..._formatMarkers.values, '```\n']) {
        edit = _unwrapAround(edit, marker, close: marker == '```\n' ? '```' : null) ?? edit;
      }
      edit = _unwrapLink(edit, _linkTarget) ?? _unwrapLink(edit, _mentionTarget) ?? edit;
      final plain = parseMarkdownShortcuts(edit.text.substring(edit.start, edit.end)).$1;
      return (text: edit.text.replaceRange(edit.start, edit.end, plain), start: edit.start, end: edit.start + plain.length);
    case ComposeFormat.pre:
      // Перевод строки после ``` — пустой язык.
      final unwrapped = _unwrapAround(value, '```\n', close: '```') ?? _unwrapPreInside(value);
      if (unwrapped != null) return unwrapped;
      return _wrap(value, '```\n', '```');
    case ComposeFormat.code when selected.contains('\n'):
      // Многострочный моноширинный — блок кода.
      return applyComposeFormat(value, ComposeFormat.pre);
    default:
      final marker = _formatMarkers[format]!;
      return _unwrapNested(value, marker) ?? _unwrapInside(value, marker) ?? _wrap(value, marker, marker);
  }
}

/// Какие форматы уже стоят на выделении — галочки в меню; повторный выбор
/// снимает только этот формат.
Set<ComposeFormat> activeComposeFormats(ComposeEdit value) {
  final (:text, :start, :end) = value;
  if (start < 0 || end <= start || end > text.length) return const {};
  final result = <ComposeFormat>{};
  final pre = _unwrapAround(value, '```\n', close: '```') != null || _unwrapPreInside(value) != null;
  if (pre) result.add(ComposeFormat.pre);
  for (final MapEntry(key: format, value: marker) in _formatMarkers.entries) {
    if (pre && format == ComposeFormat.code) continue;
    if (_unwrapNested(value, marker) != null || _unwrapInside(value, marker) != null) result.add(format);
  }
  if (_unwrapLink(value, _linkTarget) != null) result.add(ComposeFormat.link);
  if (_unwrapLink(value, _mentionTarget) != null) result.add(ComposeFormat.mention);
  final lines = _quoteBlock(text, start, end).lines;
  for (final kind in [ComposeFormat.quote, ComposeFormat.quoteExpandable]) {
    if (lines.every((l) => quoteKind(l) == kind)) result.add(kind);
  }
  return result;
}

/// Адрес в ярлыке ссылки `[текст](https://…)` / упоминания `[текст](mention:id)`.
final _linkTarget = RegExp(r'^\]\((https?://[^)\s]+)\)');
final _mentionTarget = RegExp(r'^\]\((mention:[\w-]+)\)');

/// Снять ссылку / упоминание: выделен текст внутри `[текст](адрес)` или весь
/// ярлык целиком → остаётся `текст`.
ComposeEdit? _unwrapLink(ComposeEdit value, RegExp target) {
  final (:text, :start, :end) = value;
  // Выделен текст внутри: `[` перед ним, `](адрес)` после.
  if (start > 0 && text[start - 1] == '[') {
    final after = target.firstMatch(text.substring(end));
    if (after != null) {
      final inner = text.substring(start, end);
      return (text: text.replaceRange(start - 1, end + after.end, inner), start: start - 1, end: start - 1 + inner.length);
    }
  }
  // Выделен весь ярлык.
  final selected = text.substring(start, end);
  final whole = RegExp(r'^\[([^\]\n]+)').firstMatch(selected);
  if (whole != null) {
    final rest = selected.substring(whole.end);
    final match = target.firstMatch(rest);
    if (match != null && match.end == rest.length) {
      final inner = whole.group(1)!;
      return (text: text.replaceRange(start, end, inner), start: start, end: start + inner.length);
    }
  }
  return null;
}

/// Выделен весь блок кода вместе с ярлыками: ```` ```\nкод``` ```` → `код`.
ComposeEdit? _unwrapPreInside(ComposeEdit value) {
  final (:text, :start, :end) = value;
  final selected = text.substring(start, end);
  if (selected.length <= 7 || !selected.startsWith('```\n') || !selected.endsWith('```')) return null;
  final inner = selected.substring(4, selected.length - 3);
  return (text: text.replaceRange(start, end, inner), start: start, end: start + inner.length);
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

/// Как [_unwrapAround], но [marker] может стоять не вплотную, а за другими
/// ярлыками на той же глубине: `**__[выделение]__**` → снять `**` →
/// `__[выделение]__`.
ComposeEdit? _unwrapNested(ComposeEdit value, String marker) {
  final (:text, :start, :end) = value;
  final markers = _formatMarkers.values.toList();
  // Ярлыки вплотную слева (изнутри наружу) и справа.
  final left = <(int, String)>[];
  for (var i = start; ;) {
    final m = markers.where((m) => i >= m.length && text.startsWith(m, i - m.length)).firstOrNull;
    if (m == null) break;
    i -= m.length;
    left.add((i, m));
  }
  final right = <(int, String)>[];
  for (var i = end; ;) {
    final m = markers.where((m) => text.startsWith(m, i)).firstOrNull;
    if (m == null) break;
    right.add((i, m));
    i += m.length;
  }
  for (var k = 0; k < left.length && k < right.length; k++) {
    if (left[k].$2 != marker || right[k].$2 != marker) continue;
    final (l, _) = left[k];
    final (r, _) = right[k];
    return (
      text: text.replaceRange(r, r + marker.length, '').replaceRange(l, l + marker.length, ''),
      start: start - marker.length,
      end: end - marker.length,
    );
  }
  return null;
}

/// `[**выделение**]` → `[выделение]`.
ComposeEdit? _unwrapInside(ComposeEdit value, String marker) {
  final (:text, :start, :end) = value;
  final selected = text.substring(start, end);
  if (selected.length <= marker.length * 2 || !selected.startsWith(marker) || !selected.endsWith(marker)) return null;
  final inner = selected.substring(marker.length, selected.length - marker.length);
  return (text: text.replaceRange(start, end, inner), start: start, end: start + inner.length);
}

/// Целые строки, которых касается выделение: границы и сами строки.
({int from, int to, List<String> lines}) _quoteBlock(String text, int start, int end) {
  final from = start == 0 ? 0 : text.lastIndexOf('\n', start - 1) + 1;
  final newline = text.indexOf('\n', end);
  final to = newline < 0 ? text.length : newline;
  return (from: from, to: to, lines: text.substring(from, to).split('\n'));
}

/// Цитата — на целые строки: все уже этого вида — снять, иначе поставить
/// `> ` ([expandable] — `>> `) вместо прежнего маркера.
ComposeEdit _toggleQuote(ComposeEdit value, {required bool expandable}) {
  final (:text, :start, :end) = value;
  final (:from, :to, :lines) = _quoteBlock(text, start, end);
  final kind = expandable ? ComposeFormat.quoteExpandable : ComposeFormat.quote;
  final quoted = lines.every((l) => quoteKind(l) == kind);
  final block = [
    for (final l in lines) quoted ? l.substring(quoteMarkerLength(l)) : '${expandable ? '>> ' : '> '}${l.substring(quoteMarkerLength(l))}',
  ].join('\n');
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
