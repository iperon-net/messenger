import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models.dart' as models;
import 'package:messenger/screens/chats/chat_common.dart';

void main() {
  late Translations t;

  setUpAll(() async {
    t = await AppLocale.ru.build();
  });

  test('заблокированный модерацией чат: писать нельзя, вместо статуса — пометка', () {
    const open = models.Chat(id: 'c1', type: models.ChatType.channel, title: 'Канал', myRole: models.ChatRole.owner);
    expect(open.canPost, isTrue);

    final blocked = open.copyWith(moderationBlocked: true);
    expect(blocked.canPost, isFalse);
    expect(chatSubtitle(t, blocked).text, t.screenChat.moderationBlocked);
  });
}
