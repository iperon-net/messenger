import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_qr_state.mapper.dart';

/// Вход на десктопе по QR ([AuthQrCubit]).
@MappableClass()
class AuthQrState with AuthQrStateMappable {
  /// loading — получаем токен; success — QR на экране.
  final Status status;

  /// Содержимое QR (`iperon://login?token=…`); пусто — ещё нет.
  final String qrData;

  /// Нет связи / сбой (i18n-ключ) — показать «Повторить».
  final String error;

  /// Вход подтверждён: куда перейти (облачный пароль или `/chats`).
  final String redirectURI;

  /// Подтвердили на телефоне — завершаем вход (обмен ключами).
  final bool completing;

  const AuthQrState({
    this.status = Status.initialization,
    this.qrData = "",
    this.error = "",
    this.redirectURI = "",
    this.completing = false,
  });
}
