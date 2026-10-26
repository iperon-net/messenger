import 'package:dart_mappable/dart_mappable.dart';

part 'data_usage.mapper.dart';

/// Тип скачанных файлов в «Использовании памяти» (по contentType). [other] —
/// файлы не из сообщений: фото профилей и групп, прочее.
@MappableEnum()
enum StorageCategory { photos, videos, files, audio, other }

/// Сеть, по которой шёл трафик («Использование трафика»).
@MappableEnum()
enum NetworkKind { mobile, wifi }

/// Категория трафика. [messages] — gRPC (сообщения, синхронизация, запросы),
/// [calls] — медиа звонков (WebRTC), остальное — файлы CDN по типу.
@MappableEnum()
enum TrafficCategory { messages, photos, videos, files, audio, calls, other }

/// Файлы одного чата в кэше.
@MappableClass()
class StorageChatUsage with StorageChatUsageMappable {
  /// id чата из списка (hex; секретный — `secret:<hex>`).
  final String chatID;
  final Map<StorageCategory, int> byCategory;

  const StorageChatUsage({required this.chatID, this.byCategory = const {}});

  int get bytes => byCategory.values.fold(0, (a, b) => a + b);
}

/// Что Iperon хранит на устройстве (байты на диске).
@MappableClass()
class StorageReport with StorageReportMappable {
  /// Кэш скачанного по типам (вместе с [protectedBytes]).
  final Map<StorageCategory, int> byCategory;

  /// Фото профилей: часть [StorageCategory.other], не очищается (строка
  /// кэша — внешний ключ профиля).
  final int protectedBytes;

  /// База сообщений и служебные файлы аккаунта (неотправленное, свои файлы
  /// секретных чатов) — не очищается.
  final int database;

  /// Анимированные эмодзи (скачанные с CDN).
  final int emoji;

  /// Временные файлы (подготовка к отправке, экспорт).
  final int temp;

  /// Файлы по чатам, по убыванию размера.
  final List<StorageChatUsage> chats;

  const StorageReport({
    this.byCategory = const {},
    this.protectedBytes = 0,
    this.database = 0,
    this.emoji = 0,
    this.temp = 0,
    this.chats = const [],
  });

  int get media => byCategory.values.fold(0, (a, b) => a + b);

  int get total => media + database + emoji + temp;
}

/// Счётчик трафика одной категории.
@MappableClass()
class TrafficCounter with TrafficCounterMappable {
  final int sent;
  final int received;

  const TrafficCounter({this.sent = 0, this.received = 0});

  int get total => sent + received;
}
