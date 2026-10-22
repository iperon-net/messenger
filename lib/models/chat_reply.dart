import 'package:dart_mappable/dart_mappable.dart';

import 'chat.dart';

part 'chat_reply.mapper.dart';

/// Элемент экрана «Ответы» (подэтап 4.6, как Replies в Telegram): сообщение
/// ветки комментариев, которое отвечает на мой комментарий или упоминает
/// меня. Тап — ветка [threadChatID] на сообщении [messageID] (через канал
/// [channelID] и пост [postID]).
@MappableClass()
class ChatReply with ChatReplyMappable {
  /// Нумерация «Ответов» у пользователя (растёт; курсор страниц и прочтения).
  final int replyID;

  /// hex: ветка, канал, автор ответа.
  final String threadChatID;
  final String channelID;
  final String authorID;

  final int messageID;
  final int postID;

  /// Упоминание меня, а не ответ на мой комментарий.
  final bool mention;

  final DateTime date;

  /// Имя автора по общему правилу (контакт → профиль → @username → номер).
  final String authorName;

  /// Название канала («в комментариях к …»); пусто — канал неизвестен.
  final String channelTitle;

  /// Начало поста из кэша; пусто — поста в кэше нет.
  final String postText;

  final MessageKind kind;

  /// Текст (у медиа — подпись, у опроса — вопрос).
  final String text;

  /// Превью медиа: скачанный файл (фото / обложка видео) или thumbhash.
  final String mediaPath;
  final String thumbhash;

  /// Не прочитан: новее readMaxID «Ответов» и не прочитан чтением ветки.
  final bool unread;

  /// Автор — локально скрытый профиль: без имени, аватара и текста (как в
  /// баннере и пушах).
  final bool hidden;

  const ChatReply({
    required this.replyID,
    required this.threadChatID,
    required this.channelID,
    required this.authorID,
    required this.messageID,
    required this.postID,
    required this.date,
    this.mention = false,
    this.authorName = '',
    this.channelTitle = '',
    this.postText = '',
    this.kind = MessageKind.text,
    this.text = '',
    this.mediaPath = '',
    this.thumbhash = '',
    this.unread = false,
    this.hidden = false,
  });

  /// Окно ветки на этом сообщении (`/chats/comments/<канал>/<пост>?message=`).
  String get route => '/chats/comments/$channelID/$postID?message=$messageID';
}
