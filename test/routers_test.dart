import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/routers.dart';

void main() {
  group('redirectAuthLocation', () {
    test('гость попадает на авторизацию и остаётся на её вложенных маршрутах', () {
      expect(redirectAuthLocation('/chats', isAuthorized: false), '/auth');
      expect(redirectAuthLocation('/settings', isAuthorized: false), '/auth');
      expect(redirectAuthLocation('/auth', isAuthorized: false), isNull);
      expect(redirectAuthLocation('/auth/cloud_password', isAuthorized: false), isNull);
    });

    test('авторизованный пользователь не возвращается на экраны входа', () {
      expect(redirectAuthLocation('/chats', isAuthorized: true), isNull);
      expect(redirectAuthLocation('/profile/123', isAuthorized: true), isNull);
      expect(redirectAuthLocation('/auth', isAuthorized: true), '/chats');
      expect(redirectAuthLocation('/auth/call_password_confirmation', isAuthorized: true), '/chats');
    });
  });
}
