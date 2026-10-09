import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/message_formatting.dart';
import 'package:messenger/models.dart' as models;

void main() {
  ComposeEdit sel(String text, String selected) {
    final start = text.indexOf(selected);
    return (text: text, start: start, end: start + selected.length);
  }

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
      expect(on.text, 'a ++b++ c');
      expect(activeComposeFormats(on), contains(ComposeFormat.underline));
      final off = applyComposeFormat(on, ComposeFormat.underline);
      expect(off.text, 'a b c');
    });

    test('removing one format keeps the other', () {
      var edit = applyComposeFormat(sel('a b c', 'b'), ComposeFormat.bold);
      edit = applyComposeFormat(edit, ComposeFormat.italic);
      expect(edit.text, 'a **__b__** c');
      expect(activeComposeFormats(edit), containsAll([ComposeFormat.bold, ComposeFormat.italic]));
      edit = applyComposeFormat(edit, ComposeFormat.bold);
      expect(edit.text, 'a __b__ c');
    });

    test('pre on single line, active, toggles off', () {
      final on = applyComposeFormat(sel('x code y', 'code'), ComposeFormat.pre);
      expect(on.text, 'x ```\ncode``` y');
      final active = activeComposeFormats(on);
      expect(active, contains(ComposeFormat.pre));
      expect(active, isNot(contains(ComposeFormat.code)));
      expect(applyComposeFormat(on, ComposeFormat.pre).text, 'x code y');
    });

    test('link and mention wrap and unwrap', () {
      final link = applyComposeFormat(sel('see site', 'site'), ComposeFormat.link, url: 'https://a.ru');
      expect(link.text, 'see [site](https://a.ru)');
      expect(activeComposeFormats(link), contains(ComposeFormat.link));
      expect(applyComposeFormat(link, ComposeFormat.link).text, 'see site');
      final mention = applyComposeFormat(sel('hi Anna', 'Anna'), ComposeFormat.mention, userID: 'u1');
      expect(mention.text, 'hi [Anna](mention:u1)');
      expect(activeComposeFormats(mention), contains(ComposeFormat.mention));
      expect(applyComposeFormat(mention, ComposeFormat.mention).text, 'hi Anna');
    });

    test('quote kinds switch', () {
      final quote = applyComposeFormat(sel('one\ntwo', 'one\ntwo'), ComposeFormat.quote);
      expect(quote.text, '> one\n> two');
      expect(activeComposeFormats(quote), contains(ComposeFormat.quote));
      final expandable = applyComposeFormat(quote, ComposeFormat.quoteExpandable);
      expect(expandable.text, '>> one\n>> two');
      expect(activeComposeFormats(expandable), {ComposeFormat.quoteExpandable});
      expect(applyComposeFormat(expandable, ComposeFormat.quoteExpandable).text, 'one\ntwo');
    });
  });
}
