import 'package:dart_mappable/dart_mappable.dart';

import '../../constants.dart';

part 'auth_state.mapper.dart';

@MappableClass()
class AuthState with AuthStateMappable {
  final Status status;

  /// i18n-ключ ошибки (не локализованная строка) — экран резолвит его сам.
  final String errorKey;

  /// Маршрут для перехода (с query), "" — никуда не переходить.
  /// Экран выполняет навигацию своим роутером и сбрасывает значение.
  final String redirectUrl;

  const AuthState({
    this.status = Status.initialization,
    this.errorKey = "",
    this.redirectUrl = "",
  });
}
