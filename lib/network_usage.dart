import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:livekit_client/livekit_client.dart';

import 'account_scope.dart';
import 'di.dart';
import 'logger.dart';
import 'models.dart' as models;
import 'repositories.dart';

/// Категория трафика файла по его MIME-типу; [fromChat] `false` — не вложение
/// сообщения (аватар, эмодзи) — «Прочее».
models.TrafficCategory trafficCategoryFor(String contentType, {required bool fromChat}) {
  if (!fromChat) return models.TrafficCategory.other;
  return switch (storageCategoryFor(contentType)) {
    models.StorageCategory.photos => models.TrafficCategory.photos,
    models.StorageCategory.videos => models.TrafficCategory.videos,
    models.StorageCategory.audio => models.TrafficCategory.audio,
    models.StorageCategory.files => models.TrafficCategory.files,
    models.StorageCategory.other => models.TrafficCategory.other,
  };
}

/// Тип файла вложения по MIME-типу (фото / видео / аудио и голосовые / файлы).
models.StorageCategory storageCategoryFor(String contentType) {
  final type = contentType.split(';').first.trim().toLowerCase();
  if (type.startsWith('image/')) return models.StorageCategory.photos;
  if (type.startsWith('video/')) return models.StorageCategory.videos;
  if (type.startsWith('audio/')) return models.StorageCategory.audio;
  return models.StorageCategory.files;
}

/// «Использование трафика» (как в Telegram): сколько отправлено и получено по
/// мобильной сети и Wi-Fi, по категориям. Считает само приложение — у iOS нет
/// счётчиков трафика по приложению, а Android `TrafficStats` даёт одну общую
/// цифру. Источники: gRPC (размер сообщений, без заголовков HTTP/2 и TLS —
/// чуть меньше реального), файлы CDN (байты тела ответа / чанков загрузки) и
/// звонки (статистика WebRTC-транспорта LiveKit).
///
/// Счётчики копятся в памяти и пишутся в базу аккаунта раз в [_flushDelay] —
/// [add] зовётся на каждое сообщение и сетевой чанк.
class NetworkUsage implements AccountService {
  NetworkUsage._(this._scope);

  final AccountScope _scope;

  static NetworkUsage get instance => of(AccountScope.current);

  /// Счётчик аккаунта [scope] — для сервисов, созданных до его активации
  /// (gRPC-клиент `API`).
  static NetworkUsage of(AccountScope scope) => scope.resolve(() => NetworkUsage._(scope));

  static const _flushDelay = Duration(seconds: 10);

  var _network = models.NetworkKind.wifi;
  StreamSubscription<List<ConnectivityResult>>? _connectivity;
  final _pending = <(models.NetworkKind, models.TrafficCategory), models.TrafficCounter>{};
  Timer? _flushTimer;
  var _disposed = false;

  /// Счётчики в базе изменились (запись накопленного, сброс).
  Stream<void> get changed => _changed.stream;
  final _changed = StreamController<void>.broadcast();

  /// Учесть трафик [category] по текущей сети.
  void add(models.TrafficCategory category, {int sent = 0, int received = 0}) {
    if (_disposed || (sent <= 0 && received <= 0)) return;
    _watchNetwork();
    final key = (_network, category);
    final counter = _pending[key];
    _pending[key] = models.TrafficCounter(sent: (counter?.sent ?? 0) + sent, received: (counter?.received ?? 0) + received);
    _flushTimer ??= Timer(_flushDelay, () {
      _flushTimer = null;
      unawaited(flush());
    });
  }

  void _watchNetwork() {
    if (_connectivity != null) return;
    final connectivity = Connectivity();
    _connectivity = connectivity.onConnectivityChanged.listen(_setNetwork);
    connectivity.checkConnectivity().then(_setNetwork).catchError((Object error, StackTrace stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    });
  }

