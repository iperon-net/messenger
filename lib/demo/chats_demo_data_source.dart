import 'dart:async';
import 'dart:math';

import '../chats/chats_data_source.dart';
import '../models.dart' as models;

/// Фейковые чаты и папки для UX-демо (флаг «Демо чатов» на экране
/// «Разработчик»). Состояние живёт в памяти процесса — одно на всё приложение,
/// чтобы список и «Архив» показывали одно и то же. Пока есть подписчики,
/// имитирует жизнь: кто-то печатает, приходят новые сообщения, наши исходящие
/// становятся прочитанными.
class ChatsDemoDataSource implements ChatsDataSource {
  ChatsDemoDataSource._() {
    _chats = _seedChats();
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
  Future<void> delete(String chatID) async {
    _chats = _chats.where((c) => c.id != chatID).toList();
    _chatsController.add(_chats);
  }

  @override
  Future<void> deleteFolder(String folderID) async {
    _folders = _folders.where((f) => f.isAll || f.id != folderID).toList();
    _foldersController.add(_folders);
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
    final candidates = _chats.where((c) => !c.archived && c.type != models.ChatType.channel && c.draft.isEmpty).toList();
    if (candidates.isEmpty) return;
    final chat = candidates[_random.nextInt(candidates.length)];
    final sender = chat.type == models.ChatType.private ? chat.title : _names[_random.nextInt(_names.length)];

    _update(chat.id, (c) => c.copyWith(typing: sender));

    Timer(const Duration(seconds: 3), () {
      if (!_chats.any((c) => c.id == chat.id)) return;
      final mention = chat.type != models.ChatType.private && _random.nextInt(5) == 0;
      _update(
        chat.id,
        (c) => c.copyWith(
          typing: '',
          unreadCount: c.unreadCount + 1,
          unreadMentions: c.unreadMentions + (mention ? 1 : 0),
          lastMessage: models.ChatLastMessage(
            text: mention ? '@you ${_phrases[_random.nextInt(_phrases.length)]}' : _phrases[_random.nextInt(_phrases.length)],
            senderName: c.type == models.ChatType.private ? '' : sender,
            date: DateTime.now(),
          ),
        ),
      );
    });

    final readable = _chats.where((c) => c.lastMessage?.outgoing == true && c.lastMessage?.status == models.MessageStatus.sent);
    if (readable.isNotEmpty) {
      final c = readable.first;
      _update(c.id, (c) => c.copyWith(lastMessage: c.lastMessage!.copyWith(status: models.MessageStatus.read)));
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
        lastMessage: msg('Обзор нового iPhone', kind: models.MessageKind.video, date: ago(days: 6)),
      ),
      models.Chat(
        id: 'school',
        type: models.ChatType.group,
        title: 'Родители 5 «Б»',
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
