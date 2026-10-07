import '../models.dart' as models;

/// Реакции на сообщения (см. docs/plans/chats-groups-channels.md, «Реакции»).

/// Личные чаты — фиксированный набор, без настройки.
const privateChatReactions = ['👍', '❤️', '🔥', '😂', '😮', '😢', '🙏', '👎'];

/// «Все реакции» группы/канала — из этого же набора админ выбирает «некоторые».
const allChatReactions = [
  ...privateChatReactions,
  '🎉',
  '🤔',
  '🤯',
  '😍',
  '👏',
  '💯',
  '🤝',
  '😁',
  '🥰',
  '😱',
  '🤩',
  '👀',
  '🏆',
  '💔',
  '🤣',
  '⚡',
];

/// Быстрая реакция (двойной тап по сообщению) по умолчанию; своя — в
/// «Настройки → Оформление → Быстрая реакция» (`settingsDevice.quickReaction`).
const defaultQuickReaction = '❤️';

/// Какие реакции можно поставить в [chat].
List<String> availableReactions(models.Chat chat) {
  if (chat.type == models.ChatType.private) return privateChatReactions;
  return switch (chat.reactionsMode) {
    models.ChatReactionsMode.all => allChatReactions,
    models.ChatReactionsMode.some => chat.reactions,
    models.ChatReactionsMode.none => const [],
  };
}

/// Двойной тап: быстрая реакция [preferred], если она разрешена в чате, иначе
/// первая доступная.
String? quickReaction(models.Chat chat, {String preferred = defaultQuickReaction}) {
  final available = availableReactions(chat);
  if (available.isEmpty) return null;
  return available.contains(preferred) ? preferred : available.first;
}

/// Сколько разных реакций один человек может поставить на одно сообщение.
const maxReactionsPerUser = 3;

/// Наш новый набор реакций после тапа по [emoji]: своя — снимается, новая —
/// добавляется; сверх [maxReactionsPerUser] вытесняется самая первая наша.
List<String> toggleMyReaction(List<String> mine, String emoji) {
  if (mine.contains(emoji)) return mine.where((e) => e != emoji).toList();
  final result = [...mine, emoji];
  return result.length > maxReactionsPerUser ? result.sublist(result.length - maxReactionsPerUser) : result;
}

/// Применить наш набор реакций [mine] к сообщению: снять наши, которых в
/// наборе больше нет, и добавить новые.
List<models.MessageReaction> applyMyReactions(List<models.MessageReaction> reactions, List<String> mine) {
  final result = <models.MessageReaction>[];
  for (final r in reactions) {
    if (!r.chosen || mine.contains(r.emoji)) {
      result.add(r);
    } else if (r.count > 1) {
      result.add(r.copyWith(count: r.count - 1, chosen: false));
    }
  }
  for (final emoji in mine) {
    final i = result.indexWhere((r) => r.emoji == emoji);
    if (i < 0) {
      result.add(models.MessageReaction(emoji: emoji, chosen: true));
    } else if (!result[i].chosen) {
      result[i] = result[i].copyWith(count: result[i].count + 1, chosen: true);
    }
  }
  return result;
}

/// Реакция другого участника (демо: собеседник отреагировал на наше сообщение).
List<models.MessageReaction> addOtherReaction(List<models.MessageReaction> reactions, String emoji) {
  final i = reactions.indexWhere((r) => r.emoji == emoji);
  if (i < 0) return [...reactions, models.MessageReaction(emoji: emoji)];
  return [for (final (j, r) in reactions.indexed) j == i ? r.copyWith(count: r.count + 1) : r];
}
