part of 'repositories.dart';

/// Где лежат файлы аккаунта (этап 2 мультиаккаунта,
/// docs/plans/multi-account.md): база и неотправленное — в
/// `<support>/accounts/<accountID>/`, кэш скачанного — в
/// `<cache>/accounts/<accountID>/media/`.
class AccountFiles {
  /// `<support>/accounts/<accountID>`.
  final Directory dataDir;

  /// `<cache>/accounts/<accountID>`.
  final Directory cacheDir;

  AccountFiles({required String supportDir, required String cacheRoot, required String accountID})
    : dataDir = Directory(p.join(supportDir, accountsDirName, accountID)),
      cacheDir = Directory(p.join(cacheRoot, accountsDirName, accountID));

  static const accountsDirName = 'accounts';

  /// Каталоги внутри [dataDir], которые раньше лежали прямо в `<support>`.
  static const dataDirs = ['chat_outbox', 'secret_media'];

  /// Каталог кэша скачанного внутри [cacheDir] (раньше — `<cache>/media`).
  static const mediaDirName = 'media';

  String databasePath(String name) => p.join(dataDir.path, name);

  Directory get mediaDir => Directory(p.join(cacheDir.path, mediaDirName));
}

/// Перенос файлов из прежних общих мест в папку аккаунта — один раз, при
/// первом запуске сборки с папками аккаунтов.
class AccountFilesMigration {
  AccountFilesMigration._();

  /// Сколько ждать чужой перенос (второй isolate — FCM, ответ из шторки) и
  /// когда считать замок брошенным (процесс убит посреди переноса).
  static const _lockWait = Duration(seconds: 30);
  static const _staleLock = Duration(minutes: 2);

  /// Переносит базу [databaseName] (с `-wal` / `-shm`), каталоги
  /// [AccountFiles.dataDirs] и кэш `media` в [files]. Ничего не перезаписывает:
  /// уже перенесённое пропускается. Возвращает пары «старый → новый» путь
  /// перенесённых каталогов — для правки абсолютных путей в базе
  /// ([rewritePaths]).
  static Future<Map<String, String>> run({
    required String supportDir,
    required String cacheRoot,
    required String databaseName,
    required AccountFiles files,
    required Logger logger,
  }) async {
    final legacyDatabase = File(p.join(supportDir, databaseName));
    final legacyMedia = Directory(p.join(cacheRoot, AccountFiles.mediaDirName));
    final hasLegacy =
        [
          for (final suffix in ['', '-wal', '-shm']) await File('${legacyDatabase.path}$suffix').exists(),
        ].any((e) => e) ||
        await legacyMedia.exists() ||
        [for (final name in AccountFiles.dataDirs) await Directory(p.join(supportDir, name)).exists()].any((e) => e);
    if (!hasLegacy) return const {};

    await files.dataDir.create(recursive: true);
    await files.cacheDir.create(recursive: true);
    final lock = File(p.join(supportDir, AccountFiles.accountsDirName, '.migrating'));
    if (!await _acquire(lock, logger)) return const {};
    final moved = <String, String>{};
    try {
      // База — до её открытия кем-либо: вместе с журналом, иначе
      // незафиксированное в -wal потеряется.
      for (final suffix in ['', '-wal', '-shm']) {
        await _move(File('${legacyDatabase.path}$suffix'), File(files.databasePath(databaseName) + suffix), logger);
      }
      for (final name in AccountFiles.dataDirs) {
        final from = p.join(supportDir, name);
        final to = p.join(files.dataDir.path, name);
        if (await _moveDir(Directory(from), Directory(to), logger)) moved[from] = to;
      }
      if (await _moveDir(legacyMedia, files.mediaDir, logger)) moved[legacyMedia.path] = files.mediaDir.path;
      logger.info('account files: moved to ${files.dataDir.path}');
    } finally {
      try {
        await lock.delete();
      } catch (_) {}
    }

    return moved;
  }

  /// Абсолютные пути в базе под перенесёнными каталогами [moved] — только
  /// незаконченные загрузки (`uploads.filePath`): остальное хранит имена
  /// файлов или пересчитывает путь само.
  static Future<void> rewritePaths(SqliteDatabase db, Map<String, String> moved) async {
    for (final MapEntry(key: from, value: to) in moved.entries) {
      final prefix = '$from${p.separator}';
      await db.execute('UPDATE uploads SET filePath = ? || substr(filePath, ?) WHERE substr(filePath, 1, ?) = ?;', [
        '$to${p.separator}',
        prefix.length + 1,
        prefix.length,
        prefix,
      ]);
    }
  }

  static Future<bool> _acquire(File lock, Logger logger) async {
    final deadline = DateTime.now().add(_lockWait);
    while (true) {
      try {
        await lock.create(recursive: true, exclusive: true);
        return true;
      } on FileSystemException {
        final modified = await lock.lastModified().catchError((_) => DateTime.now());
        if (DateTime.now().difference(modified) > _staleLock) {
          logger.warning('account files: stale migration lock — taking over');
          await lock.delete().catchError((_) => lock);
          continue;
        }
        if (DateTime.now().isAfter(deadline)) {
          logger.warning('account files: migration lock is busy — skipped');
          return false;
        }
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  static Future<void> _move(File from, File to, Logger logger) async {
    if (!await from.exists() || await to.exists()) return;
    try {
      await from.rename(to.path);
    } on FileSystemException catch (error) {
      logger.error('account files: move ${from.path} failed: $error');
    }
  }

  static Future<bool> _moveDir(Directory from, Directory to, Logger logger) async {
    if (!await from.exists() || await to.exists()) return false;
    try {
      await from.rename(to.path);
      return true;
    } on FileSystemException catch (error) {
      logger.error('account files: move ${from.path} failed: $error');
      return false;
    }
  }
}
