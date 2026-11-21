part of 'repositories.dart';

/// Незавершённая сессия входа по звонку-паролю (`device.db`, одна строка,
/// docs/plans/06-callpassword-reconnect.md): переживает смерть процесса во
/// время ожидания звонка — после рестарта [Routers] восстанавливает экран
/// подтверждения, пока серверная сессия жива. Пишется при запросе звонка
/// ([AuthCubit.onPressed]), чистится на терминальных исходах кубита
/// подтверждения.
typedef PendingCallPasswordSession = ({String callPasswordSession, String confirmationPhoneNumber, int timeout, int createdAt});

class PendingCallPassword {
  final Logger logger;
  final SqliteDatabase db;

  PendingCallPassword({required this.logger, required this.db});

  static const schema = '''
    CREATE TABLE pendingCallPassword (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      callPasswordSession TEXT NOT NULL,
      confirmationPhoneNumber TEXT NOT NULL,
      timeout INTEGER NOT NULL,
      createdAt INTEGER NOT NULL
    );
  ''';

  /// Зеркало записи в памяти: `_redirect` синхронный, читать базу в нём нельзя.
  /// Заполняется при старте ([load]) и обновляется вместе с базой ([set]/[clear]).
  PendingCallPasswordSession? _cached;

  /// Текущая запись; null — незавершённой сессии нет.
  PendingCallPasswordSession? get session => _cached;

  /// Прочитать запись при старте (до runApp: `getIt.allReady()` ждёт
  /// [DeviceRepositories]).
  Future<void> load() async {
    try {
      final row = await db.getOptional(
        'SELECT callPasswordSession, confirmationPhoneNumber, timeout, createdAt FROM pendingCallPassword WHERE id = 1;',
      );
      if (row == null) return;
      _cached = (
        callPasswordSession: row['callPasswordSession'] as String,
        confirmationPhoneNumber: row['confirmationPhoneNumber'] as String,
        timeout: row['timeout'] as int,
        createdAt: row['createdAt'] as int,
      );
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace, "pending call password: load failed");
    }
  }

  /// Записать/заменить сессию (новая заявка звонка); зеркало обновляется сразу
  /// — синхронные читатели не ждут базу.
  Future<void> set({required String callPasswordSession, required String confirmationPhoneNumber, required int timeout}) async {
    final record = (
      callPasswordSession: callPasswordSession,
      confirmationPhoneNumber: confirmationPhoneNumber,
      timeout: timeout,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _cached = record;
    await db.execute(
      'INSERT OR REPLACE INTO pendingCallPassword (id, callPasswordSession, confirmationPhoneNumber, timeout, createdAt) VALUES (1, ?, ?, ?, ?);',
      [record.callPasswordSession, record.confirmationPhoneNumber, record.timeout, record.createdAt],
    );
  }

  /// Сессия закрыта (успех, таймаут, ошибка, блокировка).
  Future<void> clear() async {
    _cached = null;
    await db.execute('DELETE FROM pendingCallPassword WHERE id = 1;');
  }

  /// Остаток ожидания [record] в секундах; <= 0 — серверная сессия истекла
  /// (таймаут сервер считает от момента создания сессии, [PendingCallPasswordSession.createdAt]
  /// — момент ответа AUTH_CALL_PASSWORD).
  static int remainingSeconds(PendingCallPasswordSession record) {
    final deadline = DateTime.fromMillisecondsSinceEpoch(record.createdAt).add(Duration(seconds: record.timeout));
    return deadline.difference(DateTime.now()).inSeconds;
  }
}
