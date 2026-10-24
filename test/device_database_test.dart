import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:sqlite_async/sqlite_async.dart';

// device.db: перенос settingsDevice и активного аккаунта из базы аккаунта,
// индекс accounts при входе и выходе.
void main() {
  late Directory dir;
  late SqliteDatabase account;
  late SqliteDatabase device;

  final user = List<int>.filled(12, 7);

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('device_db');
    account = SqliteDatabase(path: '${dir.path}/iperon.db');
    device = SqliteDatabase(path: '${dir.path}/device.db');
    // Как в базе аккаунта до device.db (урезано до нужного).
    await account.execute('''
      CREATE TABLE settingsDevice (
        locale TEXT NULL,
        darkMode TEXT NOT NULL,
        passcode BLOB NULL,
        quickReaction TEXT NOT NULL DEFAULT '❤️'
      );
    ''');
    await account.execute("INSERT INTO settingsDevice (locale, darkMode, passcode, quickReaction) VALUES ('ru', 'dark', x'0102', '🔥');");
    await account.execute('CREATE TABLE users (userID TEXT PRIMARY KEY, phoneNumber TEXT NOT NULL);');
    await account.execute('''
      CREATE TABLE sessions (
        sessionID BLOB NOT NULL, session BLOB NOT NULL, userID BLOB NOT NULL,
        sharedKey BLOB NOT NULL, salt BLOB NOT NULL, isActive INTEGER NOT NULL DEFAULT 0, createAt INTEGER NOT NULL
      );
    ''');
  });

  tearDown(() async {
    await account.close();
    await device.close();
    await dir.delete(recursive: true);
  });

  const slot = '00112233445566778899aabbccddeeff';
  Future<void> migrate() => DeviceDatabase.migrations(account: account, accountID: slot).migrate(device);

  test('settingsDevice переносится со схемой и значениями', () async {
    await migrate();
    final row = await device.get('SELECT * FROM settingsDevice;');
    expect(row['locale'], 'ru');
    expect(row['darkMode'], 'dark');
    expect(row['passcode'], [1, 2]);
    expect(row['quickReaction'], '🔥');
    // Схема та же — с умолчаниями.
    await device.execute("INSERT INTO settingsDevice (darkMode) VALUES ('light');");
    expect((await device.get("SELECT quickReaction FROM settingsDevice WHERE darkMode = 'light';"))['quickReaction'], '❤️');
  });

  test('без сессии — слот без пользователя', () async {
    await migrate();
    final active = await Accounts(logger: Logger(), db: device).active();
    expect(active?.accountID, slot);
    expect(active?.userID, isEmpty);
  });

  test('активная сессия становится активным аккаунтом', () async {
    await account.execute("INSERT INTO users (userID, phoneNumber) VALUES (?, '79990000001');", [user]);
    await account.execute('INSERT INTO sessions VALUES (x\'01\', x\'02\', ?, x\'03\', x\'04\', 1, 1000);', [user]);
    await migrate();
    final active = await Accounts(logger: Logger(), db: device).active();
    expect(active?.userID, user);
    expect(active?.phoneNumber, '79990000001');
    expect(active?.accountID, slot);
    expect(await DeviceDatabase.activeAccountID(device), slot);
  });

  test('ensureActive заводит слот и делает активным только его', () async {
    await migrate();
    final accounts = Accounts(logger: Logger(), db: device);
    await accounts.ensureActive('ffff');
    expect((await accounts.active())?.accountID, 'ffff');
    await accounts.ensureActive(slot);
    expect((await accounts.active())?.accountID, slot);
    expect((await device.get('SELECT COUNT(*) AS n FROM accounts WHERE isActive = 1;'))['n'], 1);
  });

  test('повторный запуск миграций ничего не дублирует', () async {
    await migrate();
    await migrate();
    expect((await device.get('SELECT COUNT(*) AS n FROM settingsDevice;'))['n'], 1);
  });

  test('вход и выход ведут индекс через Sessions', () async {
    await migrate();
    final accounts = Accounts(logger: Logger(), db: device);
    final sessions = Sessions(logger: Logger(), db: account, accounts: accounts);
    await account.execute("INSERT INTO users (userID, phoneNumber) VALUES (?, '79990000002');", [user]);

    await sessions.deleteAndCreate(userID: user, session: [1], sessionID: [2], sharedKey: [3], sharedSalt: [4], createAt: DateTime(2026));
    final first = await accounts.active();
    expect(first?.phoneNumber, '79990000002');

    // Повторный вход тем же пользователем — тот же accountID.
    await sessions.deleteAndCreate(userID: user, session: [5], sessionID: [6], sharedKey: [7], sharedSalt: [8], createAt: DateTime(2026));
    expect((await accounts.active())?.accountID, first?.accountID);

    // Выход: пользователь снят, слот (и папка) остаются.
    await sessions.deleteActive();
    final out = await accounts.active();
    expect(out?.accountID, first?.accountID);
    expect(out?.userID, isEmpty);
  });

  test('слот: имя и аватар для списка, удаление', () async {
    await migrate();
    final accounts = Accounts(logger: Logger(), db: device);
    await accounts.setProfile(accountID: slot, name: 'Костя', avatarPath: '/a.jpg');
    final listed = (await accounts.all()).single;
    expect(listed.name, 'Костя');
    expect(listed.avatarPath, '/a.jpg');

    final other = await accounts.createSlot();
    expect((await accounts.all()).map((a) => a.accountID), [slot, other]);
    expect((await accounts.all()).last.active, isFalse);
    await accounts.remove(other);
    expect((await accounts.all()).map((a) => a.accountID), [slot]);
  });
}
