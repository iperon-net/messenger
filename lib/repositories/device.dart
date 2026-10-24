part of 'repositories.dart';

/// Общая база устройства `device.db` (этап 2 мультиаккаунта,
/// docs/plans/multi-account.md): то, что не принадлежит аккаунту, —
/// настройки устройства (`settingsDevice`) и индекс аккаунтов (`accounts`).
/// Сессия с ключами остаётся в базе аккаунта (`sessions`, на неё ссылаются
/// внешние ключи и выборки «владельца»); `accounts` — только кто есть и кто
/// активен.
class DeviceDatabase {
  DeviceDatabase._();

  /// Схема и первая строка `settingsDevice` переносятся из базы аккаунта
  /// [account] как есть (тот же `CREATE TABLE`), дальше колонки добавляют
  /// миграции [migrations]; там же заводится `accounts` с активным аккаунтом
  /// [account], если в нём есть сессия.
  static SqliteMigrations migrations({required SqliteDatabase account}) {
    return SqliteMigrations()..add(
      SqliteMigration(1, (tx) async {
        final schema = await account.getOptional("SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'settingsDevice';");
        final createSettings = schema?['sql'] as String?;
        if (createSettings == null) throw StateError('device: settingsDevice is missing in the account database');
        await tx.execute(createSettings);
        final row = await account.getOptional('SELECT * FROM settingsDevice LIMIT 1;');
        if (row != null) {
          final columns = row.keys.toList();
          await tx.execute('INSERT INTO settingsDevice (${columns.join(', ')}) VALUES (${List.filled(columns.length, '?').join(', ')});', [
            for (final column in columns) row[column],
          ]);
        }

        await tx.execute(Accounts.schema);
        final active = await account.getOptional('''
          SELECT s.userID AS userID, u.phoneNumber AS phoneNumber, s.createAt AS createdAt
          FROM sessions s LEFT JOIN users u ON u.userID = s.userID
          WHERE s.isActive = 1 LIMIT 1;
        ''');
        if (active != null) {
          await Accounts._insertActive(
            tx,
            userID: active['userID'] as List<int>,
            phoneNumber: active['phoneNumber'] as String? ?? '',
            createdAt: active['createdAt'] as int,
          );
        }
      }),
    );
  }
}

/// Индекс аккаунтов устройства (`device.db`). `accountID` — случайный
/// локальный id: `userID` уникален только в пределах сервера.
class Accounts {
  final Logger logger;
  final SqliteDatabase db;

  Accounts({required this.logger, required this.db});

  static const schema = '''
    CREATE TABLE accounts (
      accountID TEXT PRIMARY KEY,
      userID BLOB NOT NULL,
      phoneNumber TEXT NOT NULL DEFAULT '',
      isActive INTEGER NOT NULL DEFAULT 0,
      sortOrder INTEGER NOT NULL DEFAULT 0,
      createdAt INTEGER NOT NULL
    );
  ''';

  /// Активный аккаунт: `accountID` и `userID`; null — никто не вошёл.
  Future<({String accountID, Uint8List userID, String phoneNumber})?> active() async {
    final row = await db.getOptional('SELECT accountID, userID, phoneNumber FROM accounts WHERE isActive = 1 LIMIT 1;');
    if (row == null) return null;
    return (
      accountID: row['accountID'] as String,
      userID: Uint8List.fromList(row['userID'] as List<int>),
      phoneNumber: row['phoneNumber'] as String,
    );
  }

  /// Вход [userID]: он становится единственным активным (аккаунт пока один —
  /// прежний активный уходит из индекса, как его сессия из `sessions`).
  Future<void> activate({required List<int> userID, required String phoneNumber}) async {
    await db.writeTransaction((tx) async {
      await tx.execute('DELETE FROM accounts WHERE isActive = 1 AND userID != ?;', [userID]);
      final existing = await tx.getOptional('SELECT accountID FROM accounts WHERE userID = ?;', [userID]);
      if (existing != null) {
        await tx.execute('UPDATE accounts SET isActive = 1, phoneNumber = ? WHERE accountID = ?;', [phoneNumber, existing['accountID']]);
        return;
      }
      await _insertActive(tx, userID: userID, phoneNumber: phoneNumber, createdAt: DateTime.now().millisecondsSinceEpoch);
    });
  }

  /// Выход активного аккаунта.
  Future<void> removeActive() async {
    await db.execute('DELETE FROM accounts WHERE isActive = 1;');
  }

  static Future<void> _insertActive(
    SqliteWriteContext tx, {
    required List<int> userID,
    required String phoneNumber,
    required int createdAt,
  }) async {
    await tx.execute('INSERT INTO accounts (accountID, userID, phoneNumber, isActive, sortOrder, createdAt) VALUES (?, ?, ?, 1, 0, ?);', [
      _newAccountID(),
      userID,
      phoneNumber,
      createdAt,
    ]);
  }

  static String _newAccountID() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }
}
