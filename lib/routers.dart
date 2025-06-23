import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/screens/home/home_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'di.dart';
import 'logger.dart';
import 'screens/settings/language_screen.dart';

class Routers {
  final GlobalKey<NavigatorState> navigatorGoRouterKey = GlobalKey<NavigatorState>();
  final logger = getIt.get<Logger>();

  GoRouter router() {
    return GoRouter(
      navigatorKey: navigatorGoRouterKey,
      initialLocation: "/home",
      observers: <NavigatorObserver>[
        TalkerRouteObserver(logger.getTalker()),
      ],
      routes: <RouteBase>[
        GoRoute(
          path: "/home",
          name: "home",
          builder: (BuildContext context, GoRouterState state) => HomeScreen(),
          routes: [
            GoRoute(
              path: "/settings/language",
              name: "settings_language",
              builder: (BuildContext context, GoRouterState state) => LanguageScreen(),
            ),
          ],
        ),
      ]
    );
  }
}
