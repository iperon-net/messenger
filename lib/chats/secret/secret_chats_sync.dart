import 'dart:async';
import 'dart:math' as math;

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import '../../api.dart';
import '../../auth.dart';
import '../../crypto.dart';
import '../../di.dart';
import '../../logger.dart';
import '../../protobuf/protos/secret_chats_v1.pb.dart' as sc;
import '../../protobuf/protos/secret_payload_v1.pb.dart' as sp;
import '../../protobuf/protos/v1.pb.dart' show MessageType;
import '../../repositories.dart';
import '../../utils.dart';
import '../chats_sync.dart' show ChatsOfflineException, ChatsFloodException;

/// Сборка умеет секретные чаты — уходит в `Subscribe.Request.capabilities`:
/// запрос на секретный чат сервер шлёт только таким устройствам.
const secretChatsCapability = 'secretChats';

/// Версия формата `SecretPayload` у этой сборки (см. secret_payload_v1.proto).
const secretPayloadLayer = 1;

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
  @override
  Future<sc.SecretChats_Response> request(sc.SecretChats_Request request) async {
    final (status, body) = await getIt.get<API>().unaryEncodedWithResponse(MessageType.SECRET_CHATS, request.writeToBuffer());
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
  }) : _storeOf = store,
       _cryptoOf = crypto,
       _sessionIDOf = sessionID,
       _userIDOf = userID,
       _loggerOf = logger;

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

    await store.applyIncoming(
      sessionID: _sessionID,
      secretChatID: chatID,
      ratchet: decrypted.state.toBytes(),
      apply: (tx) async {
        switch (payload.whichPayload()) {
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
              ),
            );
          case sp.SecretPayload_Payload.read:
            await tx.markOutgoingRead([for (final id in payload.read.randomIDs) id.toInt()]);
          case sp.SecretPayload_Payload.delete:
            await tx.deleteMessages([for (final id in payload.delete.randomIDs) id.toInt()]);
          case sp.SecretPayload_Payload.notSet:
            // Действие из будущего layer — храповик продвинут, остальное пропускаем.
            break;
        }
      },
    );
  }

  Future<void> _onDiscarded(Uint8List chatID, sc.SecretUpdate_Discarded discarded) async {
    if (discarded.reason == sc.SecretUpdate_Discarded_Reason.ACCEPTED_ELSEWHERE) {
      // Принят другим моим устройством — этот чат был не наш.
      await store.delete(sessionID: _sessionID, secretChatID: chatID);
      return;
    }
    await store.discard(
      sessionID: _sessionID,
      secretChatID: chatID,
      reason: discarded.reason.value,
      deleteHistory: discarded.deleteHistory,
    );
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
    final payload = sp.SecretPayload(
      layer: secretPayloadLayer,
      text: sp.SecretText(text: text, replyToRandomID: Int64(replyToRandomID)),
    );
    await _enqueue(
      chatID,
      payload,
      randomID,
      message: SecretMessageRecord(
        secretChatID: Uint8List.fromList(chatID),
        randomID: randomID,
        outgoing: true,
        text: text,
        date: DateTime.now(),
        status: SecretMessageStatus.pending,
        replyToRandomID: replyToRandomID,
      ),
    );
    unawaited(flush());
  }

  /// Я прочитал чат: отметки локально + «прочитано» собеседнику (его галочки).
  Future<void> markRead(List<int> chatID) async {
    final unread = await store.unreadIncoming(sessionID: _sessionID, secretChatID: chatID);
    if (unread.isEmpty) return;
    final chat = await store.chat(sessionID: _sessionID, secretChatID: chatID);
    if (chat == null || !chat.state.canSend) {
      // Чат закрыт — сказать собеседнику нечем, отмечаем только у себя.
      await store.update(sessionID: _sessionID, secretChatID: chatID, apply: (tx) => tx.markIncomingRead(unread));
      return;
    }
    await _enqueue(
      chatID,
      sp.SecretPayload(
        layer: secretPayloadLayer,
        read: sp.SecretRead(randomIDs: [for (final id in unread) Int64(id)]),
      ),
      _newRandomID(),
      apply: (tx) => tx.markIncomingRead(unread),
    );
    unawaited(flush());
  }

  /// Удалить сообщения у обоих.
  Future<void> deleteMessages(List<int> chatID, List<int> randomIDs) async {
    if (randomIDs.isEmpty) return;
    await _enqueue(
      chatID,
      sp.SecretPayload(
        layer: secretPayloadLayer,
        delete: sp.SecretDelete(randomIDs: [for (final id in randomIDs) Int64(id)]),
      ),
      _newRandomID(),
      apply: (tx) => tx.deleteMessages(randomIDs),
    );
    unawaited(flush());
  }

  /// Шифрует [payload] храповиком чата и ставит конверт в outbox (вместе с
  /// [message] / [apply]) — одной транзакцией с новым состоянием храповика.
  Future<void> _enqueue(
    List<int> chatID,
    sp.SecretPayload payload,
    int randomID, {
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
    await _locked(() async {
      if (removeLocal) {
        await store.delete(sessionID: _sessionID, secretChatID: chatID);
      } else {
        await store.discard(sessionID: _sessionID, secretChatID: chatID, reason: -1, deleteHistory: deleteHistory);
      }
    });
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

  Future<void> _flushOutbox() async {
    final ready = {
      for (final chat in await store.chats(sessionID: _sessionID))
        if (chat.state == SecretChatLocalState.ready) _hex(chat.secretChatID),
    };
    for (final item in await store.outbox(sessionID: _sessionID)) {
      if (!ready.contains(_hex(item.secretChatID))) continue;
      final sc.SecretChats_Response response;
      try {
        response = await transport.request(
          sc.SecretChats_Request(
            send: sc.SecretChats_Send(secretChatID: item.secretChatID, randomID: Int64(item.randomID), envelope: item.envelope),
          ),
        );
      } on SecretChatRequestException catch (error) {
        if (!error.isGone) rethrow;
        ready.remove(_hex(item.secretChatID));
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
