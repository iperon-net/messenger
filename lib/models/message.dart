import 'package:dart_mappable/dart_mappable.dart';

import 'chat.dart';

part 'message.mapper.dart';

/// Тип разметки участка текста — как `MessageEntity.Type` в будущем proto (см.
/// docs/plans/chats-groups-channels.md, «Форматирование сообщений»).
@MappableEnum()
enum MessageEntityType { bold, italic, underline, strike, spoiler, code, pre, textUrl, url, mention, hashtag, email, phone, blockquote }

/// Разметка участка [offset]..[offset]+[length] плоского текста (в UTF-16
/// code units, как `String` в Dart).
@MappableClass()
class MessageEntity with MessageEntityMappable {
  final MessageEntityType type;
  final int offset;
  final int length;

  /// Для [MessageEntityType.textUrl] — адрес ссылки.
  final String url;

  const MessageEntity({required this.type, required this.offset, required this.length, this.url = ''});

  int get end => offset + length;
}

/// Цитата сообщения, на которое отвечают, — в пузыре над текстом.
@MappableClass()
class MessageReply with MessageReplyMappable {
  final String messageID;
  final String senderName;

  /// Плоский текст (или подпись медиа) — одна строка в превью.
  final String text;
  final MessageKind kind;

  const MessageReply({required this.messageID, required this.senderName, this.text = '', this.kind = MessageKind.text});
}

/// Элемент альбома (см. [Message.media]).
@MappableClass()
class MessageMedia with MessageMediaMappable {
  /// [MessageKind.photo] или [MessageKind.video].
  final MessageKind kind;

  /// Локальный путь выбранного медиа (демо: из галереи до загрузки; пусто —
  /// заглушка).
  final String localPath;

  /// Размеры кадра (0 — неизвестны) — пузырь держит пропорции до загрузки.
  final int width;
  final int height;

  /// Размер файла в байтах (0 — неизвестен).
  final int size;

  /// Миниатюра (локально; позже — свой `cdnID`).
  final String thumbPath;

  /// ThumbHash (base64) — размытое превью до загрузки, см. `prepareChatPhoto`.
  final String thumbhash;

  const MessageMedia({
    required this.kind,
    this.localPath = '',
    this.width = 0,
    this.height = 0,
    this.size = 0,
    this.thumbPath = '',
    this.thumbhash = '',
  });

  double? get aspectRatio => width > 0 && height > 0 ? width / height : null;
}

/// Сообщение чата. Пока клиентская модель для UX-демо; по форме близка к
/// будущему proto (плоский текст + entities).
@MappableClass()
class Message with MessageMappable {
  final String id;
  final String chatID;
  final MessageKind kind;

  /// Плоский текст без разметки; для медиа — подпись (может быть пустой).
  final String text;
  final List<MessageEntity> entities;

  /// Исходящее (наше) — справа, с галочками [status].
  final bool outgoing;

  /// Автор входящего в группе/канале (в личном чате не показывается).
  final String senderName;

  final MessageStatus status;
  final DateTime date;
  final bool edited;
  final MessageReply? reply;

  /// Сервисное сообщение («Анна добавила Ивана») — по центру, без пузыря.
  final bool service;

  /// Имя файла ([MessageKind.file]).
  final String fileName;

  /// Локальный путь выбранного медиа (демо: фото из галереи до загрузки).
  final String localPath;

  /// Длительность голосового, секунды.
  final int duration;

  /// Альбом: до [maxAlbum] фото/видео одним сообщением (сеткой в пузыре), подпись
  /// — [text]. Один элемент — метаданные одиночного фото/видео (размеры,
  /// thumbhash); пусто — обычное сообщение ([kind] + [localPath]).
  final List<MessageMedia> media;

  static const maxAlbum = 10;

  /// Размер файла ([MessageKind.file]) в байтах; 0 — неизвестен.
  final int fileSize;

  /// Загрузка вложений на CDN: отправлено [uploadedBytes] из [uploadTotal]
  /// (0 — не грузится). Пока грузится — статус `pending`, в пузыре прогресс.
  final int uploadedBytes;
  final int uploadTotal;

  const Message({
    required this.id,
    required this.chatID,
    this.kind = MessageKind.text,
    this.text = '',
    this.entities = const [],
    this.outgoing = false,
    this.senderName = '',
    this.status = MessageStatus.sent,
    required this.date,
    this.edited = false,
    this.reply,
    this.service = false,
    this.fileName = '',
    this.localPath = '',
    this.duration = 0,
    this.media = const [],
    this.fileSize = 0,
    this.uploadedBytes = 0,
    this.uploadTotal = 0,
  });

  bool get isAlbum => media.length > 1;

  bool get isUploading => uploadTotal > 0;

  double get uploadProgress => uploadTotal > 0 ? (uploadedBytes / uploadTotal).clamp(0.0, 1.0) : 0;
}
