import 'dart:async';
import 'dart:io';
import 'dart:math';

import '../chats/chats_data_source.dart';
import '../chats/message_formatting.dart';
import '../chats/reactions.dart';
import '../models.dart' as models;

/// Фейковые чаты и папки для UX-демо (флаг «Демо чатов» на экране
/// «Разработчик»). Состояние живёт в памяти процесса — одно на всё приложение,
/// чтобы список и «Архив» показывали одно и то же. Пока есть подписчики,
/// имитирует жизнь: кто-то печатает, приходят новые сообщения, наши исходящие
/// становятся прочитанными.
class ChatsDemoDataSource implements ChatsDataSource {
  ChatsDemoDataSource._() {
    _chats = [for (final c in _seedChats()) _withProfile(c)];
    _folders = _seedFolders();
  }

  static final ChatsDemoDataSource instance = ChatsDemoDataSource._();

  final _random = Random();
  late List<models.Chat> _chats;
  late List<models.ChatFolder> _folders;

  late final StreamController<List<models.Chat>> _chatsController = StreamController.broadcast(
    onListen: _startSimulation,
    onCancel: _stopSimulation,
  );
  final _foldersController = StreamController<List<models.ChatFolder>>.broadcast();

  Timer? _timer;

  @override
  Stream<List<models.Chat>> watchChats() async* {
    yield _chats;
    yield* _chatsController.stream;
  }

  @override
  Stream<List<models.ChatFolder>> watchFolders() async* {
    yield _folders;
    yield* _foldersController.stream;
  }

  @override
  Future<void> setPinned(String chatID, bool pinned) async => _update(chatID, (c) => c.copyWith(pinned: pinned));

  @override
  Future<void> setMuted(String chatID, bool muted) async => _update(chatID, (c) => c.copyWith(muted: muted));

  @override
  Future<void> setArchived(String chatID, bool archived) async =>
      _update(chatID, (c) => c.copyWith(archived: archived, pinned: archived ? false : c.pinned));

  @override
  Future<void> setRead(String chatID, bool read) async =>
      _update(chatID, (c) => read ? c.copyWith(unreadCount: 0, unreadMentions: 0, markedUnread: false) : c.copyWith(markedUnread: true));

  @override
  Future<void> readAll(List<String> chatIDs) async {
    _chats = [for (final c in _chats) chatIDs.contains(c.id) ? c.copyWith(unreadCount: 0, unreadMentions: 0, markedUnread: false) : c];
    _chatsController.add(_chats);
  }

  @override
  Future<void> setChatReactions(String chatID, models.ChatReactionsMode mode, List<String> reactions) async =>
      _update(chatID, (c) => c.copyWith(reactionsMode: mode, reactions: reactions));

  final _members = <String, List<models.ChatMember>>{};

