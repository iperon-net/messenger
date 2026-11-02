import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/animated_emoji.dart';
import 'package:messenger/models/emoji_status.dart';
import 'package:messenger/screens/settings/settings_emoji_status_common.dart';

void main() {
  test('emoji status expires and mutes only with a duration', () {
    final expiresAt = DateTime.now().add(const Duration(hours: 4));

    expect(const EmojiStatus(emoji: '😴', doNotDisturb: true).active, isTrue);
    expect(const EmojiStatus(emoji: '😴', doNotDisturb: true).mutes, isFalse);
    expect(EmojiStatus(emoji: '😴', expiresAt: expiresAt).mutes, isFalse);
    expect(EmojiStatus(emoji: '😴', expiresAt: expiresAt, doNotDisturb: true).mutes, isTrue);

    final expired = EmojiStatus(emoji: '😴', expiresAt: DateTime.now().subtract(const Duration(seconds: 1)), doNotDisturb: true);
    expect(expired.active, isFalse);
    expect(expired.mutes, isFalse);
    expect(expired.toProto(), isNull);
  });

  test('emoji status choices contain every animated emoji with popular ones first', () {
    expect(emojiStatusChoices.length, AnimatedEmojis.values.length);
    expect(emojiStatusChoices.toSet().length, AnimatedEmojis.values.length);
    expect(emojiStatusChoices.every((emoji) => AnimatedEmojiStore.lookup(emoji) != null), isTrue);
    expect(bundledAnimatedEmoji.contains(AnimatedEmojiStore.lookup(emojiStatusChoices.first)!.name), isTrue);
  });

  test('emoji status categories and search filter the catalog', () {
    expect(emojiStatusItems(EmojiStatusCategory.popular, ''), hasLength(bundledAnimatedEmoji.length));
    for (final category in EmojiStatusCategory.values) {
      expect(emojiStatusItems(category, ''), isNotEmpty, reason: '$category must contain emoji');
    }
    expect(
      emojiStatusItems(
        EmojiStatusCategory.popular,
        'heart',
      ).every((emoji) => emoji.name.toLowerCase().contains('heart') || emoji.tags.any((tag) => tag.contains('heart'))),
      isTrue,
    );
    expect(emojiStatusItems(EmojiStatusCategory.popular, 'definitely-no-such-emoji'), isEmpty);
  });
}
