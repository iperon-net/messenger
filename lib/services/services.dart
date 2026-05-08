
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:dlibphonenumber/phone_number_util.dart';

import '../di.dart';
import '../logger.dart';

part "auth.dart";

class Services {
  final _logger = getIt.get<Logger>();

  late Auth auth;

  Future<void> initialization() async {
    auth = Auth(logger: _logger);

    _logger.info("services initialization");
  }

}
