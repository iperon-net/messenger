import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/animated_emoji.dart';

void main() {
  test('эмодзи → анимация Noto (с селектором вида и без, оттенки кожи)', () {
    expect(AnimatedEmojiStore.lookup('❤️')?.name, 'redHeart');
    expect(AnimatedEmojiStore.lookup('❤')?.name, 'redHeart');
    expect(AnimatedEmojiStore.lookup('👍')?.name, 'thumbsUp');
    expect(AnimatedEmojiStore.lookup('👍🏿')?.name, 'thumbsUpDark');
    expect(AnimatedEmojiStore.lookup('😂')?.name, 'joy');
    expect(AnimatedEmojiStore.lookup('🙏')?.name, 'foldedHands');
    expect(AnimatedEmojiStore.lookup('a'), isNull);
  });

  test('крупные: анимация, только если она есть у каждого', () {
    expect(AnimatedEmojiStore.forText('😂 ❤️')?.map((e) => e.name), ['joy', 'redHeart']);
    expect(AnimatedEmojiStore.forText('😂🇷🇺'), isNull);
  });

  test('встроенные — все есть в наборе', () {
    final names = {
      for (final s in [
        '❤️',
        '👍',
        '😂',
        '🔥',
        '🎉',
        '😍',
        '😢',
        '😭',
        '😁',
        '😄',
        '🙏',
        '👏',
        '😮',
        '😱',
        '🤣',
        '😘',
        '🥰',
        '🤔',
        '😎',
        '👌',
        '💯',
        '😡',
        '🥳',
        '😅',
        '🤯',
        '🤩',
        '😴',
        '🙈',
        '💔',
        '✨',
        '👀',
        '😉',
        '🤗',
        '😜',
        '🥺',
        '😆',
        '😀',
        '👎',
        '🤝',
        '💪',
      ])
        AnimatedEmojiStore.lookup(s)?.name,
    };
    expect(
      bundledAnimatedEmoji.difference(names),
      isEmpty,
      reason: 'встроенные без соответствия: ${bundledAnimatedEmoji.difference(names)}',
    );
  });
}
