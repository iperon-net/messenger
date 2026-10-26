import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'account_scope.dart';
import 'chats/chats_mapping.dart' show idHex;
import 'chats/chats_remote_data_source.dart';
import 'chats/secret/secret_chats_list.dart' show secretChatListID;
import 'chats/secret/secret_chats_media.dart';
import 'di.dart';
import 'logger.dart';
import 'models.dart' as models;
import 'network_usage.dart' show storageCategoryFor;
import 'repositories.dart';
import 'settings.dart';

/// «Использование памяти» (как в Telegram): сколько занимает кэш скачанного
/// по типам и чатам, очистка, автоочистка «Хранить медиа» и предел размера
/// кэша. Файлы чатов остаются на сервере — очищенное скачается снова, когда
/// понадобится (открытый чат докачивает вложения сам).
///
/// Не очищаются: фото профилей (строка `downloads` — внешний ключ профиля с
/// каскадом: удаление стёрло бы профиль), идущие скачивания ([CDNManager.evict]
/// их пропускает), база и неотправленное.
class StorageUsage implements AccountService {
  final AccountScope _scope = AccountScope.current;

  StorageUsage._();

  static StorageUsage get instance => AccountScope.current.resolve(StorageUsage._);

  Logger get _logger => getIt.get<Logger>();
  Repositories get _repositories => _scope.repositories;

  /// Варианты «Хранить медиа» (дней; 0 — всегда).
  static const keepMediaOptions = [3, 7, 30, 0];

  /// Варианты предела кэша (МБ; 0 — без ограничений).
  static const maxCacheOptions = [1024, 5 * 1024, 20 * 1024, 50 * 1024, 0];

  /// Автоочистка: первый проход после запуска (не мешать старту) и дальше.
  static const _autoCleanDelay = Duration(minutes: 1);
  static const _autoCleanInterval = Duration(hours: 12);

  Timer? _autoClean;
  Future<void>? _running;

  /// Временные каталоги приложения (в `getTemporaryDirectory`), которые можно
  /// чистить: подготовленное к отправке, экспорт, вставка, выбранные файлы.
  static const _tempDirs = ['chat_media', 'video_edit', 'media_export', 'media_paste', 'picked_files'];

  /// Временные файлы моложе этого не удаляем — их, может быть, как раз
  /// отправляют или показывают.
  static const _tempMinAge = Duration(hours: 1);

  Future<int> keepMediaDays() async => await _repositories.dataUsage.setting(DataUsageRepository.keepMediaDaysKey) ?? 0;

  Future<int> maxCacheMB() async => await _repositories.dataUsage.setting(DataUsageRepository.maxCacheMBKey) ?? 0;

  Future<void> setKeepMediaDays(int days) async {
    await _repositories.dataUsage.setSetting(DataUsageRepository.keepMediaDaysKey, days);
    unawaited(autoClean());
  }

  Future<void> setMaxCacheMB(int mb) async {
    await _repositories.dataUsage.setSetting(DataUsageRepository.maxCacheMBKey, mb);
    unawaited(autoClean());
  }

  /// Завести автоочистку (после входа в аккаунт).
  void start() {
    _autoClean ??= Timer(_autoCleanDelay, () {
      unawaited(autoClean());
      _autoClean = Timer.periodic(_autoCleanInterval, (_) => unawaited(autoClean()));
    });
  }

  // --- подсчёт ---------------------------------------------------------------

  /// Что сейчас лежит на устройстве.
  Future<models.StorageReport> scan() async {
    final files = await _files();
    final byCategory = <models.StorageCategory, int>{};
    final byChat = <String, Map<models.StorageCategory, int>>{};
    var protectedBytes = 0;
    for (final file in files) {
      byCategory[file.category] = (byCategory[file.category] ?? 0) + file.size;
      if (file.protected) protectedBytes += file.size;
      if (file.row.hasChat && !file.protected) {
        final chat = byChat[file.row.chatID] ??= {};
        chat[file.category] = (chat[file.category] ?? 0) + file.size;
      }
    }
    final chats = [for (final MapEntry(:key, :value) in byChat.entries) models.StorageChatUsage(chatID: key, byCategory: value)]
      ..removeWhere((chat) => chat.bytes == 0)
      ..sort((a, b) => b.bytes.compareTo(a.bytes));
    return models.StorageReport(
      byCategory: byCategory,
      protectedBytes: protectedBytes,
      database: await _databaseSize(),
      emoji: await _dirSize(await _emojiDir()),
      temp: await _tempSize(),
      chats: chats,
    );
  }

