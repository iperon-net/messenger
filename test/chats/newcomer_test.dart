import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/newcomer.dart';
import 'package:messenger/models.dart' as models;

void main() {
  final date = DateTime(2026, 10, 8);

  group('isLinkFree', () {
    test('plain text', () => expect(isLinkFree('Привет, как дела?', const []), isTrue));

    test('url in text', () => expect(isLinkFree('Заходи на example.com/promo', const []), isFalse));

    test('www link', () => expect(isLinkFree('смотри www.spam.ru', const []), isFalse));

    test('cyrillic domain', () => expect(isLinkFree('скидки на сайт.рф', const []), isFalse));

    test('not a domain', () {
      expect(isLinkFree('пишу на node.js, т.е. быстро; версия 1.2', const []), isTrue);
      expect(isLinkFree('почта a@b.com — не ссылка', const []), isTrue);
    });

    test('explicit text link', () {
      const link = models.MessageEntity(type: models.MessageEntityType.textUrl, offset: 0, length: 5, url: 'https://x.io');
      expect(isLinkFree('жмите', const [link]), isFalse);
    });
  });

  group('newcomerAllows', () {
    test('text without links', () {
      expect(newcomerAllows(models.Message(id: '1', chatID: 'c', text: 'Спасибо!', date: date)), isTrue);
    });

    test('text with link', () {
      expect(newcomerAllows(models.Message(id: '1', chatID: 'c', text: 'https://t.me/x', date: date)), isFalse);
    });

    test('media', () {
      expect(newcomerAllows(models.Message(id: '1', chatID: 'c', kind: models.MessageKind.photo, date: date)), isFalse);
    });
  });
}
