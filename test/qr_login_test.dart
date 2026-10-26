import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/cubit/auth/auth_qr_cubit.dart';

// QR входа на десктопе: что показывает десктоп, то разбирает сканер телефона.
void main() {
  test('токен переживает QR туда и обратно', () {
    final token = List<int>.generate(32, (i) => i * 7 % 256);
    final data = qrLoginData(token);
    expect(data, startsWith('iperon://login?token='));
    expect(data.substring('iperon://login?token='.length), isNot(contains('=')));
    expect(parseQrLoginToken(data), token);
  });

  test('чужие QR — не вход', () {
    expect(parseQrLoginToken('https://iperon.net/login?token=AAAA'), isNull);
    expect(parseQrLoginToken('iperon://chat?token=AAAA'), isNull);
    expect(parseQrLoginToken('iperon://login'), isNull);
    expect(parseQrLoginToken('iperon://login?token=%%%'), isNull);
    expect(parseQrLoginToken('просто текст'), isNull);
  });
}
