part of 'repositories.dart';

/// Последние настройки приложения с сервера (`ClientConfig`, этап 5б
/// docs/plans/admin-panel.md) в `device.db`: по одному на сервер (хост:порт),
/// не на аккаунт. Нужны офлайн и на холодном старте до ответа сервера.
class ClientConfigCache {
  final SqliteDatabase db;

  ClientConfigCache({required this.db});

  static const schema = '''
    CREATE TABLE clientConfig (
      server TEXT PRIMARY KEY,
      data BLOB NOT NULL,
      updatedAt INTEGER NOT NULL
    );
  ''';

  Future<Uint8List?> get(String server) async {
    final row = await db.getOptional('SELECT data FROM clientConfig WHERE server = ?;', [server]);
    final data = row?['data'] as List<int>?;
    return data == null ? null : Uint8List.fromList(data);
  }

  Future<void> put(String server, Uint8List data) async {
    await db.execute('INSERT OR REPLACE INTO clientConfig (server, data, updatedAt) VALUES (?, ?, ?);', [
      server,
      data,
      DateTime.now().millisecondsSinceEpoch,
    ]);
  }
}
