import 'dart:async';

import 'cubit/settings/settings_cubit.dart';
import 'di.dart';
import 'logger.dart';

import '../models.dart' as models;


class Streams {
  final _logger = getIt.get<Logger>();

  Streams();

  final StreamController<List<models.DeviceSession>> controllerDeviceSessions = StreamController<List<models.DeviceSession>>.broadcast();

}
