import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:talker/talker.dart';

/// Персистентный файловый лог с ротацией. В отличие от in-memory истории talker
/// (`talker.history`, живёт только до перезапуска) пишет журнал на диск, чтобы
/// экспорт логов из меню «Разработчик» доставал в том числе логи **прошлой
/// сессии** — например, до краша/перезапуска (диагностика звонков, LiveKit FINE).
///
/// Хранит два поколения по [_maxFileSizeBytes] каждый (`iperon.log` — текущий,
/// `iperon.1.log` — предыдущий). При переполнении текущий становится предыдущим,
/// а прошлый предыдущий удаляется. Итоговый потолок по диску — 5 МБ × 2.
///
/// Запись батчевая: [write] лишь синхронно кладёт строку в буфер (вызывается из
/// [FileLogObserver.onLog] на горячем пути и не должна блокировать), а сброс на
/// диск идёт таймером раз в [_flushInterval] либо по достижении [_flushThreshold]
/// строк — иначе объёмные FINE-логи LiveKit били бы по I/O построчно.
class FileLogger {
  FileLogger({this.baseName = 'iperon'});

  /// База имени файлов. Для будущего фонового isolate (перезапускает
  /// `registerCommonDependencies` в свежем изоляте — см. CLAUDE.md) сюда стоит
  /// передать иной base, иначе два `IOSink` на один файл дадут гонки и битые
  /// строки.
  final String baseName;

  static const int _maxFileSizeBytes = 5 * 1024 * 1024; // 5 МБ на файл
  static const Duration _flushInterval = Duration(seconds: 1);
  static const int _flushThreshold = 200;

  File? _currentFile;
  File? _previousFile;
  IOSink? _sink;
  int _currentSize = 0;

  final List<String> _buffer = <String>[];
  Timer? _flushTimer;

  /// Сериализует асинхронные операции с sink (flush/rotate), чтобы ротация не
  /// пересекалась с обычным сбросом буфера.
  Future<void> _tail = Future<void>.value();

  bool _ready = false;

  /// Открывает (создаёт при необходимости) файлы и sink. Строки, накопленные в
  /// буфере до открытия, не теряются — они сбросятся первым же flush.
  Future<void> open() async {
    try {
      final base = await getApplicationSupportDirectory();
      final dir = Directory('${base.path}/logs');
      if (!dir.existsSync()) dir.createSync(recursive: true);

      _currentFile = File('${dir.path}/$baseName.log');
      _previousFile = File('${dir.path}/$baseName.1.log');
      _currentSize = _currentFile!.existsSync() ? _currentFile!.lengthSync() : 0;
      _sink = _currentFile!.openWrite(mode: FileMode.writeOnlyAppend);
      _ready = true;
    } catch (_) {
      // Логировать нечем (мы и есть логгер) — тихо отключаемся, in-memory лог и
      // консоль продолжают работать.
      _ready = false;
    }
  }

  /// Синхронно кладёт строку в буфер и планирует сброс. Никогда не бросает.
  void write(String line) {
    _buffer.add(line);
    if (_buffer.length >= _flushThreshold) {
      unawaited(flush());
      return;
    }
    _flushTimer ??= Timer(_flushInterval, () => unawaited(flush()));
  }

  /// Принудительно сбрасывает буфер на диск и ждёт завершения записи.
  Future<void> flush() {
    _flushTimer?.cancel();
    _flushTimer = null;
    _tail = _tail.then((_) => _drain());
    return _tail;
  }

  Future<void> _drain() async {
    if (!_ready || _sink == null || _buffer.isEmpty) return;

    final chunk = _buffer.join('\n');
    _buffer.clear();
    final bytes = utf8.encode('$chunk\n').length;

    try {
      if (_currentSize + bytes > _maxFileSizeBytes && _currentSize > 0) {
        await _rotate();
      }
      _sink!.writeln(chunk);
      await _sink!.flush();
      _currentSize += bytes;
    } catch (_) {
      // I/O-ошибку проглатываем: журналирование не должно валить приложение.
    }
  }

  Future<void> _rotate() async {
    try {
      await _sink?.flush();
      await _sink?.close();

      if (_previousFile!.existsSync()) _previousFile!.deleteSync();
      if (_currentFile!.existsSync()) _currentFile!.renameSync(_previousFile!.path);

      _sink = _currentFile!.openWrite(mode: FileMode.writeOnlyAppend);
      _currentSize = 0;
    } catch (_) {
      // Если ротация не удалась — пробуем переоткрыть sink на текущий файл,
      // чтобы не потерять запись насовсем.
      _sink = _currentFile!.openWrite(mode: FileMode.writeOnlyAppend);
    }
  }

  /// Всё содержимое журнала (предыдущий + текущий файл, в хронологическом
  /// порядке) для экспорта. Перед чтением досбрасывает буфер.
  Future<String> readAll() async {
    await flush();
    final out = StringBuffer();
    try {
      if (_previousFile?.existsSync() ?? false) {
        out.write(await _previousFile!.readAsString());
      }
      if (_currentFile?.existsSync() ?? false) {
        out.write(await _currentFile!.readAsString());
      }
    } catch (_) {
      // частичное чтение лучше, чем исключение в экспорте
    }
    return out.toString();
  }

  Future<void> dispose() async {
    await flush();
    await _tail;
    try {
      await _sink?.flush();
      await _sink?.close();
    } catch (_) {}
    _sink = null;
    _ready = false;
  }
}

/// Мост talker → [FileLogger]. talker разводит обычные логи (onLog) и
/// ошибки/исключения (onError/onException) по разным веткам — реализуем все три,
/// иначе ошибки в файл не попадут (дублей при этом нет, ветки не пересекаются).
class FileLogObserver extends TalkerObserver {
  FileLogObserver(this._fileLogger, {this.timeFormat = TimeFormat.timeAndSeconds});

  final FileLogger _fileLogger;
  final TimeFormat timeFormat;

  @override
  void onLog(TalkerData log) => _fileLogger.write(log.generateTextMessage(timeFormat: timeFormat));

  @override
  void onError(TalkerError err) => _fileLogger.write(err.generateTextMessage(timeFormat: timeFormat));

  @override
  void onException(TalkerException err) => _fileLogger.write(err.generateTextMessage(timeFormat: timeFormat));
}
