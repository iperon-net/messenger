import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/components/chats/pill_context_menu.dart';

void main() {
  testWidgets('showPillContextMenu: реплика плашки на её месте, «Удалить» подтверждается', (tester) async {
    const rect = Rect.fromLTWH(100, 300, 390, 35);
    bool? deleted;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (context) => Center(
            child: CupertinoButton(
              onPressed: () async {
                deleted = await showPillContextMenu(context, pill: const Text('Плашка'), rect: rect, deleteLabel: 'Удалить');
              },
              child: const Text('открыть'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('открыть'));
    await tester.pumpAndSettle();

    // Реплика на месте строки, пункт «Удалить» под ней.
    expect(find.text('Плашка'), findsOneWidget);
    final action = tester.getRect(find.text('Удалить'));
    expect(action.top, greaterThanOrEqualTo(rect.bottom));

    await tester.tap(find.text('Удалить'));
    await tester.pumpAndSettle();
    expect(deleted, isTrue);
  });

  testWidgets('мимо пунктов меню — закрытие без удаления', (tester) async {
    bool? deleted;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (context) => Center(
            child: CupertinoButton(
              onPressed: () async {
                deleted = await showPillContextMenu(
                  context,
                  pill: const Text('Плашка'),
                  rect: const Rect.fromLTWH(100, 300, 390, 35),
                  deleteLabel: 'Удалить',
                );
              },
              child: const Text('открыть'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('открыть'));
    await tester.pumpAndSettle();

    // Мимо пунктов — по баръеру маршрута.
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(deleted, isFalse);
  });
}
