import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../cdn.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../push.dart';
import '../../protobuf/protos/secret_chats_v1.pb.dart' as sc;
import '../../protobuf/protos/secret_payload_v1.pb.dart' as sp;
import '../../protobuf/protos/v1.pb.dart' show MessageType;
import '../../repositories.dart';
import '../../utils.dart';
import '../chats_sync.dart' show ChatsOfflineException, ChatsFloodException;
import 'secret_chats_media.dart';

/// Сборка умеет секретные чаты — уходит в `Subscribe.Request.capabilities`:
/// запрос на секретный чат сервер шлёт только таким устройствам.
const secretChatsCapability = 'secretChats';

/// Версия формата `SecretPayload` у этой сборки (см. secret_payload_v1.proto):
/// 2 — вложения (`SecretMedia`), 3 — таймер самоуничтожения и скриншоты.
const secretPayloadLayer = 3;

/// Варианты таймера самоуничтожения, секунд (0 — выключен), как в Telegram.
const secretTtlOptions = [0, 5, 30, 60, 3600, 86400, 604800];

/// Каталог файлов вложений секретных чатов на устройстве: копии
/// неотправленных и кадры-обложки видео из конвертов (отдельно от outbox
/// обычных чатов — его чистит `ChatsSync`). Удаляются вместе с сообщением.
Future<Directory> secretOutboxMediaDir() async {
  final dir = Directory(p.join((await getApplicationSupportDirectory()).path, 'secret_media'));
  await dir.create(recursive: true);
  return dir;
}

/// Загруженный файл вложения: где лежит шифротекст (fileID) и чем открыть.
class SecretUploadedFile {
  final Uint8List fileID;
  final Uint8List key;
  final Uint8List hkdfSalt;

  /// sha256 шифротекста.
  final Uint8List sha256;

  const SecretUploadedFile({required this.fileID, required this.key, required this.hkdfSalt, required this.sha256});
}

/// Непрозрачная загрузка файла (ключ серверу не уходит). Ошибки — как у
/// `CDNManager.uploadFile`; отмена ([isCancelled]) — любым исключением.
abstract class SecretMediaUploader {
  Future<SecretUploadedFile> upload(
    File file, {
    required String contentType,
    void Function(int sent, int total)? onProgress,
    bool Function()? isCancelled,
  });
}

class _CdnSecretMediaUploader implements SecretMediaUploader {
  @override
  Future<SecretUploadedFile> upload(
    File file, {
    required String contentType,
    void Function(int sent, int total)? onProgress,
    bool Function()? isCancelled,
  }) async {
    final cdn = await getIt.get<CDNManager>().uploadFile(
      file: file,
      folder: secretMediaFolder,
      contentType: contentType,
      onProgress: onProgress,
      isCancelled: isCancelled,
    );
    return SecretUploadedFile(fileID: cdn.cdnID, key: cdn.encryptionKey, hkdfSalt: cdn.hkdfSalt, sha256: cdn.hashSumEncrypted);
  }
}

/// Вложение к отправке: подготовленный (сжатый) файл и что о нём известно.
class SecretMediaDraft {
  final SecretMessageKind kind;
  final String path;
  final String fileName;
  final String mimeType;
  final int width;
  final int height;

  /// Видео / голосовое — секунд.
  final int duration;
  final String thumbhash;

  /// Видео — кадр-обложка (JPEG): уйдёт прямо в конверте, если маленький.
  final String thumbPath;
  final bool spoiler;

  /// Голосовое — уровни 0..255.
  final List<int> waveform;

  const SecretMediaDraft({
    required this.kind,
    required this.path,
    this.fileName = '',
    this.mimeType = 'application/octet-stream',
    this.width = 0,
    this.height = 0,
    this.duration = 0,
    this.thumbhash = '',
    this.thumbPath = '',
    this.spoiler = false,
    this.waveform = const [],
  });
}

/// Тип вложения в протоколе и обратно.
sp.SecretMedia_Kind secretMediaKindToPb(SecretMessageKind kind) => switch (kind) {
  SecretMessageKind.video => sp.SecretMedia_Kind.VIDEO,
  SecretMessageKind.file => sp.SecretMedia_Kind.FILE,
  SecretMessageKind.voice => sp.SecretMedia_Kind.VOICE,
  _ => sp.SecretMedia_Kind.PHOTO,
};

SecretMessageKind secretMediaKindFromPb(sp.SecretMedia_Kind kind) => switch (kind) {
  sp.SecretMedia_Kind.VIDEO => SecretMessageKind.video,
  sp.SecretMedia_Kind.FILE => SecretMessageKind.file,
  sp.SecretMedia_Kind.VOICE => SecretMessageKind.voice,
  _ => SecretMessageKind.photo,
};

/// Сервер отклонил запрос секретных чатов; [error] — текст ошибки сервера
/// (контракт — protos/secret_chats_v1.proto).
class SecretChatRequestException implements Exception {
  final String error;
  final int statusCode;

  const SecretChatRequestException(this.error, this.statusCode);

  bool get isDisabled => error == 'secretChat.disabled';
  bool get isPremiumRequired => error == 'secretChat.premiumRequired';
  bool get isPeerUnsupported => error == 'secretChat.peerUnsupported';
  bool get isFrozen => error == 'secretChat.frozen';

  /// Файл сообщения сервер не прикрепил (пропал, не наш) — это сообщение не
  /// уйдёт никогда.
  bool get isFileForbidden => error == 'secretChat.fileForbidden';
  bool get isPrivacyRestricted => statusCode == StatusCode.permissionDenied && error == 'privacyRestricted';

  /// Чата уже нет на сервере или он в другом состоянии (закрыт, принят на
  /// другом устройстве) — повторять бессмысленно.
  bool get isGone => error == 'secretChat.badState' || error == 'secretChat.notFound';

  @override
  String toString() => 'SecretChatRequestException($statusCode): $error';
}

