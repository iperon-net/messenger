import '../../components.dart';
import '../../i18n/translations.g.dart';
import '../../models.dart' as models;
import 'chat_common.dart';

/// Общее для страницы сообщества (`community_{cupertino,material}.dart`), см.
/// «Сообщества» в docs/plans/chats-groups-channels.md.

/// Строка чата сообщества: название (канал объявлений — «Объявления») и
/// вторая строка — превью последнего сообщения, если мы участник, иначе число
/// участников (закрытая тема — «· По заявке»).
({String title, String subtitle}) communityChatRow(Translations t, models.Chat chat) {
  final title = chat.announcements ? t.screenChatInfo.announcements : chat.title;
  if (chat.isMember) {
    final preview = ChatTileContent.preview(t, chat);
    if (preview.text.isNotEmpty) {
      return (title: title, subtitle: preview.prefix.isEmpty ? preview.text : '${preview.prefix}: ${preview.text}');
    }
  }
  final count = chatSubtitle(t, chat).text;
  return (title: title, subtitle: chat.joinMode == models.ChatJoinMode.request ? '$count · ${t.screenChatInfo.closedTopic}' : count);
}
