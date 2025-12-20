import '../di.dart';
import '../logger.dart';

class Api {
  final _logger = getIt.get<Logger>();


  Api() {
    _logger.debug("ddd");
  }

}