/// Транспорт домена SECRET_CHATS: запрос → ответ. Ошибки — [ChatsOfflineException],
/// [ChatsFloodException], [SecretChatRequestException].
abstract class SecretChatsTransport {
  Future<sc.SecretChats_Response> request(sc.SecretChats_Request request);
}

class _ApiSecretChatsTransport implements SecretChatsTransport {
  /// Предел ожидания ответа: unary без дедлайна на полуоткрытом после сна
  /// соединении висит долго и держит всю очередь секретных чатов.
  static const _timeout = Duration(seconds: 20);

  @override
  Future<sc.SecretChats_Response> request(sc.SecretChats_Request request) async {
    final (status, body) = await getIt
        .get<API>()
        .unaryEncodedWithResponse(MessageType.SECRET_CHATS, request.writeToBuffer())
        .timeout(_timeout, onTimeout: () => throw const ChatsOfflineException());
    if (status.status == APIStatus.success && body != null) return sc.SecretChats_Response.fromBuffer(body);
    if (const [StatusCode.unavailable, StatusCode.deadlineExceeded, StatusCode.unknown].contains(status.statusCode)) {
      throw const ChatsOfflineException();
    }
    final flood = ChatsFloodException.parse(status.statusCode, status.error);
    if (flood != null) throw flood;
    throw SecretChatRequestException(status.error, status.statusCode);
  }
}

/// Синхронизация секретных чатов (docs/plans/secret-chats-e2ee.md): очередь
/// событий устройства с qts (push `SECRET_UPDATES` + догон `GetUpdates`),
/// рукопожатие и храповик ([SecretChatCrypto]) и outbox зашифрованных
/// конвертов.
///
/// Применение события — только локальное (ключи, БД), без сети: что нужно
/// отправить серверу (Accept, Commit, конверты), сохраняется и уходит в
/// [flush]. Поэтому событие никогда не «застревает» без сети, а повтор
/// отправки идёт теми же байтами (ключи не перегенерируются).
///
/// Всё, что трогает состояние храповика, идёт последовательно через [_locked].
class SecretChatsSync {
  SecretChatsSync({
    required SecretChatsRepository Function() store,
    required SecretChatCrypto Function() crypto,
    required this.transport,
    required List<int> Function() sessionID,
    required List<int> Function() userID,
    required this.hasNetwork,
    Logger Function()? logger,
    SecretMediaUploader? uploader,
    Future<Directory> Function()? mediaDir,
    void Function(List<Uint8List> fileIDs)? releaseLocal,
    DateTime Function()? clock,
    void Function(List<int> chatID)? clearNotifications,
  }) : _storeOf = store,
       _cryptoOf = crypto,
       _sessionIDOf = sessionID,
       _userIDOf = userID,
       _loggerOf = logger,
       _uploader = uploader ?? _CdnSecretMediaUploader(),
       _mediaDir = mediaDir ?? secretOutboxMediaDir,
       _releaseLocal = releaseLocal ?? _evictDownloads,
       _clock = clock ?? DateTime.now,
       _clearNotifications = clearNotifications ?? _clearPushes;

  static SecretChatsSync? _instance;

  /// Синглтон приложения (зависимости — из get_it, лениво).
  static SecretChatsSync get instance => _instance ??= SecretChatsSync(
    store: () => getIt.get<Repositories>().secretChats,
    crypto: () => getIt.get<Crypto>().secretChat,
    transport: _ApiSecretChatsTransport(),
    sessionID: () => getIt.get<Auth>().session.sessionID,
    userID: () => getIt.get<Auth>().session.userID,
    hasNetwork: () => getIt.get<Utils>().hasNetwork(),
    logger: () => getIt.get<Logger>(),
  );

  final SecretChatsRepository Function() _storeOf;
  final SecretChatCrypto Function() _cryptoOf;
  final SecretChatsTransport transport;
  final List<int> Function() _sessionIDOf;
  final List<int> Function() _userIDOf;
  final Future<bool> Function() hasNetwork;
  final Logger Function()? _loggerOf;
  final SecretMediaUploader _uploader;
  final Future<Directory> Function() _mediaDir;

  /// Убрать с устройства скачанные файлы удалённых сообщений.
  final void Function(List<Uint8List> fileIDs) _releaseLocal;
  final DateTime Function() _clock;

  /// Снять показанные уведомления чата (прочитан / удалён).
  final void Function(List<int> chatID) _clearNotifications;

  static void _clearPushes(List<int> chatID) => unawaited(PushManager.clearChatNotifications(chatID, all: true));

  static void _evictDownloads(List<Uint8List> fileIDs) {
    for (final id in fileIDs) {
      SecretChatsMedia.instance.forget(id);
      unawaited(
        getIt.get<CDNManager>().evict(id).catchError((Object error, StackTrace stackTrace) {
          getIt.get<Logger>().handle(error, stackTrace);
          return false;
        }),
      );
    }
  }

  SecretChatsRepository get store => _storeOf();
  SecretChatCrypto get _crypto => _cryptoOf();
  List<int> get _sessionID => _sessionIDOf();

  /// Мой userID (активная сессия).
  List<int> get me => _userIDOf();

  void _log(Object error, [StackTrace? stackTrace]) {
    final logger = _loggerOf?.call();
    if (logger != null) {
      logger.handle(error, stackTrace);
    } else {
      debugPrint('SecretChatsSync: $error');
    }
  }

  /// Размер страницы догона.
  static const _pageLimit = 100;

  /// Предел страниц догона за раз (защита от бесконечного hasMore).
  static const _maxPages = 50;

  final _random = math.Random.secure();

  Future<void> _queue = Future.value();

  Future<T> _locked<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _queue = _queue.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  int _newRandomID() => (_random.nextInt(1 << 31) << 31 | _random.nextInt(1 << 31)) + 1;

  // --- очередь устройства ---

  /// Push `SECRET_UPDATES` по стриму.
  Future<void> handlePush(Uint8List payload) async {
    try {
      final updates = sc.SecretUpdates.fromBuffer(payload).updates.toList()..sort((a, b) => a.qts.compareTo(b.qts));
      await _locked(() => _applyPushed(updates));
    } catch (error, stackTrace) {
      if (error is! ChatsOfflineException) _log(error, stackTrace);
    }
    await flush();
  }

