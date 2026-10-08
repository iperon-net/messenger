import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';

import '../../constants.dart';
import '../../chats/chats_data_source.dart';
import '../../chats/message_formatting.dart';
import '../../chats/reactions.dart';
import '../../demo/chats_demo_data_source.dart';
import '../../models.dart' as models;

import 'chat_state.dart';

/// Окно чата. Данные — из того же [ChatsDataSource], что и список чатов (пока
/// только демо, см. docs/plans/chats-groups-channels.md, «Этап 0»).
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(const ChatState());

  ChatsDataSource? _source;
  late String _chatID;
  StreamSubscription<List<models.Chat>>? _chatsSubscription;
  StreamSubscription<List<models.Message>>? _messagesSubscription;
  StreamSubscription<List<models.Message>>? _scheduledSubscription;

  /// Медленный режим: до какого времени ждём и таймер обратного отсчёта.
  DateTime? _slowModeUntil;
  Timer? _slowModeTimer;

  /// Непрочитанных при открытии (до `setRead`) и поставлен ли уже разделитель.
  int? _openUnread;
  bool _unreadPlaced = false;

  /// Пересылка в другой чат: сообщения ждут здесь, пока не откроется окно
  /// чата-получателя (его cubit забирает их в [ChatState.forwarding]).
  static final _pendingForwards = <String, List<models.Message>>{};

  static void forwardTo(String chatID, List<models.Message> messages) => _pendingForwards[chatID] = messages;

  /// [demo] — флаг «Демо чатов» из `settingsDevice`.
  void initialization({required String chatID, required bool demo}) {
    _chatID = chatID;
    _source = demo ? ChatsDemoDataSource.instance : null;
    final source = _source;
    if (source == null) {
      emit(state.copyWith(status: Status.success));
      return;
    }
    final pending = _pendingForwards.remove(chatID);
    if (pending != null) emit(state.copyWith(forwarding: pending));
    _chatsSubscription = source.watchChats().listen((chats) {
      if (isClosed) return;
      final chat = chats.where((c) => c.id == chatID).firstOrNull;
      _openUnread ??= chat?.unreadCount;
      // Чат открыт — всё входящее сразу прочитано.
      if (chat != null && chat.hasUnread) source.setRead(chatID, true);
      emit(state.copyWith(chat: chat, status: Status.success));
      _placeUnread();
      _syncSlowMode();
    });
    _scheduledSubscription = source.watchScheduled(chatID).listen((scheduled) {
      if (!isClosed) emit(state.copyWith(scheduled: scheduled));
    });
    _messagesSubscription = source.watchMessages(chatID).listen((messages) {
      if (isClosed) return;
      emit(state.copyWith(messages: messages));
      _placeUnread();
      // Пришло/удалилось сообщение во время поиска — пересчитываем, оставаясь
      // на текущем найденном.
      if (state.searching) _search(state.searchQuery, keepID: state.searchCurrentID);
    });
  }

  /// Разделитель «Непрочитанные сообщения» — один раз, когда известны и
  /// счётчик непрочитанных, и история: над N-м с конца входящим.
  void _placeUnread() {
    final unread = _openUnread;
    if (_unreadPlaced || unread == null || state.messages.isEmpty) return;
    _unreadPlaced = true;
    if (unread <= 0) return;
    final incoming = [
      for (final m in state.messages)
        if (!m.outgoing && !m.service) m,
    ];
    if (incoming.isEmpty) return;
    emit(state.copyWith(unreadFromID: incoming[math.max(0, incoming.length - unread)].id));
  }

  /// Медленный режим: срок от сервера изменился — перезапускаем отсчёт.
  void _syncSlowMode() {
    final chat = state.chat;
    final until = chat != null && chat.slowModeApplies ? chat.slowModeUntil : null;
    if (until == _slowModeUntil) return;
    _slowModeUntil = until;
    _slowModeTimer?.cancel();
    _slowModeTimer = null;
    _tickSlowMode();
    if (state.slowModeLeft > 0) _slowModeTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickSlowMode());
  }

  void _tickSlowMode() {
    if (isClosed) return;
    final until = _slowModeUntil;
    final ms = until == null ? 0 : until.difference(DateTime.now()).inMilliseconds;
    final left = ms <= 0 ? 0 : (ms / 1000).ceil();
    if (left != state.slowModeLeft) emit(state.copyWith(slowModeLeft: left));
    if (left == 0) {
      _slowModeTimer?.cancel();
      _slowModeTimer = null;
    }
  }

  /// Медленный режим не даёт отправить сейчас (UI заранее объясняет почему,
  /// см. `checkSlowMode`; здесь — страховка).
  bool get _slowModeWaiting => state.slowModeLeft > 0;

  /// Отправить текст из поля ввода (markdown-ярлыки → entities). В режиме
  /// редактирования — правит сообщение. [silent] — без звука у получателя;
  /// [scheduleDate] — отложить текст (пересылаемые уходят сразу).
  /// [mentions] — упомянутые по имени (без @username) из подсказки «@»:
  /// их имена в тексте становятся упоминаниями (`mentionName`).
  Future<void> send(String raw, {bool silent = false, DateTime? scheduleDate, List<models.ChatMember> mentions = const []}) async {
    final source = _source;
    final forwarding = state.forwarding;
    if (source == null || (raw.trim().isEmpty && forwarding.isEmpty)) return;
    // Правка сообщения медленным режимом не ограничена.
    if (state.editing == null && _slowModeWaiting) return;
    final (text, parsed) = parseMarkdownShortcuts(raw.trim());
    final entities = withMentionNames(text, parsed, mentions);
    final editing = state.editing;
    final reply = state.reply;
    final linkPreview = !state.linkPreviewDisabled;
    emit(state.copyWith(reply: null, editing: null, forwarding: const [], linkPreviewDisabled: false));
    if (editing != null) {
      await source.editMessage(_chatID, editing.id, text, entities);
      return;
    }
    // Как в Telegram: сначала комментарий, за ним пересылаемые.
    if (text.isNotEmpty) {
      await source.sendMessage(
        _chatID,
        text: text,
        entities: entities,
        reply: reply == null ? null : _replyOf(reply),
        silent: silent,
        scheduleDate: scheduleDate,
        linkPreview: linkPreview,
      );
    }
    if (forwarding.isNotEmpty) await source.forwardMessages(_chatID, forwarding);
  }

  /// Фото/видео из галереи или файл; [media] (2+) — альбом одним сообщением.
  /// [caption] — подпись под медиа (markdown-ярлыки → entities).
  Future<void> sendMedia({
    required models.MessageKind kind,
    String localPath = '',
    String fileName = '',
    String caption = '',
    List<models.MessageMedia> media = const [],
  }) async {
    final source = _source;
    if (source == null || _slowModeWaiting) return;
    final reply = state.reply;
    emit(state.copyWith(reply: null));
    final (text, entities) = parseMarkdownShortcuts(caption.trim());
    await source.sendMessage(
      _chatID,
      kind: kind,
      localPath: localPath,
      fileName: fileName,
      media: media,
      text: text,
      entities: entities,
      reply: reply == null ? null : _replyOf(reply),
    );
  }

  /// Голосовое: файл записи [localPath], длительность и волна.
  Future<void> sendVoice({required String localPath, required int duration, required List<int> waveform}) async {
    final source = _source;
    if (source == null || _slowModeWaiting) return;
    final reply = state.reply;
    emit(state.copyWith(reply: null));
    await source.sendMessage(
      _chatID,
      kind: models.MessageKind.voice,
      localPath: localPath,
      duration: duration,
      waveform: waveform,
      reply: reply == null ? null : _replyOf(reply),
    );
  }

  models.MessageReply _replyOf(models.Message m) => models.MessageReply(
    messageID: m.id,
    senderName: m.outgoing ? '' : (m.senderName.isNotEmpty ? m.senderName : state.chat?.title ?? ''),
    text: m.kind == models.MessageKind.file && m.text.isEmpty ? m.fileName : m.text,
    kind: m.kind,
  );

  /// Реакция: тап по своей — снять, по другой — добавить (до
  /// [maxReactionsPerUser], сверх — вытесняется самая ранняя наша).
  Future<void> toggleReaction(models.Message message, String emoji) async {
    final chat = state.chat;
    if (chat == null) return;
    final mine = message.myReactions;
    if (!mine.contains(emoji) && !availableReactions(chat).contains(emoji)) return;
    await _source?.setReactions(_chatID, message.id, toggleMyReaction(mine, emoji));
  }

  /// Двойной тап по сообщению — быстрая реакция [preferred] (из настроек).
  Future<void> quickReact(models.Message message, {String preferred = defaultQuickReaction}) async {
    final chat = state.chat;
    final emoji = chat == null ? null : quickReaction(chat, preferred: preferred);
    if (emoji != null) await toggleReaction(message, emoji);
  }

  /// Крестик на прогрессе загрузки — отменить отправку вложений.
  Future<void> cancelUpload(models.Message message) async => _source?.cancelUpload(_chatID, message.id);

  /// Поиск по чату: открыть (удержание шапки) / закрыть.
  void startSearch() => emit(state.copyWith(searching: true, searchQuery: '', searchResults: const [], searchIndex: 0));

  void closeSearch() => emit(state.copyWith(searching: false, searchQuery: '', searchResults: const [], searchIndex: 0));

  void setSearchQuery(String query) => _search(query);

  /// Стрелка «вверх» — к более старому найденному, «вниз» — к более новому.
  void searchOlder() {
    if (state.searchIndex + 1 < state.searchResults.length) emit(state.copyWith(searchIndex: state.searchIndex + 1));
  }

  void searchNewer() {
    if (state.searchIndex > 0) emit(state.copyWith(searchIndex: state.searchIndex - 1));
  }

  /// Без учёта регистра по тексту/подписи и имени файла; от новых к старым.
  void _search(String query, {String? keepID}) {
    final needle = query.trim().toLowerCase();
    final results = needle.isEmpty
        ? const <String>[]
        : [
            for (final m in state.messages.reversed)
              if (!m.service && (m.text.toLowerCase().contains(needle) || m.fileName.toLowerCase().contains(needle))) m.id,
          ];
    final kept = keepID == null ? -1 : results.indexOf(keepID);
    emit(state.copyWith(searchQuery: query, searchResults: results, searchIndex: kept < 0 ? 0 : kept));
  }

  void startReply(models.Message message) => emit(state.copyWith(reply: message, editing: null, forwarding: const []));

  void startEdit(models.Message message) => emit(state.copyWith(editing: message, reply: null, forwarding: const []));

  /// × на превью ссылки над полем ввода.
  void disableLinkPreview() => emit(state.copyWith(linkPreviewDisabled: true));

  void cancelCompose() => emit(state.copyWith(reply: null, editing: null, forwarding: const []));

  /// Закрепить / открепить (меню сообщения, крестик в плашке); [forEveryone]
  /// — см. [ChatsDataSource.setMessagePinned].
  Future<void> setPinned(models.Message message, bool pinned, {bool forEveryone = true}) async =>
      _source?.setMessagePinned(_chatID, message.id, pinned, forEveryone: forEveryone);

  /// Открепить все (экран «Закреплённые сообщения»).
  Future<void> unpinAll() async => _source?.unpinAllMessages(_chatID);

  /// Режим выделения: «Выбрать» в меню сообщения.
  void startSelection(models.Message message) =>
      emit(state.copyWith(selecting: true, selectedIDs: [message.id], searching: false, searchQuery: '', searchResults: const []));

  /// Тап по сообщению в режиме выделения; сняли последнее — выходим из режима.
  void toggleSelected(models.Message message) {
    if (message.service) return;
    final ids = state.selectedIDs.contains(message.id)
        ? state.selectedIDs.where((id) => id != message.id).toList()
        : [...state.selectedIDs, message.id];
    emit(state.copyWith(selectedIDs: ids, selecting: ids.isNotEmpty));
  }

  void clearSelection() => emit(state.copyWith(selecting: false, selectedIDs: const []));

  /// Удалить можно свои, а в личном чате — любые (как одиночное удаление).
  bool canDelete(models.Message message) => message.outgoing || state.chat?.type == models.ChatType.private;

  Future<void> deleteSelected({bool forEveryone = true}) async {
    final messages = state.selectedMessages;
    clearSelection();
    for (final m in messages) {
      if (canDelete(m)) await delete(m, forEveryone: forEveryone);
    }
  }

  /// Переслать отмеченные: в этот же чат — сразу в плашку над полем ввода,
  /// в другой — отложить до открытия его окна ([forwardTo]).
  void forwardSelected(String toChatID) {
    // Автор оригинала — сейчас, пока известен этот чат (в личном у входящих
    // имени отправителя нет — это название чата).
    final messages = [
      for (final m in state.selectedMessages)
        m.forward != null
            ? m
            : m.copyWith(
                forward: models.MessageForward(
                  self: m.outgoing,
                  name: m.outgoing ? '' : (m.senderName.isNotEmpty ? m.senderName : state.chat?.title ?? ''),
                ),
              ),
    ];
    if (messages.isEmpty) return;
    if (toChatID == _chatID) {
      emit(state.copyWith(selecting: false, selectedIDs: const [], forwarding: messages, reply: null, editing: null));
    } else {
      forwardTo(toChatID, messages);
      clearSelection();
    }
  }

  /// Куда можно переслать: все чаты, кроме каналов (писать в них нельзя) —
  /// «Избранное» первым, архив в конце.
  Future<List<models.Chat>> forwardTargets() async {
    final source = _source;
    if (source == null) return const [];
    final chats = (await source.watchChats().first).where((c) => c.type != models.ChatType.channel && !c.isThread).toList();
    int rank(models.Chat c) => c.isSelf ? 0 : (c.archived ? 2 : 1);
    // Внутри группы — порядок списка чатов (sort в Dart неустойчивый).
    final indexed = chats.indexed.toList()
      ..sort((a, b) => rank(a.$2) != rank(b.$2) ? rank(a.$2).compareTo(rank(b.$2)) : a.$1.compareTo(b.$1));
    return [for (final (_, c) in indexed) c];
  }

  /// [forEveryone] — см. [ChatsDataSource.deleteMessage].
  Future<void> delete(models.Message message, {bool forEveryone = true}) async {
    if (state.editing?.id == message.id || state.reply?.id == message.id) cancelCompose();
    await _source?.deleteMessage(_chatID, message.id, forEveryone: forEveryone);
  }

  /// [until] — выключить до этого времени (`null` — навсегда).
  Future<void> setMuted(bool muted, {DateTime? until}) async => _source?.setMuted(_chatID, muted, until: until);

  /// Профиль чата: участники группы (и заблокированные — для админа).
  Future<void> loadMembers() async {
    final source = _source;
    if (source == null) return;
    final members = await source.members(_chatID);
    final banned = state.chat?.canManage ?? false ? await source.banned(_chatID) : const <models.ChatMember>[];
    if (!isClosed) emit(state.copyWith(members: members, banned: banned));
  }

  /// Админ: «Чтение» ⇄ «Запись» у участника.
  Future<void> setMemberRole(models.ChatMember member, models.ChatRole role) async {
    await _source?.setMemberRole(_chatID, member.id, role);
    await loadMembers();
  }

  /// Админ: исключить ([ban] — и заблокировать).
  Future<void> removeMember(models.ChatMember member, {bool ban = false}) async {
    await _source?.removeMember(_chatID, member.id, ban: ban);
    await loadMembers();
  }

  Future<void> unbanMember(models.ChatMember member) async {
    await _source?.unbanMember(_chatID, member.id);
    await loadMembers();
  }

  Future<void> addMembers(List<models.ChatMember> members) async {
    await _source?.addMembers(_chatID, [for (final m in members) m.id]);
    await loadMembers();
  }

  /// Назначить админом / изменить права и «звание».
  Future<void> setAdmin(models.ChatMember member, models.ChatAdminRights rights, String rank) async {
    await _source?.setAdmin(_chatID, member.id, rights: rights, rank: rank.trim());
    await loadMembers();
  }

  Future<void> removeAdmin(models.ChatMember member) async {
    await _source?.removeAdmin(_chatID, member.id);
    await loadMembers();
  }

  /// Владелец: передать владение [member].
  Future<void> transferOwnership(models.ChatMember member) async {
    await _source?.transferOwnership(_chatID, member.id);
    await loadMembers();
  }

  /// Отправить опрос (скрепка → «Опрос»).
  Future<void> sendPoll(models.MessagePoll poll) async {
    if (_slowModeWaiting) return;
    final reply = state.reply;
    emit(state.copyWith(reply: null));
    await _source?.sendMessage(
      _chatID,
      kind: models.MessageKind.poll,
      text: poll.question,
      poll: poll,
      reply: reply == null ? null : _replyOf(reply),
    );
  }

  /// Голос в опросе (пустой список — отменить голос).
  Future<void> votePoll(models.Message message, List<int> options) async => _source?.votePoll(_chatID, message.id, options);

  Future<void> closePoll(models.Message message) async => _source?.closePoll(_chatID, message.id);

  /// «Подписаться» / «Вступить» / «Подать заявку».
  Future<void> join() async => _source?.joinChat(_chatID);

  /// Комментарии к посту канала — id чата-ветки (пусто — не открыть).
  Future<String> openComments(models.Message post) async => await _source?.openComments(_chatID, post.id) ?? '';

  /// «Написать сообщение» участнику — id личного чата с ним.
  Future<String?> privateChatWith(models.ChatMember member) async => _source?.openPrivateChat(member.id);

  /// Профиль чата → «Реакции» (админ).
  Future<void> setChatReactions(models.ChatReactionsMode mode, List<String> reactions) async =>
      _source?.setChatReactions(_chatID, mode, reactions);

  /// Профиль чата → «Медленный режим» (админ): интервал в секундах, 0 — выкл.
  Future<void> setSlowMode(int seconds) async => _source?.setSlowMode(_chatID, seconds);

  /// Профиль чата: «Удалить чат» / «Покинуть группу».
  Future<void> deleteChat() async => _source?.delete(_chatID);

  /// Отложенные (экран «Отложенные сообщения»).
  Future<void> sendScheduledNow(models.Message message) async => _source?.sendScheduledNow(_chatID, message.id);

  Future<void> reschedule(models.Message message, DateTime date) async => _source?.rescheduleMessage(_chatID, message.id, date);

  Future<void> deleteScheduled(models.Message message) async => _source?.deleteScheduled(_chatID, message.id);

  /// Черновик — при уходе с экрана (видно в списке чатов).
  Future<void> saveDraft(String text) async {
    if (state.editing != null) return;
    await _source?.setDraft(_chatID, text.trim());
  }

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _messagesSubscription?.cancel();
    await _scheduledSubscription?.cancel();
    _slowModeTimer?.cancel();
    return super.close();
  }
}
