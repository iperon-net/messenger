
import 'package:cryptography/cryptography.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:dlibphonenumber/phone_number_util.dart';

import '../api.dart';
import '../crypto.dart';
import '../di.dart';
import '../logger.dart';
import '../protobuf/protos/auth_v1.pb.dart';
import '../protobuf/protos/metadata_v1.pb.dart';
import '../repositories/repositories.dart';
import '../settings.dart';
import '../utils.dart';

part "auth.dart";

class Services {
  final _logger = getIt.get<Logger>();

  late Auth auth;

  Future<void> initialization() async {
    auth = Auth(logger: _logger);

    _logger.info("services initialization");
  }

}
