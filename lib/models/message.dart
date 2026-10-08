import 'package:dart_mappable/dart_mappable.dart';

import 'chat.dart';

part 'message.mapper.dart';

/// Тип разметки участка текста — как `MessageEntity.Type` в будущем proto (см.
/// docs/plans/chats-groups-channels.md, «Форматирование сообщений»).
@MappableEnum()
enum MessageEntityType {
  bold,
  italic,
  underline,
  strike,
  spoiler,
  code,
  pre,
  textUrl,
  url,
  mention,
  mentionName,
  hashtag,
  email,
  phone,
  blockquote,
}

/// Разметка участка [offset]..[offset]+[length] плоского текста (в UTF-16
/// code units, как `String` в Dart).
@MappableClass()
class MessageEntity with MessageEntityMappable {
  final MessageEntityType type;
  final int offset;
  final int length;

  /// Для [MessageEntityType.textUrl] — адрес ссылки.
  final String url;

  /// Для [MessageEntityType.mentionName] — кого упомянули (упоминание по
  /// имени, у человека нет @username).
  final String userID;

  const MessageEntity({required this.type, required this.offset, required this.length, this.url = '', this.userID = ''});

  int get end => offset + length;
}

/// Вариант ответа опроса: текст, голоса, наш выбор; у викторины — верный.
@MappableClass()
class PollOption with PollOptionMappable {
  final String text;
  final int votes;
  final bool chosen;
  final bool correct;

  /// Кто выбрал (открытый опрос в группе) — для списка «кто за что».
  final List<String> voters;

  const PollOption({required this.text, this.votes = 0, this.chosen = false, this.correct = false, this.voters = const []});
}

/// Опрос / викторина в сообщении (группа, канал).
@MappableClass()
class MessagePoll with MessagePollMappable {
  final String question;
  final List<PollOption> options;

  /// Анонимный — кто как голосовал, не видно (в канале — всегда).
  final bool anonymous;

  /// Можно выбрать несколько вариантов (не у викторины).
  final bool multiple;

  /// Викторина: один верный вариант, после ответа — [explanation].
  final bool quiz;
  final String explanation;

  /// Завершён: голосовать нельзя, видны итоги.
  final bool closed;

  const MessagePoll({
    required this.question,
    required this.options,
    this.anonymous = true,
    this.multiple = false,
    this.quiz = false,
    this.explanation = '',
    this.closed = false,
  });

  /// Мы уже проголосовали.
  bool get voted => options.any((o) => o.chosen);

  /// Проголосовавших (у мультивыбора человек считается один раз — в демо
  /// приближённо: по сумме голосов).
  int get totalVotes => options.fold(0, (sum, o) => sum + o.votes);

  /// Итоги видны: проголосовали или опрос завершён.
  bool get showResults => voted || closed;
}

/// Цитата сообщения, на которое отвечают, — в пузыре над текстом.
@MappableClass()
class MessageReply with MessageReplyMappable {
  final String messageID;
  final String senderName;

  /// Плоский текст (или подпись медиа) — одна строка в превью.
  final String text;
  final MessageKind kind;

  /// Ответ на фрагмент («Цитировать» в меню сообщения): в пузыре вместо
  /// [text] — цитата, тап подсвечивает фрагмент в исходном.
  final MessageQuote? quote;

  const MessageReply({required this.messageID, required this.senderName, this.text = '', this.kind = MessageKind.text, this.quote});
}

/// Процитированный фрагмент исходного сообщения (как `quote_text` в Telegram):
/// плоский [text] с разметкой [entities] (offset'ы — от начала фрагмента) и
/// его начало [offset] в исходном тексте — по нему фрагмент находится, даже
/// если такой же текст в сообщении встречается несколько раз.
@MappableClass()
class MessageQuote with MessageQuoteMappable {
  /// Предел длины цитаты (как `quote_length_max` в Telegram).
  static const maxLength = 1024;

  final String text;
  final List<MessageEntity> entities;
  final int offset;

  const MessageQuote({required this.text, this.entities = const [], this.offset = 0});
}

