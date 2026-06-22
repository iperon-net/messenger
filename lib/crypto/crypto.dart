
import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';

import '../di.dart';
import '../logger.dart';
import '../models/session.dart' as models;
import '../constants.dart';

part "syncer.dart";
part "voprf.dart";

class Crypto {
  final _logger = getIt.get<Logger>();
  final algorithmECDH = X25519();

  late Syncer syncer;
  late VOPRF voprf;

  Crypto() {
    syncer = Syncer();
    voprf = VOPRF();

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
