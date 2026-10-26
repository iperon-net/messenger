part of 'repositories.dart';

/// «Данные и память» (миграция 51): счётчики трафика по сети и категории
/// (`networkUsage`) и настройки кэша — «Хранить медиа», предел размера, с
/// какого времени считается трафик (`dataUsageSettings`).
class DataUsageRepository {
  final Logger logger;
  final SqliteDatabase db;

  DataUsageRepository({required this.logger, required this.db});

  static const networkUsageSchema = '''
    CREATE TABLE networkUsage (
      network TEXT NOT NULL,
      category TEXT NOT NULL,
      sent INTEGER NOT NULL DEFAULT 0,
      received INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY (network, category)
    );
  ''';

  static const settingsSchema = '''
    CREATE TABLE dataUsageSettings (
      key TEXT PRIMARY KEY,
      value INTEGER NOT NULL
    );
  ''';

  /// Ключи [settingsSchema].
  static const keepMediaDaysKey = 'keepMediaDays';
  static const maxCacheMBKey = 'maxCacheMB';
  static const networkSinceKey = 'networkSince';

  Future<int?> setting(String key) async {
    final rows = await db.getAll('SELECT value FROM dataUsageSettings WHERE key = ?;', [key]);
    return rows.isEmpty ? null : rows.first['value'] as int;
  }

  Future<void> setSetting(String key, int value) async {
    await db.execute('INSERT INTO dataUsageSettings (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value;', [
      key,
      value,
    ]);
  }

  /// Прибавить накопленное [usage] к счётчикам; первая запись ставит начало
  /// отсчёта, если его ещё нет.
  Future<void> addTraffic(Map<(models.NetworkKind, models.TrafficCategory), models.TrafficCounter> usage) async {
    if (usage.isEmpty) return;
    await db.writeTransaction((tx) async {
      for (final MapEntry(key: (network, category), value: counter) in usage.entries) {
        await tx.execute(
          'INSERT INTO networkUsage (network, category, sent, received) VALUES (?, ?, ?, ?) '
          'ON CONFLICT(network, category) DO UPDATE SET sent = sent + excluded.sent, received = received + excluded.received;',
          [network.name, category.name, counter.sent, counter.received],
        );
      }
      await tx.execute('INSERT OR IGNORE INTO dataUsageSettings (key, value) VALUES (?, ?);', [
        networkSinceKey,
        DateTime.now().millisecondsSinceEpoch,
      ]);
    });
  }

  Future<Map<(models.NetworkKind, models.TrafficCategory), models.TrafficCounter>> traffic() async {
    final rows = await db.getAll('SELECT network, category, sent, received FROM networkUsage;');
    final result = <(models.NetworkKind, models.TrafficCategory), models.TrafficCounter>{};
    for (final row in rows) {
      final network = models.NetworkKind.values.asNameMap()[row['network'] as String];
      final category = models.TrafficCategory.values.asNameMap()[row['category'] as String];
      if (network == null || category == null) continue;
      result[(network, category)] = models.TrafficCounter(sent: row['sent'] as int, received: row['received'] as int);
    }
    return result;
  }

  /// «Сбросить статистику»: счётчики в ноль, отсчёт — с [now].
  Future<void> resetTraffic(DateTime now) async {
    await db.writeTransaction((tx) async {
      await tx.execute('DELETE FROM networkUsage;');
      await tx.execute('INSERT INTO dataUsageSettings (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value;', [
        networkSinceKey,
        now.millisecondsSinceEpoch,
      ]);
    });
  }
}
