import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'di.dart';
import 'logger.dart';
import './screens/screens.dart';
import 'dart:io' show Platform;

class Routers {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _logger = getIt.get<Logger>();

  Routers() {
    _logger.info("routers initialization");
  }

  // Material
  final routesMaterial = <RouteBase>[
    GoRoute(
      path: '/auth',
      builder: (_, _) => AuthOnPremiseMaterialScreen(),
    ),
  ];

  // Cupertino
  final routesCupertino = <RouteBase>[
    GoRoute(
      path: '/auth',
      builder: (_, _) => AuthOnPremiseCupertinoScreen(),
    ),
  ];

  GoRouter get config => GoRouter(
    debugLogDiagnostics: kDebugMode ? true: false,
    navigatorKey: _navigatorKey,
    initialLocation: '/auth',
    routes: Platform.isAndroid ? routesMaterial: routesCupertino,
  );

}



