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

  /// Выключить / включить уведомления; [until] — до этого времени (`null` —
  /// навсегда).
  Future<void> setMuted(String chatID, bool muted, {DateTime? until});
  Future<void> setArchived(String chatID, bool archived);

  /// Прочитать (сбросить счётчики и ручную пометку) или пометить непрочитанным.
  Future<void> setRead(String chatID, bool read);

  /// Прочитать все чаты папки.
  Future<void> readAll(List<String> chatIDs);

  Future<void> delete(String chatID);

  Future<void> deleteFolder(String folderID);

  /// Создать / изменить папку (по `id`); новая — в конец списка.
  Future<void> saveFolder(models.ChatFolder folder);

  /// Новый порядок папок: [folderIDs] — все, кроме «Все чаты» (она всегда
  /// первая).
  Future<void> reorderFolders(List<String> folderIDs);

  /// Контакты, с которыми можно начать личный чат или добавить в группу
  /// («Новое сообщение», выбор участников) — по алфавиту.
  Future<List<models.ChatMember>> contacts();

  /// Личный чат с пользователем [userID] (контакт или участник группы):
  /// существующий или новый пустой. Возвращает id чата (пусто — не найден).
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
  /// вступивших. [commentsTimeLimit] — «Срок комментирования» канала (секунд,
  /// 0 — без ограничения), действует только на новые посты; [commentsWho] и
  /// [commentsMinSubscription] — кто может комментировать (только подписчики —
  /// подписанные не меньше стольких секунд).
  Future<void> updateChat(
    String chatID, {
    required String title,
    required String about,
    required String avatarPath,
    required models.ChatJoinMode joinMode,
    required String username,
    required String inviteLink,
    required models.ChatRole defaultRole,
    bool commentsEnabled = false,
    int commentsTimeLimit = 0,
    models.ChatCommentsWho commentsWho = models.ChatCommentsWho.all,
    int commentsMinSubscription = 0,
    bool signMessages = false,
    bool membersHidden = false,
  });

  /// Ссылка `iperon.net/<path>` (публичное имя или `+код` приглашения) → id
  /// чата: наш — сразу, чужой публичный / по живой ссылке — для просмотра
  /// (`Chat.isMember == false`). Пусто — ссылка не найдена или недействительна.
  Future<String> resolveLink(String path);

  /// «Подписаться» / «Вступить»: стать участником; у чата «По заявке» —
  /// подать заявку (`Chat.joinRequested`), вступление — после одобрения.
  Future<void> joinChat(String chatID);

  /// Комментарии к посту [postID] канала [channelID]: id чата-ветки (создаётся
  /// при первом открытии; первым в ней — сам пост). Пусто — комментариев нет.
  Future<String> openComments(String channelID, String postID);

  /// Админ канала: закрыть комментарии к посту досрочно ([closed]) или снова
  /// открыть (бессрочно). Закрытую ветку можно только читать.
  Future<void> setCommentsClosed(String channelID, String postID, bool closed);

  /// Ссылки-приглашения чата (админ): основная первой, затем дополнительные
  /// (новые выше), отозванные — с `revoked`. Сразу при подписке, затем при
  /// каждом изменении (счётчики вступлений).
  Stream<List<models.ChatInviteLink>> watchInviteLinks(String chatID);

  /// Новая дополнительная ссылка.
  Future<void> createInviteLink(String chatID, {String title = '', DateTime? expireDate, int usageLimit = 0, bool requestApproval = false});

  /// Изменить дополнительную ссылку (код остаётся прежним).
  Future<void> editInviteLink(
    String chatID,
    String linkID, {
    required String title,
    DateTime? expireDate,
    required int usageLimit,
    required bool requestApproval,
  });

  /// Отозвать ссылку. Основная не отзывается, а заменяется новой (старая
  /// уходит в отозванные) — меняется и `Chat.inviteLink`.
  Future<void> revokeInviteLink(String chatID, String linkID);

  /// Удалить отозванную ссылку ([linkID] пусто — все отозванные).
  Future<void> deleteRevokedLinks(String chatID, {String linkID = ''});

  /// Заявки на вступление — от новых к старым.
  Stream<List<models.ChatJoinRequest>> watchJoinRequests(String chatID);

  /// Принять / отклонить заявку ([userID] пусто — все).
  Future<void> answerJoinRequest(String chatID, {String userID = '', required bool approve});

  /// Участники группы (профиль чата): владелец и админы первыми.
  Future<List<models.ChatMember>> members(String chatID);

  /// Админ: роль участника — «Чтение» / «Запись» (админы — отдельно).
  Future<void> setMemberRole(String chatID, String userID, models.ChatRole role);

  /// Админ: исключить участника; [ban] — ещё и заблокировать (по ссылкам не
  /// вернётся, пока не разблокируют).
  Future<void> removeMember(String chatID, String userID, {bool ban = false});

  /// Заблокированные в группе (профиль → «Заблокированные», админ).
  Future<List<models.ChatMember>> banned(String chatID);

  Future<void> unbanMember(String chatID, String userID);

  /// Админ: добавить контакты [userIDs] (с ролью по умолчанию; заблокированные
  /// при этом разблокируются).
  Future<void> addMembers(String chatID, List<String> userIDs);

  /// Назначить админом / изменить права и «звание» админа.
  Future<void> setAdmin(String chatID, String userID, {required models.ChatAdminRights rights, String rank = ''});

  /// Снять админа (останется участником с правом писать).
  Future<void> removeAdmin(String chatID, String userID);

  /// Владелец: передать владение — [userID] станет владельцем, мы — админом со
  /// всеми правами. На сервере — с подтверждением облачным паролем.
  Future<void> transferOwnership(String chatID, String userID);

  /// Реакции группы/канала (профиль чата → «Реакции», админ): все /
  /// выбранные [reactions] / никаких; у канала — ещё [maxReactions] (сколько
  /// разных под постом).
  Future<void> setChatReactions(String chatID, models.ChatReactionsMode mode, List<String> reactions, {int? maxReactions});

  /// Медленный режим группы/сообщества (профиль чата → «Медленный режим»,
  /// админ): интервал в секундах, 0 — выключить.
  Future<void> setSlowMode(String chatID, int seconds);

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
    models.MessagePoll? poll,
  });

  /// Опрос: наш голос — варианты [options] (пустой список — отменить голос).
  Future<void> votePoll(String chatID, String messageID, List<int> options);

  /// Завершить опрос (автор или админ): голосовать больше нельзя.
  Future<void> closePoll(String chatID, String messageID);

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
