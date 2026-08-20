import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:local_auth/local_auth.dart';
import 'package:objectid/objectid.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'di.dart';
import 'logger.dart';
import 'models.dart';
import 'extensions.dart';

class Utils {
  final phoneUtil = PhoneNumberUtil.instance;

  Utils();

  PhoneNumberModel phoneNormalization({required String phoneNumber}) {
    const empty = PhoneNumberModel(international: "", national: "", e164: "", rfc3966: "", raw: "");

    var digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return empty;

    if (digits.length == 11 && digits.startsWith('8')) {
      digits = '7${digits.substring(1)}';
    }

    PhoneNumber phoneNumberParse;
    try {
      if (digits.length == 10 && digits.startsWith('9')) {
        // Номер без кода страны ("9XXXXXXXXX") считаем российским мобильным.
        phoneNumberParse = phoneUtil.parse(digits, 'RU');
      } else {
        phoneNumberParse = phoneUtil.parse('+$digits', '');
      }
    } catch (e) {
      return empty;
    }

    if (!phoneUtil.isValidNumber(phoneNumberParse)) return empty;

    return PhoneNumberModel(
      international: phoneUtil.format(phoneNumberParse, PhoneNumberFormat.international),
      national: phoneUtil.format(phoneNumberParse, PhoneNumberFormat.national),
      e164: phoneUtil.format(phoneNumberParse, PhoneNumberFormat.e164),
      rfc3966: phoneUtil.format(phoneNumberParse, PhoneNumberFormat.rfc3966),
      raw: digits,
    );
  }

  String bytesToHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Uint8List hexToBytes(String hex) {
    final result = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      result.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(result);
  }

  Future<PackageInfoModel> packageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return PackageInfoModel(appVersion: packageInfo.version, appBuildNumber: packageInfo.buildNumber);
  }

  Future<DeviceInfoModel> deviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final deviceNames = DeviceMarketingNames();

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      final singleDeviceName = await deviceNames.getSingleName();

      return DeviceInfoModel(
        deviceModel: singleDeviceName,
        os: OS.iOS,
        osCode: 1,
        osVersion: info.systemVersion,
        isPhysicalDevice: kDebugMode ? true : info.isPhysicalDevice,
      );
    } else {
      final info = await deviceInfo.androidInfo;
      final singleDeviceName = await deviceNames.getSingleName();

      return DeviceInfoModel(
        deviceModel: "${info.brand.capitalize()} $singleDeviceName",
        os: OS.android,
        osCode: 2,
        osVersion: info.version.release,
        isPhysicalDevice: kDebugMode ? true : info.isPhysicalDevice,
      );
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final phone = phoneNormalization(phoneNumber: phoneNumber);

    final logger = getIt.get<Logger>();

    if (phone.international.isEmpty) {
      logger.warning("makePhoneCall: invalid phone number '$phoneNumber'");
      return;
    }

    logger.debug(phone.international);

    final uri = Uri.parse('tel:${phone.international}');

    try {
      if (!await canLaunchUrl(uri)) {
        logger.warning("makePhoneCall: cannot launch $uri (no dialer available?)");
        return;
      }

      final result = await launchUrl(uri);
      logger.debug("makePhoneCall: launchUrl($uri) -> $result");
    } catch (e, s) {
      logger.handle(e, s, "makePhoneCall: failed to launch $uri");
    }
  }

  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  /// Доступна ли биометрия на устройстве прямо сейчас: железо/ОС её поддерживают
  /// и хотя бы один способ реально настроен (Face ID — задано лицо, Touch ID —
  /// добавлен отпечаток).
  ///
  /// [isDeviceSupported] и [canCheckBiometrics] сами по себе не отражают
  /// enrollment: на iPhone с Face ID, но без заданного лица, оба вернут true.
  /// Поэтому решающая проверка — [getAvailableBiometrics], который возвращает
  /// только фактически настроенные способы (пустой список = ничего не задано).
  Future<bool> isBiometricAvailable() async {
    final logger = getIt.get<Logger>();
    final auth = LocalAuthentication();

    try {
      final isSupported = await auth.isDeviceSupported();
      if (!isSupported) return false;
      final canCheck = await auth.canCheckBiometrics;
      if (!canCheck) return false;
      final available = await auth.getAvailableBiometrics();
      return available.isNotEmpty;
    } catch (e, stack) {
      logger.handle(e, stack, "isBiometricAvailable: failed");
      return false;
    }
  }

  Future<({BoringAvatarType type, String hash})> boringAvatar(ObjectId userID) async {
    final values = [
      BoringAvatarType.ring,
      BoringAvatarType.bauhaus,
      BoringAvatarType.marble,
      BoringAvatarType.pixel,
      BoringAvatarType.sunset,
      BoringAvatarType.beam,
    ];

    final sha256 = Sha256();
    final hash = await sha256.hash(userID.bytes);
    final hashBytes = hash.bytes;

    BigInt hashInt = BigInt.zero;
    for (int i = 0; i < hashBytes.length; i++) {
      hashInt = (hashInt << 8) | BigInt.from(hashBytes[i]);
    }

    final index = (hashInt % BigInt.from(values.length)).toInt();
    return (type: values[index], hash: userID.toString());
  }
}
