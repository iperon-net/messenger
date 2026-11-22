import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/split_layout.dart';

// См. docs/plans/05-iphone-duo.md: сплит на складном iPhone определяется
// геометрией дисплея — на симуляторе hw.machine отдаёт архитектуру хоста,
// поэтому идентификатор модели не годится.
void main() {
  group('SplitLayout.isDuoScreenSize', () {
    test('дисплеи iPhone Duo — tablet-класс, в любой ориентации', () {
      // Внешний дисплей, портрет (466×678 pt).
      expect(SplitLayout.isDuoScreenSize(const Size(466, 678)), isTrue);
      // Внутренний дисплей, портрет (669×951 pt) и landscape (951×669 pt).
      expect(SplitLayout.isDuoScreenSize(const Size(669, 951)), isTrue);
      expect(SplitLayout.isDuoScreenSize(const Size(951, 669)), isTrue);
    });

    test('обычные iPhone — нет, в любой ориентации', () {
      // iPhone 17 (393×852), iPhone 17 Pro Max (440×956), iPhone SE (375×667),
      // Pro Max в landscape: соотношение сторон ~0.46 < 0.6.
      expect(SplitLayout.isDuoScreenSize(const Size(393, 852)), isFalse);
      expect(SplitLayout.isDuoScreenSize(const Size(440, 956)), isFalse);
      expect(SplitLayout.isDuoScreenSize(const Size(375, 667)), isFalse);
      expect(SplitLayout.isDuoScreenSize(const Size(956, 440)), isFalse);
    });
  });

  test('порог по умолчанию — iPad/десктоп 700, складной iPhone 600', () {
    expect(SplitLayout.minWidth, 700.0);
    expect(SplitLayout.duoMinWidth, 600.0);
  });
}
