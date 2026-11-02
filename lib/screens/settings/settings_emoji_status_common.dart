import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/widgets.dart';

import '../../chats/animated_emoji.dart';
import '../../i18n/translations.g.dart';

final popularEmojiStatusChoices = [for (final name in bundledAnimatedEmoji) ...AnimatedEmojis.values.where((emoji) => emoji.name == name)];

final emojiStatusChoices = [
  ...popularEmojiStatusChoices.map((emoji) => emoji.toUnicodeEmoji()),
  for (final emoji in AnimatedEmojis.values)
    if (!bundledAnimatedEmoji.contains(emoji.name)) emoji.toUnicodeEmoji(),
];

enum EmojiStatusCategory { popular, smileys, people, animals, food, activities, travel, objects, symbols }

String emojiStatusCategoryTitle(Translations t, EmojiStatusCategory category) => switch (category) {
  EmojiStatusCategory.popular => t.screenMyProfile.emojiStatusCategoryPopular,
  EmojiStatusCategory.smileys => t.screenMyProfile.emojiStatusCategorySmileys,
  EmojiStatusCategory.people => t.screenMyProfile.emojiStatusCategoryPeople,
  EmojiStatusCategory.animals => t.screenMyProfile.emojiStatusCategoryAnimals,
  EmojiStatusCategory.food => t.screenMyProfile.emojiStatusCategoryFood,
  EmojiStatusCategory.activities => t.screenMyProfile.emojiStatusCategoryActivities,
  EmojiStatusCategory.travel => t.screenMyProfile.emojiStatusCategoryTravel,
  EmojiStatusCategory.objects => t.screenMyProfile.emojiStatusCategoryObjects,
  EmojiStatusCategory.symbols => t.screenMyProfile.emojiStatusCategorySymbols,
};

List<AnimatedEmojiData> emojiStatusItems(EmojiStatusCategory category, String query) {
  final words = query.trim().toLowerCase().split(RegExp(r'\s+')).where((word) => word.isNotEmpty);
  final source = category == EmojiStatusCategory.popular ? popularEmojiStatusChoices : AnimatedEmojis.values;
  final categoryName = switch (category) {
    EmojiStatusCategory.popular => null,
    EmojiStatusCategory.smileys => 'Smileys and emotions',
    EmojiStatusCategory.people => 'People and body',
    EmojiStatusCategory.animals => 'Animals and nature',
    EmojiStatusCategory.food => 'Food and drink',
    EmojiStatusCategory.activities => 'Activities',
    EmojiStatusCategory.travel => 'Travel and places',
    EmojiStatusCategory.objects => 'Objects',
    EmojiStatusCategory.symbols => 'Symbols',
  };
  return [
    for (final emoji in source)
      if ((categoryName == null || emoji.categories.contains(categoryName)) &&
          words.every((word) => emoji.name.toLowerCase().contains(word) || emoji.tags.any((tag) => tag.toLowerCase().contains(word))))
        emoji,
  ];
}

class EmojiStatusPreview extends StatelessWidget {
  final String emoji;

  const EmojiStatusPreview({super.key, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 112,
        height: 112,
        child: FittedBox(
          child: AnimatedBigEmoji(text: emoji, style: const TextStyle(fontSize: 88)),
        ),
      ),
    );
  }
}

List<({String title, Duration? duration})> emojiStatusDurations(Translations t) => [
  (title: t.screenMyProfile.emojiStatusUnlimited, duration: null),
  (title: t.screenMyProfile.emojiStatusHour, duration: const Duration(hours: 1)),
  (title: t.screenMyProfile.emojiStatusFourHours, duration: const Duration(hours: 4)),
  (title: t.screenMyProfile.emojiStatusEightHours, duration: const Duration(hours: 8)),
  (title: t.screenMyProfile.emojiStatusDay, duration: const Duration(days: 1)),
];
