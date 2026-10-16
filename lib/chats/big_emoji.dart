import 'package:flutter/widgets.dart' show StringCharacters;

/// «Крупные эмодзи» (как в Telegram): сообщение только из 1–3 эмодзи
/// показывается крупно и без пузыря.
const bigEmojiMax = 3;

/// Пиктограмма эмодзи (приближение Extended_Pictographic по блокам Unicode;
/// без регулярок с \p{…} — их не понимают анализаторы IDE).
bool _pictographic(int c) =>
    c >= 0x1F000 && c <= 0x1FAFF || // эмодзи, флаги (региональные индикаторы), оттенки кожи
    c >= 0x2600 && c <= 0x27BF || // разные символы, дингбаты (☀ ❤ ✅)
    c >= 0x2300 && c <= 0x23FF || // ⌚ ⏰ ⏩
    c >= 0x2B00 && c <= 0x2BFF || // ⬆ ⭐ ⭕
    c >= 0x2190 && c <= 0x21FF || // стрелки ↔ ↩
    c >= 0x25A0 && c <= 0x25FF || // ▶ ◀ ◻
    const {0xA9, 0xAE, 0x203C, 0x2049, 0x2122, 0x2139, 0x24C2, 0x2934, 0x2935, 0x3030, 0x303D, 0x3297, 0x3299}.contains(c);

/// Служебные символы внутри эмодзи-кластера: ZWJ, селекторы вида, кейкап,
/// тег-флаги («🏴󠁧󠁢󠁳󠁣󠁴󠁿»), а также «#», «*», цифры (кейкап «1️⃣»).
bool _joiner(int c) =>
    c == 0x200D ||
    c == 0xFE0F ||
    c == 0xFE0E ||
    c == 0x20E3 ||
    c >= 0xE0020 && c <= 0xE007F ||
    c == 0x23 ||
    c == 0x2A ||
    c >= 0x30 && c <= 0x39;

/// Один графемный кластер — эмодзи (цифра или «#» сами по себе — нет).
bool isEmojiCluster(String cluster) {
  var picture = false;
  for (final c in cluster.runes) {
    if (_pictographic(c)) {
      picture = true;
    } else if (c == 0x20E3) {
      picture = true;
    } else if (!_joiner(c)) {
      return false;
    }
  }
  return picture;
}

/// Сколько эмодзи в [text], если он состоит только из них (пробелы и переводы
/// строк не в счёт) и их не больше [max]; иначе 0.
int bigEmojiCount(String text, {int max = bigEmojiMax}) {
  var count = 0;
  for (final cluster in text.characters) {
    if (cluster.trim().isEmpty) continue;
    if (!isEmojiCluster(cluster) || ++count > max) return 0;
  }
  return count;
}

/// Размер шрифта крупных эмодзи: один — крупнее всего.
double bigEmojiFontSize(int count) => switch (count) {
  1 => 56,
  2 => 46,
  _ => 38,
};
