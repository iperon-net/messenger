import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/components/dust_effect.dart';

void main() {
  testWidgets('снимок, пыль в оверлее и уборка по окончании', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (_) => Center(
                child: DustSource(
                  key: key,
                  child: Container(width: 120, height: 40, color: const Color(0xFF3366FF)),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final snapshot = await tester.runAsync(() => DustEffect.capture(key.currentContext));
    expect(snapshot, isNotNull);
    expect(snapshot!.rect.size, const Size(120, 40));

    final before = find.byType(CustomPaint).evaluate().length;
    DustEffect.play(key.currentContext!, [snapshot]);
    await tester.pump();
    expect(find.byType(CustomPaint).evaluate().length, before + 1);
    await tester.pump(DustEffect.duration);
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pumpAndSettle();
    // Оверлей пыли убран.
    expect(find.byType(CustomPaint).evaluate().length, before);
  });
}
