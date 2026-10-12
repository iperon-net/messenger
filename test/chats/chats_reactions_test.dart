import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_mapping.dart';
import 'package:messenger/chats/reactions.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/protobuf/protos/chats_v1.pb.dart' as pb;

void main() {
  final me = List<int>.filled(12, 1);
  final peer = List<int>.filled(12, 2);

  pb.MessageReaction reaction(List<int> userID, String emoji, int date) =>
      pb.MessageReaction(userID: userID, emoji: emoji, date: Int64(date));

  test('реакции сервера → чипы: по первой постановке, с числом и нашим порядком', () {
    final chips = reactionsFromPb(
      pb.MessageReactions(reactions: [reaction(peer, '❤️', 1), reaction(me, '👍', 2), reaction(me, '❤️', 3), reaction(peer, '🔥', 4)]),
      myUserID: me,
    );
    expect([for (final c in chips) c.emoji], ['❤️', '👍', '🔥']);
    expect([for (final c in chips) c.count], [2, 1, 1]);
    expect([for (final c in chips) c.chosen], [true, true, false]);

    final message = models.Message(id: '1', chatID: 'c', reactions: chips, date: DateTime(2026));
    // Наши — в порядке постановки (👍 раньше ❤️), хотя чип ❤️ левее.
    expect(message.myReactions, ['👍', '❤️']);
    // Сверх лимита вытесняется самая ранняя наша — 👍, а не ❤️.
    expect(toggleMyReaction(['👍', '❤️', '😂'], '🔥'), ['❤️', '😂', '🔥']);
  });

  test('неотправленный набор поверх серверных: свои снимаются, чужие остаются', () {
    final server = reactionsFromPb(pb.MessageReactions(reactions: [reaction(peer, '❤️', 1), reaction(me, '❤️', 2)]), myUserID: me);
    final shown = applyMyReactions(server, ['👍']);
    expect([for (final c in shown) (c.emoji, c.count, c.chosen)], [('❤️', 1, false), ('👍', 1, true)]);
  });

  test('сообщение из кэша несёт реакции', () {
    final message = messageFromPb(
      pb.ChatMessage(
        chatID: List<int>.filled(12, 9),
        messageID: Int64(5),
        fromUserID: peer,
        date: Int64(1000),
        content: pb.MessageContent(text: 'привет'),
        reactions: pb.MessageReactions(reactions: [reaction(me, '🔥', 2)]),
      ),
      chatID: 'c',
      myUserID: me,
      readOutboxMaxID: 0,
      isSelf: false,
    );
    expect(message.myReactions, ['🔥']);
  });
}
