import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';

import '../di.dart';
import '../logger.dart';
import '../models.dart';
import '../utils.dart';

part 'syncer.dart';

class Crypto {
  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();

  late final Syncer syncer;

  Crypto() {
    syncer = Syncer(logger: logger, utils: utils);
  }
}