  @override
  Future<List<models.ChatMember>> members(String chatID) async {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || chat.type == models.ChatType.private) return const [];
    return _members.putIfAbsent(chatID, () {
      final now = DateTime.now();
      // Демо: участники из имён истории + «Вы»; список — первые до 30.
      const surnames = ['Смирнова', 'Козлов', 'Иванова', 'Петров', 'Соколова', 'Морозов', 'Волкова', 'Новиков'];
      final count = min(chat.membersCount, 30);
      final result = <models.ChatMember>[models.ChatMember(id: 'me', name: 'Вы', role: chat.myRole, online: true, isSelf: true)];
      for (var i = 0; result.length < count; i++) {
        final name = '${_names[i % _names.length]} ${surnames[(i * 3) % surnames.length]}';
        final role = i == 0 && chat.myRole != models.ChatRole.owner
            ? models.ChatRole.owner
            : i < 2
            ? models.ChatRole.admin
            : (i % 4 == 3 ? models.ChatRole.reader : models.ChatRole.writer);
        result.add(
          models.ChatMember(
            id: 'u$i',
            name: name,
            role: role,
            online: i % 3 == 0,
            lastSeen: i % 3 == 0 ? null : now.subtract(Duration(minutes: 7 + i * 53)),
          ),
        );
      }
      int rank(models.ChatMember m) => m.role == models.ChatRole.owner ? 0 : (m.role == models.ChatRole.admin ? 1 : 2);
      final indexed = result.indexed.toList()
        ..sort((a, b) => rank(a.$2) != rank(b.$2) ? rank(a.$2).compareTo(rank(b.$2)) : a.$1.compareTo(b.$1));
      return [for (final (_, m) in indexed) m];
    });
  }

  /// Профиль демо-чата: «О себе» / описание, @username, число участников и
  /// наша роль.
  models.Chat _withProfile(models.Chat chat) {
    final now = DateTime.now();
    return switch (chat.id) {
      'anna' => chat.copyWith(about: 'Дизайнер интерфейсов. Люблю горы 🏔', username: 'anna_smirnova', online: true),
      'dmitry' => chat.copyWith(about: 'Backend, Go, Kubernetes', username: 'dkozlov', lastSeen: now.subtract(const Duration(minutes: 25))),
      'olga' => chat.copyWith(lastSeen: now.subtract(const Duration(hours: 2))),
      'maria' => chat.copyWith(about: 'Юрист', lastSeen: now.subtract(const Duration(days: 1))),
      'sergey' => chat.copyWith(username: 'spetrov', lastSeen: now.subtract(const Duration(hours: 5))),
      'alexey' => chat.copyWith(online: true),
      'team' => chat.copyWith(about: 'Рабочий чат команды Iperon: релизы, баги, планы.', membersCount: 12, myRole: models.ChatRole.admin),
      'family' => chat.copyWith(membersCount: 6, myRole: models.ChatRole.owner),
      'football' => chat.copyWith(about: 'Каждую среду в 20:00, манеж на Ленинградке.', membersCount: 18),
      'school' => chat.copyWith(about: 'Чат родителей 5 «Б» класса школы № 1234.', membersCount: 27, myRole: models.ChatRole.reader),
      'district' => chat.copyWith(
        about: 'Сообщество жителей ЖК «Северный»: новости УК, соседи, объявления.',
        username: 'severny_zhk',
        membersCount: 1340,
      ),
      'devs' => chat.copyWith(about: 'Русскоязычное сообщество Flutter-разработчиков.', username: 'flutter_ru', membersCount: 8420),
      'news' => chat.copyWith(
        about: 'Новости мессенджера Iperon.',
        username: 'iperon_news',
        membersCount: 15400,
        myRole: models.ChatRole.reader,
      ),
      'flutter' => chat.copyWith(
        about: 'Всё о Flutter и Dart.',
        username: 'flutter_dev',
        membersCount: 52300,
        myRole: models.ChatRole.reader,
      ),
      'tech' => chat.copyWith(
        about: 'Обзоры гаджетов и технологий.',
        username: 'tech_review',
        membersCount: 3100,
        myRole: models.ChatRole.owner,
      ),
      'shop' => chat.copyWith(membersCount: 920, myRole: models.ChatRole.reader),
      _ => chat,
    };
  }

  @override
  Future<void> delete(String chatID) async {
    _chats = _chats.where((c) => c.id != chatID).toList();
    _chatsController.add(_chats);
  }

  @override
  Future<void> deleteFolder(String folderID) async {
    _folders = _folders.where((f) => f.isAll || f.id != folderID).toList();
    _foldersController.add(_folders);
  }

  // ─── Сообщения ────────────────────────────────────────────────────────────

  /// История по чатам (от старых к новым); генерируется при первом открытии.
  final _messages = <String, List<models.Message>>{};
  final _messagesController = StreamController<String>.broadcast();
  var _nextID = 0;

  String _id() => 'm${_nextID++}';

  List<models.Message> _history(String chatID) => _messages.putIfAbsent(chatID, () => _seedMessages(chatID));

  @override
  Stream<List<models.Message>> watchMessages(String chatID) async* {
    yield _history(chatID);
    yield* _messagesController.stream.where((id) => id == chatID).map((_) => _history(chatID));
  }

  void _setMessages(String chatID, List<models.Message> messages) {
    _messages[chatID] = messages;
    _messagesController.add(chatID);
  }

  void _updateMessage(String chatID, String messageID, models.Message Function(models.Message) change) {
    _setMessages(chatID, [for (final m in _history(chatID)) m.id == messageID ? change(m) : m]);
  }

  models.ChatLastMessage _lastOf(models.Message m) => models.ChatLastMessage(
    kind: m.kind,
    text: m.kind == models.MessageKind.file && m.text.isEmpty ? m.fileName : m.text,
    senderName: m.outgoing ? '' : m.senderName,
    outgoing: m.outgoing,
    status: m.status,
    date: m.date,
  );

  /// Последнее сообщение чата в списке — по истории (после правки/удаления).
  void _syncLast(String chatID) {
    final history = _history(chatID).where((m) => !m.service);
    _update(chatID, (c) => c.copyWith(lastMessage: history.isEmpty ? null : _lastOf(history.last)));
  }

  @override
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
  }) async {
    if (scheduleDate != null && scheduleDate.isAfter(DateTime.now())) {
      _schedule(
        models.Message(
          id: _id(),
          chatID: chatID,
          text: text,
          entities: entities,
          outgoing: true,
          status: models.MessageStatus.pending,
          date: DateTime.now(),
          reply: reply,
          silent: silent,
          scheduledDate: scheduleDate,
          linkPreview: linkPreview ? _linkPreviewOf(text, entities) : null,
        ),
      );
      return;
    }
    final fileSize = kind == models.MessageKind.file ? await _fileSize(localPath) : 0;
    // Байты к загрузке: фото/видео альбома или одиночное медиа/файл.
    var uploadTotal = 0;
    if (kind != models.MessageKind.text) {
      final paths = media.isNotEmpty ? [for (final m in media) m.localPath] : [localPath];
      for (final (i, path) in paths.indexed) {
        final known = media.length > i ? media[i].size : 0;
        uploadTotal += known > 0 ? known : await _fileSize(path);
      }
    }
    final message = models.Message(
      id: _id(),
      chatID: chatID,
      kind: kind,
      text: text,
      entities: entities,
      outgoing: true,
      status: models.MessageStatus.pending,
      date: DateTime.now(),
      reply: reply,
      localPath: localPath,
      fileName: fileName,
      media: media,
      duration: duration,
      waveform: waveform,
      fileSize: fileSize,
      uploadTotal: uploadTotal,
      silent: silent,
      linkPreview: linkPreview && kind == models.MessageKind.text ? _linkPreviewOf(text, entities) : null,
    );
    _setMessages(chatID, [..._history(chatID), message]);
    _update(chatID, (c) => c.copyWith(lastMessage: _lastOf(message), draft: '', archived: false));

    if (uploadTotal > 0) {
      _simulateUpload(chatID, message.id, uploadTotal, onDone: () => _delivered(chatID, message.id));
    } else {
      _delivered(chatID, message.id);
    }
  }

  /// Превью первой ссылки (демо: заготовки для известных сайтов, иначе — имя
  /// хоста). Настоящие соберёт сервер.
  models.MessageLinkPreview? _linkPreviewOf(String text, List<models.MessageEntity> entities) {
    final url = firstLinkUrl(text, entities);
    final host = url == null ? null : Uri.tryParse(url)?.host.replaceFirst(RegExp(r'^www\.'), '');
    if (url == null || host == null || host.isEmpty) return null;
    final (site, title, description) = switch (host) {
      'flutter.dev' || 'docs.flutter.dev' => (
        'Flutter',
        'Flutter documentation',
        'Get started with Flutter. Widgets, examples, updates, and API docs to help you write your first Flutter app.',
      ),
      'github.com' => (
        'GitHub',
        'GitHub · Build and ship software on a single, collaborative platform',
        'Join the world’s most widely adopted developer platform.',
      ),
      'youtube.com' || 'youtu.be' => ('YouTube', 'YouTube', 'Смотрите любимые видео, слушайте музыку и делитесь ими с друзьями.'),
      'iperon.net' => ('Iperon', 'Iperon — мессенджер', 'Звонки, чаты и каналы с шифрованием.'),
      _ => (host, host, ''),
    };
    return models.MessageLinkPreview(url: url, siteName: site, title: title, description: description);
  }

  /// Отложенные по чатам (от ранних к поздним) и их таймеры (id → таймер).
  final _scheduled = <String, List<models.Message>>{};
  final _scheduleTimers = <String, Timer>{};
  final _scheduledController = StreamController<String>.broadcast();

  List<models.Message> _scheduledOf(String chatID) => _scheduled[chatID] ?? const [];

  void _setScheduled(String chatID, List<models.Message> messages) {
    _scheduled[chatID] = [...messages]..sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));
    _scheduledController.add(chatID);
  }

  /// В список отложенных + таймер на отправку.
  void _schedule(models.Message message) {
    final chatID = message.chatID;
    _scheduleTimers.remove(message.id)?.cancel();
    _setScheduled(chatID, [
      for (final m in _scheduledOf(chatID))
        if (m.id != message.id) m,
      message,
    ]);
    final delay = message.scheduledDate!.difference(DateTime.now());
    _scheduleTimers[message.id] = Timer(delay.isNegative ? Duration.zero : delay, () => sendScheduledNow(chatID, message.id));
  }

  @override
  Stream<List<models.Message>> watchScheduled(String chatID) async* {
    yield _scheduledOf(chatID);
    yield* _scheduledController.stream.where((id) => id == chatID).map((_) => _scheduledOf(chatID));
  }

  @override
  Future<void> sendScheduledNow(String chatID, String messageID) async {
    final message = _scheduledOf(chatID).where((m) => m.id == messageID).firstOrNull;
    await deleteScheduled(chatID, messageID);
    if (message == null) return;
    await sendMessage(
      chatID,
      text: message.text,
      entities: message.entities,
      reply: message.reply,
      silent: message.silent,
      linkPreview: message.linkPreview != null,
    );
  }

  @override
  Future<void> rescheduleMessage(String chatID, String messageID, DateTime date) async {
    final message = _scheduledOf(chatID).where((m) => m.id == messageID).firstOrNull;
    if (message != null) _schedule(message.copyWith(scheduledDate: date));
  }

  @override
  Future<void> deleteScheduled(String chatID, String messageID) async {
    _scheduleTimers.remove(messageID)?.cancel();
    _setScheduled(chatID, [
      for (final m in _scheduledOf(chatID))
        if (m.id != messageID) m,
    ]);
  }

  /// Идущие загрузки вложений (id сообщения → таймер), см. [cancelUpload].
  final _uploads = <String, Timer>{};

  /// Имитация загрузки на CDN: ~250–450 КБ/с с колебаниями, шаг 100 мс —
  /// чтобы прогресс было видно даже на сжатом фото.
  void _simulateUpload(String chatID, String messageID, int total, {required void Function() onDone}) {
    var sent = 0;
    _uploads[messageID] = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_chats.any((c) => c.id == chatID) || !_history(chatID).any((m) => m.id == messageID)) {
        timer.cancel();
        _uploads.remove(messageID);
        return;
      }
      sent = min(total, sent + 25000 + _random.nextInt(20000));
      final done = sent >= total;
      _updateMessage(chatID, messageID, (m) => m.copyWith(uploadedBytes: done ? 0 : sent, uploadTotal: done ? 0 : total));
      if (done) {
        timer.cancel();
        _uploads.remove(messageID);
        onDone();
      }
    });
  }

  Future<int> _fileSize(String path) async {
    if (path.isEmpty) return 0;
    try {
      return await File(path).length();
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<void> setReactions(String chatID, String messageID, List<String> emojis) async {
    _updateMessage(chatID, messageID, (m) => m.copyWith(reactions: applyMyReactions(m.reactions, emojis)));
  }

  @override
  Future<void> cancelUpload(String chatID, String messageID) async {
    _uploads.remove(messageID)?.cancel();
    await deleteMessage(chatID, messageID);
  }

  /// Сервер принял сообщение (после загрузки вложений, если были): ⏱ → ✓ →
  /// в личном чате собеседник читает, печатает, отвечает.
  void _delivered(String chatID, String messageID) {
    final message = _history(chatID).where((m) => m.id == messageID).firstOrNull;
    if (message == null) return;
    Timer(const Duration(milliseconds: 700), () => _setStatus(chatID, message.id, models.MessageStatus.sent));
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || chat.isSelf) {
      Timer(const Duration(milliseconds: 900), () => _setStatus(chatID, message.id, models.MessageStatus.read));
      return;
    }
    if (chat.type == models.ChatType.channel) return;
    Timer(const Duration(milliseconds: 1800), () {
      _setStatus(chatID, message.id, models.MessageStatus.read);
      // Иногда собеседник отвечает реакцией на наше сообщение.
      if (_random.nextInt(3) == 0 && _history(chatID).any((m) => m.id == message.id)) {
        final emoji = ['❤️', '👍', '🔥', '😂'][_random.nextInt(4)];
        _updateMessage(chatID, message.id, (m) => m.copyWith(reactions: addOtherReaction(m.reactions, emoji)));
      }
      final sender = chat.type == models.ChatType.private ? chat.title : _names[_random.nextInt(_names.length)];
      _update(chatID, (c) => c.copyWith(typing: sender));
    });
    Timer(const Duration(milliseconds: 4200), () => _incoming(chatID));
  }

  void _setStatus(String chatID, String messageID, models.MessageStatus status) {
    if (!_chats.any((c) => c.id == chatID)) return;
    _updateMessage(chatID, messageID, (m) => m.copyWith(status: status));
    final last = _history(chatID).lastOrNull;
    if (last?.id == messageID) _update(chatID, (c) => c.copyWith(lastMessage: _lastOf(last!)));
  }

  /// Входящее в чат: в историю (если она уже открыта) и в список чатов.
  void _incoming(String chatID, {bool mention = false}) {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null) return;
    final sender = chat.typing.isNotEmpty
        ? chat.typing
        : (chat.type == models.ChatType.private ? chat.title : _names[_random.nextInt(_names.length)]);
    final (text, entities) = parseMarkdownShortcuts(
      mention ? '@you ${_phrases[_random.nextInt(_phrases.length)]}' : _phrases[_random.nextInt(_phrases.length)],
    );
    final message = models.Message(
      id: _id(),
      chatID: chatID,
      text: text,
      entities: entities,
      senderName: chat.type == models.ChatType.private ? '' : sender,
      date: DateTime.now(),
    );
    if (_messages.containsKey(chatID)) _setMessages(chatID, [..._history(chatID), message]);
    _update(
      chatID,
      (c) => c.copyWith(
        typing: '',
        unreadCount: c.unreadCount + 1,
        unreadMentions: c.unreadMentions + (mention ? 1 : 0),
        lastMessage: _lastOf(message),
      ),
    );
  }

  @override
  Future<void> editMessage(String chatID, String messageID, String text, List<models.MessageEntity> entities) async {
    _updateMessage(
      chatID,
      messageID,
      (m) => m.copyWith(text: text, entities: entities, edited: true, linkPreview: _linkPreviewOf(text, entities)),
    );
    _syncLast(chatID);
  }

  @override
  Future<void> deleteMessage(String chatID, String messageID, {bool forEveryone = true}) async {
    // Демо: собеседника нет — у себя и у всех удаляется одинаково.
    _setMessages(chatID, _history(chatID).where((m) => m.id != messageID).toList());
    _syncLast(chatID);
  }

  @override
  Future<void> setMessagePinned(String chatID, String messageID, bool pinned, {bool forEveryone = true}) async {
    _updateMessage(chatID, messageID, (m) => m.copyWith(pinned: pinned));
    if (!pinned || !forEveryone) return;
    _setMessages(chatID, [
      ..._history(chatID),
      models.Message(
        id: _id(),
        chatID: chatID,
        outgoing: true,
        service: true,
        status: models.MessageStatus.read,
        date: DateTime.now(),
        pinnedMessageID: messageID,
      ),
    ]);
  }

  @override
  Future<void> unpinAllMessages(String chatID) async {
    _setMessages(chatID, [for (final m in _history(chatID)) m.pinned ? m.copyWith(pinned: false) : m]);
  }

  @override
  Future<void> forwardMessages(String toChatID, List<models.Message> messages) async {
    final source = {for (final c in _chats) c.id: c};
    final now = DateTime.now();
    final copies = [
      for (final (i, m) in messages.indexed)
        models.Message(
          id: _id(),
          chatID: toChatID,
          kind: m.kind,
          text: m.text,
          entities: m.entities,
          outgoing: true,
          status: models.MessageStatus.pending,
          date: now.add(Duration(microseconds: i)),
          localPath: m.localPath,
          fileName: m.fileName,
          duration: m.duration,
          waveform: m.waveform,
          media: m.media,
          fileSize: m.fileSize,
          // Пересылка пересланного — автор оригинала остаётся прежним.
          forward:
              m.forward ??
              models.MessageForward(
                self: m.outgoing,
                name: m.outgoing ? '' : (m.senderName.isNotEmpty ? m.senderName : source[m.chatID]?.title ?? ''),
              ),
        ),
    ];
    if (copies.isEmpty) return;
    _setMessages(toChatID, [..._history(toChatID), ...copies]);
    _update(toChatID, (c) => c.copyWith(lastMessage: _lastOf(copies.last), archived: false));
    // Файлы уже на CDN — пересылка без загрузки: сразу «доставлено».
    for (final m in copies.take(copies.length - 1)) {
      Timer(const Duration(milliseconds: 700), () => _setStatus(toChatID, m.id, models.MessageStatus.sent));
    }
    _delivered(toChatID, copies.last.id);
  }

  @override
  Future<void> setDraft(String chatID, String draft) async {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null || chat.draft == draft) return;
    _update(chatID, (c) => c.copyWith(draft: draft));
  }

  void _update(String chatID, models.Chat Function(models.Chat) change) {
    _chats = [for (final c in _chats) c.id == chatID ? change(c) : c];
    _chatsController.add(_chats);
  }

  // ─── Имитация жизни ───────────────────────────────────────────────────────

  void _startSimulation() {
    _timer ??= Timer.periodic(const Duration(seconds: 9), (_) => _tick());
  }

  void _stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }

  /// Один «такт»: случайный неархивный чат (кроме каналов — там не печатают)
  /// начинает печатать, через 3 с приходит сообщение. Заодно наши отправленные
  /// сообщения становятся прочитанными.
  void _tick() {
    final candidates = _chats.where((c) => !c.archived && !c.isSelf && c.type != models.ChatType.channel && c.draft.isEmpty).toList();
    if (candidates.isEmpty) return;
    final chat = candidates[_random.nextInt(candidates.length)];
    final sender = chat.type == models.ChatType.private ? chat.title : _names[_random.nextInt(_names.length)];

    _update(chat.id, (c) => c.copyWith(typing: sender));

    Timer(const Duration(seconds: 3), () {
      if (!_chats.any((c) => c.id == chat.id)) return;
      _incoming(chat.id, mention: chat.type != models.ChatType.private && _random.nextInt(5) == 0);
    });

    final readable = _chats.where((c) => c.lastMessage?.outgoing == true && c.lastMessage?.status == models.MessageStatus.sent);
    if (readable.isNotEmpty) {
      final c = readable.first;
      _update(c.id, (c) => c.copyWith(lastMessage: c.lastMessage!.copyWith(status: models.MessageStatus.read)));
      if (_messages.containsKey(c.id)) {
        _setMessages(c.id, [
          for (final m in _history(c.id))
            m.outgoing && m.status == models.MessageStatus.sent ? m.copyWith(status: models.MessageStatus.read) : m,
        ]);
      }
    }
  }

  // ─── Начальные данные ─────────────────────────────────────────────────────

  static const _names = ['Анна', 'Дмитрий', 'Ольга', 'Сергей', 'Мария', 'Алексей', 'Екатерина', 'Иван'];

  static const _phrases = [
    'Ок, договорились 👍',
    'Скинь, пожалуйста, ещё раз ссылку',
    'Буду через 10 минут',
    'Посмотрел, всё отлично',
    'А во сколько встречаемся?',
    'Спасибо!',
    'Созвонимся вечером?',
    'Уже выезжаю',
  ];

  List<models.Chat> _seedChats() {
    final now = DateTime.now();
    DateTime ago({int days = 0, int hours = 0, int minutes = 0}) => now.subtract(Duration(days: days, hours: hours, minutes: minutes));
    models.ChatLastMessage msg(
      String text, {
      required DateTime date,
      String sender = '',
      bool out = false,
      models.MessageStatus status = models.MessageStatus.sent,
      models.MessageKind kind = models.MessageKind.text,
    }) => models.ChatLastMessage(text: text, senderName: sender, outgoing: out, status: status, kind: kind, date: date);

    return [
      models.Chat(
        id: 'saved',
        type: models.ChatType.private,
        title: 'Избранное',
        isContact: true,
        isSelf: true,
        pinned: true,
        lastMessage: msg('Список покупок: молоко, хлеб, кофе', out: true, status: models.MessageStatus.read, date: ago(days: 1)),
      ),
      models.Chat(
        id: 'anna',
        type: models.ChatType.private,
        title: 'Анна Смирнова',
        isContact: true,
        pinned: true,
        unreadCount: 2,
        lastMessage: msg('Ты сегодня будешь на встрече?', date: ago(minutes: 4)),
      ),
      models.Chat(
        id: 'team',
        type: models.ChatType.group,
        title: 'Команда Iperon',
        unreadCount: 14,
        unreadMentions: 1,
        lastMessage: msg('Релиз 0.0.240 ушёл в TestFlight', sender: 'Дмитрий', date: ago(minutes: 12)),
      ),
      models.Chat(
        id: 'dmitry',
        type: models.ChatType.private,
        title: 'Дмитрий Козлов',
        isContact: true,
        lastMessage: msg('Скинул макеты, глянь', out: true, status: models.MessageStatus.sent, date: ago(minutes: 30)),
      ),
      models.Chat(
        id: 'news',
        type: models.ChatType.channel,
        title: 'Iperon News',
        muted: true,
        unreadCount: 3,
        lastMessage: msg('Встречайте папки в списке чатов!', kind: models.MessageKind.photo, date: ago(hours: 1)),
      ),
      models.Chat(
        id: 'olga',
        type: models.ChatType.private,
        title: 'Ольга',
        isContact: true,
        draft: 'Напомни, пожалуйста, адрес',
        lastMessage: msg('Хорошо, до завтра', date: ago(hours: 2)),
      ),
      models.Chat(
        id: 'district',
        type: models.ChatType.community,
        title: 'Жители ЖК «Северный»',
        unreadCount: 27,
        muted: true,
        lastMessage: msg('Завтра отключат горячую воду с 10:00', sender: 'УК', date: ago(hours: 3)),
      ),
      models.Chat(
        id: 'family',
        type: models.ChatType.group,
        title: 'Семья ❤️',
        lastMessage: msg('', kind: models.MessageKind.photo, sender: 'Мама', date: ago(hours: 5)),
      ),
      models.Chat(
        id: 'unknown',
        type: models.ChatType.private,
        title: '+7 916 123-45-67',
        unreadCount: 1,
        lastMessage: msg('Здравствуйте! Вы продаёте велосипед?', date: ago(hours: 7)),
      ),
      models.Chat(
        id: 'sergey',
        type: models.ChatType.private,
        title: 'Сергей Петров',
        isContact: true,
        markedUnread: true,
        lastMessage: msg('', kind: models.MessageKind.voice, date: ago(days: 1, hours: 2)),
      ),
      models.Chat(
        id: 'flutter',
        type: models.ChatType.channel,
        title: 'Flutter Dev',
        lastMessage: msg('Вышел Flutter 4.2 — что нового', date: ago(days: 1, hours: 5)),
      ),
      models.Chat(
        id: 'maria',
        type: models.ChatType.private,
        title: 'Мария',
        isContact: true,
        lastMessage: msg('договор.pdf', kind: models.MessageKind.file, out: true, status: models.MessageStatus.read, date: ago(days: 2)),
      ),
      models.Chat(
        id: 'football',
        type: models.ChatType.group,
        title: 'Футбол по средам ⚽',
        muted: true,
        unreadCount: 5,
        lastMessage: msg('Кто сегодня идёт?', sender: 'Иван', date: ago(days: 2, hours: 3)),
      ),
      models.Chat(
        id: 'alexey',
        type: models.ChatType.private,
        title: 'Алексей',
        isContact: true,
        lastMessage: msg('', kind: models.MessageKind.video, date: ago(days: 3)),
      ),
      models.Chat(
        id: 'devs',
        type: models.ChatType.community,
        title: 'Flutter Russia',
        lastMessage: msg('Вопрос по go_router и вложенным навигаторам', sender: 'Екатерина', date: ago(days: 4)),
      ),
      models.Chat(
        id: 'tech',
        type: models.ChatType.channel,
        title: 'Техно-обзор',
        // Админ разрешил только некоторые реакции.
        reactionsMode: models.ChatReactionsMode.some,
        reactions: const ['🔥', '👍', '🤯', '❤️'],
        lastMessage: msg('Обзор нового iPhone', kind: models.MessageKind.video, date: ago(days: 6)),
      ),
      models.Chat(
        id: 'school',
        type: models.ChatType.group,
        title: 'Родители 5 «Б»',
        // Реакции в группе выключены.
        reactionsMode: models.ChatReactionsMode.none,
        archived: true,
        unreadCount: 41,
        muted: true,
        lastMessage: msg('Сдаём на экскурсию до пятницы', sender: 'Ольга', date: ago(hours: 6)),
      ),
      models.Chat(
        id: 'shop',
        type: models.ChatType.channel,
        title: 'Скидки и акции',
        archived: true,
        unreadCount: 8,
        lastMessage: msg('−30% на всё до воскресенья', date: ago(days: 1)),
      ),
      models.Chat(
        id: 'old',
        type: models.ChatType.private,
        title: 'Курьер',
        archived: true,
        lastMessage: msg('Заказ доставлен', date: ago(days: 40)),
      ),
    ];
  }

  /// Диалог личного чата: (наше?, текст с markdown-ярлыками).
  static const _dialog = [
    (false, 'Привет! Как дела?'),
    (true, 'Привет 👋 Всё отлично, сам как?'),
    (false, 'Тоже норм. Слушай, **важно**: встреча переносится на __пятницу__'),
    (true, 'Ок, понял. Во сколько?'),
    (false, 'В 15:00, вот ссылка на док: https://iperon.net/docs'),
    (true, '~~Завтра~~ Сегодня вечером посмотрю'),
    (false, 'Код от домофона `4815`, если что'),
    (false, 'И не читай это: ||в пятницу будет торт 🎂||'),
    (true, '> встреча переносится на пятницу\nТогда я возьму ноутбук'),
    (false, 'Отлично, договорились'),
  ];

  static const _groupDialog = [
    'Всем привет! Кидаю план на неделю',
    '**Понедельник** — созвон, __вторник__ — ревью',
    'А где посмотреть задачи? #планирование',
    'Вот доска: [Задачи](https://iperon.net/board)',
    'Спасибо 🙏',
    'Кто возьмёт ревью ветки `chats`?',
    'Я посмотрю сегодня',
  ];

  static const _channelPosts = [
    '**Обновление 0.0.240** 🎉\n\n• папки в списке чатов\n• поиск прячется при прокрутке\n• новые табы на «Звонках»\n\nПодробнее: https://iperon.net/blog',
    'Опрос недели: чем вы пользуетесь чаще — __личными чатами__ или __группами__? Пишите в комментариях #опрос',
    '> Хороший мессенджер — тот, который не замечаешь\n\nДелимся планами на осень в нашем блоге.',
  ];

  /// История чата для демо: несколько дней переписки, кончается тем же
  /// последним сообщением, что видно в списке.
  List<models.Message> _seedMessages(String chatID) {
    final chat = _chats.where((c) => c.id == chatID).firstOrNull;
    if (chat == null) return [];
    final now = DateTime.now();
    final last = chat.lastMessage;
    final end = last?.date ?? now;
    var date = end.subtract(const Duration(days: 2, hours: 3));
    final result = <models.Message>[];

    void add(
      String raw, {
      bool out = false,
      String sender = '',
      models.MessageKind kind = models.MessageKind.text,
      String fileName = '',
      int duration = 0,
      bool service = false,
      models.MessageReply? reply,
      int album = 0,
      bool spoiler = false,
      bool pinned = false,
      String pinnedMessageID = '',
      List<models.MessageReaction> reactions = const [],
      Duration step = const Duration(minutes: 7),
    }) {
      date = date.add(step);
      final (text, entities) = parseMarkdownShortcuts(raw);
      result.add(
        models.Message(
          id: _id(),
          chatID: chatID,
          kind: kind,
          text: text,
          entities: entities,
          outgoing: out,
          senderName: out ? '' : sender,
          status: models.MessageStatus.read,
          date: date,
          fileName: fileName,
          duration: duration,
          service: service,
          reply: reply,
          media: [
            for (var i = 0; i < album; i++)
              models.MessageMedia(kind: i == 2 ? models.MessageKind.video : models.MessageKind.photo, spoiler: spoiler),
            if (album == 0 && spoiler) models.MessageMedia(kind: kind, spoiler: true),
          ],
          reactions: reactions,
          pinned: pinned,
          pinnedMessageID: pinnedMessageID,
          linkPreview: kind == models.MessageKind.text && !service ? _linkPreviewOf(text, entities) : null,
        ),
      );
    }

    models.MessageReaction r(String emoji, [int count = 1, bool chosen = false]) =>
        models.MessageReaction(emoji: emoji, count: count, chosen: chosen);

    switch (chat.type) {
      case models.ChatType.private when chat.isSelf:
        add('Идея: папки чатов как в Telegram, но с __сообществами__', out: true);
        add('', out: true, kind: models.MessageKind.file, fileName: 'план_релиза.pdf', step: const Duration(hours: 20));
        add('Ссылка на статью https://flutter.dev/docs', out: true, step: const Duration(hours: 5));
      case models.ChatType.private:
        for (final (i, (out, text)) in _dialog.indexed) {
          add(
            text,
            out: out,
            step: Duration(minutes: i == 5 ? 60 * 18 : 3 + i),
          );
        }
        add('Вид из окна 🌇', kind: models.MessageKind.photo, reactions: [r('❤️', 1, true)], step: const Duration(hours: 9));
        add('Угадай, где я 😏', kind: models.MessageKind.photo, spoiler: true);
        add(
          'Поездка на выходных 🏔',
          out: true,
          kind: models.MessageKind.photo,
          album: 4,
          reactions: [r('🔥')],
          step: const Duration(minutes: 40),
        );
        add('', out: true, kind: models.MessageKind.voice, duration: 12);
        final quoted = result[2];
        add(
          'Тогда до пятницы!',
          out: true,
          reply: models.MessageReply(messageID: quoted.id, senderName: chat.title, text: quoted.text),
        );
      case models.ChatType.group || models.ChatType.community:
        add('Анна добавила Ивана', service: true);
        for (final (i, text) in _groupDialog.indexed) {
          add(
            text,
            out: i == 6,
            sender: _names[i % _names.length],
            step: Duration(minutes: 4 + i * 9),
          );
        }
        add(
          'Фото с митапа',
          sender: 'Мария',
          kind: models.MessageKind.photo,
          album: 6,
          pinned: true,
          reactions: [r('👍', 5), r('❤️', 3, true), r('🔥', 2)],
          step: const Duration(hours: 20),
        );
        add('', sender: 'Мария', service: true, pinnedMessageID: result.last.id, step: const Duration(minutes: 1));
        add('', sender: 'Иван', kind: models.MessageKind.file, fileName: 'отчёт_сентябрь.xlsx', pinned: true);
        add('', sender: 'Иван', service: true, pinnedMessageID: result.last.id, step: const Duration(minutes: 1));
      case models.ChatType.channel:
        // Реакции канала — только из разрешённых админом.
        final allowed = chat.reactionsMode == models.ChatReactionsMode.some ? chat.reactions : const ['👍', '🔥', '❤️'];
        for (final (i, post) in _channelPosts.indexed) {
          add(
            post,
            reactions: chat.reactionsMode == models.ChatReactionsMode.none
                ? const []
                : [for (final (j, emoji) in allowed.take(3).indexed) r(emoji, 140 - j * 45 + i * 13)],
            step: const Duration(hours: 14),
          );
        }
    }

    // История не должна уходить в будущее относительно последнего сообщения.
    if (result.isNotEmpty && !result.last.date.isBefore(end)) {
      final shift = result.last.date.difference(end) + const Duration(minutes: 5);
      for (var i = 0; i < result.length; i++) {
        result[i] = result[i].copyWith(date: result[i].date.subtract(shift));
      }
    }

    if (last != null) {
      final (text, entities) = parseMarkdownShortcuts(last.text);
      result.add(
        models.Message(
          id: _id(),
          chatID: chatID,
          kind: last.kind,
          text: last.kind == models.MessageKind.file ? '' : text,
          entities: entities,
          fileName: last.kind == models.MessageKind.file ? last.text : '',
          duration: last.kind == models.MessageKind.voice ? 23 : 0,
          outgoing: last.outgoing,
          senderName: last.senderName,
          status: last.status,
          date: last.date,
        ),
      );
    }
    return result;
  }

  List<models.ChatFolder> _seedFolders() => const [
    models.ChatFolder(id: 'all', isAll: true),
    models.ChatFolder(
      id: 'unread',
      title: 'Непрочитанные',
      includeContacts: true,
      includeNonContacts: true,
      includeGroups: true,
      includeChannels: true,
      includeCommunities: true,
      excludeRead: true,
    ),
    models.ChatFolder(id: 'personal', title: 'Личные', includeContacts: true, includeNonContacts: true),
    models.ChatFolder(id: 'groups', title: 'Группы', includeGroups: true),
    models.ChatFolder(id: 'channels', title: 'Каналы', includeChannels: true),
    models.ChatFolder(id: 'communities', title: 'Сообщества', includeCommunities: true),
    models.ChatFolder(id: 'work', title: 'Работа', includeChatIDs: ['team', 'dmitry', 'devs', 'flutter']),
  ];
}
