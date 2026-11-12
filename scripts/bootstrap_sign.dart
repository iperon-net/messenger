// Подписанный bootstrap-конфиг (docs/plans/archive/bootstrap-config.md, формат —
// lib/bootstrap/bootstrap_file.dart).
//
//   dart run scripts/bootstrap_sign.dart keygen [--out bootstrap_signing.key]
//     Новая пара Ed25519: приватный ключ (base64) — в файл (0600), публичный —
//     в stdout: его в bootstrapPublicKeys, приватный — в секрет GitHub
//     `gh secret set BOOTSTRAP_SIGNING_KEY < bootstrap_signing.key`, файл удалить.
//
//   BOOTSTRAP_SIGNING_KEY=<base64> dart run scripts/bootstrap_sign.dart sign \
//       --serial 2 [--current old.json] \
//       [--environment staging --api staging.iperon.net:443 [--api backup:443] --fingerprint <hex> \
//        [--mldsa-fingerprint <hex>]] \
//       [--default staging] [--public-key <base64>] [--out config.json]
//     Подписать (вызывает workflow bootstrap.yaml). Окружения из --current
//     (прошлый файл, проверяется ключом сборки или --public-key) переносятся как есть, меняется
//     только --environment; --default — окружение новых аккаунтов (без него —
//     из --current, а в первом файле — это же --environment). --api
//     host:port[:insecure], первый — основной. --fingerprint — sha256 EdDSA-ключа
//     сервера, --mldsa-fingerprint — ML-DSA (его клиент сверяет при входе; без
//     него — из --current, если окружение там есть).
//
//   dart run scripts/bootstrap_sign.dart verify config.json [--public-key <base64>]
//     Проверить подпись ключом из сборки (или указанным) и показать содержимое.

import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:messenger/bootstrap/bootstrap_file.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) _usage();
  try {
    switch (args.first) {
      case 'keygen':
        await _keygen(_options(args.skip(1)));
      case 'sign':
        await _sign(_options(args.skip(1)));
      case 'verify':
        if (args.length < 2) _usage();
        await _verify(args[1], _options(args.skip(2)));
      default:
        _usage();
    }
  } on BootstrapException catch (error) {
    stderr.writeln(error.message);
    exit(1);
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exit(2);
  }
}

Never _usage() {
  stderr.writeln('usage: bootstrap_sign.dart keygen|sign|verify … (see the header of this file)');
  exit(64);
}

/// `--name value` (повторяющиеся — списком).
Map<String, List<String>> _options(Iterable<String> args) {
  final options = <String, List<String>>{};
  final list = args.toList();
  for (var i = 0; i < list.length; i += 2) {
    if (!list[i].startsWith('--') || i + 1 >= list.length) throw FormatException('bad option: ${list[i]}');
    options.putIfAbsent(list[i].substring(2), () => []).add(list[i + 1]);
  }
  return options;
}

String _one(Map<String, List<String>> options, String name, {String? fallback}) {
  final values = options[name];
  if (values == null || values.isEmpty) {
    if (fallback != null) return fallback;
    throw FormatException('--$name is required');
  }
  return values.last;
}

Future<void> _keygen(Map<String, List<String>> options) async {
  final out = File(_one(options, 'out', fallback: 'bootstrap_signing.key'));
  if (out.existsSync()) throw FormatException('${out.path} already exists');
  final pair = await Ed25519().newKeyPair();
  final seed = await pair.extractPrivateKeyBytes();
  final public = await pair.extractPublicKey();
  out.writeAsStringSync(base64.encode(seed));
  if (!Platform.isWindows) await Process.run('chmod', ['600', out.path]);
  stderr.writeln('private key → ${out.path} (put it into the BOOTSTRAP_SIGNING_KEY secret, then delete the file)');
  stdout.writeln(base64.encode(public.bytes));
}

