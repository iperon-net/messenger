part of 'repositories.dart';

/// Общее для всех аккаунтов: `device.db` (настройки устройства, слоты
/// аккаунтов), пароли баз в secure storage и перенос прежних общих файлов.
/// Живёт всё время работы приложения; база аккаунта — [Repositories], в
/// scope своего аккаунта.
class DeviceRepositories {
  final logger = getIt.get<Logger>();
  final settings = getIt.get<Settings>();

  late final String supportDir;
  late final String cacheRoot;
  late final SqliteDatabase db;
  late final SettingsDevice settingsDevice;
  late final Accounts accounts;

  /// `accountID` активного слота на старте.
  late final String activeAccountID;

  // Secure storage. iOS: accessibility = afterFirstUnlockThisDeviceOnly (не
  // дефолтный whenUnlocked) — иначе на cold-start от VoIP-push (входящий звонок
  // на залоченном/только что разбуженном экране) Keychain-элемент с паролем БД
  // недоступен, и `storage.read` ВИСНЕТ → `Repositories` не готов → `allReady()`
  // не завершается → `main` не доходит до `runApp` (белый экран) и `CallPush`
  // не стартует (входящий не поднимается, нет звука). afterFirstUnlock даёт
  // доступ в фоне после первой разблокировки с момента загрузки — стандарт для
  // VoIP/фоновых приложений. Вариант ThisDeviceOnly: пароль локальной БД не
  // переносится в бэкап/на другое устройство (ему это и не нужно) — чуть строже
  // по безопасности.
  final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );

  /// Пароль `device.db` (null — debug, без шифрования).
  String? _password;

  /// Перенесённые при старте каталоги аккаунта (старый → новый путь): их
  /// абсолютные пути в базе аккаунта поправит [Repositories].
  final _movedFiles = <String, Map<String, String>>{};

  DeviceRepositories._();

  static Future<DeviceRepositories> initialization() async {
    final device = DeviceRepositories._();
    await device._initialization();
    return device;
  }

  Future<void> _initialization() async {
    supportDir = (await getApplicationSupportDirectory()).path;
    cacheRoot = (await getApplicationCacheDirectory()).path;
    final legacyDatabasePath = p.join(supportDir, settings.databaseName);
    final deviceDatabasePath = p.join(supportDir, 'device.db');

    if (settings.isDeleteDatabase) {
      logger.warning("Deleting the database, flag set IS_DELETE_DATABASE: 1");
      try {
        for (final path in [legacyDatabasePath, deviceDatabasePath]) {
          for (final file in [path, "$path-wal", "$path-shm"]) {
            if (await File(file).exists()) await File(file).delete();
          }
        }
        for (final root in [supportDir, cacheRoot]) {
          final accountsDir = Directory(p.join(root, AccountFiles.accountsDirName));
          if (await accountsDir.exists()) await accountsDir.delete(recursive: true);
        }
        logger.info("the database has been successfully deleted");
      } catch (e) {
        logger.error("error delete database $e");
      }
      for (final key in (await _storage.readAll()).keys) {
        if (key == "databasePassword" || key.startsWith("databasePassword:")) await _storage.delete(key: key);
      }
    }

    if (!kDebugMode) {
      _password = await _storage.read(key: "databasePassword");
      if (_password == null) {
        _password = _generatePassword();
        logger.logCustom(RepositoriesLog("A new password has been set for the database"));
      }
      // Перезапись — заодно миграция класса доступности: пароль, записанный
      // старым дефолтом (whenUnlocked), недоступен на cold-start от VoIP-push.
      // Идемпотентно; выполняется на обычном запуске, где read уже успешен.
      await _storage.write(key: 'databasePassword', value: _password);
    }
    db = SqliteDatabase.withFactory(_AppSqliteOpenFactory(path: deviceDatabasePath, password: _password));

    // Папка активного аккаунта: слот из device.db, иначе новый. Прежние общие
    // файлы (iperon.db, outbox, кэш) переезжают в неё один раз.
    final slot = await _startSlot() ?? Accounts.newAccountID();
    _movedFiles[slot] = await AccountFilesMigration.run(
      supportDir: supportDir,
      cacheRoot: cacheRoot,
      databaseName: settings.databaseName,
      files: AccountFiles(supportDir: supportDir, cacheRoot: cacheRoot, accountID: slot),
      logger: logger,
    );

    // Первый запуск с device.db: её первая миграция берёт settingsDevice и
    // активный аккаунт из базы аккаунта — открываем её на время миграции (с её
    // собственными миграциями: схема settingsDevice должна быть свежей).
    final bootstrap = await db.getOptional("SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'settingsDevice';") == null;
    SqliteDatabase? account;
    if (bootstrap) {
      final files = AccountFiles(supportDir: supportDir, cacheRoot: cacheRoot, accountID: slot);
      await files.dataDir.create(recursive: true);
      var path = files.databasePath(settings.databaseName);
      if (!await File(path).exists() && await File(legacyDatabasePath).exists()) path = legacyDatabasePath;
      account = await openAccountDatabase(slot, path);
      await Repositories.accountMigrations().migrate(account);
    }
    try {
      await DeviceDatabase.migrations(account: account, accountID: slot).migrate(db);
    } finally {
      await account?.close();
    }

    settingsDevice = SettingsDevice(logger: logger, db: db);
    accounts = Accounts(logger: logger, db: db);
    await accounts.ensureActive(slot);
    activeAccountID = slot;
    final abandoned = _abandonedSlot;
    if (abandoned != null && abandoned != slot) await removeAccount(abandoned);
  }

  /// Слот, с которого стартуем: активный; но если в нём никто не вошёл
  /// (вышли или бросили «добавить аккаунт»), а в другом слоте вход есть —
  /// тот (как в Telegram после выхода из одного из аккаунтов).
  Future<String?> _startSlot() async {
    final active = await DeviceDatabase.activeAccountID(db);
    if (active == null) return null;
    final signedIn = await db.getOptional("SELECT accountID FROM accounts WHERE accountID = ? AND length(userID) > 0;", [active]);
    if (signedIn != null) return active;
    final other = await db.getOptional("SELECT accountID FROM accounts WHERE length(userID) > 0 ORDER BY sortOrder, createdAt LIMIT 1;");
    final fallback = other?['accountID'] as String?;
    if (fallback == null) return active;
    _abandonedSlot = active;
    return fallback;
  }

  /// Пустой слот, с которого ушли на старте ([_startSlot]) — удаляется.
  String? _abandonedSlot;

  /// Удалить аккаунт [accountID] с устройства: слот, папку с базой и файлами,
  /// кэш, пароль базы. Не активный (его scope должен быть закрыт).
  Future<void> removeAccount(String accountID) async {
    await accounts.remove(accountID);
    final files = AccountFiles(supportDir: supportDir, cacheRoot: cacheRoot, accountID: accountID);
    for (final dir in [files.dataDir, files.cacheDir]) {
      try {
        if (await dir.exists()) await dir.delete(recursive: true);
      } catch (error, stackTrace) {
        logger.handle(error, stackTrace);
      }
    }
    await _storage.delete(key: 'databasePassword:$accountID');
    logger.info('account: removed $accountID');
  }

  /// Открыть базу аккаунта [accountID] по [path]. Пароль — свой у аккаунта
  /// (`databasePassword:<accountID>`); для уже существующей базы (перенесённой
  /// из общей) — прежний общий.
  Future<SqliteDatabase> openAccountDatabase(String accountID, String path) async {
    String? password;
    if (_password != null) {
      final key = 'databasePassword:$accountID';
      password = await _storage.read(key: key);
      if (password == null) {
        password = await File(path).exists() ? _password : _generatePassword();
        await _storage.write(key: key, value: password);
      }
    }

    return SqliteDatabase.withFactory(_AppSqliteOpenFactory(path: path, password: password));
  }

  /// Перенесённые каталоги аккаунта (один раз).
  Map<String, String> takeMovedFiles(String accountID) => _movedFiles.remove(accountID) ?? const {};

  static String _generatePassword() {
    final random = Random.secure();
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final length = 60 + random.nextInt(40);

    return List.generate(length, (_) => characters[random.nextInt(characters.length)]).join();
  }
}

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
  static SqliteMigrations migrations({required SqliteDatabase? account, required String accountID}) {
    return SqliteMigrations()
      ..add(
        SqliteMigration(1, (tx) async {
          if (account == null) throw StateError('device: the first migration needs the account database');
          final schema = await account.getOptional("SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'settingsDevice';");
          final createSettings = schema?['sql'] as String?;
          if (createSettings == null) throw StateError('device: settingsDevice is missing in the account database');
          await tx.execute(createSettings);
          final row = await account.getOptional('SELECT * FROM settingsDevice LIMIT 1;');
          if (row != null) {
            final columns = row.keys.toList();
            await tx.execute(
              'INSERT INTO settingsDevice (${columns.join(', ')}) VALUES (${List.filled(columns.length, '?').join(', ')});',
              [for (final column in columns) row[column]],
            );
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
      )
      ..add(
        SqliteMigration(2, (tx) async {
          // Подписи слотов для списка аккаунтов (этап 3.2): имя и аватар
          // аккаунта — его база закрыта, пока он не активный.
          await tx.execute("ALTER TABLE accounts ADD COLUMN name TEXT NOT NULL DEFAULT '';");
          await tx.execute("ALTER TABLE accounts ADD COLUMN avatarPath TEXT NOT NULL DEFAULT '';");
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

/// Слот аккаунта из `device.db`: [userID] пуст — в нём никто не вошёл.
typedef AccountSlot = ({String accountID, Uint8List userID, String phoneNumber, String name, String avatarPath, bool active});

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

  /// Все слоты по порядку.
  Future<List<AccountSlot>> all() async {
    final rows = await db.getAll(
      'SELECT accountID, userID, phoneNumber, name, avatarPath, isActive FROM accounts ORDER BY sortOrder, createdAt;',
    );
    return [
      for (final row in rows)
        (
          accountID: row['accountID'] as String,
          userID: Uint8List.fromList(row['userID'] as List<int>),
          phoneNumber: row['phoneNumber'] as String,
          name: row['name'] as String,
          avatarPath: row['avatarPath'] as String,
          active: row['isActive'] == 1,
        ),
    ];
  }

  /// Изменения слотов (вход, выход, имя, аватар) — для списка аккаунтов.
  Stream<void> changes() => db.onChange(['accounts'], triggerImmediately: false);

  /// Имя и аватар аккаунта [accountID] для списка (пишет активный аккаунт
  /// из своего профиля).
  Future<void> setProfile({required String accountID, required String name, required String avatarPath}) async {
    await db.execute('UPDATE accounts SET name = ?, avatarPath = ? WHERE accountID = ? AND (name != ? OR avatarPath != ?);', [
      name,
      avatarPath,
      accountID,
      name,
      avatarPath,
    ]);
  }

  /// Удалить слот [accountID] из индекса (папку удаляет
  /// [DeviceRepositories.removeAccount]).
  Future<void> remove(String accountID) async {
    await db.execute('DELETE FROM accounts WHERE accountID = ?;', [accountID]);
  }

  /// Новый пустой слот (не активный); его папку заведёт первое открытие.
  Future<String> createSlot() async {
    final accountID = newAccountID();
    await db.writeTransaction((tx) async {
      final next = await tx.get('SELECT COALESCE(MAX(sortOrder), -1) + 1 AS n FROM accounts;');
      await tx.execute('INSERT INTO accounts (accountID, userID, phoneNumber, isActive, sortOrder, createdAt) VALUES (?, ?, ?, 0, ?, ?);', [
        accountID,
        Uint8List(0),
        '',
        next['n'],
        DateTime.now().millisecondsSinceEpoch,
      ]);
    });
    return accountID;
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
