import 'package:dart_mappable/dart_mappable.dart';

import '../../chats/users_search.dart';
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
  /// `ChatsDemoDataSource`. Выключено — настоящие чаты из
  /// `ChatsRemoteDataSource` (SQLite-кэш + сервер; пока только личные и
  /// «Избранное»).
  final bool demo;

  /// Все чаты, включая архивные (фильтрация по папке/архиву/поиску — в UI).
  final List<models.Chat> chats;

  final List<models.ChatFolder> folders;

  /// Индекс активной папки в [folders].
  final int folderIndex;

  final String query;

  /// Глобальный поиск по [query] (люди — номер / username, см. [UsersSearch]):
  /// найденные — без тех, с кем личный чат уже в списке.
  final UsersSearchStatus globalStatus;
  final List<models.ChatMember> globalResults;

  /// Публичные группы глобального поиска (`Chats.SearchChats`) — без тех, что
  /// уже в списке чатов.
  final List<models.Chat> globalChats;

  /// Растёт, когда действие не выполнено из-за отсутствия сети
  /// (`ChatsOfflineException`): экран показывает «Нет соединения».
  final int offlineNotice;

  /// Растёт, когда закрепить чат нельзя — закреплено уже
  /// [models.chatPinnedLimit]: экран объясняет.
  final int pinnedLimitNotice;

  /// Локально скрытые профили: hex(userID) → sha256 код-фразы (hex). Личные
  /// чаты с ними не показываются и не входят в счётчики непрочитанных, пока
  /// поиск «/код-фраза» их не раскроет (см. `HiddenProfiles`).
  final Map<String, String> hiddenHashByHex;

  /// Скрытые профили, раскрытые текущим запросом «/код-фраза» (hex(userID)).
  /// Считается в [ChatsCubit.search], а не в build.
  final Set<String> revealedHex;

  const ChatsState({
    this.status = Status.initialization,
    this.offlineNotice = 0,
    this.pinnedLimitNotice = 0,
    this.notificationsMissing = false,
    this.notificationsBannerDismissed = false,
    this.demo = false,
    this.chats = const [],
    this.folders = const [],
    this.folderIndex = 0,
    this.query = '',
    this.globalStatus = UsersSearchStatus.idle,
    this.globalResults = const [],
    this.globalChats = const [],
    this.hiddenHashByHex = const {},
    this.revealedHex = const {},
  });

  bool get showNotificationsBanner => notificationsMissing && !notificationsBannerDismissed;

  List<models.Chat> get archived => _sorted(chats.where((c) => c.archived && !c.hiddenInList && _visible(c)));

  /// Чаты папки: закреплённые сверху, дальше по дате последнего сообщения.
  List<models.Chat> chatsOf(models.ChatFolder folder) => _sorted(chats.where((c) => folder.matches(c) && !c.hiddenInList && _visible(c)));

  /// Бейдж на табе папки — число чатов с непрочитанным (как в Telegram); [muted]
  /// — все такие чаты заглушены (бейдж серый).
  ({int count, bool muted}) unreadOf(models.ChatFolder folder) {
    final unread = chats.where((c) => folder.matches(c) && !c.hiddenInList && !isHiddenPeer(c) && c.hasUnread);
    return (count: unread.length, muted: unread.every((c) => c.muted));
  }

  /// Личный чат с локально скрытым собеседником.
  bool isHiddenPeer(models.Chat chat) => chat.type == models.ChatType.private && hiddenHashByHex.containsKey(chat.peerUserID);

  /// Скрытый виден, только пока его раскрывает «/код-фраза», — мимо текстового
  /// фильтра: сам запрос в этот момент и есть код-фраза.
  bool _visible(models.Chat chat) => isHiddenPeer(chat) ? revealedHex.contains(chat.peerUserID) : _matchesQuery(chat);

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
