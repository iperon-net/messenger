import '../models.dart' as models;

/// Цитата фрагмента [start]..[end] текста сообщения (выделение в меню →
/// «Цитировать»): пробелы и переводы строк по краям отрезаются, длина — не
/// больше [models.MessageQuote.maxLength], разметка обрезается по фрагменту.
/// `null` — выделены одни пробелы.
models.MessageQuote? quoteOf(String text, List<models.MessageEntity> entities, int start, int end) {
  start = start.clamp(0, text.length);
  end = end.clamp(start, text.length);
  while (start < end && _isSpace(text.codeUnitAt(start))) {
    start++;
  }
  while (end > start && _isSpace(text.codeUnitAt(end - 1))) {
    end--;
  }
  if (end - start > models.MessageQuote.maxLength) {
    end = start + models.MessageQuote.maxLength;
    // Не рвём суррогатную пару (эмодзи) пополам.
    if (_isHighSurrogate(text.codeUnitAt(end - 1))) end--;
  }
  if (start >= end) return null;
  return models.MessageQuote(
    text: text.substring(start, end),
    offset: start,
    entities: [
      for (final e in entities)
        if (e.offset < end && e.end > start)
          e.copyWith(
            offset: (e.offset - start).clamp(0, end - start),
            length: (e.end < end ? e.end : end) - (e.offset > start ? e.offset : start),
          ),
    ],
  );
}

/// Где цитата [quote] в тексте [text] исходного сообщения: на своём месте,
/// иначе (сообщение правили) — первое вхождение; `null` — фрагмента больше нет.
(int, int)? locateQuote(String text, models.MessageQuote quote) {
  final q = quote.text;
  if (q.isEmpty) return null;
  final at = quote.offset + q.length <= text.length && text.startsWith(q, quote.offset) ? quote.offset : text.indexOf(q);
  return at < 0 ? null : (at, at + q.length);
}

bool _isSpace(int c) => c == 0x20 || c == 0x0A || c == 0x09 || c == 0x0D || c == 0xA0;

bool _isHighSurrogate(int c) => c >= 0xD800 && c <= 0xDBFF;
