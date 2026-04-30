import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:dlibphonenumber/enums/phone_number_format.dart';
import 'package:dlibphonenumber/phone_number_util.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart' as package_info;
import 'package:url_launcher/url_launcher.dart';

import 'extensions/string_extensions.dart';

enum PhoneFormatType { wifi, mobile, vpn, ethernet, none }
enum Os { iOS, android }

class PhoneFormat {
  final String international;
  final String national;
  final String e164;
  final String rfc3966;

  PhoneFormat({
    required this.international,
    required this.national,
    required this.e164,
    required this.rfc3966,
  });

  @override
  String toString() {
    return "international=$international, national=$national, e164=$e164, rfc3966=$rfc3966";
  }

}

class DeviceInfo {
  final String deviceModel;
  final Os os;
  final String osVersion;
  final bool isPhysicalDevice;

  DeviceInfo({
    required this.deviceModel,
    required this.os,
    required this.osVersion,
    this.isPhysicalDevice = false,
  });

  @override
  String toString() {
    return "deviceModel=$deviceModel os=$os osVersion=$osVersion isPhysicalDevice=$isPhysicalDevice";
  }

}

class PackageInfo {
  final String appBuildNumber;
  final String appVersion;

  PackageInfo({
    required this.appBuildNumber,
    required this.appVersion,
  });

  @override
  String toString() {
    return "appVersion=$appVersion appBuildNumber=$appBuildNumber";
  }
}

class Utils {
  PhoneFormat phoneFormat({required String phoneNumber}) {
    final phoneUtil = PhoneNumberUtil.instance;
    final phoneNumberParse = phoneUtil.parse("+$phoneNumber", "");

    return PhoneFormat(
      international: phoneUtil.format(phoneNumberParse, PhoneNumberFormat.international),
      national: phoneUtil.format(phoneNumberParse, PhoneNumberFormat.national),
      e164: phoneUtil.format(phoneNumberParse, PhoneNumberFormat.e164),
      rfc3966: phoneUtil.format(phoneNumberParse, PhoneNumberFormat.rfc3966),
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final phone = phoneFormat(phoneNumber: phoneNumber);
    await launchUrl(Uri(scheme: 'tel', path: phone.international));
  }

  String formatDuration(Duration duration) {
    String minutes = duration.inMinutes.remainder(60).toString().padLeft(0, '2');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  String toHex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  List<int> fromHex(String hex) => [for (var i = 0; i < hex.length; i += 2) int.parse(hex.substring(i, i + 2), radix: 16)];

  Future<PackageInfo> packageInfo() async {
    final packageInfo = await package_info.PackageInfo.fromPlatform();
    return PackageInfo(appVersion: packageInfo.version, appBuildNumber: packageInfo.buildNumber);
  }

  Future<DeviceInfo> deviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final deviceNames = DeviceMarketingNames();

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      final singleDeviceName = await deviceNames.getSingleName();

        return DeviceInfo(
          deviceModel: singleDeviceName,
          os: Os.iOS,
          osVersion: info.systemVersion,
          isPhysicalDevice: kDebugMode ? true : info.isPhysicalDevice,
      );

    } else {
      final info = await deviceInfo.androidInfo;
      final singleDeviceName = await deviceNames.getSingleName();

      return DeviceInfo(
        deviceModel: "${info.brand.capitalize()} $singleDeviceName",
        os: Os.android,
        osVersion: info.version.release,
        isPhysicalDevice: kDebugMode ? true : info.isPhysicalDevice,
      );
    }

  }

}

