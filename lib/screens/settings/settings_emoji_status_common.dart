import '../../i18n/translations.g.dart';

const emojiStatusChoices = ['😀', '😎', '🥳', '😴', '☕', '💼', '🏠', '🚗', '✈️', '🏖️', '🏃', '🎮', '🎧', '📚', '❤️', '🔥'];

List<({String title, Duration? duration})> emojiStatusDurations(Translations t) => [
  (title: t.screenMyProfile.emojiStatusUnlimited, duration: null),
  (title: t.screenMyProfile.emojiStatusHour, duration: const Duration(hours: 1)),
  (title: t.screenMyProfile.emojiStatusFourHours, duration: const Duration(hours: 4)),
  (title: t.screenMyProfile.emojiStatusEightHours, duration: const Duration(hours: 8)),
  (title: t.screenMyProfile.emojiStatusDay, duration: const Duration(days: 1)),
];
