import 'dart:convert';
import 'dart:typed_data';

import 'package:messenger/crypto.dart';

const opaqueTestPassword = 'CorrectHorseBatteryStaple';
const opaqueTestKe2 =
    '7e308140890bcde30cbcea28b01ea1ecfbd077cff62c4def8efa075aabcbb47138fe59af0df2c79f57b8780278f5ae47'
    '355fe1f817119041951c80f612fdfc6dd6ec60bcdb26dc455ddf3e718f1020490c192d70dfc7e403981179d8073d1146'
    'a4f9aa1ced4e4cd984c657eb3b54ced3848326f70331953d91b02535af44d9fedc80188ca46743c52786e0382f95ad85'
    'c08f6afcd1ccfbff95e2bdeb015b166c6b20b92f832cc6df01e0b86a7efd92c1c804ff865781fa93f2f20b446c8371b6'
    '71cd9960ecef2fe0d0f7494986fa3d8b2bb01963537e60efb13981e138e3d4a1c4f62198a9d6fa9170c42c3c71f1971b'
    '29eb1d5d0bd733e40816c91f7912cc4a660c48dae03e57aaa38f3d0cffcfc21852ebc8b405d15bd6744945ba1a93438a'
    '162b6111699d98a16bb55b7bdddfe0fc5608b23da246e7bd73b47369169c5c90';
const opaqueTestKe3 =
    '4455df4f810ac31a6748835888564b536e6da5d9944dfea9e34defb9575fe5e2661ef61d2ae3929bcf57e53d464113d3'
    '64365eb7d1a57b629707ca48da18e442';
const opaqueTestRegistrationResponse =
    '7408a268083e03abc7097fc05b587834539065e86fb0c7b6342fcf5e01e5b019b2fe7af9f48cc502d016729d2fe25cdd'
    '433f2c4bc904660b2a382c9b79df1a78';
const opaqueTestRecord =
    '76a845464c68a5d2f7e442436bb1424953b17d3e2e289ccbaccafb57ac5c36751ac5844383c7708077dea41cbefe2fa1'
    '5724f449e535dd7dd562e66f5ecfb95864eadddec9db5874959905117dad40a4524111849799281fefe3c51fa82785c5'
    'ac13171b2f17bc2c74997f0fce1e1f35bec6b91fe2e12dbd323d23ba7a38dfec634b0f5b96109c198a8027da51854c35'
    'bee90d1e1c781806d07d49b76de6a28b8d9e9b6c93b9f8b64d16dddd9c5bfb5fea48ee8fd2f75012a8b308605cdd8ba5';

Uint8List opaqueTestBytes(String hex) {
  final bytes = Uint8List(hex.length ~/ 2);
  for (var index = 0; index < bytes.length; index++) {
    bytes[index] = int.parse(hex.substring(index * 2, index * 2 + 2), radix: 16);
  }
  return bytes;
}

final class VectorOpaqueClient extends OpaqueClient {
  VectorOpaqueClient() : super(context: Uint8List.fromList(utf8.encode('OPAQUE-POC')), ksf: const OpaqueKsf.identity());

  @override
  (Uint8List, OpaqueLoginState) loginStart(List<int> password, {Uint8List? blind, Uint8List? clientNonce, Uint8List? clientKeyshareSeed}) =>
      super.loginStart(
        password,
        blind: opaqueTestBytes('6ecc102d2e7a7cf49617aad7bbe188556792d4acd60a1a8a8d2b65d4b0790308'),
        clientNonce: opaqueTestBytes('da7e07376d6d6f034cfa9bb537d11b8c6b4238c334333d1f0aebb380cae6a6cc'),
        clientKeyshareSeed: opaqueTestBytes('82850a697b42a505f5b68fcdafce8c31f0af2b581f063cf1091933541936304b'),
      );

  @override
  (Uint8List, OpaqueRegistrationState) registrationStart(List<int> password, {Uint8List? blind}) =>
      super.registrationStart(password, blind: opaqueTestBytes('76cfbfe758db884bebb33582331ba9f159720ca8784a2a070a265d9c2d6abe01'));

  @override
  Future<OpaqueRegistrationResult> registrationFinish(OpaqueRegistrationState state, List<int> response, {Uint8List? envelopeNonce}) =>
      super.registrationFinish(
        state,
        response,
        envelopeNonce: opaqueTestBytes('ac13171b2f17bc2c74997f0fce1e1f35bec6b91fe2e12dbd323d23ba7a38dfec'),
      );
}
