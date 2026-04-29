import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/di.dart';
import 'package:messenger/logger.dart';

void main() {

  setUp(() async {
    await configureCommonDependencies();
  });

  test('di', () async {
    final logger = getIt.get<Logger>();
    logger.debug("debug");
  });

  tearDown(() async {
    await getIt.reset();
  });

}
