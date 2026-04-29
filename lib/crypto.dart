import 'package:cryptography/cryptography.dart';

import 'di.dart';
import 'logger.dart';

class Crypto {
  final _logger = getIt.get<Logger>();
  final algorithmECDH = X25519();

  Crypto() {
    _logger.info("crypto initialization");
  }

  // get shared secret key
  Future<(SecretKey, SimplePublicKey)> sharedSecretKey({required List<int> serverPublicKey}) async {
    final keyPair = await algorithmECDH.newKeyPair();

    final sharedSecretKey = await algorithmECDH.sharedSecretKey(
      keyPair: keyPair,
      remotePublicKey: SimplePublicKey(serverPublicKey, type: KeyPairType.x25519),
    );

    return (sharedSecretKey, await keyPair.extractPublicKey());
  }

}
