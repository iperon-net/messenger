import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/screens/home/home_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'di.dart';
import 'logger.dart';
import 'screens/settings/appearance_screen.dart';
import 'screens/settings/language_screen.dart';
import 'screens/settings/privacy_and_security_screen.dart';
import 'screens/settings/settings_screen.dart';

class Routers {
  final GlobalKey<NavigatorState> navigatorGoRouterKey = GlobalKey<NavigatorState>();
  final logger = getIt.get<Logger>();

  final routes = <RouteBase>[];

  GoRouter routerCupertino() {
    return GoRouter(
      debugLogDiagnostics: kDebugMode ? true: false,
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
                  path: "/language",
                  name: "settings_language",
                  builder: (BuildContext context, GoRouterState state) => LanguageScreen(),
                ),
                GoRoute(
                  path: "/appearance",
                  name: "settings_appearance",
                  builder: (BuildContext context, GoRouterState state) => AppearanceScreen(),
                ),
                GoRoute(
                  path: "/privacy_security",
                  name: "settings_privacy_security",
                  builder: (BuildContext context, GoRouterState state) => PrivacyAndSecurityScreen(),
                ),
              ],
            ),
          ],
        ),
      ]
    );
  }

  GoRouter routerMaterial() {
    return GoRouter(
      debugLogDiagnostics: kDebugMode ? true: false,
      navigatorKey: navigatorGoRouterKey,
      initialLocation: "/settings",
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
                  path: "/language",
                  name: "settings_language",
                  builder: (BuildContext context, GoRouterState state) => LanguageScreen(),
                ),
                GoRoute(
                  path: "/appearance",
                  name: "settings_appearance",
                  builder: (BuildContext context, GoRouterState state) => AppearanceScreen(),
                ),
                GoRoute(
                  path: "/privacy_security",
                  name: "settings_privacy_security",
                  builder: (BuildContext context, GoRouterState state) => PrivacyAndSecurityScreen(),
                ),
              ],
            ),
          ],
        ),
      ]
    );
  }

}
