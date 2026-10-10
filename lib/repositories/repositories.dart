import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:fixnum/fixnum.dart';
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
import '../protobuf/protos/chats_v1.pb.dart' as pb;

part "cache.dart";
part "settings_device.dart";
part "users.dart";
part "sessions.dart";
part "device_sessions.dart";
part "my_profile.dart";
part "profiles.dart";
part "contacts.dart";
part "uploads.dart";
part "downloads.dart";
part "call_logs.dart";
part "hidden_profiles.dart";
part "privacy_settings.dart";
part "notify_settings.dart";
part "chats.dart";

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
  late Profiles profiles;
  late Contacts contacts;
  late Uploads uploads;
  late Downloads downloads;
  late CallLogs callLogs;
  late HiddenProfiles hiddenProfiles;
  late PrivacySettings privacySettings;
  late NotifySettings notifySettings;
  late ChatsRepository chats;

  static Future<Repositories> initialization() async {
    final repositories = Repositories._();
    await repositories._initialization();
    return repositories;
  }

  Repositories._();

  Future<void> _initialization() async {
    String databasePath = p.join((await getApplicationSupportDirectory()).path, settings.databaseName);

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
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    );

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
        CREATE TABLE uploads (
          localID TEXT PRIMARY KEY,
          uploadID TEXT NULL,
          filePath TEXT NOT NULL,
          fileSize INTEGER NOT NULL,
          fileKey BLOB NOT NULL,
          hkdfSalt BLOB NOT NULL,
          folder TEXT NOT NULL,
          contentType TEXT NOT NULL,
          createdAt INTEGER NOT NULL
        );
      """);

        await tx.execute("""
        CREATE TABLE downloads (
          cdnID BLOB PRIMARY KEY,
          url TEXT NOT NULL,
          tmpPath TEXT NOT NULL,
          targetPath TEXT NULL,
          encryptionKey BLOB NOT NULL,
          hkdfSalt BLOB NOT NULL,
          contentType TEXT NOT NULL,
          hashSumEncrypted BLOB NOT NULL,
          cipherSize INTEGER NULL,
          receivedBytes INTEGER NOT NULL DEFAULT 0,
          status TEXT NOT NULL,
          createdAt INTEGER NOT NULL
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
          avatarCdnID BLOB NULL,
          FOREIGN KEY (avatarCdnID) REFERENCES downloads(cdnID) ON DELETE CASCADE ON UPDATE CASCADE,
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

        await tx.execute("""
        CREATE TABLE profiles (
          profileID INTEGER PRIMARY KEY,
          userID BLOB NOT NULL UNIQUE,
          username TEXT NULL,
          fistName TEXT NULL,
          lastName TEXT NULL,
          birthDate TEXT NULL,
          aboutMe TEXT NULL,
          phoneNumber TEXT NULL,
          avatarCdnID BLOB NULL,
          FOREIGN KEY (avatarCdnID) REFERENCES downloads(cdnID) ON DELETE CASCADE ON UPDATE CASCADE
        );
      """);

        await tx.execute("""
        CREATE INDEX idx_profiles_username ON profiles(username);
      """);
      }),
    );

    migrations.add(
      SqliteMigration(2, (tx) async {
        // Кэш совпадений приватного поиска контактов: номер из телефонной книги
        // (e164) ↔ userID зарегистрированного пользователя. Наполняется после
        // OPRF-раунда Match; см. lib/cubit/contacts/.
        await tx.execute("""
        CREATE TABLE contacts (
          phoneE164 TEXT PRIMARY KEY,
          userID BLOB NOT NULL,
          updatedAt INTEGER NOT NULL
        );
      """);
      }),
    );

    migrations.add(
      SqliteMigration(3, (tx) async {
        // Расширяем кэш до полного снимка телефонной книги: помимо совпадений
        // (userID != null) храним и записи для приглашения (userID == null) с
        // именем и номером — чтобы при следующем открытии экрана мгновенно
        // показать оба списка целиком, ещё до чтения книги и OPRF-поиска.
        // SQLite не умеет снять NOT NULL через ALTER, поэтому пересоздаём таблицу.
        await tx.execute("""
        CREATE TABLE contacts_new (
          phoneE164 TEXT PRIMARY KEY,
          displayName TEXT NOT NULL DEFAULT '',
          phone TEXT NOT NULL DEFAULT '',
          userID BLOB,
          updatedAt INTEGER NOT NULL
        );
      """);
        await tx.execute("""
        INSERT INTO contacts_new (phoneE164, userID, updatedAt)
        SELECT phoneE164, userID, updatedAt FROM contacts;
      """);
        await tx.execute("DROP TABLE contacts;");
        await tx.execute("ALTER TABLE contacts_new RENAME TO contacts;");
      }),
    );

    migrations.add(
      SqliteMigration(4, (tx) async {
        // Облачные контакты (синхронизируемые между устройствами) живут в том же
        // снимке, помеченные isCloud=1: их источник истины — сервер (CONTACTS_LIST
        // + CONTACTS_UPDATED), а не телефонная книга. oprf хранится для облачных,
        // чтобы сопоставлять входящее удаление (CONTACTS_UPDATED.removedOprf) с
        // локальной записью после холодного старта.
        await tx.execute("ALTER TABLE contacts ADD COLUMN isCloud INTEGER NOT NULL DEFAULT 0;");
        await tx.execute("ALTER TABLE contacts ADD COLUMN oprf BLOB;");
      }),
    );

    migrations.add(
      SqliteMigration(5, (tx) async {
        // Кэш last-seen контакта (epoch-millis). Свойство пользователя (userID),
        // поэтому живёт в profiles рядом с avatarCdnID, а не в contacts (там строки
        // пересоздаются на каждом OPRF-проходе). Нужен для показа даты последнего
        // визита на cold-start / без сети, пока не пришёл снимок присутствия.
        await tx.execute("ALTER TABLE profiles ADD COLUMN lastSeenAt INTEGER NULL;");
      }),
    );

    migrations.add(
      SqliteMigration(6, (tx) async {
        // Локальный журнал звонков: пишется при завершении звонка (сервер историю
        // не хранит), читается вкладкой «Звонки». direction — 'incoming'/'outgoing'
        // (имя enum CallDirection), missed/video — 0/1, createdAt — epoch-millis.
        await tx.execute("""
        CREATE TABLE callLogs (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          callID TEXT NOT NULL,
          userID BLOB NOT NULL,
          displayName TEXT NOT NULL DEFAULT '',
          direction TEXT NOT NULL,
          video INTEGER NOT NULL DEFAULT 0,
          missed INTEGER NOT NULL DEFAULT 0,
          durationSeconds INTEGER NOT NULL DEFAULT 0,
          createdAt INTEGER NOT NULL
        );
      """);
        await tx.execute("CREATE INDEX idx_callLogs_createdAt ON callLogs(createdAt);");
      }),
    );

    migrations.add(
      SqliteMigration(7, (tx) async {
        // Флаг «владелец скрыл год рождения» из Profile.hide_birth_year: birthDate
        // тогда приходит с обнулённым годом (sentinel), и профиль показывает
        // только день и месяц, без возраста. Кэшируем рядом с самим birthDate,
        // чтобы корректно рисовать дату рождения и offline / на cold-start.
        await tx.execute("ALTER TABLE profiles ADD COLUMN hideBirthYear INTEGER NOT NULL DEFAULT 0;");
      }),
    );

    migrations.add(
      SqliteMigration(8, (tx) async {
        // Локально скрытые профили: пользователь прячет собеседника из своих
        // списков (Контакты/Звонки/в будущем Чаты) на этом устройстве. Хранение
        // по userID (а не по contacts.phoneE164), потому что скрыть можно и того,
        // кого нет в адресной книге — только в журнале звонков. Показать скрытого
        // снова можно, введя в поиске «/код-фразу»: сверяем sha256 введённой фразы
        // с phraseHash. Код-фраза своя на каждый профиль (см. HiddenProfiles).
        // Необратимый хеш — самой фразы нигде не храним.
        await tx.execute("""
        CREATE TABLE hiddenProfiles (
          userID BLOB PRIMARY KEY,
          phraseHash TEXT NOT NULL,
          createdAt INTEGER NOT NULL
        );
      """);
      }),
    );

    migrations.add(
      SqliteMigration(9, (tx) async {
        // Локальный тумблер сквозного шифрования звонков (per-device). По
        // умолчанию включено (1). Колонку завели ещё в первой версии E2EE
        // (0.0.230), фичу тогда сворачивали, теперь она снова читается
        // (см. Calls._setupCallE2ee).
        await tx.execute("ALTER TABLE settingsDevice ADD COLUMN callsE2ee INTEGER NOT NULL DEFAULT 1;");
      }),
    );

    migrations.add(
      SqliteMigration(10, (tx) async {
        // Настройки приватности («кто может звонить / видеть день рождения / „О
        // себе“ / последнее посещение» + скрытие года). Кэш read-only отражения
        // серверной настройки: приходит через стрим (push при смене на другом
        // устройстве или ответ на запрос), пишется централизованно в
        // API._handleMessage, читается offline. Весь ответ PrivacySettings_Response
        // храним одним BLOB на пользователя — у настройки repeated-bytes списки
        // исключений (allow/deny × 4 канала), колоночная раскладка неудобна.
        await tx.execute("""
        CREATE TABLE privacySettings (
          userID BLOB PRIMARY KEY,
          payload BLOB NOT NULL,
          FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
        );
      """);
      }),
    );

    migrations.add(
      SqliteMigration(11, (tx) async {
        // Настройки уведомлений (личные / группы / каналы, «Новые контакты»,
        // «Пропущенные звонки») — общие для всех устройств, применяет сервер.
        // Кэш read-only отражения, как privacySettings: весь
        // NotifySettings_Response одним BLOB на пользователя, пишется в
        // API._handleMessage, читается offline.
        await tx.execute("""
        CREATE TABLE notifySettings (
          userID BLOB PRIMARY KEY,
          payload BLOB NOT NULL,
          FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
        );
      """);
      }),
    );

    migrations.add(
      SqliteMigration(12, (tx) async {
        // Флаг UX-демо чатов (экран «Разработчик»): вкладка «Чаты» показывает
        // фейковые чаты и папки из ChatsDemoDataSource. Локальная настройка
        // устройства, на сервер не уходит.
        await tx.execute("ALTER TABLE settingsDevice ADD COLUMN chatsDemo INTEGER NOT NULL DEFAULT 0;");
      }),
    );

    migrations.add(
      SqliteMigration(13, (tx) async {
        // «Темы для чатов» (Настройки → Оформление): узор обоев (id SVG из
        // assets/wallpapers, 'none' — без узора) и индекс цвета. Локально.
        await tx.execute("ALTER TABLE settingsDevice ADD COLUMN chatWallpaper TEXT NOT NULL DEFAULT 'chat';");
        await tx.execute("ALTER TABLE settingsDevice ADD COLUMN chatWallpaperColor INTEGER NOT NULL DEFAULT 0;");
      }),
    );

    migrations.add(
      SqliteMigration(14, (tx) async {
        // «Темы для чатов»: интенсивность (видимость) узора обоев, 0–100 %. Локально.
        await tx.execute("ALTER TABLE settingsDevice ADD COLUMN chatWallpaperIntensity INTEGER NOT NULL DEFAULT 40;");
      }),
    );

    migrations.add(
      SqliteMigration(15, (tx) async {
        // «Быстрая реакция» (Настройки → Оформление): эмодзи двойного тапа по
        // сообщению. Пока локально; позже — в профиль (синхронно между устройствами).
        await tx.execute("ALTER TABLE settingsDevice ADD COLUMN quickReaction TEXT NOT NULL DEFAULT '❤️';");
      }),
    );

    migrations.add(
      SqliteMigration(16, (tx) async {
        // Чаты, первый срез — личные (и «Избранное»). Локальная копия серверного
        // состояния (см. ChatsRemoteDataSource / ChatsSync): видно offline,
        // догоняется по журналу обновлений (pts). Всё — по userID, чтобы на
        // одном устройстве не смешивались аккаунты.
        //
        // chatDialogs — мой диалог: собеседник, последнее сообщение (целиком,
        // сериализованный ChatMessage — список рисуется без истории), до какого
        // messageID прочитано мной / собеседником, счётчик и настройки. draft —
        // только локально (на сервер не уходит).
        await tx.execute("""
        CREATE TABLE chatDialogs (
          userID BLOB NOT NULL,
          chatID BLOB NOT NULL,
          type INTEGER NOT NULL DEFAULT 0,
          peerUserID BLOB NULL,
          topMessageID INTEGER NOT NULL DEFAULT 0,
          topMessageDate INTEGER NOT NULL DEFAULT 0,
          topMessage BLOB NULL,
          readInboxMaxID INTEGER NOT NULL DEFAULT 0,
          readOutboxMaxID INTEGER NOT NULL DEFAULT 0,
          unreadCount INTEGER NOT NULL DEFAULT 0,
          pinned INTEGER NOT NULL DEFAULT 0,
          archived INTEGER NOT NULL DEFAULT 0,
          markedUnread INTEGER NOT NULL DEFAULT 0,
          mutedUntil INTEGER NOT NULL DEFAULT 0,
          draft TEXT NOT NULL DEFAULT '',
          createdAt INTEGER NOT NULL DEFAULT 0,
          PRIMARY KEY (userID, chatID),
          FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
        );
      """);
        await tx.execute("CREATE INDEX idx_chatDialogs_peer ON chatDialogs(userID, peerUserID);");

        // chatMessages — кэш истории. Открыты те же поля, что и на сервере;
        // содержимое — сериализованный MessageContent одним BLOB. Первичный ключ
        // (userID, chatID, messageID) — он же индекс для страниц истории.
        await tx.execute("""
        CREATE TABLE chatMessages (
          userID BLOB NOT NULL,
          chatID BLOB NOT NULL,
          messageID INTEGER NOT NULL,
          fromUserID BLOB NOT NULL,
          date INTEGER NOT NULL,
          editDate INTEGER NOT NULL DEFAULT 0,
          randomID INTEGER NOT NULL DEFAULT 0,
          mediaUnread INTEGER NOT NULL DEFAULT 0,
          silent INTEGER NOT NULL DEFAULT 0,
          content BLOB NOT NULL,
          PRIMARY KEY (userID, chatID, messageID),
          FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
        );
      """);

        // chatOutbox — ещё не дошедшие до сервера (offline / обрыв): уходят при
        // переподключении, randomID делает повтор идемпотентным. chatID пуст —
        // чата ещё нет, адресуем peerUserID. failed — сервер отклонил (не
        // транзиентная ошибка), повторно не шлём.
        await tx.execute("""
        CREATE TABLE chatOutbox (
          userID BLOB NOT NULL,
          randomID INTEGER NOT NULL,
          chatID BLOB NULL,
          peerUserID BLOB NULL,
          content BLOB NOT NULL,
          silent INTEGER NOT NULL DEFAULT 0,
          failed INTEGER NOT NULL DEFAULT 0,
          createdAt INTEGER NOT NULL,
          PRIMARY KEY (userID, randomID),
          FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
        );
      """);

        // chatUpdatesState — последний применённый pts журнала обновлений.
        await tx.execute("""
        CREATE TABLE chatUpdatesState (
          userID BLOB PRIMARY KEY,
          pts INTEGER NOT NULL,
          date INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE ON UPDATE CASCADE
        );
      """);
      }),
    );

    migrations.add(
      SqliteMigration(17, (tx) async {
        // Фича-флаг «Серверные чаты» (экран «Разработчик»): вкладка «Чаты»
        // работает с сервером (ChatsRemoteDataSource + ChatsSync). Выключен —
        // синхронизации нет, список пуст (если не включено демо). Локально.
        await tx.execute("ALTER TABLE settingsDevice ADD COLUMN chatsServer INTEGER NOT NULL DEFAULT 0;");
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
      } else {
        // Миграция класса доступности: пароль, записанный старым дефолтом
        // (whenUnlocked), недоступен на cold-start от VoIP-push. Перезаписываем
        // его теми же (afterFirstUnlock) iOSOptions — так существующие установки
        // получают доступ в фоне без сброса БД. Идемпотентно, no-op-эквивалент
        // после первой миграции. Выполняется на обычном (foreground) запуске,
        // где read уже успешен.
        await storage.write(key: 'databasePassword', value: password);
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
    profiles = Profiles(logger: logger, db: db);
    contacts = Contacts(logger: logger, db: db);
    uploads = Uploads(logger: logger, db: db);
    downloads = Downloads(logger: logger, db: db);
    callLogs = CallLogs(logger: logger, db: db);
    hiddenProfiles = HiddenProfiles(logger: logger, db: db);
    privacySettings = PrivacySettings(logger: logger, db: db);
    notifySettings = NotifySettings(logger: logger, db: db);
    chats = ChatsRepository(logger: logger, db: db);
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
