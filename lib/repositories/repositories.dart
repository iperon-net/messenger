import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/secure_storage.dart';
import 'package:messenger/settings.dart';
import "package:path/path.dart" as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sqflite_sqlcipher;

import '../di.dart';
import '../logger.dart';
import '../models/models.dart' as models;

part 'settings_device.dart';
part 'users.dart';


class Repositories {
  final _logger = getIt.get<Logger>();
  final _secureStorage = getIt.get<SecureStorage>();

  late Database _database;
  late Users users;
  late SettingsDevice settingsDevice;

  Future<void> initialization() async {

    String databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, Settings.databaseName);
    _logger.debug(path);

    // Delete the database
    if (Settings.isDeleteDatabase) {
      _logger.warning("Deleting the database, flag set IS_DELETE_DATABASE: ${Settings.isDeleteDatabase.toString()}");
      await deleteDatabase(path);
    }

    // onConfigure
    Future<void> onConfigure(Database db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }

    // onCreate
    Future<void> onCreate(Database db, int version) async {
      _logger.info("Creating the database version=$version");
      Batch batch = db.batch();

      if (version == 1) {
        batch.execute("""
          CREATE TABLE settings_device (
            language TEXT NOT NULL,
            darkMode TEXT NOT NULL,
            themeColor TEXT NOT NULL,
            passCode INTEGER NOT NULL
          )
        """);

        batch.execute("""
          INSERT INTO settings_device (language, darkMode, themeColor, passCode) VALUES ("", "system", "blue", 0)
        """);

      //   batch.execute("""
      //     CREATE TABLE users (
      //       userId TEXT NOT NULL,
      //       email TEXT NOT NULL,
      //       sessionToken TEXT NOT NULL,
      //       isActive INTEGER NOT NULL DEFAULT 0
      //     )
      //   """);
      //
      //   batch.execute("""
      //     CREATE TABLE sessions (
      //       sessionId TEXT NOT NULL,
      //       createdAt TEXT NOT NULL,
      //       updatedAt TEXT NOT NULL,
      //       lastActivityAt TEXT NOT NULL,
      //       appVersion TEXT NOT NULL,
      //       appBuildNumber TEXT NOT NULL,
      //       deviceName TEXT NOT NULL,
      //       deviceSystemVersion TEXT NOT NULL,
      //       location TEXT NOT NULL
      //     )
      // """);
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

      _logger.warning("The database is not encrypted");
    } else {
      // Generate password for database
      String password = await _secureStorage.read(key: "database_password");
      if (password.isEmpty) {
        password = await _generatePassword();
        await _secureStorage.write(key: "database_password", value: password);
        _logger.info("A new password has been set for the database");
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

    users = Users(logger: _logger, database: _database);
    settingsDevice = SettingsDevice(logger: _logger, database: _database);

    final dbVersion = await _database.getVersion();
    _logger.info("Current DB version: $dbVersion");
  }

  // Generate password
  Future<String> _generatePassword() async {
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
