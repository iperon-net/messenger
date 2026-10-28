import 'dart:ui' show Locale;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:emoji_picker_flutter/locales/default_emoji_set_locale.dart';

/// Эмодзи, которых нет в панели выбора (решение 2026-10-28): флаги ЛГБТ и
/// трансгендеров, пары одного пола — с сердцем, с поцелуем и «держатся за руки»
/// (👭 👬) — и семьи с двумя взрослыми одного пола (всё и с оттенками кожи).
/// Полученные в сообщениях не трогаем — убираем только из выбора (сетка, поиск).
bool isHiddenEmoji(String emoji) {
  if (_hiddenFlags.contains(emoji)) return true;
  // Оттенки кожи и вариационный селектор не влияют на смысл — без них.
  final bare = emoji.replaceAll(_modifiers, '');
  if (bare == _twoWomen || bare == _twoMen) return true;
  final parts = bare.split(_zwj);
  if (parts.length < 3) return false;
  final first = parts[0];
  if (first != _man && first != _woman) return false;
  // Пара с сердцем (и поцелуем): взрослый ‍❤‍ (💋‍) взрослый того же пола;
  // «держатся за руки» с разными оттенками кожи: взрослый ‍🤝‍ взрослый.
  if (parts[1] == _heart || parts[1] == _handshake) return parts.last == first;
  // Семья: два взрослых одного пола, дальше дети.
  return parts[1] == first;
}

/// Набор панели без [isHiddenEmoji].
List<CategoryEmoji> filteredEmojiSet(Locale locale) => [
  for (final category in getDefaultEmojiLocale(locale))
    category.copyWith(emoji: category.emoji.where((emoji) => !isHiddenEmoji(emoji.emoji)).toList()),
];

const _zwj = '‍';
const _man = '\u{1F468}';
const _woman = '\u{1F469}';
const _heart = '❤';
const _handshake = '\u{1F91D}';
const _twoWomen = '\u{1F46D}'; // 👭
const _twoMen = '\u{1F46C}'; // 👬
final _modifiers = RegExp('[\u{1F3FB}-\u{1F3FF}\u{FE0F}]', unicode: true);
const _hiddenFlags = {
  '\u{1F3F3}\u{FE0F}‍\u{1F308}', // 🏳️‍🌈
  '\u{1F3F3}‍\u{1F308}',
  '\u{1F3F3}\u{FE0F}‍⚧\u{FE0F}', // 🏳️‍⚧️
  '\u{1F3F3}‍⚧',
  '⚧\u{FE0F}', // ⚧️
  '⚧',
};
