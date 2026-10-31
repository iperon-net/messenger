import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/app_update.dart';

void main() {
  final manifest = <String, Object?>{
    'version': '0.0.593',
    'build': 59301,
    'apks': {
      'arm64-v8a': {'url': 'https://download.iperon.net/android/Iperon-0.0.593-arm64-v8a.apk'},
      'armeabi-v7a': {'url': 'https://download.iperon.net/android/Iperon-0.0.593-armeabi-v7a.apk'},
    },
  };
  final now = DateTime(2026, 11, 1, 12);
  AppUpdateOffer? offer({int current = 59201, List<String> abis = const ['arm64-v8a'], int dismissedBuild = 0, DateTime? dismissedAt}) =>
      AppUpdates.offerFrom(
        manifest,
        currentBuild: current,
        abis: abis,
        dismissedBuild: dismissedBuild,
        dismissedAt: dismissedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
        now: now,
      );

  test('новая сборка — баннер со ссылкой на APK своего ABI', () {
    final result = offer();
    expect(result?.version, '0.0.593');
    expect(result?.build, 59301);
    expect(result?.uri.toString(), 'https://download.iperon.net/android/Iperon-0.0.593-arm64-v8a.apk');
    expect(offer(abis: ['armeabi-v7a', 'armeabi'])?.uri.toString(), 'https://download.iperon.net/android/Iperon-0.0.593-armeabi-v7a.apk');
  });

  test('та же или более новая сборка установлена — баннера нет', () {
    expect(offer(current: 59301), isNull);
    expect(offer(current: 59399), isNull);
  });

  test('«Позже» прячет эту версию на сутки', () {
    expect(offer(dismissedBuild: 59301, dismissedAt: now.subtract(const Duration(hours: 23))), isNull);
    expect(offer(dismissedBuild: 59301, dismissedAt: now.subtract(const Duration(hours: 25))), isNotNull);
    // Отложили прошлую версию — новую показываем.
    expect(offer(dismissedBuild: 59201, dismissedAt: now), isNotNull);
  });

  test('нет APK под ABI в манифесте — постоянная ссылка, битый манифест — ничего', () {
    expect(offer(abis: ['x86_64'])?.uri.toString(), 'https://download.iperon.net/android/Iperon-x86_64.apk');
    expect(
      AppUpdates.offerFrom({'version': '0.0.593'}, currentBuild: 1, abis: const [], dismissedBuild: 0, dismissedAt: now, now: now),
      isNull,
    );
  });
}
