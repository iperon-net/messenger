import 'package:dart_mappable/dart_mappable.dart';

part 'chat.mapper.dart';

/// Тип чата (см. docs/plans/chats-groups-channels.md). Сообщество — контейнер
/// над группами и каналами; в списке чатов показывается одной строкой.
@MappableEnum()
enum ChatType { private, group, channel, community }

/// Статус исходящего сообщения: ⏱ отправляется → ✓ на сервере → ✓✓ прочитано.
@MappableEnum()
enum MessageStatus { pending, sent, read }

/// Вид последнего сообщения — для превью в списке («Фото», «Файл» …).
@MappableEnum()
enum MessageKind { text, photo, video, file, voice }

/// Какие реакции разрешены в группе/канале (настраивает админ, см.
/// docs/plans/chats-groups-channels.md, «Реакции»). В личных чатах — всегда
/// фиксированный набор.
@MappableEnum()
enum ChatReactionsMode { all, some, none }

/// Последнее сообщение чата в том виде, в каком оно нужно списку чатов.
@MappableClass()
class ChatLastMessage with ChatLastMessageMappable {
  final MessageKind kind;

  /// Плоский текст (без разметки). Для медиа — подпись, может быть пустой.
  final String text;

  /// Имя автора — показывается в группах/сообществах («Анна: текст»).
  final String senderName;

  /// Исходящее (наше) — рядом с датой рисуются галочки [status].
  final bool outgoing;

  final MessageStatus status;
  final DateTime date;

  const ChatLastMessage({
    this.kind = MessageKind.text,
    this.text = '',
    this.senderName = '',
    this.outgoing = false,
    this.status = MessageStatus.sent,
    required this.date,
  });
}

/// Строка списка чатов (диалог). Пока клиентская модель для UX-демо; позже
/// заполняется из SQLite-кэша, синхронизируемого с сервером.
@MappableClass()
class Chat with ChatMappable {
  final String id;
  final ChatType type;
  final String title;

  /// Собеседник личного чата — в контактах (для правил папок «Контакты» /
  /// «Не контакты»).
  final bool isContact;

  /// «Избранное» — чат с самим собой (иконка-закладка вместо аватара).
  final bool isSelf;

  final ChatLastMessage? lastMessage;

  /// Непрочитанные сообщения.
  final int unreadCount;

  /// Непрочитанные упоминания (@) — отдельный бейдж.
  final int unreadMentions;

  /// Помечен «непрочитанным» вручную (без счётчика).
  final bool markedUnread;

  final bool muted;
  final bool pinned;
  final bool archived;

  /// Черновик — показывается вместо последнего сообщения.
  final String draft;

  /// Кто печатает: пусто — никто; в личном чате достаточно непустого значения,
  /// в группе — имя («Анна печатает…»).
  final String typing;

  /// Реакции группы/канала: все, выбранные ([reactions]) или никаких.
  final ChatReactionsMode reactionsMode;
  final List<String> reactions;

  const Chat({
    required this.id,
    required this.type,
    required this.title,
    this.isContact = false,
    this.isSelf = false,
    this.lastMessage,
    this.unreadCount = 0,
    this.unreadMentions = 0,
    this.markedUnread = false,
    this.muted = false,
    this.pinned = false,
    this.archived = false,
    this.draft = '',
    this.typing = '',
    this.reactionsMode = ChatReactionsMode.all,
    this.reactions = const [],
  });

  bool get hasUnread => unreadCount > 0 || markedUnread;

  /// Дата для сортировки (последнее сообщение).
  DateTime get sortDate => lastMessage?.date ?? DateTime.fromMillisecondsSinceEpoch(0);
}
