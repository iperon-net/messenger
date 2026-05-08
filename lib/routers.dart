import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/cubit/main_cubit.dart';

import 'di.dart';
import 'logger.dart';
import 'screens/screens.dart';

class Routers {
  final logger = getIt.get<Logger>();

  GoRouter material(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode ? true: false,
      navigatorKey: navigatorGoRouterKey,
      initialLocation: '/',
      redirect: (context, state) {

        Uri uri = Uri.parse(state.fullPath ?? "/");
        if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == "auth") return null;
        if (context.watch<MainCubit>().state.user.userID.isEmpty) return "/auth";

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (_, _) => HomeMaterialScreen(),
        ),
        GoRoute(
          path: '/auth',
          builder: (_, _) => AuthMaterialScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: '/callpassword',
              builder: (context, state) {
                final callPasswordSession = state.uri.queryParameters["callPasswordSession"];
                final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"];
                final timeout = double.parse(state.uri.queryParameters["timeout"] ?? "0");

                if (callPasswordSession != null && confirmationPhoneNumber != null && timeout > 0) {
                  return AuthCallPasswordMaterialScreen(
                    callPasswordSession: callPasswordSession,
                    confirmationPhoneNumber: confirmationPhoneNumber,
                    timeout: timeout,
                  );
                }

                if (context.mounted) context.go("/auth");
                return Container();
              },
            ),
            GoRoute(
              path: "/confirmation",
              builder: (context, state) {
                final confirmationSession = state.uri.queryParameters["confirmationSession"] ?? "";
                return AuthConfirmationMaterialScreen(confirmationSession: confirmationSession);
              },
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
                builder: (context, state) {
                  final callPasswordSession = state.uri.queryParameters["callPasswordSession"];
                  final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"];
                  final timeout = double.parse(state.uri.queryParameters["timeout"] ?? "0");

                  if (callPasswordSession != null && confirmationPhoneNumber != null && timeout > 0) {
                    return AuthCallPasswordMaterialScreen(
                      callPasswordSession: callPasswordSession,
                      confirmationPhoneNumber: confirmationPhoneNumber,
                      timeout: timeout,
                    );
                  }

                  if (context.mounted) context.go("/auth");
                  return Container();
                },
              ),
            ],
          ),
        ]
    );
  }

}
