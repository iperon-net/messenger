import 'dart:async';

import 'package:flutter/foundation.dart';

import '../cdn.dart';
import '../di.dart';
import '../logger.dart';
import '../repositories/repositories.dart';

/// Очистка скачанных вложений на устройстве: удалили сообщения или чат (у
/// себя, на другом устройстве или собеседник — «у обоих») — их файлы из кэша
/// скачиваний (`downloads` + папка media), на которые больше ничто не
/// ссылается, удаляются (как в Telegram). Сервер свои копии чистит сам
/// (`chatMediaGc`).
///
/// [ChatsRepository] при удалении сообщений отдаёт их cdnID в [release];
/// проверка идёт пачкой после транзакции, с задержкой [_delay] (одно удаление
/// чата — одна проверка). Ссылки ищутся по байтам cdnID в сохранённых
/// сообщениях (`instr` по BLOB — без разбора каждого), в превью диалогов,
/// закреплённых, неотправленных, отложенных и в аватарах (на их строки
/// `downloads` ссылается внешний ключ с каскадом — такие не трогаем никогда).
class ChatsMediaCleanup {
  ChatsMediaCleanup._();

  static final _pending = <String, Uint8List>{};
  static Timer? _timer;
  static Future<void>? _running;

  static const _delay = Duration(seconds: 3);
  static const _chunk = 50;

  /// Таблица и BLOB-колонка, где сообщение (или его содержимое) хранится целиком.
  static const _messageColumns = [
    ('chatMessages', 'content'),
    ('chatDialogs', 'topMessage'),
    ('chatPinned', 'message'),
    ('chatOutbox', 'content'),
    ('chatScheduled', 'message'),
  ];

  /// cdnID файлов удалённых сообщений — кандидаты на удаление с устройства.
  static void release(Iterable<List<int>> cdnIDs) {
    for (final id in cdnIDs) {
      if (id.isEmpty) continue;
      _pending[_hex(id)] = Uint8List.fromList(id);
    }
    if (_pending.isEmpty) return;
    _timer?.cancel();
    _timer = Timer(_delay, () => _running ??= _run().whenComplete(() => _running = null));
  }

  static Future<void> _run() async {
    final logger = getIt.get<Logger>();
    try {
      while (_pending.isNotEmpty) {
        final batch = _pending.values.take(_chunk).toList();
        for (final id in batch) {
          _pending.remove(_hex(id));
        }
        final referenced = await _referenced(batch);
        var evicted = 0;
        for (final id in batch) {
          if (referenced.contains(_hex(id))) continue;
          if (await getIt.get<CDNManager>().evict(id)) evicted++;
        }
        if (evicted > 0) logger.debug('chats: evicted $evicted unused media files');
      }
    } catch (error, stackTrace) {
      logger.handle(error, stackTrace);
    }
  }

  /// Какие из [ids] (hex) ещё нужны: есть в сообщениях или это аватар.
  static Future<Set<String>> _referenced(List<Uint8List> ids) async {
    final db = getIt.get<Repositories>().db;
    final found = <String>{};
    final any = List.filled(ids.length, '?').join(',');
    for (final table in ['profiles', 'myProfile']) {
      for (final row in await db.getAll('SELECT avatarCdnID AS id FROM $table WHERE avatarCdnID IN ($any);', ids)) {
        found.add(_hex(row['id'] as List<int>));
      }
    }
    final match = List.filled(ids.length, 'instr(c, ?) > 0').join(' OR ');
    for (final (table, column) in _messageColumns) {
      final rows = await db.getAll('SELECT c FROM (SELECT $column AS c FROM $table WHERE $column IS NOT NULL) WHERE $match;', ids);
      for (final row in rows) {
        final blob = row['c'] as List<int>;
        for (final id in ids) {
          if (_contains(blob, id)) found.add(_hex(id));
        }
      }
    }
    return found;
  }

  static bool _contains(List<int> blob, List<int> needle) {
    outer:
    for (var i = 0; i + needle.length <= blob.length; i++) {
      for (var j = 0; j < needle.length; j++) {
        if (blob[i + j] != needle[j]) continue outer;
      }
      return true;
    }
    return false;
  }

  static String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  @visibleForTesting
  static bool containsBytes(List<int> blob, List<int> needle) => _contains(blob, needle);
}
