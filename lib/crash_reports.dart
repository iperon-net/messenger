import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlite_async/sqlite_async.dart';

import 'api.dart';
import 'auth.dart';
import 'di.dart';
import 'logger.dart';
import 'protobuf/protos/crash_report_v1.pb.dart';
import 'protobuf/protos/v1.pb.dart';
import 'utils.dart';

/// Сбой, ещё не отправленный на сервер.
@visibleForTesting
class CrashReport {
  final int? id;
  final String error;
  final String stack;
  final String reason;
  final bool fatal;
  final int date;

  const CrashReport({this.id, required this.error, this.stack = '', this.reason = '', this.fatal = false, required this.date});
}

/// Отчёты о сбоях там, где нет Crashlytics (десктоп, docs/plans/desktop-client.md
/// §3.1). Сбой сразу пишется в `device.db` (таблица `crashReports`, до неё — в
/// память) и уходит на сервер пачкой (`CRASH_REPORT`), когда есть вошедший
/// аккаунт и стрим подключён; сервер кладёт их в свой лог (→ Loki). В отчёте
/// только исключение, стек, версия и ОС — без логов приложения и переписки.
class CrashReports {
  CrashReports._();

  static final instance = CrashReports._();

  /// Сколько отчётов храним до отправки: дальше старые вытесняются — сломанный
  /// цикл не должен раздуть базу.
  static const maxStored = 100;

  /// Отчётов в одном запросе (столько же принимает сервер).
  static const batchSize = 20;

  static const _flushDelay = Duration(seconds: 5);

  SqliteDatabase? _db;
  final _pending = <CrashReport>[];
  Timer? _flushTimer;
  bool _flushing = false;

  /// `device.db` открыта: сбои, случившиеся до неё, переезжают туда.
  Future<void> attach(SqliteDatabase db) async {
    _db = db;
    final pending = List.of(_pending);
    _pending.clear();
    for (final report in pending) {
      await _store(report);
    }
  }

  /// Отвязать базу (тесты: следующие сбои снова копятся в памяти).
  @visibleForTesting
  void detach() {
    _db = null;
    _flushTimer?.cancel();
  }

  /// Записать сбой. Не бросает: сбой при записи сбоя только в лог.
  void record(Object error, StackTrace? stack, {bool fatal = false, String? reason}) {
    final report = CrashReport(
      error: error.toString(),
      stack: stack?.toString() ?? '',
      reason: reason ?? '',
      fatal: fatal,
      date: DateTime.now().millisecondsSinceEpoch,
    );
    if (_db == null) {
      if (_pending.length < maxStored) _pending.add(report);
      return;
    }
    unawaited(_store(report).then((_) => _scheduleFlush()));
  }

  Future<void> _store(CrashReport report) async {
    final db = _db;
    if (db == null) return;
    try {
      await db.writeTransaction((tx) async {
        await tx.execute('INSERT INTO crashReports (error, stack, reason, fatal, date) VALUES (?, ?, ?, ?, ?);', [
          report.error,
          report.stack,
          report.reason,
          report.fatal ? 1 : 0,
          report.date,
        ]);
        await tx.execute('DELETE FROM crashReports WHERE id NOT IN (SELECT id FROM crashReports ORDER BY id DESC LIMIT ?);', [maxStored]);
      });
    } catch (error, stackTrace) {
      _log(error, stackTrace);
    }
  }

  void _scheduleFlush() {
    _flushTimer?.cancel();
    _flushTimer = Timer(_flushDelay, () => unawaited(flush()));
  }

  /// Отправить накопленное. Зовётся на подключении стрима и после нового
  /// сбоя; без вошедшего аккаунта или сети отчёты ждут следующего раза.
  Future<void> flush() async {
    final db = _db;
    if (db == null || _flushing) return;
    if (!getIt.isRegistered<API>() || !getIt.isRegistered<Auth>() || !getIt.get<Auth>().isAuthorized) return;
    _flushing = true;
    try {
      final utils = getIt.get<Utils>();
      final api = getIt.get<API>();
      while (true) {
        final rows = await db.getAll('SELECT id, error, stack, reason, fatal, date FROM crashReports ORDER BY id LIMIT ?;', [batchSize]);
        if (rows.isEmpty) return;
        final device = await utils.deviceInfo();
        final package = await utils.packageInfo();
        final request = CrashReport_Request(
          items: [
            for (final row in rows)
              CrashReport_Item(
                error: row['error'] as String,
                stack: row['stack'] as String,
                reason: row['reason'] as String,
                fatal: row['fatal'] == 1,
                date: Int64(row['date'] as int),
              ),
          ],
          appVersion: package.appVersion,
          appBuildNumber: package.appBuildNumber,
          os: device.osCode,
          osVersion: device.osVersion,
          deviceModel: device.deviceModel,
        );
        final status = await api.unaryEncoded(MessageType.CRASH_REPORT, request.writeToBuffer());
        if (status.status != APIStatus.success) return;
        final ids = [for (final row in rows) row['id'] as int];
        await db.execute('DELETE FROM crashReports WHERE id IN (${List.filled(ids.length, '?').join(', ')});', ids);
        if (rows.length < batchSize) return;
      }
    } catch (error, stackTrace) {
      _log(error, stackTrace);
    } finally {
      _flushing = false;
    }
  }

  /// Сбой самого сборщика — только в лог, не в [record] (иначе цикл).
  void _log(Object error, StackTrace stackTrace) {
    if (getIt.isRegistered<Logger>()) getIt.get<Logger>().handle(error, stackTrace, 'crash reports');
  }
}
