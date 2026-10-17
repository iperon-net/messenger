import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/components/chats/chat_tile.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models.dart' as models;

void main() {
  late Translations t;
  setUpAll(() async => t = await AppLocale.ru.build());

  models.Chat chat(models.ChatType type, List<models.ChatTyping> typing) => models.Chat(id: '1', type: type, title: 'Анна', typing: typing);

  test('личный чат — без имени, по действию', () {
    expect(ChatTileContent.typing(t, chat(models.ChatType.private, const [])), '');
    expect(ChatTileContent.typing(t, chat(models.ChatType.private, const [models.ChatTyping(userID: 'a', name: 'Анна')])), 'печатает…');
    expect(
      ChatTileContent.typing(
        t,
        chat(models.ChatType.private, const [models.ChatTyping(userID: 'a', name: 'Анна', activity: models.ChatActivity.uploadVideo)]),
      ),
      'отправляет видео…',
    );
  });

  test('группа — с именами', () {
    const anna = models.ChatTyping(userID: 'a', name: 'Анна', activity: models.ChatActivity.recordVoice);
    const oleg = models.ChatTyping(userID: 'b', name: 'Олег');
    const ivan = models.ChatTyping(userID: 'c', name: 'Иван');
    expect(ChatTileContent.typing(t, chat(models.ChatType.group, const [anna])), 'Анна записывает аудио…');
    expect(ChatTileContent.typing(t, chat(models.ChatType.group, const [anna, oleg])), 'Анна и Олег печатают…');
    expect(ChatTileContent.typing(t, chat(models.ChatType.group, const [anna, oleg, ivan])), '3 человека печатают…');
  });
}
