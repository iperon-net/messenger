import 'package:flutter_test/flutter_test.dart';
import 'package:messenger/logger.dart';


void main() {

  test('logger', () {
    final logger = Logger();
    logger.debug("debug messages");
    logger.info("info messages");
    logger.error("error messages");
    logger.critical("critical messages");
  });

}
