import 'dart:convert';

import 'package:pointycastle/export.dart';

import '../di.dart';
import '../logger.dart';

part 'sha256.dart';

class Crypto {
  final _logger = getIt.get<Logger>();
  late SHA256 sha256;

  Future<void> initialization() async {
    _logger.debug("crypto initialization");

    sha256 = SHA256(logger: _logger);
  }


}