/// Пересланное сообщение: от кого (имя автора оригинала, для своих —
/// [self], в пузыре «Вы»). В пузыре — «Переслано от …» над содержимым.
@MappableClass()
class MessageForward with MessageForwardMappable {
  final String name;
  final bool self;

  const MessageForward({this.name = '', this.self = false});
}

/// Реакция на сообщение: эмодзи, сколько человек поставили и есть ли среди
/// них мы ([chosen]).
@MappableClass()
class MessageReaction with MessageReactionMappable {
  final String emoji;
  final int count;
  final bool chosen;

  const MessageReaction({required this.emoji, this.count = 1, this.chosen = false});
}

/// Превью ссылки под текстом (как в Telegram): сайт, заголовок, описание.
/// Позже собирает сервер (клиент не ходит по чужим ссылкам — не светит IP).
@MappableClass()
class MessageLinkPreview with MessageLinkPreviewMappable {
  final String url;
  final String siteName;
  final String title;
  final String description;

  const MessageLinkPreview({required this.url, this.siteName = '', this.title = '', this.description = ''});
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

  /// Скрыто под спойлером: размыто с пылью, пока не тапнут.
  final bool spoiler;

  /// Длительность видео, секунды (0 — неизвестна / фото).
  final int duration;

  const MessageMedia({
    required this.kind,
    this.localPath = '',
    this.width = 0,
    this.height = 0,
    this.size = 0,
    this.thumbPath = '',
    this.thumbhash = '',
    this.spoiler = false,
    this.duration = 0,
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

  /// Волна голосового: уровни громкости 0..31 (как 5-битная волна Telegram),
  /// обычно [voiceWaveformBars] штук; пусто — рисуется псевдослучайная.
  final List<int> waveform;

  static const voiceWaveformBars = 48;

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

  /// Реакции — в порядке появления (у первого — самый ранний).
  final List<MessageReaction> reactions;

  /// Переслано из другого чата; `null` — своё сообщение.
  final MessageForward? forward;

  /// Закреплено в чате — в плашке под шапкой (закреплённых может быть несколько).
  final bool pinned;

  /// Сервисное «Анна закрепила «…»» ([service]): id закреплённого сообщения
  /// (тап — к нему); автор — [senderName], у своего — [outgoing].
  final String pinnedMessageID;

  /// Отправлено «без звука» (удержание «Отправить»): получатель не слышит
  /// уведомления.
  final bool silent;

  /// Отложенное («Отправить позже»): когда уйдёт; `null` — обычное. Такие
  /// живут в отдельном списке (экран «Отложенные сообщения»), не в ленте.
  final DateTime? scheduledDate;

  /// Превью первой ссылки текста; `null` — нет ссылки или превью выключили
  /// перед отправкой (× над полем ввода).
  final MessageLinkPreview? linkPreview;

  /// Опрос ([MessageKind.poll]).
  final MessagePoll? poll;

  /// Подпись автора поста канала (канал с «Подписывать сообщения»); пусто —
  /// без подписи.
  final String authorSignature;

  /// Просмотры поста канала (глазок у времени); 0 — не показываем.
  final int views;

  /// Комментарии к посту канала и имена последних комментаторов (до 3 — их
  /// аватары в строке «N комментариев»).
  final int commentsCount;
  final List<String> commenters;

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
    this.waveform = const [],
    this.media = const [],
    this.fileSize = 0,
    this.uploadedBytes = 0,
    this.uploadTotal = 0,
    this.reactions = const [],
    this.forward,
    this.pinned = false,
    this.pinnedMessageID = '',
    this.silent = false,
    this.scheduledDate,
    this.linkPreview,
    this.poll,
    this.authorSignature = '',
    this.views = 0,
    this.commentsCount = 0,
    this.commenters = const [],
  });

  /// Наши реакции (до `maxReactionsPerUser` на сообщение), в порядке чипов.
  List<String> get myReactions => [
    for (final r in reactions)
      if (r.chosen) r.emoji,
  ];

  bool get isAlbum => media.length > 1;

  bool get isUploading => uploadTotal > 0;

  double get uploadProgress => uploadTotal > 0 ? (uploadedBytes / uploadTotal).clamp(0.0, 1.0) : 0;
}
