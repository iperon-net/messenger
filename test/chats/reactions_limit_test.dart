import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/reactions.dart';
import 'package:messenger/models.dart' as models;

void main() {
  test('лимит разных реакций под постом канала: набран — только уже стоящие', () {
    const channel = models.Chat(id: 'c', type: models.ChatType.channel, title: 'c', maxReactions: 2);
    final post = models.Message(
      id: 'm',
      chatID: 'c',
      date: DateTime(2026),
      reactions: const [
        models.MessageReaction(emoji: '🔥', count: 5),
        models.MessageReaction(emoji: '👍'),
      ],
    );
    expect(availableReactions(channel, message: post), ['👍', '🔥']);
    expect(quickReaction(channel, message: post), '👍');
    // Лимит не набран — все разрешённые.
    expect(availableReactions(channel.copyWith(maxReactions: 3), message: post), allChatReactions);
    // В группе лимита нет.
    expect(availableReactions(channel.copyWith(type: models.ChatType.group), message: post), allChatReactions);
  });
}
