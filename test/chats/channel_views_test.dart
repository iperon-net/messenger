import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/channel_views.dart';

// Просмотры постов канала (подэтап 4.2, docs/plans/chats-channels.md):
// очередь ChannelViews на подменном времени — порог 0,5 с на экране, учёт
// один раз (и после перезапуска — по локальной пометке), без сети очередь
// ждёт, свежие числа видимых — не чаще раза в 30 с на пост.
void main() {
  late DateTime clock;
  late List<({List<int> ids, bool increment})> calls;
  late Set<int> stored;
  late bool online;
  Object? failure;

  ChannelViews create() => ChannelViews(
    now: () => clock,
    fetch: (ids, {required increment}) async {
      if (failure case final error?) throw error;
      if (!online) return null;
      calls.add((ids: ids, increment: increment));
      return {for (final id in ids) id: 10};
    },
    viewed: (ids) async => {
      for (final id in ids)
        if (stored.contains(id)) id,
    },
    markViewed: (ids) async => stored.addAll(ids),
  );

  void wait(Duration d) => clock = clock.add(d);

  setUp(() {
    clock = DateTime(2026, 10, 22, 12);
    calls = [];
    stored = {};
    online = true;
    failure = null;
  });

  test('меньше 0,5 с на экране — не просмотр', () async {
    final views = create();
    views.visible([1, 2]);
    wait(const Duration(milliseconds: 300));
    views.visible([2]);
    wait(const Duration(milliseconds: 100));
    await views.flush();
    expect(calls, isEmpty);
    expect(views.pending, isEmpty);
  });

  test('≥ 0,5 с — один GetViews(increment), повторно не шлётся', () async {
    final views = create();
    views.visible([1, 2]);
    wait(const Duration(milliseconds: 500));
    await views.flush();
    expect(calls, hasLength(1));
    expect(calls.single.increment, isTrue);
    expect(calls.single.ids.toSet(), {1, 2});
    expect(stored, {1, 2});
    expect(views.counted, {1, 2});

    // Ушли с экрана и вернулись — increment не повторяется.
    views.visible(const []);
    views.visible([1, 2]);
    wait(const Duration(seconds: 2));
    await views.flush();
    expect(calls.where((c) => c.increment), hasLength(1));
  });

  test('пост ушёл с экрана после порога — всё равно учитывается', () async {
    final views = create();
    views.visible([5]);
    wait(const Duration(milliseconds: 600));
    views.visible(const []);
    await views.flush();
    expect(calls.single.ids, [5]);
    expect(calls.single.increment, isTrue);
  });

  test('учтённые до перезапуска (пометка в БД) — без increment', () async {
    stored = {1};
    final views = create();
    views.visible([1, 2]);
    wait(const Duration(seconds: 1));
    await views.flush();
    final increments = calls.where((c) => c.increment).toList();
    expect(increments.single.ids, [2]);
    // Пост 1 — только свежие числа.
    expect(calls.where((c) => !c.increment).single.ids, [1]);
  });

  test('без сети очередь копится и уходит после подключения', () async {
    online = false;
    final views = create();
    views.visible([1]);
    wait(const Duration(seconds: 1));
    await views.flush();
    views.visible([1, 2]);
    wait(const Duration(seconds: 1));
    await views.flush();
    expect(calls, isEmpty);
    expect(views.pending, {1, 2});
    expect(stored, isEmpty);

    views.visible(const []);
    online = true;
    await views.flush();
    expect(calls.single.increment, isTrue);
    expect(calls.single.ids.toSet(), {1, 2});
    expect(views.pending, isEmpty);
    expect(stored, {1, 2});
  });

  test('свежие числа видимых — не чаще раза в 30 с на пост', () async {
    final views = create();
    views.visible([1]);
    wait(const Duration(seconds: 1));
    await views.flush(); // increment
    for (var i = 0; i < 14; i++) {
      wait(ChannelViews.flushInterval);
      views.visible([1]);
      await views.flush();
    }
    // 28 с после учёта — ещё без обновления.
    expect(calls.where((c) => !c.increment), isEmpty);
    wait(const Duration(seconds: 2));
    views.visible([1]);
    await views.flush();
    expect(calls.where((c) => !c.increment).single.ids, [1]);
    wait(ChannelViews.flushInterval);
    await views.flush();
    expect(calls.where((c) => !c.increment), hasLength(1));
  });

  test('невидимые не обновляются', () async {
    final views = create();
    views.visible([1]);
    wait(const Duration(seconds: 1));
    await views.flush();
    views.visible(const []);
    wait(const Duration(minutes: 5));
    await views.flush();
    expect(calls, hasLength(1));
  });

  test('больше 100 — пачками по 100', () async {
    final views = create();
    views.visible([for (var i = 1; i <= 250; i++) i]);
    wait(const Duration(seconds: 1));
    await views.flush();
    expect([for (final c in calls) c.ids.length], [100, 100, 50]);
    expect(calls.every((c) => c.increment), isTrue);
  });

  test('отказ сервера — очередь цела, пауза 30 с', () async {
    final views = create();
    views.visible([1]);
    wait(const Duration(seconds: 1));
    failure = Exception('flood');
    await views.flush();
    expect(views.pending, {1});
    failure = null;
    wait(const Duration(seconds: 10));
    await views.flush();
    expect(calls, isEmpty);
    wait(const Duration(seconds: 21));
    await views.flush();
    expect(calls.single.ids, [1]);
    expect(calls.single.increment, isTrue);
  });
}
