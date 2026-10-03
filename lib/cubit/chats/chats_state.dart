import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';
import '../../models.dart' as models;

part 'chats_state.mapper.dart';

@MappableClass()
class ChatsState with ChatsStateMappable {
  final Status status;

  /// Разрешение на уведомления не выдано (iOS — authorization, Android 13+ —
  /// POST_NOTIFICATIONS). Управляет баннером-объяснением на вкладке.
  final bool notificationsMissing;

  /// Пользователь закрыл баннер — не показываем до конца сессии.
  final bool notificationsBannerDismissed;

  /// UX-демо включено (флаг на экране «Разработчик») — данные из
  /// `ChatsDemoDataSource`. Выключено — пока пустой список: настоящих чатов ещё нет.
  final bool demo;

  /// Все чаты, включая архивные (фильтрация по папке/архиву/поиску — в UI).
  final List<models.Chat> chats;

  final List<models.ChatFolder> folders;

  /// Индекс активной папки в [folders].
  final int folderIndex;

  final String query;

  const ChatsState({
    this.status = Status.initialization,
    this.notificationsMissing = false,
    this.notificationsBannerDismissed = false,
    this.demo = false,
    this.chats = const [],
    this.folders = const [],
    this.folderIndex = 0,
    this.query = '',
  });

  bool get showNotificationsBanner => notificationsMissing && !notificationsBannerDismissed;

  List<models.Chat> get archived => _sorted(chats.where((c) => c.archived && _matchesQuery(c)));

  /// Чаты папки: закреплённые сверху, дальше по дате последнего сообщения.
  List<models.Chat> chatsOf(models.ChatFolder folder) => _sorted(chats.where((c) => folder.matches(c) && _matchesQuery(c)));

  /// Бейдж на табе папки — число чатов с непрочитанным (как в Telegram); [muted]
  /// — все такие чаты заглушены (бейдж серый).
  ({int count, bool muted}) unreadOf(models.ChatFolder folder) {
    final unread = chats.where((c) => folder.matches(c) && c.hasUnread);
    return (count: unread.length, muted: unread.every((c) => c.muted));
  }

  bool _matchesQuery(models.Chat chat) => query.isEmpty || chat.title.toLowerCase().contains(query.toLowerCase());

  static List<models.Chat> _sorted(Iterable<models.Chat> items) {
    final list = items.toList();
    list.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.sortDate.compareTo(a.sortDate);
    });
    return list;
  }
}