  /// Стрим (пере)подключился: догнать очередь, отправить отложенное.
  Future<void> onConnected() async {
    if (_sessionID.isEmpty) return;
    await expireNow();
    try {
      await _locked(_catchUp);
    } catch (error, stackTrace) {
      if (error is! ChatsOfflineException) _log(error, stackTrace);
    }
    await flush();
  }

  Future<void> _applyPushed(List<sc.SecretUpdate> updates) async {
    var qts = await store.qts(sessionID: _sessionID);
    for (final update in updates) {
      final number = update.qts.toInt();
      if (number <= qts) continue;
      if (number != qts + 1) {
        // Дыра (пропущенный push или сгоревший номер) — истина в GetUpdates.
        await _catchUp();
        return;
      }
      await _apply(update);
      qts = number;
      await store.setQts(sessionID: _sessionID, qts: qts);
    }
    await _ack(qts);
  }

  Future<void> _catchUp() async {
    var qts = await store.qts(sessionID: _sessionID);
    for (var page = 0; page < _maxPages; page++) {
      final response = await transport.request(
        sc.SecretChats_Request(
          getUpdates: sc.SecretChats_GetUpdates(afterQts: Int64(qts), limit: _pageLimit),
        ),
      );
      final result = response.getUpdates;
      for (final update in result.updates) {
        final number = update.qts.toInt();
        if (number <= qts) continue;
        await _apply(update);
        qts = number;
        await store.setQts(sessionID: _sessionID, qts: qts);
      }
      if (!result.hasMore || result.updates.isEmpty) break;
    }
    await _ack(qts);
  }

  /// Подтвердить обработку (сервер удалит из очереди). Без сети — не страшно:
  /// повтор отфильтруется по qts.
  Future<void> _ack(int qts) async {
    if (qts <= 0) return;
    try {
      await transport.request(sc.SecretChats_Request(ack: sc.SecretChats_Ack(maxQts: Int64(qts))));
    } catch (error, stackTrace) {
      if (error is! ChatsOfflineException) _log(error, stackTrace);
    }
  }

  /// Применяет одно событие локально. Ошибка расшифровки/формата не
  /// останавливает очередь: событие пропускается с записью в лог.
  Future<void> _apply(sc.SecretUpdate update) async {
    final chatID = Uint8List.fromList(update.secretChatID);
    try {
      switch (update.whichUpdate()) {
        case sc.SecretUpdate_Update.requested:
          await _onRequested(chatID, update);
        case sc.SecretUpdate_Update.accepted:
          await _onAccepted(chatID, update.accepted);
        case sc.SecretUpdate_Update.committed:
          await _onCommitted(chatID, update.committed);
        case sc.SecretUpdate_Update.newMessage:
          await _onNewMessage(chatID, update);
        case sc.SecretUpdate_Update.discarded:
          await _onDiscarded(chatID, update.discarded);
        case sc.SecretUpdate_Update.notSet:
          break;
      }
    } on SecretChatDuplicateException {
      // Повтор доставки — уже расшифровано.
    } on SecretChatException catch (error, stackTrace) {
      _log(error, stackTrace);
    }
  }

