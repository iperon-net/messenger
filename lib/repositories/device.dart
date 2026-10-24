part of 'repositories.dart';

/// Общая база устройства `device.db` (этап 2 мультиаккаунта,
/// docs/plans/multi-account.md): то, что не принадлежит аккаунту, —
/// настройки устройства (`settingsDevice`) и индекс аккаунтов (`accounts`).
/// Сессия с ключами остаётся в базе аккаунта (`sessions`, на неё ссылаются
/// внешние ключи и выборки «владельца»); `accounts` — слоты аккаунтов: папка
/// `accounts/<accountID>/` с базой и файлами, кто в нём вошёл и какой активен.
class DeviceDatabase {
  DeviceDatabase._();

  /// Схема и первая строка `settingsDevice` переносятся из базы аккаунта
  /// [account] как есть (тот же `CREATE TABLE`), дальше колонки добавляют
  /// миграции [migrations]; там же заводится `accounts` с активным слотом
  /// [accountID] (база [account] уже лежит в его папке) и пользователем его
  /// сессии, если она есть.
  static SqliteMigrations migrations({required SqliteDatabase account, required String accountID}) {
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
        await Accounts._insertSlot(
          tx,
          accountID: accountID,
          userID: active?['userID'] as List<int>? ?? const [],
          phoneNumber: active?['phoneNumber'] as String? ?? '',
          createdAt: active?['createdAt'] as int? ?? DateTime.now().millisecondsSinceEpoch,
        );
      }),
    );
  }

  /// `accountID` активного слота в уже существующей `device.db` [db] (до её
  /// миграций: таблицы может ещё не быть); null — слота нет.
  static Future<String?> activeAccountID(SqliteDatabase db) async {
    final table = await db.getOptional("SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'accounts';");
    if (table == null) return null;
    final row = await db.getOptional('SELECT accountID FROM accounts WHERE isActive = 1 LIMIT 1;');
    return row?['accountID'] as String?;
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

  /// Активный слот: `accountID`, `userID` (пусто — никто не вошёл) и номер;
  /// null — слота нет.
  Future<({String accountID, Uint8List userID, String phoneNumber})?> active() async {
    final row = await db.getOptional('SELECT accountID, userID, phoneNumber FROM accounts WHERE isActive = 1 LIMIT 1;');
    if (row == null) return null;
    return (
      accountID: row['accountID'] as String,
      userID: Uint8List.fromList(row['userID'] as List<int>),
      phoneNumber: row['phoneNumber'] as String,
    );
  }

  /// Слот [accountID] — активный (заводится, если его нет): на старте, когда
  /// папка аккаунта уже выбрана.
  Future<void> ensureActive(String accountID) async {
    await db.writeTransaction((tx) async {
      final existing = await tx.getOptional('SELECT accountID FROM accounts WHERE accountID = ?;', [accountID]);
      if (existing == null) {
        await _insertSlot(tx, accountID: accountID, userID: const [], phoneNumber: '', createdAt: DateTime.now().millisecondsSinceEpoch);
      }
      await tx.execute('UPDATE accounts SET isActive = (accountID = ?);', [accountID]);
    });
  }

  /// Вход [userID] в активный слот (аккаунт пока один — слот и папка те же,
  /// что до выхода).
  Future<void> activate({required List<int> userID, required String phoneNumber}) async {
    await db.execute('UPDATE accounts SET userID = ?, phoneNumber = ? WHERE isActive = 1;', [userID, phoneNumber]);
  }

  /// Выход из активного слота: пользователь снимается, слот и папка остаются
  /// (как и данные при выходе сейчас; удаление папки — с переключением
  /// аккаунтов, этап 3).
  Future<void> removeActive() async {
    await db.execute("UPDATE accounts SET userID = X'', phoneNumber = '' WHERE isActive = 1;");
  }

  static Future<void> _insertSlot(
    SqliteWriteContext tx, {
    required String accountID,
    required List<int> userID,
    required String phoneNumber,
    required int createdAt,
  }) async {
    await tx.execute('INSERT INTO accounts (accountID, userID, phoneNumber, isActive, sortOrder, createdAt) VALUES (?, ?, ?, 1, 0, ?);', [
      accountID,
      Uint8List.fromList(userID),
      phoneNumber,
      createdAt,
    ]);
  }

  /// Новый `accountID`: 16 случайных байт в hex.
  static String newAccountID() {
    final random = Random.secure();
    return List.generate(16, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  }
}
