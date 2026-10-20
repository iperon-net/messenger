import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/chats/reactions_list.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/screens/chats/reactions_list_common.dart';

// «Кто поставил реакцию» (хвост 3.4): вкладки, страницы без повторов, без
// сети — ошибка на месте списка и «Повторить», а не пустой список.
void main() {
  MessageReactor reactor(String userID, String emoji, int minute) =>
      MessageReactor(userID: userID, name: userID, emoji: emoji, date: DateTime(2026, 10, 20, 12, minute));

  test('вкладки: «Все» с суммой и по эмодзи; одна разновидность — без «Все»', () {
    expect(reactionTabs(const [models.MessageReaction(emoji: '👍', count: 3), models.MessageReaction(emoji: '🔥', count: 2)]), [
      (emoji: '', count: 5),
      (emoji: '👍', count: 3),
      (emoji: '🔥', count: 2),
    ]);
    expect(reactionTabs(const [models.MessageReaction(emoji: '👍', count: 3)]), [(emoji: '👍', count: 3)]);
    expect(reactionTabs(const []), isEmpty);
  });

  test('страницы склеиваются без повторов (человек + эмодзи)', () {
    final first = [reactor('a', '👍', 3), reactor('b', '🔥', 2)];
    final merged = appendReactors(first, [reactor('b', '🔥', 2), reactor('b', '👍', 1), reactor('c', '👍', 0)]);
    expect([for (final r in merged) '${r.userID}${r.emoji}'], ['a👍', 'b🔥', 'b👍', 'c👍']);
  });

  test('контроллер: страницы по вкладкам, без сети — offline и повтор', () async {
    final calls = <String>[];
    var offline = true;
    final controller = ReactionsListController(
      load: (emoji, cursor) async {
        calls.add('$emoji|$cursor');
        if (offline) throw const ChatsOfflineException();
        if (emoji.isEmpty && cursor.isEmpty) return ReactionsListPage(reactors: [reactor('a', '👍', 1)], nextCursor: 'p2');
        if (emoji.isEmpty) return ReactionsListPage(reactors: [reactor('b', '🔥', 0)]);
        return ReactionsListPage(reactors: [reactor('a', '👍', 1)]);
      },
    );
    addTearDown(controller.dispose);

    controller.open([(emoji: '', count: 2), (emoji: '👍', count: 1), (emoji: '🔥', count: 1)]);
    await pumpEventQueue();
    expect(controller.current.error, ReactionsListError.offline);
    expect(controller.current.reactors, isEmpty);

    // Прокрутка при ошибке сеть не дёргает; «Повторить» — да.
    await controller.more();
    expect(calls, ['|']);
    offline = false;
    await controller.more(retry: true);
    expect(controller.current.reactors.map((r) => r.userID), ['a']);
    expect(controller.current.done, isFalse);
    await controller.more();
    expect(controller.current.reactors.map((r) => r.userID), ['a', 'b']);
    expect(controller.current.done, isTrue);
    await controller.more();
    expect(calls, ['|', '|', '|p2']);

    // Другая вкладка — свой список, грузится при выборе.
    controller.select('👍');
    await pumpEventQueue();
    expect(controller.emoji, '👍');
    expect(controller.current.reactors.map((r) => r.emoji), ['👍']);
    expect(calls.last, '👍|');
  });

  test('открыть сразу на эмодзи (долгое нажатие на реакцию)', () async {
    final controller = ReactionsListController(load: (emoji, cursor) async => const ReactionsListPage(reactors: []));
    addTearDown(controller.dispose);
    controller.open([(emoji: '', count: 2), (emoji: '👍', count: 1), (emoji: '🔥', count: 1)], emoji: '🔥');
    expect(controller.emoji, '🔥');
    controller.open([(emoji: '👍', count: 1)], emoji: '🔥');
    expect(controller.emoji, '👍');
  });
}
