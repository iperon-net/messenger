import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../auth.dart';
import '../../chats/chats_media.dart' show chatMediaContentType;
import '../../chats/chats_sync.dart' show ChatsOfflineException;
import '../../chats/secret/secret_chats_list.dart';
import '../../chats/secret/secret_chats_media.dart';
import '../../chats/secret/secret_chats_sync.dart';
import '../../constants.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../models.dart' as models;
import '../../peer_names.dart';
import '../../protobuf/protos/secret_payload_v1.pb.dart' as sp;
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
  StreamSubscription<void>? _uploads;
  StreamSubscription<void>? _downloads;
  Timer? _progressTimer;
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
    // Прогресс загрузки / скачивания вложений — перерисовать ленту.
    _uploads = _sync.uploadChanged.listen(
      (_) => _progressTimer ??= Timer(const Duration(milliseconds: 250), () {
        _progressTimer = null;
        _reload();
      }),
    );
    _downloads = SecretChatsMedia.instance.changed.listen((_) => _reload());
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
        messages: [for (final record in records) await _message(record, listID)],
      ),
    );
    if (_visible && chat.unreadCount > 0) unawaited(_markRead());
  }

  /// Сообщение для ленты: у вложения — файл (копия неотправленного или
  /// скачанный; ещё нет — ставится в очередь скачивания), обложка видео из
  /// конверта и прогресс загрузки / скачивания.
  Future<models.Message> _message(SecretMessageRecord record, String listID) async {
    final message = models.Message(
      id: '${record.randomID}',
      chatID: listID,
      kind: secretMessageKind(record.kind),
      text: record.text,
      outgoing: record.outgoing,
      status: secretMessageStatus(record.status),
      date: record.date,
    );
    final bytes = record.media;
    if (bytes == null) return message;
    final media = sp.SecretMedia.fromBuffer(bytes);
    final String path;
    var sent = 0;
    var total = 0;
    if (record.localPath.isNotEmpty) {
      path = await _sync.outboxFilePath(record.localPath);
      final upload = _sync.uploadProgress(record.randomID);
      // Ждёт загрузки — кольцо (на нуле без сети); крестик отменяет.
      if (record.status == SecretMessageStatus.pending) {
        total = media.size.toInt() > 0 ? media.size.toInt() : 1;
        if (upload != null && upload.total > 0) sent = (total * upload.sent / upload.total).round();
      }
    } else {
      path = await SecretChatsMedia.instance.file(_chatID, media);
      final download = SecretChatsMedia.instance.progress(media.fileID);
      // Фото проявляется из размытого превью; у видео и файлов — кольцо.
      if (path.isEmpty && download != null && record.kind != SecretMessageKind.photo) {
        total = media.size.toInt() > 0 ? media.size.toInt() : 1;
        if (download.total > 0) sent = (total * download.received / download.total).round();
      }
    }
    final thumb = record.kind == SecretMessageKind.video ? await _sync.thumbFile(record.randomID, media.thumb) : '';
    final kind = secretMessageKind(record.kind);
    return message.copyWith(
      localPath: path,
      fileName: media.fileName,
      fileSize: media.size.toInt(),
      duration: media.duration,
      waveform: [for (final level in media.waveform) level >> 3],
      media: [
        if (record.kind == SecretMessageKind.photo || record.kind == SecretMessageKind.video)
          models.MessageMedia(
            kind: kind,
            localPath: path,
            width: media.width,
            height: media.height,
            size: media.size.toInt(),
            thumbPath: thumb,
            thumbhash: media.thumbhash,
            spoiler: media.spoiler,
            duration: media.duration,
          ),
      ],
      uploadedBytes: sent,
      uploadTotal: total,
    );
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

  /// Отправить вложения (уже сжатые, см. `prepareAttachmentDrafts`): каждое —
  /// отдельным сообщением, подпись — у первого. Без сети — ждут загрузки.
  Future<void> sendMedia({required List<models.MessageMedia> media, required List<String> files, String caption = ''}) async {
    var pending = caption.trim();
    String takeCaption() {
      final value = pending;
      pending = '';
      return value;
    }

    try {
      for (final item in media) {
        await _sync.sendMedia(
          _chatID,
          SecretMediaDraft(
            kind: item.kind == models.MessageKind.video ? SecretMessageKind.video : SecretMessageKind.photo,
            path: item.localPath,
            mimeType: chatMediaContentType(item.localPath),
            width: item.width,
            height: item.height,
            duration: item.duration,
            thumbhash: item.thumbhash,
            thumbPath: item.thumbPath,
            spoiler: item.spoiler,
          ),
          caption: takeCaption(),
        );
      }
      for (final path in files) {
        await _sync.sendMedia(
          _chatID,
          SecretMediaDraft(kind: SecretMessageKind.file, path: path, mimeType: chatMediaContentType(path)),
          caption: takeCaption(),
        );
      }
    } on SecretChatException {
      _notice(SecretChatNotice.notReady);
    }
  }

  /// Удалить сообщение у обоих (чат закрыт — только у себя). Неотправленное
  /// вложение (крестик на кольце загрузки) — так же: загрузка бросается.
  Future<void> deleteMessage(models.Message message) async {
    final randomID = int.tryParse(message.id);
    if (randomID == null) return;
    try {
      await _sync.deleteMessages(_chatID, [randomID]);
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
    await _uploads?.cancel();
    await _downloads?.cancel();
    _progressTimer?.cancel();
    return super.close();
  }
}
