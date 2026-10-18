import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../auth.dart';
import '../../chats/chats_sync.dart' show ChatsOfflineException;
import '../../chats/secret/secret_chats_list.dart';
import '../../chats/secret/secret_chats_sync.dart';
import '../../constants.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../peer_names.dart';
import '../../repositories.dart';
import '../../utils.dart';
import 'secret_chat_state.dart';

/// Окно секретного чата (и его экран «Ключ шифрования»): читает чат и
/// переписку из SQLite (перечитывает при изменениях), отправляет через
/// [SecretChatsSync].
class SecretChatCubit extends Cubit<SecretChatState> {
  SecretChatCubit() : super(const SecretChatState());

  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();
  final repositories = getIt.get<Repositories>();
  SecretChatsSync get _sync => SecretChatsSync.instance;

  StreamSubscription<void>? _changes;
  late Uint8List _chatID;
  var _pending = Future<void>.value();

  /// Окно чата на экране — входящие сразу помечаются прочитанными (на экране
  /// ключа — нет).
  bool _visible = false;

  List<int> get _sessionID => getIt.get<Auth>().session.sessionID;

  Future<void> initialization({required String chatID, bool markRead = true}) async {
    _chatID = utils.hexToBytes(chatID);
    _visible = markRead;
    emit(state.copyWith(status: Status.loading, chatID: chatID));
    _changes = repositories.db.onChange(SecretChatsRepository.tables).listen((_) => _reload());
  }

  void _reload() {
    _pending = _pending.then((_) => _load()).catchError((Object error, StackTrace stackTrace) => logger.handle(error, stackTrace));
  }

  Future<void> _load() async {
    final chat = await repositories.secretChats.chat(sessionID: _sessionID, secretChatID: _chatID);
    if (isClosed) return;
    if (chat == null) {
      emit(state.copyWith(removed: true));
      return;
    }
    final records = await repositories.secretChats.messages(sessionID: _sessionID, secretChatID: _chatID);
    final title = state.title.isNotEmpty ? state.title : await peerDisplayName(chat.peerUserID);
    if (isClosed) return;
    final listID = secretChatListID(_chatID);
    emit(
      state.copyWith(
        status: Status.success,
        title: title,
        peerUserID: utils.bytesToHex(chat.peerUserID),
        secretStatus: secretChatStatus(chat.state),
        outgoing: chat.outgoing,
        emoji: chat.emoji,
        fingerprintHex: chat.fingerprint == null ? '' : utils.bytesToHex(chat.fingerprint!),
        messages: [
          for (final record in records)
            models.Message(
              id: '${record.randomID}',
              chatID: listID,
              text: record.text,
              outgoing: record.outgoing,
              status: secretMessageStatus(record.status),
              date: record.date,
            ),
        ],
      ),
    );
    if (_visible && chat.unreadCount > 0) unawaited(_markRead());
  }

  Future<void> _markRead() async {
    try {
      await _sync.markRead(_chatID);
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  void _notice(SecretChatNotice notice) {
    if (!isClosed) emit(state.copyWith(notice: notice, noticeCount: state.noticeCount + 1));
  }

  /// Отправить текст. Без сети — уходит в outbox (конверт уже зашифрован) и
  /// отправится при подключении; часики у сообщения показывают это честно.
  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    try {
      await _sync.sendText(_chatID, trimmed);
    } on SecretChatException {
      _notice(SecretChatNotice.notReady);
    }
  }

  /// Удалить сообщение у обоих.
  Future<void> deleteMessage(models.Message message) async {
    final randomID = int.tryParse(message.id);
    if (randomID == null) return;
    try {
      if (state.canSend) {
        await _sync.deleteMessages(_chatID, [randomID]);
      } else {
        // Чат закрыт — у собеседника и так ничего не изменится, удаляем у себя.
        await repositories.secretChats.update(sessionID: _sessionID, secretChatID: _chatID, apply: (tx) => tx.deleteMessages([randomID]));
      }
    } on SecretChatException {
      _notice(SecretChatNotice.notReady);
    }
  }

  /// Удалить чат: закрыть у собеседника (с перепиской) и убрать с устройства.
  /// Без сети — «Нет соединения»: собеседник иначе продолжит писать.
  Future<void> deleteChat() async {
    try {
      await _sync.discard(_chatID, deleteHistory: true, removeLocal: true);
    } on ChatsOfflineException {
      _notice(SecretChatNotice.offline);
    }
  }

  @override
  Future<void> close() async {
    await _changes?.cancel();
    return super.close();
  }
}
