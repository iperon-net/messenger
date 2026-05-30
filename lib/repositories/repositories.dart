
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:objectid/objectid.dart';
import 'package:path_provider/path_provider.dart';

import '../di.dart';
import '../i18n/translations.g.dart';
import '../logger.dart';
import 'package:path/path.dart' as p;
import '../models/models.dart' as models;
import '../settings.dart';
import 'package:sqlite_async/sqlite_async.dart';

part "settings_device.dart";
part "users.dart";

class Repositories {
  final _logger = getIt.get<Logger>();

  late SqliteDatabase _database;
  late SettingsDevice settingsDevice;
  late Users users;

  Future<void> initialization() async {
    String databasePath = p.join((await getApplicationDocumentsDirectory()).path, Settings.databaseName);

    // Secure storage
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(),
    );

    // Delete the database
    if (Settings.isDeleteDatabase) {
      _logger.warning('Deleting the database, flag set IS_DELETE_DATABASE: ${Settings.isDeleteDatabase.toString()}');

      try {
        if (await File(databasePath).exists()) {
          await File(databasePath).delete();
          _logger.info("the database has been successfully deleted");
        }

        if (await File("$databasePath-wal").exists()) {
          await File("$databasePath-wal").delete();
        }

        if (await File("$databasePath-shm").exists()) {
          await File("$databasePath-shm").delete();
        }
      } catch (e) {
        _logger.error("error delete database $e");
      }

      storage.delete(key: "database_password");
    }

    // migrations
    final migrations = SqliteMigrations()
      ..add(
        SqliteMigration(1, (tx) async {
          await tx.execute("""
            CREATE TABLE settingsDevice (
              locale TEXT NULL,
              darkMode TEXT NOT NULL,
              colorTheme TEXT NOT NULL,
              blurTaskSwitchingEnable INTEGER NOT NULL
            )
          """);

          await tx.execute("""
            INSERT INTO settingsDevice
              (locale, darkMode, colorTheme, blurTaskSwitchingEnable)
            VALUES
              (NULL, 'system', 'blue', 1)
          """);

        })
    );

    _logger.debug(databasePath);

    _database = SqliteDatabase(
      path: databasePath,
      options: SqliteOptions(journalMode: SqliteJournalMode.persist),
    );

    await migrations.migrate(_database);

    settingsDevice = SettingsDevice(logger: _logger, database: _database);
    users = Users(logger: _logger, database: _database);

    _logger.info("repositories initialization");

    // await database.executeBatch('INSERT INTO test_data(data) values(?)', [
    //   ['Test1'],
    //   ['Test2']
    // ]);
    // var results = await database.getAll('SELECT * FROM test_data');
    // _logger.debug(results.toString());

    // final result = await database.execute("PRAGMA cipher_version;");
    // _logger.debug(result.toString());


    // String databasesPath = await getDatabasesPath();
    // _logger.debug(databasesPath);
    //
    // final migrations = SqliteMigrations();
    //
    // migrations.add(SqliteMigration(Settings.databaseVersion, (tx) async {
    //   await tx.execute('CREATE TABLE test_data(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)');
    // }));
    //
    //
    // final db = SqliteDatabase(path: Settings.databaseName, options: SqliteOptions());
    //
    // await migrations.migrate(db);


    // String databasesPath = await getDatabasesPath();
    // String path = p.join(databasesPath, Settings.databaseName);
    // _logger.debug("database patch $path");
    //
    // final storage = FlutterSecureStorage(
    //   aOptions: AndroidOptions(),
    //   iOptions: IOSOptions(),
    // );
    //
    // // Delete the database
    // if (Settings.isDeleteDatabase) {
    //   _logger.warning('Deleting the database, flag set IS_DELETE_DATABASE: ${Settings.isDeleteDatabase.toString()}');
    //   await deleteDatabase(path);
    //   storage.delete(key: "database_password");
    // }
    //
    // // onConfigure
    // Future<void> onConfigure(Database db) async {
    //   await db.execute('PRAGMA foreign_keys = ON');
    // }
    //
    // // onCreate
    // Future<void> onCreate(Database db, int version) async {
    //   _logger.info('Creating the database version=$version');
    //   Batch batch = db.batch();
    //
    //   if (version == 1) {
    //     batch.execute('''
    //       CREATE TABLE settingsDevice (
    //         locate TEXT NULL,
    //         darkMode TEXT NOT NULL,
    //         colorTheme TEXT NOT NULL,
    //         blurTaskSwitchingEnable INTEGER NOT NULL
    //       )
    //     ''');
    //
    //     batch.execute('''
    //       INSERT INTO settingsDevice
    //         (locate, darkMode, colorTheme, blurTaskSwitchingEnable)
    //       VALUES
    //         (NULL, 'system', 'blue', 1)
    //     ''');
    //
    //     //
    //     batch.execute('''
    //       CREATE TABLE users (
    //         userID TEXT PRIMARY KEY,
    //         phoneNumber TEXT NOT NULL,
    //         session BLOB NOT NULL,
    //         isActive INT NOT NULL DEFAULT 0
    //       );
    //     ''');
    //
    //     batch.execute('''
    //       CREATE TABLE sharedKeys (
    //           sharedKeyID TEXT PRIMARY KEY,
    //           userID TEXT NOT NULL,
    //           sharedKey BLOB NOT NULL,
    //           expiredAt INTEGER NULL,
    //           FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
    //       );
    //     ''');
    //
    //   }
    //
    //   await batch.commit();
    // }
    //
    // // onUpgrade
    // Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}
    //
    // if (kDebugMode) {
    //   _database = await openDatabase(
    //     path,
    //     version: Settings.databaseVersion,
    //     onConfigure: onConfigure,
    //     onCreate: onCreate,
    //     onUpgrade: onUpgrade,
    //   );
    //
    //   _logger.warning('The database is not encrypted');
    // } else {
    //   String? password = await storage.read(key: "database_password");
    //
    //   if (password == null) {
    //     password = _generatePassword();
    //     await storage.write(key: 'database_password', value: password);
    //     _logger.info('A new password has been set for the database');
    //   }
    //
    //   _database = await sqflite_sqlcipher.openDatabase(
    //     path,
    //     version: Settings.databaseVersion,
    //     password: password,
    //     onConfigure: onConfigure,
    //     onCreate: onCreate,
    //     onUpgrade: onUpgrade,
    //   );
    // }
  }

  // Generate password
  String _generatePassword() {
    final random = Random();
    final characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-';
    String password = '';

    int min = 60;
    int max = 100;
    final rnd = Random();
    final length = min + rnd.nextInt(max - min);

    for (int i = 0; i < length; i++) {
      password += characters[random.nextInt(characters.length)];
    }
    return password;
  }

}
