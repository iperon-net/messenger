part of 'repositories.dart';

/// Последний проверенный bootstrap-файл (`config.json`, адреса серверов по
/// окружениям — lib/bootstrap/bootstrap_config.dart) в `device.db`: одна строка.
/// Текст как есть — на старте подпись проверяется заново.
class BootstrapConfigCache {
  final SqliteDatabase db;

  BootstrapConfigCache({required this.db});

  static const schema = '''
    CREATE TABLE bootstrapConfig (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      data TEXT NOT NULL,
      serial INTEGER NOT NULL,
      updatedAt INTEGER NOT NULL
    );
  ''';

  Future<String?> get() async {
    final row = await db.getOptional('SELECT data FROM bootstrapConfig WHERE id = 1;');
    return row?['data'] as String?;
  }

  Future<void> put(String data, int serial) async {
    await db.execute('INSERT OR REPLACE INTO bootstrapConfig (id, data, serial, updatedAt) VALUES (1, ?, ?, ?);', [
      data,
      serial,
      DateTime.now().millisecondsSinceEpoch,
    ]);
  }
}
