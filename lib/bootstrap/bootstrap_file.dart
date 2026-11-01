import 'dart:convert';

import 'package:cryptography/cryptography.dart';

/// Подписанный bootstrap-конфиг (docs/plans/bootstrap-config.md): адреса серверов
/// по окружениям и отпечатки их ключей — то, что нужно знать до подключения. Файл
/// `config.json` раздаёт download.iperon.net (из GitHub Release `bootstrap`),
/// подписывает workflow `bootstrap.yaml` скриптом `scripts/bootstrap_sign.dart`.
///
/// Только чистый Dart (без Flutter) — тот же код проверяет подпись в скрипте и
/// в клиенте.

/// Публичные ключи Ed25519 (base64), которым доверяет сборка: текущий и, при
/// ротации, следующий. Приватный — секрет GitHub `BOOTSTRAP_SIGNING_KEY`.
const bootstrapPublicKeys = <String>['NqqBmWM51VZtGAeVqIl5pb+bilyKs/d7dnY4a5+Ea1U='];

/// Адрес gRPC-сервера.
class BootstrapApi {
  final String host;
  final int port;
  final bool secure;

  const BootstrapApi({required this.host, required this.port, required this.secure});

  Map<String, Object?> toJson() => {'host': host, 'port': port, 'secure': secure};

  @override
  String toString() => '$host:$port${secure ? '' : ' (insecure)'}';
}

/// Файл не прошёл проверку: битый JSON, нет подписи, подпись не сходится.
class BootstrapException implements Exception {
  final String message;

  const BootstrapException(this.message);

  @override
  String toString() => 'BootstrapException: $message';
}

/// Адреса и ключ одного окружения (`production`, `staging`, …). Окружение —
/// свойство аккаунта (`accounts.environment` в device.db): приложение одно, на
/// стейдж ходят аккаунты, добавленные туда с экрана «Разработчик».
class BootstrapEnvironment {
  /// Первый — основной, остальные — запасные.
  final List<BootstrapApi> api;

  /// sha256 (hex) EdDSA-ключа сервера (бывший `PUBLIC_KEY_EDDSA_FINGERPRINT`
  /// Remote Config). Клиент его не проверяет; поле обязательное — его требуют
  /// сборки 0.0.604–0.0.605.
  final String serverKeyFingerprint;

  /// sha256 (hex) ML-DSA-ключа сервера (`MetadataInfo.mldsa`): им сервер
  /// подписывает обмен ключами при входе — клиент сверяет ключ с этим
  /// отпечатком (этап 4, пиннинг). '' — не проверять (файл без поля).
  final String mldsaKeyFingerprint;

  const BootstrapEnvironment({required this.api, required this.serverKeyFingerprint, this.mldsaKeyFingerprint = ''});

  Map<String, Object?> toJson() => {
    'api': [for (final entry in api) entry.toJson()],
    'serverKeyFingerprint': serverKeyFingerprint,
    if (mldsaKeyFingerprint.isNotEmpty) 'mldsaKeyFingerprint': mldsaKeyFingerprint,
  };

  static BootstrapEnvironment _parse(String name, Object? json) {
    if (json is! Map) throw BootstrapException('environment $name: not an object');
    final api = json['api'], fingerprint = json['serverKeyFingerprint'], mldsa = json['mldsaKeyFingerprint'] ?? '';
    if (fingerprint is! String) throw BootstrapException('environment $name: bad serverKeyFingerprint');
    if (mldsa is! String || (mldsa.isNotEmpty && !bootstrapFingerprint.hasMatch(mldsa))) {
      throw BootstrapException('environment $name: bad mldsaKeyFingerprint');
    }
    if (api is! List || api.isEmpty) throw BootstrapException('environment $name: no api');
    final entries = <BootstrapApi>[];
    for (final entry in api) {
      if (entry is! Map) throw BootstrapException('environment $name: bad api entry');
      final host = entry['host'], port = entry['port'], secure = entry['secure'];
      if (host is! String || host.isEmpty || port is! int || port <= 0 || port > 65535 || secure is! bool) {
        throw BootstrapException('environment $name: bad api entry');
      }
      entries.add(BootstrapApi(host: host, port: port, secure: secure));
    }
    return BootstrapEnvironment(api: entries, serverKeyFingerprint: fingerprint, mldsaKeyFingerprint: mldsa);
  }
}

/// Имя окружения: строчные латинские буквы, цифры, дефис.
final bootstrapEnvironmentName = RegExp(r'^[a-z0-9][a-z0-9-]{0,31}$');

/// Отпечаток ключа: sha256 в hex, строчными.
final bootstrapFingerprint = RegExp(r'^[0-9a-f]{64}$');

class BootstrapFile {
  /// Монотонный номер: клиент не принимает файл старше закэшированного.
  final int serial;

  /// Когда подписан (секунды от эпохи, UTC).
  final int issuedAt;

  /// Окружение новых аккаунтов (пока прода нет — `staging`).
  final String defaultEnvironment;

  final Map<String, BootstrapEnvironment> environments;

  const BootstrapFile({required this.serial, required this.issuedAt, required this.defaultEnvironment, required this.environments});

