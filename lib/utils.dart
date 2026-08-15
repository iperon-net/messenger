import 'dart:io';

import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter/foundation.dart';
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

}
