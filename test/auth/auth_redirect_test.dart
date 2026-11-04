import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/routers.dart';

void main() {
  test('неавторизованный пользователь перенаправляется из приложения на /auth', () {
    expect(redirectAuthLocation('/chats', isAuthorized: false), '/auth');
    expect(redirectAuthLocation('/settings', isAuthorized: false), '/auth');
  });

  test('неавторизованный пользователь остаётся на текущем шаге входа', () {
    expect(redirectAuthLocation('/auth', isAuthorized: false), isNull);
    expect(redirectAuthLocation('/auth/cloud_password', isAuthorized: false), isNull);
  });

  test('авторизованный пользователь не может повторно открыть вход', () {
    expect(redirectAuthLocation('/auth', isAuthorized: true), '/chats');
    expect(redirectAuthLocation('/auth/cloud_password', isAuthorized: true), '/chats');
  });

  test('авторизованный пользователь остаётся на маршруте приложения', () {
    expect(redirectAuthLocation('/chats', isAuthorized: true), isNull);
    expect(redirectAuthLocation('/settings', isAuthorized: true), isNull);
  });
}
