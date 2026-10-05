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

  /// Сообщения чата (от старых к новым) — сразу при подписке, затем при каждом
  /// изменении.
  Stream<List<models.Message>> watchMessages(String chatID);

  /// Отправить сообщение: текст уже разобран в entities (см.
  /// `parseMarkdownShortcuts`), для медиа — [kind] + [localPath]/[fileName],
  /// для альбома — [media] (подпись — [text]).
  Future<void> sendMessage(
    String chatID, {
    String text = '',
    List<models.MessageEntity> entities = const [],
    models.MessageReply? reply,
    models.MessageKind kind = models.MessageKind.text,
    String localPath = '',
    String fileName = '',
    List<models.MessageMedia> media = const [],
    int duration = 0,
    List<int> waveform = const [],
  });

  Future<void> editMessage(String chatID, String messageID, String text, List<models.MessageEntity> entities);

  Future<void> deleteMessage(String chatID, String messageID);

  /// Отменить загрузку вложений (крестик на прогрессе) — сообщение удаляется,
  /// так и не дойдя до собеседника.
  Future<void> cancelUpload(String chatID, String messageID);

  /// Наши реакции на сообщение — весь набор целиком (пустой — снять все), как
  /// `sendReaction` в Telegram.
  Future<void> setReactions(String chatID, String messageID, List<String> emojis);

  /// Сохранить черновик поля ввода (показывается в списке чатов).
  Future<void> setDraft(String chatID, String draft);
}
