import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/components/chats/message_bubble.dart';
import 'package:messenger/components/chats/message_text.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models.dart' as models;

void main() {
  setUpAll(() async {
    await AppLocale.ru.build();
  });

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

  testWidgets('ручная прокрутка вызывает onDrag, программная — нет', (tester) async {
    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    var drags = 0;
    await tester.pumpWidget(
      TranslationProvider(
        child: CupertinoApp(
          home: CupertinoPageScaffold(
            child: ChatMessagesView(
              messages: [
                for (var i = 0; i < 40; i++)
                  models.Message(id: '$i', chatID: 'chat', text: 'Сообщение $i', date: DateTime(2026, 11, 2, 12, i)),
              ],
              chatType: models.ChatType.private,
              style: style,
              onLongPress: (_) {},
              controller: scroll,
              onDrag: () => drags++,
            ),
          ),
        ),
      ),
    );

    scroll.jumpTo(100);
    await tester.pump();
    expect(drags, 0);

    await tester.drag(find.byType(ListView), const Offset(0, 200));
    await tester.pump();
    expect(drags, 1);

    scroll.jumpTo(0);
    await tester.pump();
    expect(drags, 1);
  });
}
