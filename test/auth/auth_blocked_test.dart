import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/cubit/auth/auth_login_completer.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:messenger/screens/auth/auth_blocked_common.dart';

void main() {
  late Translations t;

  setUpAll(() async {
    t = await AppLocale.ru.build();
  });

  test('трейлер блокировки → маршрут экрана и обратно', () {
    final uri = accountBlockedURI({
      'iperon-block-reason': 'spam',
      'iperon-block-until': '1900000000',
      'iperon-support': 'support@iperon.net',
    });
    expect(uri, startsWith('/auth/blocked?'));

    final info = AuthBlockedInfo.fromQuery(Uri.parse(uri).queryParameters);
    expect(info.known, isTrue);
    expect(info.reason, 'spam');
    expect(info.until, DateTime.fromMillisecondsSinceEpoch(1900000000 * 1000));
    expect(info.support, 'support@iperon.net');
    expect(info.reasonText(t), 'Причина: спам');
    expect(info.termText(t), startsWith('Блокировка действует до '));
  });

  test('навсегда и без подробностей', () {
    final forever = AuthBlockedInfo.fromQuery(Uri.parse(accountBlockedURI({'iperon-block-reason': 'weird'})).queryParameters);
    expect(forever.until, isNull);
    expect(forever.termText(t), 'Блокировка бессрочная.');
    expect(forever.reasonText(t), 'Причина: нарушение правил');

    expect(accountBlockedURI(const {}), '/auth/blocked');
    expect(AuthBlockedInfo.fromQuery(const {}).known, isFalse);
  });
}
