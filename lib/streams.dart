import 'dart:async';

import '../models.dart' as models;


class Streams {
  // final _logger = getIt.get<Logger>();

  Streams();

  final StreamController<List<models.DeviceSession>> controllerDeviceSessions = StreamController<List<models.DeviceSession>>.broadcast();
  final StreamController<bool> controllerAuth = StreamController<bool>.broadcast();

}
