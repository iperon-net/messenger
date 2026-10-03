import '../models.dart' as models;

/// Источник данных списка чатов. UI и cubit'ы работают только через него: сейчас
/// единственная реализация — [ChatsDemoDataSource] (фейковые данные для UX-демо,
/// включается на экране «Разработчик»), позже появится реализация на SQLite +
/// gRPC, а экраны не изменятся. См. docs/plans/chats-groups-channels.md.
abstract class ChatsDataSource {
  /// Текущий список чатов (включая архивные) — сразу при подписке, затем при
  /// каждом изменении.
  Stream<List<models.Chat>> watchChats();

  /// Папки пользователя; первая — «Все чаты».
  Stream<List<models.ChatFolder>> watchFolders();

  Future<void> setPinned(String chatID, bool pinned);
  Future<void> setMuted(String chatID, bool muted);
  Future<void> setArchived(String chatID, bool archived);

  /// Прочитать (сбросить счётчики и ручную пометку) или пометить непрочитанным.
  Future<void> setRead(String chatID, bool read);

  /// Прочитать все чаты папки.
  Future<void> readAll(List<String> chatIDs);

  Future<void> delete(String chatID);

  Future<void> deleteFolder(String folderID);
}