  /// Поля без подписи — то, что подписывается (в каноническом виде).
  Map<String, Object?> toUnsignedJson() => {
    'serial': serial,
    'issuedAt': issuedAt,
    'defaultEnvironment': defaultEnvironment,
    'environments': {for (final entry in environments.entries) entry.key: entry.value.toJson()},
  };

  /// Подписанный файл: поля + `signature` (Ed25519 от [canonicalJson] полей).
  Future<String> sign(SimpleKeyPair key) async {
    final unsigned = toUnsignedJson();
    final signature = await Ed25519().sign(utf8.encode(canonicalJson(unsigned)), keyPair: key);
    final signed = {...unsigned, 'signature': base64.encode(signature.bytes)};
    return const JsonEncoder.withIndent('  ').convert(signed);
  }

  /// Разбор и проверка подписи одним из [publicKeys] (base64). Бросает
  /// [BootstrapException], если файл битый или подпись не сходится.
  static Future<BootstrapFile> verify(String text, {List<String> publicKeys = bootstrapPublicKeys}) async {
    final Object? decoded;
    try {
      decoded = jsonDecode(text);
    } on FormatException catch (error) {
      throw BootstrapException('not JSON: ${error.message}');
    }
    if (decoded is! Map<String, Object?>) throw const BootstrapException('not an object');
    final signatureText = decoded['signature'];
    if (signatureText is! String) throw const BootstrapException('no signature');
    final List<int> signatureBytes;
    try {
      signatureBytes = base64.decode(signatureText);
    } on FormatException {
      throw const BootstrapException('signature is not base64');
    }
    final unsigned = Map<String, Object?>.of(decoded)..remove('signature');
    final message = utf8.encode(canonicalJson(unsigned));

    var valid = false;
    for (final key in publicKeys) {
      final publicKey = SimplePublicKey(base64.decode(key), type: KeyPairType.ed25519);
      if (await Ed25519().verify(message, signature: Signature(signatureBytes, publicKey: publicKey))) {
        valid = true;
        break;
      }
    }
    if (!valid) throw const BootstrapException('bad signature');
    return _parse(unsigned);
  }

  static BootstrapFile _parse(Map<String, Object?> json) {
    final serial = json['serial'], issuedAt = json['issuedAt'];
    final defaultEnvironment = json['defaultEnvironment'], environments = json['environments'];
    if (serial is! int || serial < 1) throw const BootstrapException('bad serial');
    if (issuedAt is! int) throw const BootstrapException('bad issuedAt');
    if (environments is! Map || environments.isEmpty) throw const BootstrapException('no environments');
    final parsed = <String, BootstrapEnvironment>{};
    for (final entry in environments.entries) {
      final name = entry.key;
      if (name is! String || !bootstrapEnvironmentName.hasMatch(name)) throw BootstrapException('bad environment name $name');
      parsed[name] = BootstrapEnvironment._parse(name, entry.value);
    }
    if (defaultEnvironment is! String || !parsed.containsKey(defaultEnvironment)) {
      throw const BootstrapException('defaultEnvironment is not in environments');
    }
    return BootstrapFile(serial: serial, issuedAt: issuedAt, defaultEnvironment: defaultEnvironment, environments: parsed);
  }
}

/// Каноническая сериализация для подписи: ключи объектов по алфавиту (на всех
/// уровнях), без пробелов; порядок в списках сохраняется.
String canonicalJson(Object? value) => jsonEncode(_sorted(value));

Object? _sorted(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((key) => key as String).toList()..sort();
    return {for (final key in keys) key: _sorted(value[key])};
  }
  if (value is List) return [for (final item in value) _sorted(item)];
  return value;
}

/// Откуда клиент берёт файл, по порядку: свой домен (nginx, кэш 5 мин), затем
/// GitHub Release напрямую — если домен недоступен или отдаёт старое.
const bootstrapMirrors = <String>[
  'https://download.iperon.net/config.json',
  'https://github.com/iperon-net/messenger/releases/download/bootstrap/config.json',
];

/// Скачанный и проверенный файл: разобранный и его текст (в кэш как есть).
typedef BootstrapDownload = ({BootstrapFile file, String text});

/// Первый файл с зеркал [mirrors], который проходит проверку подписи и не
/// старше [currentSerial] (равный — «без изменений»). Зеркало, отдавшее
/// ошибку, битый или более старый файл (откат, устаревший кэш), пропускается
/// ([onSkip] — для лога). Null — ни одно не подошло.
Future<BootstrapDownload?> fetchBootstrapFile({
  required Future<String> Function(Uri uri) fetch,
  required int currentSerial,
  List<String> mirrors = bootstrapMirrors,
  List<String> publicKeys = bootstrapPublicKeys,
  void Function(Uri uri, Object reason)? onSkip,
}) async {
  for (final mirror in mirrors) {
    final uri = Uri.parse(mirror);
    try {
      final text = await fetch(uri);
      final file = await BootstrapFile.verify(text, publicKeys: publicKeys);
      if (file.serial < currentSerial) {
        onSkip?.call(uri, 'serial ${file.serial} < $currentSerial');
        continue;
      }
      return (file: file, text: text);
    } catch (error) {
      onSkip?.call(uri, error);
    }
  }
  return null;
}
