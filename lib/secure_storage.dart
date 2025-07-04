import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'cubit/app_cubit.dart';
import 'di.dart';
import 'i18n/translations.g.dart';
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

  Future<void> setDarkMode({required DarkMode value}) async {
    await _storage.write(key: "darkMode", value: value.name);
  }

  Future<ThemeMode> getThemeMode() async {
    final result = await _storage.read(key: "darkMode");
    ThemeMode themeMode = ThemeMode.system;

    if (result != null && result.isNotEmpty && result == "disabled") {
      themeMode = ThemeMode.light;
    } else if(result != null &&  result.isNotEmpty && result == "alwaysOn") {
      themeMode = ThemeMode.dark;
    }
    return themeMode;
  }

  Future<void> setThemeColor({required ThemeColor value}) async {
    await _storage.write(key: "themeColor", value: value.name);
  }

  Future<ThemeColor> getThemeColor() async {
    final result = await _storage.read(key: "themeColor");

    ThemeColor colorTheme = ThemeColor.blue;

    if (result != null && result.isNotEmpty && result == "green") {
      colorTheme = ThemeColor.green;
    } else if (result != null && result.isNotEmpty && result == "purple") {
      colorTheme = ThemeColor.purple;
    }
    return colorTheme;
  }

  Future<void> setLanguage({required AppLocale value}) async {
    await _storage.write(key: "language", value: value.name);
  }

  Future<AppLocale> getLanguage() async {
    final result = await _storage.read(key: "language");

    if (result != null && result.isNotEmpty && result == AppLocale.ru.languageCode) {
      return AppLocale.ru;
    }
    return AppLocale.en;
  }
}
