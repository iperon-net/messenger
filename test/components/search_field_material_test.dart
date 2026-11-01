import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:messenger/components/search_field_material.dart';

void main() {
  testWidgets('крестик есть только с текстом и очищает запрос', (tester) async {
    final controller = TextEditingController();
    final changes = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchFieldMaterial(controller: controller, hintText: 'Поиск', onChanged: changes.add),
        ),
      ),
    );
    expect(find.byIcon(Icons.cancel), findsNothing);

    await tester.enterText(find.byType(TextField), 'тест');
    await tester.pump();
    expect(find.byIcon(Icons.cancel), findsOneWidget);

    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(changes.last, '');
    expect(find.byIcon(Icons.cancel), findsNothing);
  });
}
