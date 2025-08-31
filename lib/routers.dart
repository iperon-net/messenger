import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:messenger/screens/home/home_screen_material.dart';
import 'package:messenger/screens/settings/passcode_screen_material.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'di.dart';
import 'logger.dart';
import 'screens/home/home_screen_cupertino.dart';
import 'screens/settings/appearance_screen_cupertino.dart';
import 'screens/settings/appearance_screen_material.dart';
import 'screens/settings/language_screen_cupertino.dart';
import 'screens/settings/language_screen_material.dart';
import 'screens/settings/passcode_screen_cupertino.dart';
import 'screens/settings/privacy_and_security_screen_cupertino.dart';
import 'screens/settings/privacy_and_security_screen_material.dart';
import 'screens/settings/settings_screen_cupertino.dart';
import 'screens/settings/settings_screen_material.dart';

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
          builder: (BuildContext context, GoRouterState state) => HomeScreenCupertino(),
          routes: [
            GoRoute(
              path: "/settings",
              name: "settings",
              builder: (BuildContext context, GoRouterState state) => SettingsScreenCupertino(),
            ),
            GoRoute(
              path: "/settings/appearance",
              name: "settings_appearance",
              builder: (BuildContext context, GoRouterState state) => AppearanceScreenCupertino(),
            ),
            GoRoute(
              path: "/settings/privacy_security",
              name: "settings_privacy_security",
              builder: (BuildContext context, GoRouterState state) => PrivacyAndSecurityScreenCupertino(),
              routes: <GoRoute>[
                GoRoute(
                  path: "/passcode",
                  name: "settings_privacy_security_passcode",
                  builder: (BuildContext context, GoRouterState state) => PasscodeScreenCupertino(),
                ),
              ],
            ),
            GoRoute(
              path: "/settings/language",
              name: "settings_language",
              builder: (BuildContext context, GoRouterState state) => LanguageScreenCupertino(),
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
        defaultLifecycleObserver,
      ],
      routes: <RouteBase>[
        GoRoute(
          path: "/",
          name: "index",
          builder: (BuildContext context, GoRouterState state) => HomeScreenMaterial(),
          redirect: (BuildContext context, GoRouterState state) async {
            final logger = getIt.get<Logger>();
            logger.debug("redirect!");
            return;
          },
          routes: [
            GoRoute(
              path: "/settings",
              name: "settings",
              builder: (BuildContext context, GoRouterState state) => SettingsScreenMaterial(),
              routes: [
                GoRoute(
                  path: "/language",
                  name: "settings_language",
                  builder: (BuildContext context, GoRouterState state) => LanguageScreenMaterial(),
                ),
                GoRoute(
                  path: "/appearance",
                  name: "settings_appearance",
                  builder: (BuildContext context, GoRouterState state) => AppearanceScreenMaterial(),
                ),
                GoRoute(
                  path: "/privacy_security",
                  name: "settings_privacy_security",
                  builder: (BuildContext context, GoRouterState state) => PrivacyAndSecurityScreenMaterial(),
                  routes: [
                    GoRoute(
                      path: "/passcode",
                      name: "settings_privacy_security_passcode",
                      builder: (BuildContext context, GoRouterState state) => PasscodeScreenMaterial(),
                      routes: [
                        GoRoute(
                          path: "/create",
                          name: "settings_privacy_security_passcode_create",
                          builder: (BuildContext context, GoRouterState state) => PasscodeScreenCreateMaterial(),
                        )
                      ]
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ]
    );
  }

}