Future<void> _sign(Map<String, List<String>> options) async {
  final seed = Platform.environment['BOOTSTRAP_SIGNING_KEY']?.trim() ?? '';
  if (seed.isEmpty) throw const FormatException('BOOTSTRAP_SIGNING_KEY is not set');
  final key = await Ed25519().newKeyPairFromSeed(base64.decode(seed));

  final serial = int.tryParse(_one(options, 'serial'));
  if (serial == null || serial < 1) throw const FormatException('--serial must be a positive integer');

  // Прошлый файл — только с подписью ключа сборки: иначе подменённый релиз
  // переподписался бы вместе с чужими адресами.
  final currentPath = options['current']?.last;
  final current = currentPath == null
      ? null
      : await BootstrapFile.verify(File(currentPath).readAsStringSync(), publicKeys: options['public-key'] ?? bootstrapPublicKeys);
  if (current != null && serial <= current.serial) throw FormatException('--serial must be > ${current.serial}');
  final environments = {...?current?.environments};

  final name = options['environment']?.last;
  if (name != null) {
    if (!bootstrapEnvironmentName.hasMatch(name)) throw FormatException('bad --environment $name');
    final api = [for (final value in options['api'] ?? const <String>[]) _api(value)];
    if (api.isEmpty) throw const FormatException('--api is required with --environment');
    final fingerprint = _one(options, 'fingerprint');
    if (!bootstrapFingerprint.hasMatch(fingerprint)) throw const FormatException('--fingerprint must be 64 lowercase hex chars');
    final mldsa = options['mldsa-fingerprint']?.last ?? environments[name]?.mldsaKeyFingerprint ?? '';
    if (mldsa.isNotEmpty && !bootstrapFingerprint.hasMatch(mldsa)) {
      throw const FormatException('--mldsa-fingerprint must be 64 lowercase hex chars');
    }
    environments[name] = BootstrapEnvironment(api: api, serverKeyFingerprint: fingerprint, mldsaKeyFingerprint: mldsa);
  }
  final defaultEnvironment = options['default']?.last ?? current?.defaultEnvironment ?? name;
  if (defaultEnvironment == null || !environments.containsKey(defaultEnvironment)) {
    throw FormatException('--default must be one of ${environments.keys.join(', ')}');
  }

  final file = BootstrapFile(
    serial: serial,
    issuedAt: DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000,
    defaultEnvironment: defaultEnvironment,
    environments: Map.fromEntries(environments.entries.toList()..sort((a, b) => a.key.compareTo(b.key))),
  );
  final signed = await file.sign(key);
  // Сразу проверить своим же публичным ключом: битая подпись не уйдёт в релиз.
  final public = base64.encode((await key.extractPublicKey()).bytes);
  await BootstrapFile.verify(signed, publicKeys: [public]);

  File(_one(options, 'out', fallback: 'config.json')).writeAsStringSync('$signed\n');
  stderr.writeln('signed serial $serial (default $defaultEnvironment: ${environments.keys.join(', ')}), key $public');
}

BootstrapApi _api(String value) {
  final parts = value.split(':');
  final port = parts.length >= 2 ? int.tryParse(parts[1]) : null;
  if (parts.length < 2 || parts.length > 3 || parts[0].isEmpty || port == null || port <= 0 || port > 65535) {
    throw FormatException('--api must be host:port[:insecure], got $value');
  }
  if (parts.length == 3 && parts[2] != 'insecure') throw FormatException('--api: unknown flag ${parts[2]}');
  return BootstrapApi(host: parts[0], port: port, secure: parts.length == 2);
}

Future<void> _verify(String path, Map<String, List<String>> options) async {
  final keys = options['public-key'] ?? bootstrapPublicKeys;
  if (keys.isEmpty) throw const FormatException('no public keys: bootstrapPublicKeys is empty, pass --public-key');
  final file = await BootstrapFile.verify(File(path).readAsStringSync(), publicKeys: keys);
  final issued = DateTime.fromMillisecondsSinceEpoch(file.issuedAt * 1000, isUtc: true);
  stdout.writeln('ok: serial ${file.serial}, issued $issued, default ${file.defaultEnvironment}');
  for (final entry in file.environments.entries) {
    final mldsa = entry.value.mldsaKeyFingerprint;
    stdout.writeln(
      '  ${entry.key}: ${entry.value.api.join(', ')}, fingerprint ${entry.value.serverKeyFingerprint}, mldsa ${mldsa.isEmpty ? '-' : mldsa}',
    );
  }
}
