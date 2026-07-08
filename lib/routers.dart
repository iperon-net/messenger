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
import 'cubit/main_cubit.dart';
import 'cubit/settings/settings_appearance_cubit.dart';
import 'cubit/settings/settings_cubit.dart';
import 'cubit/settings/settings_device_sessions_cubit.dart';
import 'cubit/settings/settings_language_cubit.dart';
import 'cubit/settings/settings_private_and_security_cubit.dart';
import 'cubit/settings/settings_two_step_verification_cubit.dart';
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
            routes: [
              ShellRoute(
                builder: (context, state, child) => BlocProvider(
                  create: (_) => SettingsCubit(),
                  child: child,
                ),
                routes: [
                  GoRoute(
                    path: '/settings',
                    builder: (_, _) => SettingsCupertinoScreen(),
                    routes: [
                      GoRoute(
                        path: '/language',
                        builder: (_, _) => BlocProvider(
                          create: (BuildContext context) {
                            final locate = context.read<MainCubit>().state.settingsDevice.locale;
                            if (locate != null) return SettingsLanguageCubit()..initialization(locale: locate);
                            return SettingsLanguageCubit();
                          },
                          child: SettingsLanguageScreenCupertino(),
                        ),
                      ),
                      GoRoute(
                        path: '/appearance',
                        builder: (_, _) => BlocProvider(
                          create: (_) => SettingsAppearanceCubit(),
                          child: SettingsAppearanceScreenCupertino(),
                        ),
                      ),
                      GoRoute(
                        path: '/device_sessions',
                        builder: (_, _) => BlocProvider<SettingsDeviceSessionsCubit>(
                          create: (_) => SettingsDeviceSessionsCubit()..initialization(),
                          child: SettingsDeviceSessionsScreenCupertino(),
                        ),
                      ),
                      GoRoute(
                        path: '/private_and_security',
                        builder: (_, _) => BlocProvider<SettingsPrivateAndSecurityCubit>(
                          create: (_) => SettingsPrivateAndSecurityCubit(),
                          child: SettingsPrivateAndSecurityScreenCupertino(),
                        ),
                       routes: [
                         ShellRoute(
                           builder: (context, state, child) => BlocProvider(
                             create: (_) => SettingsTwoStepVerificationCubit(),
                             child: child,
                           ),
                           routes: [
                             GoRoute(
                               path: '/settings_two_step_verification',
                               builder: (_, _) => SettingsTwoStepVerificationScreenCupertino(),
                               routes: [
                                 GoRoute(
                                   path: '/new_email',
                                   builder: (_, _) => SettingsTwoStepVerificationNewEmailScreenCupertino(),
                                   routes: [
                                     GoRoute(
                                       path: '/email_code',
                                       builder: (_, _) => SettingsTwoStepVerificationCodeScreenCupertino(),
                                     ),
                                   ]
                                 ),
                               ]
                             ),
                           ]
                         ),
                       ]
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // ShellRoute(
          //   builder: (context, state, child) => BlocProvider(
          //     create: (_) => SettingsCubit(),
          //     child: child,
          //   ),
          //   routes: [
          //
          //   ],
          // ),
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