  /// Файлы кэша с размером на диске, типом и защитой от очистки. Сначала
  /// привязывает к чатам файлы, скачанные до миграции 51.
  Future<List<_StoredFile>> _files() async {
    var rows = await _repositories.downloads.stored();
    if (rows.any((row) => row.chatID.isEmpty)) {
      await _backfillChats(rows.where((row) => row.chatID.isEmpty).toList());
      rows = await _repositories.downloads.stored();
    }
    final avatars = await _protectedAvatars(rows);
    final mediaDir = (await _scope.cacheSubdir('media')).path;
    final result = <_StoredFile>[];
    for (final row in rows) {
      var size = 0;
      // Пути в базе абсолютные, а контейнер iOS при обновлении переезжает —
      // смотрим в текущий каталог media (как CDNManager._downloadState).
      final target = row.targetPath;
      if (target != null && target.isNotEmpty) size += await _fileSize(p.join(mediaDir, p.basename(target)));
      if (row.tmpPath.isNotEmpty) size += await _fileSize(p.join(mediaDir, '.part', p.basename(row.tmpPath)));
      final protected = avatars.contains(idHex(row.cdnID));
      result.add(
        _StoredFile(
          row: row,
          size: size,
          // Защищённые — всегда «Аватарки и прочее»: очистка их не тронет.
          category: row.hasChat && !protected ? storageCategoryFor(row.contentType) : models.StorageCategory.other,
          protected: protected,
        ),
      );
    }
    return result;
  }

  /// Фото профилей (внешний ключ на `downloads`) и групп (их cdnID — в
  /// ChatInfo группы): hex cdnID.
  Future<Set<String>> _protectedAvatars(List<StoredDownload> rows) async {
    final db = _repositories.db;
    final found = <String>{};
    for (final table in ['profiles', 'myProfile']) {
      for (final row in await db.getAll('SELECT avatarCdnID AS id FROM $table WHERE avatarCdnID IS NOT NULL;')) {
        found.add(idHex(row['id'] as List<int>));
      }
    }
    // Фото групп в кэше не защищены ключом, но список чатов не перекачает
    // их до перезапуска — тоже не трогаем. Кандидаты — файлы не из сообщений.
    final candidates = [
      for (final row in rows)
        if (!row.hasChat) row.cdnID,
    ];
    if (candidates.isEmpty) return found;
    final infos = [for (final row in await db.getAll('SELECT info FROM chatGroups;')) row['info'] as List<int>];
    for (final id in candidates) {
      if (infos.any((info) => _contains(info, id))) found.add(idHex(id));
    }
    return found;
  }

  /// Чат файлов, скачанных до миграции 51: ищем их cdnID в сообщениях (как
  /// `ChatsMediaCleanup`); не нашёлся — '~' (не из сообщений, больше не ищем).
  Future<void> _backfillChats(List<StoredDownload> rows) async {
    final db = _repositories.db;
    const chunk = 50;
    final chats = <Uint8List, String>{};
    for (var start = 0; start < rows.length; start += chunk) {
      final ids = [for (final row in rows.skip(start).take(chunk)) row.cdnID];
      final match = List.filled(ids.length, 'instr(c, ?) > 0').join(' OR ');
      final sources = [
        ('SELECT chatID AS chat, c FROM (SELECT chatID, content AS c FROM chatMessages) WHERE $match;', false),
        ('SELECT chatID AS chat, c FROM (SELECT chatID, content AS c FROM chatOutbox WHERE chatID IS NOT NULL) WHERE $match;', false),
        (
          'SELECT secretChatID AS chat, c FROM (SELECT secretChatID, media AS c FROM secretMessages WHERE media IS NOT NULL) WHERE $match;',
          true,
        ),
      ];
      final found = <String, String>{};
      for (final (sql, secret) in sources) {
        try {
          for (final row in await db.getAll(sql, ids)) {
            final blob = row['c'] as List<int>;
            final chat = row['chat'] as List<int>;
            for (final id in ids) {
              final hex = idHex(id);
              if (found.containsKey(hex) || !_contains(blob, id)) continue;
              found[hex] = secret ? secretChatListID(chat) : idHex(chat);
            }
          }
        } catch (error, stackTrace) {
          _logger.handle(error, stackTrace);
        }
      }
      for (final id in ids) {
        chats[id] = found[idHex(id)] ?? '~';
      }
    }
    await _repositories.downloads.setChatIDs(chats);
  }

  Future<int> _databaseSize() async {
    final files = _repositories.accountFiles;
    var size = 0;
    final database = files.databasePath(getIt.get<Settings>().databaseName);
    for (final suffix in ['', '-wal', '-shm']) {
      size += await _fileSize('$database$suffix');
    }
    for (final name in AccountFiles.dataDirs) {
      size += await _dirSize(Directory(p.join(files.dataDir.path, name)));
    }
    return size;
  }

  Future<Directory> _emojiDir() async => Directory(p.join((await getApplicationSupportDirectory()).path, 'emoji', 'noto'));

  Future<int> _tempSize() async {
    final root = (await getTemporaryDirectory()).path;
    var size = 0;
    for (final name in _tempDirs) {
      size += await _dirSize(Directory(p.join(root, name)));
    }
    return size;
  }

  // --- очистка ---------------------------------------------------------------

