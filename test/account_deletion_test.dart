import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/screens/settings/settings_account_deletion_common.dart';

void main() {
  final now = DateTime(2026, 11, 3, 12);

  group('ru', () {
    setUpAll(() async {
      await AppLocale.ru.build();
    });

    test('показывает дни, часы и минуты с правильным склонением', () {
      final text = accountDeletionScheduledText(
        AppLocale.ru.buildSync(),
        now.add(const Duration(days: 6, hours: 23, minutes: 5)),
        now: now,
      );
      expect(text, contains('(осталось 6 дней, 23 часа, 5 минут)'));
    });

    test('не показывает нулевые старшие единицы', () {
      final text = accountDeletionScheduledText(AppLocale.ru.buildSync(), now.add(const Duration(hours: 5, minutes: 6)), now: now);
      expect(text, contains('(осталось 5 часов, 6 минут)'));
    });

    test('показывает минуты, если осталось меньше часа', () {
      final text = accountDeletionScheduledText(AppLocale.ru.buildSync(), now.add(const Duration(minutes: 6)), now: now);
      expect(text, contains('(осталось 6 минут)'));
    });
  });

  group('en', () {
    setUpAll(() async {
      await AppLocale.en.build();
    });

    test('показывает локализованный остаток', () {
      final text = accountDeletionScheduledText(AppLocale.en.buildSync(), now.add(const Duration(hours: 5)), now: now);
      expect(text, contains('(5 hours left)'));
    });

    testWidgets('обновляет остаток по таймеру', (tester) async {
      var current = DateTime(2026, 11, 3, 12);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AccountDeletionScheduledText(
            t: AppLocale.en.buildSync(),
            scheduled: current.add(const Duration(seconds: 61)),
            now: () => current,
          ),
        ),
      );
      expect(find.textContaining('(1 minute left)'), findsOneWidget);

      current = current.add(const Duration(seconds: 2));
      await tester.pump(const Duration(seconds: 2));
      expect(find.textContaining('(0 minutes left)'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
