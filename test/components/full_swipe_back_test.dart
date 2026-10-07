import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' as m;
import 'package:messenger/components/chats/swipe_to_reply.dart';
import 'package:messenger/components/full_swipe_back.dart';

void main() {
  Future<({List<String> replies})> pumpChat(WidgetTester tester) async {
    final replies = <String>[];
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      CupertinoApp(
        home: Navigator(
          key: navigator,
          onGenerateRoute: (_) => CupertinoPageRoute<void>(builder: (_) => const Center(child: Text('list'))),
        ),
      ),
    );
    navigator.currentState!.push(
      FullSwipeBackPage<void>(
        child: CupertinoPageScaffold(
          child: Center(
            child: SwipeToReply(
              onReply: () => replies.add('reply'),
              background: const Color(0xFF000000),
              iconColor: const Color(0xFFFFFFFF),
              child: const SizedBox(width: 300, height: 60, child: Text('bubble')),
            ),
          ),
        ),
      ).createRoute(navigator.currentContext!),
    );
    await tester.pumpAndSettle();
    return (replies: replies);
  }

  testWidgets('свайп вправо из середины экрана закрывает страницу', (tester) async {
    await pumpChat(tester);
    expect(find.text('bubble'), findsOneWidget);
    await tester.timedDrag(find.text('bubble'), const Offset(300, 0), const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('bubble'), findsNothing);
    expect(find.text('list'), findsOneWidget);
  });

  testWidgets('свайп влево по пузырю — ответ, страница остаётся', (tester) async {
    final chat = await pumpChat(tester);
    await tester.timedDrag(find.text('bubble'), const Offset(-120, 0), const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(chat.replies, ['reply']);
    expect(find.text('bubble'), findsOneWidget);
  });

  testWidgets('короткий медленный свайп вправо — страница возвращается', (tester) async {
    await pumpChat(tester);
    await tester.timedDrag(find.text('bubble'), const Offset(60, 0), const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('bubble'), findsOneWidget);
  });

  testWidgets('Android: свайп вправо закрывает страницу поверх Material-экрана', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      m.MaterialApp(
        home: Navigator(
          key: navigator,
          onGenerateRoute: (_) => m.MaterialPageRoute<void>(
            builder: (_) => const m.Scaffold(body: Center(child: Text('list'))),
          ),
        ),
      ),
    );
    navigator.currentState!.push(
      const FullSwipeBackPage<void>(
        transitionDuration: Duration(milliseconds: 300),
        child: m.Scaffold(body: Center(child: Text('chat'))),
      ).createRoute(navigator.currentContext!),
    );
    await tester.pumpAndSettle();
    await tester.timedDrag(find.text('chat'), const Offset(300, 0), const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('chat'), findsNothing);
    expect(find.text('list'), findsOneWidget);
  });

  // Экран под чатом (список в оболочке go_router — NoTransitionPage) во время
  // свайпа и после отпускания должен идти синхронно с чатом, без рывков.
  for (final (steps, popped) in [(12, false), (30, true)]) {
    testWidgets('свайп ${popped ? 'с закрытием' : 'с возвратом'}: экран под чатом едет синхронно с чатом', (tester) async {
      final navigator = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        CupertinoApp(
          home: Navigator(
            key: navigator,
            onGenerateRoute: (_) => PageRouteBuilder<void>(
              transitionDuration: Duration.zero,
              pageBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFFFFFFF),
                child: Center(child: Text('list')),
              ),
            ),
          ),
        ),
      );
      navigator.currentState!.push(
        const FullSwipeBackPage<void>(
          child: ColoredBox(
            color: Color(0xFFEEEEEE),
            child: Center(child: Text('chat')),
          ),
        ).createRoute(navigator.currentContext!),
      );
      await tester.pumpAndSettle();
      final width = tester.getSize(find.byType(Navigator).first).width;
      final center = tester.getCenter(find.text('chat'));
      double chatX() => tester.getCenter(find.text('chat')).dx - center.dx;
      double listX() => tester.getCenter(find.text('list')).dx - center.dx;

      void expectInSync(String phase) {
        // Чат сдвинут на width·(1−v), список — на −width/3·v.
        final expected = -(width - chatX()) / 3;
        expect(listX(), moreOrLessEquals(expected, epsilon: 1.5), reason: '$phase: chat=${chatX()}');
      }

      final gesture = await tester.startGesture(center);
      for (var i = 0; i < steps; i++) {
        await gesture.moveBy(const Offset(15, 0));
        await tester.pump(const Duration(milliseconds: 16));
        if (i > 2) expectInSync('drag');
      }
      // Отпускаем без скорости: до середины — чат возвращается, дальше — закрывается.
      await tester.pump(const Duration(milliseconds: 500));
      await gesture.up();
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        if (find.text('chat').evaluate().isEmpty || find.text('list').evaluate().isEmpty) break;
        expectInSync('settle');
      }
      await tester.pumpAndSettle();
      expect(find.text('chat'), popped ? findsNothing : findsOneWidget);
      if (popped) expect(listX(), 0);
    });
  }

  // Строка со свайп-действиями (как Slidable в «Архиве»): из середины свайп
  // её, у края — «назад».
  testWidgets('внутренний горизонтальный жест главнее, но не у края', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    var rowDrags = 0;
    await tester.pumpWidget(
      CupertinoApp(
        home: Navigator(
          key: navigator,
          onGenerateRoute: (_) => CupertinoPageRoute<void>(builder: (_) => const Center(child: Text('list'))),
        ),
      ),
    );
    navigator.currentState!.push(
      FullSwipeBackPage<void>(
        child: CupertinoPageScaffold(
          child: Center(
            child: GestureDetector(
              onHorizontalDragEnd: (_) => rowDrags++,
              child: const SizedBox(width: double.infinity, height: 60, child: Text('row')),
            ),
          ),
        ),
      ).createRoute(navigator.currentContext!),
    );
    await tester.pumpAndSettle();
    final row = tester.getRect(find.text('row'));

    await tester.timedDragFrom(row.center, const Offset(300, 0), const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(rowDrags, 1);
    expect(find.text('row'), findsOneWidget);

    await tester.timedDragFrom(Offset(5, row.center.dy), const Offset(500, 0), const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(rowDrags, 1);
    expect(find.text('row'), findsNothing);
  });
}
