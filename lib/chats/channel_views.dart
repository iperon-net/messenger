import 'dart:async';
import 'dart:math' as math;

/// Запрос просмотров постов канала (`Messages.GetViews`): [increment] —
/// пометить [ids] просмотренными мной и вернуть числа, иначе — только числа.
/// `null` — нет сети: ничего не изменилось, повторить позже. Отказ сервера —
/// исключение.
typedef ChannelViewsFetch = Future<Map<int, int>?> Function(List<int> ids, {required bool increment});

/// Просмотры постов одного канала (подэтап 4.2, docs/plans/chats-channels.md,
/// как `messages.getMessagesViews` в Telegram):
/// - лента сообщает, какие посты сейчас на экране ([visible]); пост,
///   пробывший там не меньше [dwell], попадает в очередь на учёт;
/// - раз в [flushInterval] ([flush]) очередь уходит `GetViews(increment)`
///   пачками по [maxBatch]; учтённые помечаются локально и персистентно
///   ([viewed] / [markViewed]) — после перезапуска повторно не шлются;
/// - без сети очередь копится в памяти и уходит после подключения;
/// - для остальных видимых (уже учтённых) — `GetViews` без increment, не
///   чаще раза в [refreshInterval] на пост.
///
/// Числа в БД пишет [fetch] (лента перерисуется через `onChange`). Время —
/// [now] (в тестах — подменное), таймер — [attach] / [detach].
class ChannelViews {
  final ChannelViewsFetch fetch;

  /// Какие из id уже учтены (локальная пометка в БД).
  final Future<Set<int>> Function(List<int> ids) viewed;

  /// Пометить учтёнными (в БД).
  final Future<void> Function(List<int> ids) markViewed;

  final DateTime Function() now;

  ChannelViews({required this.fetch, required this.viewed, required this.markViewed, DateTime Function()? now}) : now = now ?? DateTime.now;

  /// Сколько пост должен пробыть на экране, чтобы считаться просмотренным.
  static const dwell = Duration(milliseconds: 500);

  /// Как часто уходит очередь.
  static const flushInterval = Duration(seconds: 2);

  /// Не чаще этого на пост — свежие числа без increment.
  static const refreshInterval = Duration(seconds: 30);

  /// Пауза после отказа сервера (лимит частоты, не канал …).
  static const failurePause = Duration(seconds: 30);

  /// Сервер принимает не больше 100 id за запрос.
  static const maxBatch = 100;

  /// На экране сейчас: id → с какого момента.
  final _visibleSince = <int, DateTime>{};

  /// Пробыли на экране ≥ [dwell], ещё не учтены сервером.
  final _pending = <int>{};

  /// Учтены (сервером или по локальной пометке).
  final _counted = <int>{};

  /// Когда числа поста обновлялись последний раз.
  final _refreshedAt = <int, DateTime>{};

  DateTime? _pausedUntil;
  bool _flushing = false;
  Timer? _timer;
  bool _attached = false;

  /// Ждут учёта (для тестов и для решения, держать ли таймер).
  Set<int> get pending => Set.unmodifiable(_pending);

  /// Уже учтены.
  Set<int> get counted => Set.unmodifiable(_counted);

  /// Посты [ids] сейчас на экране (снимок целиком: кого нет — ушли с экрана).
  void visible(Iterable<int> ids) {
    final t = now();
    final current = ids.toSet();
    _promote(t);
    _visibleSince.removeWhere((id, _) => !current.contains(id));
    for (final id in current) {
      _visibleSince.putIfAbsent(id, () => t);
    }
  }

  /// Пробывшие на экране ≥ [dwell] — в очередь на учёт.
  void _promote(DateTime t) {
    for (final MapEntry(key: id, value: since) in _visibleSince.entries) {
      if (!_counted.contains(id) && t.difference(since) >= dwell) _pending.add(id);
    }
  }

  /// Окно канала открыто: очередь уходит по таймеру.
  void attach() {
    _attached = true;
    _timer ??= Timer.periodic(flushInterval, (_) => unawaited(_tick()));
  }

  /// Окно закрыто: на экране ничего; неотправленная очередь уйдёт, когда
  /// появится сеть (таймер живёт, пока она не пуста).
  void detach() {
    _attached = false;
    visible(const []);
    if (_pending.isEmpty) _stop();
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    await flush();
    if (!_attached && _pending.isEmpty) _stop();
  }

  /// Один проход: очередь на учёт, затем свежие числа видимых.
  Future<void> flush() async {
    if (_flushing) return;
    final paused = _pausedUntil;
    if (paused != null && now().isBefore(paused)) return;
    _flushing = true;
    try {
      _promote(now());
      if (!await _sendPending()) return;
      await _refreshVisible();
    } catch (_) {
      // Отказ сервера: очередь остаётся, пауза — без потока повторов.
      _pausedUntil = now().add(failurePause);
    } finally {
      _flushing = false;
    }
  }

  /// `false` — нет сети (дальше в этом проходе не идём).
  Future<bool> _sendPending() async {
    while (_pending.isNotEmpty) {
      final batch = _pending.take(maxBatch).toList();
      // Учтённые раньше (до перезапуска) — не повторяем.
      final already = await viewed(batch);
      if (already.isNotEmpty) {
        _pending.removeAll(already);
        _counted.addAll(already);
      }
      final ids = [
        for (final id in batch)
          if (!already.contains(id)) id,
      ];
      if (ids.isEmpty) continue;
      final result = await fetch(ids, increment: true);
      if (result == null) return false;
      final t = now();
      _pending.removeAll(ids);
      _counted.addAll(ids);
      for (final id in ids) {
        _refreshedAt[id] = t;
      }
      await markViewed(ids);
    }
    return true;
  }

  Future<void> _refreshVisible() async {
    final t = now();
    final due = [
      for (final id in _visibleSince.keys)
        if (_counted.contains(id) && !_pending.contains(id) && _due(id, t)) id,
    ];
    for (var from = 0; from < due.length; from += maxBatch) {
      final ids = due.sublist(from, math.min(due.length, from + maxBatch));
      final result = await fetch(ids, increment: false);
      if (result == null) return;
      for (final id in ids) {
        _refreshedAt[id] = t;
      }
    }
  }

  bool _due(int id, DateTime t) {
    final last = _refreshedAt[id];
    return last == null || t.difference(last) >= refreshInterval;
  }
}
