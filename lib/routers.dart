import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'di.dart';
import 'logger.dart';
import 'screens/screens.dart';

class Routers {
  final logger = getIt.get<Logger>();

  GoRouter material(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode ? true: false,
      navigatorKey: navigatorGoRouterKey,
      initialLocation: '/auth',
      routes: <RouteBase>[
        GoRoute(
          path: '/auth',
          pageBuilder: (_, _) {
            return MaterialPage(
              child: AuthMaterialScreen(),
              maintainState: false,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/callpassword',
              pageBuilder: (BuildContext context, state) {
                final callPasswordSession = state.uri.queryParameters["callPasswordSession"];
                final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"];
                final timeout = double.parse(state.uri.queryParameters["timeout"] ?? "0");

                if (callPasswordSession != null && confirmationPhoneNumber != null && timeout > 0) {
                  return MaterialPage(
                    child: AuthCallPasswordMaterialScreen(
                      callPasswordSession: callPasswordSession,
                      confirmationPhoneNumber: confirmationPhoneNumber,
                      timeout: timeout,
                    ),
                    maintainState: false,
                  );
                }

                if (context.mounted) context.go("/auth");
                return MaterialPage(child: Container());
              },
            ),
            GoRoute(
              path: "/confirmation",
              pageBuilder: (BuildContext context, state) {
                final confirmationSession = state.uri.queryParameters["confirmationSession"] ?? "";

                return MaterialPage(
                  child: AuthConfirmationMaterialScreen(confirmationSession: confirmationSession),
                  maintainState: false,
                );
              },
              // builder: (BuildContext context, state) {
              //   final confirmationSession = state.uri.queryParameters["confirmationSession"] ?? "";
              //   return AuthConfirmationMaterialScreen(confirmationSession: confirmationSession);
              // },
            ),
          ],
        ),
      ]
    );
  }

  GoRouter cupertino(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
        debugLogDiagnostics: kDebugMode ? true: false,
        navigatorKey: navigatorGoRouterKey,
        initialLocation: '/auth',
        routes: <RouteBase>[
          GoRoute(
            path: '/auth',
            builder: (_, _) => AuthCupertinoScreen(),
            routes: [
              GoRoute(
                path: '/callpassword',
                pageBuilder: (BuildContext context, state) {
                  final callPasswordSession = state.uri.queryParameters["callPasswordSession"];
                  final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"];
                  final timeout = double.parse(state.uri.queryParameters["timeout"] ?? "0");

                  if (callPasswordSession != null && confirmationPhoneNumber != null && timeout > 0) {
                    return MaterialPage(
                      child: AuthCallPasswordMaterialScreen(
                        callPasswordSession: callPasswordSession,
                        confirmationPhoneNumber: confirmationPhoneNumber,
                        timeout: timeout,
                      ),
                      maintainState: false,
                    );
                  }

                  if (context.mounted) context.go("/auth");
                  return MaterialPage(child: Container());
                },
              ),
            ],
          ),
        ]
    );
  }

}





// logger.debug("111111");
// context.go("/auth");
// return Container();
