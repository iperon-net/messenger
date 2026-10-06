import 'dart:math';

/// Код новой ссылки-приглашения: `+` и 12 символов base62 (ссылка —
/// `iperon.net/+код`). Настоящие выдаст сервер; пока — клиент (демо).
String newInviteCode() {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  return '+${List.generate(12, (_) => alphabet[random.nextInt(alphabet.length)]).join()}';
}
