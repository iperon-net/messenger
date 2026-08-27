import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_async/sqlite_async.dart';
import 'package:sqlite_async/native.dart';

import '../di.dart';
import '../i18n/translations.g.dart';
import '../logger.dart';
import '../settings.dart';
import '../models.dart' as models;

part "cache.dart";
part "settings_device.dart";
part "users.dart";
part "sessions.dart";
part "device_sessions.dart";
part "my_profile.dart";

base class _AppSqliteOpenFactory extends NativeSqliteOpenFactory {
  final String? password;

  _AppSqliteOpenFactory({required super.path, this.password});

  @override
  List<String> pragmaStatements(SqliteOpenOptions options) {
    // PRAGMA key должен идти первым — до любого обращения к БД.
    // foreign_keys задаётся для каждого соединения пула отдельно,
    // так как это connection-scoped настройка.
    return [
      if (password != null) "PRAGMA key = '${password!.replaceAll("'", "''")}'",
      ...super.pragmaStatements(options),
      "PRAGMA foreign_keys = ON",
    ];
  }
}

class Repositories {
  final logger = getIt.get<Logger>();
  final settings = getIt.get<Settings>();

  final migrations = SqliteMigrations();

  late SqliteDatabase db;
  late SettingsDevice settingsDevice;
  late Users users;
  late Sessions sessions;
  late DeviceSessions deviceSessions;
  late Cache cache;
  late MyProfile myProfile;

  static Future<Repositories> initialization() async {
    final repositories = Repositories._();
    await repositories._initialization();
    return repositories;
  }

  Repositories._();

  Future<void> _initialization() async {
    String databasePath = p.join((await getApplicationSupportDirectory()).path, settings.databaseName);

    // Secure storage
    final storage = FlutterSecureStorage(aOptions: AndroidOptions(), iOptions: IOSOptions());

    migrations.add(
      SqliteMigration(1, (tx) async {
        await tx.execute("""
        CREATE TABLE settingsDevice (
          locale TEXT NULL,
          darkMode TEXT NOT NULL,
          colorTheme TEXT NOT NULL,
          isBlurOnInactive INTEGER NOT NULL,
          passcode BLOB NULL,
          passcodeBiometric INTEGER NULL,
          passcodeAutoLock INTEGER NULL,
          passcodeForceLocked INTEGER NOT NULL DEFAULT 0,
          passcodeBackgroundedAt INTEGER NOT NULL DEFAULT 0,
          isContactBannerDisabled INTEGER NOT NULL,
          isNotificationBannerDisabled INTEGER NOT NULL
        );
      """);

        await tx.execute("""
        INSERT INTO settingsDevice
          (locale, darkMode, colorTheme, isBlurOnInactive,
            isContactBannerDisabled, isNotificationBannerDisabled)
        VALUES
          (NULL, 'system', 'blue', 0, 0, 0)
      """);

        await tx.execute("""
        CREATE TABLE users (
          userID TEXT PRIMARY KEY,
          phoneNumber TEXT NOT NULL
        );
      """);

        await tx.execute("""
        CREATE TABLE myProfile (
          myProfileID INTEGER PRIMARY KEY,
          userID BLOB NOT NULL UNIQUE,
          username TEXT NULL,
          fistName TEXT NULL,
          lastName TEXT NULL,
          birthDate TEXT NULL,
          aboutMe TEXT NULL,
          avatarLocalPath TEXT NULL,
          FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
        );
      """);

        await tx.execute("""
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

        await tx.execute("""
        CREATE TABLE cache (
          key TEXT NOT NULL,
          value BLOB NOT NULL,
          ttl INTEGER NOT NULL DEFAULT 0,
          userID BLOB NOT NULL,
          FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE,
          CONSTRAINT unique_userId_key UNIQUE (userID, key)
        );
      """);

        await tx.execute("""
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
      }),
    );

    if (settings.isDeleteDatabase) {
      logger.warning("Deleting the database, flag set IS_DELETE_DATABASE: 1");

      try {
        if (await File(databasePath).exists()) {
          await File(databasePath).delete();
          logger.info("the database has been successfully deleted");
        }

        if (await File("$databasePath-wal").exists()) {
          await File("$databasePath-wal").delete();
        }

        if (await File("$databasePath-shm").exists()) {
          await File("$databasePath-shm").delete();
        }
      } catch (e) {
        logger.error("error delete database $e");
      }

      storage.delete(key: "databasePassword");
    }

    logger.logCustom(RepositoriesLog("databasePath = $databasePath"));

    if (!kDebugMode) {
      String? password = await storage.read(key: "databasePassword");
      if (password == null) {
        password = _generatePassword();
        await storage.write(key: 'databasePassword', value: password);
        logger.logCustom(RepositoriesLog("A new password has been set for the database"));
      }

      db = SqliteDatabase.withFactory(_AppSqliteOpenFactory(path: databasePath, password: password));
    } else {
      db = SqliteDatabase.withFactory(_AppSqliteOpenFactory(path: databasePath));
    }

    await migrations.migrate(db);
    settingsDevice = SettingsDevice(logger: logger, db: db);
    users = Users(logger: logger, db: db);
    sessions = Sessions(logger: logger, db: db);
    deviceSessions = DeviceSessions(logger: logger, db: db);
    cache = Cache(logger: logger, db: db);
    myProfile = MyProfile(logger: logger, db: db);
  }

  // Generate password
  String _generatePassword() {
    final random = Random.secure();
    final characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String password = '';

    int min = 60;
    int max = 100;
    final length = min + random.nextInt(max - min);

    for (int i = 0; i < length; i++) {
      password += characters[random.nextInt(characters.length)];
    }
    return password;
  }
}
