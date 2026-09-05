import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';

import '../di.dart';
import '../logger.dart';
import '../models.dart';
import '../utils.dart';

part 'syncer.dart';
part 'file_encryptor.dart';

class Crypto {
  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();

  late final Syncer syncer;
  late final FileEncryptor fileEncryptor;

  Crypto() {
    syncer = Syncer(logger: logger, utils: utils);
    fileEncryptor = FileEncryptor(logger: logger);
  }
}
