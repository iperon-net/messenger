import 'dart:ui';

import 'package:emoji_picker_flutter/locales/default_emoji_set_locale.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/emoji_filter.dart';

void main() {
  test('hides LGBT flags and same-sex couples and families', () {
    for (final emoji in [
      '🏳️‍🌈',
      '🏳️‍⚧️',
      '👨‍❤️‍👨',
      '👩‍❤️‍👩',
      '👨‍❤️‍💋‍👨',
      '👩‍❤️‍💋‍👩',
      '👨🏻‍❤️‍👨🏿',
      '👨‍👨‍👦',
      '👩‍👩‍👧‍👦',
      '👭',
      '👬',
      '👭🏻',
      '👩🏻‍🤝‍👩🏿',
      '👨🏼‍🤝‍👨🏾',
    ]) {
      expect(isHiddenEmoji(emoji), isTrue, reason: emoji);
    }
  });

  test('keeps other people, couples and flags', () {
    for (final emoji in [
      '👪',
      '💑',
      '💏',
      '👫',
      '👩🏻‍🤝‍👨🏿',
      '🧑‍🤝‍🧑',
      '👨‍❤️‍👩',
      '👩‍❤️‍💋‍👨',
      '👨‍👩‍👦',
      '👨‍👦',
      '👩‍👧',
      '🏳️',
      '🏴',
      '🇷🇺',
      '❤️',
      '👨‍💻',
    ]) {
      expect(isHiddenEmoji(emoji), isFalse, reason: emoji);
    }
  });

  test('panel set drops only hidden emoji', () {
    final all = getDefaultEmojiLocale(const Locale('en')).expand((c) => c.emoji).map((e) => e.emoji).toList();
    final kept = filteredEmojiSet(const Locale('en')).expand((c) => c.emoji).map((e) => e.emoji).toList();
    final removed = all.where((e) => !kept.contains(e)).toList();
    expect(removed, isNotEmpty);
    expect(removed.every(isHiddenEmoji), isTrue);
  });
}
