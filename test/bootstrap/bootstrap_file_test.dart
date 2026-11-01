import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/bootstrap/bootstrap_file.dart';

void main() {
  const fingerprint = '7abfc2a7e8ea09ae384bdeb855cfeae24d60bfac3646046e754fddc8d5ab604d';
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
}
