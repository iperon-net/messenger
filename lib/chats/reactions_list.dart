import '../models.dart' as models;

/// «Кто поставил реакцию» в группе (подэтап 3.4, `Messages.ReactionsList`):
/// человек, его эмодзи и когда. Одна строка — одна реакция (поставил две —
/// две строки, как в Telegram).
class MessageReactor {
  final String userID;
  final String name;
  final String emoji;
  final DateTime date;

  /// Это мы (имя — «Вы», тап — не профиль).
  final bool isSelf;

  const MessageReactor({required this.userID, required this.name, required this.emoji, required this.date, this.isSelf = false});
}

/// Страница списка ([MessageReactor] от поздних к ранним); [nextCursor] —
/// продолжение (пусто — дальше нет).
class ReactionsListPage {
  final List<MessageReactor> reactors;
  final String nextCursor;

  const ReactionsListPage({required this.reactors, this.nextCursor = ''});
}

/// Вкладки экрана: «Все» (пустой эмодзи, всего реакций) и по эмодзи с числом
/// — в порядке чипов под сообщением; одна разновидность — без «Все».
List<({String emoji, int count})> reactionTabs(List<models.MessageReaction> reactions) {
  final byEmoji = [
    for (final r in reactions)
      if (r.count > 0) (emoji: r.emoji, count: r.count),
  ];
  if (byEmoji.length <= 1) return byEmoji;
  final total = byEmoji.fold<int>(0, (sum, tab) => sum + tab.count);
  return [(emoji: '', count: total), ...byEmoji];
}

/// Дописать к уже загруженному [current] следующую страницу [page] без
/// повторов (та же пара человек + эмодзи — повтор: страница могла сдвинуться,
/// пока листали).
List<MessageReactor> appendReactors(List<MessageReactor> current, List<MessageReactor> page) {
  final seen = {for (final r in current) '${r.userID}:${r.emoji}'};
  return [
    ...current,
    for (final r in page)
      if (seen.add('${r.userID}:${r.emoji}')) r,
  ];
}
