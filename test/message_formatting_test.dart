import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/message_formatting.dart';
import 'package:messenger/models.dart' as models;

void main() {
  // Поле из текста с ярлыками [source], выделено [selected] (в плоском тексте).
  ComposeEdit sel(String source, String selected) {
    final (text, entities) = parseMarkdownShortcuts(source);
    final start = text.indexOf(selected);
    return (text: text, entities: entities, start: start, end: start + selected.length);
  }

  String md(ComposeEdit edit) => toMarkdownShortcuts(edit.text, edit.entities);

  group('parseMarkdownShortcuts', () {
    test('underline', () {
      final (text, entities) = parseMarkdownShortcuts('a ++b++ c');
      expect(text, 'a b c');
      expect(entities.single.type, models.MessageEntityType.underline);
      expect((entities.single.offset, entities.single.length), (2, 1));
    });

    test('mention by id', () {
      final (text, entities) = parseMarkdownShortcuts('hi [Анна](mention:u1)!');
      expect(text, 'hi Анна!');
      expect(entities.single.type, models.MessageEntityType.mentionName);
      expect(entities.single.userID, 'u1');
    });

    test('expandable and plain quotes', () {
      final (text, entities) = parseMarkdownShortcuts('>> one\n>> two\n> three\nfour');
      expect(text, 'one\ntwo\nthree\nfour');
      final quotes = entities.where((e) => e.type == models.MessageEntityType.blockquote).toList();
      expect(quotes.length, 2);
      expect((quotes[0].offset, quotes[0].length, quotes[0].expandable), (0, 7, true));
      expect((quotes[1].offset, quotes[1].length, quotes[1].expandable), (8, 5, false));
    });

    test('round trip', () {
      const source = '**b** ++u++ [t](https://x.ru) [n](mention:u2)\n```\ncode```\n>> q';
      final (text, entities) = parseMarkdownShortcuts(source);
      final (text2, entities2) = parseMarkdownShortcuts(toMarkdownShortcuts(text, entities));
      expect(text2, text);
      expect(
        entities2.map((e) => (e.type, e.offset, e.length, e.url, e.userID, e.expandable)).toList(),
        entities.map((e) => (e.type, e.offset, e.length, e.url, e.userID, e.expandable)).toList(),
      );
    });
  });

  group('applyComposeFormat / activeComposeFormats', () {
    test('underline toggles', () {
      final on = applyComposeFormat(sel('a b c', 'b'), ComposeFormat.underline);
      expect(on.text, 'a b c');
      expect(md(on), 'a ++b++ c');
      expect(activeComposeFormats(on), contains(ComposeFormat.underline));
      final off = applyComposeFormat(on, ComposeFormat.underline);
      expect(md(off), 'a b c');
    });

    test('removing one format keeps the other', () {
      var edit = applyComposeFormat(sel('a b c', 'b'), ComposeFormat.bold);
      edit = applyComposeFormat(edit, ComposeFormat.italic);
      expect(md(edit), 'a **__b__** c');
      expect(activeComposeFormats(edit), containsAll([ComposeFormat.bold, ComposeFormat.italic]));
      edit = applyComposeFormat(edit, ComposeFormat.bold);
      expect(md(edit), 'a __b__ c');
    });

    test('part of a word, then the whole word', () {
      var edit = applyComposeFormat(sel('hello', 'ell'), ComposeFormat.bold);
      expect(md(edit), 'h**ell**o');
      edit = applyComposeFormat((text: edit.text, entities: edit.entities, start: 0, end: 5), ComposeFormat.bold);
      expect(md(edit), '**hello**');
      // Снять с середины — края остаются.
      edit = applyComposeFormat((text: edit.text, entities: edit.entities, start: 1, end: 4), ComposeFormat.bold);
      expect(md(edit), '**h**ell**o**');
    });

    test('pre on single line, active, toggles off', () {
      final on = applyComposeFormat(sel('x code y', 'code'), ComposeFormat.pre);
      expect(md(on), 'x ```\ncode``` y');
      final active = activeComposeFormats(on);
      expect(active, contains(ComposeFormat.pre));
      expect(active, isNot(contains(ComposeFormat.code)));
      expect(md(applyComposeFormat(on, ComposeFormat.pre)), 'x code y');
    });

    test('code drops formatting inside', () {
      final code = applyComposeFormat(sel('a **bc** d', 'bc d'), ComposeFormat.code);
      expect(md(code), 'a `bc d`');
    });

    test('link and mention wrap and unwrap', () {
      final link = applyComposeFormat(sel('see site', 'site'), ComposeFormat.link, url: 'https://a.ru');
      expect(md(link), 'see [site](https://a.ru)');
      expect(activeComposeFormats(link), contains(ComposeFormat.link));
      expect(md(applyComposeFormat(link, ComposeFormat.link)), 'see site');
      final mention = applyComposeFormat(sel('hi Anna', 'Anna'), ComposeFormat.mention, userID: 'u1');
      expect(md(mention), 'hi [Anna](mention:u1)');
      expect(activeComposeFormats(mention), contains(ComposeFormat.mention));
      expect(md(applyComposeFormat(mention, ComposeFormat.mention)), 'hi Anna');
    });

    test('quote kinds switch', () {
      final quote = applyComposeFormat(sel('one\ntwo', 'one\ntwo'), ComposeFormat.quote);
      expect(md(quote), '> one\n> two');
      expect(activeComposeFormats(quote), contains(ComposeFormat.quote));
      final expandable = applyComposeFormat(quote, ComposeFormat.quoteExpandable);
      expect(md(expandable), '>> one\n>> two');
      expect(activeComposeFormats(expandable), {ComposeFormat.quoteExpandable});
      expect(md(applyComposeFormat(expandable, ComposeFormat.quoteExpandable)), 'one\ntwo');
    });

    test('crossing formats nest when written as shortcuts', () {
      var edit = applyComposeFormat(sel('abcd', 'abc'), ComposeFormat.bold);
      edit = applyComposeFormat((text: edit.text, entities: edit.entities, start: 1, end: 4), ComposeFormat.italic);
      final (text, entities) = parseMarkdownShortcuts(md(edit));
      expect(text, 'abcd');
      bool has(models.MessageEntityType type, int at) => entities.any((e) => e.type == type && e.offset <= at && at < e.end);
      expect(
        [for (var i = 0; i < 4; i++) (has(models.MessageEntityType.bold, i), has(models.MessageEntityType.italic, i))],
        [(true, false), (true, true), (true, true), (false, true)],
      );
    });
  });

  group('shiftComposeEntities', () {
    List<models.MessageEntity> bold(int offset, int length) => [
      models.MessageEntity(type: models.MessageEntityType.bold, offset: offset, length: length),
    ];
    String shift(String from, String to, List<models.MessageEntity> entities, {int caret = -1}) =>
        toMarkdownShortcuts(to, shiftComposeEntities(from, to, entities, caret: caret));

    test('typing inside keeps the format, at the edges does not', () {
      expect(shift('ab c', 'aXb c', bold(0, 2), caret: 2), '**aXb** c');
      expect(shift('ab c', 'abX c', bold(0, 2), caret: 3), '**ab**X c');
      expect(shift('ab c', 'Xab c', bold(0, 2), caret: 1), 'X**ab** c');
    });

    test('repeated letters use the caret', () {
      expect(shift('aa', 'aaa', bold(0, 1), caret: 1), 'a**a**a');
      expect(shift('aa', 'aaa', bold(0, 1), caret: 2), '**a**aa');
      expect(shift('aa', 'aaa', bold(1, 1), caret: 1), 'aa**a**');
    });

    test('links do not grow when typing after them', () {
      final link = [models.MessageEntity(type: models.MessageEntityType.textUrl, offset: 0, length: 2, url: 'https://a.ru')];
      expect(shift('ab', 'abc', link, caret: 3), '[ab](https://a.ru)c');
    });

    test('deleting and replacing', () {
      expect(shift('xaby', 'xy', bold(1, 2), caret: 1), 'xy');
      expect(shift('xaby', 'xby', bold(1, 2), caret: 1), 'x**b**y');
      // Заменили выделение внутри формата — новое в нём же.
      expect(shift('xabcy', 'xaZcy', bold(1, 3)), 'x**aZc**y');
    });
  });
}
