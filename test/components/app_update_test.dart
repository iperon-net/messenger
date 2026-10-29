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
}
