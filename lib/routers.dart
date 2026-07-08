import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/repositories/repositories.dart';

import 'cubit/auth/auth_callpassword_cubit.dart';
import 'cubit/auth/auth_cubit.dart';
import 'cubit/auth/auth_sms_cubit.dart';
import 'di.dart';
import 'logger.dart';
import 'screens.dart';

class Routers {
  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();

  GoRouter material(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode ? true: false,
      navigatorKey: navigatorGoRouterKey,
      initialLocation: '/',
      redirect: (context, state) async {

        Uri uri = Uri.parse(state.fullPath ?? "/");
        if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == "auth") return null;

        final session = await repositories.sessions.getActive();
        if (!session.isActive) return "/auth";

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
                  return BlocProvider(
                    create: (_) => AuthCallpasswordCubit(),
                    child: AuthCallPasswordMaterialScreen(
                      callPasswordSession: callPasswordSession,
                      confirmationPhoneNumber: confirmationPhoneNumber,
                      timeout: timeout,
                    ),
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

  GoRouter cupertino(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
        debugLogDiagnostics: kDebugMode ? true: false,
        navigatorKey: navigatorGoRouterKey,
        initialLocation: '/',
        redirect: (context, state) async {

          Uri uri = Uri.parse(state.fullPath ?? "/");
          if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == "auth") return null;

          final session = await repositories.sessions.getActive();
          if (!session.isActive) return "/auth";

          return null;
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (_, _) => HomeCupertinoScreen(),
          ),
          GoRoute(
            path: '/auth',
            builder: (_, _) => BlocProvider<AuthCubit>(
              create: (_) => AuthCubit(),
              child: AuthCupertinoScreen(),
            ),
            routes: [
              GoRoute(
                path: "/sms",
                builder: (context, state) {
                  final smsSession = state.uri.queryParameters["smsSession"];
                  final phoneNumber = state.uri.queryParameters["phoneNumber"];
                  if (smsSession != null && phoneNumber != null) {
                    return BlocProvider(
                      create: (_) => AuthSmsCubit(),
                      child: AuthSmsScreenCupertino(smsSession: smsSession, phoneNumber: phoneNumber),
                    );
                  }

                  if (context.mounted) context.go("/auth");
                  return Container();
                },
              ),
              GoRoute(
                path: '/callpassword',
                builder: (context, state) {
                  final callPasswordSession = state.uri.queryParameters["callPasswordSession"];
                  final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"];
                  final timeout = double.parse(state.uri.queryParameters["timeout"] ?? "0");

                  if (callPasswordSession != null && confirmationPhoneNumber != null && timeout > 0) {
                    return BlocProvider(
                      create: (_) => AuthCallpasswordCubit(),
                      child: AuthCallPasswordCupertinoScreen(
                        callPasswordSession: callPasswordSession,
                        confirmationPhoneNumber: confirmationPhoneNumber,
                        timeout: timeout,
                      ),
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
