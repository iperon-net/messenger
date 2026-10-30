import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/crypto.dart';

/// Тестовые векторы RFC 9807, приложение C.1.1 и C.1.2 (OPAQUE-3DH,
/// ristretto255-SHA512, KSF Identity, context "OPAQUE-POC"). Серверные
/// сообщения (registration_response, KE2) берутся из векторов — клиент должен
/// выдать байт в байт те же request / record / KE1 / KE3 / ключи.
Uint8List _hex(String s) {
  final out = Uint8List(s.length ~/ 2);
  for (var i = 0; i < out.length; i++) {
    out[i] = int.parse(s.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return out;
}

String _hexStr(List<int> b) => b.map((e) => e.toRadixString(16).padLeft(2, '0')).join();

const _vector1 = <String, String>{
  'password': '436f7272656374486f72736542617474657279537461706c65',
  'envelope_nonce': 'ac13171b2f17bc2c74997f0fce1e1f35bec6b91fe2e12dbd323d23ba7a38dfec',
  'client_nonce': 'da7e07376d6d6f034cfa9bb537d11b8c6b4238c334333d1f0aebb380cae6a6cc',
  'client_keyshare_seed': '82850a697b42a505f5b68fcdafce8c31f0af2b581f063cf1091933541936304b',
  'blind_registration': '76cfbfe758db884bebb33582331ba9f159720ca8784a2a070a265d9c2d6abe01',
  'blind_login': '6ecc102d2e7a7cf49617aad7bbe188556792d4acd60a1a8a8d2b65d4b0790308',
  'registration_request': '5059ff249eb1551b7ce4991f3336205bde44a105a032e747d21bf382e75f7a71',
  'registration_response':
      '7408a268083e03abc7097fc05b587834539065e86fb0c7b6342fcf5e01e5b019b2fe7af9f48cc502d016729d2fe25cdd'
      '433f2c4bc904660b2a382c9b79df1a78',
  'registration_upload':
      '76a845464c68a5d2f7e442436bb1424953b17d3e2e289ccbaccafb57ac5c36751ac5844383c7708077dea41cbefe2fa1'
      '5724f449e535dd7dd562e66f5ecfb95864eadddec9db5874959905117dad40a4524111849799281fefe3c51fa82785c5'
      'ac13171b2f17bc2c74997f0fce1e1f35bec6b91fe2e12dbd323d23ba7a38dfec634b0f5b96109c198a8027da51854c35'
      'bee90d1e1c781806d07d49b76de6a28b8d9e9b6c93b9f8b64d16dddd9c5bfb5fea48ee8fd2f75012a8b308605cdd8ba5',
  'KE1':
      'c4dedb0ba6ed5d965d6f250fbe554cd45cba5dfcce3ce836e4aee778aa3cd44dda7e07376d6d6f034cfa9bb537d11b8c'
      '6b4238c334333d1f0aebb380cae6a6cc6e29bee50701498605b2c085d7b241ca15ba5c32027dd21ba420b94ce60da326',
  'KE2':
      '7e308140890bcde30cbcea28b01ea1ecfbd077cff62c4def8efa075aabcbb47138fe59af0df2c79f57b8780278f5ae47'
      '355fe1f817119041951c80f612fdfc6dd6ec60bcdb26dc455ddf3e718f1020490c192d70dfc7e403981179d8073d1146'
      'a4f9aa1ced4e4cd984c657eb3b54ced3848326f70331953d91b02535af44d9fedc80188ca46743c52786e0382f95ad85'
      'c08f6afcd1ccfbff95e2bdeb015b166c6b20b92f832cc6df01e0b86a7efd92c1c804ff865781fa93f2f20b446c8371b6'
      '71cd9960ecef2fe0d0f7494986fa3d8b2bb01963537e60efb13981e138e3d4a1c4f62198a9d6fa9170c42c3c71f1971b'
      '29eb1d5d0bd733e40816c91f7912cc4a660c48dae03e57aaa38f3d0cffcfc21852ebc8b405d15bd6744945ba1a93438a'
      '162b6111699d98a16bb55b7bdddfe0fc5608b23da246e7bd73b47369169c5c90',
  'KE3':
      '4455df4f810ac31a6748835888564b536e6da5d9944dfea9e34defb9575fe5e2661ef61d2ae3929bcf57e53d464113d3'
      '64365eb7d1a57b629707ca48da18e442',
  'export_key':
      '1ef15b4fa99e8a852412450ab78713aad30d21fa6966c9b8c9fb3262a970dc62950d4dd4ed62598229b1b72794fc0335'
      '199d9f7fcc6eaedde92cc04870e63f16',
  'session_key':
      '42afde6f5aca0cfa5c163763fbad55e73a41db6b41bc87b8e7b62214a8eedc6731fa3cb857d657ab9b3764b89a84e91e'
      'bcb4785166fbb02cedfcbdfda215b96f',
};

const _vector2 = <String, String>{
  'client_identity': '616c696365',
  'server_identity': '626f62',
  'password': '436f7272656374486f72736542617474657279537461706c65',
  'envelope_nonce': 'ac13171b2f17bc2c74997f0fce1e1f35bec6b91fe2e12dbd323d23ba7a38dfec',
  'client_nonce': 'da7e07376d6d6f034cfa9bb537d11b8c6b4238c334333d1f0aebb380cae6a6cc',
  'client_keyshare_seed': '82850a697b42a505f5b68fcdafce8c31f0af2b581f063cf1091933541936304b',
  'blind_registration': '76cfbfe758db884bebb33582331ba9f159720ca8784a2a070a265d9c2d6abe01',
  'blind_login': '6ecc102d2e7a7cf49617aad7bbe188556792d4acd60a1a8a8d2b65d4b0790308',
  'registration_request': '5059ff249eb1551b7ce4991f3336205bde44a105a032e747d21bf382e75f7a71',
  'registration_response':
      '7408a268083e03abc7097fc05b587834539065e86fb0c7b6342fcf5e01e5b019b2fe7af9f48cc502d016729d2fe25cdd'
      '433f2c4bc904660b2a382c9b79df1a78',
  'registration_upload':
      '76a845464c68a5d2f7e442436bb1424953b17d3e2e289ccbaccafb57ac5c36751ac5844383c7708077dea41cbefe2fa1'
      '5724f449e535dd7dd562e66f5ecfb95864eadddec9db5874959905117dad40a4524111849799281fefe3c51fa82785c5'
      'ac13171b2f17bc2c74997f0fce1e1f35bec6b91fe2e12dbd323d23ba7a38dfec1ac902dc5589e9a5f0de56ad685ea848'
      '6210ef41449cd4d8712828913c5d2b680b2b3af4a26c765cff329bfb66d38ecf1d6cfa9e7a73c222c6efe0d9520f7d7c',
  'KE1':
      'c4dedb0ba6ed5d965d6f250fbe554cd45cba5dfcce3ce836e4aee778aa3cd44dda7e07376d6d6f034cfa9bb537d11b8c'
      '6b4238c334333d1f0aebb380cae6a6cc6e29bee50701498605b2c085d7b241ca15ba5c32027dd21ba420b94ce60da326',
  'KE2':
      '7e308140890bcde30cbcea28b01ea1ecfbd077cff62c4def8efa075aabcbb47138fe59af0df2c79f57b8780278f5ae47'
      '355fe1f817119041951c80f612fdfc6dd6ec60bcdb26dc455ddf3e718f1020490c192d70dfc7e403981179d8073d1146'
      'a4f9aa1ced4e4cd984c657eb3b54ced3848326f70331953d91b02535af44d9fea502150b67fe36795dd8914f164e49f8'
      '1c7688a38928372134b7dccd50e09f8fed9518b7b2f94835b3c4fe4c8475e7513f20eb97ff0568a39caee3fd6251876f'
      '71cd9960ecef2fe0d0f7494986fa3d8b2bb01963537e60efb13981e138e3d4a1c4f62198a9d6fa9170c42c3c71f1971b'
      '29eb1d5d0bd733e40816c91f7912cc4a292371e7809a9031743e943fb3b56f51de903552fc91fba4e7419029951c3970'
      'b2e2f0a9dea218d22e9e4e0000855bb6421aa3610d6fc0f4033a6517030d4341',
  'KE3':
      '7a026de1d6126905736c3f6d92463a08d209833eb793e46d0f7f15b3e0f62c7643763c02bbc6b8d3d15b63250cae9817'
      '1e9260f1ffa789750f534ac11a0176d5',
  'export_key':
      '1ef15b4fa99e8a852412450ab78713aad30d21fa6966c9b8c9fb3262a970dc62950d4dd4ed62598229b1b72794fc0335'
      '199d9f7fcc6eaedde92cc04870e63f16',
  'session_key':
      'ae7951123ab5befc27e62e63f52cf472d6236cb386c968cc47b7e34f866aa4bc7638356a73cfce92becf39d6a7d32a18'
      '61f12130e824241fe6cab34fbd471a57',
};

OpaqueClient _client(Map<String, String> v) => OpaqueClient(
  context: Uint8List.fromList(utf8.encode('OPAQUE-POC')),
  ksf: const OpaqueKsf.identity(),
  clientIdentity: v['client_identity'] == null ? null : _hex(v['client_identity']!),
  serverIdentity: v['server_identity'] == null ? null : _hex(v['server_identity']!),
);

Future<OpaqueLoginResult> _login(Map<String, String> v, {String? password, Uint8List? ke2}) {
  final (_, state) = _client(v).loginStart(
    password == null ? _hex(v['password']!) : utf8.encode(password),
    blind: _hex(v['blind_login']!),
    clientNonce: _hex(v['client_nonce']!),
    clientKeyshareSeed: _hex(v['client_keyshare_seed']!),
  );
  return _client(v).loginFinish(state, ke2 ?? _hex(v['KE2']!));
}

void main() {
  for (final (name, v) in [('vector 1', _vector1), ('vector 2 (identities)', _vector2)]) {
    group(name, () {
      test('registration', () async {
        final client = _client(v);
        final (request, state) = client.registrationStart(_hex(v['password']!), blind: _hex(v['blind_registration']!));
        expect(_hexStr(request), v['registration_request']);

        final result = await client.registrationFinish(state, _hex(v['registration_response']!), envelopeNonce: _hex(v['envelope_nonce']!));
        expect(_hexStr(result.record), v['registration_upload']);
        expect(_hexStr(result.exportKey), v['export_key']);
      });

      test('login', () async {
        final (ke1, _) = _client(v).loginStart(
          _hex(v['password']!),
          blind: _hex(v['blind_login']!),
          clientNonce: _hex(v['client_nonce']!),
          clientKeyshareSeed: _hex(v['client_keyshare_seed']!),
        );
        expect(_hexStr(ke1), v['KE1']);

        final result = await _login(v);
        expect(_hexStr(result.ke3), v['KE3']);
        expect(_hexStr(result.sessionKey), v['session_key']);
        expect(_hexStr(result.exportKey), v['export_key']);
      });
    });
  }

  test('wrong password fails envelope recovery', () async {
    await expectLater(
      _login(_vector1, password: 'wrong'),
      throwsA(isA<OpaqueException>().having((e) => e.error, 'error', OpaqueError.wrongPassword)),
    );
  });

  test('tampered server MAC is rejected', () async {
    final ke2 = _hex(_vector1['KE2']!);
    ke2[ke2.length - 1] ^= 1;
    await expectLater(
      _login(_vector1, ke2: ke2),
      throwsA(isA<OpaqueException>().having((e) => e.error, 'error', OpaqueError.serverAuthentication)),
    );
  });

  test('malformed KE2 is rejected', () async {
    await expectLater(
      _login(_vector1, ke2: _hex(_vector1['KE2']!).sublist(1)),
      throwsA(isA<OpaqueException>().having((e) => e.error, 'error', OpaqueError.invalidMessage)),
    );
  });
}
