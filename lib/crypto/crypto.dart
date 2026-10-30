import 'dart:convert';
import 'dart:ffi' show AllocatorAlloc, Pointer, Uint8, Uint8Pointer, UnsignedChar;
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart' show DartArgon2id, DartHmac, DartSha512;
import 'package:cryptography/helpers.dart';
import 'package:ffi/ffi.dart' show calloc;
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:pqcrypto/pqcrypto.dart' show PqcKem;
import 'package:sodium/sodium.ffi.dart' show LibSodiumFFI;

import '../di.dart';
import '../logger.dart';
import '../models.dart';
import '../utils.dart';

part 'syncer.dart';
part 'file_encryptor.dart';
part 'oprf.dart';
part 'opaque.dart';
part 'ristretto.dart';
part 'call_keys.dart';
part 'secret_chat.dart';
part 'secret_chat_state.dart';

class Crypto {
  final logger = getIt.get<Logger>();
  final utils = getIt.get<Utils>();

  late final Syncer syncer;
  late final FileEncryptor fileEncryptor;
  late final Oprf oprf;
  late final CallKeys callKeys;
  late final SecretChatCrypto secretChat;

  Crypto() {
    syncer = Syncer(logger: logger, utils: utils);
    fileEncryptor = FileEncryptor(logger: logger);
    oprf = Oprf(logger: logger);
    callKeys = CallKeys(logger: logger);
    secretChat = SecretChatCrypto(logger: logger);
  }
}
