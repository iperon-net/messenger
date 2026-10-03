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
}

void roundTrip(String raw) {
  final (text, entities) = parseMarkdownShortcuts(raw);
  final back = toMarkdownShortcuts(text, entities);
  final (text2, entities2) = parseMarkdownShortcuts(back);
  expect(text2, text, reason: back);
  expect(dump(text2, entities2), dump(text, entities), reason: back);
}
