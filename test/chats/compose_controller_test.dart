import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/message_formatting.dart';
import 'package:messenger/screens/chats/compose_controller.dart';

void main() {
  TextEditingValue typed(String text) => TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );

  test('формат виден в поле, наружу — ярлыки', () {
    final input = ComposeController(markdown: 'привет **мир**');
    expect(input.text, 'привет мир');
    input.selection = const TextSelection(baseOffset: 0, extentOffset: 6);
    input.applyFormat(ComposeFormat.italic);
    expect(input.markdown, '__привет__ **мир**');
    expect(input.activeFormats, {ComposeFormat.italic});
  });

  test('набор после формата — уже без него, очистка убирает', () {
    final input = ComposeController(markdown: '**ab**');
    input.value = typed('abc');
    expect(input.markdown, '**ab**c');
    input.clear();
    expect(input.entities, isEmpty);
    input.value = typed('x');
    expect(input.markdown, 'x');
  });

  test('отмена возвращает и разметку', () {
    final input = ComposeController();
    final first = typed('hello');
    input.value = first;
    input.selection = const TextSelection(baseOffset: 0, extentOffset: 5);
    input.applyFormat(ComposeFormat.bold);
    input.value = const TextEditingValue(text: '', selection: TextSelection.collapsed(offset: 0));
    expect(input.markdown, '');
    // История правок поля возвращает тот же объект значения.
    input.value = first;
    expect(input.markdown, '**hello**');
  });
}
