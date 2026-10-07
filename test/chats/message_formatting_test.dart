import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/message_formatting.dart';
import 'package:messenger/models.dart';

String dump(String text, List<MessageEntity> entities) =>
    entities.map((e) => '${e.type.name}:${text.substring(e.offset, e.end)}${e.url.isEmpty ? '' : '>${e.url}'}').join(',');

void main() {
  test('простые ярлыки', () {
    final (text, entities) = parseMarkdownShortcuts('**жирный** и __курсив__, ~~нет~~ ||тайна|| `код`');
    expect(text, 'жирный и курсив, нет тайна код');
    expect(dump(text, entities), 'bold:жирный,italic:курсив,strike:нет,spoiler:тайна,code:код');
  });

  test('вложенность и ссылка', () {
    final (text, entities) = parseMarkdownShortcuts('**жир __и курсив__** [сайт](https://iperon.net)');
    expect(text, 'жир и курсив сайт');
    expect(dump(text, entities), 'bold:жир и курсив,italic:и курсив,textUrl:сайт>https://iperon.net');
  });

  test('код не размечается внутри', () {
    final (text, entities) = parseMarkdownShortcuts('`**a**` и ```\nfinal x = 1;\n```');
    expect(text, '**a** и final x = 1;\n');
    expect(dump(text, entities), 'code:**a**,pre:final x = 1;\n');
  });

  test('цитата', () {
    final (text, entities) = parseMarkdownShortcuts('> первая **строка**\n> вторая\nответ');
    expect(text, 'первая строка\nвторая\nответ');
    expect(dump(text, entities), 'blockquote:первая строка\nвторая,bold:строка');
  });

  test('без разметки — как есть', () {
    final (text, entities) = parseMarkdownShortcuts('2 * 3 = 6, a_b_c, > не цитата');
    expect(text, '2 * 3 = 6, a_b_c, > не цитата');
    expect(entities, isEmpty);
  });

  test('обратно в ярлыки (редактирование)', () {
    roundTrip('**жир __и курсив__** [сайт](https://iperon.net) ~~x~~ ||y|| `код`');
    roundTrip('> первая **строка**\n> вторая\nответ');
    roundTrip('```\nfinal x = 1;\n```');
  });

  test('авто-ссылки', () {
    const text = 'Пиши на a@b.ru, смотри https://iperon.net. @kostya #релиз';
    expect(dump(text, detectAutoEntities(text, const [])), 'url:https://iperon.net,email:a@b.ru,mention:@kostya,hashtag:#релиз');
  });
  group('меню форматирования', () {
    ComposeEdit sel(String text, String selected) {
      final start = text.indexOf(selected);
      return (text: text, start: start, end: start + selected.length);
    }

    test('обернуть и снять', () {
      final bold = applyComposeFormat(sel('привет мир', 'мир'), ComposeFormat.bold);
      expect(bold, (text: 'привет **мир**', start: 9, end: 12));
      expect(applyComposeFormat(bold, ComposeFormat.bold), (text: 'привет мир', start: 7, end: 10));
      // Выделили вместе с ярлыками.
      expect(applyComposeFormat(sel('a ~~b~~', '~~b~~'), ComposeFormat.strike).text, 'a b');
      expect(
        parseMarkdownShortcuts(applyComposeFormat(sel('x тайна', 'тайна'), ComposeFormat.spoiler).text).$2.single.type,
        MessageEntityType.spoiler,
      );
    });

    test('код: строка и блок', () {
      expect(applyComposeFormat(sel('run ls', 'ls'), ComposeFormat.code).text, 'run `ls`');
      final block = applyComposeFormat(sel('a\nb', 'a\nb'), ComposeFormat.code);
      expect(block.text, '```\na\nb```');
      final (text, entities) = parseMarkdownShortcuts(block.text);
      expect(dump(text, entities), 'pre:a\nb');
      expect(applyComposeFormat(block, ComposeFormat.code).text, 'a\nb');
    });

    test('ссылка', () {
      final link = applyComposeFormat(sel('см. сайт', 'сайт'), ComposeFormat.link, url: 'https://iperon.net');
      final (text, entities) = parseMarkdownShortcuts(link.text);
      expect(dump(text, entities), 'textUrl:сайт>https://iperon.net');
    });

    test('цитата на целые строки', () {
      final quote = applyComposeFormat(sel('раз\nдва\nтри', 'ва\nтр'), ComposeFormat.quote);
      expect(quote.text, 'раз\n> два\n> три');
      expect(applyComposeFormat(quote, ComposeFormat.quote).text, 'раз\nдва\nтри');
    });

    test('обычный — убрать разметку', () {
      expect(applyComposeFormat(sel('a **b __c__** d', '**b __c__**'), ComposeFormat.plain).text, 'a b c d');
      expect(applyComposeFormat(sel('a **b** d', 'b'), ComposeFormat.plain).text, 'a b d');
    });
  });
  test('первая ссылка для превью', () {
    expect(firstLinkUrl('без ссылок', const []), isNull);
    expect(firstLinkUrl('см. www.iperon.net и https://flutter.dev', const []), 'https://www.iperon.net');
    final (text, entities) = parseMarkdownShortcuts('https://a.dev и [сайт](https://b.dev)');
    expect(firstLinkUrl(text, entities), 'https://a.dev');
    final (text2, entities2) = parseMarkdownShortcuts('[сайт](https://b.dev), потом https://a.dev');
    expect(firstLinkUrl(text2, entities2), 'https://b.dev');
    // В коде ссылки не ищем.
    final (text3, entities3) = parseMarkdownShortcuts('`https://a.dev`');
    expect(firstLinkUrl(text3, entities3), isNull);
  });

  test('упоминание по имени — mentionName с id', () {
    const anna = ChatMember(id: 'u1', name: 'Анна Смирнова');
    final (text, entities) = parseMarkdownShortcuts('**Привет**, Анна Смирнова, глянь');
    final result = withMentionNames(text, entities, [anna]);
    expect(dump(text, result), 'bold:Привет,mentionName:Анна Смирнова');
    expect(result.last.userID, 'u1');
  });

  test('упоминание внутри кода не ставится', () {
    const ivan = ChatMember(id: 'u2', name: 'Иван');
    final (text, entities) = parseMarkdownShortcuts('`Иван` и Иван');
    final result = withMentionNames(text, entities, [ivan]);
    expect(dump(text, result), 'code:Иван,mentionName:Иван');
    expect(result.last.offset, text.lastIndexOf('Иван'));
  });
}

void roundTrip(String raw) {
  final (text, entities) = parseMarkdownShortcuts(raw);
  final back = toMarkdownShortcuts(text, entities);
  final (text2, entities2) = parseMarkdownShortcuts(back);
  expect(text2, text, reason: back);
  expect(dump(text2, entities2), dump(text, entities), reason: back);
}
