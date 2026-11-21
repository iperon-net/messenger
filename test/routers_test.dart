import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';
import 'package:messenger/repositories/repositories.dart';
import 'package:messenger/routers.dart';
import 'package:sqlite_async/sqlite_async.dart';

void main() {
  group('redirectAuthLocation', () {
    test('гость попадает на авторизацию и остаётся на её вложенных маршрутах', () {
      expect(redirectAuthLocation('/chats', isAuthorized: false), '/auth');
      expect(redirectAuthLocation('/settings', isAuthorized: false), '/auth');
      expect(redirectAuthLocation('/auth', isAuthorized: false), isNull);
      expect(redirectAuthLocation('/auth/cloud_password', isAuthorized: false), isNull);
    });

    test('авторизованный пользователь не возвращается на экраны входа', () {
      expect(redirectAuthLocation('/chats', isAuthorized: true), isNull);
      expect(redirectAuthLocation('/profile/123', isAuthorized: true), isNull);
      expect(redirectAuthLocation('/auth', isAuthorized: true), '/chats');
      expect(redirectAuthLocation('/auth/call_password_confirmation', isAuthorized: true), '/chats');
    });
  });

  // Незавершённый вход по звонку-паролю после смерти процесса
  // (docs/plans/06-callpassword-reconnect.md).
  group('pendingCallPasswordLocation', () {
    late Directory dir;
    late SqliteDatabase db;
    late PendingCallPassword pending;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('routers_pending');
      db = SqliteDatabase(path: '${dir.path}/device.db');
      await db.execute('''
        CREATE TABLE pendingCallPassword (
          id INTEGER PRIMARY KEY CHECK (id = 1),
          callPasswordSession TEXT NOT NULL,
          confirmationPhoneNumber TEXT NOT NULL,
          timeout INTEGER NOT NULL,
          createdAt INTEGER NOT NULL
        );
      ''');
      pending = PendingCallPassword(logger: Logger(), db: db);
    });

    tearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    test('без записи — null', () {
      expect(pendingCallPasswordLocation(pending), isNull);
    });

    test('живая сессия — URL экрана подтверждения с теми же параметрами', () async {
      await pending.set(callPasswordSession: 'ab01', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: 120);

      final location = pendingCallPasswordLocation(pending);
      expect(location, isNotNull);
      final uri = Uri.parse(location!);
      expect(uri.path, '/auth/call_password_confirmation');
      expect(uri.queryParameters['callPasswordSession'], 'ab01');
      expect(uri.queryParameters['confirmationPhoneNumber'], '+7 *** ***-**-44');
      expect(int.parse(uri.queryParameters['timeout']!), inInclusiveRange(110, 120));
    });

    test('истекшая сессия — null, запись очищается', () async {
      await pending.set(callPasswordSession: 'ab01', confirmationPhoneNumber: '+7 *** ***-**-44', timeout: 30);
      // Сдвинуть запись в прошлое и перечитать её, как после «рестарта».
      await db.execute('UPDATE pendingCallPassword SET createdAt = ?;', [DateTime.now().millisecondsSinceEpoch - 60 * 1000]);
      final restored = PendingCallPassword(logger: Logger(), db: db);
      await restored.load();

      expect(pendingCallPasswordLocation(restored), isNull);
      await Future<void>.delayed(Duration.zero);
      expect(restored.session, isNull);
      // Очистка записи в базе уходит фоном (unawaited) — дать ей завершиться
      // до закрытия базы в tearDown.
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
  });
}
