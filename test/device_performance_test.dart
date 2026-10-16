import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/device_performance.dart';

void main() {
  const gb = 1024 * 1024 * 1024;

  test('Android: память, ядра, частота, media performance class', () {
    PerformanceClass android(Map<String, Object?> info) => DevicePerformance.classify(info, android: true);
    expect(android({'ram': 2 * gb, 'cores': 8, 'maxFreqKHz': 2000000}), PerformanceClass.low);
    expect(android({'ram': 8 * gb, 'cores': 8, 'lowRam': true}), PerformanceClass.low);
    expect(android({'ram': 4 * gb, 'cores': 4, 'maxFreqKHz': 1400000}), PerformanceClass.low);
    expect(android({'ram': 4 * gb, 'cores': 8, 'maxFreqKHz': 2000000}), PerformanceClass.average);
    expect(android({'ram': 8 * gb, 'cores': 8, 'maxFreqKHz': 2000000}), PerformanceClass.average);
    expect(android({'ram': 8 * gb, 'cores': 8, 'maxFreqKHz': 2840000}), PerformanceClass.high);
    expect(android({'ram': 8 * gb, 'cores': 8, 'maxFreqKHz': 0}), PerformanceClass.high);
    expect(android({'ram': 4 * gb, 'cores': 8, 'mediaClass': 33}), PerformanceClass.high);
  });

  test('iOS: по памяти', () {
    PerformanceClass ios(num ram) => DevicePerformance.classify({'ram': ram, 'cores': 6}, android: false);
    expect(ios(2 * gb), PerformanceClass.low);
    expect(ios(3 * gb), PerformanceClass.average);
    expect(ios(4 * gb), PerformanceClass.high);
  });
}
