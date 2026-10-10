import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Вложения настоящих чатов (см. docs/plans/chats-groups-channels.md): файлы
/// неотправленных сообщений и всё, что про них можно посчитать без сети и UI.
///
/// Отправка: файл копируется в каталог outbox (temp-каталог iOS может
/// почистить, пока сообщение ждёт сети), загружается на CDN
/// (`CDNManager.uploadFile`, папка [chatMediaFolder]) — `cdnID` пишется в
/// содержимое outbox, — и только когда загружено всё, уходит само сообщение.
/// После загрузки файл уже лежит в кэше скачиваний под своим `cdnID`, копия из
/// outbox больше не нужна ([cleanOutboxFiles]).

/// Папка на CDN для вложений чатов.
const chatMediaFolder = 'chats';

/// Локальные файлы одного вложения неотправленного сообщения: имена в каталоге
/// outbox ([outboxMediaDir]) — относительные, потому что путь к контейнеру
/// приложения на iOS меняется при обновлении.
class OutboxMedia {
  final String path;

  /// Обложка видео (пусто — нет).
  final String thumb;

  const OutboxMedia({required this.path, this.thumb = ''});

  Map<String, String> toJson() => {'path': path, if (thumb.isNotEmpty) 'thumb': thumb};

  static String encode(List<OutboxMedia> media) => media.isEmpty ? '' : jsonEncode([for (final m in media) m.toJson()]);

  static List<OutboxMedia> decode(String raw) {
    if (raw.isEmpty) return const [];
    try {
      return [
        for (final item in jsonDecode(raw) as List<dynamic>)
          OutboxMedia(path: (item as Map<String, dynamic>)['path'] as String? ?? '', thumb: item['thumb'] as String? ?? ''),
      ];
    } on FormatException {
      return const [];
    }
  }

  /// Все имена файлов (для чистки каталога).
  static Iterable<String> names(String raw) sync* {
    for (final m in decode(raw)) {
      if (m.path.isNotEmpty) yield m.path;
      if (m.thumb.isNotEmpty) yield m.thumb;
    }
  }
}

Future<Directory> outboxMediaDir() async {
  final dir = Directory(p.join((await getApplicationSupportDirectory()).path, 'chat_outbox'));
  await dir.create(recursive: true);
  return dir;
}

var _stashCounter = 0;

/// Копия [source] в каталог outbox; возвращает имя файла там (пусто — нечего
/// копировать).
Future<String> stashOutboxFile(String source) async {
  if (source.isEmpty) return '';
  final name = '${DateTime.now().microsecondsSinceEpoch}_${_stashCounter++}${p.extension(source).toLowerCase()}';
  await File(source).copy(p.join((await outboxMediaDir()).path, name));
  return name;
}

/// Полный путь файла outbox по имени (пусто — пусто).
String outboxFilePath(Directory dir, String name) => name.isEmpty ? '' : p.join(dir.path, name);

/// Удалить из каталога outbox файлы, на которые не ссылается ни одно
/// неотправленное сообщение ([keep]). Свежие не трогаем: файл копируется до
/// записи строки outbox.
Future<void> cleanOutboxFiles(Set<String> keep, {Duration minAge = const Duration(minutes: 1)}) async {
  final dir = await outboxMediaDir();
  final now = DateTime.now();
  await for (final entity in dir.list()) {
    if (entity is! File || keep.contains(p.basename(entity.path))) continue;
    if (now.difference(await entity.lastModified()) < minAge) continue;
    await entity.delete();
  }
}

/// MIME по расширению — для CDN (по нему кэш скачиваний выбирает расширение
/// файла, а плееры и просмотрщики — формат).
String chatMediaContentType(String path) => switch (p.extension(path).toLowerCase()) {
  '.jpg' || '.jpeg' => 'image/jpeg',
  '.png' => 'image/png',
  '.gif' => 'image/gif',
  '.webp' => 'image/webp',
  '.heic' => 'image/heic',
  '.mp4' => 'video/mp4',
  '.mov' => 'video/quicktime',
  '.m4a' => 'audio/mp4',
  '.aac' => 'audio/aac',
  '.mp3' => 'audio/mpeg',
  '.pdf' => 'application/pdf',
  _ => 'application/octet-stream',
};

/// Волна голосового: модель — 0..31 (5 бит, как в Telegram), proto — 0..255.
List<int> waveformToPb(List<int> levels) => [for (final v in levels) math.min(255, v.clamp(0, 31) << 3)];

/// Прогресс загрузки вложений сообщения в байтах исходных файлов: [done] —
/// уже загруженные файлы целиком, текущий — доля [sent]/[total] шифротекста
/// от его размера [current]. Шифротекст чуть больше файла (тег на чанк), так
/// что считаем долями, а не байтами.
int uploadedBytes({required int done, required int current, required int sent, required int total}) {
  if (total <= 0) return done;
  return done + (current * (sent / total).clamp(0.0, 1.0)).round();
}
