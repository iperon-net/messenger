
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../di.dart';
import '../i18n/translations.g.dart';
import '../logger.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqflite_sqlcipher;
import '../models/settings_device.dart' as models;
import '../settings.dart';

part "settings_device.dart";
part "profiles.dart";

class Repositories {
  final _logger = getIt.get<Logger>();

  late Database _database;
  late SettingsDevice settingsDevice;
  late Profiles profiles;

  Future<void> initialization() async {

    String databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, Settings.databaseName);
    _logger.debug("database patch $path");

    final storage = FlutterSecureStorage();

    // Delete the database
    if (Settings.isDeleteDatabase) {
      _logger.warning('Deleting the database, flag set IS_DELETE_DATABASE: ${Settings.isDeleteDatabase.toString()}');
      await deleteDatabase(path);
      storage.delete(key: "database_password");
    }

    // onConfigure
    Future<void> onConfigure(Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }

    // onCreate
    Future<void> onCreate(Database db, int version) async {
      _logger.info('Creating the database version=$version');
      Batch batch = db.batch();

      if (version == 1) {
        batch.execute('''
          CREATE TABLE settingsDevice (
            language TEXT NOT NULL,
            darkMode TEXT NOT NULL,
            themeColor TEXT NOT NULL,
            blurTaskSwitchingEnable INTEGER NOT NULL
          )
        ''');

        batch.execute('''
          INSERT INTO settingsDevice
            (language, darkMode, themeColor, blurTaskSwitchingEnable)
          VALUES
            ('', 'system', 'blue', 1)
        ''');

        //
        batch.execute('''
          CREATE TABLE users (
            usersId INTEGER PRIMARY KEY AUTOINCREMENT,
            phoneNumber TEXT NOT NULL,
            session BLOB NOT NULL,
            isActive INT NOT NULL DEFAULT 0
          );
        ''');

        batch.execute('''
          CREATE TABLE sharedKeys (
              sharedKeyId INTEGER PRIMARY KEY AUTOINCREMENT,
              usersId INTEGER NOT NULL,
              secretKey BLOB NOT NULL,
              isActive INTEGER NOT NULL DEFAULT 0,
              expiredAt INTEGER NULL,
              FOREIGN KEY (usersId) REFERENCES users(usersId) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

      }

      await batch.commit();
    }

    // onUpgrade
    Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}

    if (kDebugMode) {
      _database = await openDatabase(
        path,
        version: Settings.databaseVersion,
        onConfigure: onConfigure,
        onCreate: onCreate,
        onUpgrade: onUpgrade,
      );

      _logger.warning('The database is not encrypted');
    } else {
      String? password = await storage.read(key: "database_password");

      if (password == null) {
        password = _generatePassword();
        await storage.write(key: 'database_password', value: password);
        _logger.info('A new password has been set for the database');
      }

      _database = await sqflite_sqlcipher.openDatabase(
        path,
        version: Settings.databaseVersion,
        password: password,
        onConfigure: onConfigure,
        onCreate: onCreate,
        onUpgrade: onUpgrade,
      );
    }

    settingsDevice = SettingsDevice(logger: _logger, database: _database);
    profiles = Profiles(logger: _logger, database: _database);

    _logger.info("repositories initialization");
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
