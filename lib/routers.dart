import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPage;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:messenger/i18n/translations.g.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'components.dart';
import 'cubit.dart';
import 'di.dart';
import 'logger.dart';
import 'repositories.dart';
import 'screens.dart';
import 'auth.dart';
import 'utils.dart';

class Routers {
  final logger = getIt.get<Logger>();
  final repositories = getIt.get<Repositories>();
  final auth = getIt.get<Auth>();

  final initialLocation = "/chats";

  // go_router определяет тип Page по типу App-виджета через
  // findAncestorWidgetOfExactType<CupertinoApp>() (из package:flutter).
  // Приложение обёрнуто в CupertinoApp из cupertino_ui — это другой тип,
  // поэтому автоопределение проваливается в NoTransitionPage (без свайпа
  // назад). Поэтому Page отдаём явно: FullSwipeBackPage — iOS-переход, и
  // экран закрывается свайпом вправо с любого места (как в Telegram), а не
  // только от края. [fullSwipe] = false — штатная CupertinoPage (жест только
  // от края): для экранов, где случайный свайп вредит (звонок).
  Page<void> _page(GoRouterState state, Widget child, {bool fullSwipe = true}) => fullSwipe
      ? FullSwipeBackPage<void>(key: state.pageKey, name: state.name ?? state.path, child: child)
      : CupertinoPage<void>(key: state.pageKey, name: state.name ?? state.path, child: child);

  // Тот же нюанс, что и с _page, но для Material: приложение обёрнуто в
  // MaterialApp из material_ui (не из package:flutter/material). Переход и
  // свайп — как на iOS (так выглядит и Telegram на Android), только короче.
  // [fullSwipe] = false — штатная MaterialPage (системный Android-переход).
  Page<void> _pageMaterial(GoRouterState state, Widget child, {bool fullSwipe = true}) => fullSwipe
      ? FullSwipeBackPage<void>(
          key: state.pageKey,
          name: state.name ?? state.path,
          transitionDuration: const Duration(milliseconds: 300),
          child: child,
        )
      : MaterialPage<void>(key: state.pageKey, name: state.name ?? state.path, child: child);

  /// Тип чатов из пути `/settings/notifications/:scope` (имя [NotifyScope]);
  /// неизвестное — личные чаты.
  NotifyScope _notifyScope(String? name) =>
      NotifyScope.values.firstWhere((scope) => scope.name == name, orElse: () => NotifyScope.privateChats);

  String? _redirect(BuildContext context, GoRouterState state) {
    final isAuthRoute = state.matchedLocation.startsWith("/auth");

    if (!auth.isAuthorized) {
      return isAuthRoute ? null : "/auth";
    }

    return isAuthRoute ? "/chats" : null;
  }

