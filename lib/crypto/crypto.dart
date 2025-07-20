import "package:pointycastle/pointycastle.dart";

import '../di.dart';
import '../logger.dart';

class Crypto {
  final _logger = getIt.get<Logger>();

  Future<void> initialization() async {
    _logger.debug("crypto initialization");
  }

  void argon2() {
    final kd = KeyDerivator('scrypt/argon2');
  }


}
