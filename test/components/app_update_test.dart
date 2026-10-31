import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/components/app_update/app_update_common.dart';

void main() {
  test('сборка старше минимальной версии', () {
    expect(isVersionOlder('0.0.569', '0.0.570'), isTrue);
    expect(isVersionOlder('0.0.570', '0.0.570'), isFalse);
    expect(isVersionOlder('0.1.0', '0.0.570'), isFalse);
    expect(isVersionOlder('0.0.99', '0.1'), isTrue);
    expect(isVersionOlder('1.0', '0.9.9'), isFalse);
    // Не задана или негодная — не ограничиваем.
    expect(isVersionOlder('0.0.1', ''), isFalse);
    expect(isVersionOlder('0.0.1', 'latest'), isFalse);
    expect(isVersionOlder('', '0.0.570'), isFalse);
  });

  test('ссылка на APK — первый ABI устройства, под который есть сборка', () {
    expect(apkDownloadUri(['arm64-v8a', 'armeabi-v7a', 'armeabi']).toString(), 'https://download.iperon.net/android/Iperon-arm64-v8a.apk');
    expect(apkDownloadUri(['armeabi-v7a', 'armeabi']).toString(), 'https://download.iperon.net/android/Iperon-armeabi-v7a.apk');
    expect(apkDownloadUri(['x86_64', 'arm64-v8a']).toString(), 'https://download.iperon.net/android/Iperon-x86_64.apk');
    // Нет данных / неизвестный ABI — самая частая сборка.
    expect(apkDownloadUri([]).toString(), 'https://download.iperon.net/android/Iperon-arm64-v8a.apk');
    expect(apkDownloadUri(['riscv64']).toString(), 'https://download.iperon.net/android/Iperon-arm64-v8a.apk');
  });
}
