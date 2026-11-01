import 'package:cryptography/cryptography.dart';

import '../../di.dart';
import '../../logger.dart';
import '../../settings.dart';

/// Пиннинг ключа сервера (docs/plans/bootstrap-config.md, этап 4): ML-DSA-ключ
/// из `META_DATA_INFO`, которым сервер подписывает обмен ключами при входе,
/// должен совпасть с отпечатком из подписанного `config.json`
/// ([Settings.serverMlDsaFingerprint]). Иначе посредник с «доверенным»
/// TLS-сертификатом (чужой корневой, корпоративный прокси) подставил бы свой
/// ключ и получил ключи сессии. Отпечатка нет — не сверяем.
Future<bool> serverKeyTrusted(List<int> publicKey) async {
  final expected = getIt.get<Settings>().serverMlDsaFingerprint;
  if (expected.isEmpty) return true;
  final hash = await Sha256().hash(publicKey);
  final actual = hash.bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  if (actual == expected) return true;
  getIt.get<Logger>().error('server key: ML-DSA fingerprint $actual, expected $expected');
  return false;
}
