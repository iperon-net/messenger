
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../di.dart';
import '../i18n/translations.g.dart';
import '../logger.dart';
import '../models.dart' as models;
import '../settings.dart';

part "device_sessions.dart";
part "sessions.dart";
part "settings_device.dart";
part "users.dart";
part "cache.dart";

class Repositories {
  final _logger = getIt.get<Logger>();

  late Database _database;
  late SettingsDevice settingsDevice;
  late Users users;
  late Sessions sessions;
  late DeviceSessions deviceSessions;
  late Cache cache;

  Future<void> initialization() async {
    String databasePath = p.join((await getApplicationSupportDirectory()).path, Settings.databaseName);

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

    _database = sqlite3.open(databasePath);
    _logger.debug(databasePath);

    if (!kDebugMode) {
      String? password = await storage.read(key: "database_password");
      if (password == null) {
        password = _generatePassword();
        await storage.write(key: 'database_password', value: password);
        _logger.info('A new password has been set for the database');
      }
      _database.execute("PRAGMA key = '$password'");
    }

    _database.execute("PRAGMA journal_mode = WAL");
    _database.execute("PRAGMA foreign_keys = ON");

    // Migrations
    _logger.info("userVersion = ${_database.userVersion}");

    if (_database.userVersion == 0) {
      _database.execute("""
        CREATE TABLE settingsDevice (
          locale TEXT NULL,
          darkMode TEXT NOT NULL,
          colorTheme TEXT NOT NULL,
          isBlurTaskSwitchingEnable INTEGER NOT NULL,
          isContactBannerDisabled INTEGER NOT NULL,
          isNotificationBannerDisabled INTEGER NOT NULL
        )
      """);

      _database.execute("""
        INSERT INTO settingsDevice
          (locale, darkMode, colorTheme, isBlurTaskSwitchingEnable, isContactBannerDisabled, isNotificationBannerDisabled)
        VALUES
          (NULL, 'system', 'blue', 0, 0, 0)
      """);

      _database.execute("""
          CREATE TABLE users (
            userID TEXT PRIMARY KEY,
            phoneNumber TEXT NOT NULL,
            salt BLOB NULL
          );
      """);

      _database.execute("""
          CREATE TABLE sessions (
            sessionID BLOB NOT NULL,
            session BLOB NOT NULL,
            userID BLOB NOT NULL,
            sharedKey BLOB NOT NULL,
            salt BLOB NOT NULL,
            isActive INTEGER NOT NULL DEFAULT 0,
            createAt INTEGER NOT NULL,
            FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
          );
      """);

      _database.execute("""
          CREATE TABLE cache (
            key TEXT NOT NULL,
            value BLOB NOT NULL,
            ttl INTEGER NOT NULL DEFAULT 0,
            userID BLOB NOT NULL,
            FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
          );
      """);

      _database.execute("""
          CREATE TABLE deviceSessions (
            sessionID BLOB NOT NULL,
            userID BLOB NOT NULL,
            deviceModel TEXT NOT NULL,
            os INTEGER NOT NULL,
            osVersion TEXT NOT NULL,
            appVersion TEXT NOT NULL,
            appBuildNumber TEXT NOT NULL,
            locationRussian TEXT NOT NULL,
            locationEnglish TEXT NOT NULL,
            updateAt INTEGER NOT NULL,
            FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
          );
      """);

      _database.execute("""
          CREATE TABLE contacts (
            contactID TEXT NOT NULL,
            userID BLOB NOT NULL,
            firstName TEXT NULL,
            lastName TEXT NULL,
            lastSeenAt TEXT NULL,
            phoneNumber TEXT NULL,
            username TEXT NULL,
            birthDate TEXT NULL,
            avatarColor INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
          );
      """);

      _database.execute("""
          CREATE TABLE contactPhoneNumbers (
            contactID TEXT NOT NULL,
            international TEXT NOT NULL,
            national TEXT NOT NULL,
            e164 TEXT NOT NULL,
            rfc3966 TEXT NOT NULL,
            FOREIGN KEY (contactID) REFERENCES contacts(contactID) ON DELETE CASCADE ON UPDATE CASCADE
          );
      """);

      _database.execute("PRAGMA user_version = 1");
    }

    settingsDevice = SettingsDevice(logger: _logger, database: _database);
    users = Users(logger: _logger, database: _database);
    sessions = Sessions(logger: _logger, database: _database);
    deviceSessions = DeviceSessions(logger: _logger, database: _database);
    cache = Cache(logger: _logger, database: _database);
    _logger.info("repositories initialization");
  }

  // Generate password
  String _generatePassword() {
    final random = Random();
    final characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
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
