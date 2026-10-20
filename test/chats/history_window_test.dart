import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/chats/history_window.dart';

// Окно «вокруг сообщения» (хвост 3.6): когда оно стыкуется с лентой и какой
// диапазон покрывает страница.
void main() {
  test('windowJoins: дошли до самого нового или до сверенной части', () {
    expect(windowJoins(high: 50, newer: false, floor: 100), isTrue);
    expect(windowJoins(high: 50, newer: true, floor: 100), isFalse);
    expect(windowJoins(high: 99, newer: true, floor: 100), isTrue);
    expect(windowJoins(high: 120, newer: true, floor: 100), isTrue);
    // Кэш пуст — стыковаться не с чем.
    expect(windowJoins(high: 99, newer: true, floor: 0), isFalse);
  });

  test('pageRange: от самого старого (или №1) до верха запроса', () {
    expect(pageRange([30, 25, 20], hasOlder: true), (from: 20, to: 30));
    expect(pageRange([30, 25, 20], hasOlder: false), (from: 1, to: 30));
    expect(pageRange([30, 25, 20], hasOlder: true, upper: 39), (from: 20, to: 39));
    expect(pageRange([], hasOlder: false, upper: 39), (from: 1, to: 39));
    expect(pageRange([], hasOlder: true, upper: 39), isNull);
  });

  test('HistoryWindow.contains', () {
    const window = HistoryWindow(low: 10, high: 20, older: true, newer: true);
    expect(window.contains(10), isTrue);
    expect(window.contains(21), isFalse);
    expect(window.copyWith(high: 30).contains(25), isTrue);
  });
}