  /// Мне (B) пришёл запрос: принимаем автоматически, как Telegram, — ключи
  /// сохраняем сразу, Accept уходит в [flush].
  Future<void> _onRequested(Uint8List chatID, sc.SecretUpdate update) async {
    if (await store.chat(sessionID: _sessionID, secretChatID: chatID) != null) return;
    final (pending, accept) = await _crypto.accept(
      chatId: chatID,
      request: SecretChatRequest(commitment: Uint8List.fromList(update.requested.commitment)),
    );
    final request = sc.SecretChats_Request(
      accept: sc.SecretChats_Accept(secretChatID: chatID, ephemeralKey: accept.ephemeralKey, kemPublicKey: accept.kemPublicKey),
    );
    await store.insertChat(
      sessionID: _sessionID,
      secretChatID: chatID,
      peerUserID: update.requested.fromUserID,
      outgoing: false,
      state: SecretChatLocalState.accepting,
      pending: pending.toBytes(),
      request: request.writeToBuffer(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(update.date.toInt()),
    );
  }

  /// Моё (A) устройство-собеседник приняло: раскрываем ключ, Commit — в [flush].
  Future<void> _onAccepted(Uint8List chatID, sc.SecretUpdate_Accepted accepted) async {
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    if (chat == null || !chat.outgoing || chat.state != SecretChatLocalState.waiting || chat.pending == null) return;
    final (session, commit) = await _crypto.complete(
      chatId: chatID,
      pending: SecretChatInitiatorPending.fromBytes(chat.pending!),
      accept: SecretChatAccept(
        ephemeralKey: Uint8List.fromList(accepted.ephemeralKey),
        kemPublicKey: Uint8List.fromList(accepted.kemPublicKey),
      ),
    );
    final request = sc.SecretChats_Request(
      commit: sc.SecretChats_Commit(
        secretChatID: chatID,
        ephemeralKey: commit.ephemeralKey,
        nonce: commit.nonce,
        kemCiphertext: commit.kemCiphertext,
        ratchetKey: commit.ratchetKey,
      ),
    );
    await store.setHandshake(
      sessionID: _sessionID,
      secretChatID: chatID,
      state: SecretChatLocalState.committing,
      request: request.writeToBuffer(),
      ratchet: session.state.toBytes(),
      fingerprint: session.fingerprint.bytes,
      emoji: session.fingerprint.emoji,
    );
  }

  /// Я (B) получил раскрытие: чат готов.
  Future<void> _onCommitted(Uint8List chatID, sc.SecretUpdate_Committed committed) async {
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    // accepting — сервер принял наш Accept, но ответ до нас не дошёл.
    if (chat == null || chat.outgoing || chat.pending == null) return;
    if (chat.state != SecretChatLocalState.accepted && chat.state != SecretChatLocalState.accepting) return;
    final session = await _crypto.finish(
      pending: SecretChatResponderPending.fromBytes(chat.pending!),
      commit: SecretChatCommit(
        ephemeralKey: Uint8List.fromList(committed.ephemeralKey),
        nonce: Uint8List.fromList(committed.nonce),
        kemCiphertext: Uint8List.fromList(committed.kemCiphertext),
        ratchetKey: Uint8List.fromList(committed.ratchetKey),
      ),
    );
    await store.setHandshake(
      sessionID: _sessionID,
      secretChatID: chatID,
      state: SecretChatLocalState.ready,
      ratchet: session.state.toBytes(),
      fingerprint: session.fingerprint.bytes,
      emoji: session.fingerprint.emoji,
    );
  }

  Future<void> _onNewMessage(Uint8List chatID, sc.SecretUpdate update) async {
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    final ratchet = chat?.ratchet;
    if (chat == null || ratchet == null) {
      _log(StateError('secret chat: message for unknown or not ready chat'));
      return;
    }
    final decrypted = await _crypto.decrypt(
      state: SecretChatRatchetState.fromBytes(ratchet),
      envelope: Uint8List.fromList(update.newMessage.envelope),
    );
    final payload = sp.SecretPayload.fromBuffer(decrypted.plaintext);
    final randomID = update.newMessage.randomID.toInt();
    final date = DateTime.fromMillisecondsSinceEpoch(update.date.toInt());
    // Удалённые собеседником «у обоих» вложения — убрать с устройства.
    final removed = <SecretMessageRecord>[];

    await store.applyIncoming(
      sessionID: _sessionID,
      secretChatID: chatID,
      ratchet: decrypted.state.toBytes(),
      apply: (tx) async {
        switch (payload.whichPayload()) {
          case sp.SecretPayload_Payload.media:
            final media = payload.media;
            await tx.insertMessage(
              SecretMessageRecord(
                secretChatID: chatID,
                randomID: randomID,
                outgoing: false,
                text: media.caption,
                date: date,
                status: SecretMessageStatus.unread,
                replyToRandomID: media.replyToRandomID.toInt(),
                kind: secretMediaKindFromPb(media.kind),
                media: media.writeToBuffer(),
                ttl: media.ttl,
              ),
            );
          case sp.SecretPayload_Payload.setTtl:
            await tx.setTtl(payload.setTtl.seconds);
            await tx.insertMessage(
              SecretMessageRecord(
                secretChatID: chatID,
                randomID: randomID,
                outgoing: false,
                text: '',
                date: date,
                status: SecretMessageStatus.read,
                kind: SecretMessageKind.ttlChange,
                ttl: payload.setTtl.seconds,
              ),
            );
          case sp.SecretPayload_Payload.screenshot:
            await tx.insertMessage(
              SecretMessageRecord(
                secretChatID: chatID,
                randomID: randomID,
                outgoing: false,
                text: '',
                date: date,
                status: SecretMessageStatus.read,
                kind: SecretMessageKind.screenshot,
              ),
            );
          case sp.SecretPayload_Payload.text:
            await tx.insertMessage(
              SecretMessageRecord(
                secretChatID: chatID,
                randomID: randomID,
                outgoing: false,
                text: payload.text.text,
                date: date,
                status: SecretMessageStatus.unread,
                replyToRandomID: payload.text.replyToRandomID.toInt(),
                ttl: payload.text.ttl,
              ),
            );
          case sp.SecretPayload_Payload.read:
            // Отсчёт — с прочтения (время конверта на сервере), а не с того,
            // когда отметку принял этот телефон: проспал — удалится сразу,
            // вместе с копией собеседника.
            await tx.markOutgoingRead([for (final id in payload.read.randomIDs) id.toInt()], now: date);
          case sp.SecretPayload_Payload.delete:
            final ids = [for (final id in payload.delete.randomIDs) id.toInt()];
            _announceDeleted(chatID, ids);
            removed.addAll(await tx.deleteMessages(ids));
          case sp.SecretPayload_Payload.notSet:
            // Действие из будущего layer — храповик продвинут, остальное пропускаем.
            break;
        }
      },
    );
    await _cleanup(removed);
    _scheduleExpiry();
  }

  Future<void> _onDiscarded(Uint8List chatID, sc.SecretUpdate_Discarded discarded) async {
    if (discarded.reason == sc.SecretUpdate_Discarded_Reason.ACCEPTED_ELSEWHERE) {
      // Принят другим моим устройством — этот чат был не наш.
      await store.delete(sessionID: _sessionID, secretChatID: chatID);
      return;
    }
    final media = discarded.deleteHistory
        ? await store.mediaMessages(sessionID: _sessionID, secretChatID: chatID)
        : const <SecretMessageRecord>[];
    await store.discard(
      sessionID: _sessionID,
      secretChatID: chatID,
      reason: discarded.reason.value,
      deleteHistory: discarded.deleteHistory,
    );
    await _cleanup(media);
    if (discarded.deleteHistory) _clearNotifications(chatID);
  }

  // --- действия ---

  /// Начать секретный чат с [peerUserID]. Нужна сеть; возвращает id чата.
  Future<Uint8List> create(List<int> peerUserID) async {
    if (!await hasNetwork()) throw const ChatsOfflineException();
    // Под замком: ответ собеседника (accepted) может прийти раньше, чем мы
    // запишем чат, — тогда push подождёт.
    return _locked(() async {
      final (pending, request) = await _crypto.request();
      final response = await transport.request(
        sc.SecretChats_Request(
          createChat: sc.SecretChats_Create(userID: peerUserID, commitment: request.commitment, randomID: Int64(_newRandomID())),
        ),
      );
      final chat = response.createChat.chat;
      final chatID = Uint8List.fromList(chat.secretChatID);
      await store.insertChat(
        sessionID: _sessionID,
        secretChatID: chatID,
        peerUserID: peerUserID,
        outgoing: true,
        state: SecretChatLocalState.waiting,
        pending: pending.toBytes(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(chat.date.toInt()),
      );
      return chatID;
    });
  }

  /// Отправить текст. Без сети — ждёт в outbox (конверт уже зашифрован).
  Future<void> sendText(List<int> chatID, String text, {int replyToRandomID = 0}) async {
    final randomID = _newRandomID();
    final ttl = (await store.chat(sessionID: _sessionID, secretChatID: chatID))?.ttl ?? 0;
    final payload = sp.SecretPayload(
      layer: secretPayloadLayer,
      text: sp.SecretText(text: text, replyToRandomID: Int64(replyToRandomID), ttl: ttl),
    );
    await _enqueue(
      chatID,
      payload,
      randomID,
      notify: true,
      message: SecretMessageRecord(
        secretChatID: Uint8List.fromList(chatID),
        randomID: randomID,
        outgoing: true,
        text: text,
        date: DateTime.now(),
        status: SecretMessageStatus.pending,
        replyToRandomID: replyToRandomID,
        ttl: ttl,
      ),
    );
    unawaited(flush());
  }

  /// Таймер самоуничтожения новых сообщений чата ([secretTtlOptions]; 0 —
  /// выключить): у обоих — служебное «… установил таймер».
  Future<void> setTtl(List<int> chatID, int seconds) async {
    final randomID = _newRandomID();
    await _enqueue(
      chatID,
      sp.SecretPayload(
        layer: secretPayloadLayer,
        setTtl: sp.SecretSetTtl(seconds: seconds),
      ),
      randomID,
      message: SecretMessageRecord(
        secretChatID: Uint8List.fromList(chatID),
        randomID: randomID,
        outgoing: true,
        text: '',
        date: _clock(),
        status: SecretMessageStatus.pending,
        kind: SecretMessageKind.ttlChange,
        ttl: seconds,
      ),
      apply: (tx) => tx.setTtl(seconds),
    );
    unawaited(flush());
  }

  /// Я сделал снимок экрана чата (iOS): собеседнику — «… сделал скриншот».
  /// Чат не готов — некому сказать.
  Future<void> screenshotTaken(List<int> chatID) async {
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    if (chat == null || !chat.state.canSend) return;
    final randomID = _newRandomID();
    await _enqueue(
      chatID,
      sp.SecretPayload(layer: secretPayloadLayer, screenshot: sp.SecretScreenshot()),
      randomID,
      notify: true,
      message: SecretMessageRecord(
        secretChatID: Uint8List.fromList(chatID),
        randomID: randomID,
        outgoing: true,
        text: '',
        date: _clock(),
        status: SecretMessageStatus.pending,
        kind: SecretMessageKind.screenshot,
      ),
    );
    unawaited(flush());
  }

  // --- самоуничтожение ---

  Timer? _expiryTimer;

  /// Удалить сообщения, чей таймер истёк (каждый у себя — собеседнику
  /// сообщать не нужно, у него тот же таймер), и завести таймер на
  /// следующее.
  Future<void> expireNow() async {
    if (_sessionID.isEmpty) return;
    try {
      final expired = await store.expired(sessionID: _sessionID, now: _clock());
      final byChat = <String, List<SecretMessageRecord>>{};
      for (final message in expired) {
        byChat.putIfAbsent(_hex(message.secretChatID), () => []).add(message);
      }
      for (final messages in byChat.values) {
        final removed = <SecretMessageRecord>[];
        _announceDeleted(messages.first.secretChatID, [for (final m in messages) m.randomID]);
        // Мимо [_locked]: храповик не трогаем, а очередь может стоять на
        // сети (догон после сна) — пыль уже полетела, сообщение должно уйти.
        await store.update(
          sessionID: _sessionID,
          secretChatID: messages.first.secretChatID,
          apply: (tx) async => removed.addAll(await tx.deleteMessages([for (final m in messages) m.randomID])),
        );
        await _cleanup(removed);
      }
    } catch (error, stackTrace) {
      _log(error, stackTrace);
    }
    _scheduleExpiry();
  }

  void _scheduleExpiry() {
    unawaited(() async {
      try {
        final next = await store.nextExpiry(sessionID: _sessionID);
        _expiryTimer?.cancel();
        _expiryTimer = null;
        if (next == null) return;
        final wait = next.difference(_clock());
        _expiryTimer = Timer(wait.isNegative ? Duration.zero : wait + const Duration(milliseconds: 50), () => unawaited(expireNow()));
      } catch (error, stackTrace) {
        _log(error, stackTrace);
      }
    }());
  }

  /// Сколько байт кадра-обложки видео можно положить прямо в конверт (больше
  /// — только ThumbHash): конверт с паддингом не должен выходить за 64 КБ.
  static const maxInlineThumb = 40 * 1024;

  /// Отправить фото / видео / файл. Файл копируется (временный может
  /// исчезнуть), загружается при сети, и только потом шифруется и уходит
  /// конверт с его ключом (ключ, соль и хеш знают только участники чата).
  /// Без сети — ждёт с часиками, как текст.
  Future<void> sendMedia(List<int> chatID, SecretMediaDraft draft, {String caption = '', int replyToRandomID = 0}) async {
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    if (chat == null || !chat.state.canSend) throw const SecretChatException('chat is not ready');
    final source = File(draft.path);
    final name = '${DateTime.now().microsecondsSinceEpoch}_${_newRandomID()}${p.extension(draft.path).toLowerCase()}';
    await source.copy(p.join((await _mediaDir()).path, name));

    var thumb = Uint8List(0);
    if (draft.thumbPath.isNotEmpty) {
      final file = File(draft.thumbPath);
      if (await file.exists() && await file.length() <= maxInlineThumb) thumb = await file.readAsBytes();
    }
    final media = sp.SecretMedia(
      ttl: chat.ttl,
      kind: secretMediaKindToPb(draft.kind),
      size: Int64(await source.length()),
      mimeType: draft.mimeType,
      fileName: draft.fileName.isNotEmpty ? draft.fileName : p.basename(draft.path),
      width: draft.width,
      height: draft.height,
      duration: draft.duration,
      thumbhash: draft.thumbhash,
      thumb: thumb,
      spoiler: draft.spoiler,
      waveform: draft.waveform,
      caption: caption,
      replyToRandomID: Int64(replyToRandomID),
    );
    await store.queueUpload(
      sessionID: _sessionID,
      secretChatID: chatID,
      message: SecretMessageRecord(
        secretChatID: Uint8List.fromList(chatID),
        randomID: _newRandomID(),
        outgoing: true,
        text: caption,
        date: DateTime.now(),
        status: SecretMessageStatus.pending,
        replyToRandomID: replyToRandomID,
        kind: draft.kind,
        media: media.writeToBuffer(),
        localPath: name,
        ttl: chat.ttl,
      ),
    );
    unawaited(flush());
  }

  /// Кадр-обложка видео из конверта [bytes] — файлом для пузыря (пишется один
  /// раз; удаляется вместе с сообщением). Пусто — обложки нет.
  Future<String> thumbFile(int randomID, List<int> bytes) async {
    if (bytes.isEmpty) return '';
    final file = File(p.join((await _mediaDir()).path, _thumbName(randomID)));
    if (!await file.exists()) await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static String _thumbName(int randomID) => 'thumb_$randomID.jpg';

  /// Полный путь копии неотправленного вложения ([SecretMessageRecord.localPath]).
  Future<String> outboxFilePath(String name) async => name.isEmpty ? '' : p.join((await _mediaDir()).path, name);

  /// Прогресс загрузки вложения сообщения [randomID] (байты шифротекста);
  /// `null` — не грузится.
  ({int sent, int total})? uploadProgress(int randomID) => _uploadProgress[randomID];
  final _uploadProgress = <int, ({int sent, int total})>{};

  /// Изменился прогресс загрузки (для перерисовки ленты).
  Stream<void> get uploadChanged => _uploadChanged.stream;
  final _uploadChanged = StreamController<void>.broadcast(sync: true);

  /// Сообщения сейчас пропадут из БД (удалил собеседник, истёк таймер; свои
  /// удаления окно рассыпает само) — шлётся ДО записи, чтобы открытое окно чата успело придержать
  /// строки и рассыпать их пылью. [chatID] — hex, [messageIDs] — randomID.
  Stream<({String chatID, List<String> messageIDs})> get messagesDeleted => _messagesDeleted.stream;
  final _messagesDeleted = StreamController<({String chatID, List<String> messageIDs})>.broadcast(sync: true);

  void _announceDeleted(List<int> chatID, Iterable<int> randomIDs) =>
      _messagesDeleted.add((chatID: _hex(chatID), messageIDs: [for (final id in randomIDs) '$id']));

  /// Отменённые загрузки (сообщение удалено, пока файл грузился).
  final _cancelledUploads = <int>{};

  /// Неудачные загрузки при наличии сети: после [_maxUploadFailures] подряд
  /// сообщение — «не отправлено» (иначе встала бы вся очередь чата).
  final _uploadFailures = <int, int>{};
  static const _maxUploadFailures = 3;

  /// Ссылки на файлы чата для скачивания: fileID (hex) → адрес. Нужна сеть.
  Future<Map<String, String>> fileUrls(List<int> chatID, List<List<int>> fileIDs) async {
    final response = await transport.request(
      sc.SecretChats_Request(
        getFiles: sc.SecretChats_GetFiles(secretChatID: chatID, fileIDs: fileIDs),
      ),
    );
    return {for (final file in response.getFiles.files) _hex(file.fileID): file.url};
  }

  /// Убрать с устройства всё, что осталось от удалённых сообщений с
  /// вложениями: идущую загрузку, копию неотправленного файла, скачанное.
  Future<void> _cleanup(List<SecretMessageRecord> removed) async {
    if (removed.isEmpty) return;
    final fileIDs = <Uint8List>[];
    for (final message in removed) {
      // Удалили, пока файл грузился, — загрузку бросаем.
      if (message.outgoing && message.status == SecretMessageStatus.pending) _cancelledUploads.add(message.randomID);
      for (final name in [message.localPath, _thumbName(message.randomID)]) {
        if (name.isEmpty) continue;
        try {
          final file = File(await outboxFilePath(name));
          if (await file.exists()) await file.delete();
        } catch (error, stackTrace) {
          _log(error, stackTrace);
        }
      }
      final media = message.media;
      if (media == null) continue;
      final fileID = sp.SecretMedia.fromBuffer(media).fileID;
      if (fileID.isNotEmpty) fileIDs.add(Uint8List.fromList(fileID));
    }
    if (fileIDs.isNotEmpty) _releaseLocal(fileIDs);
  }

  /// Файлы удалённых мной «у обоих» сообщений серверу больше не нужны.
  /// Без сети — не страшно: при закрытии чата сервер освободит их сам.
  Future<void> _releaseFiles(List<int> chatID, List<SecretMessageRecord> removed) async {
    final fileIDs = [
      for (final message in removed)
        if (message.media != null) sp.SecretMedia.fromBuffer(message.media!).fileID,
    ].where((id) => id.isNotEmpty).toList();
    if (fileIDs.isEmpty) return;
    try {
      await transport.request(
        sc.SecretChats_Request(
          releaseFiles: sc.SecretChats_ReleaseFiles(secretChatID: chatID, fileIDs: fileIDs),
        ),
      );
    } catch (error, stackTrace) {
      if (error is! ChatsOfflineException) _log(error, stackTrace);
    }
  }

  /// Я прочитал чат: отметки локально + «прочитано» собеседнику (его галочки).
  Future<void> markRead(List<int> chatID) async {
    final unread = await store.unreadIncoming(sessionID: _sessionID, secretChatID: chatID);
    if (unread.isEmpty) return;
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    _clearNotifications(chatID);
    if (chat == null || !chat.state.canSend) {
      // Чат закрыт — сказать собеседнику нечем, отмечаем только у себя.
      await store.update(
        sessionID: _sessionID,
        secretChatID: chatID,
        apply: (tx) => tx.markIncomingRead(unread, now: _clock()),
      );
      _scheduleExpiry();
      return;
    }
    await _enqueue(
      chatID,
      sp.SecretPayload(
        layer: secretPayloadLayer,
        read: sp.SecretRead(randomIDs: [for (final id in unread) Int64(id)]),
      ),
      _newRandomID(),
      apply: (tx) => tx.markIncomingRead(unread, now: _clock()),
    );
    _scheduleExpiry();
    unawaited(flush());
  }

  /// Удалить сообщения у обоих. Чат закрыт — только у себя (собеседнику
  /// сказать нечем).
  Future<void> deleteMessages(List<int> chatID, List<int> randomIDs) async {
    if (randomIDs.isEmpty) return;
    final removed = <SecretMessageRecord>[];
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    if (chat == null || !chat.state.canSend) {
      await store.update(
        sessionID: _sessionID,
        secretChatID: chatID,
        apply: (tx) async => removed.addAll(await tx.deleteMessages(randomIDs)),
      );
      await _cleanup(removed);
      return;
    }
    await _enqueue(
      chatID,
      sp.SecretPayload(
        layer: secretPayloadLayer,
        delete: sp.SecretDelete(randomIDs: [for (final id in randomIDs) Int64(id)]),
      ),
      _newRandomID(),
      apply: (tx) async => removed.addAll(await tx.deleteMessages(randomIDs)),
    );
    await _cleanup(removed);
    unawaited(_releaseFiles(chatID, removed));
    unawaited(flush());
  }

  /// Шифрует [payload] храповиком чата и ставит конверт в outbox (вместе с
  /// [message] / [apply]) — одной транзакцией с новым состоянием храповика.
  Future<void> _enqueue(
    List<int> chatID,
    sp.SecretPayload payload,
    int randomID, {
    bool notify = false,
    SecretMessageRecord? message,
    Future<void> Function(SecretChatsTx tx)? apply,
  }) {
    return _locked(() async {
      final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
      if (chat == null || !chat.state.canSend || chat.ratchet == null) {
        throw const SecretChatException('chat is not ready');
      }
      final encrypted = await _crypto.encrypt(state: SecretChatRatchetState.fromBytes(chat.ratchet!), plaintext: payload.writeToBuffer());
      await store.queueOutgoing(
        sessionID: _sessionID,
        secretChatID: chatID,
        ratchet: encrypted.state.toBytes(),
        randomID: randomID,
        envelope: encrypted.envelope,
        notify: notify,
        message: message,
        apply: apply,
      );
    });
  }

  /// Закрыть чат: собеседнику — «закрыт» ([deleteHistory] — удалить переписку
  /// и у него). [removeLocal] — убрать чат с устройства совсем. Нужна сеть
  /// (ещё не закрытый на сервере); уже закрытый — только локально.
  Future<void> discard(List<int> chatID, {bool deleteHistory = false, bool removeLocal = false}) async {
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    if (chat == null) return;
    if (chat.state != SecretChatLocalState.discarded) {
      if (!await hasNetwork()) throw const ChatsOfflineException();
      try {
        await transport.request(
          sc.SecretChats_Request(
            discard: sc.SecretChats_Discard(secretChatID: chatID, deleteHistory: deleteHistory),
          ),
        );
      } on SecretChatRequestException catch (error) {
        if (!error.isGone) rethrow;
      }
    }
    final media = removeLocal || deleteHistory
        ? await store.mediaMessages(sessionID: _sessionID, secretChatID: chatID)
        : const <SecretMessageRecord>[];
    await _locked(() async {
      if (removeLocal) {
        await store.delete(sessionID: _sessionID, secretChatID: chatID);
      } else {
        await store.discard(sessionID: _sessionID, secretChatID: chatID, reason: -1, deleteHistory: deleteHistory);
      }
    });
    await _cleanup(media);
    if (removeLocal || deleteHistory) _clearNotifications(chatID);
  }

  // --- отправка отложенного ---

  Future<void>? _flushing;
  bool _flushAgain = false;

  /// Отправить, что ждёт: Accept / Commit рукопожатий, затем конверты outbox
  /// (только в чаты, готовые на сервере). Без сети — тихо ждём следующего
  /// подключения. Уже идёт — пройдёт ещё раз после текущего (тот же Future).
  Future<void> flush() {
    if (_sessionID.isEmpty) return Future.value();
    final running = _flushing;
    if (running != null) {
      _flushAgain = true;
      return running;
    }
    return _flushing = _flushLoop().whenComplete(() => _flushing = null);
  }

  Future<void> _flushLoop() async {
    try {
      do {
        _flushAgain = false;
        await _flushHandshakes();
        await _flushUploads();
        await _flushOutbox();
      } while (_flushAgain);
    } on ChatsOfflineException {
      // Подождём подключения.
    } on ChatsFloodException {
      // Лимит частоты — следующая попытка при следующем действии/подключении.
    } catch (error, stackTrace) {
      _log(error, stackTrace);
    }
  }

  Future<void> _flushHandshakes() async {
    for (final chat in await store.chats(sessionID: _sessionID)) {
      final request = chat.request;
      if (request == null) continue;
      if (chat.state != SecretChatLocalState.accepting && chat.state != SecretChatLocalState.committing) continue;
      try {
        await transport.request(sc.SecretChats_Request.fromBuffer(request));
      } on SecretChatRequestException catch (error) {
        if (!error.isGone) rethrow;
        // Чат закрыт / принят на другом устройстве — событие об этом придёт
        // в очереди; запрос больше не нужен.
        await _locked(
          () =>
              store.discard(sessionID: _sessionID, secretChatID: chat.secretChatID, reason: sc.SecretUpdate_Discarded_Reason.BY_PEER.value),
        );
        continue;
      }
      await _locked(() async {
        // За время запроса мог прийти committed (accepting → ready) — не откатываем.
        final current = await store.chat(sessionID: _sessionID, secretChatID: chat.secretChatID);
        if (current == null || current.state != chat.state) return;
        await store.setHandshake(
          sessionID: _sessionID,
          secretChatID: chat.secretChatID,
          state: chat.state == SecretChatLocalState.accepting ? SecretChatLocalState.accepted : SecretChatLocalState.ready,
          pending: chat.state == SecretChatLocalState.accepting ? current.pending : null,
        );
      });
    }
  }

  /// Загрузить файлы ждущих вложений и поставить их конверты в outbox (на
  /// своё место в очереди чата — по времени отправки).
  Future<void> _flushUploads() async {
    final writable = {
      for (final chat in await store.chats(sessionID: _sessionID))
        if (chat.state.canSend) _hex(chat.secretChatID),
    };
    for (final upload in await store.uploads(sessionID: _sessionID)) {
      if (!writable.contains(_hex(upload.secretChatID))) continue;
      final randomID = upload.randomID;
      final message = await store.message(sessionID: _sessionID, secretChatID: upload.secretChatID, randomID: randomID);
      if (message == null || message.media == null) continue;
      final file = File(await outboxFilePath(message.localPath));
      if (message.localPath.isEmpty || !await file.exists()) {
        await store.update(sessionID: _sessionID, secretChatID: upload.secretChatID, apply: (tx) => tx.markFailed(randomID));
        continue;
      }
      final media = sp.SecretMedia.fromBuffer(message.media!);
      final SecretUploadedFile uploaded;
      try {
        uploaded = await _uploader.upload(
          file,
          contentType: media.mimeType,
          onProgress: (sent, total) {
            _uploadProgress[randomID] = (sent: sent, total: total);
            _uploadChanged.add(null);
          },
          isCancelled: () => _cancelledUploads.contains(randomID),
        );
      } catch (error, stackTrace) {
        if (_cancelledUploads.remove(randomID)) continue;
        if (!await hasNetwork()) throw const ChatsOfflineException();
        _log(error, stackTrace);
        final failures = (_uploadFailures[randomID] ?? 0) + 1;
        _uploadFailures[randomID] = failures;
        if (failures >= _maxUploadFailures) {
          _uploadFailures.remove(randomID);
          await store.update(sessionID: _sessionID, secretChatID: upload.secretChatID, apply: (tx) => tx.markFailed(randomID));
        }
        continue;
      } finally {
        if (_uploadProgress.remove(randomID) != null) _uploadChanged.add(null);
      }
      _uploadFailures.remove(randomID);
      media
        ..fileID = uploaded.fileID
        ..key = uploaded.key
        ..hkdfSalt = uploaded.hkdfSalt
        ..sha256 = uploaded.sha256;
      final queued = await _locked(() async {
        final chat = await store.chat(sessionID: _sessionID, secretChatID: upload.secretChatID);
        if (chat == null || !chat.state.canSend || chat.ratchet == null) return false;
        // Удалили, пока грузилось.
        if (await store.message(sessionID: _sessionID, secretChatID: upload.secretChatID, randomID: randomID) == null) return false;
        final encrypted = await _crypto.encrypt(
          state: SecretChatRatchetState.fromBytes(chat.ratchet!),
          plaintext: sp.SecretPayload(layer: secretPayloadLayer, media: media).writeToBuffer(),
        );
        final complete = media.writeToBuffer();
        await store.queueOutgoing(
          sessionID: _sessionID,
          secretChatID: upload.secretChatID,
          ratchet: encrypted.state.toBytes(),
          randomID: randomID,
          envelope: encrypted.envelope,
          files: [uploaded.fileID],
          notify: true,
          createdAt: upload.createdAt,
          apply: (tx) => tx.setUploaded(randomID, complete),
        );
        return true;
      });
      if (!queued) continue;
      try {
        await file.delete();
      } catch (error, stackTrace) {
        _log(error, stackTrace);
      }
    }
  }

  Future<void> _flushOutbox() async {
    final ready = {
      for (final chat in await store.chats(sessionID: _sessionID))
        if (chat.state == SecretChatLocalState.ready) _hex(chat.secretChatID),
    };
    // Порядок чата: всё, что отправили после ещё не загруженного вложения,
    // ждёт его (иначе фото пришло бы после следующего за ним текста).
    final waitFrom = <String, DateTime>{};
    for (final upload in await store.uploads(sessionID: _sessionID)) {
      waitFrom.putIfAbsent(_hex(upload.secretChatID), () => upload.createdAt);
    }
    for (final item in await store.outbox(sessionID: _sessionID)) {
      final chatKey = _hex(item.secretChatID);
      if (!ready.contains(chatKey)) continue;
      final wait = waitFrom[chatKey];
      if (wait != null && item.createdAt.isAfter(wait)) continue;
      final sc.SecretChats_Response response;
      try {
        response = await transport.request(
          sc.SecretChats_Request(
            send: sc.SecretChats_Send(
              secretChatID: item.secretChatID,
              randomID: Int64(item.randomID),
              envelope: item.envelope,
              fileIDs: item.files,
              notify: item.notify,
            ),
          ),
        );
      } on SecretChatRequestException catch (error) {
        if (error.isFileForbidden || error.isPrivacyRestricted) {
          // Файл пропал на сервере или один из нас заблокировал другого — это
          // сообщение не уйдёт (без повторов, иначе встанет вся очередь);
          // храповик собеседника пропуск переживёт.
          await store.outboxFailed(sessionID: _sessionID, secretChatID: item.secretChatID, randomID: item.randomID);
          continue;
        }
        if (!error.isGone) rethrow;
        ready.remove(chatKey);
        continue;
      }
      final date = response.send.date.toInt();
      await store.outboxSent(
        sessionID: _sessionID,
        secretChatID: item.secretChatID,
        randomID: item.randomID,
        date: date > 0 ? DateTime.fromMillisecondsSinceEpoch(date) : null,
      );
    }
  }

  static String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
