import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Домен-сепаратор клиентского pre-hash облачного пароля. Нужен, чтобы
/// транслируемое значение не совпадало ни с чужими rainbow-таблицами, ни с любым
/// другим местом, где мог бы хэшироваться пароль.
const _cloudPasswordDomain = 'iperon-cloud-pw-v1';

/// Клиентский pre-hash облачного пароля: `SHA-256(domain ‖ password)` (32 байта).
///
/// По проводу уходит ИМЕННО этот хэш, а не сам пароль — сервер поверх него считает
/// argon2id (см. серверный `crypto.HashPassword`). Плейнтекст пароля клиент никуда
/// не отправляет. Функция должна давать одинаковый результат во всех точках —
/// вход, установка, смена, восстановление, — иначе введённые пароли не совпадут.
/// См. docs/plans/hidden-toasting-mountain.md.
Future<Uint8List> cloudPasswordHash(String password) async {
  final data = utf8.encode('$_cloudPasswordDomain$password');
  final hash = await Sha256().hash(data);
  return Uint8List.fromList(hash.bytes);
}
