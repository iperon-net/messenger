import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Возможности текущей платформы (docs/plans/desktop-client.md, §3.1): вместо
/// разбросанных `Platform.isIOS / isAndroid` там, где важна не ОС, а наличие
/// сервиса. Десктоп (macOS / Windows) — без Firebase, пушей, звонков и
/// секретных чатов в первом релизе.
abstract final class AppPlatform {
  static bool get isMobile => Platform.isIOS || Platform.isAndroid;
  static bool get isDesktop => Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  /// Firebase (Remote Config, Crashlytics, Messaging) — только на мобильных.
  static bool get hasFirebase => isMobile;

  /// Пуши (APNs / FCM) и нативный показ уведомлений.
  static bool get hasPush => isMobile;

  /// Звонки (LiveKit + CallKit / ConnectionService) — на десктопе позже (§7 плана).
  static bool get hasCalls => isMobile;

  /// Секретные чаты — на десктопе не делаем (§3.7 плана).
  static bool get hasSecretChats => isMobile;

  /// Телефонная книга устройства (поиск знакомых по OPRF, баннер доступа) — на
  /// десктопе контакты только облачные (§3 плана).
  static bool get hasAddressBook => isMobile;
}

/// Keychain на macOS: обычный (login) keychain, не data protection — тому нужны
/// entitlement `keychain-access-groups` и подпись командой (Developer ID), без
/// них запись падает с -34018. Перейти на data protection вместе с подписью
/// (этап 6 docs/plans/desktop-client.md).
const macOSKeychainOptions = MacOsOptions(usesDataProtectionKeychain: false);