  List<RouteBase> _common(GlobalKey<NavigatorState> rootNavigatorKey) => <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => HomeCubit()..initialization()),
          // Статус соединения общий для всех вкладок — провайдим на уровне
          // shell, чтобы навбары любой вкладки могли его показать.
          BlocProvider<ConnectionCubit>(create: (_) => ConnectionCubit()..initialization()),
          // Контакты живут на уровне shell, чтобы к моменту открытия вкладки
          // список уже был показан из кэша и (при выданном доступе) освежён.
          BlocProvider<ContactsCubit>(create: (_) => ContactsCubit()..bootstrap()),
        ],
        child: CallGate(child: HomeCupertino(navigationShell: navigationShell)),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/contacts",
              builder: (_, _) => const ContactsCupertino(),
              routes: [
                GoRoute(
                  path: "add",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(state, const ContactsAddCupertino()),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/calls",
              builder: (_, _) => BlocProvider<CallsCubit>(create: (_) => CallsCubit()..initialization(), child: const CallsCupertino()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/chats",
              builder: (_, _) => BlocProvider<ChatsCubit>(
                create: (context) => ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
                child: const ChatsCupertino(),
              ),
              routes: [
                // «Архив» — полноэкранно поверх таб-бара. Свой ChatsCubit: данные
                // общие через источник (ChatsDemoDataSource — один на приложение).
                GoRoute(
                  path: "archive",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<ChatsCubit>(
                      create: (context) =>
                          ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo, archive: true),
                      child: const ChatsArchiveCupertino(),
                    ),
                  ),
                ),
                // Окно чата — полноэкранно поверх таб-бара (и из списка, и из «Архива»).
                GoRoute(
                  path: "chat/:id",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<ChatCubit>(
                      create: (context) => ChatCubit()
                        ..initialization(
                          chatID: state.pathParameters['id']!,
                          demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                        ),
                      child: const ChatCupertino(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/settings",
              builder: (_, _) =>
                  BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()..initialization(), child: const SettingsCupertino()),
              routes: [
                // Вложенные пути (/settings/language, /settings/appearance),
                // но parentNavigatorKey отправляет их на корневой навигатор —
                // экран открывается на весь экран, без нижнего таб-бара.

                GoRoute(
                  path: "profile",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsMyProfileCubit>(
                      create: (_) =>
                          SettingsMyProfileCubit()
                            ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                      child: SettingsMyProfileCupertino(),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: "edit",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsMyProfileEditCubit>(
                          create: (_) =>
                              SettingsMyProfileEditCubit()
                                ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                          child: SettingsMyProfileEditCupertino(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: "username",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsMyProfileUsernameCubit>(
                          create: (_) =>
                              SettingsMyProfileUsernameCubit()
                                ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                          child: SettingsMyProfileUsernameCupertino(),
                        ),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: "notifications",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsNotificationsCubit>(
                      create: (_) => SettingsNotificationsCubit()..initialization(),
                      child: const SettingsNotificationsCupertino(),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: ":scope",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsNotificationsCubit>(
                          create: (_) => SettingsNotificationsCubit()..initialization(),
                          child: SettingsNotificationsScopeCupertino(scope: _notifyScope(state.pathParameters["scope"])),
                        ),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: "privacy_and_security",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                      child: SettingsPrivacyAndSecurityCupertino(),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: "calls",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsPrivacyAndSecurityCubit>(
                          create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                          child: const SettingsPrivacyCallsCupertino(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "allow",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowCupertino(
                                kind: CallsListKind.allow,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                        GoRoute(
                          path: "deny",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowCupertino(
                                kind: CallsListKind.deny,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "birthday",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsPrivacyAndSecurityCubit>(
                          create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                          child: const SettingsPrivacyBirthdayCupertino(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "allow",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowCupertino(
                                kind: CallsListKind.allow,
                                channel: PrivacyChannel.birthday,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                        GoRoute(
                          path: "deny",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowCupertino(
                                kind: CallsListKind.deny,
                                channel: PrivacyChannel.birthday,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "about_me",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsPrivacyAndSecurityCubit>(
                          create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                          child: const SettingsPrivacyAboutMeCupertino(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "allow",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowCupertino(
                                kind: CallsListKind.allow,
                                channel: PrivacyChannel.aboutMe,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                        GoRoute(
                          path: "deny",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowCupertino(
                                kind: CallsListKind.deny,
                                channel: PrivacyChannel.aboutMe,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "last_seen",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsPrivacyAndSecurityCubit>(
                          create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                          child: const SettingsPrivacyLastSeenCupertino(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "allow",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowCupertino(
                                kind: CallsListKind.allow,
                                channel: PrivacyChannel.lastSeen,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                        GoRoute(
                          path: "deny",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _page(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowCupertino(
                                kind: CallsListKind.deny,
                                channel: PrivacyChannel.lastSeen,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "passcode",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsPasscodeCubit>(
                          create: (_) => SettingsPasscodeCubit()..initialization(),
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
                              create: (_) => SettingsPasscodeCreateCubit()..initialization(),
                              child: SettingsPasscodeCreateCupertino(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "cloud_password",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsCloudPasswordCubit>(
                          create: (_) => SettingsCloudPasswordCubit()..initialization(),
                          child: SettingsCloudPasswordCupertino(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: "passkeys",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(
                        state,
                        BlocProvider<SettingsPasskeysCubit>(
                          create: (_) => SettingsPasskeysCubit()..initialization(),
                          child: SettingsPasskeysCupertino(),
                        ),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  // Скрытый раздел «Разработчик» (открывается 5 тапами по вкладке
                  // «Настройки», см. HomeCupertino). Логи теперь живут здесь.
                  path: "developer",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(state, const SettingsDeveloperCupertino()),
                  routes: [
                    GoRoute(
                      path: "logs",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(state, TalkerScreen(talker: logger.talker)),
                    ),
                    // DEBUG-only превью экрана звонка без реального звонка.
                    if (kDebugMode)
                      GoRoute(
                        path: "call_preview",
                        parentNavigatorKey: rootNavigatorKey,
                        pageBuilder: (context, state) => _page(state, const CallPreview()),
                      ),
                  ],
                ),
                GoRoute(
                  path: "language",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsLanguageCubit>(
                      create: (_) =>
                          SettingsLanguageCubit()..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale),
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
                      create: (_) => SettingsAppearanceCubit()
                        ..initialization(
                          colorTheme: context.read<CommonCubit>().state.settingsDevice.colorTheme,
                          darkMode: context.read<CommonCubit>().state.settingsDevice.darkMode,
                          isBlurOnInactive: context.read<CommonCubit>().state.settingsDevice.isBlurOnInactive,
                        ),
                      child: SettingsAppearanceCupertino(),
                    ),
                  ),
                  routes: [
                    // Темы для чатов — обои окна чата.
                    GoRoute(
                      path: "chat_themes",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _page(state, const SettingsChatThemesCupertino()),
                    ),
                  ],
                ),
                GoRoute(
                  path: "device_sessions",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _page(
                    state,
                    BlocProvider<SettingsDeviceSessionsCubit>(
                      create: (_) => SettingsDeviceSessionsCubit()..initialization(),
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
      path: "/call",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _page(
        state,
        BlocProvider<CallCubit>(create: (_) => CallCubit()..initialization(), child: const CallCupertino()),
        fullSwipe: false,
      ),
    ),
    GoRoute(
      path: "/profile/:userID",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _page(
        state,
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit()
            ..initialization(
              userID: getIt.get<Utils>().hexToBytes(state.pathParameters['userID'] ?? ''),
              locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en,
            ),
          child: const ProfileCupertino(),
        ),
      ),
      routes: [
        GoRoute(
          path: "hide",
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => _page(
            state,
            BlocProvider<ProfileHideCubit>(
              create: (_) =>
                  ProfileHideCubit(userID: getIt.get<Utils>().hexToBytes(state.pathParameters['userID'] ?? ''))..initialization(),
              child: const ProfileHideCupertino(),
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: "/auth",
      builder: (_, _) => BlocProvider<AuthCubit>(create: (_) => AuthCubit()..initialization(), child: AuthCupertinoScreen()),
      routes: [
        GoRoute(
          path: "/call_password_confirmation",
          pageBuilder: (context, state) {
            final callPasswordSession = state.uri.queryParameters["callPasswordSession"] ?? "";
            final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"] ?? "";
            final timeout = state.uri.queryParameters["timeout"] ?? "";

            if (callPasswordSession.isEmpty || confirmationPhoneNumber.isEmpty || timeout.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _page(state, Container());
            }

            return _page(
              state,
              BlocProvider<AuthCallpasswordConfirmationCubit>(
                create: (_) => AuthCallpasswordConfirmationCubit()
                  ..initialization(
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
            final moderationApplicationStoreSession = state.uri.queryParameters["moderationApplicationStoreSession"] ?? "";
            final phoneNumber = state.uri.queryParameters["phoneNumber"] ?? "";

            if (moderationApplicationStoreSession.isEmpty || phoneNumber.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _page(state, Container());
            }

            return _page(
              state,
              BlocProvider<AuthModerationApplicationStoreCubit>(
                create: (_) =>
                    AuthModerationApplicationStoreCubit()
                      ..initialization(phoneNumber: phoneNumber, moderationApplicationStoreSession: moderationApplicationStoreSession),
                child: AuthModerationApplicationStoreCupertino(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/cloud_password",
          pageBuilder: (context, state) {
            final confirmationSession = state.uri.queryParameters["confirmationSession"] ?? "";

            if (confirmationSession.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _page(state, Container());
            }

            return _page(
              state,
              BlocProvider<AuthCloudPasswordCubit>(
                create: (_) => AuthCloudPasswordCubit()..initialization(confirmationSession: confirmationSession),
                child: AuthCloudPasswordCupertino(),
              ),
            );
          },
        ),
      ],
    ),
  ];

  List<RouteBase> get _cupertino => <RouteBase>[];

  // Material-аналог _common: тот же StatefulShellRoute с нижней навигацией, но
  // рендерит Material-экраны. Портированы все вкладки и вся ветка /auth.
  List<RouteBase> _commonMaterial(GlobalKey<NavigatorState> rootNavigatorKey) => <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => HomeCubit()..initialization()),
          BlocProvider<ConnectionCubit>(create: (_) => ConnectionCubit()..initialization()),
          // Контакты живут на уровне shell, чтобы к моменту открытия вкладки
          // список уже был показан из кэша и (при выданном доступе) освежён.
          BlocProvider<ContactsCubit>(create: (_) => ContactsCubit()..bootstrap()),
        ],
        child: CallGate(child: HomeMaterial(navigationShell: navigationShell)),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/contacts",
              builder: (_, _) => const ContactsMaterial(),
              routes: [
                GoRoute(
                  path: "add",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(state, const ContactsAddMaterial()),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/calls",
              builder: (_, _) => BlocProvider<CallsCubit>(create: (_) => CallsCubit()..initialization(), child: const CallsMaterial()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/chats",
              builder: (_, _) => BlocProvider<ChatsCubit>(
                create: (context) => ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo),
                child: const ChatsMaterial(),
              ),
              routes: [
                // «Архив» — полноэкранно поверх таб-бара. Свой ChatsCubit: данные
                // общие через источник (ChatsDemoDataSource — один на приложение).
                GoRoute(
                  path: "archive",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<ChatsCubit>(
                      create: (context) =>
                          ChatsCubit()..initialization(demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo, archive: true),
                      child: const ChatsArchiveMaterial(),
                    ),
                  ),
                ),
                // Окно чата — полноэкранно поверх таб-бара (и из списка, и из «Архива»).
                GoRoute(
                  path: "chat/:id",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<ChatCubit>(
                      create: (context) => ChatCubit()
                        ..initialization(
                          chatID: state.pathParameters['id']!,
                          demo: context.read<CommonCubit>().state.settingsDevice.chatsDemo,
                        ),
                      child: const ChatMaterial(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/settings",
              builder: (_, _) =>
                  BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()..initialization(), child: const SettingsMaterial()),
              routes: [
                GoRoute(
                  path: "profile",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsMyProfileCubit>(
                      create: (_) =>
                          SettingsMyProfileCubit()
                            ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                      child: const SettingsMyProfileMaterial(),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: "edit",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsMyProfileEditCubit>(
                          create: (_) =>
                              SettingsMyProfileEditCubit()
                                ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                          child: const SettingsMyProfileEditMaterial(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: "username",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsMyProfileUsernameCubit>(
                          create: (_) =>
                              SettingsMyProfileUsernameCubit()
                                ..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en),
                          child: const SettingsMyProfileUsernameMaterial(),
                        ),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: "notifications",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsNotificationsCubit>(
                      create: (_) => SettingsNotificationsCubit()..initialization(),
                      child: const SettingsNotificationsMaterial(),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: ":scope",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsNotificationsCubit>(
                          create: (_) => SettingsNotificationsCubit()..initialization(),
                          child: SettingsNotificationsScopeMaterial(scope: _notifyScope(state.pathParameters["scope"])),
                        ),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: "privacy_and_security",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsPrivacyAndSecurityCubit>(
                      create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                      child: const SettingsPrivacyAndSecurityMaterial(),
                    ),
                  ),
                  routes: [
                    GoRoute(
                      path: "calls",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsPrivacyAndSecurityCubit>(
                          create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                          child: const SettingsPrivacyCallsMaterial(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "allow",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowMaterial(
                                kind: CallsListKind.allow,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                        GoRoute(
                          path: "deny",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowMaterial(
                                kind: CallsListKind.deny,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "birthday",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsPrivacyAndSecurityCubit>(
                          create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                          child: const SettingsPrivacyBirthdayMaterial(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "allow",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowMaterial(
                                kind: CallsListKind.allow,
                                channel: PrivacyChannel.birthday,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                        GoRoute(
                          path: "deny",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowMaterial(
                                kind: CallsListKind.deny,
                                channel: PrivacyChannel.birthday,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "about_me",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsPrivacyAndSecurityCubit>(
                          create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                          child: const SettingsPrivacyAboutMeMaterial(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "allow",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowMaterial(
                                kind: CallsListKind.allow,
                                channel: PrivacyChannel.aboutMe,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                        GoRoute(
                          path: "deny",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowMaterial(
                                kind: CallsListKind.deny,
                                channel: PrivacyChannel.aboutMe,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "last_seen",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsPrivacyAndSecurityCubit>(
                          create: (_) => SettingsPrivacyAndSecurityCubit()..initialization(),
                          child: const SettingsPrivacyLastSeenMaterial(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "allow",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowMaterial(
                                kind: CallsListKind.allow,
                                channel: PrivacyChannel.lastSeen,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                        GoRoute(
                          path: "deny",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPrivacyAndSecurityCubit>(
                              create: (_) => SettingsPrivacyAndSecurityCubit(),
                              child: SettingsPrivacyCallsAllowMaterial(
                                kind: CallsListKind.deny,
                                channel: PrivacyChannel.lastSeen,
                                initialSelected: (state.extra as List<Uint8List>?) ?? const [],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "passcode",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsPasscodeCubit>(
                          create: (_) => SettingsPasscodeCubit()..initialization(),
                          child: const SettingsPasscodeMaterial(),
                        ),
                      ),
                      routes: [
                        GoRoute(
                          path: "create",
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) => _pageMaterial(
                            state,
                            BlocProvider<SettingsPasscodeCreateCubit>(
                              create: (_) => SettingsPasscodeCreateCubit()..initialization(),
                              child: const SettingsPasscodeCreateMaterial(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: "cloud_password",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsCloudPasswordCubit>(
                          create: (_) => SettingsCloudPasswordCubit()..initialization(),
                          child: const SettingsCloudPasswordMaterial(),
                        ),
                      ),
                    ),
                    GoRoute(
                      path: "passkeys",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(
                        state,
                        BlocProvider<SettingsPasskeysCubit>(
                          create: (_) => SettingsPasskeysCubit()..initialization(),
                          child: const SettingsPasskeysMaterial(),
                        ),
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  // Скрытый раздел «Разработчик» (открывается 5 тапами по вкладке
                  // «Настройки», см. HomeMaterial). Логи теперь живут здесь.
                  path: "developer",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(state, const SettingsDeveloperMaterial()),
                  routes: [
                    GoRoute(
                      path: "logs",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(state, TalkerScreen(talker: logger.talker)),
                    ),
                    // DEBUG-only превью экрана звонка без реального звонка.
                    if (kDebugMode)
                      GoRoute(
                        path: "call_preview",
                        parentNavigatorKey: rootNavigatorKey,
                        pageBuilder: (context, state) => _pageMaterial(state, const CallPreview()),
                      ),
                  ],
                ),
                GoRoute(
                  path: "language",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsLanguageCubit>(
                      create: (_) =>
                          SettingsLanguageCubit()..initialization(locale: context.read<CommonCubit>().state.settingsDevice.locale),
                      child: const SettingsLanguageMaterialScreen(),
                    ),
                  ),
                ),
                GoRoute(
                  path: "appearance",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsAppearanceCubit>(
                      create: (_) => SettingsAppearanceCubit()
                        ..initialization(
                          colorTheme: context.read<CommonCubit>().state.settingsDevice.colorTheme,
                          darkMode: context.read<CommonCubit>().state.settingsDevice.darkMode,
                          isBlurOnInactive: context.read<CommonCubit>().state.settingsDevice.isBlurOnInactive,
                        ),
                      child: const SettingsAppearanceMaterial(),
                    ),
                  ),
                  routes: [
                    // Темы для чатов — обои окна чата.
                    GoRoute(
                      path: "chat_themes",
                      parentNavigatorKey: rootNavigatorKey,
                      pageBuilder: (context, state) => _pageMaterial(state, const SettingsChatThemesMaterial()),
                    ),
                  ],
                ),
                GoRoute(
                  path: "device_sessions",
                  parentNavigatorKey: rootNavigatorKey,
                  pageBuilder: (context, state) => _pageMaterial(
                    state,
                    BlocProvider<SettingsDeviceSessionsCubit>(
                      create: (_) => SettingsDeviceSessionsCubit()..initialization(),
                      child: const SettingsDeviceSessionsMaterial(),
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
      path: "/call",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _pageMaterial(
        state,
        BlocProvider<CallCubit>(create: (_) => CallCubit()..initialization(), child: const CallMaterial()),
        fullSwipe: false,
      ),
    ),
    GoRoute(
      path: "/profile/:userID",
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _pageMaterial(
        state,
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit()
            ..initialization(
              userID: getIt.get<Utils>().hexToBytes(state.pathParameters['userID'] ?? ''),
              locale: context.read<CommonCubit>().state.settingsDevice.locale ?? AppLocale.en,
            ),
          child: const ProfileMaterial(),
        ),
      ),
      routes: [
        GoRoute(
          path: "hide",
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state) => _pageMaterial(
            state,
            BlocProvider<ProfileHideCubit>(
              create: (_) =>
                  ProfileHideCubit(userID: getIt.get<Utils>().hexToBytes(state.pathParameters['userID'] ?? ''))..initialization(),
              child: const ProfileHideMaterial(),
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: "/auth",
      builder: (_, _) => BlocProvider<AuthCubit>(create: (_) => AuthCubit()..initialization(), child: const AuthMaterialScreen()),
      routes: [
        GoRoute(
          path: "/call_password_confirmation",
          pageBuilder: (context, state) {
            final callPasswordSession = state.uri.queryParameters["callPasswordSession"] ?? "";
            final confirmationPhoneNumber = state.uri.queryParameters["confirmationPhoneNumber"] ?? "";
            final timeout = state.uri.queryParameters["timeout"] ?? "";

            if (callPasswordSession.isEmpty || confirmationPhoneNumber.isEmpty || timeout.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _pageMaterial(state, const SizedBox.shrink());
            }

            return _pageMaterial(
              state,
              BlocProvider<AuthCallpasswordConfirmationCubit>(
                create: (_) => AuthCallpasswordConfirmationCubit()
                  ..initialization(
                    callPasswordSession: callPasswordSession,
                    confirmationPhoneNumber: confirmationPhoneNumber,
                    timeout: timeout,
                  ),
                child: const AuthCallpasswordConfirmationMaterial(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/moderation_application_store",
          pageBuilder: (context, state) {
            final moderationApplicationStoreSession = state.uri.queryParameters["moderationApplicationStoreSession"] ?? "";
            final phoneNumber = state.uri.queryParameters["phoneNumber"] ?? "";

            if (moderationApplicationStoreSession.isEmpty || phoneNumber.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _pageMaterial(state, const SizedBox.shrink());
            }

            return _pageMaterial(
              state,
              BlocProvider<AuthModerationApplicationStoreCubit>(
                create: (_) =>
                    AuthModerationApplicationStoreCubit()
                      ..initialization(phoneNumber: phoneNumber, moderationApplicationStoreSession: moderationApplicationStoreSession),
                child: const AuthModerationApplicationStoreMaterial(),
              ),
            );
          },
        ),
        GoRoute(
          path: "/cloud_password",
          pageBuilder: (context, state) {
            final confirmationSession = state.uri.queryParameters["confirmationSession"] ?? "";

            if (confirmationSession.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) context.go("/auth");
              });
              return _pageMaterial(state, const SizedBox.shrink());
            }

            return _pageMaterial(
              state,
              BlocProvider<AuthCloudPasswordCubit>(
                create: (_) => AuthCloudPasswordCubit()..initialization(confirmationSession: confirmationSession),
                child: const AuthCloudPasswordMaterial(),
              ),
            );
          },
        ),
      ],
    ),
  ];

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
      routes: [..._commonMaterial(navigatorGoRouterKey)],
    );
  }
}
