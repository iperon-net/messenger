import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show PointerDeviceKind, kSecondaryMouseButton;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show MaterialApp, SelectionArea;
import 'package:messenger/components/chats/message_bubble.dart';
import 'package:messenger/components/chats/message_text.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/screens/chats/message_context_menu_cupertino.dart';

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
        child: MaterialApp(
          home: ChatMessagesView(
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

  testWidgets('на десктопе текст сообщения можно выделить мышью', (tester) async {
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: ChatMessagesView(
            messages: [models.Message(id: '1', chatID: 'chat', text: 'Текст для копирования', date: DateTime(2026, 11, 6))],
            chatType: models.ChatType.private,
            style: style,
            onLongPress: (_) {},
          ),
        ),
      ),
    );

    expect(find.byType(SelectionArea), findsOneWidget);
  });

  testWidgets('правый клик по тексту сообщения открывает его меню', (tester) async {
    var opened = 0;
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: ChatMessagesView(
            messages: [models.Message(id: '1', chatID: 'chat', text: 'Текст для копирования', date: DateTime(2026, 11, 6))],
            chatType: models.ChatType.private,
            style: style,
            onLongPress: (_) => opened++,
          ),
        ),
      ),
    );

    final click = await tester.startGesture(
      tester.getCenter(find.byType(SelectionArea)),
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await tester.pump();
    await click.up();

    expect(opened, 1);
  });

  testWidgets('превью и действия помещаются при большом тексте', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final message = ConstrainedBox(constraints: const BoxConstraints(maxWidth: 250), child: Text('Длинное сообщение. ' * 100));
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(padding: EdgeInsets.symmetric(vertical: 30), textScaler: TextScaler.linear(1.6)),
        child: CupertinoApp(
          home: Center(
            child: MessageContextMenuCupertino(
              actions: [for (var i = 0; i < 4; i++) CupertinoContextMenuAction(onPressed: () {}, child: Text('Действие $i'))],
              bubble: message,
              preview: (_) => message,
            ),
          ),
        ),
      ),
    );

    final press = await tester.startGesture(tester.getCenter(find.byType(MessageContextMenuCupertino)));
    await tester.pump(const Duration(milliseconds: 700));
    await press.up();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.descendant(of: find.byType(MessageContextMenuCupertino), matching: find.byType(FittedBox)), findsNothing);
    for (final action in find.byType(CupertinoContextMenuAction).evaluate()) {
      final rect = tester.getRect(find.byWidget(action.widget));
      expect(rect.top, greaterThanOrEqualTo(30));
      expect(rect.bottom, lessThanOrEqualTo(538));
    }
    debugDefaultTargetPlatformOverride = null;
  });
}
