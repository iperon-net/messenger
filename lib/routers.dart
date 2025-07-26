import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:messenger/screens/home/home_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'di.dart';
import 'logger.dart';
import 'screens/settings/appearance_screen.dart';
import 'screens/settings/language_screen.dart';
import 'screens/settings/passcode_screen.dart';
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
        defaultLifecycleObserver,
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
              path: "/settings/appearance",
              name: "settings_appearance",
              builder: (BuildContext context, GoRouterState state) => AppearanceScreen(),
            ),
            GoRoute(
              path: "/settings/privacy_security",
              name: "settings_privacy_security",
              builder: (BuildContext context, GoRouterState state) => PrivacyAndSecurityScreen(),
              routes: <GoRoute>[
                GoRoute(
                  path: "/passcode",
                  name: "settings_privacy_security_passcode",
                  builder: (BuildContext context, GoRouterState state) => PasscodeScreen(),
                ),
              ],
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
      debugLogDiagnostics: kDebugMode ? true: false,
      navigatorKey: navigatorGoRouterKey,
      initialLocation: "/",
      observers: <NavigatorObserver>[
        TalkerRouteObserver(logger.getTalker()),
        defaultLifecycleObserver,
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
