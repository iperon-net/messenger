import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'di.dart';
import 'logger.dart';

class SecureStorage {
  final logger = getIt.get<Logger>();

  late FlutterSecureStorage _storage;

  SecureStorage() {
    if (Platform.isIOS) {
      _storage = FlutterSecureStorage(iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock));
    } else {
      _storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
    }
    // logger.debug("secure storage initialization");
  }

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String> read({required String key}) async {
    final result = await _storage.read(key: key);
    if (result != null) return result;
    return "";
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }
}
