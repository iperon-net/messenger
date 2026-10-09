import '../models.dart' as models;

/// Отметки о прочтении (как в Telegram, см. docs/plans/chats-groups-channels.md,
/// «Отметки о прочтении»): ✓✓ — по `Message.status`, а «кто и когда прочитал»
/// — по запросу из меню своего сообщения.

/// «Кто прочитал» — только в группах до стольких участников.
const readMarksMaxMembers = 100;

/// Время прочтения хранится столько после отправки (и в личных, и в группах).
const readMarksExpire = Duration(days: 7);

/// Ответ на «кто / когда прочитал».
enum MessageReadStatus {
  /// Есть: в личном — [MessageReadInfo.date], в группе — [MessageReadInfo.readers].
  read,

  /// Ещё никто не прочитал.
  notRead,

  /// Собеседник скрывает время прочтения (или мы скрыли своё — взаимно).
  hidden,

  /// Старше [readMarksExpire] / группа больше [readMarksMaxMembers].
  unavailable,
}

class MessageReader {
  final String userID;
  final String name;
  final DateTime date;

  /// Его реакция на сообщение (пусто — нет).
  final String reaction;

  const MessageReader({required this.userID, required this.name, required this.date, this.reaction = ''});
}

class MessageReadInfo {
  final MessageReadStatus status;

  /// Личный чат: когда собеседник прочитал.
  final DateTime? date;

  /// Группа: кто прочитал, от последних к первым.
  final List<MessageReader> readers;

  const MessageReadInfo(this.status, {this.date, this.readers = const []});
}

/// Показывать ли в меню сообщения строку «Прочитано …» / «Прочитали: N»:
/// своё прочитанное сообщение не старше [readMarksExpire], в личном чате (не
/// «Избранное») или в группе до [readMarksMaxMembers] участников. В каналах —
/// просмотры, а не прочтения.
bool readReceiptsApply(models.Chat chat, models.Message message, [DateTime? now]) {
  if (!message.outgoing || message.service || message.status != models.MessageStatus.read) return false;
  if (message.date.isBefore((now ?? DateTime.now()).subtract(readMarksExpire))) return false;
  return switch (chat.type) {
    models.ChatType.private => !chat.isSelf,
    models.ChatType.group => !chat.isThread && chat.membersCount <= readMarksMaxMembers,
    _ => false,
  };
}
