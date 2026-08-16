import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'cubit.dart';
import 'di.dart';
import 'logger.dart';
import 'repositories.dart';
import 'screens.dart';
import 'auth.dart';

class Routers {
  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();
  final auth = getIt.get<Auth>();

  final initialLocation = "/chats";

  // go_router определяет тип Page по типу App-виджета через
  // findAncestorWidgetOfExactType<CupertinoApp>() (из package:flutter).
  // Приложение обёрнуто в CupertinoApp из cupertino_ui — это другой тип,
  // поэтому автоопределение проваливается в NoTransitionPage (без свайпа
  // назад). Явно отдаём CupertinoPage из cupertino_ui, чтобы вернуть
  // iOS-переход и жест «назад».
  Page<void> _page(GoRouterState state, Widget child) => CupertinoPage<void>(
    key: state.pageKey,
    name: state.name ?? state.path,
    child: child,
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final isAuthRoute = state.matchedLocation.startsWith("/auth");

    if (!auth.isAuthorized) {
      return isAuthRoute ? null : "/auth";
    }

    return isAuthRoute ? "/chats" : null;
  }

  List<RouteBase> _common(
    GlobalKey<NavigatorState> rootNavigatorKey,
  ) => <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => HomeCubit()..initialization()),
          // Статус соединения общий для всех вкладок — провайдим на уровне
          // shell, чтобы навбары любой вкладки могли его показать.
          BlocProvider<ConnectionCubit>(
            create: (_) => ConnectionCubit()..initialization(),
          ),
        ],
        child: HomeCupertino(navigationShell: navigationShell),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/contacts",
              builder: (_, _) => const ContactsCupertino(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: "/calls", builder: (_, _) => const CallsCupertino()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/chats",
              builder: (_, _) => BlocProvider<ChatsCubit>(
                create: (_) => ChatsCubit()..initialization(),
                child: const ChatsCupertino(),
              ),
              // builder: (_, _) => const ChatsCupertino()
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/settings",
              builder: (_, _) => BlocProvider<SettingsCubit>(
                create: (_) => SettingsCubit()..initialization(),
                child: const SettingsCupertino(),
              ),
              routes: [
                // Вложенные пути (/settings/language, /settings/appearance),
                // но parentNavigatorKey отправляет их на корневой навигатор —
                // экран открывается на весь экран, без нижнего таб-бара.
                GoRoute(
                  path: "privacy_and_security",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) =>
                          SettingsPrivacyAndSecurityCubit()..initialization(),
                      child: SettingsPrivacyAndSecurityCupertino(),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: "passcode",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsPasscodeCubit>(
                          create: (_) =>
                              SettingsPasscodeCubit()..initialization(),
                          child: SettingsPasscodeCupertino(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "create",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPasscodeCreateCubit>(
                              create: (_) =>
                                  SettingsPasscodeCreateCubit()
                                    ..initialization(),
                              child: SettingsPasscodeCreateCupertino(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: "language",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsLanguageCubit>(
                      create: (_) => SettingsLanguageCubit()
                        ..initialization(
                          locale: context
                              .read<CommonCubit>()
                              .state
                              .settingsDevice
                              .locale,
                        ),
                      child: SettingsLanguageCupertinoScreen(),
                    ),
                  ),
                ),
                GoRoute(
                  path: "appearance",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsAppearanceCubit>(
                      create: (_) =>
                      SettingsAppearanceCubit()
                        ..initialization(
                          colorTheme: context
                              .read<CommonCubit>()
                              .state
                              .settingsDevice
                              .colorTheme,
                          darkMode: context
                              .read<CommonCubit>()
                              .state
                              .settingsDevice
                              .darkMode,
                          isBlurOnInactive: context
                              .read<CommonCubit>()
                              .state
                              .settingsDevice
                              .isBlurOnInactive,
                        ),
                      child: SettingsAppearanceCupertino(),
                    ),
                  ),
                ),
                GoRoute(
                  path: "device_sessions",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsDeviceSessionsCubit>(
                      create: (_) =>
                          SettingsDeviceSessionsCubit()..initialization(),
                      child: SettingsDeviceSessionsCupertino(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: "/auth",
      builder: (_, _) => BlocProvider<AuthCubit>(
        create: (_) => AuthCubit()..initialization(),
        child: AuthCupertinoScreen(),
      ),
      routes: [
        GoRoute(
          path: "/call_password_confirmation",
          pageBuilder: (context, state) {
            final callPasswordSession =
                state.uri.queryParameters["callPasswordSession"] ?? "";
            final confirmationPhoneNumber =
                state.uri.queryParameters["confirmationPhoneNumber"] ?? "";
            final timeout = state.uri.queryParameters["timeout"] ?? "";

            if (callPasswordSession.isEmpty ||
                confirmationPhoneNumber.isEmpty ||
                timeout.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _page(state, Container());
            }

            return _page(
              state,
              BlocProvider<AuthCallpasswordConfirmationCubit>(
                create: (_) =>
                    AuthCallpasswordConfirmationCubit()..initialization(
                      callPasswordSession: callPasswordSession,
                      confirmationPhoneNumber: confirmationPhoneNumber,
                      timeout: timeout,
                    ),
                child: AuthCallpasswordConfirmationCupertino(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/moderation_application_store",
          pageBuilder: (context, state) {
            final moderationApplicationStoreSession =
                state
                    .uri
                    .queryParameters["moderationApplicationStoreSession"] ??
                "";
            final phoneNumber = state.uri.queryParameters["phoneNumber"] ?? "";

            if (moderationApplicationStoreSession.isEmpty ||
                phoneNumber.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _page(state, Container());
            }

            return _page(
              state,
              BlocProvider<AuthModerationApplicationStoreCubit>(
                create: (_) =>
                    AuthModerationApplicationStoreCubit()..initialization(
                      phoneNumber: phoneNumber,
                      moderationApplicationStoreSession:
                          moderationApplicationStoreSession,
                    ),
                child: AuthModerationApplicationStoreCupertino(),
              ),
            );
          },
        ),
      ],
    ),
  ];

  List<RouteBase> get _cupertino => <RouteBase>[];

  List<RouteBase> get _material => <RouteBase>[];

  GoRouter cupertino(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      observers: [TalkerRouteObserver(logger.talker)],
      navigatorKey: navigatorGoRouterKey,
      initialLocation: initialLocation,
      redirect: _redirect,
      refreshListenable: auth,
      routes: [..._common(navigatorGoRouterKey), ..._cupertino],
    );
  }

  GoRouter material(GlobalKey<NavigatorState> navigatorGoRouterKey) {
    return GoRouter(
      debugLogDiagnostics: kDebugMode,
      navigatorKey: navigatorGoRouterKey,
      initialLocation: initialLocation,
      redirect: _redirect,
      refreshListenable: auth,
      routes: [..._common(navigatorGoRouterKey), ..._material],
    );
  }
}
