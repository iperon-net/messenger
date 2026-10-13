import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/deep_links.dart';

// Внешние ссылки: iperon.net/<путь> (полный адрес или только путь) —
// запоминаются; разделы приложения, корень и чужие сайты — нет.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final links = DeepLinks.instance;

  test('что считается внешней ссылкой', () {
    expect(links.capture(Uri.parse('https://iperon.net/Anna_Smith')), isTrue);
    expect(links.take(), Uri.parse('https://iperon.net/Anna_Smith'));
    expect(links.take(), isNull);

    expect(links.capture(Uri.parse('/anna_smith')), isTrue);
    expect(links.take()?.path, '/anna_smith');
    expect(links.capture(Uri.parse('https://www.iperon.net/+abc?x=1')), isTrue);
    expect(links.take()?.toString(), 'https://iperon.net/+abc?x=1');

    for (final uri in ['/', '/chats', '/chats/chat/1', '/settings/developer', '/auth', '/profile/1', 'https://example.com/anna_smith']) {
      expect(links.capture(Uri.parse(uri)), isFalse, reason: uri);
    }
    expect(links.take(), isNull);
  });
}
