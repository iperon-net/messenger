import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/screens/home/home_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'di.dart';
import 'logger.dart';
import 'screens/settings/language_screen.dart';
import 'screens/settings/settings_screen.dart';

class Routers {
  final GlobalKey<NavigatorState> navigatorGoRouterKey = GlobalKey<NavigatorState>();
  final logger = getIt.get<Logger>();

  final routes = <RouteBase>[];

  GoRouter routerCupertino() {
    return GoRouter(
      navigatorKey: navigatorGoRouterKey,
      initialLocation: "/",
      observers: <NavigatorObserver>[
        TalkerRouteObserver(logger.getTalker()),
      ],
      routes: <RouteBase>[
        GoRoute(
          path: "/",
          name: "index",
          builder: (BuildContext context, GoRouterState state) => HomeScreen(),
          routes: [
            GoRoute(
              path: "/settings",
              name: "settings",
              builder: (BuildContext context, GoRouterState state) => SettingsScreen(),
            ),
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

  GoRouter routerMaterial() {
    return GoRouter(
      navigatorKey: navigatorGoRouterKey,
      initialLocation: "/",
      observers: <NavigatorObserver>[
        TalkerRouteObserver(logger.getTalker()),
      ],
      routes: <RouteBase>[
        GoRoute(
          path: "/",
          name: "index",
          builder: (BuildContext context, GoRouterState state) => HomeScreen(),
          routes: [
            GoRoute(
              path: "/settings",
              name: "settings",
              builder: (BuildContext context, GoRouterState state) => SettingsScreen(),
              routes: [
                GoRoute(
                  path: "/settings/language",
                  name: "settings_language",
                  builder: (BuildContext context, GoRouterState state) => LanguageScreen(),
                ),
              ],
            ),
          ],
        ),
      ]
    );
  }

}