  /// Wi-Fi или проводная — Wi-Fi (VPN поверх них не меняет сеть); только
  /// сотовая — мобильная.
  void _setNetwork(List<ConnectivityResult> results) {
    final wifi = results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.ethernet);
    _network = !wifi && results.contains(ConnectivityResult.mobile) ? models.NetworkKind.mobile : models.NetworkKind.wifi;
  }

  /// Записать накопленное в базу.
  Future<void> flush() async {
    _flushTimer?.cancel();
    _flushTimer = null;
    if (_pending.isEmpty) return;
    final batch = Map.of(_pending);
    _pending.clear();
    try {
      await _scope.repositories.dataUsage.addTraffic(batch);
      if (!_changed.isClosed) _changed.add(null);
    } catch (error, stackTrace) {
      // База ещё не открыта (самые первые запросы) или закрывается — вернём
      // в очередь, допишем следующей записью.
      for (final MapEntry(:key, :value) in batch.entries) {
        final counter = _pending[key];
        _pending[key] = models.TrafficCounter(sent: (counter?.sent ?? 0) + value.sent, received: (counter?.received ?? 0) + value.received);
      }
      getIt.get<Logger>().handle(error, stackTrace);
    }
  }

  /// Счётчики с начала отсчёта ([since]), включая ещё не записанное.
  Future<Map<(models.NetworkKind, models.TrafficCategory), models.TrafficCounter>> load() async {
    await flush();
    return _scope.repositories.dataUsage.traffic();
  }

  /// С какого момента считается; `null` — трафика ещё не было.
  Future<DateTime?> since() async {
    final value = await _scope.repositories.dataUsage.setting(DataUsageRepository.networkSinceKey);
    return value == null ? null : DateTime.fromMillisecondsSinceEpoch(value);
  }

  /// «Сбросить статистику».
  Future<void> reset() async {
    _pending.clear();
    _flushTimer?.cancel();
    _flushTimer = null;
    await _scope.repositories.dataUsage.resetTraffic(DateTime.now());
    if (!_changed.isClosed) _changed.add(null);
  }

  /// Переключение аккаунта: дописать накопленное, пока база открыта.
  @override
  Future<void> dispose() async {
    await flush();
    _disposed = true;
    await _connectivity?.cancel();
    _connectivity = null;
    await _changed.close();
  }
}

/// Трафик звонка: раз в [_interval] читает байты WebRTC-транспортов комнаты
/// (publisher / subscriber) и прибавляет прирост к «Звонкам». Последний
/// интервал перед отбоем теряется — опрашивать статистику во время разбора
/// комнаты нельзя (гонка с `pc.close()`, см. `Calls._teardown`).
class CallTraffic {
  CallTraffic(this._room) : _usage = NetworkUsage.instance;

  final Room _room;
  final NetworkUsage _usage;

  static const _interval = Duration(seconds: 5);

  Timer? _timer;
  var _polling = false;

  /// Последние значения по транспорту (publisher / subscriber): прирост
  /// считается от них.
  final _last = <String, ({int sent, int received})>{};

  void start() => _timer ??= Timer.periodic(_interval, (_) => _poll());

  /// Синхронно, до `room.disconnect()`: дальше статистику не читаем.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _poll() async {
    if (_polling) return;
    _polling = true;
    try {
      // Байты транспортов — только у peer connection движка (internal в
      // SDK): публичная статистика дорожек считает лишь полезную нагрузку RTP,
      // без заголовков, RTCP и канала данных.
      // ignore: invalid_use_of_internal_member
      final engine = _room.engine;
      // ignore: invalid_use_of_internal_member
      final transports = {'publisher': engine.publisher, 'subscriber': engine.subscriber};
      for (final MapEntry(key: name, value: transport) in transports.entries) {
        if (_timer == null || transport == null) continue;
        final reports = await transport.pc.getStats();
        var sent = 0;
        var received = 0;
        var found = false;
        for (final report in reports) {
          if (report.type != 'transport') continue;
          found = true;
          sent += _int(report.values['bytesSent']);
          received += _int(report.values['bytesReceived']);
        }
        // Нет отчёта transport — выбранная пара кандидатов.
        if (!found) {
          for (final report in reports) {
            if (report.type != 'candidate-pair' || report.values['nominated'] != true) continue;
            sent += _int(report.values['bytesSent']);
            received += _int(report.values['bytesReceived']);
          }
        }
        final last = _last[name];
        // Счётчик меньше прежнего — транспорт пересоздан (переподключение).
        final sentDelta = last == null || sent < last.sent ? sent : sent - last.sent;
        final receivedDelta = last == null || received < last.received ? received : received - last.received;
        _last[name] = (sent: sent, received: received);
        _usage.add(models.TrafficCategory.calls, sent: sentDelta, received: receivedDelta);
      }
    } catch (error, stackTrace) {
      getIt.get<Logger>().handle(error, stackTrace);
    } finally {
      _polling = false;
    }
  }

  static int _int(Object? value) => switch (value) {
    final num n => n.toInt(),
    final String s => int.tryParse(s) ?? 0,
    _ => 0,
  };
}