  /// Удалить с устройства файлы [categories] — всех чатов или только
  /// [chatIDs]. Возвращает освобождённые байты.
  Future<int> clear({required Set<models.StorageCategory> categories, Set<String>? chatIDs}) {
    return _serial(() async {
      final files = [
        for (final file in await _files())
          if (!file.protected && categories.contains(file.category) && (chatIDs == null || chatIDs.contains(file.row.chatID))) file,
      ];
      return _evict(files);
    });
  }

  /// Анимированные эмодзи: скачаются снова при показе.
  Future<int> clearEmoji() => _serial(() async {
    final dir = await _emojiDir();
    final size = await _dirSize(dir);
    try {
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
    }
    return size;
  });

  /// Временные файлы старше [_tempMinAge].
  Future<int> clearTemp() => _serial(() async {
    final root = (await getTemporaryDirectory()).path;
    final cutoff = DateTime.now().subtract(_tempMinAge);
    var freed = 0;
    for (final name in _tempDirs) {
      final dir = Directory(p.join(root, name));
      if (!await dir.exists()) continue;
      try {
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is! File) continue;
          final stat = await entity.stat();
          if (stat.modified.isAfter(cutoff)) continue;
          await entity.delete();
          freed += stat.size;
        }
      } catch (error, stackTrace) {
        _logger.handle(error, stackTrace);
      }
    }
    return freed;
  });

  /// Автоочистка: файлы, которые не открывали дольше «Хранить медиа», и
  /// самые давние сверх предела размера кэша.
  Future<void> autoClean() => _serial(() async {
    try {
      final days = await keepMediaDays();
      final maxMB = await maxCacheMB();
      if (days == 0 && maxMB == 0) return 0;
      final files = [
        for (final file in await _files())
          if (!file.protected && file.row.ready) file,
      ]..sort((a, b) => a.row.accessedAt.compareTo(b.row.accessedAt));
      final evict = <_StoredFile>[];
      if (days > 0) {
        final cutoff = DateTime.now().subtract(Duration(days: days));
        evict.addAll(files.where((file) => file.row.accessedAt.isBefore(cutoff)));
      }
      if (maxMB > 0) {
        final limit = maxMB * 1024 * 1024;
        var total = files.fold(0, (sum, file) => sum + file.size) - evict.fold(0, (sum, file) => sum + file.size);
        for (final file in files) {
          if (total <= limit) break;
          if (evict.contains(file)) continue;
          evict.add(file);
          total -= file.size;
        }
      }
      if (evict.isEmpty) return 0;
      final freed = await _evict(evict);
      _logger.debug('storage: auto-clean freed $freed bytes (${evict.length} files)');
      return freed;
    } catch (error, stackTrace) {
      _logger.handle(error, stackTrace);
      return 0;
    }
  });

  /// Удалить файлы из кэша и забыть их пути у источников чатов (иначе открытые
  /// окна показывали бы пустые картинки до перезапуска).
  Future<int> _evict(List<_StoredFile> files) async {
    var freed = 0;
    final keys = <String>{};
    final chats = <String>{};
    for (final file in files) {
      if (!await _scope.cdn.evict(file.row.cdnID)) continue;
      freed += file.size;
      keys.add(idHex(file.row.cdnID));
      if (file.row.hasChat) chats.add(file.row.chatID);
    }
    if (keys.isNotEmpty) {
      ChatsRemoteDataSource.instance.forgetMedia(keys, chats);
      SecretChatsMedia.instance.forgetAll(keys);
    }
    return freed;
  }

  /// Очистки и автоочистка — по одной (две параллельные удаляли бы одно и то же
  /// и считали бы освобождённое дважды).
  Future<int> _serial(Future<int> Function() run) {
    final previous = _running ?? Future<void>.value();
    final next = previous.then((_) => run());
    _running = next.then((_) {}, onError: (_) {});
    return next;
  }

  // --- файлы -----------------------------------------------------------------

  static Future<int> _fileSize(String path) async {
    try {
      final stat = await File(path).stat();
      return stat.type == FileSystemEntityType.file ? stat.size : 0;
    } catch (_) {
      return 0;
    }
  }

  static Future<int> _dirSize(Directory dir) async {
    var size = 0;
    try {
      if (!await dir.exists()) return 0;
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) size += await entity.length();
      }
    } catch (_) {
      // Файл исчез во время обхода — неважно для подсчёта.
    }
    return size;
  }

  static bool _contains(List<int> blob, List<int> needle) {
    outer:
    for (var i = 0; i + needle.length <= blob.length; i++) {
      for (var j = 0; j < needle.length; j++) {
        if (blob[i + j] != needle[j]) continue outer;
      }
      return true;
    }
    return false;
  }

  @override
  Future<void> dispose() async {
    _autoClean?.cancel();
    _autoClean = null;
  }
}

class _StoredFile {
  final StoredDownload row;
  final int size;
  final models.StorageCategory category;
  final bool protected;

  const _StoredFile({required this.row, required this.size, required this.category, required this.protected});
}
