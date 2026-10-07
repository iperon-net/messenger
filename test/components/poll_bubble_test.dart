import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/components/chats/message_bubble.dart';
import 'package:messenger/components/chats/message_text.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models.dart' as models;

/// Пузырь с опросом: голосование переключает варианты на итоги — без ошибок
/// раскладки (пузырь меряется IntrinsicWidth) и семантики.
void main() {
  const colors = MessageTextColors(
    text: Color(0xFF000000),
    link: Color(0xFF007AFF),
    codeBackground: Color(0x11000000),
    spoiler: Color(0x33000000),
    quote: Color(0x99000000),
  );
  const style = MessageBubbleStyle(
    incoming: Color(0xFFFFFFFF),
    outgoing: Color(0xFF007AFF),
    incomingText: colors,
    outgoingText: colors,
    incomingMeta: Color(0x99000000),
    outgoingMeta: Color(0xCCFFFFFF),
    pill: Color(0x22000000),
    pillText: Color(0xFF000000),
    textStyle: TextStyle(fontSize: 16),
  );

  models.Message message(models.MessagePoll poll) => models.Message(
    id: 'm1',
    chatID: 'c1',
    kind: models.MessageKind.poll,
    text: poll.question,
    poll: poll,
    date: DateTime(2026, 10, 7, 12),
  );

  const poll = models.MessagePoll(
    question: 'Когда созвон?',
    anonymous: false,
    options: [
      models.PollOption(text: 'Понедельник', votes: 2),
      models.PollOption(text: 'Вторник', votes: 3),
    ],
  );

  Future<void> pump(WidgetTester tester, models.Message m, ValueChanged<List<int>> onVote) => tester.pumpWidget(
    TranslationProvider(
      child: CupertinoApp(
        home: CupertinoPageScaffold(
          child: Center(
            child: MessageBubble(message: m, style: style, tail: true, showSender: false, onLongPress: () {}, onPollVote: onVote),
          ),
        ),
      ),
    ),
  );

  testWidgets('голос — итоги без ошибок', (tester) async {
    final semantics = tester.ensureSemantics();
    var current = message(poll);
    List<int>? voted;
    await pump(tester, current, (options) => voted = options);
    await tester.tap(find.text('Вторник'));
    expect(voted, [1]);

    current = current.copyWith(poll: poll.copyWith(options: [poll.options[0], poll.options[1].copyWith(votes: 4, chosen: true)]));
    await pump(tester, current, (_) {});
    await tester.pumpAndSettle();
    expect(find.text('67%'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
