import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/screens/settings/settings_account_deletion_common.dart';

void main() {
  final now = DateTime(2026, 11, 3, 12);

  group('ru', () {
    setUpAll(() async {
      await AppLocale.ru.build();
    });

    test('показывает дни с правильным склонением', () {
      final text = accountDeletionScheduledText(AppLocale.ru.buildSync(), now.add(const Duration(days: 4)), now: now);
      expect(text, contains('(осталось 4 дня)'));
    });

    test('показывает часы, если осталось меньше дня', () {
      final text = accountDeletionScheduledText(AppLocale.ru.buildSync(), now.add(const Duration(hours: 5)), now: now);
      expect(text, contains('(осталось 5 часов)'));
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
  });
}
