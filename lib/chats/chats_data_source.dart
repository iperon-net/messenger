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

  /// Контакты, с которыми можно начать личный чат или добавить в группу
  /// («Новое сообщение», выбор участников) — по алфавиту.
  Future<List<models.ChatMember>> contacts();

  /// Личный чат с контактом [userID]: существующий или новый пустой. Возвращает
  /// id чата.
  Future<String> openPrivateChat(String userID);

  /// Свободно ли публичное имя группы/канала/сообщества (форма создания и
  /// «Изменить»; своё текущее имя чата [exceptChatID] — свободно).
  Future<bool> isUsernameAvailable(String username, {String exceptChatID = ''});

  /// Создать группу / канал / сообщество, мы — владелец. [memberIDs] — кого
  /// добавить сразу (группа); [username] — публичное имя (пусто — частный чат со
  /// ссылкой-приглашением [inviteLink]); [avatarPath] — локальный файл фото.
  /// Возвращает id нового чата.
  Future<String> createChat({
    required models.ChatType type,
    required String title,
    String about = '',
    List<String> memberIDs = const [],
    String username = '',
    String inviteLink = '',
    String avatarPath = '',
  });

  /// Изменить группу/канал/сообщество (профиль чата → «Изменить», админ):
  /// название, описание, фото, способ вступления ([username] — для
  /// [models.ChatJoinMode.open], иначе действует [inviteLink]) и роль
  /// вступивших.
  Future<void> updateChat(
    String chatID, {
    required String title,
    required String about,
    required String avatarPath,
    required models.ChatJoinMode joinMode,
    required String username,
    required String inviteLink,
    required models.ChatRole defaultRole,
  });

  /// Участники группы (профиль чата): владелец и админы первыми.
  Future<List<models.ChatMember>> members(String chatID);

  /// Реакции группы/канала (профиль чата → «Реакции», админ): все /
  /// выбранные [reactions] / никаких.
  Future<void> setChatReactions(String chatID, models.ChatReactionsMode mode, List<String> reactions);

  /// Сообщения чата (от старых к новым) — сразу при подписке, затем при каждом
  /// изменении.
  Stream<List<models.Message>> watchMessages(String chatID);

  /// Отправить сообщение: текст уже разобран в entities (см.
  /// `parseMarkdownShortcuts`), для медиа — [kind] + [localPath]/[fileName],
  /// для альбома — [media] (подпись — [text]). [silent] — без звука у
  /// получателя; [scheduleDate] — не сейчас, а в это время (см. [watchScheduled]);
  /// [linkPreview] `false` — без превью ссылки (× над полем ввода).
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
    bool silent = false,
    DateTime? scheduleDate,
    bool linkPreview = true,
  });

  /// Отложенные сообщения чата (отправка с [sendMessage] `scheduleDate`) — от
  /// ранних к поздним; в момент `scheduledDate` уходят в чат сами.
  Stream<List<models.Message>> watchScheduled(String chatID);

  /// Отложенное — отправить сейчас / перенести / удалить.
  Future<void> sendScheduledNow(String chatID, String messageID);
  Future<void> rescheduleMessage(String chatID, String messageID, DateTime date);
  Future<void> deleteScheduled(String chatID, String messageID);

  Future<void> editMessage(String chatID, String messageID, String text, List<models.MessageEntity> entities);

  /// Удалить сообщение: [forEveryone] — у всех (в личном чате — и у
  /// собеседника), `false` — только у себя.
  Future<void> deleteMessage(String chatID, String messageID, {bool forEveryone = true});

  /// Закрепить / открепить сообщение в чате. [forEveryone] — закрепить и у
  /// собеседника (личный чат) / у всех: тогда в ленте появляется сервисное
  /// «Вы закрепили «…»»; `false` — только у себя, без сервисного.
  Future<void> setMessagePinned(String chatID, String messageID, bool pinned, {bool forEveryone = true});

  /// Открепить все сообщения чата (экран «Закреплённые сообщения»).
  Future<void> unpinAllMessages(String chatID);

  /// Переслать [messages] (из любых чатов, по порядку) в чат [toChatID]: новые
  /// исходящие сообщения с тем же содержимым и пометкой «Переслано от».
  Future<void> forwardMessages(String toChatID, List<models.Message> messages);

  /// Отменить загрузку вложений (крестик на прогрессе) — сообщение удаляется,
  /// так и не дойдя до собеседника.
  Future<void> cancelUpload(String chatID, String messageID);

  /// Наши реакции на сообщение — весь набор целиком (пустой — снять все), как
  /// `sendReaction` в Telegram.
  Future<void> setReactions(String chatID, String messageID, List<String> emojis);

  /// Сохранить черновик поля ввода (показывается в списке чатов).
  Future<void> setDraft(String chatID, String draft);
}
