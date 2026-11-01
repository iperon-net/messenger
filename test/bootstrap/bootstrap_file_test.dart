import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/bootstrap/bootstrap_file.dart';

void main() {
  const fingerprint = '7abfc2a7e8ea09ae384bdeb855cfeae24d60bfac3646046e754fddc8d5ab604d';
  const mldsa = 'e14b67f0691cfdcdb5a29fdc44c6c7f225f07b88f574821473b27b84f15894c7';
  const file = BootstrapFile(
    serial: 3,
    issuedAt: 1793260800,
    defaultEnvironment: 'staging',
    environments: {
      'staging': BootstrapEnvironment(
        api: [
          BootstrapApi(host: 'staging.iperon.net', port: 443, secure: true),
          BootstrapApi(host: 'backup.example', port: 8443, secure: false),
        ],
        serverKeyFingerprint: fingerprint,
      ),
      'production': BootstrapEnvironment(
        api: [BootstrapApi(host: 'iperon.net', port: 443, secure: true)],
        serverKeyFingerprint: fingerprint,
        mldsaKeyFingerprint: mldsa,
      ),
    },
  );

  late SimpleKeyPair key;
  late String publicKey;
  setUpAll(() async {
    key = await Ed25519().newKeyPairFromSeed(List.filled(32, 7));
    publicKey = base64.encode((await key.extractPublicKey()).bytes);
  });

  Future<Map<String, Object?>> signedJson() async => jsonDecode(await file.sign(key)) as Map<String, Object?>;

  test('канонический JSON: ключи по алфавиту на всех уровнях, без пробелов', () {
    expect(
      canonicalJson({
        'b': 1,
        'a': [
          {'y': true, 'x': 'z'},
        ],
      }),
      '{"a":[{"x":"z","y":true}],"b":1}',
    );
  });

  test('подписанный файл проходит проверку и разбирается по окружениям', () async {
    final parsed = await BootstrapFile.verify(await file.sign(key), publicKeys: [publicKey]);
    expect(parsed.serial, 3);
    expect(parsed.issuedAt, 1793260800);
    expect(parsed.defaultEnvironment, 'staging');
    expect(parsed.environments.keys, unorderedEquals(['staging', 'production']));
    expect(parsed.environments['staging']!.api.map((api) => api.toString()), ['staging.iperon.net:443', 'backup.example:8443 (insecure)']);
    expect(parsed.environments['production']!.serverKeyFingerprint, fingerprint);
    // ML-DSA-отпечаток — необязательный: без поля — пусто (не сверять).
    expect(parsed.environments['production']!.mldsaKeyFingerprint, mldsa);
    expect(parsed.environments['staging']!.mldsaKeyFingerprint, '');
  });

  test('порядок полей в файле на подпись не влияет', () async {
    final signed = await signedJson();
    final reordered = {for (final key in signed.keys.toList().reversed) key: signed[key]};
    expect((await BootstrapFile.verify(jsonEncode(reordered), publicKeys: [publicKey])).serial, 3);
  });

  test('изменённый адрес или окружение по умолчанию — подпись не сходится', () async {
    final host = await signedJson();
    ((host['environments'] as Map)['production']['api'] as List).first['host'] = 'evil.example';
    expect(() => BootstrapFile.verify(jsonEncode(host), publicKeys: [publicKey]), throwsA(isA<BootstrapException>()));

    final defaultEnvironment = await signedJson();
    defaultEnvironment['defaultEnvironment'] = 'production';
    expect(() => BootstrapFile.verify(jsonEncode(defaultEnvironment), publicKeys: [publicKey]), throwsA(isA<BootstrapException>()));
  });

  test('чужой ключ — отказ; среди нескольких ключей подходит свой', () async {
    final other = base64.encode((await (await Ed25519().newKeyPairFromSeed(List.filled(32, 9))).extractPublicKey()).bytes);
    final signed = await file.sign(key);
    expect(() => BootstrapFile.verify(signed, publicKeys: [other]), throwsA(isA<BootstrapException>()));
    expect((await BootstrapFile.verify(signed, publicKeys: [other, publicKey])).serial, 3);
  });

  test('без подписи, не JSON, окружение по умолчанию вне списка — отказ', () async {
    expect(() => BootstrapFile.verify(jsonEncode(file.toUnsignedJson()), publicKeys: [publicKey]), throwsA(isA<BootstrapException>()));
    expect(() => BootstrapFile.verify('{', publicKeys: [publicKey]), throwsA(isA<BootstrapException>()));
    final orphan = BootstrapFile(
      serial: 1,
      issuedAt: 0,
      defaultEnvironment: 'production',
      environments: {'staging': file.environments['staging']!},
    );
    expect(() async => BootstrapFile.verify(await orphan.sign(key), publicKeys: [publicKey]), throwsA(isA<BootstrapException>()));
  });

  test('битый ML-DSA-отпечаток — отказ даже с верной подписью', () async {
    final bad = BootstrapFile(
      serial: 1,
      issuedAt: 0,
      defaultEnvironment: 'staging',
      environments: {
        'staging': BootstrapEnvironment(
          api: file.environments['staging']!.api,
          serverKeyFingerprint: fingerprint,
          mldsaKeyFingerprint: 'XYZ',
        ),
      },
    );
    expect(() async => BootstrapFile.verify(await bad.sign(key), publicKeys: [publicKey]), throwsA(isA<BootstrapException>()));
  });

  group('fetchBootstrapFile', () {
    Future<String> signedWith(int serial) =>
        BootstrapFile(serial: serial, issuedAt: 0, defaultEnvironment: file.defaultEnvironment, environments: file.environments).sign(key);

    const mirrors = ['https://a.example/config.json', 'https://b.example/config.json'];

    test('первое зеркало недоступно или с чужой подписью — берётся следующее', () async {
      final good = await signedWith(5);
      final skipped = <String>[];
      final result = await fetchBootstrapFile(
        fetch: (uri) async => uri.host == 'a.example' ? throw const SocketException('down') : good,
        currentSerial: 3,
        mirrors: mirrors,
        publicKeys: [publicKey],
        onSkip: (uri, _) => skipped.add(uri.host),
      );
      expect(result?.file.serial, 5);
      expect(result?.text, good);
      expect(skipped, ['a.example']);

      final forged = await fetchBootstrapFile(
        fetch: (uri) async => uri.host == 'a.example' ? good.replaceFirst('staging.iperon.net', 'evil.example') : good,
        currentSerial: 3,
        mirrors: mirrors,
        publicKeys: [publicKey],
      );
      expect(forged?.text, good);
    });

    test('откат serial не принимается; равный — «без изменений»', () async {
      final old = await signedWith(2), same = await signedWith(3);
      final rollback = await fetchBootstrapFile(fetch: (_) async => old, currentSerial: 3, mirrors: mirrors, publicKeys: [publicKey]);
      expect(rollback, isNull);
      final stale = await fetchBootstrapFile(
        fetch: (uri) async => uri.host == 'a.example' ? old : same,
        currentSerial: 3,
        mirrors: mirrors,
        publicKeys: [publicKey],
      );
      expect(stale?.file.serial, 3);
    });
  });
}
