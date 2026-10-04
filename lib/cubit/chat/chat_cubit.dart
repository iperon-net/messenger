import 'dart:async';

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

  /// [demo] — флаг «Демо чатов» из `settingsDevice`.
  void initialization({required String chatID, required bool demo}) {
    _chatID = chatID;
    _source = demo ? ChatsDemoDataSource.instance : null;
    final source = _source;
    if (source == null) {
      emit(state.copyWith(status: Status.success));
      return;
    }
    _chatsSubscription = source.watchChats().listen((chats) {
      if (isClosed) return;
      final chat = chats.where((c) => c.id == chatID).firstOrNull;
      // Чат открыт — всё входящее сразу прочитано.
      if (chat != null && chat.hasUnread) source.setRead(chatID, true);
      emit(state.copyWith(chat: chat, status: Status.success));
    });
    _messagesSubscription = source.watchMessages(chatID).listen((messages) {
      if (isClosed) return;
      emit(state.copyWith(messages: messages));
      // Пришло/удалилось сообщение во время поиска — пересчитываем, оставаясь
      // на текущем найденном.
      if (state.searching) _search(state.searchQuery, keepID: state.searchCurrentID);
    });
  }

  /// Отправить текст из поля ввода (markdown-ярлыки → entities). В режиме
  /// редактирования — правит сообщение.
  Future<void> send(String raw) async {
    final source = _source;
    if (source == null || raw.trim().isEmpty) return;
    final (text, entities) = parseMarkdownShortcuts(raw.trim());
    final editing = state.editing;
    final reply = state.reply;
    emit(state.copyWith(reply: null, editing: null));
    if (editing != null) {
      await source.editMessage(_chatID, editing.id, text, entities);
      return;
    }
    await source.sendMessage(_chatID, text: text, entities: entities, reply: reply == null ? null : _replyOf(reply));
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
    if (source == null) return;
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

  /// Двойной тап по сообщению — быстрая реакция.
  Future<void> quickReact(models.Message message) async {
    final chat = state.chat;
    final emoji = chat == null ? null : quickReaction(chat);
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

  void startReply(models.Message message) => emit(state.copyWith(reply: message, editing: null));

  void startEdit(models.Message message) => emit(state.copyWith(editing: message, reply: null));

  void cancelCompose() => emit(state.copyWith(reply: null, editing: null));

  Future<void> delete(models.Message message) async {
    if (state.editing?.id == message.id || state.reply?.id == message.id) cancelCompose();
    await _source?.deleteMessage(_chatID, message.id);
  }

  Future<void> setMuted(bool muted) async => _source?.setMuted(_chatID, muted);

  /// Черновик — при уходе с экрана (видно в списке чатов).
  Future<void> saveDraft(String text) async {
    if (state.editing != null) return;
    await _source?.setDraft(_chatID, text.trim());
  }

  @override
  Future<void> close() async {
    await _chatsSubscription?.cancel();
    await _messagesSubscription?.cancel();
    return super.close();
  }
}
