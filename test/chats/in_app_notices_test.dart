import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/chats_sync.dart';
import 'package:messenger/components/in_app_notice/in_app_notice_host.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/models.dart' as models;

void main() {
  late Translations t;
  setUpAll(() async => t = await AppLocale.ru.build());

  test('счётчик непрочитанных чатов: всего и без открытого чата', () {
    final unread = ChatsUnread(const {'a': 3, 'secret:b': 2});
    expect(unread.total, 2);
    expect(unread.except('a'), 1);
    expect(unread.except('c'), 2);
    expect(unread, ChatsUnread(const {'secret:b': 2, 'a': 3}));
    expect(ChatsUnread.empty.total, 0);
  });

  group('текст баннера', () {
    final message = models.ChatLastMessage(kind: models.MessageKind.text, text: 'Привет', senderName: 'Анна', date: DateTime(2026));
    final private = models.Chat(id: '1', type: models.ChatType.private, title: 'Анна', lastMessage: message, draft: 'черновик');
    final group = models.Chat(id: '2', type: models.ChatType.group, title: 'Дача', lastMessage: message);

    test('последнее сообщение, а не черновик; в группе — с автором', () {
      expect(InAppNoticeContent.title(t, InAppNotice(chat: private, route: '/chats/chat/1')), 'Анна');
      expect(InAppNoticeContent.text(t, InAppNotice(chat: private, route: '/chats/chat/1')), 'Привет');
      expect(InAppNoticeContent.title(t, InAppNotice(chat: group, route: '/chats/chat/2')), 'Дача');
      expect(InAppNoticeContent.text(t, InAppNotice(chat: group, route: '/chats/chat/2')), 'Анна: Привет');
    });

    test('без «Показывать текст» и от скрытого профиля — «Новое сообщение»', () {
      expect(InAppNoticeContent.text(t, InAppNotice(chat: private, route: '/chats/chat/1', showPreview: false)), 'Новое сообщение');
      final hidden = InAppNotice(chat: private, route: '/chats/chat/1', anonymous: true);
      expect((InAppNoticeContent.title(t, hidden), InAppNoticeContent.text(t, hidden)), ('Iperon', 'Новое сообщение'));
    });

    test('фото без подписи — вид вложения', () {
      final photo = private.copyWith(
        lastMessage: message.copyWith(kind: models.MessageKind.photo, text: ''),
      );
      expect(InAppNoticeContent.text(t, InAppNotice(chat: photo, route: '/chats/chat/1')), t.screenChats.photo);
    });
  });
}
