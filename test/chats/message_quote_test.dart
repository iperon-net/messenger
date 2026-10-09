import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/message_quote.dart';
import 'package:messenger/models.dart' as models;

void main() {
  group('quoteOf', () {
    test('trims spaces and keeps the offset', () {
      final q = quoteOf('Привет, как дела?', const [], 7, 12)!;
      expect(q.text, 'как');
      expect(q.offset, 8);
    });

    test('only spaces — null', () {
      expect(quoteOf('a   b', const [], 1, 4), isNull);
    });

    test('clips entities to the fragment', () {
      const bold = models.MessageEntity(type: models.MessageEntityType.bold, offset: 0, length: 5);
      const link = models.MessageEntity(type: models.MessageEntityType.textUrl, offset: 6, length: 5, url: 'https://x');
      final q = quoteOf('hello world', const [bold, link], 3, 8)!;
      expect(q.text, 'lo wo');
      expect(q.entities, [
        const models.MessageEntity(type: models.MessageEntityType.bold, offset: 0, length: 2),
        const models.MessageEntity(type: models.MessageEntityType.textUrl, offset: 3, length: 2, url: 'https://x'),
      ]);
    });

    test('limits the length without splitting a surrogate pair', () {
      final text = '${'a' * (models.MessageQuote.maxLength - 1)}😀tail';
      final q = quoteOf(text, const [], 0, text.length)!;
      expect(q.text.length, models.MessageQuote.maxLength - 1);
    });
  });

  group('locateQuote', () {
    test('at its offset when the text repeats', () {
      expect(locateQuote('да, да, да', const models.MessageQuote(text: 'да', offset: 4)), (4, 6));
    });

    test('falls back to the first occurrence after an edit', () {
      expect(locateQuote('ну да, да', const models.MessageQuote(text: 'да', offset: 0)), (3, 5));
    });

    test('gone — null', () {
      expect(locateQuote('нет', const models.MessageQuote(text: 'да', offset: 0)), isNull);
    });
  });
}
