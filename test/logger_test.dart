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

  //[54, 57, 102, 52, 54, 100, 54, 53, 51, 97, 98, 101, 52, 53, 56, 48, 101, 99, 56, 54, 99, 98, 99, 50]
}
